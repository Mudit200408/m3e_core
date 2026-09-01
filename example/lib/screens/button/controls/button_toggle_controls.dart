// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class ButtonToggleControls extends StatelessWidget {
  const ButtonToggleControls({
    super.key,
    required this.isChecked,
    required this.onIsCheckedChanged,
    required this.allowMultilineLabel,
    required this.onAllowMultilineLabelChanged,
    required this.useCustomCheckedLabel,
    required this.onUseCustomCheckedLabelChanged,
    required this.checkedLabel,
    required this.onCheckedLabelChanged,
    required this.useCustomCheckedIcon,
    required this.onUseCustomCheckedIconChanged,
    required this.checkedIcon,
    required this.onCheckedIconChanged,
  });

  final bool isChecked;
  final ValueChanged<bool> onIsCheckedChanged;
  final bool allowMultilineLabel;
  final ValueChanged<bool> onAllowMultilineLabelChanged;
  final bool useCustomCheckedLabel;
  final ValueChanged<bool> onUseCustomCheckedLabelChanged;
  final String checkedLabel;
  final ValueChanged<String> onCheckedLabelChanged;
  final bool useCustomCheckedIcon;
  final ValueChanged<bool> onUseCustomCheckedIconChanged;
  final IconData checkedIcon;
  final ValueChanged<IconData> onCheckedIconChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Pill Toggle State & Morphing',
          icon: Icons.toggle_on_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Checked State',
                  subtitle: 'Toggles between active and inactive pill states',
                  value: isChecked,
                  onChanged: onIsCheckedChanged,
                ),
                M3ESwitchItem(
                  title: 'Custom Checked Label',
                  subtitle:
                      'Use different text when checked (morphs label smoothly)',
                  value: useCustomCheckedLabel,
                  onChanged: onUseCustomCheckedLabelChanged,
                ),
                M3ESwitchItem(
                  title: 'Custom Checked Icon',
                  subtitle:
                      'Use different icon when checked (morphs icon with cross-fade)',
                  value: useCustomCheckedIcon,
                  onChanged: onUseCustomCheckedIconChanged,
                ),
                M3ESwitchItem(
                  title: 'Allow Multiline Label',
                  subtitle:
                      'Enables multi-line status titles for quick settings tiles',
                  value: allowMultilineLabel,
                  onChanged: onAllowMultilineLabelChanged,
                ),
              ],
            ),
            if (useCustomCheckedLabel) ...[
              const Divider(height: 16),
              const Text(
                'Checked State Label',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: checkedLabel == 'Selected'
                    ? 0
                    : (checkedLabel == 'Active'
                          ? 1
                          : (checkedLabel == 'On' ? 2 : 3)),
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onCheckedLabelChanged(switch (i) {
                      0 => 'Selected',
                      1 => 'Active',
                      2 => 'On',
                      _ => 'Bookmarked',
                    });
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Selected')),
                  M3EToggleButtonGroupAction(label: Text('Active')),
                  M3EToggleButtonGroupAction(label: Text('On')),
                  M3EToggleButtonGroupAction(label: Text('Bookmarked')),
                ],
              ),
            ],
            if (useCustomCheckedIcon) ...[
              const Divider(height: 16),
              Row(
                children: [
                  const Text('Checked Icon:', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    icon: Icon(checkedIcon),
                    onPressed: () {
                      onCheckedIconChanged(
                        checkedIcon == Icons.check_circle_rounded
                            ? Icons.favorite_rounded
                            : (checkedIcon == Icons.favorite_rounded
                                  ? Icons.bookmark_added_rounded
                                  : Icons.check_circle_rounded),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to cycle checked icon',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
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
