// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

class DismissibleStyleControls extends StatelessWidget {
  const DismissibleStyleControls({
    super.key,
    required this.direction,
    required this.onDirectionChanged,
    required this.onSwipeModeChanged,
    required this.actionRevealTrigger,
    required this.onActionRevealTriggerChanged,
    required this.gmailUI,
    required this.onGmailUIChanged,
    required this.useActionButtons,
    required this.onUseActionButtonsChanged,
    required this.actionCount,
    required this.onActionCountChanged,
    required this.useSecondaryActionButtons,
    required this.onUseSecondaryActionButtonsChanged,
    required this.secondaryActionCount,
    required this.onSecondaryActionCountChanged,
    required this.actionButtonWidth,
    required this.onActionButtonWidthChanged,
    required this.actionButtonHeight,
    required this.onActionButtonHeightChanged,
    required this.actionSpacing,
    required this.onActionSpacingChanged,
    required this.backgroundRadius,
    required this.onBackgroundRadiusChanged,
    required this.useCustomCardColor,
    required this.onUseCustomCardColorChanged,
    required this.customCardColor,
    required this.onCustomCardColorChanged,
  });

  final DismissDirection direction;
  final ValueChanged<DismissDirection> onDirectionChanged;
  final ValueChanged<bool> onSwipeModeChanged;
  final M3EActionRevealTrigger actionRevealTrigger;
  final ValueChanged<M3EActionRevealTrigger> onActionRevealTriggerChanged;
  final bool gmailUI;
  final ValueChanged<bool> onGmailUIChanged;
  final bool useActionButtons;
  final ValueChanged<bool> onUseActionButtonsChanged;
  final int actionCount;
  final ValueChanged<int> onActionCountChanged;
  final bool useSecondaryActionButtons;
  final ValueChanged<bool> onUseSecondaryActionButtonsChanged;
  final int secondaryActionCount;
  final ValueChanged<int> onSecondaryActionCountChanged;
  final double actionButtonWidth;
  final ValueChanged<double> onActionButtonWidthChanged;
  final double actionButtonHeight;
  final ValueChanged<double> onActionButtonHeightChanged;
  final double actionSpacing;
  final ValueChanged<double> onActionSpacingChanged;
  final double backgroundRadius;
  final ValueChanged<double> onBackgroundRadiusChanged;
  final bool useCustomCardColor;
  final ValueChanged<bool> onUseCustomCardColorChanged;
  final Color customCardColor;
  final ValueChanged<Color> onCustomCardColorChanged;

