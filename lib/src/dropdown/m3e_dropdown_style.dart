import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/m3e_common.dart';

/// Controls the direction in which the dropdown overlay expands.
///
/// * [ExpandDirection.auto]: Automatically determines the direction based on
///   available space. Falls back to showing above if there's not enough space below.
/// * [ExpandDirection.down]: Forces the dropdown to expand downward.
/// * [ExpandDirection.up]: Forces the dropdown to expand upward.
enum ExpandDirection {
  /// Automatically determine the best direction based on available space.
  auto,

  /// Force the dropdown to expand downward.
  down,

  /// Force the dropdown to expand upward.
  up,
}

/// Visual styling for the M3E dropdown field (the tap target).
@immutable
class M3EDropdownFieldStyle with Diagnosticable {
  /// Hint text shown when nothing is selected.
  final String? hintText;

  /// Style for the hint text.
  final TextStyle? hintStyle;

  /// Style for the selected value text (single-select mode).
  final TextStyle? selectedTextStyle;

  /// Style for the error message shown below the field.
  final TextStyle? errorStyle;

  /// An optional leading icon/widget.
  final Widget? prefixIcon;

  /// An optional trailing icon/widget. Overrides the default animated arrow
  /// when provided.
  final Widget? suffixIcon;

  /// A custom widget to clear all selections.
  ///
  /// Only used when [showClearIcon] is true.
  final Widget? clearIcon;

  /// Background color of the field.
  final Color? backgroundColor;

  /// Text color of the field.
  final Color? foregroundColor;

  /// Inner padding of the field content.
  final EdgeInsetsGeometry padding;

  /// Outer margin around the field.
  final EdgeInsetsGeometry margin;

  /// The border drawn around the field.
  final BorderSide? border;

  /// Border when the dropdown is focused / open.
  final BorderSide? focusedBorder;

  /// Border when the dropdown has a validation error.
  final BorderSide? errorBorder;

  /// Whether to show the default animated arrow indicator.
  ///
  /// Set to `false` to hide the built-in chevron. If [suffixIcon]
  /// is non-null the default arrow is _already_ replaced.
  ///
  /// Defaults to `true`.
  final bool showArrow;

  /// A custom widget shown while async data is loading.
  ///
  /// Defaults to a small [CircularProgressIndicator] when null.
  final Widget? loadingWidget;

  /// Border radius of the field.
  ///
  /// When null the widget's `outerRadius` inside [M3EDropdownItemStyle] is used as a circular radius.
  final BorderRadius? borderRadius;

  /// Whether to show a clear-all icon when items are selected.
  ///
  /// The icon replaces the suffix/arrow when visible and clears all
  /// selected items on tap. Defaults to `false`.
  final bool showClearIcon;

  /// Whether to animate the default suffix icon (arrow) rotation.
  ///
  /// Defaults to `true`.
  final bool animateSuffixIcon;

  /// Border radius of the field when the dropdown is expanded.
  ///
  /// When non-null the field animates from [borderRadius] to this value
  /// with a snappy spring when the dropdown opens, and back when it closes.
  final double? selectedBorderRadius;

  /// Border radius of the field when hovered.
  final double? hoverRadius;

  /// Border radius of the field when pressed.
  final double? pressedRadius;

  /// Splash factory for tap feedback on the field.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Splash color for the ripple effect.
  final Color? splashColor;

  /// Highlight color when the field is pressed.
  final Color? highlightColor;

  /// Mouse cursor when hovering over the field.
  final MouseCursor? mouseCursor;

  /// Creates a [M3EDropdownFieldStyle].
  const M3EDropdownFieldStyle({
    this.hintText,
    this.hintStyle,
    this.selectedTextStyle,
    this.errorStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.clearIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.margin = EdgeInsets.zero,
    this.showArrow = true,
    this.loadingWidget,
    this.borderRadius,
    this.selectedBorderRadius,
    this.hoverRadius,
    this.pressedRadius,
    this.splashFactory,
    this.splashColor,
    this.highlightColor,
    this.mouseCursor,
    this.showClearIcon = false,
    this.animateSuffixIcon = true,
  });

