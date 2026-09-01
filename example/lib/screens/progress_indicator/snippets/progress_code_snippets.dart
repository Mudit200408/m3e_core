// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../models/progress_models.dart';

class ProgressCodeSnippets {
  static String _number(double value) => value.toStringAsFixed(2);

  static String _color(Color color) =>
      'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0')})';

  static String _cap(StrokeCap cap) => 'StrokeCap.${cap.name}';

  static String _constructorName(ProgressType type) {
    switch (type) {
      case ProgressType.linear:
        return 'M3ELinearProgressIndicator';
      case ProgressType.circular:
        return 'M3ECircularProgressIndicator';
      case ProgressType.linearWavy:
        return 'M3ELinearWavyProgressIndicator';
      case ProgressType.circularWavy:
        return 'M3ECircularWavyProgressIndicator';
    }
  }

  static String _amplitudeSnippet(ProgressAmplitudeMode mode) {
    switch (mode) {
      case ProgressAmplitudeMode.defaultAmplitude:
        return '';
      case ProgressAmplitudeMode.constant:
        return '  amplitude: (_) => 0.75,\n';
      case ProgressAmplitudeMode.triangular:
        return '  amplitude: (progress) => (progress * 2).clamp(0.0, 1.0),\n';
    }
  }

  static String generate({
    required ProgressType type,
    required bool indeterminate,
    required double progress,
    required bool useValueColor,
    required Color valueColor,
    required bool customActiveColor,
    required Color activeColor,
    required bool customTrackColor,
    required Color trackColor,
    required double width,
    required double size,
    required double minHeight,
    required StrokeCap strokeCap,
    required double gapSize,
    required double stopSize,
    required double strokeWidth,
    required double trackStrokeWidth,
    required double height,
    required double wavelength,
    required double waveSpeed,
    required ProgressAmplitudeMode amplitudeMode,
  }) {
    final b = StringBuffer();
    b.writeln('${_constructorName(type)}(');
    if (!indeterminate) b.writeln('  value: ${_number(progress)},');
    if (useValueColor) {
      b.writeln(
        '  valueColor: AlwaysStoppedAnimation<Color?>(${_color(valueColor)}),',
      );
    } else if (customActiveColor) {
      b.writeln('  color: ${_color(activeColor)},');
    }
    if (customTrackColor) {
      b.writeln('  backgroundColor: ${_color(trackColor)},');
    }
    if (type == ProgressType.linear || type == ProgressType.linearWavy) {
      b.writeln('  width: ${_number(width)},');
    }
    if (type == ProgressType.circular || type == ProgressType.circularWavy) {
      b.writeln('  size: ${_number(size)},');
    }
    switch (type) {
      case ProgressType.linear:
        b.writeln('  minHeight: ${_number(minHeight)},');
        b.writeln('  strokeCap: ${_cap(strokeCap)},');
        b.writeln('  gapSize: ${_number(gapSize)},');
        b.writeln('  stopSize: ${_number(stopSize)},');
      case ProgressType.circular:
        b.writeln('  strokeWidth: ${_number(strokeWidth)},');
        b.writeln('  strokeCap: ${_cap(strokeCap)},');
        b.writeln('  gapSize: ${_number(gapSize)},');
      case ProgressType.linearWavy:
        b.writeln('  height: ${_number(height)},');
        b.writeln('  strokeWidth: ${_number(strokeWidth)},');
        b.writeln('  trackStrokeWidth: ${_number(trackStrokeWidth)},');
        b.writeln('  gapSize: ${_number(gapSize)},');
        b.writeln('  stopSize: ${_number(stopSize)},');
        b.writeln('  wavelength: ${_number(wavelength)},');
        b.writeln('  waveSpeed: ${_number(waveSpeed)},');
        b.write(_amplitudeSnippet(amplitudeMode));
      case ProgressType.circularWavy:
        b.writeln('  strokeWidth: ${_number(strokeWidth)},');
        b.writeln('  trackStrokeWidth: ${_number(trackStrokeWidth)},');
        b.writeln('  gapSize: ${_number(gapSize)},');
        b.writeln('  wavelength: ${_number(wavelength)},');
        b.writeln('  waveSpeed: ${_number(waveSpeed)},');
        b.write(_amplitudeSnippet(amplitudeMode));
    }
    b.write(');');
    return b.toString();
  }
}
