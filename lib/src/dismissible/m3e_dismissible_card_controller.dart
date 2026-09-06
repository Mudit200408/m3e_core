import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../common/m3e_common.dart';
import 'internal/_dismissible_focus_ring.dart';
import 'm3e_dismissible_card_style.dart';
import 'm3e_swipe_action.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spring presets (Material 3 Expressive via motor)
// ─────────────────────────────────────────────────────────────────────────────

final _kSpatialSpringBack = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 200, damping: 0.8);

final _kReEngageSpring = MaterialSpringMotion.standardSpatialFast();

final _kDetachPush = MaterialSpringMotion.expressiveSpatialDefault().copyWith(
  stiffness: 800,
  damping: 0.95,
);

final _kRoundnessSnap = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 1000, damping: 0.4);

// Easing used by _AnimatedCard when no drag is active — settles the card's
// border-radius and shadow smoothly without overshooting into negative blur radii.
const _kCardSettleCurve = Curves.easeOutCubic;

// ─────────────────────────────────────────────────────────────────────────────
// Slot — lightweight per-item bookkeeping
// ─────────────────────────────────────────────────────────────────────────────

enum _SlotStatus { visible, collapsing }

/// Lightweight bookkeeping for a single card's position and lifecycle in the list.
class DismissibleSlot {
  _SlotStatus _status;

  /// The measured height of the card before it started collapsing.
  double capturedHeight = 0;

  /// The measured width of the card before it was dismissed.
  double capturedWidth = 0;

  /// Direction of the swipe that caused the dismiss — kept so the background
  /// stays correct during the fly-out.
  DismissDirection? dismissedDirection;

  /// Controller for the collapse animation (gap closing).
  SingleMotionController? collapseCtrl;

  /// Controller for the fly-out animation (card moving off-screen).
  SingleMotionController? flyCtrl;

  /// Notifier for the fly-out progress value.
  final ValueNotifier<double> flyNotifier = ValueNotifier(0.0);
  bool _flyDisposed = false;

  /// Notifier for local press-state (touch down / press scale).
  ///
  /// Isolated per-slot so that pressing an item only updates that item's
  /// SingleMotionBuilder, avoiding full list-wide rebuilds.
  final ValueNotifier<bool> isPressedNotifier = ValueNotifier<bool>(false);

  /// Notifier for local keyboard focus-state.
  ///
  /// Isolated per-slot so that focusing an item only updates that item's
  /// focus ring decorator.
  final ValueNotifier<bool> isFocusedNotifier = ValueNotifier<bool>(false);

  /// Dedicated FocusNode for keyboard focus tracking.
  late final FocusNode focusNode;

  /// Focus nodes for individual action buttons when revealed.
  final List<FocusNode> actionFocusNodes = [];

  /// Optional callback invoked when the user requests keyboard-driven reordering
  /// (e.g. via Alt/Option/Cmd+ArrowUp/Down).
  void Function(int index, bool moveForward)? onReorderKey;

  /// The child widget to display during the dismiss animation.
  Widget? frozenChild;

  /// Unique identity – survives slot-list mutations so gesture tracking stays
  /// stable even when surrounding slots collapse.
  final Object identity = Object();

  /// Creates a new [DismissibleSlot] in the visible state.
  DismissibleSlot({KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent})
    : _status = _SlotStatus.visible {
    focusNode = FocusNode(
      debugLabel: 'M3EDismissibleSlot',
      onKeyEvent: onKeyEvent,
    );
    focusNode.addListener(_handleFocusNodeChanged);
  }

  FocusNode getActionFocusNode(int index) {
    while (actionFocusNodes.length <= index) {
      final node = FocusNode(
        debugLabel:
            'M3ESwipeAction_${identity.hashCode}_${actionFocusNodes.length}',
      );
      actionFocusNodes.add(node);
    }
    return actionFocusNodes[index];
  }

  void _handleFocusNodeChanged() {
    isFocusedNotifier.value = focusNode.hasFocus;
  }

  bool get isVisible => _status == _SlotStatus.visible;
  bool get isCollapsing => _status == _SlotStatus.collapsing;

  /// Disposes of the slot and its controllers.
  void dispose() {
    collapseCtrl?.dispose();
    flyCtrl?.dispose();
    disposeFlyNotifier();
    focusNode.removeListener(_handleFocusNodeChanged);
    focusNode.dispose();
    for (final node in actionFocusNodes) {
      node.dispose();
    }
    actionFocusNodes.clear();
    isPressedNotifier.dispose();
    isFocusedNotifier.dispose();
  }

  /// Disposes of the fly notifier.
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
  double _targetOffset = 0.0;
  bool _pastThreshold = false;
  bool _pastActionThreshold = false;
  bool _reEngaging = false;

  double _neighbourFraction = 0.0;
  double _roundnessFraction = 0.0;
  double _detachPush = 0.0;

  /// Number of slots currently in the collapsing state.
  /// Kept in sync at the exact moments slots change state — O(1) alternative
  /// to scanning [_slots] on every card build.
  int _collapsingCount = 0;

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
  List<DismissibleSlot> get slots => List.unmodifiable(_slots);

