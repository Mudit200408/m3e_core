// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonSplitControls extends StatelessWidget {
  const ButtonSplitControls({
    super.key,
    required this.splitMenuStyle,
    required this.onSplitMenuStyleChanged,
    required this.splitAlignment,
    required this.onSplitAlignmentChanged,
    required this.splitSelectedValue,
    required this.onSplitSelectedValueChanged,
    required this.splitGap,
    required this.onSplitGapChanged,
    required this.trailingSelectedRadius,
    required this.onTrailingSelectedRadiusChanged,
    required this.useCustomDividerColor,
    required this.onUseCustomDividerColorChanged,
    required this.customDividerColor,
    required this.onCustomDividerColorChanged,
    required this.leadingTooltip,
    required this.onLeadingTooltipChanged,
    required this.onTrailingTooltipChanged,
  });

  final SplitButtonMenuStyle splitMenuStyle;
  final ValueChanged<SplitButtonMenuStyle> onSplitMenuStyleChanged;
  final M3ESplitButtonTrailingAlignment splitAlignment;
  final ValueChanged<M3ESplitButtonTrailingAlignment> onSplitAlignmentChanged;
  final String splitSelectedValue;
  final ValueChanged<String> onSplitSelectedValueChanged;
  final double splitGap;
  final ValueChanged<double> onSplitGapChanged;
  final double trailingSelectedRadius;
  final ValueChanged<double> onTrailingSelectedRadiusChanged;
  final bool useCustomDividerColor;
  final ValueChanged<bool> onUseCustomDividerColorChanged;
  final Color customDividerColor;
  final ValueChanged<Color> onCustomDividerColorChanged;
  final String leadingTooltip;
  final ValueChanged<String> onLeadingTooltipChanged;
  final ValueChanged<String> onTrailingTooltipChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Split Button Menus & Tooltips',
          subtitle:
              'Popup / modal bottom sheet menus, optical alignment, and selection state',
          icon: Icons.call_split_rounded,
        ),
        ControlCard(
          children: [
            const Text(
              'Menu Presentation Style (SplitButtonMenuStyle)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: ButtonPlaygroundOptions.splitMenuStyles.indexOf(
                splitMenuStyle,
              ),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onSplitMenuStyleChanged(
                    ButtonPlaygroundOptions.splitMenuStyles[i],
                  );
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Popup (Anchor)')),
                M3EToggleButtonGroupAction(label: Text('Bottom Sheet (Modal)')),
                M3EToggleButtonGroupAction(label: Text('Native Menu')),
              ],
            ),
            const Divider(height: 16),
            const Text(
              'Trailing Alignment (M3ESplitButtonTrailingAlignment)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: ButtonPlaygroundOptions.splitAlignments.indexOf(
                splitAlignment,
              ),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onSplitAlignmentChanged(
                    ButtonPlaygroundOptions.splitAlignments[i],
                  );
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Optical Center')),
                M3EToggleButtonGroupAction(label: Text('Geometric Center')),
              ],
            ),
            const Divider(height: 16),
            const Text(
              'Active Selected Item',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex:
                  ButtonPlaygroundOptions.splitOptions.contains(
                    splitSelectedValue,
                  )
                  ? ButtonPlaygroundOptions.splitOptions.indexOf(
                      splitSelectedValue,
                    )
                  : 0,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onSplitSelectedValueChanged(
                    ButtonPlaygroundOptions.splitOptions[i],
                  );
                }
              },
              actions: ButtonPlaygroundOptions.splitOptions
                  .map((opt) => M3EToggleButtonGroupAction(label: Text(opt)))
                  .toList(),
            ),
            const Divider(height: 16),
            M3ESliderRow(
              label: 'Split Segment Gap',
              value: splitGap,
              min: 0.0,
              max: 12.0,
              divisions: 12,
              format: (v) => '${v.toStringAsFixed(0)} dp',
              onChanged: onSplitGapChanged,
            ),
            M3ESliderRow(
              label: 'Trailing Selected Radius',
              value: trailingSelectedRadius,
              min: 0.0,
              max: 24.0,
              divisions: 24,
              format: (v) => '${v.toStringAsFixed(0)} dp',
              onChanged: onTrailingSelectedRadiusChanged,
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Segment Divider Color',
                  value: useCustomDividerColor,
                  onChanged: onUseCustomDividerColorChanged,
                ),
              ],
            ),
            if (useCustomDividerColor) ...[
              const SizedBox(height: 8),
              ColorDotPicker(
                selectedColor: customDividerColor,
                onColorSelected: onCustomDividerColorChanged,
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Show Action Tooltips',
                  subtitle:
                      'Displays "Trigger Primary Action" & "More Actions" on hover',
                  value: leadingTooltip.isNotEmpty,
                  onChanged: (v) {
                    onLeadingTooltipChanged(v ? 'Trigger Primary Action' : '');
                    onTrailingTooltipChanged(v ? 'More Actions' : '');
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