  /// Creates a copy of this style with the given fields replaced.
  M3EDropdownFieldStyle copyWith({
    String? hintText,
    TextStyle? hintStyle,
    TextStyle? selectedTextStyle,
    TextStyle? errorStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? clearIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderSide? border,
    BorderSide? focusedBorder,
    BorderSide? errorBorder,
    bool? showArrow,
    Widget? loadingWidget,
    BorderRadius? borderRadius,
    bool? showClearIcon,
    bool? animateSuffixIcon,
    double? selectedBorderRadius,
    double? hoverRadius,
    double? pressedRadius,
    InteractiveInkFeatureFactory? splashFactory,
    Color? splashColor,
    Color? highlightColor,
    MouseCursor? mouseCursor,
  }) {
    return M3EDropdownFieldStyle(
      hintText: hintText ?? this.hintText,
      hintStyle: hintStyle ?? this.hintStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      clearIcon: clearIcon ?? this.clearIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      showArrow: showArrow ?? this.showArrow,
      loadingWidget: loadingWidget ?? this.loadingWidget,
      borderRadius: borderRadius ?? this.borderRadius,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      animateSuffixIcon: animateSuffixIcon ?? this.animateSuffixIcon,
      selectedBorderRadius: selectedBorderRadius ?? this.selectedBorderRadius,
      hoverRadius: hoverRadius ?? this.hoverRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      splashFactory: splashFactory ?? this.splashFactory,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  /// Linearly interpolate between two field styles.
  static M3EDropdownFieldStyle lerp(
    M3EDropdownFieldStyle? a,
    M3EDropdownFieldStyle? b,
    double t,
  ) {
    if (a == null && b == null) return const M3EDropdownFieldStyle();
    return M3EDropdownFieldStyle(
      hintText: t < 0.5 ? a?.hintText : b?.hintText,
      hintStyle: TextStyle.lerp(a?.hintStyle, b?.hintStyle, t),
      selectedTextStyle: TextStyle.lerp(
        a?.selectedTextStyle,
        b?.selectedTextStyle,
        t,
      ),
      errorStyle: TextStyle.lerp(a?.errorStyle, b?.errorStyle, t),
      prefixIcon: t < 0.5 ? a?.prefixIcon : b?.prefixIcon,
      suffixIcon: t < 0.5 ? a?.suffixIcon : b?.suffixIcon,
      clearIcon: t < 0.5 ? a?.clearIcon : b?.clearIcon,
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t)!,
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t)!,
      border: BorderSide.lerp(
        a?.border ?? BorderSide.none,
        b?.border ?? BorderSide.none,
        t,
      ),
      focusedBorder: BorderSide.lerp(
        a?.focusedBorder ?? BorderSide.none,
        b?.focusedBorder ?? BorderSide.none,
        t,
      ),
      errorBorder: BorderSide.lerp(
        a?.errorBorder ?? BorderSide.none,
        b?.errorBorder ?? BorderSide.none,
        t,
      ),
      showArrow: t < 0.5 ? (a?.showArrow ?? true) : (b?.showArrow ?? true),
      loadingWidget: t < 0.5 ? a?.loadingWidget : b?.loadingWidget,
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      showClearIcon: t < 0.5
          ? (a?.showClearIcon ?? false)
          : (b?.showClearIcon ?? false),
      animateSuffixIcon: t < 0.5
          ? (a?.animateSuffixIcon ?? true)
          : (b?.animateSuffixIcon ?? true),
      selectedBorderRadius: lerpDouble(
        a?.selectedBorderRadius,
        b?.selectedBorderRadius,
        t,
      ),
      hoverRadius: lerpDouble(a?.hoverRadius, b?.hoverRadius, t),
      pressedRadius: lerpDouble(a?.pressedRadius, b?.pressedRadius, t),
      splashFactory: t < 0.5 ? a?.splashFactory : b?.splashFactory,
      splashColor: Color.lerp(a?.splashColor, b?.splashColor, t),
      highlightColor: Color.lerp(a?.highlightColor, b?.highlightColor, t),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EDropdownFieldStyle &&
          hintText == other.hintText &&
          hintStyle == other.hintStyle &&
          selectedTextStyle == other.selectedTextStyle &&
          errorStyle == other.errorStyle &&
          prefixIcon == other.prefixIcon &&
          suffixIcon == other.suffixIcon &&
          clearIcon == other.clearIcon &&
          backgroundColor == other.backgroundColor &&
          foregroundColor == other.foregroundColor &&
          padding == other.padding &&
          margin == other.margin &&
          border == other.border &&
          focusedBorder == other.focusedBorder &&
          errorBorder == other.errorBorder &&
          showArrow == other.showArrow &&
          loadingWidget == other.loadingWidget &&
          borderRadius == other.borderRadius &&
          showClearIcon == other.showClearIcon &&
          animateSuffixIcon == other.animateSuffixIcon &&
          selectedBorderRadius == other.selectedBorderRadius &&
          hoverRadius == other.hoverRadius &&
          pressedRadius == other.pressedRadius &&
          splashFactory == other.splashFactory &&
          splashColor == other.splashColor &&
          highlightColor == other.highlightColor &&
          mouseCursor == other.mouseCursor;

  @override
  int get hashCode => Object.hashAll([
    hintText,
    hintStyle,
    selectedTextStyle,
    errorStyle,
    prefixIcon,
    suffixIcon,
    clearIcon,
    backgroundColor,
    foregroundColor,
    padding,
    margin,
    border,
    focusedBorder,
    errorBorder,
    showArrow,
    loadingWidget,
    borderRadius,
    showClearIcon,
    animateSuffixIcon,
    selectedBorderRadius,
    hoverRadius,
    pressedRadius,
    splashFactory,
    splashColor,
    highlightColor,
    mouseCursor,
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('hintText', hintText));
    properties.add(DiagnosticsProperty<TextStyle>('hintStyle', hintStyle));
    properties.add(
      DiagnosticsProperty<TextStyle>('selectedTextStyle', selectedTextStyle),
    );
    properties.add(DiagnosticsProperty<TextStyle>('errorStyle', errorStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('foregroundColor', foregroundColor));
    properties.add(
      DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius),
    );
    properties.add(
      DoubleProperty('selectedBorderRadius', selectedBorderRadius),
    );
  }
}

/// Visual styling for the dropdown panel (the list of items).
@immutable
class M3EDropdownStyle with Diagnosticable {
  /// Background color of the dropdown panel.
  final Color? backgroundColor;

  /// Elevation of the dropdown panel.
  final double elevation;

  /// Maximum height of the dropdown panel.
  final double maxHeight;

  /// Gap between the field and the dropdown panel.
  final double marginTop;

  /// Text shown when search yields no matches.
  final String noItemsFoundText;

  /// An optional header widget shown above the items.
  final Widget? header;

  /// An optional footer widget shown below the items.
  final Widget? footer;

  /// Padding applied around the item list inside the dropdown panel.
  ///
  /// Defaults to `EdgeInsets.all(8)`.
  final EdgeInsetsGeometry contentPadding;

  /// The direction in which the dropdown expands.
  ///
  /// Defaults to [ExpandDirection.auto], which automatically determines
  /// the direction based on available screen space.
  final ExpandDirection expandDirection;

  /// Radius applied to the dropdown panel container.
  ///
  /// When set, overrides the widget-level [M3EDropdownMenu.containerRadius].
  final double? containerRadius;

  /// Creates a [M3EDropdownStyle].
  const M3EDropdownStyle({
    this.backgroundColor,
    this.elevation = 3,
    this.maxHeight = 350,
    this.marginTop = 4,
    this.noItemsFoundText = 'No items found',
    this.header,
    this.footer,
    this.contentPadding = const EdgeInsets.all(8),
    this.expandDirection = ExpandDirection.auto,
    this.containerRadius,
  });

  /// Creates a copy of this style with the given fields replaced.
  M3EDropdownStyle copyWith({
    Color? backgroundColor,
    double? elevation,
    double? maxHeight,
    double? marginTop,
    String? noItemsFoundText,
    Widget? header,
    Widget? footer,
    EdgeInsetsGeometry? contentPadding,
    ExpandDirection? expandDirection,
    double? containerRadius,
  }) {
    return M3EDropdownStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      maxHeight: maxHeight ?? this.maxHeight,
      marginTop: marginTop ?? this.marginTop,
      noItemsFoundText: noItemsFoundText ?? this.noItemsFoundText,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      contentPadding: contentPadding ?? this.contentPadding,
      expandDirection: expandDirection ?? this.expandDirection,
      containerRadius: containerRadius ?? this.containerRadius,
    );
  }

  /// Linearly interpolate between two dropdown styles.
  static M3EDropdownStyle lerp(
    M3EDropdownStyle? a,
    M3EDropdownStyle? b,
    double t,
  ) {
    if (a == null && b == null) return const M3EDropdownStyle();
    return M3EDropdownStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t) ?? 3,
      maxHeight: lerpDouble(a?.maxHeight, b?.maxHeight, t) ?? 350,
      marginTop: lerpDouble(a?.marginTop, b?.marginTop, t) ?? 4,
      noItemsFoundText: t < 0.5
          ? (a?.noItemsFoundText ?? 'No items found')
          : (b?.noItemsFoundText ?? 'No items found'),
      header: t < 0.5 ? a?.header : b?.header,
      footer: t < 0.5 ? a?.footer : b?.footer,
      contentPadding:
          EdgeInsetsGeometry.lerp(a?.contentPadding, b?.contentPadding, t) ??
          const EdgeInsets.all(8),
      expandDirection: t < 0.5
          ? (a?.expandDirection ?? ExpandDirection.auto)
          : (b?.expandDirection ?? ExpandDirection.auto),
      containerRadius: lerpDouble(a?.containerRadius, b?.containerRadius, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EDropdownStyle &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          maxHeight == other.maxHeight &&
          marginTop == other.marginTop &&
          noItemsFoundText == other.noItemsFoundText &&
          header == other.header &&
          footer == other.footer &&
          contentPadding == other.contentPadding &&
          expandDirection == other.expandDirection &&
          containerRadius == other.containerRadius;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    elevation,
    maxHeight,
    marginTop,
    noItemsFoundText,
    header,
    footer,
    contentPadding,
    expandDirection,
    containerRadius,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(DoubleProperty('maxHeight', maxHeight));
    properties.add(DoubleProperty('marginTop', marginTop));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>('contentPadding', contentPadding),
    );
    properties.add(
      EnumProperty<ExpandDirection>('expandDirection', expandDirection),
    );
    properties.add(DoubleProperty('containerRadius', containerRadius));
  }
}

