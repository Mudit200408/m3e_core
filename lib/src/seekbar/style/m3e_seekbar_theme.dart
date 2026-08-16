// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

/// Colors for the [M3ESeekbar] and [M3EWavySeekbar] components.
@immutable
class M3ESeekbarColors {
  /// Color of the handle (thumb) when enabled.
  final Color handleColor;

  /// Color of the handle when disabled.
  final Color disabledHandleColor;

  /// Color of the active portion of the track.
  final Color activeTrackColor;

  /// Color of the inactive portion of the track.
  final Color inactiveTrackColor;

  /// Color of the active track when disabled.
  final Color disabledActiveTrackColor;

  /// Color of the inactive track when disabled.
  final Color disabledInactiveTrackColor;

  /// Color of the secondary (buffered) portion of the track.
  final Color secondaryTrackColor;

  /// Color of the secondary track when disabled.
  final Color disabledSecondaryTrackColor;

  const M3ESeekbarColors({
    required this.handleColor,
    required this.disabledHandleColor,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.disabledActiveTrackColor,
    required this.disabledInactiveTrackColor,
    required this.secondaryTrackColor,
    required this.disabledSecondaryTrackColor,
  });

  /// Creates a copy of this [M3ESeekbarColors] with the given fields replaced.
  M3ESeekbarColors copyWith({
    Color? handleColor,
    Color? disabledHandleColor,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? secondaryTrackColor,
    Color? disabledSecondaryTrackColor,
  }) {
    return M3ESeekbarColors(
      handleColor: handleColor ?? this.handleColor,
      disabledHandleColor: disabledHandleColor ?? this.disabledHandleColor,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      disabledActiveTrackColor:
          disabledActiveTrackColor ?? this.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
      secondaryTrackColor: secondaryTrackColor ?? this.secondaryTrackColor,
      disabledSecondaryTrackColor:
          disabledSecondaryTrackColor ?? this.disabledSecondaryTrackColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is M3ESeekbarColors &&
        other.handleColor == handleColor &&
        other.disabledHandleColor == disabledHandleColor &&
        other.activeTrackColor == activeTrackColor &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.disabledActiveTrackColor == disabledActiveTrackColor &&
        other.disabledInactiveTrackColor == disabledInactiveTrackColor &&
        other.secondaryTrackColor == secondaryTrackColor &&
        other.disabledSecondaryTrackColor == disabledSecondaryTrackColor;
  }

  @override
  int get hashCode => Object.hash(
    handleColor,
    disabledHandleColor,
    activeTrackColor,
    inactiveTrackColor,
    disabledActiveTrackColor,
    disabledInactiveTrackColor,
    secondaryTrackColor,
    disabledSecondaryTrackColor,
  );
}

/// Token defaults and helper methods for Material 3 Expressive Seekbars
/// aligned with AOSP SystemUI SquigglyProgress specifications.
abstract class M3ESeekbarDefaults {
  /// Default height of the seekbar track.
  static const double trackHeight = 4.0;

  /// Default stroke width for standard and squiggly tracks.
  static const double strokeWidth = 2.0;

  /// Default radius for circular handles.
  static const double circleHandleRadius = 10.0;

  /// Default width for rectangular handles (AOSP SystemUI Media 4.dp thumb).
  static const double rectHandleWidth = 4.0;

  /// Default height for rectangular handles (AOSP SystemUI Media 16.dp thumb).
  static const double rectHandleHeight = 16.0;

  /// Corner radius for rectangular handles.
  static const double rectHandleCornerRadius = 2.0;

  /// Gap size between track and handle.
  static const double handleTrackGapSize = 4.0;

  /// Corner radius of the track ends facing the handle.
  static const double trackInsideCornerSize = 2.0;

  /// AOSP SquigglyProgress: Horizontal length of sine wave (waveLength).
  static const double waveLength = 20.0;

  /// AOSP SquigglyProgress: Peak amplitude height of sine wave (lineAmplitude).
  static const double lineAmplitude = 3.0;

  /// AOSP SquigglyProgress: Scrolling phase speed (pixels per second).
  static const double phaseSpeed = 16.0;

  /// AOSP SquigglyProgress: Distance over which wave amplitude drops to zero (in wavelengths).
  static const double transitionPeriods = 1.5;

  /// AOSP SquigglyProgress: Alpha multiplier for disabled/remaining track line (77/255 = 0.30).
  static const double disabledAlpha = 0.30;

  /// Creates a standard [M3ESeekbarColors] using the active theme.
  static M3ESeekbarColors colors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primary = colorScheme.primary;
    final onSurface = colorScheme.onSurface;
    final surface = colorScheme.surface;

    final disabledHandle = Color.alphaBlend(
      onSurface.withValues(alpha: 0.38),
      surface,
    );

    final activeTrack = primary;
    final inactiveTrack = onSurface.withValues(alpha: 0.16);
    final secondaryTrack = primary.withValues(alpha: 0.38);

    final disabledActiveTrack = onSurface.withValues(alpha: 0.38);
    final disabledInactiveTrack = onSurface.withValues(alpha: 0.08);
    final disabledSecondaryTrack = onSurface.withValues(alpha: 0.20);

    return M3ESeekbarColors(
      handleColor: primary,
      disabledHandleColor: disabledHandle,
      activeTrackColor: activeTrack,
      inactiveTrackColor: inactiveTrack,
      disabledActiveTrackColor: disabledActiveTrack,
      disabledInactiveTrackColor: disabledInactiveTrack,
      secondaryTrackColor: secondaryTrack,
      disabledSecondaryTrackColor: disabledSecondaryTrack,
    );
  }
}
