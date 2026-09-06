// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../common/m3e_common.dart';
import 'm3e_dismissible_card_controller.dart';
import 'm3e_dismissible_card_style.dart';

/// A Material 3 Expressive list that seamlessly combines spring-physics reordering
/// (dynamic placeholder slot, bouncy spring neighbor displacement, smooth snap settling)
/// with horizontal swipe-to-dismiss and action reveal capabilities.
///
/// Interaction:
/// - Horizontal drag swipes and reveals actions / dismisses items with spring fly-out and collapsing.
/// - Vertical long-press drag (or drag handle) reorders items with spring-driven neighbor shifts.
class M3EReorderableDismissibleList extends StatefulWidget {
  /// Number of data items.
  final int itemCount;

  /// Builds content for the item at the given index.
  final IndexedWidgetBuilder itemBuilder;

  /// Generates a stable key for each item to preserve state across reorders and dismissals.
  final Key Function(int index)? keyBuilder;

  /// Called when an item moves to a new position.
  final ReorderCallback onReorder;

  /// Called when a swipe exceeds the dismiss threshold.
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;

  /// Called on tap (blocked while a drag, dismiss, or reorder is in-flight).
  final void Function(int index)? onTap;

  /// Visual and interaction configuration for the dismissible cards.
  final M3EDismissibleCardStyle style;

  /// Scroll controller for the underlying list.
  final ScrollController? scrollController;

  /// Standard [ListView] scroll physics.
  final ScrollPhysics? physics;

  /// Outer padding applied around the entire list.
  final EdgeInsetsGeometry? listPadding;

  /// Margin applied around the outside of the list container.
  final EdgeInsetsGeometry? margin;

  /// Whether the list should shrink-wrap its contents.
  final bool shrinkWrap;

  /// Clip behavior for the list view.
  final Clip clipBehavior;

  /// Whether to build default trailing drag handle icons ([Icons.drag_handle_rounded]).
  final bool buildDefaultDragHandles;

  /// Visual elevation applied to the item when it is being dragged for reordering.
  final double dragElevation;

  /// Scale multiplier applied to the item when it is being dragged for reordering.
  final double dragScale;

  /// Border radius applied to the dragged item during reordering.
  final BorderRadius? dragBorderRadius;

  /// Background color applied to the dragged item proxy while reordering.
  final Color? dragColor;

  /// Background color for the reorder drop target placeholder slot container.
  final Color? dragPlaceholderColor;

  /// Border outline for the reorder drop target placeholder slot container.
  final BorderSide? dragPlaceholderBorder;

  /// Corner radius for the reorder drop target placeholder slot container.
  final double? dragPlaceholderRadius;

  /// Optional custom builder for the reorder drop target placeholder slot container.
  final Widget Function(BuildContext context, int index, Size size)?
  dragPlaceholderBuilder;

  /// Spring motion used for reorder settling and neighbor shifts.
  ///
  /// Defaults to [M3EMotion.expressiveSpatialFast].
  final M3EMotion reorderMotion;

  /// Builder displayed when there are no items to show and no collapsing animations running.
  final WidgetBuilder? emptyBuilder;

  const M3EReorderableDismissibleList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onReorder,
    this.keyBuilder,
    this.onDismiss,
    this.onTap,
    this.style = const M3EDismissibleCardStyle(),
    this.scrollController,
    this.physics,
    this.listPadding,
    this.margin,
    this.shrinkWrap = false,
    this.clipBehavior = Clip.hardEdge,
    this.buildDefaultDragHandles = false,
    this.dragElevation = 8.0,
    this.dragScale = 1.0,
    this.dragBorderRadius,
    this.dragColor,
    this.dragPlaceholderColor,
    this.dragPlaceholderBorder,
    this.dragPlaceholderRadius,
    this.dragPlaceholderBuilder,
    this.reorderMotion = M3EMotion.expressiveSpatialFast,
    this.emptyBuilder,
  });

  @override
  State<M3EReorderableDismissibleList> createState() =>
      _M3EReorderableDismissibleListState();
}

