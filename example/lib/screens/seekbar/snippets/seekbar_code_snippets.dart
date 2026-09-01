// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/seekbar_models.dart';

class SeekbarCodeSnippets {
  static String formatTime(double frac) {
    final totalSeconds = (frac * 215).toInt();
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  static String generate({
    required SeekbarVariant variant,
    required double value,
    required bool isPlaying,
    required bool enableBuffered,
    required double bufferedValue,
    required bool enabled,
    required double waveLength,
    required double lineAmplitude,
    required double phaseSpeed,
    required double strokeWidth,
    required bool transitionEnabled,
    required bool useCustomColors,
    required M3ESeekbarHandleShape handleShape,
    required double handleWidth,
    required double handleHeight,
    required double handleRadius,
    required M3EHapticFeedback haptic,
    required bool showLabel,
    required Axis orientation,
    required double trackHeight,
    required double trackCornerRadius,
  }) {
    final buf = StringBuffer();

    if (variant == SeekbarVariant.wavy) {
      buf.writeln("// Android 13+ AOSP Squiggly Wavy Seekbar");
      buf.writeln("M3EWavySeekbar(");
      buf.writeln("  value: ${value.toStringAsFixed(2)},");
      buf.writeln("  isPlaying: $isPlaying,");
      if (enableBuffered) {
        buf.writeln(
          "  secondaryTrackValue: ${bufferedValue.toStringAsFixed(2)},",
        );
      }
      if (!enabled) buf.writeln("  enabled: false,");
      if (waveLength != 20.0) {
        buf.writeln("  waveLength: ${waveLength.toStringAsFixed(1)},");
      }
      if (lineAmplitude != 3.0) {
        buf.writeln("  lineAmplitude: ${lineAmplitude.toStringAsFixed(1)},");
      }
      if (phaseSpeed != 16.0) {
        buf.writeln("  phaseSpeed: ${phaseSpeed.toStringAsFixed(1)},");
      }
      if (strokeWidth != 4.0) {
        buf.writeln("  strokeWidth: ${strokeWidth.toStringAsFixed(1)},");
      }
      if (!transitionEnabled) {
        buf.writeln("  transitionEnabled: false,");
      }
      if (trackCornerRadius != 3.0) {
        buf.writeln(
          "  trackCornerRadius: ${trackCornerRadius.toStringAsFixed(1)},",
        );
      }
      if (useCustomColors) {
        buf.writeln("  activeColor: Colors.teal,");
        buf.writeln("  inactiveColor: Colors.teal.withValues(alpha: 0.24),");
        if (enableBuffered) {
          buf.writeln(
            "  secondaryActiveColor: Colors.teal.withValues(alpha: 0.50),",
          );
        }
        buf.writeln("  thumbColor: Colors.teal,");
      }
      buf.writeln("  onChanged: (v) => setState(() => value = v),");
      buf.writeln("  decoration: const M3ESeekbarDecoration(");
      buf.writeln(
        "    handleShape: M3ESeekbarHandleShape.${handleShape.name},",
      );
      if (handleShape == M3ESeekbarHandleShape.rectangle) {
        buf.writeln("    handleWidth: ${handleWidth.toStringAsFixed(1)},");
        buf.writeln("    handleHeight: ${handleHeight.toStringAsFixed(1)},");
      } else {
        buf.writeln("    handleRadius: ${handleRadius.toStringAsFixed(1)},");
      }
      if (haptic != M3EHapticFeedback.none) {
        buf.writeln("    haptic: M3EHapticFeedback.${haptic.name},");
      }
      buf.writeln("  ),");
      buf.write(")");
      return buf.toString();
    }

    buf.writeln("// Material 3 Expressive Standard Seekbar");
    buf.writeln("M3ESeekbar(");
    buf.writeln("  value: ${value.toStringAsFixed(2)},");
    if (enableBuffered) {
      buf.writeln(
        "  secondaryTrackValue: ${bufferedValue.toStringAsFixed(2)},",
      );
    }
    if (!enabled) buf.writeln("  enabled: false,");
    if (showLabel) {
      buf.writeln("  label: '${formatTime(value)}',");
    }
    if (orientation == Axis.vertical) {
      buf.writeln("  orientation: Axis.vertical,");
    }
    if (useCustomColors) {
      buf.writeln("  activeColor: Colors.teal,");
      buf.writeln("  inactiveColor: Colors.teal.withValues(alpha: 0.24),");
      if (enableBuffered) {
        buf.writeln(
          "  secondaryActiveColor: Colors.teal.withValues(alpha: 0.50),",
        );
      }
      buf.writeln("  thumbColor: Colors.teal,");
    }
    buf.writeln("  onChanged: (v) => setState(() => value = v),");
    buf.writeln("  decoration: const M3ESeekbarDecoration(");
    buf.writeln("    trackHeight: ${trackHeight.toStringAsFixed(1)},");
    buf.writeln(
      "    trackCornerRadius: ${trackCornerRadius.toStringAsFixed(1)},",
    );
    buf.writeln("    handleShape: M3ESeekbarHandleShape.${handleShape.name},");
    if (handleShape == M3ESeekbarHandleShape.rectangle) {
      buf.writeln("    handleWidth: ${handleWidth.toStringAsFixed(1)},");
      buf.writeln("    handleHeight: ${handleHeight.toStringAsFixed(1)},");
    } else {
      buf.writeln("    handleRadius: ${handleRadius.toStringAsFixed(1)},");
    }
    if (haptic != M3EHapticFeedback.none) {
      buf.writeln("    haptic: M3EHapticFeedback.${haptic.name},");
    }
    buf.writeln("  ),");
    buf.write(")");
    return buf.toString();
  }
}
