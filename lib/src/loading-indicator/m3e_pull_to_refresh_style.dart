import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/m3e_common.dart';

/// Style configuration for [M3EPullToRefreshIndicator].
@immutable
class M3EPullToRefreshStyle with Diagnosticable {
  /// Background color of the contained loading indicator.
  final Color? containerColor;

  /// Primary color of the loading indicator shape morph.
  final Color? indicatorColor;

  /// Width and height size of the loading indicator.
  final double? size;

  /// Inner padding applied around the loading indicator.
  final EdgeInsetsGeometry? padding;

  /// Elevation of the container shadow.
  final double? elevation;

  /// Corner border radius of the container.
  final BorderRadiusGeometry? borderRadius;

  /// Pull distance required to trigger the refresh callback.
  final double? triggerDistance;

  /// Settled height of the loading indicator container during refresh.
  final double? indicatorHeight;

  /// Spring motion specification for retract animations.
  final M3EMotion? springMotion;

  /// Haptic feedback intensity when drag reaches [triggerDistance].
  final M3EHapticFeedback? hapticFeedback;

  /// Resistance factor applied to raw drag delta.
  final double? dragResistance;

  /// Multiplier applied to [triggerDistance] to compute the maximum drag cap.
  final double? maxDragMultiplier;

  const M3EPullToRefreshStyle({
    this.containerColor,
    this.indicatorColor,
    this.size,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.triggerDistance,
    this.indicatorHeight,
    this.springMotion,
    this.hapticFeedback,
    this.dragResistance,
    this.maxDragMultiplier,
  });

  /// Creates a copy of this style with the given fields replaced.
  M3EPullToRefreshStyle copyWith({
    Color? containerColor,
    Color? indicatorColor,
    double? size,
    EdgeInsetsGeometry? padding,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    double? triggerDistance,
    double? indicatorHeight,
    M3EMotion? springMotion,
    M3EHapticFeedback? hapticFeedback,
    double? dragResistance,
    double? maxDragMultiplier,
  }) {
    return M3EPullToRefreshStyle(
      containerColor: containerColor ?? this.containerColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      size: size ?? this.size,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      triggerDistance: triggerDistance ?? this.triggerDistance,
      indicatorHeight: indicatorHeight ?? this.indicatorHeight,
      springMotion: springMotion ?? this.springMotion,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      dragResistance: dragResistance ?? this.dragResistance,
      maxDragMultiplier: maxDragMultiplier ?? this.maxDragMultiplier,
    );
  }

  /// Linearly interpolates between two [M3EPullToRefreshStyle] instances.
  static M3EPullToRefreshStyle? lerp(
    M3EPullToRefreshStyle? a,
    M3EPullToRefreshStyle? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return M3EPullToRefreshStyle(
      containerColor: Color.lerp(a?.containerColor, b?.containerColor, t),
      indicatorColor: Color.lerp(a?.indicatorColor, b?.indicatorColor, t),
      size: lerpDouble(a?.size, b?.size, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a?.borderRadius,
        b?.borderRadius,
        t,
      ),
      triggerDistance: lerpDouble(a?.triggerDistance, b?.triggerDistance, t),
      indicatorHeight: lerpDouble(a?.indicatorHeight, b?.indicatorHeight, t),
      springMotion: t < 0.5 ? a?.springMotion : b?.springMotion,
      hapticFeedback: t < 0.5 ? a?.hapticFeedback : b?.hapticFeedback,
      dragResistance: lerpDouble(a?.dragResistance, b?.dragResistance, t),
      maxDragMultiplier: lerpDouble(
        a?.maxDragMultiplier,
        b?.maxDragMultiplier,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EPullToRefreshStyle &&
          runtimeType == other.runtimeType &&
          containerColor == other.containerColor &&
          indicatorColor == other.indicatorColor &&
          size == other.size &&
          padding == other.padding &&
          elevation == other.elevation &&
          borderRadius == other.borderRadius &&
          triggerDistance == other.triggerDistance &&
          indicatorHeight == other.indicatorHeight &&
          springMotion == other.springMotion &&
          hapticFeedback == other.hapticFeedback &&
          dragResistance == other.dragResistance &&
          maxDragMultiplier == other.maxDragMultiplier;

  @override
  int get hashCode => Object.hash(
    containerColor,
    indicatorColor,
    size,
    padding,
    elevation,
    borderRadius,
    triggerDistance,
    indicatorHeight,
    springMotion,
    hapticFeedback,
    dragResistance,
    maxDragMultiplier,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('containerColor', containerColor));
    properties.add(ColorProperty('indicatorColor', indicatorColor));
    properties.add(DoubleProperty('size', size));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>('borderRadius', borderRadius),
    );
    properties.add(DoubleProperty('triggerDistance', triggerDistance));
    properties.add(DoubleProperty('indicatorHeight', indicatorHeight));
    properties.add(
      DiagnosticsProperty<M3EMotion>('springMotion', springMotion),
    );
    properties.add(
      EnumProperty<M3EHapticFeedback>('hapticFeedback', hapticFeedback),
    );
    properties.add(DoubleProperty('dragResistance', dragResistance));
    properties.add(DoubleProperty('maxDragMultiplier', maxDragMultiplier));
  }
}
