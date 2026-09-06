import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../common/m3e_common.dart';
import 'm3e_segmented_item.dart';
import 'style/m3e_segmented_list_decoration.dart';

/// A Material 3 interactive segmented list with dynamically rounded corners and selection support.
///
/// `M3ESegmentedList` renders a vertical list of items, where the first and last
/// items automatically have a larger outer radius, and the inner items have
/// a smaller inner radius, adhering to Material 3's expressive list design.
///
/// Use the default constructor for small lists (using [Column]) or
/// [M3ESegmentedList.builder] for large or infinite lists (using [ListView.builder]).
class M3ESegmentedList extends StatelessWidget {
  /// The number of items in the list.
  final int itemCount;

  /// Signature for a function that creates a widget for a given index.
  final IndexedWidgetBuilder itemBuilder;

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
  /// Defaults to `3.0`.
  final double gap;

  /// The background color for each item when unselected.
  ///
  /// Defaults to [ColorScheme.surfaceContainer] if null.
  final Color? color;

  /// The inner padding applied to the [itemBuilder] child of each item.
  ///
  /// Defaults to `EdgeInsets.all(12.0)`.
  final EdgeInsetsGeometry? padding;

  /// The outer margin applied around the entire list.
  ///
  /// Defaults to [EdgeInsets.zero].
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
  ///
  /// Defaults to [BorderSide.none].
  final BorderSide? border;

  /// The elevation of each item when unselected.
  ///
  /// Defaults to `0`.
  final double elevation;

  /// The splash color of the ink response when tapped.
  final Color? splashColor;

  /// The highlight color of the ink response when tapped.
  final Color? highlightColor;

  /// Defines the appearance of the splash.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// Defaults to `true`.
  final bool enableFeedback;

  /// The haptic feedback to provide on interaction.
  final M3EHapticFeedback haptic;

  /// Widget displayed when the list is empty (itemCount is 0).
  final Widget? emptyBuilder;

  // --- Selection & Morphing API ---

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

  /// Optional styling, motion, and interaction overrides for the segmented list.
  ///
  /// If non-null, properties specified here take precedence over individual widget parameters.
  final M3ESegmentedListDecoration? decoration;

  /// Whether this list uses [ListView.builder] (true) or [Column] (false).
  final bool _isBuilder;

  /// Controls the scroll position of the list.
  ///
  /// Only used by [M3ESegmentedList.builder].
  final ScrollController? controller;

  /// How the scroll view should respond to user input.
  ///
  /// Only used by [M3ESegmentedList.builder].
  final ScrollPhysics? physics;

  /// Whether the scroll view should size itself to fit its children.
  ///
  /// Only used by [M3ESegmentedList.builder].
  final bool shrinkWrap;

  /// Padding for the scrollable list itself.
  ///
  /// Only used by [M3ESegmentedList.builder].
  final EdgeInsetsGeometry? listPadding;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  final bool addSemanticIndexes;

  /// The cache extent for the scroll view.
  final double? cacheExtent;

  /// Determines the way that drag start behavior is handled.
  final DragStartBehavior dragStartBehavior;

  /// Defines how the scroll view should dismiss the keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Restoration ID to save and restore the scroll offset.
  final String? restorationId;

  /// The clip behavior of the scroll view.
  final Clip clipBehavior;

  /// Optional predicate to determine if a specific item index is enabled.
  ///
  /// Defaults to `null` (all items enabled).
  final bool Function(int index)? isEnabled;

