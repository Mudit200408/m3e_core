// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'control_card.dart';
import 'm3e_slider_row.dart';
import 'motion_preset.dart';

/// Reusable control section for configuring an [M3EMotion] or [M3EExampleMotionPreset].
class MotionPresetControlCard extends StatelessWidget {
  const MotionPresetControlCard({
    super.key,
    this.title = 'Motion & Physics (Motor Spring)',
    this.subtitle =
        'Expressive spatial physics tuned for responsive interactive feel',
    this.presetLabel = 'Motion Preset',
    this.icon = Icons.animation_rounded,
    required this.selectedPreset,
    required this.onPresetChanged,
    required this.stiffness,
    required this.onStiffnessChanged,
    required this.damping,
    required this.onDampingChanged,
    this.availablePresets,
    this.minStiffness = 50.0,
    this.maxStiffness = 1000.0,
    this.stiffnessDivisions = 38,
  });

  final String title;
  final String? subtitle;
  final String presetLabel;
  final IconData? icon;
  final M3EExampleMotionPreset selectedPreset;
  final ValueChanged<M3EExampleMotionPreset> onPresetChanged;
  final double stiffness;
  final ValueChanged<double> onStiffnessChanged;
  final double damping;
  final ValueChanged<double> onDampingChanged;
  final List<M3EExampleMotionPreset>? availablePresets;
  final double minStiffness;
  final double maxStiffness;
  final int stiffnessDivisions;

  @override
  Widget build(BuildContext context) {
    final presets = availablePresets ?? M3EExampleMotionPreset.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ControlSectionHeader(title: title, subtitle: subtitle, icon: icon),
        ControlCard(
          children: [
            Text(
              presetLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EDropdownMenu<M3EExampleMotionPreset>(
              key: ValueKey(
                'motion_${title}_${presetLabel}_${selectedPreset.name}',
              ),
              singleSelect: true,
              searchEnabled: false,
              items: presets
                  .map(
                    (p) => M3EDropdownItem<M3EExampleMotionPreset>(
                      label: p.label,
                      value: p,
                      selected: p == selectedPreset,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Motion Preset',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != selectedPreset) {
                  onPresetChanged(items.first.value);
                }
              },
            ),
            if (selectedPreset == M3EExampleMotionPreset.custom) ...[
              const SizedBox(height: 12),
              M3ESliderRow(
                label: 'Stiffness',
                value: stiffness,
                min: minStiffness,
                max: maxStiffness,
                divisions: stiffnessDivisions,
                format: (v) => v.toStringAsFixed(0),
                onChanged: onStiffnessChanged,
              ),
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Damping',
                value: damping,
                min: 0.1,
                max: 1.0,
                divisions: 18,
                format: (v) => v.toStringAsFixed(2),
                onChanged: onDampingChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
