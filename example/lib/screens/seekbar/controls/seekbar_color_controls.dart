// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class SeekbarColorControls extends StatelessWidget {
  const SeekbarColorControls({
    super.key,
    required this.useCustomColors,
    required this.onUseCustomColorsChanged,
    required this.activeColor,
    required this.onColorSelected,
    required this.haptic,
    required this.onHapticChanged,
  });

  final bool useCustomColors;
  final ValueChanged<bool> onUseCustomColorsChanged;
  final Color activeColor;
  final ValueChanged<Color> onColorSelected;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Color Palettes & Haptic Feedback',
          subtitle:
              'Customize active, inactive, buffered tracks and haptic impact',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Color Overrides',
                  subtitle:
                      'Applies custom active track, buffered track, and thumb colors',
                  value: useCustomColors,
                  onChanged: onUseCustomColorsChanged,
                ),
              ],
            ),
            if (useCustomColors) ...[
              const Divider(height: 16),
              const Text(
                'Active Track & Thumb Accent',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: activeColor,
                onColorSelected: onColorSelected,
              ),
            ],
            const Divider(height: 16),
            const Text(
              'Haptic Feedback Preset (M3EHapticFeedback)',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('seekbar_haptic_$haptic'),
              singleSelect: true,
              searchEnabled: false,
              items: const [
                M3EDropdownItem(label: 'NONE', value: M3EHapticFeedback.none),
                M3EDropdownItem(
                  label: 'LIGHT IMPACT',
                  value: M3EHapticFeedback.light,
                ),
                M3EDropdownItem(
                  label: 'MEDIUM IMPACT',
                  value: M3EHapticFeedback.medium,
                ),
                M3EDropdownItem(
                  label: 'HEAVY IMPACT',
                  value: M3EHapticFeedback.heavy,
                ),
              ],
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Haptic Preset',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != haptic) {
                  onHapticChanged(selectedItems.first.value);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