  /// Creates a Material 3 Expressive static segmented list (renders via [Column]).
  const M3ESegmentedList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.decoration,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 2.0,
    this.color,
    this.padding = const EdgeInsets.all(12.0),
    this.margin = EdgeInsets.zero,
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
  }) : _isBuilder = false,

       controller = null,
       physics = null,
       shrinkWrap = false,
       listPadding = null,
       addAutomaticKeepAlives = true,
       addRepaintBoundaries = true,
       addSemanticIndexes = true,
       cacheExtent = null,
       dragStartBehavior = DragStartBehavior.start,
       keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
       restorationId = null,
       clipBehavior = Clip.hardEdge;

  /// Creates a Material 3 Expressive lazily loaded segmented list (renders via [ListView.builder]).
  const M3ESegmentedList.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.decoration,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 2.0,
    this.color,
    this.padding = const EdgeInsets.all(12.0),
    this.margin = EdgeInsets.zero,
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
    this.motion = M3EMotion.standardSpatialDefault,
    this.pressedMotion = M3EMotion.expressiveEffectsFast,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.listPadding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : _isBuilder = true;

  bool _checkIsSelected(int index) {
    if (isSelected != null) return isSelected!(index);
    if (selectionMode == M3ESelectionMode.none) return false;
    if (selectedIndices != null) return selectedIndices!.contains(index);
    return false;
  }

  void _handleItemTap(int index) {
    if (selectionMode != M3ESelectionMode.none &&
        (selectionTrigger == M3ESelectionTrigger.tap ||
            selectionTrigger == M3ESelectionTrigger.both)) {
      _toggleSelection(index);
    }
    onTap?.call(index);
  }

  void _handleItemLongPress(int index) {
    if (selectionMode != M3ESelectionMode.none &&
        (selectionTrigger == M3ESelectionTrigger.longPress ||
            selectionTrigger == M3ESelectionTrigger.both)) {
      _toggleSelection(index);
    }
    onLongPress?.call(index);
  }

  void _toggleSelection(int index) {
    if (onSelectionChanged == null) return;
    final current = Set<int>.from(selectedIndices ?? const <int>{});

    if (selectionMode == M3ESelectionMode.single) {
      if (current.contains(index)) {
        current.clear();
      } else {
        current
          ..clear()
          ..add(index);
      }
    } else if (selectionMode == M3ESelectionMode.multiple) {
      if (current.contains(index)) {
        current.remove(index);
      } else {
        current.add(index);
      }
    }
    onSelectionChanged!(current);
  }

  Widget _buildItem(BuildContext context, int index) {
    final position = calculateSegmentedItemPosition(index, itemCount);
    final selected = _checkIsSelected(index);
    final enabled = isEnabled?.call(index) ?? true;

    final hasTap =
        enabled &&
        (onTap != null ||
            (selectionMode != M3ESelectionMode.none &&
                (selectionTrigger == M3ESelectionTrigger.tap ||
                    selectionTrigger == M3ESelectionTrigger.both)));
    final hasLongPress =
        enabled &&
        (onLongPress != null ||
            (selectionMode != M3ESelectionMode.none &&
                (selectionTrigger == M3ESelectionTrigger.longPress ||
                    selectionTrigger == M3ESelectionTrigger.both)));

    final effectiveOuterRadius = decoration?.outerRadius ?? outerRadius;
    final effectiveInnerRadius = decoration?.innerRadius ?? innerRadius;
    final effectiveGap = decoration?.gap ?? gap;
    final effectiveColor = decoration?.color ?? color;
    final effectivePadding = decoration?.padding ?? padding;
    final effectiveBorder = decoration?.border ?? border;
    final effectiveElevation = decoration?.elevation ?? elevation;
    final effectiveSplashColor = decoration?.splashColor ?? splashColor;
    final effectiveHighlightColor =
        decoration?.highlightColor ?? highlightColor;
    final effectiveHoverColor = decoration?.hoverColor ?? hoverColor;
    final effectiveFocusColor = decoration?.focusColor ?? focusColor;
    final effectiveSplashFactory = decoration?.splashFactory ?? splashFactory;
    final effectiveEnableFeedback =
        decoration?.enableFeedback ?? enableFeedback;
    final effectiveHaptic = decoration?.haptic ?? haptic;
    final effectiveDisabledColor = decoration?.disabledColor;
    final effectiveDisabledBorder = decoration?.disabledBorder;
    final effectiveFocusedColor = decoration?.focusedColor;
    final effectiveFocusedBorder = decoration?.focusedBorder;
    final effectiveFocusedRadius = decoration?.focusedRadius;
    final effectiveFocusedBorderRadius = decoration?.focusedBorderRadius;
    final effectiveFocusedElevation = decoration?.focusedElevation;
    final effectiveFocusRingColor = decoration?.focusRingColor;
    final effectiveFocusRingWidth = decoration?.focusRingWidth ?? 2.0;
    final effectiveFocusRingGap = decoration?.focusRingGap ?? 0.0;
    final effectiveSelectedColor = decoration?.selectedColor ?? selectedColor;
    final effectiveSelectedBorder =
        decoration?.selectedBorder ?? selectedBorder;
    final effectiveSelectedRadius =
        decoration?.selectedRadius ?? selectedRadius;
    final effectiveSelectedBorderRadius =
        decoration?.selectedBorderRadius ?? selectedBorderRadius;
    final effectiveSelectedElevation =
        decoration?.selectedElevation ?? selectedElevation;
    final effectivePressedRadius = decoration?.pressedRadius ?? pressedRadius;
    final effectivePressedBorderRadius =
        decoration?.pressedBorderRadius ?? pressedBorderRadius;
    final effectivePressedScale = decoration?.pressedScale ?? pressedScale;
    final effectiveHoveredRadius = decoration?.hoveredRadius ?? hoveredRadius;
    final effectiveHoveredBorderRadius =
        decoration?.hoveredBorderRadius ?? hoveredBorderRadius;
    final effectiveShowSelectionCheckmark =
        decoration?.showSelectionCheckmark ?? showSelectionCheckmark;
    final effectiveSelectionCheckmarkAlignment =
        decoration?.selectionCheckmarkAlignment ?? selectionCheckmarkAlignment;
    final effectiveMotion = decoration?.motion ?? motion;
    final effectivePressedMotion = decoration?.pressedMotion ?? pressedMotion;

    return M3ESegmentedItem(
      index: index,
      position: position,
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
      focusRingColor: effectiveFocusRingColor,
      focusRingWidth: effectiveFocusRingWidth,
      focusRingGap: effectiveFocusRingGap,
      onTap: hasTap ? _handleItemTap : null,
      onLongPress: hasLongPress ? _handleItemLongPress : null,
      semanticLabel: semanticLabelBuilder?.call(index),
      mouseCursor: mouseCursor,
      focusColor: effectiveFocusColor,
      hoverColor: effectiveHoverColor,
      onFocusChange: onFocusChange != null
          ? (focused) => onFocusChange!(index, focused)
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
          selectionMode != M3ESelectionMode.none &&
          effectiveShowSelectionCheckmark,
      selectionCheckmarkAlignment: effectiveSelectionCheckmarkAlignment,
      selectionCheckmarkBuilder: selectionCheckmarkBuilder != null
          ? (ctx, isSel) => selectionCheckmarkBuilder!(ctx, index, isSel)
          : null,
      motion: effectiveMotion,
      pressedMotion: effectivePressedMotion,
      child: itemBuilder(context, index),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return emptyBuilder ?? const SizedBox.shrink();
    }

    final effectiveMargin = decoration?.margin ?? margin;

    if (!_isBuilder) {
      final column = FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            itemCount,
            (index) => _buildItem(context, index),
          ),
        ),
      );

      if (effectiveMargin != null && effectiveMargin != EdgeInsets.zero) {
        return Padding(padding: effectiveMargin, child: column);
      }
      return column;
    }

    final listView = FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: ListView.builder(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: listPadding,
        itemCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        // ignore: deprecated_member_use
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        itemBuilder: _buildItem,
      ),
    );

    if (effectiveMargin != null && effectiveMargin != EdgeInsets.zero) {
      return Padding(padding: effectiveMargin, child: listView);
    }
    return listView;
  }
}
