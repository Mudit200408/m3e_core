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
import 'm3e_expandable_base.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_item.dart';
import 'm3e_expandable_shared.dart';
import 'm3e_expandable_style.dart';
import 'm3e_expandable_theme.dart';

/// A Material 3 Expressive spring-physics reorderable expandable list with dynamic
/// destination placeholder slot, bouncy spring neighbor displacement, and smooth snap settling.
///
/// Combines the full collapsible/expandable card functionality of [M3EExpandableCardList]
/// with 1:1 identical reorder physics, spring lift-off motion, and placeholder slots
/// from [M3EReorderableDismissibleList] and [M3EReorderableSegmentedList].
class M3EReorderableExpandableList extends M3EExpandableListBase {
  /// Called when an item moves to a new position.
  final ReorderCallback onReorder;

  /// Generates a stable key for each item to preserve state across reorders.
  final Key Function(int index)? keyBuilder;

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

  /// Builder displayed when there are no items to show.
  final WidgetBuilder? emptyBuilder;

  M3EReorderableExpandableList({
    super.key,
    required List<M3EExpandableData> data,
    required this.onReorder,
    Key Function(int index)? keyBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded = const {},
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
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
  }) : keyBuilder =
           keyBuilder ??
           ((index) => ValueKey('m3e_exp_item_${data[index].title}')),
       super(
         itemCount: data.length,
         headerBuilder: m3eSimpleHeaderBuilder(data),
         bodyBuilder: m3eSimpleBodyBuilder(
           data,
           style ?? const M3EExpandableStyle(),
         ),
       );

  const M3EReorderableExpandableList.builder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    required this.onReorder,
    this.keyBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded = const {},
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
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
  State<M3EReorderableExpandableList> createState() =>
      _M3EReorderableExpandableListState();
}

