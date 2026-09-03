// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

import '../../common/m3e_common.dart';

/// Styling, geometry, motion, and interaction overrides for Material 3 Expressive Segmented Lists.
///
/// Encapsulates all visual customization properties for [M3ESegmentedList], [M3ESegmentedColumn],
/// [M3ESegmentedRow], [SliverM3ESegmentedList], and [M3EReorderableSegmentedList].
@immutable
class M3ESegmentedListDecoration {
  // --- Base Geometry & Styling ---

  /// Outer corner radius applied to the first and last items.
  final double outerRadius;

  /// Inner corner radius applied between adjacent items.
  final double innerRadius;

  /// Gap spacing between items.
  final double gap;

  /// Default background color of the segmented items.
  final Color? color;

  /// Inner padding inside each segmented item.
  final EdgeInsetsGeometry? padding;

  /// Outer margin surrounding the segmented container.
  final EdgeInsetsGeometry? margin;

  /// Border outline for resting items.
  final BorderSide? border;

  /// Elevation shadow for resting items.
  final double elevation;

  /// Splash color for touch ripples.
  final Color? splashColor;

  /// Highlight color for touch presses.
  final Color? highlightColor;

  /// Hover color for mouse hover.
  final Color? hoverColor;

  /// Focus color for keyboard focus highlight.
  final Color? focusColor;

  /// Custom splash factory for ink ripples.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether acoustic/haptic feedback is enabled.
  final bool enableFeedback;

  /// Haptic feedback level to trigger on interaction.
  final M3EHapticFeedback haptic;

  // --- Disabled Styling ---

  /// Background color applied to disabled items.
  final Color? disabledColor;

  /// Border applied to disabled items.
  final BorderSide? disabledBorder;

  // --- Focus Styling ---

  /// Background color applied when an item is focused.
  final Color? focusedColor;

  /// Border outline applied when an item is focused.
  final BorderSide? focusedBorder;

  /// Corner radius applied to all corners when an item is focused.
  final double? focusedRadius;

  /// Custom [BorderRadius] applied when an item is focused.
  final BorderRadius? focusedBorderRadius;

  /// Elevation applied when an item is focused.
  final double? focusedElevation;

  // --- Selection Styling ---

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

  /// Whether to render an animated selection checkmark badge on selected items.
  final bool showSelectionCheckmark;

  /// Alignment of the selection checkmark badge.
  final Alignment selectionCheckmarkAlignment;

  // --- Interactive Morphing ---

  /// Corner radius applied to all corners when an item is pressed.
  final double? pressedRadius;

  /// Custom [BorderRadius] applied when an item is pressed.
  final BorderRadius? pressedBorderRadius;

  /// Scale factor applied to the item inner content when pressed (e.g. 0.98 or 0.96).
  ///
  /// Defaults to `null`, meaning content maintains standard `1.0` scale without spring scaling.
  final double? pressedScale;

  /// Corner radius applied to all corners when an item is hovered.
  final double? hoveredRadius;

  /// Custom [BorderRadius] applied when an item is hovered.
  final BorderRadius? hoveredBorderRadius;

  // --- Motion ---

  /// Spring motion used for normal and selection transitions.
  final M3EMotion motion;

  /// Spring motion used for pressed state transitions.
  final M3EMotion pressedMotion;

  // --- Drag / Reorder Styling ---

  /// Corner radius applied to all corners when an item is being dragged.
  final double? dragRadius;

  /// Custom [BorderRadius] applied when an item is being dragged.
  final BorderRadius? dragBorderRadius;

  /// Elevation applied to the dragged item proxy.
  final double dragElevation;

  /// Scale multiplier applied to the dragged item proxy.
  final double dragScale;

  /// Custom background color for the dragged item proxy.
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