class _M3EReorderableDismissibleListState
    extends State<M3EReorderableDismissibleList>
    with TickerProviderStateMixin, M3EDismissibleCardMixin {
  // ── M3EDismissibleCardMixin interface ──

  @override
  int get swipeItemCount => widget.itemCount;

  @override
  Widget swipeItemBuilder(BuildContext context, int dataIndex) {
    Widget item = widget.itemBuilder(context, dataIndex);
    if (widget.buildDefaultDragHandles) {
      item = Row(
        children: [
          Expanded(child: item),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.drag_handle_rounded),
          ),
        ],
      );
    }
    return item;
  }

  @override
  M3EDismissibleCardStyle get style => widget.style;

  @override
  Future<bool> Function(int, DismissDirection)? get onDismissCallback =>
      widget.onDismiss;

  @override
  void Function(int)? get onTapCallback => widget.onTap;

  // ── Reorder State & Physics (consistent with M3EReorderableSegmentedList) ──

  final GlobalKey _stackKey = GlobalKey();
  final ValueNotifier<int?> _draggedIndexNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<int?> _targetIndexNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<Offset> _pointerOffsetNotifier = ValueNotifier<Offset>(
    Offset.zero,
  );
  final ValueNotifier<bool> _isSettlingNotifier = ValueNotifier<bool>(false);

  Offset _dragItemOrigin = Offset.zero;
  double _grabOffsetY = 30.0;
  double _dragItemHeight = 60.0;
  double _dragItemWidth = 300.0;

  final Map<int, GlobalKey> _reorderItemKeys = {};
  final Map<int, SingleMotionController> _shiftControllers = {};
  final Map<int, double> _targetShifts = {};

  late final SingleMotionController _proxyLiftCtrl;
  late final SingleMotionController _snapMotionCtrl;
  Offset _snapStartOffset = Offset.zero;
  Offset _snapTargetOffset = Offset.zero;
  double _dragStartScrollOffset = 0.0;

  late ScrollController _internalScrollController;
  ScrollController get _effectiveScrollController =>
      widget.scrollController ?? _internalScrollController;

  @override
  void initState() {
    super.initState();
    initSlots();
    _internalScrollController = ScrollController();
    _proxyLiftCtrl = SingleMotionController(
      motion: widget.reorderMotion.toMotion(),
      vsync: this,
    );
    _snapMotionCtrl = SingleMotionController(
      motion: widget.reorderMotion.toMotion(),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(M3EReorderableDismissibleList old) {
    super.didUpdateWidget(old);
    syncSlotsIfNeeded(old.itemCount);
    _proxyLiftCtrl.motion = widget.reorderMotion.toMotion();
    _snapMotionCtrl.motion = widget.reorderMotion.toMotion();

    _shiftControllers.removeWhere((idx, ctrl) {
      if (idx >= widget.itemCount) {
        ctrl.dispose();
        return true;
      }
      return false;
    });

    if (widget.itemCount != old.itemCount) {
      if (_isSettlingNotifier.value || _draggedIndexNotifier.value != null) {
        _cleanupDragState();
      }
    }
  }

  @override
  void dispose() {
    _proxyLiftCtrl.dispose();
    _snapMotionCtrl.dispose();
    for (final ctrl in _shiftControllers.values) {
      ctrl.dispose();
    }
    _shiftControllers.clear();
    _internalScrollController.dispose();
    _draggedIndexNotifier.dispose();
    _targetIndexNotifier.dispose();
    _pointerOffsetNotifier.dispose();
    _isSettlingNotifier.dispose();
    disposeSlots();
    super.dispose();
  }

  // ── Keyboard Reordering & Viewport Scrolling ──

  int? _pendingKeyboardFocusIndex;

  void _scrollToItemIfNeeded(int index) {
    if (!_effectiveScrollController.hasClients) return;
    if (!_effectiveScrollController.position.hasContentDimensions) return;
    if (_effectiveScrollController.position.maxScrollExtent <= 0) return;

    final itemBox =
        _reorderItemKeys[index]?.currentContext?.findRenderObject()
            as RenderBox?;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final listRenderBox =
        (stackBox ?? context.findRenderObject()) as RenderBox?;

    if (itemBox == null || listRenderBox == null) return;

    final itemOffsetInList = listRenderBox.globalToLocal(
      itemBox.localToGlobal(Offset.zero),
    );
    final viewportHeight = listRenderBox.size.height;
    final itemHeight = itemBox.size.height;
    final currentScroll = _effectiveScrollController.offset;
    final maxScroll = _effectiveScrollController.position.maxScrollExtent;

    double? targetScroll;
    const double margin = 16.0;

    if (itemOffsetInList.dy < margin) {
      targetScroll = (currentScroll + itemOffsetInList.dy - margin).clamp(
        0.0,
        maxScroll,
      );
    } else if (itemOffsetInList.dy + itemHeight > viewportHeight - margin) {
      final overflow =
          (itemOffsetInList.dy + itemHeight) - (viewportHeight - margin);
      targetScroll = (currentScroll + overflow).clamp(0.0, maxScroll);
    }

    if (targetScroll != null && (targetScroll - currentScroll).abs() > 1.0) {
      _effectiveScrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handleKeyboardReorder(int index, bool moveForward) {
    final visible = computeVisibleIndices();
    final targetIndex = moveForward ? index + 1 : index - 1;
    if (targetIndex >= 0 && targetIndex < visible.length) {
      _pendingKeyboardFocusIndex = targetIndex;
      final reorderTo = targetIndex > index ? targetIndex + 1 : targetIndex;
      widget.onReorder(index, reorderTo);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pendingKeyboardFocusIndex != null) {
          final targetIdx = _pendingKeyboardFocusIndex!;
          _pendingKeyboardFocusIndex = null;
          final visibleAfter = computeVisibleIndices();
          if (targetIdx >= 0 && targetIdx < visibleAfter.length) {
            final slot = slots[visibleAfter[targetIdx]];
            slot.focusNode.requestFocus();
          }
          _scrollToItemIfNeeded(targetIdx);
        }
      });
    }
  }

  // ── Reorder Controllers & Gestures ──

  SingleMotionController _getOrCreateShiftController(int index) {
    if (!_shiftControllers.containsKey(index)) {
      final ctrl = SingleMotionController(
        motion: widget.reorderMotion.toMotion(),
        vsync: this,
      );
      _shiftControllers[index] = ctrl;
    }
    return _shiftControllers[index]!;
  }

  Drag? _handleReorderDragStart(int index, Offset globalPos) {
    if (_isSettlingNotifier.value ||
        _draggedIndexNotifier.value != null ||
        isInteractionLocked) {
      return null;
    }
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final renderBox = (stackBox ?? context.findRenderObject()) as RenderBox?;
    if (renderBox == null) return null;

    final itemKey = _reorderItemKeys[index];
    final itemBox = itemKey?.currentContext?.findRenderObject() as RenderBox?;
    final itemLocalOrigin = itemBox != null
        ? renderBox.globalToLocal(itemBox.localToGlobal(Offset.zero))
        : Offset.zero;

    final touchLocal = renderBox.globalToLocal(globalPos);
    final rawItemHeight = itemBox?.size.height ?? 60.0;
    final effectiveGap = widget.style.gap;
    final isLastItem = index == widget.itemCount - 1;

    _dragItemHeight = isLastItem
        ? rawItemHeight
        : (rawItemHeight - effectiveGap).clamp(0.0, double.infinity);
    _dragItemWidth = itemBox?.size.width ?? renderBox.size.width;
    _dragItemOrigin = itemLocalOrigin;
    _dragStartScrollOffset = _effectiveScrollController.hasClients
        ? _effectiveScrollController.offset
        : 0.0;
    _grabOffsetY = (touchLocal.dy - itemLocalOrigin.dy).clamp(
      0.0,
      _dragItemHeight,
    );
    _pointerOffsetNotifier.value = touchLocal;

    _draggedIndexNotifier.value = index;
    _targetIndexNotifier.value = index;

    if (widget.style.enableFeedback) {
      HapticFeedback.mediumImpact();
    }

    _proxyLiftCtrl.stop();
    _snapMotionCtrl.stop();
    _snapMotionCtrl.value = 0.0;
    for (final ctrl in _shiftControllers.values) {
      ctrl.stop();
      ctrl.value = 0.0;
    }

    _proxyLiftCtrl.value = 0.0;
    _proxyLiftCtrl.animateTo(1.0);
    _targetShifts.clear();
    _updateShifts();

    return _M3EReorderDrag(
      onUpdate: _handleReorderDragUpdate,
      onEnd: _handleReorderDragEnd,
      onCancel: () => _handleReorderDragEnd(null),
    );
  }

  void _handleReorderDragUpdate(Offset globalPos) {
    if (_draggedIndexNotifier.value == null || _isSettlingNotifier.value) {
      return;
    }
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final renderBox = (stackBox ?? context.findRenderObject()) as RenderBox?;
    if (renderBox == null) return;

    final localPos = renderBox.globalToLocal(globalPos);
    _pointerOffsetNotifier.value = localPos;

    // Auto-scroll near edges
    if (_effectiveScrollController.hasClients) {
      const double edgeThreshold = 50.0;
      if (localPos.dy < edgeThreshold &&
          _effectiveScrollController.offset > 0) {
        _effectiveScrollController.animateTo(
          (_effectiveScrollController.offset - 15.0).clamp(
            0.0,
            _effectiveScrollController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 30),
          curve: Curves.linear,
        );
      } else if (localPos.dy > renderBox.size.height - edgeThreshold &&
          _effectiveScrollController.offset <
              _effectiveScrollController.position.maxScrollExtent) {
        _effectiveScrollController.animateTo(
          (_effectiveScrollController.offset + 15.0).clamp(
            0.0,
            _effectiveScrollController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 30),
          curve: Curves.linear,
        );
      }
    }

    // Determine target index
    final draggedCenterY = localPos.dy - _grabOffsetY + (_dragItemHeight / 2.0);
    int bestTarget = _draggedIndexNotifier.value!;
    double closestDist = double.infinity;
    final effectiveGap = widget.style.gap;

    for (int i = 0; i < widget.itemCount; i++) {
      final key = _reorderItemKeys[i];
      final box = key?.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final origin = renderBox.globalToLocal(box.localToGlobal(Offset.zero));
        final centerY = origin.dy + (box.size.height / 2.0);
        final dist = (draggedCenterY - centerY).abs();
        if (dist < closestDist) {
          closestDist = dist;
          bestTarget = i;
        }
      } else {
        final estimatedY =
            _dragItemOrigin.dy +
            (i - _draggedIndexNotifier.value!) *
                (_dragItemHeight + effectiveGap) +
            (_dragItemHeight / 2.0);
        final dist = (draggedCenterY - estimatedY).abs();
        if (dist < closestDist) {
          closestDist = dist;
          bestTarget = i;
        }
      }
    }

    if (bestTarget != _targetIndexNotifier.value) {
      _targetIndexNotifier.value = bestTarget;
      _updateShifts();
      HapticFeedback.selectionClick();
    }
  }

  void _updateShifts() {
    final from = _draggedIndexNotifier.value;
    final to = _targetIndexNotifier.value;
    if (from == null || to == null) {
      for (final i in _shiftControllers.keys) {
        if ((_targetShifts[i] ?? 0.0) != 0.0) {
          _targetShifts[i] = 0.0;
          _shiftControllers[i]?.animateTo(0.0);
        }
      }
      return;
    }

    final effectiveGap = widget.style.gap;
    final shiftAmount = _dragItemHeight + effectiveGap;

    for (int i = 0; i < widget.itemCount; i++) {
      if (i == from) {
        if ((_targetShifts[i] ?? 0.0) != 0.0) {
          _targetShifts[i] = 0.0;
          _shiftControllers[i]?.animateTo(0.0);
        }
        continue;
      }

      double targetShift = 0.0;
      if (from < to && i > from && i <= to) {
        targetShift = -shiftAmount;
      } else if (from > to && i >= to && i < from) {
        targetShift = shiftAmount;
      }

      if ((_targetShifts[i] ?? 0.0) != targetShift) {
        _targetShifts[i] = targetShift;
        _getOrCreateShiftController(i).animateTo(targetShift);
      }
    }
  }

  void _cleanupDragState() {
    for (final ctrl in _shiftControllers.values) {
      ctrl.stop();
      ctrl.value = 0.0;
    }
    _targetShifts.clear();
    _draggedIndexNotifier.value = null;
    _targetIndexNotifier.value = null;
    _isSettlingNotifier.value = false;
  }

  void _handleReorderDragEnd([DragEndDetails? details]) {
    final from = _draggedIndexNotifier.value;
    if (from == null || _isSettlingNotifier.value) return;

    final to = _targetIndexNotifier.value ?? from;
    final effectiveGap = widget.style.gap;
    final shiftAmount = _dragItemHeight + effectiveGap;

    final double currentLiftT = _proxyLiftCtrl.value.clamp(0.0, 1.0);
    const double kLiftShiftX = 12.0;
    const double kLiftShiftY = 12.0;
    _snapStartOffset = Offset(
      _dragItemOrigin.dx + (kLiftShiftX * currentLiftT),
      _pointerOffsetNotifier.value.dy -
          _grabOffsetY +
          (kLiftShiftY * currentLiftT),
    );

    final renderBox = context.findRenderObject() as RenderBox?;
    final viewportHeight = renderBox?.size.height ?? double.infinity;

    final currentScrollOffset = _effectiveScrollController.hasClients
        ? _effectiveScrollController.offset
        : 0.0;
    final scrollDelta = currentScrollOffset - _dragStartScrollOffset;

    final slotToViewportDy =
        _dragItemOrigin.dy + ((to - from) * shiftAmount) - scrollDelta;
    double destinationDy = slotToViewportDy;

    if (_effectiveScrollController.hasClients &&
        viewportHeight.isFinite &&
        _effectiveScrollController.position.hasContentDimensions) {
      double? targetScrollOffset;
      if (slotToViewportDy < 0) {
        targetScrollOffset =
            (currentScrollOffset + slotToViewportDy - effectiveGap).clamp(
              0.0,
              _effectiveScrollController.position.maxScrollExtent,
            );
      } else if (slotToViewportDy + _dragItemHeight > viewportHeight) {
        final overflow = (slotToViewportDy + _dragItemHeight) - viewportHeight;
        targetScrollOffset = (currentScrollOffset + overflow + effectiveGap)
            .clamp(0.0, _effectiveScrollController.position.maxScrollExtent);
      }

      if (targetScrollOffset != null &&
          (targetScrollOffset - currentScrollOffset).abs() > 1.0) {
        _effectiveScrollController.animateTo(
          targetScrollOffset,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
        final postScrollDelta = targetScrollOffset - _dragStartScrollOffset;
        destinationDy =
            _dragItemOrigin.dy + ((to - from) * shiftAmount) - postScrollDelta;
      }
    }

    _snapTargetOffset = Offset(_dragItemOrigin.dx, destinationDy);
    _isSettlingNotifier.value = true;
    _snapMotionCtrl.stop();
    _snapMotionCtrl.value = 0.0;

    bool finished = false;
    Timer? settleTimer;
    VoidCallback? onSnapTick;

    void completeSettling() {
      if (finished) return;
      finished = true;
      settleTimer?.cancel();
      if (onSnapTick != null) {
        _snapMotionCtrl.removeListener(onSnapTick);
      }

      if (!mounted) return;

      _snapMotionCtrl.stop();
      _cleanupDragState();

      if (from != to) {
        final reorderTo = to > from ? to + 1 : to;
        widget.onReorder(from, reorderTo);
      }
    }

    final initialDistance = (_snapStartOffset.dy - destinationDy).abs();
    if (initialDistance <= 1.0) {
      completeSettling();
      return;
    }

    final distanceDelta = destinationDy - _snapStartOffset.dy;
    final velocityDy = details?.velocity.pixelsPerSecond.dy;
    final double? normalizedVelocity;
    if (velocityDy != null && distanceDelta.abs() > 1.0) {
      normalizedVelocity = (velocityDy / distanceDelta).clamp(-10.0, 10.0);
    } else {
      normalizedVelocity = null;
    }

    onSnapTick = () {
      final snapT = _snapMotionCtrl.value;
      if (snapT >= 0.999 || (snapT - 1.0).abs() <= 0.001) {
        completeSettling();
      }
    };

    _snapMotionCtrl.addListener(onSnapTick);
    _snapMotionCtrl.animateTo(1.0, withVelocity: normalizedVelocity).then((_) {
      completeSettling();
    });

    settleTimer = Timer(const Duration(milliseconds: 1500), () {
      completeSettling();
    });
  }

  // ── Corner Radii Calculation with Visual Reordering ──

  BorderRadius _computePositionRadius(int position, int total) {
    if (total <= 1) {
      return BorderRadius.circular(widget.style.outerRadius);
    }
    final isFirst = position == 0;
    final isLast = position == total - 1;
    final or = widget.style.outerRadius;
    final ir = widget.style.innerRadius;

    return BorderRadius.only(
      topLeft: Radius.circular(isFirst ? or : ir),
      topRight: Radius.circular(isFirst ? or : ir),
      bottomLeft: Radius.circular(isLast ? or : ir),
      bottomRight: Radius.circular(isLast ? or : ir),
    );
  }

  // ── Placeholder & Proxy Rendering ──

  Widget _buildPlaceholder(BuildContext context, int targetSlot) {
    final s = widget.style;
    final cs = Theme.of(context).colorScheme;
    final total = computeVisibleIndices().length;

    final placeholderRadius = widget.dragPlaceholderRadius != null
        ? BorderRadius.circular(widget.dragPlaceholderRadius!)
        : (widget.dragPlaceholderBorder != null
              ? BorderRadius.circular(s.outerRadius)
              : _computePositionRadius(targetSlot, total));

    if (widget.dragPlaceholderBuilder != null) {
      return widget.dragPlaceholderBuilder!(
        context,
        targetSlot,
        Size(_dragItemWidth, _dragItemHeight),
      );
    }

    return Container(
      width: _dragItemWidth,
      height: _dragItemHeight,
      decoration: BoxDecoration(
        color: widget.dragPlaceholderColor ?? cs.surfaceContainerLow,
        borderRadius: placeholderRadius,
        border: widget.dragPlaceholderBorder != null
            ? Border.fromBorderSide(widget.dragPlaceholderBorder!)
            : null,
      ),
    );
  }

  Widget _buildProxyItem(BuildContext context, int index) {
    final s = widget.style;
    final effectiveDragBorderRadius =
        widget.dragBorderRadius ?? BorderRadius.circular(s.outerRadius);
    final effectiveDragElevation = widget.dragElevation;
    final effectiveDragScale = widget.dragScale;
    final effectiveDragColor =
        widget.dragColor ??
        s.color ??
        Theme.of(context).colorScheme.surfaceContainerHigh;

    Widget childContent = widget.itemBuilder(context, index);
    if (widget.buildDefaultDragHandles) {
      childContent = Row(
        children: [
          Expanded(child: childContent),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.drag_handle_rounded),
          ),
        ],
      );
    }

    final fromIndex = _draggedIndexNotifier.value ?? index;
    final visible = computeVisibleIndices();
    final total = visible.length;
    final restingLandingRadius = _computePositionRadius(fromIndex, total);
    final floatingRadius = effectiveDragBorderRadius;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _proxyLiftCtrl,
        _snapMotionCtrl,
        _pointerOffsetNotifier,
        _targetIndexNotifier,
        _isSettlingNotifier,
        _effectiveScrollController,
      ]),
      builder: (context, _) {
        final bool isSettling = _isSettlingNotifier.value;
        final double scale;
        final double elev;
        final BorderRadius currentRadius;

        final currentTargetIndex = _targetIndexNotifier.value ?? fromIndex;
        final targetLandingRadius = _computePositionRadius(
          currentTargetIndex,
          total,
        );

        if (isSettling) {
          final double snapT = _snapMotionCtrl.value.clamp(0.0, 1.0);
          scale = lerpDouble(effectiveDragScale, 1.0, snapT)!;
          elev = lerpDouble(effectiveDragElevation, s.elevation, snapT)!;
          currentRadius =
              BorderRadius.lerp(floatingRadius, targetLandingRadius, snapT) ??
              targetLandingRadius;
        } else {
          final double liftT = _proxyLiftCtrl.value.clamp(0.0, 1.0);
          scale = lerpDouble(1.0, effectiveDragScale, liftT)!;
          elev = lerpDouble(s.elevation, effectiveDragElevation, liftT)!;
          currentRadius =
              BorderRadius.lerp(restingLandingRadius, floatingRadius, liftT) ??
              floatingRadius;
        }

        final currentScrollOffset = _effectiveScrollController.hasClients
            ? _effectiveScrollController.offset
            : 0.0;
        final scrollDelta = currentScrollOffset - _dragStartScrollOffset;

        final Offset currentOffset;
        if (isSettling) {
          final snapT = _snapMotionCtrl.value;
          final destinationWithScrollDelta = Offset(
            _snapTargetOffset.dx,
            _snapTargetOffset.dy - scrollDelta,
          );
          currentOffset =
              Offset.lerp(
                _snapStartOffset,
                destinationWithScrollDelta,
                snapT,
              ) ??
              destinationWithScrollDelta;
        } else {
          final double liftT = _proxyLiftCtrl.value.clamp(0.0, 1.0);
          const double kLiftShiftX = 12.0;
          const double kLiftShiftY = 12.0;
          currentOffset = Offset(
            _dragItemOrigin.dx + (kLiftShiftX * liftT),
            _pointerOffsetNotifier.value.dy -
                _grabOffsetY +
                (kLiftShiftY * liftT),
          );
        }

        Widget proxyItem = Container(
          width: _dragItemWidth,
          height: _dragItemHeight,
          decoration: BoxDecoration(
            color: effectiveDragColor,
            borderRadius: currentRadius,
            border: s.border != null
                ? Border.all(color: s.border!.color, width: s.border!.width)
                : null,
            boxShadow: elev > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.1,
                      ), //alpha: 0.12 + (elev * 0.015),
                      blurRadius: elev * 2.0,
                      offset: Offset(0, elev),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: s.padding ?? const EdgeInsets.all(16.0),
              child: childContent,
            ),
          ),
        );

        if (scale != 1.0) {
          proxyItem = Transform.scale(scale: scale, child: proxyItem);
        }

        return Positioned(
          left: currentOffset.dx,
          top: currentOffset.dy,
          child: IgnorePointer(child: proxyItem),
        );
      },
    );
  }

  // ── Custom buildSlot override with Reorder support ──

  Widget _buildReorderableSlot(
    BuildContext context,
    int slotIndex,
    List<int> visible,
  ) {
    final slot = slots[slotIndex];
    if (slot.isCollapsing) {
      return buildSlot(context, slotIndex, visible);
    }

    final slotPos = visible.indexOf(slotIndex);
    if (slotPos < 0 || slotPos >= swipeItemCount) {
      return const SizedBox.shrink();
    }

    slot.onReorderKey = _handleKeyboardReorder;

    final Key itemKey = widget.keyBuilder != null
        ? widget.keyBuilder!(slotPos)
        : ValueKey('reorder_dismiss_slot_${slot.identity.hashCode}');

    _reorderItemKeys[slotPos] ??= GlobalKey();

    final shiftCtrl = _getOrCreateShiftController(slotPos);

    return KeyedSubtree(
      key: itemKey,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _draggedIndexNotifier,
          _targetIndexNotifier,
        ]),
        builder: (context, _) {
          final draggedIndex = _draggedIndexNotifier.value;
          final targetIndex = _targetIndexNotifier.value;
          final isBeingDragged = draggedIndex == slotPos;
          final isPlaceholderSlot =
              draggedIndex != null && targetIndex == slotPos;

          int visualIndex = slotPos;
          if (draggedIndex != null && targetIndex != null) {
            if (slotPos == draggedIndex) {
              visualIndex = targetIndex;
            } else if (draggedIndex < targetIndex) {
              if (slotPos > draggedIndex && slotPos <= targetIndex) {
                visualIndex = slotPos - 1;
              }
            } else if (draggedIndex > targetIndex) {
              if (slotPos >= targetIndex && slotPos < draggedIndex) {
                visualIndex = slotPos + 1;
              }
            }
          }

          // Regular dismissible slot widget with dynamic visual index for corner radii
          final rawSlotWidget = buildSlot(
            context,
            slotIndex,
            visible,
            visualIndex,
          );

          final itemContentWithVisibility = Visibility(
            visible: !isBeingDragged,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: rawSlotWidget,
          );

          final wrappedItem = _M3EReorderItemDragStartListener(
            index: slotPos,
            delayed: true,
            onStartDrag: _handleReorderDragStart,
            child: itemContentWithVisibility,
          );

          return Stack(
            key: _reorderItemKeys[slotPos],
            clipBehavior: Clip.none,
            children: [
              if (isPlaceholderSlot)
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: (slotPos == visible.length - 1)
                          ? 0
                          : widget.style.gap,
                    ),
                    child: _buildPlaceholder(context, slotPos),
                  ),
                ),
              AnimatedBuilder(
                animation: shiftCtrl,
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0, shiftCtrl.value),
                    child: wrappedItem,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return widget.emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    final visible = computeVisibleIndices();

    Widget content = FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Stack(
        key: _stackKey,
        clipBehavior: Clip.none,
        children: [
          ListView.builder(
            controller: _effectiveScrollController,
            physics: widget.physics,
            padding: widget.listPadding,
            shrinkWrap: widget.shrinkWrap,
            clipBehavior: widget.clipBehavior,
            // ignore: deprecated_member_use
            cacheExtent: 1000.0,
            itemCount: slots.length,
            itemBuilder: (ctx, i) => _buildReorderableSlot(ctx, i, visible),
          ),
          ValueListenableBuilder<int?>(
            valueListenable: _draggedIndexNotifier,
            builder: (context, draggedIndex, _) {
              if (draggedIndex == null) return const SizedBox.shrink();
              return _buildProxyItem(context, draggedIndex);
            },
          ),
        ],
      ),
    );

    if (widget.margin != null && widget.margin != EdgeInsets.zero) {
      return Padding(padding: widget.margin!, child: content);
    }
    return content;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drag Gestures & Listener Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _M3EReorderItemDragStartListener extends StatelessWidget {
  const _M3EReorderItemDragStartListener({
    required this.index,
    required this.child,
    required this.onStartDrag,
    required this.delayed,
  });

  final int index;
  final Widget child;
  final Drag? Function(int index, Offset globalPosition) onStartDrag;
  final bool delayed;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory>{
        if (delayed)
          DelayedMultiDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                DelayedMultiDragGestureRecognizer
              >(
                () => DelayedMultiDragGestureRecognizer(
                  delay: const Duration(milliseconds: 200),
                ),
                (DelayedMultiDragGestureRecognizer instance) {
                  instance.onStart = (Offset position) {
                    return onStartDrag(index, position);
                  };
                },
              )
        else
          ImmediateMultiDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                ImmediateMultiDragGestureRecognizer
              >(() => ImmediateMultiDragGestureRecognizer(), (
                ImmediateMultiDragGestureRecognizer instance,
              ) {
                instance.onStart = (Offset position) {
                  return onStartDrag(index, position);
                };
              }),
      },
      child: child,
    );
  }
}

class _M3EReorderDrag extends Drag {
  final ValueChanged<Offset> onUpdate;
  final ValueChanged<DragEndDetails> onEnd;
  final VoidCallback onCancel;

  _M3EReorderDrag({
    required this.onUpdate,
    required this.onEnd,
    required this.onCancel,
  });

  @override
  void update(DragUpdateDetails details) {
    onUpdate(details.globalPosition);
  }

  @override
  void end(DragEndDetails details) {
    onEnd(details);
  }

  @override
  void cancel() {
    onCancel();
  }
}
