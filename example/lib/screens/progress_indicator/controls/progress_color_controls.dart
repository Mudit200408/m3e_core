// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class ProgressColorControls extends StatelessWidget {
  const ProgressColorControls({
    super.key,
    required this.indeterminate,
    required this.progress,
    required this.onProgressChanged,
    required this.useValueColor,
    required this.onUseValueColorChanged,
    required this.valueColor,
    required this.onValueColorChanged,
    required this.customActiveColor,
    required this.onCustomActiveColorChanged,
    required this.activeColor,
    required this.onActiveColorChanged,
    required this.customTrackColor,
    required this.onCustomTrackColorChanged,
    required this.trackColor,
    required this.onTrackColorChanged,
  });

  final bool indeterminate;
  final double progress;
  final ValueChanged<double> onProgressChanged;
  final bool useValueColor;
  final ValueChanged<bool> onUseValueColorChanged;
  final Color valueColor;
  final ValueChanged<Color> onValueColorChanged;
  final bool customActiveColor;
  final ValueChanged<bool> onCustomActiveColorChanged;
  final Color activeColor;
  final ValueChanged<Color> onActiveColorChanged;
  final bool customTrackColor;
  final ValueChanged<bool> onCustomTrackColorChanged;
  final Color trackColor;
  final ValueChanged<Color> onTrackColorChanged;

  Widget _colorControl(
    String label,
    Color color,
    ValueChanged<Color> onChanged,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        ColorDotPicker(
          selectedColor: color,
          onColorSelected: onChanged,
          size: 26,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Progress & Colors',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            if (!indeterminate)
              M3ESliderRow(
                label: 'Progress value',
                value: progress,
                min: 0,
                max: 1,
                divisions: 20,
                format: (value) => '${(value * 100).round()}%',
                onChanged: onProgressChanged,
              ),
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use valueColor',
                  subtitle: 'Demonstrates Animation<Color?> precedence.',
                  value: useValueColor,
                  onChanged: onUseValueColorChanged,
                ),
              ],
            ),
            if (useValueColor) ...[
              const SizedBox(height: 8),
              _colorControl('Value color', valueColor, onValueColorChanged),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom active color',
                  value: customActiveColor,
                  onChanged: onCustomActiveColorChanged,
                ),
              ],
            ),
            if (customActiveColor && !useValueColor) ...[
              const SizedBox(height: 8),
              _colorControl('Active color', activeColor, onActiveColorChanged),
            ],
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom background color',
                  value: customTrackColor,
                  onChanged: onCustomTrackColorChanged,
                ),
              ],
            ),
            if (customTrackColor) ...[
              const SizedBox(height: 8),
              _colorControl(
                'Background color',
                trackColor,
                onTrackColorChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
