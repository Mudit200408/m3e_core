import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../common/m3e_common.dart';
import 'm3e_segmented_item.dart';
import 'style/m3e_segmented_list_decoration.dart';

/// A Material 3 Expressive spring-physics reorderable segmented list with dynamic
/// destination placeholder slot, bouncy spring neighbor displacement, and smooth snap settling.
class M3EReorderableSegmentedList extends StatefulWidget {
  /// The number of items in the list.
  final int itemCount;

  /// Signature for a function that creates a widget for a given index.
  final IndexedWidgetBuilder itemBuilder;

  /// Called when a list child has moved to a new position.
  final ReorderCallback onReorder;

  /// The radius used for the top corners of the first item, the bottom corners
  /// of the last item, and all corners of a single item.
  ///
  /// Defaults to `24.0`.
  final double outerRadius;

  /// The radius used for the inner corners of adjoining items.
  ///
  /// Defaults to `4.0`.
  final double innerRadius;

  /// The gap space between adjacent items.
  ///
  /// Defaults to `2.0`.
  final double gap;

  /// The background color for each item when unselected.
  final Color? color;

  /// The inner padding applied to each item.
  final EdgeInsetsGeometry? padding;

  /// The outer margin applied around the entire reorderable list.
  final EdgeInsetsGeometry? margin;

  /// Optional callback invoked when an item is tapped.
  final void Function(int index)? onTap;

  /// Optional callback invoked when an item is long-pressed.
  final void Function(int index)? onLongPress;

  /// Optional semantic label builder for accessibility.
  final String Function(int index)? semanticLabelBuilder;

  /// The cursor for a mouse pointer when it enters an item's bounds.
  final MouseCursor? mouseCursor;

  /// The color to use when an item is focused by keyboard navigation.
  final Color? focusColor;

  /// The color to use when an item is hovered by a mouse pointer.
  final Color? hoverColor;

  /// Called when the focus state of an item changes.
  final void Function(int index, bool)? onFocusChange;

  /// The border drawn around each item when unselected.
  final BorderSide? border;

  /// The resting elevation of each item.
  final double elevation;

  /// The splash color of the ink response when tapped.
  final Color? splashColor;

  /// The highlight color of the ink response when tapped.
  final Color? highlightColor;

  /// Defines the appearance of the splash.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool enableFeedback;

  /// The haptic feedback to provide on interaction.
  final M3EHapticFeedback haptic;

  /// Optional predicate to determine if a specific item index is enabled.
  ///
  /// Defaults to `null` (all items enabled).
  final bool Function(int index)? isEnabled;

  /// Widget displayed when the list is empty (itemCount is 0).
  final Widget? emptyBuilder;

  // --- Drag & Reorder Customization ---

  /// Whether to build decorative trailing drag handle icons ([Icons.drag_handle_rounded]).
  ///
  /// Reordering is initiated via a long-press on the item.
  /// When `true`, a drag handle icon is appended to the trailing edge as a visual cue.
  final bool buildDefaultDragHandles;

  /// The visual elevation applied to the item when it is being dragged.
  ///
  /// Defaults to `8.0`.
  final double dragElevation;

  /// The scale multiplier applied to the item when it is being dragged.
  ///
  /// Defaults to `1.0`.
  final double dragScale;

  /// Corner radius applied to all corners when an item is being dragged.
  final double? dragRadius;

  /// The border radius applied to the dragged item, giving it a detached floating appearance.
  ///
  /// Defaults to `BorderRadius.circular(24.0)`.
  final BorderRadius? dragBorderRadius;

  /// Background color applied to the item while being dragged.
  ///
  /// If null, defaults to [ColorScheme.surfaceContainerHigh] in theme.
  final Color? dragColor;

  /// Background color for the reorder drop target placeholder slot container.
  ///
  /// If null, defaults to [ColorScheme.surfaceContainerLow] in theme.
  final Color? dragPlaceholderColor;

  /// Border outline for the reorder drop target placeholder slot container.
  final BorderSide? dragPlaceholderBorder;

  /// Corner radius for the reorder drop target placeholder slot container.
  final double? dragPlaceholderRadius;

  /// Optional custom builder for the reorder drop target placeholder slot container.
  final Widget Function(BuildContext context, int index, Size size)?
  dragPlaceholderBuilder;

  // --- Selection API ---

  /// Currently selected item indices.
  final Set<int>? selectedIndices;

  /// Callback invoked whenever the selection set changes.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// The selection mode for this list (none, single, or multiple).
  final M3ESelectionMode selectionMode;

  /// Which user gesture triggers selection (tap, longPress, both, or none).
  final M3ESelectionTrigger selectionTrigger;

  /// Custom predicate to determine if a specific item index is selected.
  final bool Function(int index)? isSelected;

  /// Background color applied to selected items.
  final Color? selectedColor;

  /// Border applied to selected items.
  final BorderSide? selectedBorder;

  /// Corner radius applied to all corners when an item is selected.
  final double? selectedRadius;

  /// Custom border radius applied to selected items.
  final BorderRadius? selectedBorderRadius;

