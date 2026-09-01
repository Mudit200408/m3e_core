// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/slider_models.dart';

class SliderVariantControls extends StatelessWidget {
  const SliderVariantControls({
    super.key,
    required this.aospVolumePreset,
    required this.onApplyAospVolumePreset,
    required this.kind,
    required this.onKindChanged,
    required this.mode,
    required this.onModeChanged,
    required this.min,
    required this.onMinChanged,
    required this.max,
    required this.onMaxChanged,
    required this.value,
    required this.onValueChanged,
    required this.range,
    required this.onRangeChanged,
    required this.divisions,
    required this.onDivisionsChanged,
  });

  final bool aospVolumePreset;
  final VoidCallback onApplyAospVolumePreset;
  final SliderKind kind;
  final ValueChanged<SliderKind> onKindChanged;
  final SliderMode mode;
  final ValueChanged<SliderMode> onModeChanged;
  final double min;
  final ValueChanged<double> onMinChanged;
  final double max;
  final ValueChanged<double> onMaxChanged;
  final double value;
  final ValueChanged<double> onValueChanged;
  final RangeValues range;
  final ValueChanged<RangeValues> onRangeChanged;
  final int divisions;
  final ValueChanged<int> onDivisionsChanged;

  String _number(double val) => val.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Variant & Value',
          subtitle: 'Switch between single-value and range sliders.',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            M3EButton.icon(
              onPressed: onApplyAospVolumePreset,
              icon: const Icon(Icons.volume_up_rounded),
              label: const Text('Use AOSP volume preset'),
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
            ),
            if (aospVolumePreset)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Previewing a thick in-track volume slider. Other controls remain editable.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              selectedIndex: kind.index,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onKindChanged(SliderKind.values[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Single'),
                  icon: Icon(Icons.linear_scale_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Range'),
                  icon: Icon(Icons.unfold_more_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              selectedIndex: mode.index,
              onSelectedIndexChanged: (i) {
                if (i != null) onModeChanged(SliderMode.values[i]);
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Continuous')),
                M3EToggleButtonGroupAction(label: Text('Discrete')),
              ],
            ),
            const SizedBox(height: 12),
            M3ESliderRow(
              label: 'Minimum',
              value: min,
              min: -100,
              max: 100,
              format: _number,
              onChanged: onMinChanged,
            ),
            M3ESliderRow(
              label: 'Maximum',
              value: max,
              min: min + .01,
              max: 100,
              format: _number,
              onChanged: onMaxChanged,
            ),
            M3ESliderRow(
              label: 'Single value',
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: mode == SliderMode.discrete ? divisions : null,
              format: _number,
              enabled: kind == SliderKind.single,
              onChanged: onValueChanged,
            ),
            if (kind == SliderKind.range) ...[
              M3ESliderRow(
                label: 'Range start',
                value: range.start.clamp(min, max),
                min: min,
                max: range.end,
                divisions: mode == SliderMode.discrete ? divisions : null,
                format: _number,
                onChanged: (v) => onRangeChanged(RangeValues(v, range.end)),
              ),
              M3ESliderRow(
                label: 'Range end',
                value: range.end.clamp(min, max),
                min: range.start,
                max: max,
                divisions: mode == SliderMode.discrete ? divisions : null,
                format: _number,
                onChanged: (v) => onRangeChanged(RangeValues(range.start, v)),
              ),
            ],
            if (mode == SliderMode.discrete)
              M3ESliderRow(
                label: 'Divisions',
                value: divisions.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                format: (v) => v.round().toString(),
                onChanged: (v) => onDivisionsChanged(v.round()),
              ),
          ],
        ),
      ],
    );
  }
}
