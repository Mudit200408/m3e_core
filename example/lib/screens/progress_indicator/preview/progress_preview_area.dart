// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/progress_models.dart';

class ProgressPreviewArea extends StatelessWidget {
  const ProgressPreviewArea({
    super.key,
    required this.type,
    required this.indeterminate,
    required this.progress,
    required this.customActiveColor,
    required this.customTrackColor,
    required this.useValueColor,
    required this.activeColor,
    required this.trackColor,
    required this.valueColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.strokeCap,
    required this.gapSize,
    required this.stopSize,
    required this.size,
    required this.minHeight,
    required this.width,
    required this.height,
    required this.wavelength,
    required this.waveSpeed,
    required this.amplitude,
  });

  final ProgressType type;
  final bool indeterminate;
  final double progress;
  final bool customActiveColor;
  final bool customTrackColor;
  final bool useValueColor;
  final Color activeColor;
  final Color trackColor;
  final Color valueColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final StrokeCap strokeCap;
  final double gapSize;
  final double stopSize;
  final double size;
  final double minHeight;
  final double width;
  final double height;
  final double wavelength;
  final double waveSpeed;
  final double Function(double)? amplitude;

  @override
  Widget build(BuildContext context) {
    final value = indeterminate ? null : progress;
    final actColor = useValueColor
        ? null
        : (customActiveColor ? activeColor : null);
    final valColor = useValueColor
        ? AlwaysStoppedAnimation<Color?>(valueColor)
        : null;
    final backgroundColor = customTrackColor ? trackColor : null;

    switch (type) {
      case ProgressType.linear:
        return M3ELinearProgressIndicator(
          key: const ValueKey('linear_progress_preview'),
          value: value,
          color: actColor,
          valueColor: valColor,
          backgroundColor: backgroundColor,
          minHeight: minHeight,
          strokeCap: strokeCap,
          gapSize: gapSize,
          stopSize: stopSize,
          width: width,
        );
      case ProgressType.circular:
        return M3ECircularProgressIndicator(
          key: const ValueKey('circular_progress_preview'),
          value: value,
          color: actColor,
          valueColor: valColor,
          backgroundColor: backgroundColor,
          strokeWidth: strokeWidth,
          strokeCap: strokeCap,
          gapSize: gapSize,
          size: size,
        );
      case ProgressType.linearWavy:
        return SizedBox(
          key: const ValueKey('linear_wavy_progress_preview'),
          width: width,
          child: M3ELinearWavyProgressIndicator(
            value: value,
            color: actColor,
            valueColor: valColor,
            backgroundColor: backgroundColor,
            strokeWidth: strokeWidth,
            trackStrokeWidth: trackStrokeWidth,
            gapSize: gapSize,
            stopSize: stopSize,
            wavelength: wavelength,
            waveSpeed: waveSpeed,
            height: height,
            width: width,
            amplitude: amplitude,
          ),
        );
      case ProgressType.circularWavy:
        return M3ECircularWavyProgressIndicator(
          key: const ValueKey('circular_wavy_progress_preview'),
          value: value,
          color: actColor,
          valueColor: valColor,
          backgroundColor: backgroundColor,
          strokeWidth: strokeWidth,
          trackStrokeWidth: trackStrokeWidth,
          gapSize: gapSize,
          wavelength: wavelength,
          waveSpeed: waveSpeed,
          size: size,
          amplitude: amplitude,
        );
    }
  }
}
