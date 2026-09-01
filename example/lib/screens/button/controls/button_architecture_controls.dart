// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonArchitectureControls extends StatelessWidget {
  const ButtonArchitectureControls({
    super.key,
    required this.architecture,
    required this.onArchitectureChanged,
    required this.fabMode,
    required this.onFabModeChanged,
  });

  final ButtonArchitecture architecture;
  final ValueChanged<ButtonArchitecture> onArchitectureChanged;
  final FabArchitectureMode fabMode;
  final ValueChanged<FabArchitectureMode> onFabModeChanged;

  @override
  Widget build(BuildContext context) {
    final isFab = architecture == ButtonArchitecture.floatingAction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ControlSectionHeader(
          title: isFab ? 'FAB Architecture & Variant' : 'Button Architecture',
          subtitle: isFab
              ? 'Choose between Standard FAB, Extended FAB, and spring-driven FAB Menu'
              : 'Select between standard buttons, toggle buttons, split buttons, and groups',
          icon: isFab ? Icons.open_in_full_rounded : Icons.category_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: architecture.index,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onArchitectureChanged(ButtonArchitecture.values[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Standard'),
                  icon: Icon(Icons.smart_button_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Toggle (Pill)'),
                  icon: Icon(Icons.toggle_on_outlined),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Group'),
                  icon: Icon(Icons.view_week_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Split'),
                  icon: Icon(Icons.call_split_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('FAB'),
                  icon: Icon(Icons.open_in_full_rounded),
                ),
              ],
            ),
            if (isFab) ...[
              const Divider(height: 20),
              const Text(
                'FAB Variant',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabMode.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabModeChanged(FabArchitectureMode.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Standard FAB')),
                  M3EToggleButtonGroupAction(label: Text('Extended FAB')),
                  M3EToggleButtonGroupAction(label: Text('FAB Menu')),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
