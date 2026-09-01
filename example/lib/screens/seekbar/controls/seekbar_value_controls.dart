// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/seekbar_models.dart';

class SeekbarValueControls extends StatelessWidget {
  const SeekbarValueControls({
    super.key,
    required this.value,
    required this.onValueChanged,
    required this.min,
    required this.max,
    required this.enableBuffered,
    required this.onEnableBufferedChanged,
    required this.bufferedValue,
    required this.onBufferedValueChanged,
    required this.variant,
    required this.showLabel,
    required this.onShowLabelChanged,
    required this.orientation,
    required this.onOrientationChanged,
  });

  final double value;
  final ValueChanged<double> onValueChanged;
  final double min;
  final double max;
  final bool enableBuffered;
  final ValueChanged<bool> onEnableBufferedChanged;
  final double bufferedValue;
  final ValueChanged<double> onBufferedValueChanged;
  final SeekbarVariant variant;
  final bool showLabel;
  final ValueChanged<bool> onShowLabelChanged;
  final Axis orientation;
  final ValueChanged<Axis> onOrientationChanged;

  static const _orientations = [Axis.horizontal, Axis.vertical];

  String _formatTime(double frac) {
    final totalSeconds = (frac * 215).toInt();
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Values, Stream Buffering & Layout',
          subtitle:
              'Progress scrubbing, secondary buffer track, and orientation',
          icon: Icons.track_changes_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Active Progress Value',
              value: value,
              min: min,
              max: max,
              format: (v) => '${(v * 100).toInt()}% (${_formatTime(v)})',
              onChanged: onValueChanged,
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Secondary (Buffered) Track',
                  subtitle:
                      'Renders buffered stream progress behind active playback',
                  value: enableBuffered,
                  onChanged: onEnableBufferedChanged,
                ),
              ],
            ),
            if (enableBuffered) ...[
              const SizedBox(height: 6),
              M3ESliderRow(
                label: 'Buffered Progress',
                value: bufferedValue,
                min: min,
                max: max,
                divisions: 100,
                format: (v) => '${(v * 100).toInt()}%',
                onChanged: onBufferedValueChanged,
              ),
            ],
            if (variant == SeekbarVariant.standard) ...[
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Show Scrubbing Value Pill / Label',
                    subtitle:
                        'Displays dynamic timecode label above the handle while dragging',
                    value: showLabel,
                    onChanged: onShowLabelChanged,
                  ),
                ],
              ),
              const Divider(height: 16),
              const Text(
                'Orientation (Axis)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: _orientations.indexOf(orientation),
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onOrientationChanged(_orientations[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(
                    label: Text('Horizontal (Default)'),
                  ),
                  M3EToggleButtonGroupAction(label: Text('Vertical (Mixer)')),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