/// Visual styling for chips displayed in the field.
@immutable
class M3EChipStyle with Diagnosticable {
  /// Chip background color.
  final Color? backgroundColor;

  /// Chip label text style.
  final TextStyle? labelStyle;

  /// Chip delete icon widget.
  final Widget? deleteIcon;

  /// Padding inside each chip.
  final EdgeInsetsGeometry padding;

  /// Border drawn around each chip.
  final BorderSide? border;

  /// Border radius of the chip.
  final BorderRadius borderRadius;

  /// Spacing between chips horizontally.
  final double spacing;

  /// Spacing between chip rows vertically.
  final double runSpacing;

  /// Whether to wrap chips or scroll them horizontally.
  final bool wrap;

  /// Maximum visible chips before showing "+N more".
  final int? maxDisplayCount;

  /// Spring motion for the chip entry (scale-in) animation.
  ///
  /// Defaults to [M3EMotion.expressiveSpatialDefault].
  final M3EMotion openMotion;

  /// Spring motion for the chip exit (scale-out / pop) animation.
  ///
  /// Defaults to [M3EMotion.expressiveSpatialDefault].
  final M3EMotion closeMotion;

  /// Mouse cursor when hovering over the chip.
  final MouseCursor? mouseCursor;

  /// Creates a [M3EChipStyle].
  const M3EChipStyle({
    this.backgroundColor,
    this.labelStyle,
    this.deleteIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.spacing = 6,
    this.runSpacing = 6,
    this.wrap = true,
    this.maxDisplayCount,
    this.openMotion = M3EMotion.expressiveSpatialDefault,
    this.closeMotion = M3EMotion.expressiveSpatialDefault,
    this.mouseCursor,
  });

