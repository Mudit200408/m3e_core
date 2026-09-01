// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/slider_models.dart';

class SliderCodeSnippets {
  static String _number(double value) => value.toStringAsFixed(2);

  static String _colorLiteral(Color color) =>
      'Color(0x${color.toARGB32().toRadixString(16).padLeft(8, '0')})';

  static String generate({
    required SliderKind kind,
    required SliderMode mode,
    required double value,
    required RangeValues range,
    required double min,
    required double max,
    required int divisions,
    required bool enabled,
    required bool autofocus,
    required Axis orientation,
    required M3EExampleMotionPreset motionPreset,
    required double motionStiffness,
    required double motionDamping,
    required bool showLabel,
    required Widget? icon,
    required bool trailingIcon,
    required double iconSize,
    required M3EHapticFeedback haptic,
    required double trackHeight,
    required double trackCornerRadius,
    required double thumbWidth,
    required double thumbHeight,
    required Color trackIconActiveColor,
    required Color trackIconInactiveColor,
    required M3ESliderColors colors,
    required bool continuousDrag,
    required double dragThreshold,
    required bool lowerBookend,
    required bool upperBookend,
    required double lowerThreshold,
    required double upperThreshold,
    required double minScale,
    required double maxScale,
    required double velocityBump,
    required double maxVelocity,
    required double intervalMs,
  }) {
    final b = StringBuffer();
    final isRange = kind == SliderKind.range;
    b.writeln(isRange ? 'M3ERangeSlider(' : 'M3ESlider(');
    b.writeln(
      isRange
          ? '  value: RangeValues(${_number(range.start)}, ${_number(range.end)}),'
          : '  value: ${_number(value)},',
    );
    b.writeln('  min: ${_number(min)},');
    b.writeln('  max: ${_number(max)},');
    if (mode == SliderMode.discrete) b.writeln('  divisions: $divisions,');
    if (!enabled) b.writeln('  enabled: false,');
    if (autofocus) b.writeln('  autofocus: true,');
    if (orientation == Axis.vertical) {
      b.writeln('  orientation: Axis.vertical,');
    }
    if (!isRange) {
      if (motionPreset == M3EExampleMotionPreset.custom) {
        b.writeln(
          '  motion: M3EMotion.custom(stiffness: ${_number(motionStiffness)}, damping: ${_number(motionDamping)}),',
        );
      } else {
        b.writeln('  motion: M3EMotion.${motionPreset.name},');
      }
    }
    if (showLabel) b.writeln("  label: '${isRange ? 'Range' : 'Value'}',");
    if (!isRange && icon != null) {
      b.writeln('  icon: const Icon(Icons.volume_up_rounded),');
      if (!trailingIcon) b.writeln('  trailingIcon: false,');
      if (iconSize != 24) b.writeln('  iconSize: ${_number(iconSize)},');
    }
    if (isRange) {
      b.writeln('  onChanged: (values) => setState(() => range = values),');
      b.writeln(
        "  onChangeStart: (values) => debugPrint('started: \$values'),",
      );
      b.writeln("  onChangeEnd: (values) => debugPrint('ended: \$values'),");
    } else {
      b.writeln('  onChanged: (value) => setState(() => value = value),');
      b.writeln("  onChangeStart: (value) => debugPrint('started: \$value'),");
      b.writeln("  onChangeEnd: (value) => debugPrint('ended: \$value'),");
    }
    b.writeln('  decoration: M3ESliderDecoration(');
    b.writeln('    haptic: M3EHapticFeedback.${haptic.name},');
    b.writeln('    trackHeight: ${_number(trackHeight)},');
    b.writeln('    trackCornerRadius: ${_number(trackCornerRadius)},');
    b.writeln('    thumbWidth: ${_number(thumbWidth)},');
    b.writeln('    thumbHeight: ${_number(thumbHeight)},');
    b.writeln(
      '    trackIconActiveColor: ${_colorLiteral(trackIconActiveColor)},',
    );
    b.writeln(
      '    trackIconInactiveColor: ${_colorLiteral(trackIconInactiveColor)},',
    );
    b.writeln('    colors: M3ESliderColors(');
    b.writeln('      thumbColor: ${_colorLiteral(colors.thumbColor)},');
    b.writeln(
      '      disabledThumbColor: ${_colorLiteral(colors.disabledThumbColor)},',
    );
    b.writeln(
      '      activeTrackColor: ${_colorLiteral(colors.activeTrackColor)},',
    );
    b.writeln(
      '      inactiveTrackColor: ${_colorLiteral(colors.inactiveTrackColor)},',
    );
    b.writeln(
      '      disabledActiveTrackColor: ${_colorLiteral(colors.disabledActiveTrackColor)},',
    );
    b.writeln(
      '      disabledInactiveTrackColor: ${_colorLiteral(colors.disabledInactiveTrackColor)},',
    );
    b.writeln(
      '      activeTickColor: ${_colorLiteral(colors.activeTickColor)},',
    );
    b.writeln(
      '      inactiveTickColor: ${_colorLiteral(colors.inactiveTickColor)},',
    );
    b.writeln(
      '      disabledActiveTickColor: ${_colorLiteral(colors.disabledActiveTickColor)},',
    );
    b.writeln(
      '      disabledInactiveTickColor: ${_colorLiteral(colors.disabledInactiveTickColor)},',
    );
    b.writeln('    ),');
    b.writeln('    hapticConfig: M3EHapticConfig(');
    b.writeln('      enableContinuousDrag: $continuousDrag,');
    b.writeln(
      '      deltaProgressForDragThreshold: ${_number(dragThreshold)},',
    );
    b.writeln('      vibrateOnLowerBookend: $lowerBookend,');
    b.writeln('      vibrateOnUpperBookend: $upperBookend,');
    b.writeln('      lowerBookendThreshold: ${_number(lowerThreshold)},');
    b.writeln('      upperBookendThreshold: ${_number(upperThreshold)},');
    b.writeln('      progressBasedDragMinScale: ${_number(minScale)},');
    b.writeln('      progressBasedDragMaxScale: ${_number(maxScale)},');
    b.writeln('      additionalVelocityMaxBump: ${_number(velocityBump)},');
    b.writeln('      maxVelocityToScale: ${_number(maxVelocity)},');
    b.writeln(
      '      minimumDragInterval: Duration(milliseconds: ${intervalMs.round()}),',
    );
    b.writeln('    ),');
    b.writeln('  ),');
    b.write(');');
    return b.toString();
  }
}
