import 'package:flutter/material.dart';

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
class M3EDropdownFieldDecoration {
  /// Hint text shown when nothing is selected.
  final String? hintText;

  /// Style for the hint text.
  final TextStyle? hintStyle;

  /// Style for the selected value text (single-select mode).
  final TextStyle? selectedTextStyle;

  /// An optional leading icon/widget.
  final Widget? prefixIcon;

  /// An optional trailing icon/widget. Overrides the default animated arrow
  /// when provided.
  final Widget? suffixIcon;

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
  /// When null the widget's `outerRadius` inside [M3EDropdownItemDecoration] is used as a circular radius.
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
  final BorderRadius? expandedBorderRadius;

  /// Creates a [M3EDropdownFieldDecoration].
  const M3EDropdownFieldDecoration({
    this.hintText,
    this.hintStyle,
    this.selectedTextStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.focusedBorder,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.margin = EdgeInsets.zero,
    this.showArrow = true,
    this.loadingWidget,
    this.borderRadius,
    this.expandedBorderRadius,
    this.showClearIcon = false,
    this.animateSuffixIcon = true,
  });
}

/// Visual styling for the dropdown panel (the list of items).
class M3EDropdownDecoration {
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

  /// Creates a [M3EDropdownDecoration].
  const M3EDropdownDecoration({
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
}

/// Visual styling for chips displayed in the field.
class M3EChipDecoration {
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

  /// Spring stiffness for the chip entry (scale-in) animation.
  ///
  /// Defaults to `380`.
  final double openStiffness;

  /// Spring damping for the chip entry (scale-in) animation.
  ///
  /// Defaults to `0.8`.
  final double openDamping;

  /// Spring stiffness for the chip exit (scale-out / pop) animation.
  ///
  /// Defaults to `380`.
  final double closeStiffness;

  /// Spring damping for the chip exit (scale-out / pop) animation.
  ///
  /// Defaults to `0.8`.
  final double closeDamping;

  /// Creates a [M3EChipDecoration].
  const M3EChipDecoration({
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
    this.openStiffness = 380,
    this.openDamping = 0.8,
    this.closeStiffness = 380,
    this.closeDamping = 0.8,
  });
}

/// Visual styling for the search field inside the dropdown.
class M3ESearchDecoration {
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
  /// When null, falls back to the item decoration's outer radius.
  final BorderRadius? borderRadius;

  /// Content padding inside the search text field.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`.
  final EdgeInsetsGeometry contentPadding;

  /// Outer margin (padding around the search field container).
  ///
  /// Defaults to `EdgeInsets.fromLTRB(12, 8, 12, 4)`.
  final EdgeInsetsGeometry margin;

  /// Creates a [M3ESearchDecoration].
  const M3ESearchDecoration({
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
  });
}

/// Visual styling for individual items inside the dropdown list.
class M3EDropdownItemDecoration {
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
  /// Defaults to `4.0`.
  final double? innerRadius;

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

  /// Creates a [M3EDropdownItemDecoration].
  const M3EDropdownItemDecoration({
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
    this.innerRadius,
    this.itemGap,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.selectedBorderRadius,
  });
}
