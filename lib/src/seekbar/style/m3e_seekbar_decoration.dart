// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';
import '../../common/m3e_common.dart';
import 'm3e_seekbar_handle_shape.dart';
import 'm3e_seekbar_theme.dart';

/// Styling, token shape, and haptic overrides for [M3ESeekbar] and [M3EWavySeekbar].
@immutable
class M3ESeekbarDecoration {
  /// The shape token for the handle (`circle` or `rectangle`).
  final M3ESeekbarHandleShape handleShape;

  /// Custom colors for the seekbar components.
  final M3ESeekbarColors? colors;

  /// Haptic feedback level to apply during interactions.
  final M3EHapticFeedback? haptic;

  /// Custom haptic configuration.
  final M3EHapticConfig? hapticConfig;

  /// Custom height of the seekbar track.
  final double? trackHeight;

  /// Custom corner radius controlling the ends of the seekbar track.
  final double? trackCornerRadius;

  /// Custom width of a rectangular handle (used when [handleShape] is [M3ESeekbarHandleShape.rectangle]).
  final double? handleWidth;

  /// Custom height of a rectangular handle (used when [handleShape] is [M3ESeekbarHandleShape.rectangle]).
  final double? handleHeight;

  /// Custom radius of a circular handle (used when [handleShape] is [M3ESeekbarHandleShape.circle]).
  final double? handleRadius;

  /// Horizontal length of the squiggly sine wave (AOSP SquigglyProgress `waveLength`).
  final double? waveLength;

  /// Peak amplitude height of the squiggly sine wave (AOSP SquigglyProgress `lineAmplitude`).
  final double? lineAmplitude;

  /// Horizontal phase scrolling speed in px/sec (AOSP SquigglyProgress `phaseSpeed`).
  final double? phaseSpeed;

  /// Whether amplitude smooth transition tapering near progress point is enabled.
  final bool transitionEnabled;

  const M3ESeekbarDecoration({
    this.handleShape = M3ESeekbarHandleShape.circle,
    this.colors,
    this.haptic = M3EHapticFeedback.none,
    this.hapticConfig,
    this.trackHeight,
    this.trackCornerRadius,
    this.handleWidth,
    this.handleHeight,
    this.handleRadius,
    this.waveLength,
    this.lineAmplitude,
    this.phaseSpeed,
    this.transitionEnabled = true,
  });

  /// Creates a copy of this decoration with the given fields replaced.
  M3ESeekbarDecoration copyWith({
    M3ESeekbarHandleShape? handleShape,
    M3ESeekbarColors? colors,
    M3EHapticFeedback? haptic,
    M3EHapticConfig? hapticConfig,
    double? trackHeight,
    double? trackCornerRadius,
    double? handleWidth,
    double? handleHeight,
    double? handleRadius,
    double? waveLength,
    double? lineAmplitude,
    double? phaseSpeed,
    bool? transitionEnabled,
  }) {
    return M3ESeekbarDecoration(
      handleShape: handleShape ?? this.handleShape,
      colors: colors ?? this.colors,
      haptic: haptic ?? this.haptic,
      hapticConfig: hapticConfig ?? this.hapticConfig,
      trackHeight: trackHeight ?? this.trackHeight,
      trackCornerRadius: trackCornerRadius ?? this.trackCornerRadius,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
      handleRadius: handleRadius ?? this.handleRadius,
      waveLength: waveLength ?? this.waveLength,
      lineAmplitude: lineAmplitude ?? this.lineAmplitude,
      phaseSpeed: phaseSpeed ?? this.phaseSpeed,
      transitionEnabled: transitionEnabled ?? this.transitionEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is M3ESeekbarDecoration &&
        other.handleShape == handleShape &&
        other.colors == colors &&
        other.haptic == haptic &&
        other.hapticConfig == hapticConfig &&
        other.trackHeight == trackHeight &&
        other.trackCornerRadius == trackCornerRadius &&
        other.handleWidth == handleWidth &&
        other.handleHeight == handleHeight &&
        other.handleRadius == handleRadius &&
        other.waveLength == waveLength &&
        other.lineAmplitude == lineAmplitude &&
        other.phaseSpeed == phaseSpeed &&
        other.transitionEnabled == transitionEnabled;
  }

  @override
  int get hashCode => Object.hash(
    handleShape,
    colors,
    haptic,
    hapticConfig,
    trackHeight,
    trackCornerRadius,
    handleWidth,
    handleHeight,
    handleRadius,
    waveLength,
    lineAmplitude,
    phaseSpeed,
    transitionEnabled,
  );
}
