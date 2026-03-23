import 'package:flutter/material.dart';

import 'm3e_button_enums.dart';
import 'm3e_motion.dart';

/// Styling overrides for [M3EButton].
///
/// Pass an instance to [M3EButton.decoration] to customize colors, shape,
/// motion, and haptic feedback without subclassing.
///
/// All fields are optional; null means "use the token default for this style
/// and size". Combine with [copyWith] to build incremental overrides.
///
/// This class is `@immutable`. Create a new instance (or use [copyWith])
/// rather than modifying an existing one. Equality is value-based so the
/// same logical decoration produces a stable layout signature.
///
/// ## Example
/// ```dart
/// M3EButton(
///   decoration: M3EButtonDecoration(
///     backgroundColor: Colors.blue,
///     foregroundColor: Colors.white,
///     motion: M3EMotion.custom(1600, 0.95),
///   ),
///   onPressed: () {},
///   child: const Text('Custom Button'),
/// )
/// ```
///
/// See also:
/// - [M3EToggleButtonDecoration] for toggle button styling
@immutable
class M3EButtonDecoration {
  /// Background color of the button.
  final Color? backgroundColor;

  /// Foreground (text/icon) color of the button.
  final Color? foregroundColor;

  /// Background color of the button when disabled.
  final Color? disabledBackgroundColor;

  /// Foreground color of the button when disabled.
  final Color? disabledForegroundColor;

  /// Custom border side.
  final BorderSide? borderSide;

  /// Custom corner radius.
  final BorderRadius? borderRadius;

  /// Spring physics configuration.
  final M3EMotion? motion;

  /// Haptic feedback level.
  final M3EHapticFeedback? haptic;

  /// Custom size override.
  final M3EButtonSize? size;

  /// Custom corner radius when hovered.
  final double? hoveredRadius;

  /// Custom corner radius when pressed.
  final double? pressedRadius;

  /// Custom mouse cursor.
  final MouseCursor? mouseCursor;

  /// The color of the overlay that appears behind the button.
  ///
  /// This is used to show pressed/hovered states.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The color of the surface tint overlay.
  ///
  /// Only applies to filled and tonal button styles.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  const M3EButtonDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderSide,
    this.borderRadius,
    this.motion,
    this.haptic,
    this.hoveredRadius,
    this.pressedRadius,
    this.mouseCursor,
    this.size,
    this.overlayColor,
    this.surfaceTintColor,
  });

  /// Creates a copy of this decoration with the given fields replaced.
  ///
  /// All null parameters will use the current decoration's values.
  M3EButtonDecoration copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    M3EMotion? motion,
    M3EHapticFeedback? haptic,
    double? hoveredRadius,
    double? pressedRadius,
    MouseCursor? mouseCursor,
    M3EButtonSize? size,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
  }) {
    return M3EButtonDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      motion: motion ?? this.motion,
      haptic: haptic ?? this.haptic,
      hoveredRadius: hoveredRadius ?? this.hoveredRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      size: size ?? this.size,
      overlayColor: overlayColor ?? this.overlayColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EButtonDecoration &&
          backgroundColor == other.backgroundColor &&
          foregroundColor == other.foregroundColor &&
          disabledBackgroundColor == other.disabledBackgroundColor &&
          disabledForegroundColor == other.disabledForegroundColor &&
          borderSide == other.borderSide &&
          borderRadius == other.borderRadius &&
          motion == other.motion &&
          haptic == other.haptic &&
          hoveredRadius == other.hoveredRadius &&
          pressedRadius == other.pressedRadius &&
          mouseCursor == other.mouseCursor &&
          size == other.size &&
          overlayColor == other.overlayColor &&
          surfaceTintColor == other.surfaceTintColor;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    disabledBackgroundColor,
    disabledForegroundColor,
    borderSide,
    borderRadius,
    motion,
    haptic,
    hoveredRadius,
    pressedRadius,
    mouseCursor,
    size,
    overlayColor,
    surfaceTintColor,
  );
}

/// Styling overrides for [M3EToggleButton].
///
/// Pass an instance to [M3EToggleButton.decoration] to customize colors,
/// motion, radii, and haptic feedback without subclassing.
///
/// All fields are optional; null means "use the token default for this style
/// and size". Combine with [copyWith] to build incremental overrides.
///
/// This class is `@immutable`. Create a new instance (or use [copyWith])
/// rather than modifying an existing one. Equality is value-based so the
/// same logical decoration produces a stable layout signature.
///
/// ## Example
/// ```dart
/// M3EToggleButton(
///   decoration: M3EToggleButtonDecoration(
///     checkedBackgroundColor: Colors.blue,
///     checkedForegroundColor: Colors.white,
///     haptic: M3EHapticFeedback.light,
///   ),
///   onCheckedChange: (checked) {},
///   child: const Icon(Icons.favorite),
/// )
/// ```
///
/// See also:
/// - [M3EButtonDecoration] for standard button styling
@immutable
class M3EToggleButtonDecoration {
  /// Background color of the button.
  final Color? backgroundColor;