  @override
  Widget build(BuildContext context) {
    final bool anyActionButtons = useActionButtons || useSecondaryActionButtons;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Swipe Mode & Direction',
          subtitle: 'Choose between action buttons or full swipe-to-dismiss',
          icon: Icons.palette_outlined,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: anyActionButtons ? 0 : 1,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onSwipeModeChanged(i == 0);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Action Buttons'),
                  icon: Icon(Icons.touch_app_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Swipe to Dismiss'),
                  icon: Icon(Icons.delete_sweep_rounded),
                ),
              ],
            ),
            const Divider(height: 16),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: direction == DismissDirection.horizontal
                  ? 0
                  : direction == DismissDirection.startToEnd
                  ? 1
                  : direction == DismissDirection.endToStart
                  ? 2
                  : 3,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  final dirs = [
                    DismissDirection.horizontal,
                    DismissDirection.startToEnd,
                    DismissDirection.endToStart,
                    DismissDirection.none,
                  ];
                  onDirectionChanged(dirs[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Both'),
                  icon: Icon(Icons.swap_horiz_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Right Only'),
                  icon: Icon(Icons.arrow_forward_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Left Only'),
                  icon: Icon(Icons.arrow_back_rounded),
                ),
                M3EToggleButtonGroupAction(
                  label: Text('Disabled'),
                  icon: Icon(Icons.block_rounded),
                ),
              ],
            ),
            if (anyActionButtons) ...[
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Primary Actions (Swipe Right)',
                    subtitle:
                        'Reveals buttons on start-to-end swipe (Share, Archive)',
                    value: useActionButtons,
                    onChanged: onUseActionButtonsChanged,
                  ),
                  M3ESwitchItem(
                    title: 'Secondary Actions (Swipe Left)',
                    subtitle:
                        'Reveals buttons on end-to-start swipe (Collaborator, Edit)',
                    value: useSecondaryActionButtons,
                    onChanged: onUseSecondaryActionButtonsChanged,
                  ),
                ],
              ),
            ],

            if (anyActionButtons) ...[
              const Divider(height: 16),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex:
                    actionRevealTrigger == M3EActionRevealTrigger.none
                    ? 0
                    : actionRevealTrigger == M3EActionRevealTrigger.doubleTap
                    ? 1
                    : actionRevealTrigger == M3EActionRevealTrigger.longPress
                    ? 2
                    : 3,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    final triggers = [
                      M3EActionRevealTrigger.none,
                      M3EActionRevealTrigger.doubleTap,
                      M3EActionRevealTrigger.longPress,
                      M3EActionRevealTrigger.tap,
                    ];
                    onActionRevealTriggerChanged(triggers[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(
                    label: Text('Swipe Only'),
                    icon: Icon(Icons.swipe_rounded),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('Double Tap'),
                    icon: Icon(Icons.touch_app_outlined),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('Long Press'),
                    icon: Icon(Icons.pan_tool_outlined),
                  ),
                  M3EToggleButtonGroupAction(
                    label: Text('Single Tap'),
                    icon: Icon(Icons.mouse_outlined),
                  ),
                ],
              ),
            ],

            if (useActionButtons) ...[
              const Divider(height: 16),
              M3ESliderRow(
                label: 'Primary Action Count',
                subtitle: 'Number of buttons for swipe right',
                value: actionCount.toDouble(),
                min: 1,
                max: 4,
                divisions: 3,
                format: (v) => v.toInt().toString(),
                onChanged: (v) => onActionCountChanged(v.toInt()),
              ),
            ],

            if (useSecondaryActionButtons) ...[
              const Divider(height: 16),
              M3ESliderRow(
                label: 'Secondary Action Count',
                subtitle: 'Number of buttons for swipe left',
                value: secondaryActionCount.toDouble(),
                min: 1,
                max: 4,
                divisions: 3,
                format: (v) => v.toInt().toString(),
                onChanged: (v) => onSecondaryActionCountChanged(v.toInt()),
              ),
            ],

            if (anyActionButtons) ...[
              const Divider(height: 16),
              M3ESliderRow(
                label: 'Button Width',
                subtitle: 'Width of each vertical pill action',
                value: actionButtonWidth,
                min: 36,
                max: 72,
                divisions: 18,
                format: (v) => '${v.toStringAsFixed(0)} dp',
                onChanged: onActionButtonWidthChanged,
              ),
              M3ESliderRow(
                label: 'Button Height',
                subtitle: 'Height of each vertical pill action',
                value: actionButtonHeight,
                min: 0,
                max: 100,
                divisions: 22,
                format: (v) => v == 0
                    ? 'Auto (Card Height)'
                    : '${v.toStringAsFixed(0)} dp',
                onChanged: onActionButtonHeightChanged,
              ),
              M3ESliderRow(
                label: 'Button Gap / Spacing',
                subtitle: 'Spacing between adjacent action buttons',
                value: actionSpacing,
                min: 0,
                max: 20,
                divisions: 20,
                format: (v) => '${v.toStringAsFixed(0)} dp',
                onChanged: onActionSpacingChanged,
              ),
            ],

            if (!anyActionButtons) ...[
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Gmail Style UI Preset',
                    subtitle:
                        'Green archive & red delete backgrounds with centered icons',
                    value: gmailUI,
                    onChanged: onGmailUIChanged,
                  ),
                ],
              ),
              if (gmailUI) ...[
                const SizedBox(height: 8),
                M3ESliderRow(
                  label: 'Background Radius',
                  value: backgroundRadius,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  format: (v) => v.toStringAsFixed(0),
                  onChanged: onBackgroundRadiusChanged,
                ),
              ],
            ],

            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Card Surface Color',
                  value: useCustomCardColor,
                  onChanged: onUseCustomCardColorChanged,
                ),
              ],
            ),
            if (useCustomCardColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: customCardColor,
                onColorSelected: onCustomCardColorChanged,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
