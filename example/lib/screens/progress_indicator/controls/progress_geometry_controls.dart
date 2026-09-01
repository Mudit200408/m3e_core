// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/progress_models.dart';

class ProgressGeometryControls extends StatelessWidget {
  const ProgressGeometryControls({
    super.key,
    required this.type,
    required this.size,
    required this.onSizeChanged,
    required this.width,
    required this.onWidthChanged,
    required this.minHeight,
    required this.onMinHeightChanged,
    required this.height,
    required this.onHeightChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.trackStrokeWidth,
    required this.onTrackStrokeWidthChanged,
    required this.strokeCap,
    required this.onStrokeCapChanged,
    required this.gapSize,
    required this.onGapSizeChanged,
    required this.stopSize,
    required this.onStopSizeChanged,
    required this.wavelength,
    required this.onWavelengthChanged,
    required this.waveSpeed,
    required this.onWaveSpeedChanged,
    required this.amplitudeMode,
    required this.onAmplitudeModeChanged,
  });

  final ProgressType type;
  final double size;
  final ValueChanged<double> onSizeChanged;
  final double width;
  final ValueChanged<double> onWidthChanged;
  final double minHeight;
  final ValueChanged<double> onMinHeightChanged;
  final double height;
  final ValueChanged<double> onHeightChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final double trackStrokeWidth;
  final ValueChanged<double> onTrackStrokeWidthChanged;
  final StrokeCap strokeCap;
  final ValueChanged<StrokeCap> onStrokeCapChanged;
  final double gapSize;
  final ValueChanged<double> onGapSizeChanged;
  final double stopSize;
  final ValueChanged<double> onStopSizeChanged;
  final double wavelength;
  final ValueChanged<double> onWavelengthChanged;
  final double waveSpeed;
  final ValueChanged<double> onWaveSpeedChanged;
  final ProgressAmplitudeMode amplitudeMode;
  final ValueChanged<ProgressAmplitudeMode> onAmplitudeModeChanged;

  String _number(double val) => val.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Geometry & Motion',
          icon: Icons.straighten_rounded,
        ),
        ControlCard(
          children: [
            if (type == ProgressType.circular ||
                type == ProgressType.circularWavy)
              M3ESliderRow(
                label: 'Indicator size',
                value: size,
                min: 24,
                max: 140,
                divisions: 58,
                format: (value) => value.round().toString(),
                onChanged: onSizeChanged,
              ),
            if (type == ProgressType.linear || type == ProgressType.linearWavy)
              M3ESliderRow(
                label: 'Width',
                value: width,
                min: 120,
                max: 420,
                divisions: 60,
                format: (value) => value.round().toString(),
                onChanged: onWidthChanged,
              ),
            if (type == ProgressType.linear)
              M3ESliderRow(
                label: 'Min height',
                value: minHeight,
                min: 2,
                max: 32,
                divisions: 30,
                format: (value) => value.round().toString(),
                onChanged: onMinHeightChanged,
              ),
            if (type == ProgressType.linearWavy)
              M3ESliderRow(
                label: 'Height',
                value: height,
                min: 12,
                max: 80,
                divisions: 34,
                format: (value) => value.round().toString(),
                onChanged: onHeightChanged,
              ),
            if (type == ProgressType.circular ||
                type == ProgressType.circularWavy ||
                type == ProgressType.linearWavy)
              M3ESliderRow(
                label: 'Stroke width',
                value: strokeWidth,
                min: 1,
                max: 20,
                divisions: 38,
                format: _number,
                onChanged: onStrokeWidthChanged,
              ),
            if (type == ProgressType.circularWavy ||
                type == ProgressType.linearWavy)
              M3ESliderRow(
                label: 'Track stroke width',
                value: trackStrokeWidth,
                min: 1,
                max: 20,
                divisions: 38,
                format: _number,
                onChanged: onTrackStrokeWidthChanged,
              ),
            if (type == ProgressType.linear || type == ProgressType.circular)
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                selectedIndex: strokeCap.index,
                onSelectedIndexChanged: (index) {
                  if (index != null) {
                    onStrokeCapChanged(StrokeCap.values[index]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Butt')),
                  M3EToggleButtonGroupAction(label: Text('Round')),
                  M3EToggleButtonGroupAction(label: Text('Square')),
                ],
              ),
            M3ESliderRow(
              label: 'Gap size',
              value: gapSize,
              min: 0,
              max: 20,
              divisions: 20,
              format: _number,
              onChanged: onGapSizeChanged,
            ),
            if (type == ProgressType.linear)
              M3ESliderRow(
                label: 'Stop size',
                value: stopSize,
                min: 0,
                max: 20,
                divisions: 20,
                format: _number,
                onChanged: onStopSizeChanged,
              ),
            if (type == ProgressType.linearWavy ||
                type == ProgressType.circularWavy) ...[
              M3ESliderRow(
                label: 'Wavelength',
                value: wavelength,
                min: 4,
                max: 80,
                divisions: 38,
                format: _number,
                onChanged: onWavelengthChanged,
              ),
              M3ESliderRow(
                label: 'Wave speed',
                value: waveSpeed,
                min: 0,
                max: 100,
                divisions: 50,
                format: _number,
                onChanged: onWaveSpeedChanged,
              ),
              Text(
                'Amplitude function',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              M3EDropdownMenu<ProgressAmplitudeMode>(
                singleSelect: true,
                items: [
                  for (final mode in ProgressAmplitudeMode.values)
                    M3EDropdownItem(
                      value: mode,
                      label: switch (mode) {
                        ProgressAmplitudeMode.defaultAmplitude => 'Default',
                        ProgressAmplitudeMode.constant => 'Constant (0.75)',
                        ProgressAmplitudeMode.triangular => 'Triangular',
                      },
                      selected: mode == amplitudeMode,
                    ),
                ],
                fieldStyle: const M3EDropdownFieldStyle(
                  hintText: 'Amplitude function',
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                onSelectionChanged: (items) {
                  if (items.isEmpty || items.first.value == amplitudeMode) {
                    return;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onAmplitudeModeChanged(items.first.value);
                  });
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
