import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';

import 'm3e_dismissible_card_style.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spring presets (Material 3 Expressive via motor)
// ─────────────────────────────────────────────────────────────────────────────

final _kSpatialSpring = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 380, damping: 0.6);

final _kSpatialSpringBack = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 200, damping: 0.8);

final _kFlySpring = MaterialSpringMotion.expressiveSpatialSlow();

final _kReEngageSpring = MaterialSpringMotion.standardSpatialFast();

final _kDetachPush = MaterialSpringMotion.expressiveSpatialDefault().copyWith(
  stiffness: 800,
  damping: 0.95,
);

final _kRoundnessSnap = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 1000, damping: 0.4);

// ─────────────────────────────────────────────────────────────────────────────
// Slot — lightweight per-item bookkeeping
// ─────────────────────────────────────────────────────────────────────────────

enum _SlotStatus { visible, collapsing }

class DismissibleSlot {
  _SlotStatus _status;
  double capturedHeight = 0;
  double capturedWidth = 0;

  /// Direction of the swipe that caused the dismiss — kept so the background
  /// stays correct during the fly-out.
  DismissDirection? dismissedDirection;

  SingleMotionController? collapseCtrl;
  SingleMotionController? flyCtrl;
  final ValueNotifier<double> flyNotifier = ValueNotifier(0.0);
  bool _flyDisposed = false;
  Widget? frozenChild;

  /// Unique identity – survives slot-list mutations so gesture tracking stays
  /// stable even when surrounding slots collapse.
  final Object identity = Object();

  DismissibleSlot() : _status = _SlotStatus.visible;

  bool get isVisible => _status == _SlotStatus.visible;
  bool get isCollapsing => _status == _SlotStatus.collapsing;

  void dispose() {
    collapseCtrl?.dispose();
    flyCtrl?.dispose();
    disposeFlyNotifier();
  }

