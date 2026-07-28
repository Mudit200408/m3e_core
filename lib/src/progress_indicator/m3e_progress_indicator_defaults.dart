// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';

/// Default styling values and constraints for M3E progress indicators.
class M3EProgressIndicatorDefaults {
  M3EProgressIndicatorDefaults._();

  /// Default active color for the progress bar.
  static Color activeColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// Default track color behind the progress bar.
  static Color trackColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer;

  // ── Linear Progress Defaults ──

  /// Default stroke width for standard linear indicators.
  static const double linearStrokeWidth = 4.0;

  /// Default stroke width for standard linear track.
  static const double linearTrackStrokeWidth = 4.0;

  /// Default gap size between active indicator and track for linear.
  static const double linearIndicatorTrackGapSize = 4.0;

  /// Default size of the stop indicator at the end of the linear track.
  static const double linearTrackStopIndicatorSize = 4.0;

  /// Default wavelength of a determinate linear progress indicator wave.
  static const double linearDeterminateWavelength = 20.0;

  /// Default wavelength of an indeterminate linear progress indicator wave.
  static const double linearIndeterminateWavelength = 20.0;

  /// Default speed of a linear progress indicator wave.
  static const double linearWaveSpeed = 20.0;

  /// Default container height of the linear wavy progress indicator.
  static const double linearContainerHeight = 10.0;

  // ── Circular Progress Defaults ──

  /// Default stroke width for standard circular indicators.
  static const double circularStrokeWidth = 4.0;

  /// Default stroke width for standard circular track.
  static const double circularTrackStrokeWidth = 4.0;

  /// Default gap size between active indicator and track for circular.
  static const double circularIndicatorTrackGapSize = 4.0;

  /// Default wavelength of circular progress wave.
  static const double circularWavelength = 20.0;

  /// Default speed of circular progress wave.
  static const double circularWaveSpeed = 20.0;

  /// Default container size of the circular progress indicator.
  static const double circularContainerSize = 48.0;

  // ── Animation Spec Defaults ──

  /// Default duration for progress updates transition.
  static const Duration progressAnimationDuration = Duration(milliseconds: 300);

  /// Amplitude decay function for determinate progress, matching Jetpack Compose.
  /// Sets amplitude to 0 at <= 10% and >= 95% of progress, and 1 in between.
  static double indicatorAmplitude(double progress) {
    if (progress <= 0.1 || progress >= 0.95) {
      return 0.0;
    } else {
      return 1.0;
    }
  }
}
