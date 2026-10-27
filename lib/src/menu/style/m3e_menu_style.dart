// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../../common/m3e_common.dart';
import 'm3e_menu_animation_style.dart';
import 'm3e_menu_position.dart';
import 'm3e_menu_tokens.dart';

/// The color scheme variant for a Material 3 Expressive menu.
enum M3EMenuColorSchemeVariant {
  /// Surface-based color palette for general utilitarian actions and context menus.
  standard,

  /// Tertiary-based color palette providing bold visual emphasis.
  /// Recommended to be used sparingly for prominent or featured actions.
  vibrant,
}

/// Represents the active and inactive shapes for a segmented menu group.
@immutable
class MenuGroupShapes with Diagnosticable {
  /// The shape of the group when active or hovered.
  final ShapeBorder shape;

  /// The shape of the group when inactive or no longer hovered.
  final ShapeBorder inactiveShape;

  const MenuGroupShapes({required this.shape, required this.inactiveShape});

  /// Factory for a standalone menu group (count == 1).
  factory MenuGroupShapes.standalone() {
    return const MenuGroupShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerLarge),
        ),
      ),
      inactiveShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerSmall),
        ),
      ),
    );
  }

  /// Factory for the leading group in a list of groups (index == 0).
  factory MenuGroupShapes.leading() {
    return const MenuGroupShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(M3EMenuTokens.cornerLarge),
          topRight: Radius.circular(M3EMenuTokens.cornerLarge),
          bottomLeft: Radius.circular(M3EMenuTokens.cornerSmall),
          bottomRight: Radius.circular(M3EMenuTokens.cornerSmall),
        ),
      ),
      inactiveShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerSmall),
        ),
      ),
    );
  }

  /// Factory for a middle group in a list of groups.
  factory MenuGroupShapes.middle() {
    return const MenuGroupShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerSmall),
        ),
      ),
      inactiveShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerSmall),
        ),
      ),
    );
  }

  /// Factory for the trailing group in a list of groups (index == count - 1).
  factory MenuGroupShapes.trailing() {
    return const MenuGroupShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(M3EMenuTokens.cornerSmall),
          topRight: Radius.circular(M3EMenuTokens.cornerSmall),
          bottomLeft: Radius.circular(M3EMenuTokens.cornerLarge),
          bottomRight: Radius.circular(M3EMenuTokens.cornerLarge),
        ),
      ),
      inactiveShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerSmall),
        ),
      ),
    );
  }

  /// Resolves the appropriate group shapes given its [index] and total [count].
  static MenuGroupShapes resolve(int index, int count) {
    if (count <= 1) return MenuGroupShapes.standalone();
    if (index == 0) return MenuGroupShapes.leading();
    if (index == count - 1) return MenuGroupShapes.trailing();
    return MenuGroupShapes.middle();
  }

  MenuGroupShapes copyWith({ShapeBorder? shape, ShapeBorder? inactiveShape}) {
    return MenuGroupShapes(
      shape: shape ?? this.shape,
      inactiveShape: inactiveShape ?? this.inactiveShape,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuGroupShapes &&
          runtimeType == other.runtimeType &&
          shape == other.shape &&
          inactiveShape == other.inactiveShape;

  @override
  int get hashCode => Object.hash(shape, inactiveShape);
}

/// Represents the unselected and selected shapes for a menu item.
@immutable
class MenuItemShapes with Diagnosticable {
  /// The unselected shape of the menu item.
  final ShapeBorder shape;

  /// The shape of the menu item when selected or checked.
  final ShapeBorder selectedShape;

  const MenuItemShapes({required this.shape, required this.selectedShape});

  /// Factory for a standalone menu item (count == 1).
  factory MenuItemShapes.standalone() {
    return const MenuItemShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerExtraSmall),
        ),
      ),
      selectedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerMedium),
        ),
      ),
    );
  }

  /// Factory for the leading item in a menu or group (index == 0).
  factory MenuItemShapes.leading() {
    return const MenuItemShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(M3EMenuTokens.cornerMedium),
          topRight: Radius.circular(M3EMenuTokens.cornerMedium),
          bottomLeft: Radius.circular(M3EMenuTokens.cornerExtraSmall),
          bottomRight: Radius.circular(M3EMenuTokens.cornerExtraSmall),
        ),
      ),
      selectedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerMedium),
        ),
      ),
    );
  }

  /// Factory for a middle item in a menu or group.
  factory MenuItemShapes.middle() {
    return const MenuItemShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerExtraSmall),
        ),
      ),
      selectedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerMedium),
        ),
      ),
    );
  }

  /// Factory for the trailing item in a menu or group (index == count - 1).
  factory MenuItemShapes.trailing() {
    return const MenuItemShapes(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(M3EMenuTokens.cornerExtraSmall),
          topRight: Radius.circular(M3EMenuTokens.cornerExtraSmall),
          bottomLeft: Radius.circular(M3EMenuTokens.cornerMedium),
          bottomRight: Radius.circular(M3EMenuTokens.cornerMedium),
        ),
      ),
      selectedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(M3EMenuTokens.cornerMedium),
        ),
      ),
    );
  }

  /// Resolves the appropriate item shapes given its [index] and total [count].
  static MenuItemShapes resolve(int index, int count) {
    if (count <= 1) return MenuItemShapes.standalone();
    if (index == 0) return MenuItemShapes.leading();
    if (index == count - 1) return MenuItemShapes.trailing();
    return MenuItemShapes.middle();
  }

  MenuItemShapes copyWith({ShapeBorder? shape, ShapeBorder? selectedShape}) {
    return MenuItemShapes(
      shape: shape ?? this.shape,
      selectedShape: selectedShape ?? this.selectedShape,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItemShapes &&
          runtimeType == other.runtimeType &&
          shape == other.shape &&
          selectedShape == other.selectedShape;

  @override
  int get hashCode => Object.hash(shape, selectedShape);
}

/// Visual styling configuration for an [M3EMenuAnchor] or popup menu container.
@immutable
class M3EMenuStyle with Diagnosticable {
  /// Background color of the menu container.
  final Color? backgroundColor;

  /// Shadow elevation for the menu popup. Defaults to [M3EMenuTokens.containerElevation].
  final double? elevation;

  /// Shadow color for the popup.
  final Color? shadowColor;

  /// Surface tint color for the container.
  final Color? surfaceTintColor;

  /// Inner padding for the menu content.
  final EdgeInsetsGeometry? padding;

  /// Outer shape of the menu container.
  final ShapeBorder? shape;

  /// Spring motion used for spatial animations (scale, bounds).
  final M3EMotion spatialMotion;

  /// Spring motion used for effect animations (fade, opacity).
  final M3EMotion effectsMotion;

  /// Minimum width of the menu popup. Defaults to [M3EMenuTokens.containerMinWidth].
  final double? minWidth;

  /// Maximum width of the menu popup. Defaults to [M3EMenuTokens.containerMaxWidth].
  final double? maxWidth;

  /// Maximum height constraint of the menu popup.
  final double? maxHeight;

  /// Reveal animation used when the popup opens and closes.
  ///
  /// Defaults to [M3EMenuAnimationStyle.popup].
  final M3EMenuAnimationStyle animationStyle;

  /// Whether the popup is placed over or under its anchor.
  ///
  /// Defaults to [M3EMenuPosition.under], which places the menu below the
  /// anchor and flips it above when the space below is insufficient.
  final M3EMenuPosition position;

  const M3EMenuStyle({
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding,
    this.shape,
    this.spatialMotion = M3EMotion.expressiveSpatialFast,
    this.effectsMotion = M3EMotion.standardEffectsFast,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.animationStyle = M3EMenuAnimationStyle.popup,
    this.position = M3EMenuPosition.under,
  });

  M3EMenuStyle copyWith({
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    EdgeInsetsGeometry? padding,
    ShapeBorder? shape,
    M3EMotion? spatialMotion,
    M3EMotion? effectsMotion,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    M3EMenuAnimationStyle? animationStyle,
    M3EMenuPosition? position,
  }) {
    return M3EMenuStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      padding: padding ?? this.padding,
      shape: shape ?? this.shape,
      spatialMotion: spatialMotion ?? this.spatialMotion,
      effectsMotion: effectsMotion ?? this.effectsMotion,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      animationStyle: animationStyle ?? this.animationStyle,
      position: position ?? this.position,
    );
  }

  /// Linearly interpolates between two [M3EMenuStyle] instances.
  static M3EMenuStyle? lerp(M3EMenuStyle? a, M3EMenuStyle? b, double t) {
    if (identical(a, b)) return a;
    if (a == null) return b;
    if (b == null) return a;
    return M3EMenuStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      elevation: lerpDouble(a.elevation, b.elevation, t),
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t),
      surfaceTintColor: Color.lerp(a.surfaceTintColor, b.surfaceTintColor, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
      spatialMotion: t < 0.5 ? a.spatialMotion : b.spatialMotion,
      effectsMotion: t < 0.5 ? a.effectsMotion : b.effectsMotion,
      minWidth: lerpDouble(a.minWidth, b.minWidth, t),
      maxWidth: lerpDouble(a.maxWidth, b.maxWidth, t),
      maxHeight: lerpDouble(a.maxHeight, b.maxHeight, t),
      animationStyle: t < 0.5 ? a.animationStyle : b.animationStyle,
      position: t < 0.5 ? a.position : b.position,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EMenuStyle &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          shadowColor == other.shadowColor &&
          surfaceTintColor == other.surfaceTintColor &&
          padding == other.padding &&
          shape == other.shape &&
          spatialMotion == other.spatialMotion &&
          effectsMotion == other.effectsMotion &&
          minWidth == other.minWidth &&
          maxWidth == other.maxWidth &&
          maxHeight == other.maxHeight &&
          animationStyle == other.animationStyle &&
          position == other.position;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    elevation,
    shadowColor,
    surfaceTintColor,
    padding,
    shape,
    spatialMotion,
    effectsMotion,
    minWidth,
    maxWidth,
    maxHeight,
    animationStyle,
    position,
  );
}