  /// Creates a copy of this style with the given fields replaced.
  M3EChipStyle copyWith({
    Color? backgroundColor,
    TextStyle? labelStyle,
    Widget? deleteIcon,
    EdgeInsetsGeometry? padding,
    BorderSide? border,
    BorderRadius? borderRadius,
    double? spacing,
    double? runSpacing,
    bool? wrap,
    int? maxDisplayCount,
    M3EMotion? openMotion,
    M3EMotion? closeMotion,
    MouseCursor? mouseCursor,
  }) {
    return M3EChipStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      deleteIcon: deleteIcon ?? this.deleteIcon,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      wrap: wrap ?? this.wrap,
      maxDisplayCount: maxDisplayCount ?? this.maxDisplayCount,
      openMotion: openMotion ?? this.openMotion,
      closeMotion: closeMotion ?? this.closeMotion,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  /// Linearly interpolate between two chip styles.
  static M3EChipStyle lerp(M3EChipStyle? a, M3EChipStyle? b, double t) {
    if (a == null && b == null) return const M3EChipStyle();
    return M3EChipStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      labelStyle: TextStyle.lerp(a?.labelStyle, b?.labelStyle, t),
      deleteIcon: t < 0.5 ? a?.deleteIcon : b?.deleteIcon,
      padding:
          EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t) ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      border: BorderSide.lerp(
        a?.border ?? BorderSide.none,
        b?.border ?? BorderSide.none,
        t,
      ),
      borderRadius:
          BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t) ??
          const BorderRadius.all(Radius.circular(20)),
      spacing: lerpDouble(a?.spacing, b?.spacing, t) ?? 6,
      runSpacing: lerpDouble(a?.runSpacing, b?.runSpacing, t) ?? 6,
      wrap: t < 0.5 ? (a?.wrap ?? true) : (b?.wrap ?? true),
      maxDisplayCount: t < 0.5 ? a?.maxDisplayCount : b?.maxDisplayCount,
      openMotion: t < 0.5
          ? (a?.openMotion ?? M3EMotion.expressiveSpatialDefault)
          : (b?.openMotion ?? M3EMotion.expressiveSpatialDefault),
      closeMotion: t < 0.5
          ? (a?.closeMotion ?? M3EMotion.expressiveSpatialDefault)
          : (b?.closeMotion ?? M3EMotion.expressiveSpatialDefault),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EChipStyle &&
          backgroundColor == other.backgroundColor &&
          labelStyle == other.labelStyle &&
          deleteIcon == other.deleteIcon &&
          padding == other.padding &&
          border == other.border &&
          borderRadius == other.borderRadius &&
          spacing == other.spacing &&
          runSpacing == other.runSpacing &&
          wrap == other.wrap &&
          maxDisplayCount == other.maxDisplayCount &&
          openMotion == other.openMotion &&
          closeMotion == other.closeMotion &&
          mouseCursor == other.mouseCursor;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    labelStyle,
    deleteIcon,
    padding,
    border,
    borderRadius,
    spacing,
    runSpacing,
    wrap,
    maxDisplayCount,
    openMotion,
    closeMotion,
    mouseCursor,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<TextStyle>('labelStyle', labelStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(
      DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius),
    );
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(IntProperty('maxDisplayCount', maxDisplayCount));
  }
}

