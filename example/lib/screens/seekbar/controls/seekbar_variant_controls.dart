// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/seekbar_models.dart';

class SeekbarVariantControls extends StatelessWidget {
  const SeekbarVariantControls({
    super.key,
    required this.variant,
    required this.onVariantChanged,
    required this.preset,
    required this.onPresetSelected,
    required this.enabled,
    required this.onEnabledChanged,
  });

  final SeekbarVariant variant;
  final ValueChanged<SeekbarVariant> onVariantChanged;
  final SeekbarPreset preset;
  final ValueChanged<SeekbarPreset> onPresetSelected;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Seekbar Architecture & Presets',
          subtitle:
              'Choose between AOSP Squiggly Waveform and Standard M3E Seekbar',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: variant.index,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onVariantChanged(SeekbarVariant.values[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('AOSP Squiggly Wave'),
                  icon: Icon(Icons.waves_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Standard M3E'),
                  icon: Icon(Icons.linear_scale_rounded),
                ),
              ],
            ),
            const Divider(height: 20),
            const Text(
              'Interactive Presets',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: preset.index,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onPresetSelected(SeekbarPreset.values[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('AOSP Wave'),
                  icon: Icon(Icons.play_circle_filled_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Buffered Stream'),
                  icon: Icon(Icons.cloud_download_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Mixer Channel'),
                  icon: Icon(Icons.equalizer_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Minimal Pill'),
                  icon: Icon(Icons.linear_scale_rounded),
                ),
              ],
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Seekbar Enabled',
                  subtitle: 'Enables or disables pointer and touch interaction',
                  value: enabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
