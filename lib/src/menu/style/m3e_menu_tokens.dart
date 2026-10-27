// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

/// Design tokens for Material 3 Expressive Menus.
///
/// Values extracted from Google Material 3 Design System Database (DSDB)
/// (Revision 7989) and Android Open Source Project (AOSP) Jetpack Compose
/// reference (`SegmentedMenuTokens`).
abstract final class M3EMenuTokens {
  // Dimensions
  /// Minimum width of a menu container.
  /// Ref: `md.comp.menus.container.min-width` / `DropdownMenuItemDefaultMinWidth`
  static const double containerMinWidth = 112.0;

  /// Maximum width of a menu container.
  /// Ref: `md.comp.menus.container.max-width` / `DropdownMenuItemDefaultMaxWidth`
  static const double containerMaxWidth = 280.0;

  /// Minimum height of a standard menu item touch target.
  /// Ref: `MenuListItemContainerHeight`
  static const double itemMinHeight = 48.0;

  /// Minimum height of a menu group header label.
  /// Ref: `DropdownMenuGroupDefaultMinHeight`
  static const double groupLabelMinHeight = 32.0;

  /// Default shadow elevation for a floating menu container (Level 2).
  /// Ref: `md.comp.menus.container.elevation`
  static const double containerElevation = 3.0;

  /// Inner vertical padding applied to the menu container.
  /// Ref: `DropdownMenuVerticalPadding`
  static const double containerVerticalPadding = 8.0;

  /// Horizontal margin from screen edges.
  /// Ref: `MenuHorizontalMargin`
  static const double screenMarginHorizontal = 8.0;

  /// Vertical margin from screen edges.
  /// Ref: `MenuVerticalMargin`
  static const double screenMarginVertical = 48.0;

  /// Default vertical gap between the anchor button and the popup menu.
  /// Ref: `md.comp.menus.anchor-gap`
  static const double anchorGap = 8.0;

  /// Horizontal padding for standard dropdown menu item content.
  /// Ref: `DropdownMenuItemHorizontalPadding` (12dp)
  static const double itemHorizontalPadding = 12.0;

  /// Horizontal padding for menu items in an exposed dropdown menu (anchored to a text field).
  /// Ref: `ExposedDropdownMenuItemHorizontalPadding` (16dp)
  static const double exposedDropdownItemHorizontalPadding = 16.0;

  /// Vertical padding for selectable items.
  /// Ref: `SelectableItemVerticalPadding`
  static const double selectableItemVerticalPadding = 12.0;

  /// Spacing gap between segmented groups.
  /// Ref: `md.comp.menus.gap` (`SegmentedGap`)
  static const double groupGap = 2.0;

  /// Inner vertical padding inside a segmented menu group.
  /// Ref: `md.comp.menus.group.padding` (`space25`)
  static const double groupInnerPadding = 2.0;

  /// Horizontal padding for dividers separating items in a menu.
  /// Ref: `HorizontalDividerPadding` (horizontal = 12dp)
  static const double dividerHorizontalPadding = 12.0;

  /// Vertical padding for dividers separating items in a menu.
  /// Ref: `HorizontalDividerPadding` (vertical = 2dp)
  static const double dividerVerticalPadding = 2.0;

  /// Start padding for a menu group label.
  /// Ref: `DropdownMenuGroupLabelHorizontalPadding` (start = 12dp)
  static const double groupLabelPaddingStart = 12.0;

  /// End padding for a menu group label.
  /// Ref: `DropdownMenuGroupLabelHorizontalPadding` (end = 4dp)
  static const double groupLabelPaddingEnd = 4.0;

  /// End padding for a trailing label on precision pointer / desktop devices.
  /// Ref: `DropdownMenuItemTrailingLabelHorizontalPadding` (end = 6dp)
  static const double trailingLabelPaddingEndPrecision = 6.0;

  /// Start padding for selectable items on precision pointer / desktop devices.
  /// Ref: `DropdownMenuSelectableItemContentPadding` (start = 16dp)
  static const double selectableItemPaddingStartPrecision = 16.0;

  /// End padding for selectable items on precision pointer / desktop devices.
  /// Ref: `DropdownMenuSelectableItemContentPadding` (end = 10dp)
  static const double selectableItemPaddingEndPrecision = 10.0;

  /// Spacing between icon and label text on touch devices.
  static const double iconTextSpacingTouch = 8.0;

  /// Spacing between icon and label text on precision pointer / desktop devices.
  static const double iconTextSpacingPrecision = 12.0;

  /// Default icon size in the leading slot.
  /// Ref: `SegmentedMenuTokens.ItemLeadingIconSize`
  static const double leadingIconSize = 24.0;

  /// Default icon size in the trailing slot.
  /// Ref: `SegmentedMenuTokens.ItemTrailingIconSize`
  static const double trailingIconSize = 24.0;

  // Shapes / Corner Radii
  /// Extra small corner radius (4dp).
  /// Ref: `md.sys.shape.corner.extra-small`
  static const double cornerExtraSmall = 4.0;

  /// Small corner radius (8dp).
  /// Ref: `md.sys.shape.corner.small`
  static const double cornerSmall = 8.0;

  /// Medium corner radius (12dp).
  /// Ref: `md.sys.shape.corner.medium`
  static const double cornerMedium = 12.0;

  /// Large corner radius (16dp).
  /// Ref: `md.sys.shape.corner.large`
  static const double cornerLarge = 16.0;

  /// Pill / Full circular corner radius (9999dp).
  /// Ref: `md.sys.shape.corner.full`
  static const double cornerFull = 9999.0;

  // Opacities
  /// Disabled content opacity.
  static const double disabledOpacity = 0.38;

  /// Hover state layer opacity.
  static const double hoverOpacity = 0.08;

  /// Focus state layer opacity.
  static const double focusOpacity = 0.12;

  /// Pressed state layer opacity.
  static const double pressedOpacity = 0.12;

  // Animation Scale & Alpha Targets
  /// Scale when the menu is collapsed.
  static const double closedScaleTarget = 0.8;

  /// Scale when the menu is fully expanded.
  static const double expandedScaleTarget = 1.0;

  /// Alpha when the menu is collapsed.
  static const double closedAlphaTarget = 0.0;

  /// Alpha when the menu is fully expanded.
  static const double expandedAlphaTarget = 1.0;

  /// Empirical content slide ratio during vertical height reveal (§0.5).
  /// Content is translated by `0.24 * (1 - h)` during the reveal.
  static const double revealContentTranslationRatio = 0.24;
}