/// Visual styling for the search field inside the dropdown.
@immutable
class M3ESearchStyle with Diagnosticable {
  /// Hint text shown in the search field.
  final String hintText;

  /// Search field hint style.
  final TextStyle? hintStyle;

  /// Search field text style.
  final TextStyle? textStyle;

  /// Fill color for the search field.
  final Color? fillColor;

  /// Whether the search field is filled.
  final bool filled;

  /// Whether to auto-focus the search field when the dropdown opens.
  final bool autofocus;

  /// Whether to show a clear‐search icon.
  final bool showClearIcon;

  /// Custom clear icon widget for the search field.
  final Widget? clearIcon;

  /// The debounce duration in milliseconds for search input.
  ///
  /// When set to a value greater than 0, search callbacks will
  /// only fire after the user stops typing for this duration.
  /// Defaults to 0 (no debounce).
  final int searchDebounceMs;

  /// Border radius of the search field.
  ///
  /// When null, falls back to the item style's outer radius.
  final BorderRadius? borderRadius;

  /// Content padding inside the search text field.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`.
  final EdgeInsetsGeometry contentPadding;

  /// Outer margin (padding around the search field container).
  ///
  /// Defaults to `EdgeInsets.fromLTRB(12, 8, 12, 4)`.
  final EdgeInsetsGeometry margin;

