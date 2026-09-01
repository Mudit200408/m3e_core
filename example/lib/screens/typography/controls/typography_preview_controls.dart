// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/typography_models.dart';

class TypographyPreviewControls extends StatelessWidget {
  const TypographyPreviewControls({
    super.key,
    required this.previewMode,
    required this.onPreviewModeChanged,
    required this.font,
    required this.onFontChanged,
    required this.selectedPreset,
    required this.onPresetSelected,
    required this.isEmphasized,
    required this.onIsEmphasizedChanged,
    required this.rond,
    required this.onRondChanged,
    required this.applyBodyRond,
    required this.onApplyBodyRondChanged,
  });

  final TypographyPreviewMode previewMode;
  final ValueChanged<TypographyPreviewMode> onPreviewModeChanged;
  final TypographyFont font;
  final ValueChanged<TypographyFont> onFontChanged;
  final String selectedPreset;
  final ValueChanged<String> onPresetSelected;
  final bool isEmphasized;
  final ValueChanged<bool> onIsEmphasizedChanged;
  final double rond;
  final ValueChanged<double> onRondChanged;
  final bool applyBodyRond;
  final ValueChanged<bool> onApplyBodyRondChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Preview',
          icon: Icons.visibility_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: previewMode.index,
              onSelectedIndexChanged: (index) {
                if (index != null) {
                  onPreviewModeChanged(TypographyPreviewMode.values[index]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Custom text'),
                  icon: Icon(Icons.tune_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Type scale'),
                  icon: Icon(Icons.text_fields_rounded),
                ),
              ],
            ),
          ],
        ),
        const ControlSectionHeader(
          title: 'Font Family',
          icon: Icons.font_download_rounded,
        ),
        ControlCard(
          children: [
            M3EDropdownMenu<TypographyFont>(
              singleSelect: true,
              searchEnabled: false,
              items: [
                for (final f in TypographyFont.values)
                  M3EDropdownItem(
                    label: f.label,
                    value: f,
                    selected: f == font,
                  ),
              ],
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select font family',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != font) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onFontChanged(selectedItems.first.value);
                  });
                }
              },
            ),
          ],
        ),
        const ControlSectionHeader(
          title: 'Typography Presets',
          icon: Icons.text_fields_rounded,
        ),
        ControlCard(
          children: [
            M3EDropdownMenu<String>(
              singleSelect: true,
              searchEnabled: false,
              items: [
                for (final preset in const [
                  'Display Large',
                  'Headline Medium',
                  'Title Medium',
                  'Body Large',
                  'Label Large',
                ])
                  M3EDropdownItem(
                    label: preset,
                    value: preset,
                    selected: preset == selectedPreset,
                  ),
              ],
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select typography preset',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != selectedPreset) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onPresetSelected(selectedItems.first.value);
                  });
                }
              },
            ),
          ],
        ),
        const ControlSectionHeader(
          title: 'Type Scale',
          icon: Icons.format_size_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use M3E Emphasized Typography',
                  subtitle:
                      'Apply expressive weights, line heights, and variable font axes.',
                  value: isEmphasized,
                  onChanged: onIsEmphasizedChanged,
                ),
              ],
            ),
            if (isEmphasized) ...[
              const Divider(height: 20),
              M3ESliderRow(
                label: 'Type Scale Roundness (ROND)',
                value: rond,
                min: 0,
                max: 100,
                divisions: 10,
                format: (value) => value.toInt().toString(),
                onChanged: onRondChanged,
              ),
              const SizedBox(height: 8),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Apply ROND to Body & Labels',
                    value: applyBodyRond,
                    onChanged: onApplyBodyRondChanged,
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
