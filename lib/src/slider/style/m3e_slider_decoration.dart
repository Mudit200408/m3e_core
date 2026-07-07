// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';
import '../../common/m3e_common.dart';
import '../m3e_slider_theme.dart';

/// Styling and haptic overrides for Material 3 Expressive sliders.
@immutable
class M3ESliderDecoration {
  /// Custom colors for the slider components.
  final M3ESliderColors? colors;

  /// Haptic feedback level to apply during slider interactions.
  final M3EHapticFeedback? haptic;

  /// Override for the track icon size.
  final double? trackIconSize;

  /// Override for the track icon color on the active track segment.
  final Color? trackIconActiveColor;

  /// Override for the track icon color on the inactive track segment.
  final Color? trackIconInactiveColor;

  /// Custom height of the slider track.
  final double? trackHeight;

  /// Custom corner radius of the slider track.
  final double? trackCornerRadius;

  /// Custom width of the slider thumb.
  final double? thumbWidth;

  /// Custom height of the slider thumb.
  final double? thumbHeight;

  const M3ESliderDecoration({
    this.colors,
    this.haptic = M3EHapticFeedback.none,
    this.trackIconSize,
    this.trackIconActiveColor,
    this.trackIconInactiveColor,
    this.trackHeight,
    this.trackCornerRadius,
    this.thumbWidth,
    this.thumbHeight,
  });

  /// Creates a copy of this decoration with the given fields replaced.
  M3ESliderDecoration copyWith({
    M3ESliderColors? colors,
    M3EHapticFeedback? haptic,
    double? trackIconSize,
    Color? trackIconActiveColor,
    Color? trackIconInactiveColor,
    double? trackHeight,
    double? trackCornerRadius,
    double? thumbWidth,
    double? thumbHeight,
  }) {
    return M3ESliderDecoration(
      colors: colors ?? this.colors,
      haptic: haptic ?? this.haptic,
      trackIconSize: trackIconSize ?? this.trackIconSize,
      trackIconActiveColor: trackIconActiveColor ?? this.trackIconActiveColor,
      trackIconInactiveColor:
          trackIconInactiveColor ?? this.trackIconInactiveColor,
      trackHeight: trackHeight ?? this.trackHeight,
      trackCornerRadius: trackCornerRadius ?? this.trackCornerRadius,
      thumbWidth: thumbWidth ?? this.thumbWidth,
      thumbHeight: thumbHeight ?? this.thumbHeight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESliderDecoration &&
          colors == other.colors &&
          haptic == other.haptic &&
          trackIconSize == other.trackIconSize &&
          trackIconActiveColor == other.trackIconActiveColor &&
          trackIconInactiveColor == other.trackIconInactiveColor &&
          trackHeight == other.trackHeight &&
          trackCornerRadius == other.trackCornerRadius &&
          thumbWidth == other.thumbWidth &&
          thumbHeight == other.thumbHeight;

  @override
  int get hashCode => Object.hash(
    colors,
    haptic,
    trackIconSize,
    trackIconActiveColor,
    trackIconInactiveColor,
    trackHeight,
    trackCornerRadius,
    thumbWidth,
    thumbHeight,
  );
}