/// Visual styling configuration for an [M3EMenuItemButton] or selectable menu item.
@immutable
class M3EMenuItemStyle with Diagnosticable {
  /// Inner padding applied to the menu item content.
  final EdgeInsetsGeometry? padding;

  /// Item container background color when unselected.
  final Color? backgroundColor;

  /// Item text and icon foreground color when enabled and unselected.
  final Color? foregroundColor;

  /// Leading icon color when enabled.
  final Color? leadingIconColor;

  /// Trailing icon or shortcut color when enabled.
  final Color? trailingIconColor;

  /// Item background color when selected or checked.
  final Color? selectedBackgroundColor;

  /// Item text and icon color when selected or checked.
  final Color? selectedForegroundColor;

  /// Foreground color when disabled.
  final Color? disabledForegroundColor;

  /// Primary label text style.
  final TextStyle? textStyle;

  /// Text style when selected.
  final TextStyle? selectedTextStyle;

  /// Supporting secondary text style.
  final TextStyle? supportingTextStyle;

  /// Trailing shortcut / status text style.
  final TextStyle? trailingTextStyle;

  /// Corner shapes for unselected and selected states.
  final MenuItemShapes? shapes;

  /// Spring motion for interactive shape morphing.
  final M3EMotion spatialMotion;

  const M3EMenuItemStyle({
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.leadingIconColor,
    this.trailingIconColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.disabledForegroundColor,
    this.textStyle,
    this.selectedTextStyle,
    this.supportingTextStyle,
    this.trailingTextStyle,
    this.shapes,
    this.spatialMotion = M3EMotion.expressiveSpatialFast,
  });

