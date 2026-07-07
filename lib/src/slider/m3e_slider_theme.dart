// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';

/// Colors for the [M3ESlider] and [M3ERangeSlider] components.
@immutable
class M3ESliderColors {
  /// Color of the thumb when enabled.
  final Color thumbColor;

  /// Color of the thumb when disabled.
  final Color disabledThumbColor;

  /// Color of the track in the active part.
  final Color activeTrackColor;

  /// Color of the track in the inactive part.
  final Color inactiveTrackColor;

  /// Color of the track in the active part when disabled.
  final Color disabledActiveTrackColor;

  /// Color of the track in the inactive part when disabled.
  final Color disabledInactiveTrackColor;

  /// Color of the active tick marks.
  final Color activeTickColor;

  /// Color of the inactive tick marks.
  final Color inactiveTickColor;

  /// Color of the active tick marks when disabled.
  final Color disabledActiveTickColor;

  /// Color of the inactive tick marks when disabled.
  final Color disabledInactiveTickColor;

  const M3ESliderColors({
    required this.thumbColor,
    required this.disabledThumbColor,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.disabledActiveTrackColor,
    required this.disabledInactiveTrackColor,
    required this.activeTickColor,
    required this.inactiveTickColor,
    required this.disabledActiveTickColor,
    required this.disabledInactiveTickColor,
  });

  /// Creates a copy of this [M3ESliderColors] with the given fields replaced.
  M3ESliderColors copyWith({
    Color? thumbColor,
    Color? disabledThumbColor,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? activeTickColor,
    Color? inactiveTickColor,
    Color? disabledActiveTickColor,
    Color? disabledInactiveTickColor,
  }) {
    return M3ESliderColors(
      thumbColor: thumbColor ?? this.thumbColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      disabledActiveTrackColor:
          disabledActiveTrackColor ?? this.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
      activeTickColor: activeTickColor ?? this.activeTickColor,
      inactiveTickColor: inactiveTickColor ?? this.inactiveTickColor,
      disabledActiveTickColor:
          disabledActiveTickColor ?? this.disabledActiveTickColor,
      disabledInactiveTickColor:
          disabledInactiveTickColor ?? this.disabledInactiveTickColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is M3ESliderColors &&
        other.thumbColor == thumbColor &&
        other.disabledThumbColor == disabledThumbColor &&
        other.activeTrackColor == activeTrackColor &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.disabledActiveTrackColor == disabledActiveTrackColor &&
        other.disabledInactiveTrackColor == disabledInactiveTrackColor &&
        other.activeTickColor == activeTickColor &&
        other.inactiveTickColor == inactiveTickColor &&
        other.disabledActiveTickColor == disabledActiveTickColor &&
        other.disabledInactiveTickColor == disabledInactiveTickColor;
  }

  @override
  int get hashCode => Object.hashAll([
    thumbColor,
    disabledThumbColor,
    activeTrackColor,
    inactiveTrackColor,
    disabledActiveTrackColor,
    disabledInactiveTrackColor,
    activeTickColor,
    inactiveTickColor,
    disabledActiveTickColor,
    disabledInactiveTickColor,
  ]);
}

/// Token defaults and helper methods for Material 3 Expressive Sliders.
abstract class M3ESliderDefaults {
  /// Default alpha of the inactive part of the track.
  static const double inactiveTrackAlpha = 1.0;

  /// Default height of the slider track.
  static const double trackHeight = 16.0;

  /// Default radius of the slider thumb.
  static const double thumbRadius = 10.0;

  /// Default radius of the slider thumb touch/ripple area.
  static const double thumbRippleRadius = 24.0;

  /// Default width of the vertical thumb pill.
  static const double thumbWidth = 4.0;

  /// Default height of the vertical thumb pill.
  static const double thumbHeight = 44.0;

  /// The gap size between track segments and the thumb.
  static const double thumbTrackGapSize = 6.0;

  /// Inside corner radius of the tracks facing the thumb.
  static const double trackInsideCornerSize = 2.0;

  /// Default size of the tick/stop indicator dots.
  static const double tickSize = 4.0;

  /// Default elevation of the thumb.
  static const double thumbElevation = 0.0;

  /// Default size of track icons.
  static const double trackIconSize = 24.0;

  /// Default color for track icons on the active track segment.
  static Color trackIconActiveColor(ColorScheme cs) => cs.primary;

  /// Default color for track icons on the inactive track segment.
  static Color trackIconInactiveColor(ColorScheme cs) => cs.onSurfaceVariant;

  /// Creates a standard [M3ESliderColors] using the active theme.
  static M3ESliderColors colors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primary = colorScheme.primary;
    final secondaryContainer = colorScheme.secondaryContainer;
    final onSurface = colorScheme.onSurface;
    final surface = colorScheme.surface;

    // Disabled thumb is onSurface at 38% opacity composited over surface
    final disabledThumb = Color.alphaBlend(
      onSurface.withValues(alpha: 0.38),
      surface,
    );

    final activeTrack = primary;
    final inactiveTrack = secondaryContainer;

    final disabledActiveTrack = onSurface.withValues(alpha: 0.38);
    final disabledInactiveTrack = onSurface.withValues(alpha: 0.12);

    final activeTick = secondaryContainer;
    final inactiveTick = primary;

    final disabledActiveTick = onSurface.withValues(alpha: 0.12);
    final disabledInactiveTick = onSurface.withValues(alpha: 0.38);

    return M3ESliderColors(
      thumbColor: primary,
      disabledThumbColor: disabledThumb,
      activeTrackColor: activeTrack,
      inactiveTrackColor: inactiveTrack,
      disabledActiveTrackColor: disabledActiveTrack,
      disabledInactiveTrackColor: disabledInactiveTrack,
      activeTickColor: activeTick,
      inactiveTickColor: inactiveTick,
      disabledActiveTickColor: disabledActiveTick,
      disabledInactiveTickColor: disabledInactiveTick,
    );
  }
}
