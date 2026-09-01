// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class SegmentedListSelectionControls extends StatelessWidget {
  const SegmentedListSelectionControls({
    super.key,
    required this.selectionMode,
    required this.onSelectionModeChanged,
    required this.selectionTrigger,
    required this.onSelectionTriggerChanged,
    required this.showSelectionCheckmark,
    required this.onShowSelectionCheckmarkChanged,
    required this.checkmarkAlignment,
    required this.onCheckmarkAlignmentChanged,
    required this.selectedRadius,
    required this.onSelectedRadiusChanged,
    required this.selectedElevation,
    required this.onSelectedElevationChanged,
    required this.useCustomSelectedColor,
    required this.onUseCustomSelectedColorChanged,
    required this.selectedColor,
    required this.onSelectedColorChanged,
    required this.useSelectedBorder,
    required this.onUseSelectedBorderChanged,
    required this.selectedBorderWidth,
    required this.onSelectedBorderWidthChanged,
    required this.selectedBorderColor,
    required this.onSelectedBorderColorChanged,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onInvertSelection,
    required this.onClearSelection,
  });

  final M3ESelectionMode selectionMode;
  final ValueChanged<M3ESelectionMode> onSelectionModeChanged;
  final M3ESelectionTrigger selectionTrigger;
  final ValueChanged<M3ESelectionTrigger> onSelectionTriggerChanged;
  final bool showSelectionCheckmark;
  final ValueChanged<bool> onShowSelectionCheckmarkChanged;
  final Alignment checkmarkAlignment;
  final ValueChanged<Alignment> onCheckmarkAlignmentChanged;
  final double selectedRadius;
  final ValueChanged<double> onSelectedRadiusChanged;
  final double selectedElevation;
  final ValueChanged<double> onSelectedElevationChanged;
  final bool useCustomSelectedColor;
  final ValueChanged<bool> onUseCustomSelectedColorChanged;
  final Color selectedColor;
  final ValueChanged<Color> onSelectedColorChanged;
  final bool useSelectedBorder;
  final ValueChanged<bool> onUseSelectedBorderChanged;
  final double selectedBorderWidth;
  final ValueChanged<double> onSelectedBorderWidthChanged;
  final Color selectedBorderColor;
  final ValueChanged<Color> onSelectedBorderColorChanged;
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onInvertSelection;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Selection & Checkmarks',
          icon: Icons.check_circle_outline_rounded,
        ),
        ControlCard(
          children: [
            const Text(
              'Selection Mode',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3ESelectionMode>(
              key: ValueKey('sel_mode_$selectionMode'),
              singleSelect: true,
              searchEnabled: false,
              items: M3ESelectionMode.values
                  .map(
                    (m) => M3EDropdownItem<M3ESelectionMode>(
                      label: m.name.toUpperCase(),
                      value: m,
                      selected: selectionMode == m,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Selection Mode',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != selectionMode) {
                  onSelectionModeChanged(selectedItems.first.value);
                }
              },
            ),
            if (selectionMode != M3ESelectionMode.none) ...[
              const SizedBox(height: 14),
              const Text(
                'Selection Trigger',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(height: 6),
              M3EDropdownMenu<M3ESelectionTrigger>(
                key: ValueKey('sel_trig_$selectionTrigger'),
                singleSelect: true,
                searchEnabled: false,
                items: M3ESelectionTrigger.values
                    .map(
                      (t) => M3EDropdownItem<M3ESelectionTrigger>(
                        label: t.name.toUpperCase(),
                        value: t,
                        selected: selectionTrigger == t,
                      ),
                    )
                    .toList(),
                fieldStyle: const M3EDropdownFieldStyle(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  hintText: 'Select Selection Trigger',
                ),
                dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
                onSelectionChanged: (selectedItems) {
                  if (selectedItems.isNotEmpty &&
                      selectedItems.first.value != selectionTrigger) {
                    onSelectionTriggerChanged(selectedItems.first.value);
                  }
                },
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Show Selection Checkmark',
                    subtitle: 'Animated checkmark indicator on selected items',
                    value: showSelectionCheckmark,
                    onChanged: onShowSelectionCheckmarkChanged,
                  ),
                ],
              ),
              if (showSelectionCheckmark) ...[
                const SizedBox(height: 8),
                const Text(
                  'Checkmark Alignment',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 6),
                M3EDropdownMenu<Alignment>(
                  key: ValueKey('align_$checkmarkAlignment'),
                  singleSelect: true,
                  searchEnabled: false,
                  items: [
                    M3EDropdownItem(
                      label: 'Center Right',
                      value: Alignment.centerRight,
                      selected: checkmarkAlignment == Alignment.centerRight,
                    ),
                    M3EDropdownItem(
                      label: 'Center Left',
                      value: Alignment.centerLeft,
                      selected: checkmarkAlignment == Alignment.centerLeft,
                    ),
                    M3EDropdownItem(
                      label: 'Top Right',
                      value: Alignment.topRight,
                      selected: checkmarkAlignment == Alignment.topRight,
                    ),
                    M3EDropdownItem(
                      label: 'Top Left',
                      value: Alignment.topLeft,
                      selected: checkmarkAlignment == Alignment.topLeft,
                    ),
                    M3EDropdownItem(
                      label: 'Bottom Right',
                      value: Alignment.bottomRight,
                      selected: checkmarkAlignment == Alignment.bottomRight,
                    ),
                    M3EDropdownItem(
                      label: 'Bottom Left',
                      value: Alignment.bottomLeft,
                      selected: checkmarkAlignment == Alignment.bottomLeft,
                    ),
                  ],
                  fieldStyle: const M3EDropdownFieldStyle(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    hintText: 'Select Alignment',
                  ),
                  dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
                  onSelectionChanged: (selectedItems) {
                    if (selectedItems.isNotEmpty &&
                        selectedItems.first.value != checkmarkAlignment) {
                      onCheckmarkAlignmentChanged(selectedItems.first.value);
                    }
                  },
                ),
              ],
              M3ESliderRow(
                label: 'Selected Corner Radius',
                value: selectedRadius,
                min: 0,
                max: 48,
                divisions: 48,
                format: (v) => v.toStringAsFixed(0),
                onChanged: onSelectedRadiusChanged,
              ),
              M3ESliderRow(
                label: 'Selected Elevation',
                value: selectedElevation,
                min: 0,
                max: 12,
                divisions: 12,
                format: (v) => v.toStringAsFixed(0),
                onChanged: onSelectedElevationChanged,
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Selected Color',
                    value: useCustomSelectedColor,
                    onChanged: onUseCustomSelectedColorChanged,
                  ),
                ],
              ),
              if (useCustomSelectedColor) ...[
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: selectedColor,
                  onColorSelected: onSelectedColorChanged,
                ),
              ],
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Selected Border',
                    subtitle:
                        'Highlights selected items with an accented border outline',
                    value: useSelectedBorder,
                    onChanged: onUseSelectedBorderChanged,
                  ),
                ],
              ),
              if (useSelectedBorder) ...[
                const SizedBox(height: 8),
                ColorDotPicker(
                  selectedColor: selectedBorderColor,
                  onColorSelected: onSelectedBorderColorChanged,
                ),
                const SizedBox(height: 6),
                M3ESliderRow(
                  label: 'Selected Border Width',
                  value: selectedBorderWidth,
                  min: 1.0,
                  max: 4.0,
                  divisions: 6,
                  format: (v) => '${v.toStringAsFixed(1)} px',
                  onChanged: onSelectedBorderWidthChanged,
                ),
              ],
              const Divider(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected: $selectedCount',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      M3EButton.icon(
                        size: M3EButtonSize.xs,
                        style: M3EButtonStyle.outlined,
                        icon: const Icon(Icons.select_all_rounded),
                        label: const Text('All'),
                        onPressed: onSelectAll,
                      ),
                      M3EButton.icon(
                        size: M3EButtonSize.xs,
                        style: M3EButtonStyle.outlined,
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: const Text('Invert'),
                        onPressed: onInvertSelection,
                      ),
                      M3EButton.icon(
                        size: M3EButtonSize.xs,
                        style: M3EButtonStyle.tonal,
                        icon: const Icon(Icons.clear_all_rounded),
                        label: const Text('Clear'),
                        onPressed: onClearSelection,
                      ),
                    ],
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
