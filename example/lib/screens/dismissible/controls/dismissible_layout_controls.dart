// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/dismissible_models.dart';

class DismissibleLayoutControls extends StatelessWidget {
  const DismissibleLayoutControls({
    super.key,
    required this.layoutMode,
    required this.onLayoutModeChanged,
    required this.enableLazyLoading,
    required this.onEnableLazyLoadingChanged,
    required this.itemCount,
    required this.onAddItem,
    required this.onResetItems,
    required this.confirmWithDialog,
    required this.onConfirmWithDialogChanged,
    this.isActionButtonsMode = false,
  });

  final DismissibleLayoutMode layoutMode;
  final ValueChanged<DismissibleLayoutMode> onLayoutModeChanged;
  final bool enableLazyLoading;
  final ValueChanged<bool> onEnableLazyLoadingChanged;
  final int itemCount;
  final VoidCallback onAddItem;
  final VoidCallback onResetItems;
  final bool confirmWithDialog;
  final ValueChanged<bool> onConfirmWithDialogChanged;
  final bool isActionButtonsMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Layout Architecture',
          subtitle:
              'Choose between Column, ListView, and Sliver implementations',
          icon: Icons.architecture_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: layoutMode.index,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onLayoutModeChanged(DismissibleLayoutMode.values[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Column'),
                  icon: Icon(Icons.view_stream_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('ListView'),
                  icon: Icon(Icons.view_list_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Sliver'),
                  icon: Icon(Icons.layers_rounded),
                ),
              ],
            ),
            if (layoutMode != DismissibleLayoutMode.column) ...[
              const Divider(height: 20),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Infinite Scroll / Lazy Loading',
                    subtitle: 'Simulates asynchronous pagination on scroll',
                    value: enableLazyLoading,
                    onChanged: onEnableLazyLoadingChanged,
                  ),
                ],
              ),
            ],
          ],
        ),
        const ControlSectionHeader(
          title: 'Item Management',
          icon: Icons.checklist_rounded,
        ),
        ControlCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Cards: $itemCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    M3EButton.icon(
                      size: M3EButtonSize.xs,
                      style: M3EButtonStyle.outlined,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add'),
                      onPressed: onAddItem,
                    ),
                    M3EButton.icon(
                      size: M3EButtonSize.xs,
                      style: M3EButtonStyle.tonal,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reset'),
                      onPressed: onResetItems,
                    ),
                  ],
                ),
              ],
            ),
            if (!isActionButtonsMode) ...[
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Confirm With Dialog',
                    subtitle: 'Prompts before committing deletion/archive',
                    value: confirmWithDialog,
                    onChanged: onConfirmWithDialogChanged,
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