  /// `true` while any drag or collapse animation is running — used to block
  /// tap events and prevent mis-touch.
  bool get isInteractionLocked => _dragSlotRef != null || _collapsingCount > 0;

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
    _collapsingCount = 0;
  }

  DismissibleSlot _createSlot() {
    late final DismissibleSlot slot;
    slot = DismissibleSlot(
      onKeyEvent: (node, event) => _handleCardKeyEvent(node, event, slot),
    );
    return slot;
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
    } else if (visibleCount + _collapsingCount < swipeItemCount) {
      final toAdd = swipeItemCount - (visibleCount + _collapsingCount);
      for (int i = 0; i < toAdd; i++) {
        _slots.add(_createSlot());
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

  // [slotPos] and [dragPos] are pre-computed by the caller to avoid redundant
  // indexOf lookups when this is called once per card per frame.
  BorderRadius computeRadius(
    int slotIndex,
    int slotPos,
    int dragPos,
    List<int> visible, [
    int? visualIndexOverride,
  ]) {
    final s = style;
    if (slotPos < 0) return BorderRadius.circular(s.outerRadius);

    final total = visible.length;
    final isFirst = (visualIndexOverride ?? slotPos) == 0;
    final isLast = (visualIndexOverride ?? slotPos) == total - 1;
    final or = s.outerRadius;
    final sr = s.selectedBorderRadius ?? or;
    final ir = s.innerRadius;
    final isDragged = slotIndex == _dragSlotIndex;

    if (total == 1) {
      if (isDragged) {
        if (_pastThreshold) {
          return BorderRadius.circular(sr);
        }
        final facingR = lerpDouble(or, sr, _roundnessFraction)!;
        return BorderRadius.circular(facingR);
      }
      return BorderRadius.circular(or);
    }

    // No active drag or far from dragged card — static radius.
    if (dragPos < 0 || (slotPos - dragPos).abs() > 1) {
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

    final isAbove = slotPos < dragPos;

    if (isDragged) {
      final actionList = _dragOffset > 0
          ? style.actions
          : (style.secondaryActions ?? style.actions);
      final bool hasActions = actionList != null && actionList.isNotEmpty;

      // When action buttons are used, morph smoothly with facingR (no hard _pastThreshold snap)
      // and return to resting inner radius when snapped back.
      if (hasActions) {
        return BorderRadius.only(
          topLeft: Radius.circular(isFirst ? or : facingR),
          topRight: Radius.circular(isFirst ? or : facingR),
          bottomLeft: Radius.circular(isLast ? or : facingR),
          bottomRight: Radius.circular(isLast ? or : facingR),
        );
      }

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

  // [slotPos] and [dragPos] are pre-computed by the caller.
  double computeNeighbourOffset(int slotPos, int dragPos) {
    if (dragPos < 0 || slotPos < 0) return 0.0;

    final distance = (slotPos - dragPos).abs();
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
    if (slot._status != _SlotStatus.visible ||
        style.direction == DismissDirection.none) {
      return;
    }

    _springCtrl?.stop(canceled: true);
    _nbrCtrl?.stop(canceled: true);
    _pushCtrl?.stop(canceled: true);
    _roundnessCtrl?.stop(canceled: true);

    setState(() {
      final isSameSlot = _dragSlotRef == slot;
      _dragSlotRef = slot;
      _dragSlotIndex = _slots.indexOf(slot);
      if (!isSameSlot) {
        _dragOffset = 0.0;
        _neighbourFraction = 0.0;
        _pastThreshold = false;
        _pastActionThreshold = false;
        _detachPush = 0.0;
        _roundnessFraction = 0.0;
      }
      // Clear press scale when drag starts
      if (style.pressedScale != null && style.pressedScale != 1.0) {
        slot.isPressedNotifier.value = false;
      }
    });
  }

  void handleDragUpdate(DragUpdateDetails d) {
    if (_dragSlotRef == null || style.direction == DismissDirection.none) {
      return;
    }

    final double swipeSpeed = d.delta.dx.abs();
    final double multiplier = (1.0 + (swipeSpeed / 5.0)).clamp(1.0, 4.0);

    double newOffset = _dragOffset + d.delta.dx;
    if (style.direction == DismissDirection.startToEnd && newOffset < 0) {
      newOffset = 0.0;
    } else if (style.direction == DismissDirection.endToStart &&
        newOffset > 0) {
      newOffset = 0.0;
    }

    final swipingRight = newOffset > 0;
    final actionList = swipingRight
        ? style.actions
        : (style.secondaryActions ?? style.actions);
    final bool hasActions = actionList != null && actionList.isNotEmpty;

    if (hasActions) {
      final actionsWidth = _computeActionsWidth(actionList);
      final maxExtent = actionsWidth + 24.0;
      if (newOffset.abs() > maxExtent) {
        final overdrag = newOffset.abs() - maxExtent;
        final dampedOverdrag = math.sqrt(overdrag) * 3.0;
        newOffset = (maxExtent + dampedOverdrag) * newOffset.sign;
      }

      final crossedAction = newOffset.abs() >= actionsWidth;
      if (crossedAction && !_pastActionThreshold) {
        _pastActionThreshold = true;
        if (style.enableFeedback) {
          applyHaptic(style.hapticOnThreshold);
        }
      } else if (!crossedAction && _pastActionThreshold) {
        _pastActionThreshold = false;
      }
    }

    double newNeighbour = _neighbourFraction;
    double newRoundness = _roundnessFraction;

    // Preview progress at the new offset.
    final savedOffset = _dragOffset;
    _dragOffset = newOffset;
    final newProgress = _dragProgress;
    _dragOffset = savedOffset;

    final crossedNow = hasActions ? false : (newProgress >= 1.0);

    if (crossedNow && !_pastThreshold) {
      // ── Crossed threshold ──
      _pastThreshold = true;
      applyHaptic(style.hapticOnThreshold);

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
                stiffness: style.neighbourMotion.stiffness * multiplier,
                damping: style.neighbourMotion.damping,
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
      applyHaptic(style.hapticOnThreshold);

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
                stiffness: style.neighbourMotion.stiffness * multiplier,
                damping: style.neighbourMotion.damping,
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

    final swipingRight = _dragOffset > 0;
    final actionList = swipingRight
        ? style.actions
        : (style.secondaryActions ?? style.actions);

    final bool hasActions = actionList != null && actionList.isNotEmpty;

    if (hasActions) {
      final actionsWidth = _computeActionsWidth(actionList);
      if (_dragOffset.abs() >= actionsWidth * 0.35) {
        _snapToRevealed(actionsWidth * (swipingRight ? 1.0 : -1.0), speedMul);
      } else {
        _springBack(speedMul);
      }
    } else {
      if (_dragProgress >= 1.0) {
        final direction = swipingRight
            ? DismissDirection.startToEnd
            : DismissDirection.endToStart;
        _dismiss(_dragSlotIndex, speedMul, direction);
      } else {
        _springBack(speedMul);
      }
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
      _pastActionThreshold = false;
      _reEngaging = false;
      _roundnessFraction = 0.0;
    });
  }

  void _playPullHaptics() {
    if (!style.enableFeedback) return;
    if (_hapticStopwatch.elapsedMilliseconds < _kVibrationThresholdMs) return;
    _hapticStopwatch.reset();
    final progress = _dragProgress;
    final amplitude = 0.10 + (0.85 - 0.10) * progress;
    applyTypedHaptic('dragTexture', amplitude);
  }

  /// Toggles revealing or hiding actions for a card slot.
  void toggleRevealActions(DismissibleSlot slot, {bool endToStart = true}) {
    if (slot._status != _SlotStatus.visible) return;

    // If this slot is already revealed, close it
    if (_dragSlotRef == slot && _dragOffset.abs() > 0) {
      _springBack(1.0);
      return;
    }

    _springCtrl?.stop(canceled: true);
    _nbrCtrl?.stop(canceled: true);
    _pushCtrl?.stop(canceled: true);
    _roundnessCtrl?.stop(canceled: true);

    final actionList = endToStart
        ? (style.secondaryActions ?? style.actions)
        : style.actions;

    if (actionList == null || actionList.isEmpty) return;

    final actionsWidth = _computeActionsWidth(actionList);
    final targetOffset = actionsWidth * (endToStart ? -1.0 : 1.0);

    setState(() {
      _dragSlotRef = slot;
      _dragSlotIndex = _slots.indexOf(slot);
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _pastActionThreshold = false;
      _roundnessFraction = 0.0;
    });

    _snapToRevealed(targetOffset, 1.0);
  }

  /// Reveals action buttons for a card and automatically transfers keyboard focus to the first action button.
  void _revealAndFocusActions(
    DismissibleSlot slot, {
    required bool endToStart,
    required List<M3ESwipeAction> actionList,
  }) {
    if (slot._status != _SlotStatus.visible) return;

    final actionsWidth = _computeActionsWidth(actionList);
    final targetOffset = actionsWidth * (endToStart ? -1.0 : 1.0);

    _springCtrl?.stop(canceled: true);
    _nbrCtrl?.stop(canceled: true);
    _pushCtrl?.stop(canceled: true);
    _roundnessCtrl?.stop(canceled: true);

    setState(() {
      _dragSlotRef = slot;
      _dragSlotIndex = _slots.indexOf(slot);
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _pastActionThreshold = false;
      _roundnessFraction = 0.0;
    });

    _snapToRevealed(targetOffset, 1.0);

    // Automatically focus the first action button in the revealed set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && actionList.isNotEmpty) {
        final focusNode = slot.getActionFocusNode(0);
        focusNode.requestFocus();
      }
    });
  }

  /// Programmatically reveals or hides action buttons for the card at [index].
  void revealActionsAtIndex(int index, {bool endToStart = true}) {
    final visible = computeVisibleIndices();
    if (index >= 0 && index < visible.length) {
      final slot = _slots[visible[index]];
      toggleRevealActions(slot, endToStart: endToStart);
    }
  }

  /// Handles keyboard shortcuts when a card holds keyboard focus.
  KeyEventResult _handleCardKeyEvent(
    FocusNode node,
    KeyEvent event,
    DismissibleSlot slot,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final s = style;
    final slotIndex = _slots.indexOf(slot);
    if (slotIndex < 0) return KeyEventResult.ignored;

    // Alt/Option, Meta (Cmd), or Ctrl + Arrow Up/Left -> move backward (index - 1)
    // Alt/Option, Meta (Cmd), or Ctrl + Arrow Down/Right -> move forward (index + 1)
    final isModifier =
        HardwareKeyboard.instance.isAltPressed ||
        HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.alt) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.altLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.altRight,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.meta,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.metaLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.metaRight,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.control,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.controlLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.controlRight,
        );

    if (isModifier && slot.onReorderKey != null) {
      final visible = computeVisibleIndices();
      final visualPos = visible.indexOf(slotIndex);
      if (visualPos >= 0) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.physicalKey == PhysicalKeyboardKey.arrowUp ||
            event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
          slot.onReorderKey!(visualPos, false);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowRight ||
            event.physicalKey == PhysicalKeyboardKey.arrowDown ||
            event.physicalKey == PhysicalKeyboardKey.arrowRight) {
          slot.onReorderKey!(visualPos, true);
          return KeyEventResult.handled;
        }
      }
    }

    // Tab: if actions are open on this card, Tab moves focus directly into the action buttons
    if (event.logicalKey == LogicalKeyboardKey.tab &&
        !HardwareKeyboard.instance.isShiftPressed) {
      if (_dragSlotRef == slot &&
          (_dragOffset.abs() > 0 || _pastActionThreshold)) {
        final actionList = _dragOffset < 0
            ? (s.secondaryActions ?? s.actions)
            : s.actions;
        if (actionList != null && actionList.isNotEmpty) {
          slot.getActionFocusNode(0).requestFocus();
          return KeyEventResult.handled;
        }
      }
    }

    // Delete / Backspace: trigger dismissal (in pure dismiss mode) or reveal actions (in action buttons mode)
    if (event.logicalKey == LogicalKeyboardKey.delete ||
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (slot._status == _SlotStatus.visible &&
          s.direction != DismissDirection.none) {
        final endActions = s.secondaryActions ?? s.actions;
        if (endActions != null && endActions.isNotEmpty) {
          _revealAndFocusActions(
            slot,
            endToStart: true,
            actionList: endActions,
          );
          return KeyEventResult.handled;
        } else if (s.actions != null && s.actions!.isNotEmpty) {
          _revealAndFocusActions(
            slot,
            endToStart: false,
            actionList: s.actions!,
          );
          return KeyEventResult.handled;
        } else {
          final dir = s.direction == DismissDirection.startToEnd
              ? DismissDirection.startToEnd
              : DismissDirection.endToStart;
          _dismiss(slotIndex, 1.0, dir);
          return KeyEventResult.handled;
        }
      }
    }

    // Arrow Left: reveal end-to-start actions or move into revealed actions or dismiss left
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_dragSlotRef == slot && _dragOffset < 0 && _pastActionThreshold) {
        // Trailing actions are fully open: focus the action button
        final endActions = s.secondaryActions ?? s.actions;
        if (endActions != null && endActions.isNotEmpty) {
          slot.getActionFocusNode(0).requestFocus();
          return KeyEventResult.handled;
        }
      }
      if (s.direction != DismissDirection.none) {
        final endActions = s.secondaryActions ?? s.actions;
        if (endActions != null && endActions.isNotEmpty) {
          _revealAndFocusActions(
            slot,
            endToStart: true,
            actionList: endActions,
          );
          return KeyEventResult.handled;
        } else if (s.direction == DismissDirection.endToStart ||
            s.direction == DismissDirection.horizontal) {
          _dismiss(slotIndex, 1.0, DismissDirection.endToStart);
          return KeyEventResult.handled;
        }
      }
    }

    // Arrow Right: reveal start-to-end actions or move into revealed actions or dismiss right
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_dragSlotRef == slot && _dragOffset > 0 && _pastActionThreshold) {
        // Leading actions are fully open: focus the action button
        final startActions = s.actions;
        if (startActions != null && startActions.isNotEmpty) {
          slot.getActionFocusNode(0).requestFocus();
          return KeyEventResult.handled;
        }
      }
      if (s.direction != DismissDirection.none) {
        final startActions = s.actions;
        if (startActions != null && startActions.isNotEmpty) {
          _revealAndFocusActions(
            slot,
            endToStart: false,
            actionList: startActions,
          );
          return KeyEventResult.handled;
        } else if (s.direction == DismissDirection.startToEnd ||
            s.direction == DismissDirection.horizontal) {
          _dismiss(slotIndex, 1.0, DismissDirection.startToEnd);
          return KeyEventResult.handled;
        }
      }
    }

    // Escape: close revealed actions
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_dragSlotRef == slot && _dragOffset.abs() > 0) {
        _springBack(1.0);
        return KeyEventResult.handled;
      }
    }

    // Enter / Space: if actions are revealed, trigger primary action
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_dragSlotRef == slot && _dragOffset.abs() > 0) {
        final actionList = _dragOffset < 0
            ? (s.secondaryActions ?? s.actions)
            : s.actions;
        if (actionList != null && actionList.isNotEmpty) {
          final primary = actionList.firstWhere(
            (a) => a.isPrimary,
            orElse: () => actionList.last,
          );
          primary.onTap?.call();
          _springBack(1.0);
          return KeyEventResult.handled;
        }
      }
    }

    return KeyEventResult.ignored;
  }

  /// Handles keyboard shortcuts when an individual action button holds focus.
  KeyEventResult _handleActionButtonKeyEvent(
    FocusNode node,
    KeyEvent event,
    DismissibleSlot slot,
    int actionIndex,
    List<M3ESwipeAction> actionList,
    bool swipingRight,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final isShift =
        HardwareKeyboard.instance.isShiftPressed ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.shift,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.shiftLeft,
        ) ||
        HardwareKeyboard.instance.isLogicalKeyPressed(
          LogicalKeyboardKey.shiftRight,
        );

    // Tab / Shift+Tab: cycle through action buttons within this drawer
    if (event.logicalKey == LogicalKeyboardKey.tab ||
        event.physicalKey == PhysicalKeyboardKey.tab) {
      if (isShift) {
        if (actionIndex > 0) {
          slot.getActionFocusNode(actionIndex - 1).requestFocus();
        } else {
          slot.getActionFocusNode(actionList.length - 1).requestFocus();
        }
        return KeyEventResult.handled;
      } else {
        if (actionIndex < actionList.length - 1) {
          slot.getActionFocusNode(actionIndex + 1).requestFocus();
        } else {
          slot.getActionFocusNode(0).requestFocus();
        }
        return KeyEventResult.handled;
      }
    }

    // Enter or Space: Trigger this action
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      final action = actionList[actionIndex];
      action.haptic.apply();
      action.onTap?.call();
      _springBack(1.0);
      slot.focusNode.requestFocus();
      return KeyEventResult.handled;
    }

    // Escape: Close action drawer and focus back to card
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _springBack(1.0);
      slot.focusNode.requestFocus();
      return KeyEventResult.handled;
    }

    // Arrow Left / Shift + Arrow Left
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
      if (swipingRight) {
        // Leading actions (left side): navigate towards left outer edge
        if (actionIndex > 0) {
          slot.getActionFocusNode(actionIndex - 1).requestFocus();
        } else if (isShift) {
          slot.getActionFocusNode(actionList.length - 1).requestFocus();
        } else {
          _springBack(1.0);
          slot.focusNode.requestFocus();
        }
        return KeyEventResult.handled;
      } else {
        // Trailing actions (right side): navigate left towards inner actions
        if (actionIndex > 0) {
          slot.getActionFocusNode(actionIndex - 1).requestFocus();
        } else if (isShift) {
          slot.getActionFocusNode(actionList.length - 1).requestFocus();
        } else {
          _springBack(1.0);
          slot.focusNode.requestFocus();
        }
        return KeyEventResult.handled;
      }
    }

    // Arrow Right / Shift + Arrow Right
    if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.physicalKey == PhysicalKeyboardKey.arrowRight) {
      if (swipingRight) {
        // Leading actions: navigate right towards card
        if (actionIndex < actionList.length - 1) {
          slot.getActionFocusNode(actionIndex + 1).requestFocus();
        } else if (isShift) {
          slot.getActionFocusNode(0).requestFocus();
        } else {
          _springBack(1.0);
          slot.focusNode.requestFocus();
        }
        return KeyEventResult.handled;
      } else {
        // Trailing actions: navigate right towards outer edge or back to card
        if (actionIndex < actionList.length - 1) {
          slot.getActionFocusNode(actionIndex + 1).requestFocus();
        } else if (isShift) {
          slot.getActionFocusNode(0).requestFocus();
        } else {
          _springBack(1.0);
          slot.focusNode.requestFocus();
        }
        return KeyEventResult.handled;
      }
    }

    // Arrow Up / Down (without shift): close actions and let card handle reorder / navigation
    if ((event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) &&
        !isShift) {
      _springBack(1.0);
      slot.focusNode.requestFocus();
      return _handleCardKeyEvent(slot.focusNode, event, slot);
    }

    return KeyEventResult.ignored;
  }

  void _snapToRevealed(double targetOffset, double speedMul) {
    _targetOffset = targetOffset;
    _pushCtrl?.dispose();
    _pushCtrl = null;
    _detachPush = 0.0;
    _pastThreshold = false;
    _pastActionThreshold = true;
    _reEngaging = false;

    _springCtrl?.dispose();
    _springCtrl =
        SingleMotionController(
            motion: M3EMotion.custom(
              stiffness: style.snapBackMotion.stiffness * speedMul,
              damping: style.snapBackMotion.damping,
            ).toMotion(),
            vsync: this,
            initialValue: _dragOffset,
          )
          ..addListener(() {
            if (mounted) setState(() => _dragOffset = _springCtrl!.value);
          })
          ..animateTo(targetOffset);

    _nbrCtrl?.dispose();
    _nbrCtrl =
        SingleMotionController(
            motion: M3EMotion.custom(
              stiffness: style.snapBackMotion.stiffness * speedMul,
              damping: style.snapBackMotion.damping,
            ).toMotion(),
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
            motion: M3EMotion.custom(
              stiffness: style.snapBackMotion.stiffness * speedMul,
              damping: style.snapBackMotion.damping,
            ).toMotion(),
            vsync: this,
            initialValue: _roundnessFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _roundnessFraction = _roundnessCtrl!.value);
            }
          })
          ..animateTo(0.0);
  }

  double _computeActionsWidth(List<M3ESwipeAction> actionList) {
    if (actionList.isEmpty) return 0.0;
    double total = 0.0;
    for (final action in actionList) {
      total += action.width;
    }
    // Gaps between adjacent buttons plus gaps at both ends (outer edge and card edge)
    total += (actionList.length + 1) * style.actionSpacing;
    return total;
  }

  // ── Spring-back (below threshold release) ──

  void _springBack(double speedMul) {
    _targetOffset = 0.0;
    _pushCtrl?.dispose();
    _pushCtrl = null;
    _detachPush = 0.0;
    _pastThreshold = false;
    _pastActionThreshold = false;
    _reEngaging = false;

    final ref = _dragSlotRef;

    _springCtrl?.dispose();
    _springCtrl =
        SingleMotionController(
            motion: M3EMotion.custom(
              stiffness: style.snapBackMotion.stiffness * speedMul,
              damping: style.snapBackMotion.damping,
            ).toMotion(),
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
            motion: M3EMotion.custom(
              stiffness: style.snapBackMotion.stiffness * speedMul,
              damping: style.snapBackMotion.damping,
            ).toMotion(),
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
            motion: M3EMotion.custom(
              stiffness: style.snapBackMotion.stiffness * speedMul,
              damping: style.snapBackMotion.damping,
            ).toMotion(),
            vsync: this,
            initialValue: _roundnessFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _roundnessFraction = _roundnessCtrl!.value);
            }
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

    // Capture size & freeze the child before notifying consumer.
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
    _nbrCtrl?.dispose();
    _nbrCtrl = null;
    _roundnessCtrl?.dispose();
    _roundnessCtrl = null;

    setState(() {
      slot._status = _SlotStatus.collapsing;
      _collapsingCount++;
      _dragSlotRef = null;
      _dragSlotIndex = -1;
      _dragOffset = 0.0;
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _pastActionThreshold = false;
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

    colCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        if (mounted) {
          final idx = _slots.indexOf(slot);
          if (idx >= 0) {
            setState(() {
              _slots.removeAt(idx);
              _collapsingCount--;
              _reindexDragSlot();
            });
            _measureKeys.remove(slot);
          }
        }
        slot.disposeFlyNotifier();
        slot.dispose();
        colCtrl.dispose();
      }
    });

    // ── Fly-out spring ──
    final flySign = flyInitial.sign;
    final flyTarget = flySign == 0
        ? slot.capturedWidth + 80.0
        : flySign * (slot.capturedWidth + 80.0);

    slot.flyCtrl?.dispose();
    final flyCtrl = SingleMotionController(
      motion: M3EMotion.custom(
        stiffness: style.flyMotion.stiffness * speedMul,
        damping: style.flyMotion.damping,
      ).toMotion(),
      vsync: this,
      initialValue: flyInitial,
    );
    slot.flyCtrl = flyCtrl;
    bool collapseStarted = false;
    flyCtrl
      ..addListener(() {
        slot.flyNotifier.value = flyCtrl.value;

        // Start collapse as soon as the card is 90% of the way to the target
        // to avoid waiting for the spring to fully settle.
        final totalDist = (flyTarget - flyInitial).abs();
        if (totalDist > 0) {
          final currentDist = (flyCtrl.value - flyInitial).abs();
          if (currentDist / totalDist > 0.9 && !collapseStarted) {
            collapseStarted = true;
            colCtrl.animateTo(1.0);
          }
        }
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
          slot.flyCtrl = null;
          flyCtrl.dispose();
          // Safety check: ensure collapse starts if it didn't already
          if (!collapseStarted) {
            collapseStarted = true;
            colCtrl.animateTo(1.0);
          }
        }
      })
      ..animateTo(flyTarget);

    // ── Auto-execute primary action on full swipe if configured ──
    if (style.autoExecutePrimaryOnFullSwipe) {
      final swipingRight = direction == DismissDirection.startToEnd;
      final actionList = swipingRight
          ? style.actions
          : (style.secondaryActions ?? style.actions);
      if (actionList != null && actionList.isNotEmpty) {
        final primary = actionList.firstWhere(
          (a) => a.isPrimary,
          orElse: () => actionList.last,
        );
        primary.onTap?.call();
      }
    }

    // ── Ask the consumer if dismissal is allowed ──
    final allowed = await onDismissCallback?.call(dataIndex, direction) ?? true;
    if (!allowed) {
      flyCtrl.dispose();
      slot.flyCtrl = null;
      colCtrl.dispose();
      slot.collapseCtrl = null;
      slot.frozenChild = null;
      if (mounted) {
        setState(() {
          slot._status = _SlotStatus.visible;
          _collapsingCount--;
        });
        _syncSlots();
      }
      _springBack(speedMul);
      return;
    }
  }

  // ── Widget builders ──

  /// Dispatches to either [_buildActiveCard] or [_buildCollapsingCard].
  ///
  /// Pass a pre-computed [visible] list to avoid recomputing
  /// [computeVisibleIndices] once per slot.
  Widget buildSlot(
    BuildContext context,
    int slotIndex, [
    List<int>? visible,
    int? visualIndexOverride,
  ]) {
    final slot = _slots[slotIndex];
    if (slot.isCollapsing) {
      return _buildCollapsingCard(context, slotIndex);
    }
    return _buildActiveCard(
      context,
      slotIndex,
      visible ?? computeVisibleIndices(),
      visualIndexOverride,
    );
  }

  Widget _buildCollapsingCard(BuildContext context, int slotIndex) {
    final slot = _slots[slotIndex];
    final ctrl = slot.collapseCtrl!;
    final totalH = slot.capturedHeight + style.gap;
    final s = style;
    // Use the stored dismiss direction — _dragOffset belongs to any currently
    // active drag on a *different* slot and would give the wrong side.
    final bool swipingRight =
        slot.dismissedDirection == DismissDirection.startToEnd;
    final bgRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);
    final cardRadius = s.selectedBorderRadius ?? s.outerRadius;

    final List<M3ESwipeAction>? activeActions = swipingRight
        ? s.actions
        : (s.secondaryActions ?? s.actions);
    final Widget? effectiveBg =
        activeActions != null && activeActions.isNotEmpty
        ? _buildActionsRow(slot, activeActions, 1.0, swipingRight)
        : (swipingRight
              ? s.background
              : (s.secondaryBackground ?? s.background));

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ctrl,
        // The Stack is built once and passed as a stable child — only the
        // SizedBox height wrapper is rebuilt on every animation tick.
        child: slot.frozenChild == null
            ? null
            : Stack(
                children: [
                  // ── Background (stays visible during fly-out) ──
                  if (slot.dismissedDirection != null && effectiveBg != null)
                    ValueListenableBuilder<double>(
                      valueListenable: slot.flyNotifier,
                      builder: (_, flyOff, child) {
                        final progress = flyOff.abs();
                        final swipingRight =
                            slot.dismissedDirection ==
                            DismissDirection.startToEnd;
                        return Positioned.fill(
                          bottom: s.gap,
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
                                  borderRadius: BorderRadius.circular(bgRadius),
                                  child: effectiveBg,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // ── Flying card ──
                  Padding(
                    padding: EdgeInsets.only(bottom: s.gap),
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      minWidth: slot.capturedWidth > 0 ? slot.capturedWidth : 0,
                      maxWidth: slot.capturedWidth > 0
                          ? slot.capturedWidth
                          : MediaQuery.sizeOf(context).width,
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
                              borderRadius: BorderRadius.circular(cardRadius),
                              color:
                                  s.color ??
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                              elevation: s.elevation > 0
                                  ? s.elevation + 6
                                  : 0.0,
                              boxShadow: s.boxShadow,
                              border: s.border,
                              padding: s.padding ?? const EdgeInsets.all(16),
                              child: slot.frozenChild!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        builder: (ctx, child) {
          final h = (totalH * (1.0 - ctrl.value)).clamp(0.0, totalH);
          return SizedBox(height: h, width: double.infinity, child: child);
        },
      ),
    );
  }

  Widget _buildActiveCard(
    BuildContext context,
    int slotIndex,
    List<int> visible, [
    int? visualIndexOverride,
  ]) {
    final slot = _slots[slotIndex];
    final s = style;
    final slotPos = visible.indexOf(slotIndex);
    if (slotPos < 0 || slotPos >= swipeItemCount) {
      return const SizedBox.shrink();
    }

    final total = visible.length;
    final isLast = (visualIndexOverride ?? slotPos) == total - 1;
    final isDragged = slotIndex == _dragSlotIndex;
    final dragPos = _dragSlotIndex >= 0 ? visible.indexOf(_dragSlotIndex) : -1;
    final br = computeRadius(
      slotIndex,
      slotPos,
      dragPos,
      visible,
      visualIndexOverride,
    );
    final nOff = computeNeighbourOffset(slotPos, dragPos);

    // Active background based on swipe direction.
    final bool swipingRight = _dragOffset != 0
        ? _dragOffset > 0
        : _targetOffset > 0;
    final List<M3ESwipeAction>? activeActions = swipingRight
        ? s.actions
        : (s.secondaryActions ?? s.actions);

    final Widget? activeBg = activeActions != null && activeActions.isNotEmpty
        ? _buildActionsRow(slot, activeActions, _dragProgress, swipingRight)
        : (swipingRight
              ? s.background
              : (s.secondaryBackground ?? s.background));

    final borderRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);

    final actionW = (activeActions != null && activeActions.isNotEmpty)
        ? _computeActionsWidth(activeActions)
        : 0.0;
    final bgW =
        (_dragOffset != 0
                ? _dragOffset.abs()
                : (_pastActionThreshold ? actionW : 0.0))
            .clamp(0.0, double.infinity);

    return RepaintBoundary(
      child: Padding(
        padding: s.margin ?? EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Expanding pill background ──
            if (isDragged &&
                (_dragOffset != 0 || _pastActionThreshold) &&
                activeBg != null)
              Positioned.fill(
                bottom: isLast ? 0 : s.gap,
                child: RepaintBoundary(
                  child: Align(
                    alignment: swipingRight
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: activeActions != null && activeActions.isNotEmpty
                        ? SizedBox(
                            width: bgW,
                            height: double.infinity,
                            child: activeBg,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: SizedBox(
                              width: bgW,
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
            Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : s.gap),
              child: Transform.translate(
                offset: Offset(isDragged ? _dragOffset + _detachPush : nOff, 0),
                child: GestureDetector(
                  onHorizontalDragStart: s.direction == DismissDirection.none
                      ? null
                      : (_) => handleDragStart(slot),
                  onHorizontalDragUpdate: s.direction == DismissDirection.none
                      ? null
                      : handleDragUpdate,
                  onHorizontalDragEnd: s.direction == DismissDirection.none
                      ? null
                      : handleDragEnd,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: slot.isFocusedNotifier,
                    builder: (context, isFocused, cardChild) {
                      return DismissibleFocusRing(
                        focused: isFocused,
                        radius: br,
                        color: s.focusRingColor,
                        gap: s.focusRingGap,
                        width: s.focusRingWidth,
                        child: cardChild!,
                      );
                    },
                    child: _AnimatedCard(
                      key: ValueKey('card_${slot.identity.hashCode}'),
                      cardKey: _measureKey(slot),
                      borderRadius: br,
                      color:
                          s.color ??
                          Theme.of(context).colorScheme.surfaceContainer,
                      elevation: (isDragged && s.elevation > 0)
                          ? s.elevation + 6
                          : s.elevation,
                      boxShadow: s.boxShadow,
                      border: s.border,
                      isDragged: isDragged,
                      hasActiveDrag: _dragSlotRef != null,
                      child: Listener(
                        onPointerDown: (_) {
                          if (s.pressedScale != null && s.pressedScale != 1.0) {
                            slot.isPressedNotifier.value = true;
                          }
                        },
                        onPointerUp: (_) {
                          if (s.pressedScale != null && s.pressedScale != 1.0) {
                            slot.isPressedNotifier.value = false;
                          }
                        },
                        onPointerCancel: (_) {
                          if (s.pressedScale != null && s.pressedScale != 1.0) {
                            slot.isPressedNotifier.value = false;
                          }
                        },
                        child: InkWell(
                          focusNode: slot.focusNode,
                          onFocusChange: (focused) {
                            slot.isFocusedNotifier.value = focused;
                          },
                          splashColor: s.splashColor,
                          highlightColor: s.highlightColor,
                          splashFactory:
                              s.splashFactory ?? InkSparkle.splashFactory,
                          enableFeedback: s.enableFeedback,
                          onTap: () {
                            if (_dragSlotRef != null && _dragOffset.abs() > 0) {
                              _springBack(1.0);
                              return;
                            }
                            if (s.actionRevealTrigger ==
                                M3EActionRevealTrigger.tap) {
                              final actionList =
                                  s.secondaryActions ?? s.actions;
                              if (actionList != null && actionList.isNotEmpty) {
                                toggleRevealActions(slot, endToStart: true);
                                return;
                              }
                            }
                            if (isInteractionLocked || onTapCallback == null) {
                              return;
                            }
                            onTapCallback!(slotPos);
                            applyHaptic(s.hapticOnTap);
                          },
                          onDoubleTap:
                              s.actionRevealTrigger ==
                                  M3EActionRevealTrigger.doubleTap
                              ? () =>
                                    toggleRevealActions(slot, endToStart: true)
                              : null,
                          onLongPress:
                              s.actionRevealTrigger ==
                                  M3EActionRevealTrigger.longPress
                              ? () =>
                                    toggleRevealActions(slot, endToStart: true)
                              : null,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: slot.isPressedNotifier,
                            builder: (context, isPressed, _) {
                              return _buildPressScaledContent(
                                s,
                                isDragged: isDragged,
                                isPressed: isPressed,
                                child: Padding(
                                  padding:
                                      s.padding ?? const EdgeInsets.all(16.0),
                                  child: swipeItemBuilder(context, slotPos),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Background helpers ──

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
        child: wrapChild(bg.child),
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

  Widget _buildPressScaledContent(
    M3EDismissibleCardStyle s, {
    required bool isDragged,
    required bool isPressed,
    required Widget child,
  }) {
    if (s.pressedScale == null || s.pressedScale == 1.0) {
      return child;
    }

    final motion = s.pressedMotion.toMotion();
    final targetScale = s.pressedScale!;

    return SingleMotionBuilder(
      motion: motion,
      value: (isPressed && !isDragged) ? targetScale : 1.0,
      builder: (context, animatedScale, _) {
        return Transform.scale(scale: animatedScale, child: child);
      },
    );
  }

  Widget _buildActionsRow(
    DismissibleSlot slot,
    List<M3ESwipeAction> actionList,
    double progress,
    bool swipingRight,
  ) {
    final s = style;
    final baseWidth = _computeActionsWidth(actionList);
    final currentOffset = _pastActionThreshold
        ? math.max(_dragOffset.abs(), baseWidth)
        : _dragOffset.abs();
    final numActions = actionList.length;

    // Fixed spacing between action buttons
    final double spacing = s.actionSpacing;

    // Dynamic width expansion distributed to action buttons on overdrag
    final double overdrag = (currentOffset > baseWidth && baseWidth > 0)
        ? (currentOffset - baseWidth)
        : 0.0;
    final double extraWidthPerButton = numActions > 0
        ? ((overdrag / numActions) * 0.75).clamp(0.0, 48.0)
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight.clamp(36.0, 300.0)
            : 64.0;

        return Container(
          color: Colors.transparent,
          alignment: swipingRight
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: OverflowBox(
            alignment: swipingRight
                ? Alignment.centerLeft
                : Alignment.centerRight,
            minWidth: 0,
            maxWidth: double.infinity,
            minHeight: 0,
            maxHeight: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: FocusTraversalGroup(
                policy: WidgetOrderTraversalPolicy(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: swipingRight
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actionList.length; i++) ...[
                      if (i > 0 && spacing > 0) SizedBox(width: spacing),
                      () {
                        final orderIndex = swipingRight
                            ? i
                            : (actionList.length - 1 - i);
                        final action = actionList[i];
                        final targetWidth = action.width;

                        // Staggered reveal window for each button
                        final startOffset =
                            orderIndex * (targetWidth * 0.7 + spacing);
                        final endOffset = startOffset + targetWidth + 12.0;

                        final double buttonProgress =
                            (currentOffset <= startOffset)
                            ? 0.0
                            : (currentOffset >= endOffset)
                            ? 1.0
                            : ((currentOffset - startOffset) /
                                      (endOffset - startOffset))
                                  .clamp(0.0, 1.0);

                        final double pillWidth =
                            (targetWidth * (0.2 + 0.8 * buttonProgress) +
                                    extraWidthPerButton)
                                .clamp(0.0, targetWidth + 48.0);

                        final actionFocusNode = slot.getActionFocusNode(i);
                        final double buttonHeight =
                            action.height ??
                            math.max(28.0, availableHeight - 8.0);

                        return Opacity(
                          opacity: buttonProgress.clamp(0.0, 1.0),
                          child: Center(
                            child: SizedBox(
                              width: pillWidth,
                              height: buttonHeight,
                              child: action.buildButton(
                                context,
                                focusNode: actionFocusNode,
                                onKeyEvent: (node, event) =>
                                    _handleActionButtonKeyEvent(
                                      node,
                                      event,
                                      slot,
                                      i,
                                      actionList,
                                      swipingRight,
                                    ),
                                onTriggered: () {
                                  _springBack(1.0);
                                },
                              ),
                            ),
                          ),
                        );
                      }(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AnimatedCard — the foreground card with animated decoration
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedCard extends StatefulWidget {
  final GlobalKey cardKey;
  final BorderRadius borderRadius;
  final Color color;
  final double elevation;
  final List<BoxShadow>? boxShadow;
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
    this.boxShadow,
    required this.isDragged,
    required this.hasActiveDrag,
    this.border,
    required this.child,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  late BoxDecoration _decoration;

  @override
  void initState() {
    super.initState();
    _decoration = _buildDecoration();
  }

  @override
  void didUpdateWidget(_AnimatedCard old) {
    super.didUpdateWidget(old);
    // Only rebuild the BoxDecoration when the visual inputs actually change.
    // During drag, only ~3 cards (dragged + immediate neighbours) change their
    // borderRadius — the other 17 reuse the cached decoration, eliminating
    // ~17 BoxShadow / Color allocations per frame.
    if (old.color != widget.color ||
        old.borderRadius != widget.borderRadius ||
        old.elevation != widget.elevation ||
        old.isDragged != widget.isDragged ||
        old.border != widget.border ||
        old.boxShadow != widget.boxShadow) {
      _decoration = _buildDecoration();
    }
  }

  BoxDecoration _buildDecoration() {
    final List<BoxShadow>? effectiveShadow;
    if (widget.boxShadow != null) {
      effectiveShadow = widget.boxShadow;
    } else if (widget.elevation <= 0) {
      effectiveShadow = const [];
    } else {
      effectiveShadow = [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: 0.06 + widget.elevation * 0.015,
          ),
          blurRadius: 4 + widget.elevation * 2,
          spreadRadius: widget.isDragged ? 1 : 0,
          offset: Offset(0, widget.isDragged ? 4 : 2),
        ),
      ];
    }

    return BoxDecoration(
      color: widget.color,
      borderRadius: widget.borderRadius,
      boxShadow: effectiveShadow,
      border: widget.border != null
          ? Border.all(color: widget.border!.color, width: widget.border!.width)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      duration: widget.hasActiveDrag
          ? Duration.zero
          : const Duration(milliseconds: 520),
      curve: _kCardSettleCurve,
      decoration: _decoration,
      clipBehavior: Clip.antiAlias,
      child: Material(
        key: widget.cardKey,
        color: Colors.transparent,
        child: widget.child,
      ),
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
  final List<BoxShadow>? boxShadow;
  final BorderSide? border;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _FlyingCard({
    super.key,
    required this.borderRadius,
    required this.color,
    required this.elevation,
    this.boxShadow,
    this.border,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow>? effectiveShadow;
    if (boxShadow != null) {
      effectiveShadow = boxShadow;
    } else if (elevation <= 0) {
      effectiveShadow = const [];
    } else {
      effectiveShadow = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06 + elevation * 0.015),
          blurRadius: 4 + elevation * 2,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ];
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: effectiveShadow,
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