  /// Mouse cursor when hovering over the search field.
  final MouseCursor? mouseCursor;

  /// Creates a [M3ESearchStyle].
  const M3ESearchStyle({
    this.hintText = 'Search…',
    this.hintStyle,
    this.textStyle,
    this.fillColor,
    this.filled = false,
    this.autofocus = false,
    this.showClearIcon = true,
    this.clearIcon,
    this.searchDebounceMs = 0,
    this.borderRadius,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.margin = const EdgeInsets.fromLTRB(12, 8, 12, 4),
    this.mouseCursor,
  });

  /// Creates a copy of this style with the given fields replaced.
  M3ESearchStyle copyWith({
    String? hintText,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    Color? fillColor,
    bool? filled,
    bool? autofocus,
    bool? showClearIcon,
    Widget? clearIcon,
    int? searchDebounceMs,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? margin,
    MouseCursor? mouseCursor,
  }) {
    return M3ESearchStyle(
      hintText: hintText ?? this.hintText,
      hintStyle: hintStyle ?? this.hintStyle,
      textStyle: textStyle ?? this.textStyle,
      fillColor: fillColor ?? this.fillColor,
      filled: filled ?? this.filled,
      autofocus: autofocus ?? this.autofocus,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      clearIcon: clearIcon ?? this.clearIcon,
      searchDebounceMs: searchDebounceMs ?? this.searchDebounceMs,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      margin: margin ?? this.margin,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  /// Linearly interpolate between two search styles.
  static M3ESearchStyle lerp(M3ESearchStyle? a, M3ESearchStyle? b, double t) {
    if (a == null && b == null) return const M3ESearchStyle();
    return M3ESearchStyle(
      hintText: t < 0.5
          ? (a?.hintText ?? 'Search…')
          : (b?.hintText ?? 'Search…'),
      hintStyle: TextStyle.lerp(a?.hintStyle, b?.hintStyle, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      fillColor: Color.lerp(a?.fillColor, b?.fillColor, t),
      filled: t < 0.5 ? (a?.filled ?? false) : (b?.filled ?? false),
      autofocus: t < 0.5 ? (a?.autofocus ?? false) : (b?.autofocus ?? false),
      showClearIcon: t < 0.5
          ? (a?.showClearIcon ?? true)
          : (b?.showClearIcon ?? true),
      clearIcon: t < 0.5 ? a?.clearIcon : b?.clearIcon,
      searchDebounceMs:
          lerpDouble(
            a?.searchDebounceMs.toDouble(),
            b?.searchDebounceMs.toDouble(),
            t,
          )?.round() ??
          0,
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(a?.contentPadding, b?.contentPadding, t) ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin:
          EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t) ??
          const EdgeInsets.fromLTRB(12, 8, 12, 4),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESearchStyle &&
          hintText == other.hintText &&
          hintStyle == other.hintStyle &&
          textStyle == other.textStyle &&
          fillColor == other.fillColor &&
          filled == other.filled &&
          autofocus == other.autofocus &&
          showClearIcon == other.showClearIcon &&
          clearIcon == other.clearIcon &&
          searchDebounceMs == other.searchDebounceMs &&
          borderRadius == other.borderRadius &&
          contentPadding == other.contentPadding &&
          margin == other.margin &&
          mouseCursor == other.mouseCursor;

  @override
  int get hashCode => Object.hash(
    hintText,
    hintStyle,
    textStyle,
    fillColor,
    filled,
    autofocus,
    showClearIcon,
    clearIcon,
    searchDebounceMs,
    borderRadius,
    contentPadding,
    margin,
    mouseCursor,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('hintText', hintText));
    properties.add(ColorProperty('fillColor', fillColor));
    properties.add(
      DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius),
    );
  }
}

/// Visual styling for individual items inside the dropdown list.
@immutable
class M3EDropdownItemStyle with Diagnosticable {
  /// Item background color.
  final Color? backgroundColor;

  /// Background color for selected items.
  final Color? selectedBackgroundColor;

  /// Background color for disabled items.
  final Color? disabledBackgroundColor;

  /// Text color.
  final Color? textColor;

  /// Text color for selected items.
  final Color? selectedTextColor;

  /// Text color for disabled items.
  final Color? disabledTextColor;

  /// Text style for item labels.
  final TextStyle? textStyle;

  /// Text style for selected item labels.
  final TextStyle? selectedTextStyle;

  /// Icon shown next to selected items.
  final Widget? selectedIcon;

  /// Outer radius applied to the first and last dropdown item cards
  /// (the "cap" corners), mirroring the M3E card list treatment.
  ///
  /// Defaults to `12.0`.
  final double? outerRadius;

  /// Inner radius applied to middle dropdown item cards.
  ///
  /// Defaults to `6.0`.
  final double innerRadius;

  /// Gap between items.
  ///
  /// When set, specifies the gap between items list.
  final double? itemGap;

  /// Inner padding applied to each dropdown item.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16, vertical: 12)`.
  final EdgeInsetsGeometry itemPadding;

  /// Border radius applied to a selected item.
  ///
  /// When null, falls back to [outerRadius] (or its default of `12.0`).
  final double? selectedBorderRadius;

  /// Radius applied to the item when hovered.
  ///
  /// Defaults to `8.0`.
  final double hoverRadius;

  /// Radius applied to the item when pressed.
  ///
  /// Defaults to `4.0`.
  final double pressedRadius;

  /// Splash factory for tap feedback on individual items.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Splash color for the ripple effect.
  final Color? splashColor;

  /// Highlight color when the item is pressed.
  final Color? highlightColor;

  /// Mouse cursor when hovering over an item.
  final MouseCursor? mouseCursor;

  /// Creates a [M3EDropdownItemStyle].
  const M3EDropdownItemStyle({
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.disabledBackgroundColor,
    this.textColor,
    this.selectedTextColor,
    this.disabledTextColor,
    this.textStyle,
    this.selectedTextStyle,
    this.selectedIcon,
    this.outerRadius,
    this.innerRadius = 6.0,
    this.itemGap,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.selectedBorderRadius,
    this.hoverRadius = 8.0,
    this.pressedRadius = 4.0,
    this.splashFactory,
    this.splashColor,
    this.highlightColor,
    this.mouseCursor,
  });

  /// Creates a copy of this style with the given fields replaced.
  M3EDropdownItemStyle copyWith({
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? textColor,
    Color? selectedTextColor,
    Color? disabledTextColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    Widget? selectedIcon,
    double? outerRadius,
    double? innerRadius,
    double? itemGap,
    EdgeInsetsGeometry? itemPadding,
    double? selectedBorderRadius,
    double? hoverRadius,
    double? pressedRadius,
    InteractiveInkFeatureFactory? splashFactory,
    Color? splashColor,
    Color? highlightColor,
    MouseCursor? mouseCursor,
  }) {
    return M3EDropdownItemStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      textColor: textColor ?? this.textColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      itemGap: itemGap ?? this.itemGap,
      itemPadding: itemPadding ?? this.itemPadding,
      selectedBorderRadius: selectedBorderRadius ?? this.selectedBorderRadius,
      hoverRadius: hoverRadius ?? this.hoverRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      splashFactory: splashFactory ?? this.splashFactory,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  /// Linearly interpolate between two dropdown item styles.
  static M3EDropdownItemStyle lerp(
    M3EDropdownItemStyle? a,
    M3EDropdownItemStyle? b,
    double t,
  ) {
    if (a == null && b == null) return const M3EDropdownItemStyle();
    return M3EDropdownItemStyle(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      selectedBackgroundColor: Color.lerp(
        a?.selectedBackgroundColor,
        b?.selectedBackgroundColor,
        t,
      ),
      disabledBackgroundColor: Color.lerp(
        a?.disabledBackgroundColor,
        b?.disabledBackgroundColor,
        t,
      ),
      textColor: Color.lerp(a?.textColor, b?.textColor, t),
      selectedTextColor: Color.lerp(
        a?.selectedTextColor,
        b?.selectedTextColor,
        t,
      ),
      disabledTextColor: Color.lerp(
        a?.disabledTextColor,
        b?.disabledTextColor,
        t,
      ),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      selectedTextStyle: TextStyle.lerp(
        a?.selectedTextStyle,
        b?.selectedTextStyle,
        t,
      ),
      selectedIcon: t < 0.5 ? a?.selectedIcon : b?.selectedIcon,
      outerRadius: lerpDouble(a?.outerRadius, b?.outerRadius, t),
      innerRadius: lerpDouble(a?.innerRadius, b?.innerRadius, t) ?? 6.0,
      itemGap: lerpDouble(a?.itemGap, b?.itemGap, t),
      itemPadding:
          EdgeInsetsGeometry.lerp(a?.itemPadding, b?.itemPadding, t) ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      selectedBorderRadius: lerpDouble(
        a?.selectedBorderRadius,
        b?.selectedBorderRadius,
        t,
      ),
      hoverRadius: lerpDouble(a?.hoverRadius, b?.hoverRadius, t) ?? 8.0,
      pressedRadius: lerpDouble(a?.pressedRadius, b?.pressedRadius, t) ?? 4.0,
      splashFactory: t < 0.5 ? a?.splashFactory : b?.splashFactory,
      splashColor: Color.lerp(a?.splashColor, b?.splashColor, t),
      highlightColor: Color.lerp(a?.highlightColor, b?.highlightColor, t),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EDropdownItemStyle &&
          backgroundColor == other.backgroundColor &&
          selectedBackgroundColor == other.selectedBackgroundColor &&
          disabledBackgroundColor == other.disabledBackgroundColor &&
          textColor == other.textColor &&
          selectedTextColor == other.selectedTextColor &&
          disabledTextColor == other.disabledTextColor &&
          textStyle == other.textStyle &&
          selectedTextStyle == other.selectedTextStyle &&
          selectedIcon == other.selectedIcon &&
          outerRadius == other.outerRadius &&
          innerRadius == other.innerRadius &&
          itemGap == other.itemGap &&
          itemPadding == other.itemPadding &&
          selectedBorderRadius == other.selectedBorderRadius &&
          hoverRadius == other.hoverRadius &&
          pressedRadius == other.pressedRadius &&
          splashFactory == other.splashFactory &&
          splashColor == other.splashColor &&
          highlightColor == other.highlightColor &&
          mouseCursor == other.mouseCursor;

  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    selectedBackgroundColor,
    disabledBackgroundColor,
    textColor,
    selectedTextColor,
    disabledTextColor,
    textStyle,
    selectedTextStyle,
    selectedIcon,
    outerRadius,
    innerRadius,
    itemGap,
    itemPadding,
    selectedBorderRadius,
    hoverRadius,
    pressedRadius,
    splashFactory,
    splashColor,
    highlightColor,
    mouseCursor,
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(
      ColorProperty('selectedBackgroundColor', selectedBackgroundColor),
    );
    properties.add(DoubleProperty('outerRadius', outerRadius));
    properties.add(DoubleProperty('innerRadius', innerRadius));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>('itemPadding', itemPadding),
    );
  }
}
