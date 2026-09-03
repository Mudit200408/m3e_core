// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../common/m3e_common.dart';
import 'm3e_segmented_item.dart';
import 'style/m3e_segmented_list_decoration.dart';

/// A Material 3 static segmented row with dynamically rounded horizontal corners and selection support.
///
/// `M3ESegmentedRow` renders a horizontal row of items from a static list of [children],
/// where the first item has outer rounded left corners, the last item has outer rounded right corners,
/// and inner items have smaller inner radii, adhering to Material 3's expressive list design.
class M3ESegmentedRow extends StatelessWidget {
  /// The list of static children to display in the row.
  final List<Widget> children;

  /// The radius used for the left corners of the first item, the right corners
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
  ///
  /// Defaults to [ColorScheme.surfaceContainer] if null.
  final Color? color;

  /// The inner padding applied to each child.
  ///
  /// Defaults to `EdgeInsets.all(12.0)`.
  final EdgeInsetsGeometry? padding;

  /// The outer margin applied around the entire group of items.
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

  /// The elevation of the item when unselected.
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

  /// Widget displayed when the row is empty.
  final Widget? emptyBuilder;

  // --- Row Layout API ---

  /// Whether each child item expands equally to fill available horizontal width.
  ///
  /// Defaults to `true`. When false, items take their natural intrinsic widths.
  final bool equalWidth;

  /// Whether each item matches the height of the tallest item in the row.
  ///
  /// Defaults to `true`. When true, wraps the row in [IntrinsicHeight] and
  /// sets [CrossAxisAlignment.stretch].
  final bool equalHeight;

  /// Optional flex factors for each item in [children].
  ///
  /// When provided, overrides [equalWidth] and wraps each item in [Expanded]
  /// with the corresponding flex factor.
  final List<int>? flexes;

  /// How the children should be placed along the main (horizontal) axis.
  ///
  /// Defaults to [MainAxisAlignment.start].
  final MainAxisAlignment mainAxisAlignment;

  /// How the children should be placed along the cross (vertical) axis.
  ///
  /// Defaults to [CrossAxisAlignment.center]. Ignored if [equalHeight] is true.
  final CrossAxisAlignment crossAxisAlignment;

  /// How much space the row should occupy along the main axis.
  ///
  /// Defaults to [MainAxisSize.max].
  final MainAxisSize mainAxisSize;

  // --- Selection & Morphing API ---

  /// Currently selected item indices.
  final Set<int>? selectedIndices;

  /// Callback invoked whenever the selection set changes.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// The selection mode for this row (none, single, or multiple).
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
  final M3ESegmentedListDecoration? decoration;

  /// Optional predicate to determine if a specific child index is enabled.
  ///
  /// Defaults to `null` (all items enabled).
  final bool Function(int index)? isEnabled;

  /// Creates an [M3ESegmentedRow].
  const M3ESegmentedRow({
    super.key,
    required this.children,
    this.decoration,
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
    this.equalWidth = true,
    this.equalHeight = true,
    this.flexes,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
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
  });

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

  @override
  Widget build(BuildContext context) {
    final count = children.length;
    if (count == 0) {
      return emptyBuilder ?? const SizedBox.shrink();
    }

    final effectiveOuterRadius = decoration?.outerRadius ?? outerRadius;
    final effectiveInnerRadius = decoration?.innerRadius ?? innerRadius;
    final effectiveGap = decoration?.gap ?? gap;
    final effectiveColor = decoration?.color ?? color;
    final effectivePadding =
        decoration?.padding ??
        padding ??
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0);
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
    final effectiveMargin = decoration?.margin ?? margin;

    final rowChildren = List.generate(count, (index) {
      final position = calculateSegmentedItemPosition(index, count);
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

      final item = M3ESegmentedItem(
        index: index,
        axis: Axis.horizontal,
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
        child: children[index],
      );

      if (flexes != null && index < flexes!.length) {
        return Expanded(flex: flexes![index], child: item);
      } else if (equalWidth) {
        return Expanded(child: item);
      }
      return item;
    });

    Widget row = Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: equalHeight
          ? CrossAxisAlignment.stretch
          : crossAxisAlignment,
      children: rowChildren,
    );

    if (equalHeight) {
      row = IntrinsicHeight(child: row);
    }

    if (effectiveMargin != null && effectiveMargin != EdgeInsets.zero) {
      return Padding(padding: effectiveMargin, child: row);
    }
    return row;
  }
}