  /// Elevation applied to selected items.
  final double? selectedElevation;

  /// Corner radius applied to all corners when an item is pressed.
  final double? pressedRadius;

  /// Custom [BorderRadius] applied when an item is pressed.
  final BorderRadius? pressedBorderRadius;

  /// Scale factor applied to the item inner content when pressed (e.g. 0.98 or 0.96).
  final double? pressedScale;

  /// Corner radius applied to all corners when an item is hovered.
  final double? hoveredRadius;

  /// Custom [BorderRadius] applied when an item is hovered.
  final BorderRadius? hoveredBorderRadius;

  /// Whether to render an animated selection checkmark badge on selected items.
  final bool showSelectionCheckmark;

  /// Alignment of the selection checkmark badge.
  final Alignment selectionCheckmarkAlignment;

  /// Custom builder for the selection checkmark badge.
  final Widget Function(BuildContext context, int index, bool isSelected)?
  selectionCheckmarkBuilder;

  /// Spring motion used for normal and selection transitions.
  final M3EMotion motion;

  /// Spring motion used for pressed state transitions.
  final M3EMotion pressedMotion;

  // --- ScrollView Configuration ---

  /// Controls the scroll position of the list.
  final ScrollController? controller;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the scroll view should size itself to fit its children.
  final bool shrinkWrap;

  /// Padding for the scrollable list itself.
  final EdgeInsetsGeometry? listPadding;

  /// The drag start behavior for scrolling.
  final DragStartBehavior dragStartBehavior;

  /// Defines how the scroll view should dismiss the keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Optional non-reorderable header widget displayed before the list items.
  final Widget? header;

  /// Optional non-reorderable footer widget displayed after the list items.
  final Widget? footer;

  /// Optional callback to provide unique and stable [Key]s for each item in the list.
  final Key Function(int index)? keyBuilder;

  /// Optional styling, motion, interaction, and drag overrides for the reorderable segmented list.
  final M3ESegmentedListDecoration? decoration;

