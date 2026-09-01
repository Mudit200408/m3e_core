// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/dropdown_models.dart';

class DropdownDataControls extends StatelessWidget {
  const DropdownDataControls({
    super.key,
    required this.dataMode,
    required this.onDataModeChanged,
    required this.singleSelect,
    required this.onSingleSelectChanged,
    required this.enabled,
    required this.onEnabledChanged,
    required this.maxSelections,
    required this.onMaxSelectionsChanged,
    required this.controller,
    required this.lastEvent,
    required this.lastSearch,
  });

  final DropdownDataMode dataMode;
  final ValueChanged<DropdownDataMode> onDataModeChanged;
  final bool singleSelect;
  final ValueChanged<bool> onSingleSelectChanged;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final int maxSelections;
  final ValueChanged<int> onMaxSelectionsChanged;
  final M3EDropdownController<String> controller;
  final ValueNotifier<String> lastEvent;
  final ValueNotifier<String> lastSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Data & Selection',
          icon: Icons.list_alt_rounded,
        ),
        ControlCard(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Generic type: String',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Data source',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            M3EDropdownMenu<DropdownDataMode>(
              key: ValueKey('control_data_source_$dataMode'),
              singleSelect: true,
              searchEnabled: false,
              items: DropdownDataMode.values
                  .map(
                    (item) => M3EDropdownItem(
                      label: item.name,
                      value: item,
                      selected: item == dataMode,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != dataMode) {
                  onDataModeChanged(items.first.value);
                }
              },
            ),
            const SizedBox(height: 8),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Single-select',
                  value: singleSelect,
                  onChanged: onSingleSelectChanged,
                ),
                M3ESwitchItem(
                  title: 'Enabled',
                  value: enabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
            M3ESliderRow(
              label: 'Maximum selections',
              value: maxSelections.toDouble(),
              min: 0,
              max: 8,
              divisions: 8,
              format: (v) => v.round().toString(),
              onChanged: (v) => onMaxSelectionsChanged(v.round()),
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final selected = controller.selectedValues.join(', ');
                return Text(
                  'Selected: ${selected.isEmpty ? 'None' : selected}',
                );
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: lastEvent,
              builder: (context, value, child) => Text('Last callback: $value'),
            ),
            ValueListenableBuilder<String>(
              valueListenable: lastSearch,
              builder: (context, value, child) =>
                  Text('Last search query: $value'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                M3EButton.icon(
                  onPressed: controller.clearAll,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear'),
                  style: M3EButtonStyle.tonal,
                ),
                M3EButton.icon(
                  onPressed: controller.selectAll,
                  icon: const Icon(Icons.select_all),
                  label: const Text('Select all'),
                  style: M3EButtonStyle.tonal,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
