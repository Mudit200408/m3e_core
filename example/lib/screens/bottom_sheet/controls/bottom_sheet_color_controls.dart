// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';
import '../models/bottom_sheet_models.dart';

class BottomSheetColorControls extends StatelessWidget {
  const BottomSheetColorControls({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final BottomSheetPlaygroundState state;
  final ValueChanged<BottomSheetPlaygroundState> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final backgroundColors = [
      (label: 'Container High (Default)', color: cs.surfaceContainerHigh),
      (label: 'Container Low', color: cs.surfaceContainerLow),
      (label: 'Container Highest', color: cs.surfaceContainerHighest),
      (label: 'Surface Bright', color: cs.surfaceBright),
      (label: 'Primary Container', color: cs.primaryContainer),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Colors & Elevation',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Elevation',
              value: state.elevation,
              min: 0,
              max: 16,
              divisions: 8,
              format: (v) => '${v.toStringAsFixed(0)}dp',
              onChanged: (val) => onChanged(state.copyWith(elevation: val)),
            ),
            const SizedBox(height: 8),
            Text('Background Color Preset', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(backgroundColors.length, (i) {
                final isSelected = state.selectedColorIndex == i;
                return ChoiceChip(
                  label: Text(backgroundColors[i].label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onChanged(state.copyWith(selectedColorIndex: i));
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