  /// Creates a Material 3 Expressive reorderable segmented list with explicit [children].
  ///
  /// For lazily building large lists on demand, use [M3EReorderableSegmentedList.builder].
  M3EReorderableSegmentedList({
    super.key,
    required List<Widget> children,
    required this.onReorder,
    this.decoration,
    this.keyBuilder,
    this.header,
    this.footer,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 2.0,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.onFocusChange,
    this.border,
    this.elevation = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = M3EHapticFeedback.none,
    this.isEnabled,
    this.emptyBuilder,
    this.buildDefaultDragHandles = false,
    this.dragElevation = 8.0,
    this.dragScale = 1.0,
    this.dragRadius,
    this.dragBorderRadius,
    this.dragColor,
    this.dragPlaceholderColor,
    this.dragPlaceholderBorder,
    this.dragPlaceholderRadius,
    this.dragPlaceholderBuilder,
    this.selectedIndices,
    this.onSelectionChanged,
    this.selectionMode = M3ESelectionMode.none,
    this.selectionTrigger = M3ESelectionTrigger.tap,
    this.isSelected,
    this.selectedColor,
    this.selectedBorder,
    this.selectedRadius,
    this.selectedBorderRadius,
    this.selectedElevation,
    this.pressedRadius,
    this.pressedBorderRadius,
    this.pressedScale,
    this.hoveredRadius,
    this.hoveredBorderRadius,
    this.showSelectionCheckmark = false,
    this.selectionCheckmarkAlignment = Alignment.centerRight,
    this.selectionCheckmarkBuilder,
    this.motion = M3EMotion.expressiveSpatialFast,
    this.pressedMotion = M3EMotion.expressiveSpatialFast,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.listPadding,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) : itemCount = children.length,
       itemBuilder = ((BuildContext context, int index) => children[index]);

  /// Creates a Material 3 Expressive lazily loaded reorderable segmented list.
  ///
  /// This constructor is functionally identical to the default [M3EReorderableSegmentedList]
  /// constructor and is provided for API consistency with [ReorderableListView.builder]
  /// and [M3ESegmentedList.builder].
  const M3EReorderableSegmentedList.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onReorder,
    this.decoration,
    this.keyBuilder,
    this.header,
    this.footer,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 2.0,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.onFocusChange,
    this.border,
    this.elevation = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = M3EHapticFeedback.none,
    this.isEnabled,
    this.emptyBuilder,
    this.buildDefaultDragHandles = false,
    this.dragElevation = 8.0,
    this.dragScale = 1.0,
    this.dragRadius,
    this.dragBorderRadius,
    this.dragColor,
    this.dragPlaceholderColor,
    this.dragPlaceholderBorder,
    this.dragPlaceholderRadius,
    this.dragPlaceholderBuilder,
    this.selectedIndices,
    this.onSelectionChanged,
    this.selectionMode = M3ESelectionMode.none,
    this.selectionTrigger = M3ESelectionTrigger.tap,
    this.isSelected,
    this.selectedColor,
    this.selectedBorder,
    this.selectedRadius,
    this.selectedBorderRadius,
    this.selectedElevation,
    this.pressedRadius,
    this.pressedBorderRadius,
    this.pressedScale,
    this.hoveredRadius,
    this.hoveredBorderRadius,
    this.showSelectionCheckmark = false,
    this.selectionCheckmarkAlignment = Alignment.centerRight,
    this.selectionCheckmarkBuilder,
    this.motion = M3EMotion.expressiveSpatialFast,
    this.pressedMotion = M3EMotion.expressiveSpatialFast,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.listPadding,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  State<M3EReorderableSegmentedList> createState() =>
      _M3EReorderableSegmentedListState();
}

class _M3EReorderableSegmentedListState
    extends State<M3EReorderableSegmentedList>
    with TickerProviderStateMixin {
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

  final Map<int, GlobalKey> _itemKeys = {};
  final Map<int, SingleMotionController> _shiftControllers = {};
  final Map<int, double> _targetShifts = {};
  bool _dragItemIsSelected = false;
  // Suppresses spring radius animations for one frame immediately after a reorder
  // to prevent spurious springs caused by slot identity mismatch: position-keyed
  // States inherit _wasSelected from the previous item at that slot, not the new one.
  bool _suppressRadiusAnimation = false;
  late final SingleMotionController _proxyLiftCtrl;
  late final SingleMotionController _snapMotionCtrl;
  Offset _snapStartOffset = Offset.zero;
  Offset _snapTargetOffset = Offset.zero;
  double _dragStartScrollOffset = 0.0;

  late ScrollController _internalScrollController;
  ScrollController get _effectiveScrollController =>
      widget.controller ?? _internalScrollController;

  @override
  void initState() {
    super.initState();
    _internalScrollController = ScrollController();
    _proxyLiftCtrl = SingleMotionController(
      motion: M3EMotion.expressiveEffectsFast.toMotion(),
      vsync: this,
    );
    final effectiveMotion = widget.decoration?.motion ?? widget.motion;
    _snapMotionCtrl = SingleMotionController(
      motion: effectiveMotion.toMotion(),
      vsync: this,
    );
    assert(() {
      if (widget.selectionMode != M3ESelectionMode.none &&
          widget.keyBuilder == null) {
        debugPrint(
          'M3EReorderableSegmentedList: selectionMode is active but '
          'keyBuilder is null. Item identity defaults to list position, '
          'which causes spurious radius and badge animations after reorder '
          'because M3ESegmentedItemState is reused across logical items. '
          'Pass keyBuilder returning a stable per-item key (e.g. '
          'ValueKey(item.id)) to eliminate this.',
        );
      }
      return true;
    }());
  }

  @override
  void didUpdateWidget(covariant M3EReorderableSegmentedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final effectiveMotion = widget.decoration?.motion ?? widget.motion;
    _snapMotionCtrl.motion = effectiveMotion.toMotion();

    _shiftControllers.removeWhere((idx, ctrl) {
      if (idx >= widget.itemCount) {
        ctrl.dispose();
        return true;
      }
      return false;
    });

    if (widget.itemCount != oldWidget.itemCount) {
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
    super.dispose();
  }

  SingleMotionController _getOrCreateShiftController(int index) {
    if (!_shiftControllers.containsKey(index)) {
      // Use expressiveSpatialDefault for a visibly bouncy but readable
      // neighbor displacement that matches the M3E spec.
      final effectiveMotion = widget.decoration?.motion ?? widget.motion;
      final ctrl = SingleMotionController(
        motion: effectiveMotion.toMotion(),
        vsync: this,
      );
      _shiftControllers[index] = ctrl;
    }
    return _shiftControllers[index]!;
  }

  bool _checkIsSelected(int index) {
    if (widget.isSelected != null) return widget.isSelected!(index);
    if (widget.selectionMode == M3ESelectionMode.none) return false;
    if (widget.selectedIndices != null) {
      return widget.selectedIndices!.contains(index);
    }
    return false;
  }

  void _handleItemTap(int index) {
    if (widget.selectionMode != M3ESelectionMode.none &&
        (widget.selectionTrigger == M3ESelectionTrigger.tap ||
            widget.selectionTrigger == M3ESelectionTrigger.both)) {
      _toggleSelection(index);
    }
    widget.onTap?.call(index);
  }

  void _handleItemLongPress(int index) {
    if (widget.selectionMode != M3ESelectionMode.none &&
        (widget.selectionTrigger == M3ESelectionTrigger.longPress ||
            widget.selectionTrigger == M3ESelectionTrigger.both)) {
      _toggleSelection(index);
    }
    widget.onLongPress?.call(index);
  }

  void _toggleSelection(int index) {
    if (widget.onSelectionChanged == null) return;
    final current = Set<int>.from(widget.selectedIndices ?? const <int>{});

    if (widget.selectionMode == M3ESelectionMode.single) {
      if (current.contains(index)) {
        current.clear();
      } else {
        current
          ..clear()
          ..add(index);
      }
    } else if (widget.selectionMode == M3ESelectionMode.multiple) {
      if (current.contains(index)) {
        current.remove(index);
      } else {
        current.add(index);
      }
    }
    widget.onSelectionChanged!(current);
  }

  Drag? _handleDragStart(int index, Offset globalPos) {
    if (_isSettlingNotifier.value || _draggedIndexNotifier.value != null) {
      return null;
    }
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final itemKey = _itemKeys[index];
    final itemBox = itemKey?.currentContext?.findRenderObject() as RenderBox?;
    final itemLocalOrigin = itemBox != null
        ? renderBox.globalToLocal(itemBox.localToGlobal(Offset.zero))
        : Offset.zero;

    final touchLocal = renderBox.globalToLocal(globalPos);

    final rawItemHeight = itemBox?.size.height ?? 60.0;
    final effectiveGap = widget.decoration?.gap ?? widget.gap;
    final isLastItem = index == widget.itemCount - 1;
    // itemBox includes the bottom gap for all non-last items. Strip the gap so
    // _dragItemHeight represents the card's exact height for the proxy and placeholder.
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

    _dragItemIsSelected = _checkIsSelected(index);
    _draggedIndexNotifier.value = index;
    _targetIndexNotifier.value = index;

    final effectiveEnableFeedback =
        widget.decoration?.enableFeedback ?? widget.enableFeedback;
    final effectiveHaptic = widget.decoration?.haptic ?? widget.haptic;
    if (effectiveEnableFeedback) {
      effectiveHaptic.apply();
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
      onUpdate: _handleDragUpdate,
      onEnd: _handleDragEnd,
      onCancel: () => _handleDragEnd(null),
    );
  }

  void _handleDragUpdate(Offset globalPos) {
    if (_draggedIndexNotifier.value == null || _isSettlingNotifier.value) {
      return;
    }
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPos = renderBox.globalToLocal(globalPos);
    _pointerOffsetNotifier.value = localPos;

    // Auto-scroll when dragging near viewport edges
    if (_effectiveScrollController.hasClients) {
      final double edgeThreshold = 50.0;
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

    // Determine target index by comparing dragged card center with slots
    final draggedCenterY = localPos.dy - _grabOffsetY + (_dragItemHeight / 2.0);
    int bestTarget = _draggedIndexNotifier.value!;
    double closestDist = double.infinity;
    final effectiveGap = widget.decoration?.gap ?? widget.gap;

    for (int i = 0; i < widget.itemCount; i++) {
      final key = _itemKeys[i];
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

    final effectiveGap = widget.decoration?.gap ?? widget.gap;
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
    _dragItemIsSelected = false;
    _draggedIndexNotifier.value = null;
    _targetIndexNotifier.value = null;
    _isSettlingNotifier.value = false;
  }

  void _handleDragEnd([DragEndDetails? details]) {
    final from = _draggedIndexNotifier.value;
    if (from == null || _isSettlingNotifier.value) return;

    final to = _targetIndexNotifier.value ?? from;
    final effectiveGap = widget.decoration?.gap ?? widget.gap;
    final shiftAmount = _dragItemHeight + effectiveGap;

    _snapStartOffset = Offset(
      _dragItemOrigin.dx,
      _pointerOffsetNotifier.value.dy - _grabOffsetY,
    );

    final renderBox = context.findRenderObject() as RenderBox?;
    final viewportHeight = renderBox?.size.height ?? double.infinity;

    final currentScrollOffset = _effectiveScrollController.hasClients
        ? _effectiveScrollController.offset
        : 0.0;
    final scrollDelta = currentScrollOffset - _dragStartScrollOffset;

    // Viewport-relative landing position of target slot `to` at current scroll position:
    final slotToViewportDy =
        _dragItemOrigin.dy + ((to - from) * shiftAmount) - scrollDelta;

    double destinationDy = slotToViewportDy;

    // Bring-into-view: if target slot is partially/fully off-screen, coordinate smooth scroll
    if (_effectiveScrollController.hasClients &&
        viewportHeight.isFinite &&
        _effectiveScrollController.position.hasContentDimensions) {
      double? targetScrollOffset;
      if (slotToViewportDy < 0) {
        // Slot is above top of viewport -> scroll up so slot is visible with padding
        targetScrollOffset =
            (currentScrollOffset + slotToViewportDy - effectiveGap).clamp(
              0.0,
              _effectiveScrollController.position.maxScrollExtent,
            );
      } else if (slotToViewportDy + _dragItemHeight > viewportHeight) {
        // Slot is below bottom of viewport -> scroll down so slot is visible with padding
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
      // Suppress radius animations before cleanup and reorder so that the
      // parent's setState-triggered rebuild passes suppressAnimation=true to
      // every M3ESegmentedItem. This prevents spurious springs from
      // position-keyed slots inheriting stale _wasSelected from the previous
      // item. Cleared on the next frame once state has settled.
      _suppressRadiusAnimation = true;
      _cleanupDragState();

      if (from != to) {
        final reorderTo = to > from ? to + 1 : to;
        widget.onReorder(from, reorderTo);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _suppressRadiusAnimation = false;
      });
    }

    final initialDistance = (_snapStartOffset.dy - destinationDy).abs();
    if (initialDistance <= 1.0) {
      completeSettling();
      return;
    }

    // Compute normalized velocity along the snap travel vector (from 0.0 to 1.0)
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

  Widget _buildPlaceholder(BuildContext context, int targetSlot) {
    final effectiveDragPlaceholderColor =
        widget.decoration?.dragPlaceholderColor ?? widget.dragPlaceholderColor;
    final effectiveDragPlaceholderBorder =
        widget.decoration?.dragPlaceholderBorder ??
        widget.dragPlaceholderBorder;
    final effectiveDragPlaceholderRadius =
        widget.decoration?.dragPlaceholderRadius ??
        widget.dragPlaceholderRadius;
    final effectiveDragPlaceholderBuilder =
        widget.decoration?.dragPlaceholderBuilder ??
        widget.dragPlaceholderBuilder;
    final effectiveOuterRadius =
        widget.decoration?.outerRadius ?? widget.outerRadius;
    final effectiveInnerRadius =
        widget.decoration?.innerRadius ?? widget.innerRadius;

    final placeholderPosition = calculateSegmentedItemPosition(
      targetSlot,
      widget.itemCount,
    );

    final placeholderRadius = effectiveDragPlaceholderRadius != null
        ? BorderRadius.circular(effectiveDragPlaceholderRadius)
        : (effectiveDragPlaceholderBorder != null
              ? BorderRadius.circular(effectiveOuterRadius)
              : calculateSegmentedItemRadius(
                  position: placeholderPosition,
                  outerRadius: effectiveOuterRadius,
                  innerRadius: effectiveInnerRadius,
                ));

    if (effectiveDragPlaceholderBuilder != null) {
      return effectiveDragPlaceholderBuilder(
        context,
        targetSlot,
        Size(_dragItemWidth, _dragItemHeight),
      );
    }

    final cs = Theme.of(context).colorScheme;
    final effectiveMotion = widget.decoration?.motion ?? widget.motion;
    return M3ESegmentedRadiusMotion(
      motion: effectiveMotion.toMotion(),
      targetRadius: placeholderRadius,
      builder: (context, animatedRadius) {
        return Container(
          width: _dragItemWidth,
          height: _dragItemHeight,
          decoration: BoxDecoration(
            color: effectiveDragPlaceholderColor ?? cs.surfaceContainerLow,
            borderRadius: animatedRadius,
            border: effectiveDragPlaceholderBorder != null
                ? Border.fromBorderSide(effectiveDragPlaceholderBorder)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildProxyItem(BuildContext context, int index) {
    final effectiveOuterRadius =
        widget.decoration?.outerRadius ?? widget.outerRadius;
    final effectiveInnerRadius =
        widget.decoration?.innerRadius ?? widget.innerRadius;
    final effectiveDragRadius =
        widget.decoration?.dragRadius ?? widget.dragRadius;
    final effectiveDragBorderRadius =
        widget.decoration?.dragBorderRadius ?? widget.dragBorderRadius;
    final effectiveDragElevation =
        widget.decoration?.dragElevation ?? widget.dragElevation;
    final effectiveDragScale = widget.decoration?.dragScale ?? widget.dragScale;
    final effectiveDragColor = widget.decoration?.dragColor ?? widget.dragColor;
    final effectiveSelectedColor =
        widget.decoration?.selectedColor ?? widget.selectedColor;
    final effectiveSelectedBorder =
        widget.decoration?.selectedBorder ?? widget.selectedBorder;
    final effectiveColor = widget.decoration?.color ?? widget.color;
    final effectiveBorder = widget.decoration?.border ?? widget.border;
    final effectiveElevation = widget.decoration?.elevation ?? widget.elevation;
    final effectiveSelectedElevation =
        widget.decoration?.selectedElevation ?? widget.selectedElevation;
    final effectiveSelectedRadius =
        widget.decoration?.selectedRadius ?? widget.selectedRadius;
    final effectiveSelectedBorderRadius =
        widget.decoration?.selectedBorderRadius ?? widget.selectedBorderRadius;
    final effectivePadding = widget.decoration?.padding ?? widget.padding;
    final effectiveShowSelectionCheckmark =
        widget.decoration?.showSelectionCheckmark ??
        widget.showSelectionCheckmark;
    final effectiveSelectionCheckmarkAlignment =
        widget.decoration?.selectionCheckmarkAlignment ??
        widget.selectionCheckmarkAlignment;

    final fromIndex = _draggedIndexNotifier.value ?? index;

    final restingPosition = calculateSegmentedItemPosition(
      fromIndex,
      widget.itemCount,
    );
    final restingRadius = calculateSegmentedItemRadius(
      position: restingPosition,
      outerRadius: effectiveOuterRadius,
      innerRadius: effectiveInnerRadius,
    );

    final floatingRadius =
        effectiveDragBorderRadius ??
        (effectiveDragRadius != null
            ? BorderRadius.circular(effectiveDragRadius)
            : BorderRadius.circular(effectiveOuterRadius));

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

        final isSel = _checkIsSelected(index);
        final colorScheme = Theme.of(context).colorScheme;

        final currentTargetIndex = _targetIndexNotifier.value ?? fromIndex;
        final dynamicLandingPosition = calculateSegmentedItemPosition(
          currentTargetIndex,
          widget.itemCount,
        );
        final dynamicLandingRadius = calculateSegmentedItemRadius(
          position: dynamicLandingPosition,
          outerRadius: effectiveOuterRadius,
          innerRadius: effectiveInnerRadius,
        );

        final targetLandingRadius = isSel
            ? (effectiveSelectedBorderRadius ??
                  (effectiveSelectedRadius != null
                      ? BorderRadius.circular(effectiveSelectedRadius)
                      : dynamicLandingRadius))
            : dynamicLandingRadius;

        final restingLandingRadius = isSel
            ? (effectiveSelectedBorderRadius ??
                  (effectiveSelectedRadius != null
                      ? BorderRadius.circular(effectiveSelectedRadius)
                      : restingRadius))
            : restingRadius;

        final targetLandingElevation = isSel
            ? (effectiveSelectedElevation ?? effectiveElevation)
            : effectiveElevation;

        if (isSettling) {
          final double snapT = _snapMotionCtrl.value.clamp(0.0, 1.0);
          scale = lerpDouble(effectiveDragScale, 1.0, snapT)!;
          elev = lerpDouble(
            effectiveDragElevation,
            targetLandingElevation,
            snapT,
          )!;
          currentRadius =
              BorderRadius.lerp(floatingRadius, targetLandingRadius, snapT) ??
              targetLandingRadius;
        } else {
          final double liftT = _proxyLiftCtrl.value.clamp(0.0, 1.0);
          scale = lerpDouble(1.0, effectiveDragScale, liftT)!;
          elev = lerpDouble(
            targetLandingElevation,
            effectiveDragElevation,
            liftT,
          )!;
          currentRadius =
              BorderRadius.lerp(restingLandingRadius, floatingRadius, liftT) ??
              floatingRadius;
        }

        final effectiveBgColor =
            effectiveDragColor ??
            (isSel
                ? (effectiveSelectedColor ?? colorScheme.secondaryContainer)
                : (effectiveColor ?? colorScheme.surfaceContainerHigh));

        final effectiveBorderSide = isSel
            ? (effectiveSelectedBorder ?? effectiveBorder ?? BorderSide.none)
            : (effectiveBorder ?? BorderSide.none);

        Widget itemContent = widget.itemBuilder(context, index);
        if (widget.buildDefaultDragHandles) {
          itemContent = Row(
            children: [
              Expanded(child: itemContent),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.drag_handle_rounded),
              ),
            ],
          );
        }

        if (widget.selectionMode != M3ESelectionMode.none &&
            effectiveShowSelectionCheckmark) {
          final checkmark = widget.selectionCheckmarkBuilder != null
              ? widget.selectionCheckmarkBuilder!(context, index, isSel)
              : M3EDefaultSelectionBadge(
                  isSelected: isSel,
                  selectedColor: colorScheme.primary,
                  onSelectedColor: colorScheme.onPrimary,
                );

          itemContent = Stack(
            alignment: Alignment.center,
            children: [
              itemContent,
              Positioned.fill(
                child: Align(
                  alignment: effectiveSelectionCheckmarkAlignment,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: checkmark,
                  ),
                ),
              ),
            ],
          );
        }

        Widget proxyItem = Container(
          width: _dragItemWidth,
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: currentRadius,
            border: Border.fromBorderSide(effectiveBorderSide),
            boxShadow: elev > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isSel ? 0.14 : 0.1),
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
              padding: effectivePadding ?? const EdgeInsets.all(12.0),
              child: itemContent,
            ),
          ),
        );

        if (scale != 1.0) {
          proxyItem = Transform.scale(scale: scale, child: proxyItem);
        }

        Offset currentOffset;
        if (isSettling) {
          final snapT = _snapMotionCtrl.value;
          currentOffset = Offset(
            _snapStartOffset.dx,
            lerpDouble(_snapStartOffset.dy, _snapTargetOffset.dy, snapT) ??
                _snapTargetOffset.dy,
          );
        } else {
          currentOffset = Offset(
            _dragItemOrigin.dx,
            _pointerOffsetNotifier.value.dy - _grabOffsetY,
          );
        }

        return Positioned(
          left: currentOffset.dx,
          top: currentOffset.dy,
          child: IgnorePointer(child: proxyItem),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    // Use _dragItemIsSelected (frozen at drag-start) for the dragged slot to prevent
    // a 1-frame selection flash when the parent remaps selectedIndices in onReorder.
    final draggedIndex = _draggedIndexNotifier.value;
    final selected = (draggedIndex != null && draggedIndex == index)
        ? _dragItemIsSelected
        : _checkIsSelected(index);
    final enabled = widget.isEnabled?.call(index) ?? true;

    final hasTap =
        enabled &&
        (widget.onTap != null ||
            (widget.selectionMode != M3ESelectionMode.none &&
                (widget.selectionTrigger == M3ESelectionTrigger.tap ||
                    widget.selectionTrigger == M3ESelectionTrigger.both)));
    final hasLongPress =
        enabled &&
        (widget.onLongPress != null ||
            (widget.selectionMode != M3ESelectionMode.none &&
                (widget.selectionTrigger == M3ESelectionTrigger.longPress ||
                    widget.selectionTrigger == M3ESelectionTrigger.both)));

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

    final Key itemKey = widget.keyBuilder != null
        ? widget.keyBuilder!(index)
        : (childContent.key ?? ValueKey('m3e_reorderable_item_$index'));

    _itemKeys[index] ??= GlobalKey();

    final effectiveOuterRadius =
        widget.decoration?.outerRadius ?? widget.outerRadius;
    final effectiveInnerRadius =
        widget.decoration?.innerRadius ?? widget.innerRadius;
    final effectiveGap = widget.decoration?.gap ?? widget.gap;
    final effectiveColor = widget.decoration?.color ?? widget.color;
    final effectivePadding = widget.decoration?.padding ?? widget.padding;
    final effectiveBorder = widget.decoration?.border ?? widget.border;
    final effectiveElevation = widget.decoration?.elevation ?? widget.elevation;
    final effectiveSplashColor =
        widget.decoration?.splashColor ?? widget.splashColor;
    final effectiveHighlightColor =
        widget.decoration?.highlightColor ?? widget.highlightColor;
    final effectiveHoverColor =
        widget.decoration?.hoverColor ?? widget.hoverColor;
    final effectiveFocusColor =
        widget.decoration?.focusColor ?? widget.focusColor;
    final effectiveSplashFactory =
        widget.decoration?.splashFactory ?? widget.splashFactory;
    final effectiveEnableFeedback =
        widget.decoration?.enableFeedback ?? widget.enableFeedback;
    final effectiveHaptic = widget.decoration?.haptic ?? widget.haptic;
    final effectiveDisabledColor = widget.decoration?.disabledColor;
    final effectiveDisabledBorder = widget.decoration?.disabledBorder;
    final effectiveFocusedColor = widget.decoration?.focusedColor;
    final effectiveFocusedBorder = widget.decoration?.focusedBorder;
    final effectiveFocusedRadius = widget.decoration?.focusedRadius;
    final effectiveFocusedBorderRadius = widget.decoration?.focusedBorderRadius;
    final effectiveFocusedElevation = widget.decoration?.focusedElevation;
    final effectiveSelectedColor =
        widget.decoration?.selectedColor ?? widget.selectedColor;
    final effectiveSelectedBorder =
        widget.decoration?.selectedBorder ?? widget.selectedBorder;
    final effectiveSelectedRadius =
        widget.decoration?.selectedRadius ?? widget.selectedRadius;
    // When no explicit selectedRadius/selectedBorderRadius is set, the fallback inside
    // M3ESegmentedItem is unselectedRadius (computed from widget.position = dynamicPosition).
    // During drag, dynamicPosition shifts as items are displaced, which changes that fallback
    // and triggers a spurious corner-radius spring on every selected item in the range.
    // Fix: pre-compute the fallback from the ORIGINAL (static, index-based) position and
    // pass it as selectedBorderRadius so the dynamic position never feeds into it.
    final effectiveSelectedBorderRadius =
        widget.decoration?.selectedBorderRadius ??
        widget.selectedBorderRadius ??
        (effectiveSelectedRadius == null
            ? calculateSegmentedItemRadius(
                position: calculateSegmentedItemPosition(
                  index,
                  widget.itemCount,
                ),
                outerRadius: effectiveOuterRadius,
                innerRadius: effectiveInnerRadius,
              )
            : null);
    final effectiveSelectedElevation =
        widget.decoration?.selectedElevation ?? widget.selectedElevation;
    final effectivePressedRadius =
        widget.decoration?.pressedRadius ?? widget.pressedRadius;
    final effectivePressedBorderRadius =
        widget.decoration?.pressedBorderRadius ?? widget.pressedBorderRadius;
    final effectivePressedScale =
        widget.decoration?.pressedScale ?? widget.pressedScale;
    final effectiveHoveredRadius =
        widget.decoration?.hoveredRadius ?? widget.hoveredRadius;
    final effectiveHoveredBorderRadius =
        widget.decoration?.hoveredBorderRadius ?? widget.hoveredBorderRadius;
    final effectiveShowSelectionCheckmark =
        widget.decoration?.showSelectionCheckmark ??
        widget.showSelectionCheckmark;
    final effectiveSelectionCheckmarkAlignment =
        widget.decoration?.selectionCheckmarkAlignment ??
        widget.selectionCheckmarkAlignment;
    final effectiveMotion = widget.decoration?.motion ?? widget.motion;
    final effectivePressedMotion =
        widget.decoration?.pressedMotion ?? widget.pressedMotion;

    final shiftCtrl = _getOrCreateShiftController(index);

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
          final isBeingDragged = draggedIndex == index;
          final isPlaceholderSlot =
              draggedIndex != null && targetIndex == index;

          int visualIndex = index;
          if (draggedIndex != null && targetIndex != null) {
            if (index == draggedIndex) {
              visualIndex = targetIndex;
            } else if (draggedIndex < targetIndex) {
              if (index > draggedIndex && index <= targetIndex) {
                visualIndex = index - 1;
              }
            } else if (draggedIndex > targetIndex) {
              if (index >= targetIndex && index < draggedIndex) {
                visualIndex = index + 1;
              }
            }
          }

          final dynamicPosition = calculateSegmentedItemPosition(
            visualIndex,
            widget.itemCount,
          );

          final itemWidget = M3ESegmentedItem(
            index: index,
            position: dynamicPosition,
            outerRadius: effectiveOuterRadius,
            innerRadius: effectiveInnerRadius,
            gap: effectiveGap,
            color: effectiveColor,
            padding: effectivePadding,
            enabled: enabled,
            disabledColor: effectiveDisabledColor,
            disabledBorder: effectiveDisabledBorder,
            focusedColor: effectiveFocusedColor,
            focusedBorder: effectiveFocusedBorder,
            focusedRadius: effectiveFocusedRadius,
            focusedBorderRadius: effectiveFocusedBorderRadius,
            focusedElevation: effectiveFocusedElevation,
            onTap: hasTap ? _handleItemTap : null,
            onLongPress: hasLongPress ? _handleItemLongPress : null,
            semanticLabel: widget.semanticLabelBuilder?.call(index),
            mouseCursor: widget.mouseCursor,
            focusColor: effectiveFocusColor,
            hoverColor: effectiveHoverColor,
            onFocusChange: widget.onFocusChange != null
                ? (focused) => widget.onFocusChange!(index, focused)
                : null,
            border: effectiveBorder,
            elevation: effectiveElevation,
            splashColor: effectiveSplashColor,
            highlightColor: effectiveHighlightColor,
            splashFactory: effectiveSplashFactory,
            enableFeedback: effectiveEnableFeedback,
            haptic: effectiveHaptic,
            isSelected: selected,
            selectedColor: effectiveSelectedColor,
            selectedBorder: effectiveSelectedBorder,
            selectedRadius: effectiveSelectedRadius,
            selectedBorderRadius: effectiveSelectedBorderRadius,
            selectedElevation: effectiveSelectedElevation,
            pressedRadius: effectivePressedRadius,
            pressedBorderRadius: effectivePressedBorderRadius,
            pressedScale: effectivePressedScale,
            hoveredRadius: effectiveHoveredRadius,
            hoveredBorderRadius: effectiveHoveredBorderRadius,
            showSelectionCheckmark:
                widget.selectionMode != M3ESelectionMode.none &&
                effectiveShowSelectionCheckmark,
            selectionCheckmarkAlignment: effectiveSelectionCheckmarkAlignment,
            selectionCheckmarkBuilder: widget.selectionCheckmarkBuilder != null
                ? (ctx, isSel) =>
                      widget.selectionCheckmarkBuilder!(ctx, index, isSel)
                : null,
            motion: effectiveMotion,
            pressedMotion: effectivePressedMotion,
            // Suppress radius spring for one frame after reorder to prevent
            // spurious animations from position-keyed slot identity mismatch.
            suppressAnimation: _suppressRadiusAnimation,
            // Decouple the physical bottom gap from dynamic visual position:
            // the layout gap is strictly determined by physical slot index.
            isLast: index == widget.itemCount - 1,
            child: childContent,
          );

          final itemContentWithVisibility = Visibility(
            visible: !isBeingDragged,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: itemWidget,
          );

          final wrappedItem = _M3EReorderItemDragStartListener(
            index: index,
            delayed: true,
            onStartDrag: _handleDragStart,
            child: itemContentWithVisibility,
          );

          return Stack(
            key: _itemKeys[index],
            clipBehavior: Clip.none,
            children: [
              if (isPlaceholderSlot)
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: (index == widget.itemCount - 1)
                          ? 0
                          : effectiveGap,
                    ),
                    child: _buildPlaceholder(context, index),
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

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return widget.emptyBuilder ?? const SizedBox.shrink();
    }

    final effectiveMargin = widget.decoration?.margin ?? widget.margin;
    final effectivePadding = widget.listPadding;

    Widget content = Stack(
      clipBehavior: Clip.none,
      children: [
        ListView.builder(
          controller: _effectiveScrollController,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          padding: effectivePadding,
          itemCount:
              widget.itemCount +
              (widget.header != null ? 1 : 0) +
              (widget.footer != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (widget.header != null) {
              if (index == 0) return widget.header!;
              index--;
            }
            if (index >= widget.itemCount) {
              return widget.footer ?? const SizedBox.shrink();
            }
            return _buildItem(context, index);
          },
        ),
        ValueListenableBuilder<int?>(
          valueListenable: _draggedIndexNotifier,
          builder: (context, draggedIndex, _) {
            if (draggedIndex == null) return const SizedBox.shrink();
            return _buildProxyItem(context, draggedIndex);
          },
        ),
      ],
    );

    if (effectiveMargin != null && effectiveMargin != EdgeInsets.zero) {
      return Padding(padding: effectiveMargin, child: content);
    }
    return content;
  }
}

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
