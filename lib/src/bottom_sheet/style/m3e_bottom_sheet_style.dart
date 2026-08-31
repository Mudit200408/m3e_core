// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:material_ui/material_ui.dart';
import '../../common/m3e_common.dart';

/// Style configuration for [M3EBottomSheet] and [showM3EModalBottomSheet].
@immutable
class M3EBottomSheetStyle {
  /// Creates an [M3EBottomSheetStyle].
  const M3EBottomSheetStyle({
    this.backgroundColor,
    this.surfaceTintColor,
    this.shadowColor,
    this.elevation,
    this.shape,
    this.borderRadius = 28.0,
    this.dragHandleColor,
    this.dragHandleSize = const Size(32, 4),
    this.dragHandlePadding = const EdgeInsets.symmetric(vertical: 16),
    this.motion = M3EMotion.expressiveSpatialDefault,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
    this.clipBehavior = Clip.antiAlias,
  });

  /// The background color of the bottom sheet.
  final Color? backgroundColor;

  /// The surface tint color applied to the sheet when elevated.
  final Color? surfaceTintColor;

  /// The shadow color cast when elevated.
  final Color? shadowColor;

  /// The elevation of the sheet.
  final double? elevation;

  /// Custom shape border. When specified, overrides [borderRadius].
  final ShapeBorder? shape;

  /// The top corner radius (in logical pixels) for the sheet.
  ///
  /// Defaults to 28.0dp according to Material 3 Expressive guidelines.
  final double borderRadius;

  /// The color of the top drag handle indicator.
  final Color? dragHandleColor;

  /// The dimensions of the top drag handle. Defaults to 32x4 dp.
  final Size dragHandleSize;

  /// The padding around the top drag handle.
  final EdgeInsetsGeometry dragHandlePadding;

  /// The spring motion preset driving the sheet's entrance and exit.
  final M3EMotion? motion;

  /// Content padding inside the sheet.
  final EdgeInsetsGeometry padding;

  /// The clip behavior for the sheet container.
  final Clip clipBehavior;

  /// Creates a copy of this style with the given fields replaced.
  M3EBottomSheetStyle copyWith({
    Color? backgroundColor,
    Color? surfaceTintColor,
    Color? shadowColor,
    double? elevation,
    ShapeBorder? shape,
    double? borderRadius,
    Color? dragHandleColor,
    Size? dragHandleSize,
    EdgeInsetsGeometry? dragHandlePadding,
    M3EMotion? motion,
    EdgeInsetsGeometry? padding,
    Clip? clipBehavior,
  }) {
    return M3EBottomSheetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      borderRadius: borderRadius ?? this.borderRadius,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      dragHandleSize: dragHandleSize ?? this.dragHandleSize,
      dragHandlePadding: dragHandlePadding ?? this.dragHandlePadding,
      motion: motion ?? this.motion,
      padding: padding ?? this.padding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between two [M3EBottomSheetStyle] objects.
  static M3EBottomSheetStyle? lerp(
    M3EBottomSheetStyle? a,
    M3EBottomSheetStyle? b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (a == null) return b;
    if (b == null) return a;
    return M3EBottomSheetStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      surfaceTintColor: Color.lerp(a.surfaceTintColor, b.surfaceTintColor, t),
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t),
      elevation: lerpDouble(a.elevation, b.elevation, t),
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
      borderRadius: lerpDouble(a.borderRadius, b.borderRadius, t) ?? 28.0,
      dragHandleColor: Color.lerp(a.dragHandleColor, b.dragHandleColor, t),
      dragHandleSize:
          Size.lerp(a.dragHandleSize, b.dragHandleSize, t) ?? const Size(32, 4),
      dragHandlePadding:
          EdgeInsetsGeometry.lerp(
            a.dragHandlePadding,
            b.dragHandlePadding,
            t,
          ) ??
          const EdgeInsets.symmetric(vertical: 16),
      motion: t < 0.5 ? a.motion : b.motion,
      padding:
          EdgeInsetsGeometry.lerp(a.padding, b.padding, t) ??
          const EdgeInsets.fromLTRB(24, 0, 24, 24),
      clipBehavior: t < 0.5 ? a.clipBehavior : b.clipBehavior,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EBottomSheetStyle &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          surfaceTintColor == other.surfaceTintColor &&
          shadowColor == other.shadowColor &&
          elevation == other.elevation &&
          shape == other.shape &&
          borderRadius == other.borderRadius &&
          dragHandleColor == other.dragHandleColor &&
          dragHandleSize == other.dragHandleSize &&
          dragHandlePadding == other.dragHandlePadding &&
          motion == other.motion &&
          padding == other.padding &&
          clipBehavior == other.clipBehavior;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    surfaceTintColor,
    shadowColor,
    elevation,
    shape,
    borderRadius,
    dragHandleColor,
    dragHandleSize,
    dragHandlePadding,
    motion,
    padding,
    clipBehavior,
  );
}