  /// Foreground (text/icon) color of the button.
  final Color? foregroundColor;

  /// Background color when checked.
  final Color? checkedBackgroundColor;

  /// Foreground color when checked.
  final Color? checkedForegroundColor;

  /// Background color when disabled.
  final Color? disabledBackgroundColor;

  /// Foreground color when disabled.
  final Color? disabledForegroundColor;

  /// Custom border side.
  final BorderSide? borderSide;

  /// Spring physics configuration.
  final M3EMotion? motion;

  /// Haptic feedback level.
  final M3EHapticFeedback? haptic;

  /// Corner radius when checked.
  final double? checkedRadius;

  /// Corner radius when unchecked.
  final double? uncheckedRadius;

  /// Corner radius when pressed.
  final double? pressedRadius;

  /// Corner radius when hovered.
  final double? hoveredRadius;

  /// Inner corner radius for connected button groups.
  final double? connectedInnerRadius;

  /// Hovered inner corner radius for connected button groups.
  final double? connectedHoveredInnerRadius;

  /// Custom size override.
  final M3EButtonSize? size;

  /// Custom mouse cursor.
  final MouseCursor? mouseCursor;

  /// The color of the overlay that appears behind the button.
  ///
  /// This is used to show pressed/hovered states.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The color of the surface tint overlay.
  ///
  /// Only applies to filled and tonal button styles.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  const M3EToggleButtonDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.checkedBackgroundColor,
    this.checkedForegroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderSide,
    this.motion,
    this.haptic,
    this.checkedRadius,
    this.uncheckedRadius,
    this.pressedRadius,
    this.hoveredRadius,
    this.connectedInnerRadius,
    this.connectedHoveredInnerRadius,
    this.mouseCursor,
    this.size,
    this.overlayColor,
    this.surfaceTintColor,
  });

  /// Creates a copy of this decoration with the given fields replaced.
  ///
  /// All null parameters will use the current decoration's values.
  M3EToggleButtonDecoration copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? checkedBackgroundColor,
    Color? checkedForegroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    BorderSide? borderSide,
    M3EMotion? motion,
    M3EHapticFeedback? haptic,
    double? checkedRadius,
    double? uncheckedRadius,
    double? pressedRadius,
    double? hoveredRadius,
    double? connectedInnerRadius,
    double? connectedHoveredInnerRadius,
    MouseCursor? mouseCursor,
    M3EButtonSize? size,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
  }) {
    return M3EToggleButtonDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      checkedBackgroundColor:
          checkedBackgroundColor ?? this.checkedBackgroundColor,
      checkedForegroundColor:
          checkedForegroundColor ?? this.checkedForegroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      borderSide: borderSide ?? this.borderSide,
      motion: motion ?? this.motion,
      haptic: haptic ?? this.haptic,
      checkedRadius: checkedRadius ?? this.checkedRadius,
      uncheckedRadius: uncheckedRadius ?? this.uncheckedRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      hoveredRadius: hoveredRadius ?? this.hoveredRadius,
      connectedInnerRadius: connectedInnerRadius ?? this.connectedInnerRadius,
      connectedHoveredInnerRadius:
          connectedHoveredInnerRadius ?? this.connectedHoveredInnerRadius,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      size: size ?? this.size,
      overlayColor: overlayColor ?? this.overlayColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EToggleButtonDecoration &&
          backgroundColor == other.backgroundColor &&
          foregroundColor == other.foregroundColor &&
          checkedBackgroundColor == other.checkedBackgroundColor &&
          checkedForegroundColor == other.checkedForegroundColor &&
          disabledBackgroundColor == other.disabledBackgroundColor &&
          disabledForegroundColor == other.disabledForegroundColor &&
          borderSide == other.borderSide &&
          motion == other.motion &&
          haptic == other.haptic &&
          checkedRadius == other.checkedRadius &&
          uncheckedRadius == other.uncheckedRadius &&
          pressedRadius == other.pressedRadius &&
          hoveredRadius == other.hoveredRadius &&
          connectedInnerRadius == other.connectedInnerRadius &&
          connectedHoveredInnerRadius == other.connectedHoveredInnerRadius &&
          mouseCursor == other.mouseCursor &&
          size == other.size &&
          overlayColor == other.overlayColor &&
          surfaceTintColor == other.surfaceTintColor;

  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    foregroundColor,
    checkedBackgroundColor,
    checkedForegroundColor,
    disabledBackgroundColor,
    disabledForegroundColor,
    borderSide,
    motion,
    haptic,
    checkedRadius,
    uncheckedRadius,
    pressedRadius,
    hoveredRadius,
    connectedInnerRadius,
    connectedHoveredInnerRadius,
    mouseCursor,
    size,
    overlayColor,
    surfaceTintColor,
  ]);
}
