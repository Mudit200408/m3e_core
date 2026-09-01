// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/progress_models.dart';

class ProgressTypeControls extends StatelessWidget {
  const ProgressTypeControls({
    super.key,
    required this.type,
    required this.onTypeChanged,
    required this.indeterminate,
    required this.onIndeterminateChanged,
  });

  final ProgressType type;
  final ValueChanged<ProgressType> onTypeChanged;
  final bool indeterminate;
  final ValueChanged<bool> onIndeterminateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Indicator Type',
          subtitle: 'Explore every linear, circular, and wavy progress API.',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              direction: Axis.horizontal,
              style: M3EButtonStyle.tonal,
              selectedIndex: type.index,
              onSelectedIndexChanged: (index) {
                if (index != null && index != type.index) {
                  onTypeChanged(ProgressType.values[index]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Linear')),
                M3EToggleButtonGroupAction(label: Text('Circular')),
                M3EToggleButtonGroupAction(label: Text('Linear wavy')),
                M3EToggleButtonGroupAction(label: Text('Circular wavy')),
              ],
            ),
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Indeterminate animation',
                  value: indeterminate,
                  onChanged: onIndeterminateChanged,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