  /// Creates a Material 3 Expressive segmented list decoration.
  const M3ESegmentedListDecoration({
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 2.0,
    this.color,
    this.padding,
    this.margin,
    this.border,
    this.elevation = 0.0,
    this.splashColor,
    this.highlightColor,
    this.hoverColor,
    this.focusColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = M3EHapticFeedback.none,
    this.disabledColor,
    this.disabledBorder,
    this.focusedColor,
    this.focusedBorder,
    this.focusedRadius,
    this.focusedBorderRadius,
    this.focusedElevation,
    this.selectedColor,
    this.selectedBorder,
    this.selectedRadius,
    this.selectedBorderRadius,
    this.selectedElevation,
    this.showSelectionCheckmark = false,
    this.selectionCheckmarkAlignment = Alignment.centerRight,
    this.pressedRadius,
    this.pressedBorderRadius,
    this.pressedScale,
    this.hoveredRadius,
    this.hoveredBorderRadius,
    this.motion = M3EMotion.expressiveSpatialFast,
    this.pressedMotion = M3EMotion.expressiveSpatialFast,
    this.dragRadius,
    this.dragBorderRadius,
    this.dragElevation = 8.0,
    this.dragScale = 1.0,
    this.dragColor,
    this.dragPlaceholderColor,
    this.dragPlaceholderBorder,
    this.dragPlaceholderRadius,
    this.dragPlaceholderBuilder,
  });