  void disposeFlyNotifier() {
    if (!_flyDisposed) {
      _flyDisposed = true;
      flyNotifier.dispose();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mixin — all shared drag / animation / build logic
// ─────────────────────────────────────────────────────────────────────────────

/// A mixin that implements the full dismissible M3E card interaction model.
///
/// Concrete wrappers (Column, ListView, Sliver) only need to provide a layout
/// container in their [build] methods and delegate per‑slot widget creation to
/// [buildSlot].
mixin M3EDismissibleCardMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  // ── Abstract interface — each wrapper implements these ──

  /// Current number of data items (from the consumer).
  int get swipeItemCount;

  /// Builds the content for the item at [dataIndex].
  Widget swipeItemBuilder(BuildContext context, int dataIndex);

  /// Visual / interaction configuration.
  M3EDismissibleCardStyle get style;

  /// Called when a swipe exceeds [M3EDismissibleCardStyle.dismissThreshold].
  Future<bool> Function(int index, DismissDirection direction)?
  get onDismissCallback;

  /// Called on tap (unless interaction is locked).
  void Function(int index)? get onTapCallback;

  // ── Internal state ──

  final List<DismissibleSlot> _slots = [];

  /// The slot currently being dragged (by identity reference, NOT index).
  DismissibleSlot? _dragSlotRef;

  /// Cached slot-list index of the dragged slot (recomputed on every mutation).
  int _dragSlotIndex = -1;

  double _dragOffset = 0.0;
  bool _pastThreshold = false;
  bool _reEngaging = false;

  double _neighbourFraction = 0.0;
  double _roundnessFraction = 0.0;
  double _detachPush = 0.0;

  /// Stopwatch for throttling haptic feedback — cheaper than DateTime.now().
  final Stopwatch _hapticStopwatch = Stopwatch()..start();

  final Map<DismissibleSlot, GlobalKey> _measureKeys = {};

  SingleMotionController? _springCtrl;
  SingleMotionController? _nbrCtrl;
  SingleMotionController? _pushCtrl;
  SingleMotionController? _roundnessCtrl;

  // ── Constants ──

  static const int _kVibrationThresholdMs = 60;
  static const double _kMaxPreDetachRoundness = 0.6;
  static const double _kPreThresholdRoundnessScale = 0.4;
  static const double _kDetachPushPixels = 30.0;

  // ── Public API ──

  /// Sorted indices of visible (non-collapsing) slots.
  List<int> computeVisibleIndices() => [
    for (int i = 0; i < _slots.length; i++)
      if (_slots[i].isVisible) i,
  ];

  /// All managed slots (visible + collapsing).
  List<DismissibleSlot> get slots => _slots;

  /// `true` while any drag or collapse animation is running — used to block
  /// tap events and prevent mis-touch.
  bool get isInteractionLocked =>
      _dragSlotRef != null || _slots.any((s) => s.isCollapsing);

  // ── Lifecycle ──

  void initSlots() => _syncSlots();

  void syncSlotsIfNeeded(int oldItemCount) {
    if (swipeItemCount != oldItemCount) _syncSlots();
  }

  void disposeSlots() {
    _springCtrl?.dispose();
    _nbrCtrl?.dispose();
    _pushCtrl?.dispose();
    _roundnessCtrl?.dispose();
    for (final slot in _slots) {
      slot.dispose();
      slot.disposeFlyNotifier();
    }
  }

  /// Keeps [_slots] in sync with [swipeItemCount] without requiring the
  /// consumer to do manual index arithmetic.
  void _syncSlots() {
    final visibleCount = _slots.where((s) => s.isVisible).length;

    if (visibleCount > swipeItemCount) {
      int toRemove = visibleCount - swipeItemCount;
      for (int i = _slots.length - 1; i >= 0 && toRemove > 0; i--) {
        if (_slots[i].isVisible) {
          final slot = _slots[i];
          _slots.removeAt(i);
          _measureKeys.remove(slot);
          slot.dispose();
          toRemove--;
        }
      }
    } else if (visibleCount < swipeItemCount) {
      final toAdd = swipeItemCount - visibleCount;
      for (int i = 0; i < toAdd; i++) {
        _slots.add(DismissibleSlot());
      }
    }

    // Keep drag tracking stable after mutations.
    _reindexDragSlot();
  }

  void _reindexDragSlot() {
    if (_dragSlotRef != null) {
      _dragSlotIndex = _slots.indexOf(_dragSlotRef!);
      if (_dragSlotIndex < 0) {
        // Slot was removed — cancel drag silently.
        _dragSlotRef = null;
        _dragOffset = 0.0;
        _detachPush = 0.0;
      }
    } else {
      _dragSlotIndex = -1;
    }
  }

  // ── Measurement helpers ──

  GlobalKey _measureKey(DismissibleSlot slot) =>
      _measureKeys.putIfAbsent(slot, () => GlobalKey());

  Size _cardSize(DismissibleSlot slot) {
    final box =
        _measureKeys[slot]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return const Size(320, 52);
    return box.size;
  }

  double get _dragProgress {
    if (_dragSlotRef == null) return 0.0;
    final w = _cardSize(_dragSlotRef!).width;
    return (_dragOffset.abs() / (w * style.dismissThreshold)).clamp(0.0, 1.0);
  }

  // ── Border radius ──

  BorderRadius computeRadius(int slotIndex, List<int> visible) {
    final s = style;
    final pos = visible.indexOf(slotIndex);
    if (pos < 0) return BorderRadius.circular(s.outerRadius);

    final total = visible.length;
    final isFirst = pos == 0;
    final isLast = pos == total - 1;
    final or = s.outerRadius;
    final sr = s.selectedBorderRadius ?? or;
    final ir = s.innerRadius;

    if (total == 1) return BorderRadius.circular(or);

    final dragPos = _dragSlotIndex >= 0 ? visible.indexOf(_dragSlotIndex) : -1;

    // No active drag or far from dragged card — static radius.
    if (dragPos < 0 || (pos - dragPos).abs() > 1) {
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : ir),
        topRight: Radius.circular(isFirst ? or : ir),
        bottomLeft: Radius.circular(isLast ? or : ir),
        bottomRight: Radius.circular(isLast ? or : ir),
      );
    }

    // Animated radius for immediate neighbours + the dragged card itself.
    final facingR = lerpDouble(ir, or, _roundnessFraction)!;
    final subtleR = _pastThreshold
        ? ir
        : lerpDouble(ir, or, _roundnessFraction * 0.3)!;

    final isDragged = slotIndex == _dragSlotIndex;
    final isAbove = pos < dragPos;

    if (isDragged) {
      // Once past threshold, snap all corners to selectedBorderRadius.
      if (_pastThreshold) {
        return BorderRadius.circular(sr);
      }
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : facingR),
        topRight: Radius.circular(isFirst ? or : facingR),
        bottomLeft: Radius.circular(isLast ? or : facingR),
        bottomRight: Radius.circular(isLast ? or : facingR),
      );
    }
    if (isAbove) {
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : subtleR),
        topRight: Radius.circular(isFirst ? or : subtleR),
        bottomLeft: Radius.circular(isLast ? or : facingR),
        bottomRight: Radius.circular(isLast ? or : facingR),
      );
    }
    // Below.
    return BorderRadius.only(
      topLeft: Radius.circular(isFirst ? or : facingR),
      topRight: Radius.circular(isFirst ? or : facingR),
      bottomLeft: Radius.circular(isLast ? or : subtleR),
      bottomRight: Radius.circular(isLast ? or : subtleR),
    );
  }

  // ── Neighbour offset ──

  double computeNeighbourOffset(int slotIndex, List<int> visible) {
    if (_dragSlotIndex < 0) return 0.0;
    final dragPos = visible.indexOf(_dragSlotIndex);
    final pos = visible.indexOf(slotIndex);
    if (dragPos < 0 || pos < 0) return 0.0;

    final distance = (pos - dragPos).abs();
    if (distance == 0 || distance > style.neighbourReach) return 0.0;

    final reach = style.neighbourReach;
    final falloff = reach > 1 ? (reach - distance) / (reach - 1) : 1.0;
    return _neighbourFraction *
        style.neighbourPull *
        falloff *
        _dragOffset.sign;
  }

  // ── Gesture handlers ──

  void handleDragStart(DismissibleSlot slot) {
    if (slot._status != _SlotStatus.visible) return;

    _springCtrl?.stop(canceled: true);
    _nbrCtrl?.stop(canceled: true);
    _pushCtrl?.stop(canceled: true);

    setState(() {
      _dragSlotRef = slot;
      _dragSlotIndex = _slots.indexOf(slot);
      _dragOffset = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _detachPush = 0.0;
      _roundnessFraction = 0.0;
    });
  }

  void handleDragUpdate(DragUpdateDetails d) {
    if (_dragSlotRef == null) return;

    final double swipeSpeed = d.delta.dx.abs();
    final double multiplier = (1.0 + (swipeSpeed / 5.0)).clamp(1.0, 4.0);

    double newOffset = _dragOffset + d.delta.dx;
    double newNeighbour = _neighbourFraction;
    double newRoundness = _roundnessFraction;

    // Preview progress at the new offset.
    final savedOffset = _dragOffset;
    _dragOffset = newOffset;
    final newProgress = _dragProgress;
    _dragOffset = savedOffset;

    final crossedNow = newProgress >= 1.0;

    if (crossedNow && !_pastThreshold) {
      // ── Crossed threshold ──
      _pastThreshold = true;
      switch (style.hapticOnThreshold) {
        case 1:
          HapticFeedback.lightImpact();
          break;
        case 2:
          HapticFeedback.mediumImpact();
          break;
        case 3:
          HapticFeedback.heavyImpact();
          break;
        default:
          break;
      }

      final pushDir = newOffset.sign;

      _pushCtrl?.dispose();
      _pushCtrl =
          SingleMotionController(
              motion: _kDetachPush.copyWith(stiffness: 800 * multiplier),
              vsync: this,
              initialValue: 0.0,
            )
            ..addListener(() {
              if (mounted) setState(() => _detachPush = _pushCtrl!.value);
            })
            ..animateTo(
              style.background == null || style.secondaryBackground == null
                  ? pushDir * _kDetachPushPixels
                  : 0,
            );

      _nbrCtrl?.dispose();
      _nbrCtrl =
          SingleMotionController(
              motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
                stiffness: style.neighbourStiffness * multiplier,
                damping: style.neighbourDamping,
              ),
              vsync: this,
              initialValue: _neighbourFraction,
            )
            ..addListener(() {
              if (mounted) setState(() => _neighbourFraction = _nbrCtrl!.value);
            })
            ..animateTo(0.0);

      _roundnessCtrl?.dispose();
      _roundnessCtrl =
          SingleMotionController(
              motion: _kRoundnessSnap.copyWith(stiffness: 1000 * multiplier),
              vsync: this,
              initialValue: _roundnessFraction,
            )
            ..addListener(() {
              if (mounted) {
                setState(() => _roundnessFraction = _roundnessCtrl!.value);
              }
            })
            ..animateTo(1.0);
    } else if (!crossedNow && _pastThreshold) {
      // ── Re-engaging (back below threshold) ──
      _pastThreshold = false;
      _reEngaging = true;
      switch (style.hapticOnThreshold) {
        case 1:
          HapticFeedback.lightImpact();
          break;
        case 2:
          HapticFeedback.mediumImpact();
          break;
        case 3:
          HapticFeedback.heavyImpact();
          break;
        default:
          break;
      }

      _pushCtrl?.dispose();
      _pushCtrl =
          SingleMotionController(
              motion: _kDetachPush.copyWith(stiffness: 800 * multiplier),
              vsync: this,
              initialValue: _detachPush,
            )
            ..addListener(() {
              if (mounted) setState(() => _detachPush = _pushCtrl!.value);
            })
            ..animateTo(0.0);

      // Compute target neighbour fraction at the new offset.
      _dragOffset = newOffset;
      final target = _dragProgress;
      _dragOffset = savedOffset;

      _nbrCtrl?.dispose();
      _nbrCtrl =
          SingleMotionController(
              motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
                stiffness: style.neighbourStiffness * multiplier,
                damping: style.neighbourDamping,
              ),
              vsync: this,
              initialValue: _neighbourFraction,
            )
            ..addListener(() {
              if (mounted) setState(() => _neighbourFraction = _nbrCtrl!.value);
            })
            ..addStatusListener((s) {
              if (s == AnimationStatus.completed ||
                  s == AnimationStatus.dismissed) {
                _reEngaging = false;
              }
            })
            ..animateTo(target);

      _roundnessCtrl?.dispose();
      _roundnessCtrl =
          SingleMotionController(
              motion: _kReEngageSpring.copyWith(stiffness: 800 * multiplier),
              vsync: this,
              initialValue: _roundnessFraction,
            )
            ..addListener(() {
              if (mounted) {
                setState(() => _roundnessFraction = _roundnessCtrl!.value);
              }
            })
            ..animateTo(target * _kPreThresholdRoundnessScale);
    } else if (!_pastThreshold) {
      // ── Normal pre-threshold tracking ──
      if (_reEngaging) {
        _reEngaging = false;
        _nbrCtrl?.stop(canceled: true);
        _roundnessCtrl?.stop(canceled: true);
      }
      newNeighbour = newProgress;
      newRoundness = (newProgress * _kMaxPreDetachRoundness).clamp(
        0.0,
        _kMaxPreDetachRoundness,
      );

      if (style.dismissHapticStream) _playPullHaptics();
    }

    setState(() {
      _dragOffset = newOffset;
      _neighbourFraction = newNeighbour;
      _roundnessFraction = newRoundness;
    });
  }

  void handleDragEnd(DragEndDetails d) {
    if (_dragSlotRef == null) return;

    // Re-resolve the index — it may have shifted during the drag.
    _reindexDragSlot();
    if (_dragSlotIndex < 0) {
      _resetDragState();
      return;
    }

    final velocity = d.velocity.pixelsPerSecond.dx.abs();
    final double speedMul = (1.0 + (velocity / 1000.0)).clamp(1.0, 4.0);

    if (_dragProgress >= 1.0) {
      final direction = _dragOffset > 0
          ? DismissDirection.startToEnd
          : DismissDirection.endToStart;
      _dismiss(_dragSlotIndex, speedMul, direction);
    } else {
      _springBack(speedMul);
    }
  }

  void _resetDragState() {
    setState(() {
      _dragSlotRef = null;
      _dragSlotIndex = -1;
      _dragOffset = 0.0;
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _reEngaging = false;
      _roundnessFraction = 0.0;
    });
  }

  void _playPullHaptics() {
    if (!style.enableFeedback) return;
    if (_hapticStopwatch.elapsedMilliseconds < _kVibrationThresholdMs) return;
    _hapticStopwatch.reset();
    HapticFeedback.selectionClick();
  }

  // ── Spring-back (below threshold release) ──

  void _springBack(double speedMul) {
    _pushCtrl?.dispose();
    _pushCtrl = null;
    _detachPush = 0.0;
    _roundnessCtrl?.dispose();
    _roundnessCtrl = null;
    _roundnessFraction = 0.0;

    final ref = _dragSlotRef;

    _springCtrl?.dispose();
    _springCtrl =
        SingleMotionController(
            motion: _kSpatialSpring.copyWith(stiffness: 380 * speedMul),
            vsync: this,
            initialValue: _dragOffset,
          )
          ..addListener(() {
            if (mounted) setState(() => _dragOffset = _springCtrl!.value);
          })
          ..addStatusListener((s) {
            if ((s == AnimationStatus.completed ||
                    s == AnimationStatus.dismissed) &&
                mounted &&
                _dragSlotRef == ref) {
              _resetDragState();
            }
          })
          ..animateTo(0.0);

    _nbrCtrl?.dispose();
    _nbrCtrl =
        SingleMotionController(
            motion: _kSpatialSpring.copyWith(stiffness: 380 * speedMul),
            vsync: this,
            initialValue: _neighbourFraction,
          )
          ..addListener(() {
            if (mounted) setState(() => _neighbourFraction = _nbrCtrl!.value);
          })
          ..animateTo(0.0);
  }

  // ── Dismiss (above threshold release) ──

  Future<void> _dismiss(
    int slotIndex,
    double speedMul,
    DismissDirection direction,
  ) async {
    if (slotIndex < 0 || slotIndex >= _slots.length) return;

    final slot = _slots[slotIndex];
    final visible = computeVisibleIndices();
    final dataIndex = visible.indexOf(slotIndex);
    if (dataIndex < 0) return;

    // Capture size & freeze the child.
    final size = _cardSize(slot);
    slot.capturedHeight = size.height;
    slot.capturedWidth = size.width;
    slot.frozenChild = swipeItemBuilder(context, dataIndex);
    slot.dismissedDirection = direction;

    final flyInitial = _dragOffset + _detachPush;
    slot.flyNotifier.value = flyInitial;

    // Clear drag-phase controllers.
    _pushCtrl?.dispose();
    _pushCtrl = null;
    _roundnessCtrl?.dispose();
    _roundnessCtrl = null;

    setState(() {
      slot._status = _SlotStatus.collapsing;
      _dragSlotRef = null;
      _dragSlotIndex = -1;
      _dragOffset = 0.0;
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _reEngaging = false;
      _roundnessFraction = 0.0;
    });

    // ── Collapse spring (gap closes) ──
    final colCtrl = SingleMotionController(
      motion: _kSpatialSpringBack.copyWith(
        stiffness: style.collapseSpeed * speedMul,
      ),
      vsync: this,
      initialValue: 0.0,
    );
    slot.collapseCtrl = colCtrl;

    colCtrl
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
          if (mounted) {
            final idx = _slots.indexOf(slot);
            if (idx >= 0) {
              setState(() {
                _slots.removeAt(idx);
                _reindexDragSlot();
              });
              _measureKeys.remove(slot);
            }
          }
          slot.disposeFlyNotifier();
          slot.dispose();
          colCtrl.dispose();
        }
      })
      ..animateTo(1.0);

    // ── Fly-out spring ──
    final flySign = flyInitial.sign;
    final flyTarget = flySign == 0
        ? slot.capturedWidth + 80.0
        : flySign * (slot.capturedWidth + 80.0);

    slot.flyCtrl?.dispose();
    final flyCtrl = SingleMotionController(
      motion: _kFlySpring.copyWith(stiffness: 400 * speedMul),
      vsync: this,
      initialValue: flyInitial,
    );
    slot.flyCtrl = flyCtrl;
    flyCtrl
      ..addListener(() => slot.flyNotifier.value = flyCtrl.value)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
          slot.flyCtrl = null;
          flyCtrl.dispose();
          // Start the collapse spring after the fly-out finishes
          colCtrl.animateTo(1.0);
        }
      })
      ..animateTo(flyTarget);

    // Notify consumer.
    onDismissCallback?.call(dataIndex, direction);
  }

  // ── Widget builders ──

  /// Dispatches to either [_buildActiveCard] or [_buildCollapsingCard].
  ///
  /// Pass a pre-computed [visible] list to avoid recomputing
  /// [computeVisibleIndices] once per slot.
  Widget buildSlot(BuildContext context, int slotIndex, [List<int>? visible]) {
    final slot = _slots[slotIndex];
    if (slot.isCollapsing) {
      return _buildCollapsingCard(context, slotIndex);
    }
    return _buildActiveCard(
      context,
      slotIndex,
      visible ?? computeVisibleIndices(),
    );
  }

  Widget _buildCollapsingCard(BuildContext context, int slotIndex) {
    final slot = _slots[slotIndex];
    final ctrl = slot.collapseCtrl!;
    final totalH = slot.capturedHeight + style.gap;
    final s = style;
    final bool swipingRight = _dragOffset > 0;
    final borderRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ctrl,
        builder: (ctx, _) {
          final h = (totalH * (1.0 - ctrl.value)).clamp(0.0, totalH);
          return SizedBox(
            height: h,
            width: double.infinity,
            child: slot.frozenChild == null
                ? null
                : Stack(
                    children: [
                      // ── Background (stays visible during fly-out, pushing card) ──
                      if (slot.dismissedDirection != null)
                        ValueListenableBuilder<double>(
                          valueListenable: slot.flyNotifier,
                          builder: (ctx, flyOff, child) {
                            // Calculate how far the card has flown.
                            final progress = flyOff.abs();
                            // If swiping right (flyOff > 0), align background to left and increase its width.
                            // If swiping left (flyOff < 0), align background to right and increase its width.
                            final swipingRight =
                                slot.dismissedDirection ==
                                DismissDirection.startToEnd;
                            return Positioned.fill(
                              child: Align(
                                alignment: swipingRight
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: SizedBox(
                                  width: progress,
                                  height: double.infinity,
                                  child: Padding(
                                    padding: s.margin ?? EdgeInsets.zero,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        borderRadius,
                                      ),
                                      child: _buildDismissedBackground(
                                        swipingRight
                                            ? s.background
                                            : (s.secondaryBackground ??
                                                  s.background),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // ── Flying card ──
                      OverflowBox(
                        alignment: Alignment.topLeft,
                        minWidth: slot.capturedWidth > 0
                            ? slot.capturedWidth
                            : 0,
                        maxWidth: slot.capturedWidth > 0
                            ? slot.capturedWidth
                            : MediaQuery.sizeOf(ctx).width,
                        minHeight: 0,
                        maxHeight: slot.capturedHeight,
                        child: IgnorePointer(
                          child: ValueListenableBuilder<double>(
                            valueListenable: slot.flyNotifier,
                            builder: (_, flyOff, child) => Transform.translate(
                              offset: Offset(flyOff, 0),
                              child: child,
                            ),
                            child: Padding(
                              padding: s.margin ?? EdgeInsets.zero,
                              child: _FlyingCard(
                                key: ValueKey('fly_${slot.identity.hashCode}'),
                                borderRadius: BorderRadius.circular(
                                  borderRadius,
                                ),
                                color:
                                    s.color ??
                                    Theme.of(
                                      ctx,
                                    ).colorScheme.surfaceContainerHighest,
                                elevation: s.elevation + 6,
                                border: s.border,
                                padding: s.padding ?? const EdgeInsets.all(16),
                                child: slot.frozenChild!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildActiveCard(
    BuildContext context,
    int slotIndex,
    List<int> visible,
  ) {
    final slot = _slots[slotIndex];
    final s = style;
    final dataIndex = visible.indexOf(slotIndex);
    if (dataIndex < 0 || dataIndex >= swipeItemCount) {
      return const SizedBox.shrink();
    }

    final total = visible.length;
    final isLast = visible.indexOf(slotIndex) == total - 1;
    final isDragged = slotIndex == _dragSlotIndex;
    final br = computeRadius(slotIndex, visible);
    final nOff = computeNeighbourOffset(slotIndex, visible);

    // Active background based on swipe direction.
    final bool swipingRight = _dragOffset > 0;
    final Widget? activeBg = swipingRight
        ? s.background
        : (s.secondaryBackground ?? s.background);

    final borderRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);

    return RepaintBoundary(
      child: Padding(
        padding: s.margin ?? EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : s.gap),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Expanding pill background ──
              if (isDragged && _dragOffset != 0 && activeBg != null)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: Align(
                      alignment: swipingRight
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: SizedBox(
                          width: _dragOffset.abs(),
                          height: double.infinity,
                          child: Opacity(
                            opacity: (_dragProgress * 3.0).clamp(0.0, 1.0),
                            child: _buildActiveBackground(
                              activeBg,
                              _dragProgress,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Foreground card ──
              Transform.translate(
                offset: Offset(isDragged ? _dragOffset + _detachPush : nOff, 0),
                child: GestureDetector(
                  onHorizontalDragStart: (_) => handleDragStart(slot),
                  onHorizontalDragUpdate: handleDragUpdate,
                  onHorizontalDragEnd: handleDragEnd,
                  child: _AnimatedCard(
                    key: ValueKey('card_${slot.identity.hashCode}'),
                    cardKey: _measureKey(slot),
                    borderRadius: br,
                    color:
                        s.color ??
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    elevation: isDragged ? s.elevation + 6 : s.elevation,
                    border: s.border,
                    isDragged: isDragged,
                    hasActiveDrag: _dragSlotRef != null,
                    child: InkWell(
                      splashColor: s.splashColor,
                      highlightColor: s.highlightColor,
                      splashFactory: s.splashFactory,
                      enableFeedback: s.enableFeedback,
                      // ── Mistouch fix: block taps during drag / dismiss ──
                      onTap: isInteractionLocked || onTapCallback == null
                          ? null
                          : () {
                              onTapCallback!(dataIndex);
                              switch (s.hapticOnTap) {
                                case 1:
                                  HapticFeedback.lightImpact();
                                  break;
                                case 2:
                                  HapticFeedback.mediumImpact();
                                  break;
                                case 3:
                                  HapticFeedback.heavyImpact();
                                  break;
                                default:
                                  break;
                              }
                            },
                      child: Padding(
                        padding: s.padding ?? const EdgeInsets.all(16.0),
                        child: swipeItemBuilder(context, dataIndex),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Background helpers ──

  Widget _buildDismissedBackground(Widget? bg) {
    if (bg == null) return const SizedBox.shrink();
    if (bg is Container) {
      return Container(color: bg.color, decoration: bg.decoration);
    }
    if (bg is ColoredBox) return ColoredBox(color: bg.color);
    if (bg is DecoratedBox) return DecoratedBox(decoration: bg.decoration);
    return bg;
  }

  Widget _buildActiveBackground(Widget? bg, double progress) {
    if (bg == null) return const SizedBox.shrink();

    final iconOpacity = progress < 0.3
        ? 0.0
        : ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
    final iconScale = progress < 0.3
        ? 0.8
        : (0.8 + ((progress - 0.3) / 0.7) * 0.2).clamp(0.0, 1.0);

    Widget wrapChild(Widget? child) {
      if (child == null) return const SizedBox.shrink();
      return Transform.scale(
        scale: iconScale,
        child: Opacity(opacity: iconOpacity, child: child),
      );
    }

    if (bg is Container) {
      return Container(
        alignment: bg.alignment,
        padding: bg.padding,
        color: bg.color,
        decoration: bg.decoration,
        foregroundDecoration: bg.foregroundDecoration,
        constraints: bg.constraints,
        margin: bg.margin,
        transform: bg.transform,
        transformAlignment: bg.transformAlignment,
        clipBehavior: bg.clipBehavior,
        child: bg.child != null ? wrapChild(bg.child) : null,
      );
    }
    if (bg is ColoredBox) {
      return ColoredBox(color: bg.color, child: wrapChild(bg.child));
    }
    if (bg is DecoratedBox) {
      return DecoratedBox(
        decoration: bg.decoration,
        position: bg.position,
        child: wrapChild(bg.child),
      );
    }
    return wrapChild(bg);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AnimatedCard — the foreground card with animated decoration
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedCard extends StatelessWidget {
  final GlobalKey cardKey;
  final BorderRadius borderRadius;
  final Color color;
  final double elevation;
  final BorderSide? border;
  final bool isDragged;
  final bool hasActiveDrag;
  final Widget child;

  const _AnimatedCard({
    super.key,
    required this.cardKey,
    required this.borderRadius,
    required this.color,
    required this.elevation,
    required this.isDragged,
    required this.hasActiveDrag,
    this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      duration: hasActiveDrag
          ? Duration.zero
          : const Duration(milliseconds: 520),
      curve: const Cubic(0.34, 1.56, 0.64, 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06 + elevation * 0.015),
            blurRadius: 4 + elevation * 2,
            spreadRadius: isDragged ? 1 : 0,
            offset: Offset(0, isDragged ? 4 : 2),
          ),
        ],
        border: border != null
            ? Border.all(color: border!.color, width: border!.width)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(key: cardKey, color: Colors.transparent, child: child),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FlyingCard — snapshot card that flies off-screen during dismiss
// ─────────────────────────────────────────────────────────────────────────────

class _FlyingCard extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color color;
  final double elevation;
  final BorderSide? border;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _FlyingCard({
    super.key,
    required this.borderRadius,
    required this.color,
    required this.elevation,
    this.border,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06 + elevation * 0.015),
            blurRadius: 4 + elevation * 2,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: border != null
            ? Border.all(color: border!.color, width: border!.width)
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: Colors.transparent,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