  M3EMenuItemStyle copyWith({
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? leadingIconColor,
    Color? trailingIconColor,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    Color? disabledForegroundColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    TextStyle? supportingTextStyle,
    TextStyle? trailingTextStyle,
    MenuItemShapes? shapes,
    M3EMotion? spatialMotion,
  }) {
    return M3EMenuItemStyle(
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      leadingIconColor: leadingIconColor ?? this.leadingIconColor,
      trailingIconColor: trailingIconColor ?? this.trailingIconColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedForegroundColor:
          selectedForegroundColor ?? this.selectedForegroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      supportingTextStyle: supportingTextStyle ?? this.supportingTextStyle,
      trailingTextStyle: trailingTextStyle ?? this.trailingTextStyle,
      shapes: shapes ?? this.shapes,
      spatialMotion: spatialMotion ?? this.spatialMotion,
    );
  }

  /// Linearly interpolates between two [M3EMenuItemStyle] instances.
  static M3EMenuItemStyle? lerp(
    M3EMenuItemStyle? a,
    M3EMenuItemStyle? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (a == null) return b;
    if (b == null) return a;
    return M3EMenuItemStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      leadingIconColor: Color.lerp(a.leadingIconColor, b.leadingIconColor, t),
      trailingIconColor: Color.lerp(
        a.trailingIconColor,
        b.trailingIconColor,
        t,
      ),
      selectedBackgroundColor: Color.lerp(
        a.selectedBackgroundColor,
        b.selectedBackgroundColor,
        t,
      ),
      selectedForegroundColor: Color.lerp(
        a.selectedForegroundColor,
        b.selectedForegroundColor,
        t,
      ),
      disabledForegroundColor: Color.lerp(
        a.disabledForegroundColor,
        b.disabledForegroundColor,
        t,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      selectedTextStyle: TextStyle.lerp(
        a.selectedTextStyle,
        b.selectedTextStyle,
        t,
      ),
      supportingTextStyle: TextStyle.lerp(
        a.supportingTextStyle,
        b.supportingTextStyle,
        t,
      ),
      trailingTextStyle: TextStyle.lerp(
        a.trailingTextStyle,
        b.trailingTextStyle,
        t,
      ),
      shapes: t < 0.5 ? a.shapes : b.shapes,
      spatialMotion: t < 0.5 ? a.spatialMotion : b.spatialMotion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EMenuItemStyle &&
          runtimeType == other.runtimeType &&
          padding == other.padding &&
          backgroundColor == other.backgroundColor &&
          foregroundColor == other.foregroundColor &&
          leadingIconColor == other.leadingIconColor &&
          trailingIconColor == other.trailingIconColor &&
          selectedBackgroundColor == other.selectedBackgroundColor &&
          selectedForegroundColor == other.selectedForegroundColor &&
          disabledForegroundColor == other.disabledForegroundColor &&
          textStyle == other.textStyle &&
          selectedTextStyle == other.selectedTextStyle &&
          supportingTextStyle == other.supportingTextStyle &&
          trailingTextStyle == other.trailingTextStyle &&
          shapes == other.shapes &&
          spatialMotion == other.spatialMotion;

  @override
  int get hashCode => Object.hash(
    padding,
    backgroundColor,
    foregroundColor,
    leadingIconColor,
    trailingIconColor,
    selectedBackgroundColor,
    selectedForegroundColor,
    disabledForegroundColor,
    textStyle,
    selectedTextStyle,
    supportingTextStyle,
    trailingTextStyle,
    shapes,
    spatialMotion,
  );
}