class _M3EReorderableExpandableListState
    extends State<M3EReorderableExpandableList>
    with TickerProviderStateMixin, M3EExpandableStateMixin {
  @override
  Set<int> get initiallyExpanded => widget.initiallyExpanded;

  // ── Reorder State & Physics (consistent 1:1 with M3EReorderableDismissibleList and M3EReorderableSegmentedList) ──

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
  Set<int> _savedExpandedIndices = {};
  Set<int> _justSettledIndices = {};

  final Map<int, GlobalKey> _reorderItemKeys = {};
  final Map<int, GlobalKey> _reorderHeaderKeys = {};
  final Map<int, SingleMotionController> _shiftControllers = {};
  final Map<int, double> _targetShifts = {};

  late final SingleMotionController _proxyLiftCtrl;
  late final SingleMotionController _snapMotionCtrl;
  Offset _snapStartOffset = Offset.zero;
  Offset _snapTargetOffset = Offset.zero;
  double _dragStartScrollOffset = 0.0;
  double _snapStartScrollOffset = 0.0;

  late ScrollController _internalScrollController;
  ScrollController get _effectiveScrollController =>
      widget.scrollController ?? _internalScrollController;

  @override
  void initState() {
    super.initState();
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

  final Map<int, FocusNode> _focusNodes = {};
  int? _pendingKeyboardFocusIndex;

  FocusNode _getFocusNode(int index) {
    return _focusNodes.putIfAbsent(
      index,
      () => FocusNode(debugLabel: 'M3EReorderableExpandableItem_$index'),
    );
  }

  @override
  void didUpdateWidget(M3EReorderableExpandableList old) {
    super.didUpdateWidget(old);
    _proxyLiftCtrl.motion = widget.reorderMotion.toMotion();
    _snapMotionCtrl.motion = widget.reorderMotion.toMotion();

    _shiftControllers.removeWhere((idx, ctrl) {
      if (idx >= widget.itemCount) {
        ctrl.dispose();
        return true;
      }
      return false;
    });

    _focusNodes.removeWhere((idx, node) {
      if (idx >= widget.itemCount) {
        node.dispose();
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
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    _focusNodes.clear();
    _reorderItemKeys.clear();
    _reorderHeaderKeys.clear();
    _internalScrollController.dispose();
    _draggedIndexNotifier.dispose();
    _targetIndexNotifier.dispose();
    _pointerOffsetNotifier.dispose();
    _isSettlingNotifier.dispose();
    super.dispose();
  }

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
    final targetIndex = moveForward ? index + 1 : index - 1;
    if (targetIndex >= 0 && targetIndex < widget.itemCount) {
      _pendingKeyboardFocusIndex = targetIndex;

      final from = index;
      final to = targetIndex;
      final newExpanded = <int>{};
      for (final idx in expandedIndices) {
        if (idx == from) {
          newExpanded.add(to);
        } else if (from < to && idx > from && idx <= to) {
          newExpanded.add(idx - 1);
        } else if (from > to && idx >= to && idx < from) {
          newExpanded.add(idx + 1);
        } else {
          newExpanded.add(idx);
        }
      }

      setState(() {
        expandedIndices.clear();
        expandedIndices.addAll(newExpanded);
      });

      final reorderTo = targetIndex > index ? targetIndex + 1 : targetIndex;
      widget.onReorder(index, reorderTo);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pendingKeyboardFocusIndex != null) {
          final targetIdx = _pendingKeyboardFocusIndex!;
          _pendingKeyboardFocusIndex = null;
          final node = _getFocusNode(targetIdx);
          node.requestFocus();
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
    if (_isSettlingNotifier.value || _draggedIndexNotifier.value != null) {
      return null;
    }
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final renderBox = (stackBox ?? context.findRenderObject()) as RenderBox?;
    if (renderBox == null) return null;

    final headerKey = _reorderHeaderKeys[index];
    final headerBox =
        headerKey?.currentContext?.findRenderObject() as RenderBox?;
    final itemKey = _reorderItemKeys[index];
    final itemBox = itemKey?.currentContext?.findRenderObject() as RenderBox?;
    final itemLocalOrigin = itemBox != null
        ? renderBox.globalToLocal(itemBox.localToGlobal(Offset.zero))
        : Offset.zero;

    final touchLocal = renderBox.globalToLocal(globalPos);
    final effectiveStyle = widget.style ?? M3EExpandableTheme.of(context).style;
    final effectiveGap = effectiveStyle.gap;

    _savedExpandedIndices = Set<int>.from(expandedIndices);

    // Measure collapsed header height directly from headerBox if available,
    // which gives the exact collapsed card height even if the item was expanded.
    double? collapsedHeight =
        (headerBox != null && headerBox.hasSize && headerBox.size.height > 0)
        ? headerBox.size.height
        : null;

    if (collapsedHeight == null) {
      for (int i = 0; i < widget.itemCount; i++) {
        final hBox =
            _reorderHeaderKeys[i]?.currentContext?.findRenderObject()
                as RenderBox?;
        if (hBox != null && hBox.hasSize && hBox.size.height > 0) {
          collapsedHeight = hBox.size.height;
          break;
        }
      }
    }

    if (collapsedHeight == null) {
      for (int i = 0; i < widget.itemCount; i++) {
        if (!isExpanded(i)) {
          final box =
              _reorderItemKeys[i]?.currentContext?.findRenderObject()
                  as RenderBox?;
          if (box != null && box.hasSize && box.size.height > 0) {
            final isLast = i == widget.itemCount - 1;
            collapsedHeight = isLast
                ? box.size.height
                : (box.size.height - effectiveGap).clamp(0.0, double.infinity);
            break;
          }
        }
      }
    }
    _dragItemHeight = collapsedHeight ?? 56.0;
    _dragItemWidth =
        headerBox?.size.width ?? itemBox?.size.width ?? renderBox.size.width;

    // Calculate slot 0 top position in list coordinates
    final item0Key = _reorderItemKeys[0];
    final item0Box = item0Key?.currentContext?.findRenderObject() as RenderBox?;
    final item0Origin = item0Box != null
        ? renderBox.globalToLocal(item0Box.localToGlobal(Offset.zero))
        : Offset.zero;
    final slot0Top = item0Box != null
        ? item0Origin.dy
        : (itemLocalOrigin.dy - index * (_dragItemHeight + effectiveGap));

    _dragItemOrigin = Offset(
      item0Box != null ? item0Origin.dx : itemLocalOrigin.dx,
      slot0Top + index * (_dragItemHeight + effectiveGap),
    );
    _dragStartScrollOffset = _effectiveScrollController.hasClients
        ? _effectiveScrollController.offset
        : 0.0;

    final headerLocalOrigin = headerBox != null
        ? renderBox.globalToLocal(headerBox.localToGlobal(Offset.zero))
        : (itemBox != null ? itemLocalOrigin : _dragItemOrigin);
    _grabOffsetY = (touchLocal.dy - headerLocalOrigin.dy).clamp(
      0.0,
      _dragItemHeight,
    );
    _pointerOffsetNotifier.value = touchLocal;

    _draggedIndexNotifier.value = index;
    _targetIndexNotifier.value = index;

    if (effectiveStyle.enableFeedback) {
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

    // Determine target index using live rendered slot centers where available.
    final draggedCenterY = localPos.dy - _grabOffsetY + (_dragItemHeight / 2.0);
    final from = _draggedIndexNotifier.value!;

    // Collect actual rendered slot center Y positions.
    final slotCenters = <int, double>{};
    for (int i = 0; i < widget.itemCount; i++) {
      final box =
          _reorderItemKeys[i]?.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final slotTop = renderBox
            .globalToLocal(box.localToGlobal(Offset.zero))
            .dy;
        slotCenters[i] = slotTop + box.size.height / 2.0;
      }
    }

    int bestTarget = from;
    double closestDist = double.infinity;

    if (slotCenters.isNotEmpty) {
      final firstIdx = slotCenters.keys.reduce((a, b) => a < b ? a : b);
      final lastIdx = slotCenters.keys.reduce((a, b) => a > b ? a : b);

      if (draggedCenterY <= slotCenters[firstIdx]!) {
        bestTarget = 0;
      } else if (draggedCenterY >= slotCenters[lastIdx]!) {
        bestTarget = widget.itemCount - 1;
      } else {
        for (final entry in slotCenters.entries) {
          final dist = (draggedCenterY - entry.value).abs();
          if (dist < closestDist) {
            closestDist = dist;
            bestTarget = entry.key;
          }
        }
      }
    } else {
      // Fallback: uniform pitch estimate (only used before first layout).
      final effectiveStyle =
          widget.style ?? M3EExpandableTheme.of(context).style;
      final effectiveGap = effectiveStyle.gap;
      final pitch = _dragItemHeight + effectiveGap;
      for (int i = 0; i < widget.itemCount; i++) {
        final slotCenterY =
            _dragItemOrigin.dy + ((i - from) * pitch) + (_dragItemHeight / 2.0);
        final dist = (draggedCenterY - slotCenterY).abs();
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

    final effectiveStyle = widget.style ?? M3EExpandableTheme.of(context).style;
    final effectiveGap = effectiveStyle.gap;
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
    _savedExpandedIndices.clear();
  }

  void _handleReorderDragEnd([DragEndDetails? details]) {
    final from = _draggedIndexNotifier.value;
    if (from == null || _isSettlingNotifier.value) return;

    final to = _targetIndexNotifier.value ?? from;
    final effectiveStyle = widget.style ?? M3EExpandableTheme.of(context).style;
    final effectiveGap = effectiveStyle.gap;
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

    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox =
        _reorderItemKeys[to]?.currentContext?.findRenderObject() as RenderBox?;

    final currentScrollOffset = _effectiveScrollController.hasClients
        ? _effectiveScrollController.offset
        : 0.0;
    _snapStartScrollOffset = currentScrollOffset;

    final Offset targetSlotOffset;
    if (stackBox != null && targetBox != null && targetBox.hasSize) {
      targetSlotOffset = stackBox.globalToLocal(
        targetBox.localToGlobal(Offset.zero),
      );
    } else {
      final scrollDelta = currentScrollOffset - _dragStartScrollOffset;
      final slotToViewportDy =
          _dragItemOrigin.dy + ((to - from) * shiftAmount) - scrollDelta;
      targetSlotOffset = Offset(_dragItemOrigin.dx, slotToViewportDy);
    }
    double destinationDy = targetSlotOffset.dy;

    final renderBox = (stackBox ?? context.findRenderObject()) as RenderBox?;
    final viewportHeight = renderBox?.size.height ?? double.infinity;

    if (_effectiveScrollController.hasClients &&
        viewportHeight.isFinite &&
        _effectiveScrollController.position.hasContentDimensions) {
      double? targetScrollOffset;
      if (destinationDy < 0) {
        targetScrollOffset =
            (currentScrollOffset + destinationDy - effectiveGap).clamp(
              0.0,
              _effectiveScrollController.position.maxScrollExtent,
            );
      } else if (destinationDy + _dragItemHeight > viewportHeight) {
        final overflow = (destinationDy + _dragItemHeight) - viewportHeight;
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
      }
    }

    _snapTargetOffset = Offset(targetSlotOffset.dx, destinationDy);
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
      final from = _draggedIndexNotifier.value;
      final to = _targetIndexNotifier.value ?? from;
      final savedExpanded = Set<int>.from(_savedExpandedIndices);
      _cleanupDragState();

      final newExpanded = <int>{};
      for (final idx in savedExpanded) {
        if (from != null && to != null) {
          if (idx == from) {
            newExpanded.add(to);
          } else if (from < to && idx > from && idx <= to) {
            newExpanded.add(idx - 1);
          } else if (from > to && idx >= to && idx < from) {
            newExpanded.add(idx + 1);
          } else {
            newExpanded.add(idx);
          }
        } else {
          newExpanded.add(idx);
        }
      }

      final settledIndices = <int>{};
      if (from != null && to != null && savedExpanded.contains(from)) {
        settledIndices.add(to);
      }

      setState(() {
        expandedIndices.clear();
        expandedIndices.addAll(newExpanded);
        _justSettledIndices = settledIndices;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (settledIndices.isNotEmpty && to != null) {
            final targetContext = _reorderItemKeys[to]?.currentContext;
            if (targetContext != null) {
              Scrollable.ensureVisible(
                targetContext,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
              );
            }
          }
        }
      });

      Timer(const Duration(milliseconds: 350), () {
        if (mounted) {
          _justSettledIndices.clear();
        }
      });

      if (from != null && to != null && from != to) {
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
    final effectiveStyle = widget.style ?? M3EExpandableTheme.of(context).style;
    if (total <= 1) {
      return BorderRadius.circular(effectiveStyle.outerRadius);
    }
    final isFirst = position == 0;
    final isLast = position == total - 1;
    final or = effectiveStyle.outerRadius;
    final ir = effectiveStyle.innerRadius;

    return BorderRadius.only(
      topLeft: Radius.circular(isFirst ? or : ir),
      topRight: Radius.circular(isFirst ? or : ir),
      bottomLeft: Radius.circular(isLast ? or : ir),
      bottomRight: Radius.circular(isLast ? or : ir),
    );
  }

  // ── Placeholder & Proxy Rendering ──

  Widget _buildPlaceholder(BuildContext context, int targetSlot) {
    final s = widget.style ?? M3EExpandableTheme.of(context).style;
    final cs = Theme.of(context).colorScheme;
    final total = widget.itemCount;

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
    final s = widget.style ?? M3EExpandableTheme.of(context).style;
    final effectiveDragBorderRadius =
        widget.dragBorderRadius ?? BorderRadius.circular(s.outerRadius);
    final effectiveDragElevation = widget.dragElevation;
    final effectiveDragScale = widget.dragScale;
    final effectiveDragColor =
        widget.dragColor ??
        s.color ??
        Theme.of(context).colorScheme.surfaceContainerHigh;

    final fromIndex = _draggedIndexNotifier.value ?? index;
    final total = widget.itemCount;
    final restingLandingRadius = _computePositionRadius(fromIndex, total);
    final floatingRadius = effectiveDragBorderRadius;

    M3EExpandableHeaderBuilder effectiveHeader = widget.headerBuilder;
    if (widget.buildDefaultDragHandles) {
      effectiveHeader = (ctx, i, progress) => Row(
        children: [
          Expanded(child: widget.headerBuilder(ctx, i, progress)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.drag_handle_rounded),
          ),
        ],
      );
    }

    final wasExpanded = _savedExpandedIndices.contains(index);
    Widget childContent = M3EExpandableItem(
      key: ValueKey('proxy_expandable_item_$index'),
      index: index,
      totalCount: widget.itemCount,
      isExpanded: false,
      animateInitially: wasExpanded,
      headerBuilder: effectiveHeader,
      bodyBuilder: widget.bodyBuilder,
      decoration: s.copyWith(color: effectiveDragColor, elevation: 0.0),
      expandMotion:
          widget.expandMotion ?? M3EExpandableTheme.of(context).expandMotion,
      collapseMotion:
          widget.collapseMotion ??
          M3EExpandableTheme.of(context).collapseMotion,
      onToggle: () {},
    );

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

        final Offset currentOffset;
        if (isSettling) {
          final snapT = _snapMotionCtrl.value;
          final targetBox =
              _reorderItemKeys[currentTargetIndex]?.currentContext
                      ?.findRenderObject()
                  as RenderBox?;
          final stackBox =
              _stackKey.currentContext?.findRenderObject() as RenderBox?;
          final Offset liveDestination;
          if (stackBox != null && targetBox != null && targetBox.hasSize) {
            liveDestination = stackBox.globalToLocal(
              targetBox.localToGlobal(Offset.zero),
            );
          } else {
            final scrollDeltaSinceEnd =
                currentScrollOffset - _snapStartScrollOffset;
            liveDestination = Offset(
              _snapTargetOffset.dx,
              _snapTargetOffset.dy - scrollDeltaSinceEnd,
            );
          }
          currentOffset =
              Offset.lerp(_snapStartOffset, liveDestination, snapT) ??
              liveDestination;
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
          decoration: BoxDecoration(
            color: effectiveDragColor,
            borderRadius: currentRadius,
            border: s.border != null
                ? Border.all(color: s.border!.color, width: s.border!.width)
                : null,
            boxShadow: elev > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: elev * 2.0,
                      offset: Offset(0, elev),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(type: MaterialType.transparency, child: childContent),
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

  // ── Item Builder with Reorder Support ──

  Widget _buildReorderableItem(BuildContext context, int slotPos) {
    final Key itemKey = widget.keyBuilder != null
        ? widget.keyBuilder!(slotPos)
        : ValueKey('reorder_expandable_slot_$slotPos');

    _reorderItemKeys[slotPos] ??= GlobalKey();
    _reorderHeaderKeys[slotPos] ??= GlobalKey();

    final shiftCtrl = _getOrCreateShiftController(slotPos);
    final effectiveStyle = widget.style ?? M3EExpandableTheme.of(context).style;

    M3EExpandableHeaderBuilder effectiveHeader = widget.headerBuilder;
    if (widget.buildDefaultDragHandles) {
      effectiveHeader = (ctx, i, progress) => Row(
        children: [
          Expanded(child: widget.headerBuilder(ctx, i, progress)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.drag_handle_rounded),
          ),
        ],
      );
    }

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

          final theme = M3EExpandableTheme.of(context);
          final effectiveExpandMotion =
              widget.expandMotion ?? theme.expandMotion;
          final effectiveCollapseMotion =
              widget.collapseMotion ?? theme.collapseMotion;
          final effectiveAllowMultiple =
              widget.allowMultipleExpanded ?? theme.allowMultipleExpanded;

          final rawItemWidget = buildM3EExpandableItem(
            key: ValueKey('inner_$itemKey'),
            index: slotPos,
            visualIndex: visualIndex,
            isLast: slotPos == widget.itemCount - 1,
            headerKey: _reorderHeaderKeys[slotPos],
            totalCount: widget.itemCount,
            isExpanded: draggedIndex != null ? false : isExpanded(slotPos),
            animateInitially: _justSettledIndices.contains(slotPos),
            animateCollapse: draggedIndex == null,
            headerBuilder: effectiveHeader,
            bodyBuilder: widget.bodyBuilder,
            decoration: effectiveStyle,
            expandMotion: effectiveExpandMotion,
            collapseMotion: effectiveCollapseMotion,
            onToggle: () => handleToggle(
              slotPos,
              allowMultipleExpanded: effectiveAllowMultiple,
              haptic: effectiveStyle.haptic,
              onExpansionChanged: widget.onExpansionChanged,
            ),
            focusNode: _getFocusNode(slotPos),
            onReorderKey: _handleKeyboardReorder,
          );

          final itemContentWithVisibility = Visibility(
            visible: !isBeingDragged,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: rawItemWidget,
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
                      bottom: (slotPos == widget.itemCount - 1)
                          ? 0
                          : effectiveStyle.gap,
                    ),
                    child: _buildPlaceholder(context, targetIndex ?? slotPos),
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
    if (widget.itemCount == 0) {
      return widget.emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

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
            findChildIndexCallback: (Key key) {
              if (widget.keyBuilder != null) {
                for (int i = 0; i < widget.itemCount; i++) {
                  if (widget.keyBuilder!(i) == key) return i;
                }
              }
              return null;
            },
            itemCount: widget.itemCount,
            itemBuilder: (ctx, i) => _buildReorderableItem(ctx, i),
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