  /// Creates a copy of this decoration with the given fields replaced.
  M3ESegmentedListDecoration copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderSide? border,
    double? elevation,
    Color? splashColor,
    Color? highlightColor,
    Color? hoverColor,
    Color? focusColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool? enableFeedback,
    M3EHapticFeedback? haptic,
    Color? disabledColor,
    BorderSide? disabledBorder,
    Color? focusedColor,
    BorderSide? focusedBorder,
    double? focusedRadius,
    BorderRadius? focusedBorderRadius,
    double? focusedElevation,
    Color? selectedColor,
    BorderSide? selectedBorder,
    double? selectedRadius,
    BorderRadius? selectedBorderRadius,
    double? selectedElevation,
    bool? showSelectionCheckmark,
    Alignment? selectionCheckmarkAlignment,
    double? pressedRadius,
    BorderRadius? pressedBorderRadius,
    double? pressedScale,
    double? hoveredRadius,
    BorderRadius? hoveredBorderRadius,
    M3EMotion? motion,
    M3EMotion? pressedMotion,
    double? dragRadius,
    BorderRadius? dragBorderRadius,
    double? dragElevation,
    double? dragScale,
    Color? dragColor,
    Color? dragPlaceholderColor,
    BorderSide? dragPlaceholderBorder,
    double? dragPlaceholderRadius,
    Widget Function(BuildContext context, int index, Size size)?
    dragPlaceholderBuilder,
  }) {
    return M3ESegmentedListDecoration(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      color: color ?? this.color,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      border: border ?? this.border,
      elevation: elevation ?? this.elevation,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      hoverColor: hoverColor ?? this.hoverColor,
      focusColor: focusColor ?? this.focusColor,
      splashFactory: splashFactory ?? this.splashFactory,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      haptic: haptic ?? this.haptic,
      disabledColor: disabledColor ?? this.disabledColor,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      focusedColor: focusedColor ?? this.focusedColor,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      focusedRadius: focusedRadius ?? this.focusedRadius,
      focusedBorderRadius: focusedBorderRadius ?? this.focusedBorderRadius,
      focusedElevation: focusedElevation ?? this.focusedElevation,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedBorder: selectedBorder ?? this.selectedBorder,
      selectedRadius: selectedRadius ?? this.selectedRadius,
      selectedBorderRadius: selectedBorderRadius ?? this.selectedBorderRadius,
      selectedElevation: selectedElevation ?? this.selectedElevation,
      showSelectionCheckmark:
          showSelectionCheckmark ?? this.showSelectionCheckmark,
      selectionCheckmarkAlignment:
          selectionCheckmarkAlignment ?? this.selectionCheckmarkAlignment,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      pressedBorderRadius: pressedBorderRadius ?? this.pressedBorderRadius,
      pressedScale: pressedScale ?? this.pressedScale,
      hoveredRadius: hoveredRadius ?? this.hoveredRadius,
      hoveredBorderRadius: hoveredBorderRadius ?? this.hoveredBorderRadius,
      motion: motion ?? this.motion,
      pressedMotion: pressedMotion ?? this.pressedMotion,
      dragRadius: dragRadius ?? this.dragRadius,
      dragBorderRadius: dragBorderRadius ?? this.dragBorderRadius,
      dragElevation: dragElevation ?? this.dragElevation,
      dragScale: dragScale ?? this.dragScale,
      dragColor: dragColor ?? this.dragColor,
      dragPlaceholderColor: dragPlaceholderColor ?? this.dragPlaceholderColor,
      dragPlaceholderBorder:
          dragPlaceholderBorder ?? this.dragPlaceholderBorder,
      dragPlaceholderRadius:
          dragPlaceholderRadius ?? this.dragPlaceholderRadius,
      dragPlaceholderBuilder:
          dragPlaceholderBuilder ?? this.dragPlaceholderBuilder,
    );
  }

  /// Linearly interpolates between two [M3ESegmentedListDecoration]s.
  static M3ESegmentedListDecoration? lerp(
    M3ESegmentedListDecoration? a,
    M3ESegmentedListDecoration? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (a == null) return b;
    if (b == null) return a;

    return M3ESegmentedListDecoration(
      outerRadius: lerpDouble(a.outerRadius, b.outerRadius, t) ?? b.outerRadius,
      innerRadius: lerpDouble(a.innerRadius, b.innerRadius, t) ?? b.innerRadius,
      gap: lerpDouble(a.gap, b.gap, t) ?? b.gap,
      color: Color.lerp(a.color, b.color, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
      border: BorderSide.lerp(
        a.border ?? BorderSide.none,
        b.border ?? BorderSide.none,
        t,
      ),
      elevation: lerpDouble(a.elevation, b.elevation, t) ?? b.elevation,
      splashColor: Color.lerp(a.splashColor, b.splashColor, t),
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      focusColor: Color.lerp(a.focusColor, b.focusColor, t),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      enableFeedback: t < 0.5 ? a.enableFeedback : b.enableFeedback,
      haptic: t < 0.5 ? a.haptic : b.haptic,
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      disabledBorder: BorderSide.lerp(
        a.disabledBorder ?? BorderSide.none,
        b.disabledBorder ?? BorderSide.none,
        t,
      ),
      focusedColor: Color.lerp(a.focusedColor, b.focusedColor, t),
      focusedBorder: BorderSide.lerp(
        a.focusedBorder ?? BorderSide.none,
        b.focusedBorder ?? BorderSide.none,
        t,
      ),
      focusedRadius: lerpDouble(a.focusedRadius, b.focusedRadius, t),
      focusedBorderRadius: BorderRadius.lerp(
        a.focusedBorderRadius,
        b.focusedBorderRadius,
        t,
      ),
      focusedElevation: lerpDouble(a.focusedElevation, b.focusedElevation, t),
      selectedColor: Color.lerp(a.selectedColor, b.selectedColor, t),
      selectedBorder: BorderSide.lerp(
        a.selectedBorder ?? BorderSide.none,
        b.selectedBorder ?? BorderSide.none,
        t,
      ),
      selectedRadius: lerpDouble(a.selectedRadius, b.selectedRadius, t),
      selectedBorderRadius: BorderRadius.lerp(
        a.selectedBorderRadius,
        b.selectedBorderRadius,
        t,
      ),
      selectedElevation: lerpDouble(
        a.selectedElevation,
        b.selectedElevation,
        t,
      ),
      showSelectionCheckmark: t < 0.5
          ? a.showSelectionCheckmark
          : b.showSelectionCheckmark,
      selectionCheckmarkAlignment:
          Alignment.lerp(
            a.selectionCheckmarkAlignment,
            b.selectionCheckmarkAlignment,
            t,
          ) ??
          b.selectionCheckmarkAlignment,
      pressedRadius: lerpDouble(a.pressedRadius, b.pressedRadius, t),
      pressedBorderRadius: BorderRadius.lerp(
        a.pressedBorderRadius,
        b.pressedBorderRadius,
        t,
      ),
      pressedScale: lerpDouble(a.pressedScale, b.pressedScale, t),
      hoveredRadius: lerpDouble(a.hoveredRadius, b.hoveredRadius, t),
      hoveredBorderRadius: BorderRadius.lerp(
        a.hoveredBorderRadius,
        b.hoveredBorderRadius,
        t,
      ),
      motion: t < 0.5 ? a.motion : b.motion,
      pressedMotion: t < 0.5 ? a.pressedMotion : b.pressedMotion,
      dragRadius: lerpDouble(a.dragRadius, b.dragRadius, t),
      dragBorderRadius: BorderRadius.lerp(
        a.dragBorderRadius,
        b.dragBorderRadius,
        t,
      ),
      dragElevation:
          lerpDouble(a.dragElevation, b.dragElevation, t) ?? b.dragElevation,
      dragScale: lerpDouble(a.dragScale, b.dragScale, t) ?? b.dragScale,
      dragColor: Color.lerp(a.dragColor, b.dragColor, t),
      dragPlaceholderColor: Color.lerp(
        a.dragPlaceholderColor,
        b.dragPlaceholderColor,
        t,
      ),
      dragPlaceholderBorder: BorderSide.lerp(
        a.dragPlaceholderBorder ?? BorderSide.none,
        b.dragPlaceholderBorder ?? BorderSide.none,
        t,
      ),
      dragPlaceholderRadius: lerpDouble(
        a.dragPlaceholderRadius,
        b.dragPlaceholderRadius,
        t,
      ),
      dragPlaceholderBuilder: t < 0.5
          ? a.dragPlaceholderBuilder
          : b.dragPlaceholderBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is M3ESegmentedListDecoration &&
        other.outerRadius == outerRadius &&
        other.innerRadius == innerRadius &&
        other.gap == gap &&
        other.color == color &&
        other.padding == padding &&
        other.margin == margin &&
        other.border == border &&
        other.elevation == elevation &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor &&
        other.hoverColor == hoverColor &&
        other.focusColor == focusColor &&
        other.splashFactory == splashFactory &&
        other.enableFeedback == enableFeedback &&
        other.haptic == haptic &&
        other.disabledColor == disabledColor &&
        other.disabledBorder == disabledBorder &&
        other.focusedColor == focusedColor &&
        other.focusedBorder == focusedBorder &&
        other.focusedRadius == focusedRadius &&
        other.focusedBorderRadius == focusedBorderRadius &&
        other.focusedElevation == focusedElevation &&
        other.selectedColor == selectedColor &&
        other.selectedBorder == selectedBorder &&
        other.selectedRadius == selectedRadius &&
        other.selectedBorderRadius == selectedBorderRadius &&
        other.selectedElevation == selectedElevation &&
        other.showSelectionCheckmark == showSelectionCheckmark &&
        other.selectionCheckmarkAlignment == selectionCheckmarkAlignment &&
        other.pressedRadius == pressedRadius &&
        other.pressedBorderRadius == pressedBorderRadius &&
        other.pressedScale == pressedScale &&
        other.hoveredRadius == hoveredRadius &&
        other.hoveredBorderRadius == hoveredBorderRadius &&
        other.motion == motion &&
        other.pressedMotion == pressedMotion &&
        other.dragRadius == dragRadius &&
        other.dragBorderRadius == dragBorderRadius &&
        other.dragElevation == dragElevation &&
        other.dragScale == dragScale &&
        other.dragColor == dragColor &&
        other.dragPlaceholderColor == dragPlaceholderColor &&
        other.dragPlaceholderBorder == dragPlaceholderBorder &&
        other.dragPlaceholderRadius == dragPlaceholderRadius &&
        other.dragPlaceholderBuilder == dragPlaceholderBuilder;
  }

  @override
  int get hashCode => Object.hashAll([
    outerRadius,
    innerRadius,
    gap,
    color,
    padding,
    margin,
    border,
    elevation,
    splashColor,
    highlightColor,
    hoverColor,
    focusColor,
    splashFactory,
    enableFeedback,
    haptic,
    disabledColor,
    disabledBorder,
    focusedColor,
    focusedBorder,
    focusedRadius,
    focusedBorderRadius,
    focusedElevation,
    selectedColor,
    selectedBorder,
    selectedRadius,
    selectedBorderRadius,
    selectedElevation,
    showSelectionCheckmark,
    selectionCheckmarkAlignment,
    pressedRadius,
    pressedBorderRadius,
    pressedScale,
    hoveredRadius,
    hoveredBorderRadius,
    motion,
    pressedMotion,
    dragRadius,
    dragBorderRadius,
    dragElevation,
    dragScale,
    dragColor,
    dragPlaceholderColor,
    dragPlaceholderBorder,
    dragPlaceholderRadius,
    dragPlaceholderBuilder,
  ]);
}
