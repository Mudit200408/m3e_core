// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonStandardControls extends StatelessWidget {
  const ButtonStandardControls({
    super.key,
    required this.architecture,
    required this.style,
    required this.onStyleChanged,
    required this.size,
    required this.onSizeChanged,
    required this.isCustomSize,
    required this.onIsCustomSizeChanged,
    required this.customHeight,
    required this.onCustomHeightChanged,
    required this.customHPadding,
    required this.onCustomHPaddingChanged,
    required this.customIconSize,
    required this.onCustomIconSizeChanged,
    required this.customIconGap,
    required this.onCustomIconGapChanged,
    required this.useCustomWidth,
    required this.onUseCustomWidthChanged,
    required this.customWidth,
    required this.onCustomWidthChanged,
    required this.shape,
    required this.onShapeChanged,
    required this.useDecoration,
    required this.onUseDecorationChanged,
    required this.enabled,
    required this.onEnabledChanged,
    required this.enableFeedback,
    required this.onEnableFeedbackChanged,
    required this.contentLayout,
    required this.onContentLayoutChanged,
    required this.iconAlignment,
    required this.onIconAlignmentChanged,
    required this.label,
    required this.onLabelChanged,
    required this.icon,
    required this.onIconChanged,
    required this.buttonTooltip,
    required this.onButtonTooltipChanged,
  });

  final ButtonArchitecture architecture;
  final M3EButtonStyle style;
  final ValueChanged<M3EButtonStyle> onStyleChanged;
  final M3EButtonSize size;
  final ValueChanged<M3EButtonSize> onSizeChanged;
  final bool isCustomSize;
  final ValueChanged<bool> onIsCustomSizeChanged;
  final double customHeight;
  final ValueChanged<double> onCustomHeightChanged;
  final double customHPadding;
  final ValueChanged<double> onCustomHPaddingChanged;
  final double customIconSize;
  final ValueChanged<double> onCustomIconSizeChanged;
  final double customIconGap;
  final ValueChanged<double> onCustomIconGapChanged;
  final bool useCustomWidth;
  final ValueChanged<bool> onUseCustomWidthChanged;
  final double customWidth;
  final ValueChanged<double> onCustomWidthChanged;
  final M3EButtonShape shape;
  final ValueChanged<M3EButtonShape> onShapeChanged;
  final bool useDecoration;
  final ValueChanged<bool> onUseDecorationChanged;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool enableFeedback;
  final ValueChanged<bool> onEnableFeedbackChanged;

  final ButtonContentLayout contentLayout;
  final ValueChanged<ButtonContentLayout> onContentLayoutChanged;
  final IconAlignment iconAlignment;
  final ValueChanged<IconAlignment> onIconAlignmentChanged;
  final String label;
  final ValueChanged<String> onLabelChanged;
  final IconData icon;
  final ValueChanged<IconData> onIconChanged;
  final String buttonTooltip;
  final ValueChanged<String> onButtonTooltipChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final availableStyles = architecture == ButtonArchitecture.split
        ? const [
            M3EButtonStyle.filled,
            M3EButtonStyle.tonal,
            M3EButtonStyle.elevated,
            M3EButtonStyle.outlined,
          ]
        : ButtonPlaygroundOptions.styles;
    final selectedStyleIdx = availableStyles.indexOf(style);

    final selectedSizeIdx = isCustomSize
        ? 5
        : ButtonPlaygroundOptions.availableSizes.indexOf(size);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ControlCard(
          children: [
            const Text(
              'Button Style (M3EButtonStyle)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              key: ValueKey('btn_style_group_${architecture.name}'),
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: selectedStyleIdx >= 0 ? selectedStyleIdx : 0,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onStyleChanged(availableStyles[i]);
                }
              },
              actions: availableStyles
                  .map(
                    (s) => M3EToggleButtonGroupAction(
                      label: Text(switch (s) {
                        M3EButtonStyle.filled => 'Filled',
                        M3EButtonStyle.tonal => 'Tonal',
                        M3EButtonStyle.elevated => 'Elevated',
                        M3EButtonStyle.outlined => 'Outlined',
                        M3EButtonStyle.text => 'Text',
                      }),
                    ),
                  )
                  .toList(),
            ),
            const Divider(height: 20),
            const Text(
              'Button Size (M3EButtonSize)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: selectedSizeIdx >= 0 ? selectedSizeIdx : 2,
              onSelectedIndexChanged: (i) {
                if (i == null) return;
                if (i == 5) {
                  onIsCustomSizeChanged(true);
                } else {
                  onIsCustomSizeChanged(false);
                  onSizeChanged(ButtonPlaygroundOptions.availableSizes[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('XS')),
                M3EToggleButtonGroupAction(label: Text('SM')),
                M3EToggleButtonGroupAction(label: Text('MD')),
                M3EToggleButtonGroupAction(label: Text('LG')),
                M3EToggleButtonGroupAction(label: Text('XL')),
                M3EToggleButtonGroupAction(label: Text('Custom')),
              ],
            ),
            if (isCustomSize) ...[
              const SizedBox(height: 12),
              M3ESliderRow(
                label: 'Custom Height',
                value: customHeight,
                min: 24,
                max: 120,
                divisions: 96,
                format: (v) => '${v.toInt()} dp',
                onChanged: onCustomHeightChanged,
              ),
              M3ESliderRow(
                label: 'Horizontal Padding',
                value: customHPadding,
                min: 0,
                max: 48,
                divisions: 48,
                format: (v) => '${v.toInt()} dp',
                onChanged: onCustomHPaddingChanged,
              ),
              M3ESliderRow(
                label: 'Icon Size',
                value: customIconSize,
                min: 12,
                max: 48,
                divisions: 36,
                format: (v) => '${v.toInt()} dp',
                onChanged: onCustomIconSizeChanged,
              ),
              M3ESliderRow(
                label: 'Icon Gap',
                value: customIconGap,
                min: 0,
                max: 32,
                divisions: 32,
                format: (v) => '${v.toInt()} dp',
                onChanged: onCustomIconGapChanged,
              ),
              const SizedBox(height: 8),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Fixed Custom Width',
                    subtitle: 'Sets explicit button width instead of intrinsic',
                    value: useCustomWidth,
                    onChanged: onUseCustomWidthChanged,
                  ),
                ],
              ),
              if (useCustomWidth)
                M3ESliderRow(
                  label: 'Custom Width',
                  value: customWidth,
                  min: 40,
                  max: 300,
                  divisions: 26,
                  format: (v) => '${v.toInt()} dp',
                  onChanged: onCustomWidthChanged,
                ),
            ],
            const Divider(height: 20),
            const Text(
              'Button Shape (M3EButtonShape)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: ButtonPlaygroundOptions.shapes.indexOf(shape),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onShapeChanged(ButtonPlaygroundOptions.shapes[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Round (Pill)')),
                M3EToggleButtonGroupAction(label: Text('Square (Token)')),
              ],
            ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Use M3EButtonDecoration.styleFrom',
                  subtitle: 'Applies custom token styling data class',
                  value: useDecoration,
                  onChanged: onUseDecorationChanged,
                ),
                M3ESwitchItem(
                  title: 'Button Enabled',
                  value: enabled,
                  onChanged: onEnabledChanged,
                ),
                M3ESwitchItem(
                  title: 'Enable Ripple & Audio Feedback',
                  subtitle: 'Controls enableFeedback on interaction',
                  value: enableFeedback,
                  onChanged: onEnableFeedbackChanged,
                ),
              ],
            ),
          ],
        ),
        if (architecture != ButtonArchitecture.group) ...[
          const ControlSectionHeader(
            title: 'Content & Slot Layout',
            subtitle: 'Icons, labels, tooltips, and slot alignments',
            icon: Icons.text_fields_rounded,
          ),
          ControlCard(
            children: [
              const Text(
                'Content Composition',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: ButtonPlaygroundOptions.contentLayouts.indexOf(
                  contentLayout,
                ),
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onContentLayoutChanged(
                      ButtonPlaygroundOptions.contentLayouts[i],
                    );
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Label + Icon')),
                  M3EToggleButtonGroupAction(label: Text('Label Only')),
                  M3EToggleButtonGroupAction(label: Text('Icon Only')),
                ],
              ),
              if (contentLayout != ButtonContentLayout.iconOnly) ...[
                const Divider(height: 16),
                const Text(
                  'Button Label Text',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 8),
                M3EToggleButtonGroup(
                  type: M3EButtonGroupType.connected,
                  style: M3EButtonStyle.outlined,
                  size: M3EButtonSize.xs,
                  selectedIndex: label == 'Explore'
                      ? 0
                      : (label == 'Save' ? 1 : (label == 'Submit' ? 2 : 3)),
                  onSelectedIndexChanged: (i) {
                    if (i != null) {
                      onLabelChanged(switch (i) {
                        0 => 'Explore',
                        1 => 'Save',
                        2 => 'Submit',
                        _ => 'Delete Action',
                      });
                    }
                  },
                  actions: const [
                    M3EToggleButtonGroupAction(label: Text('Explore')),
                    M3EToggleButtonGroupAction(label: Text('Save')),
                    M3EToggleButtonGroupAction(label: Text('Submit')),
                    M3EToggleButtonGroupAction(label: Text('Delete')),
                  ],
                ),
              ],
              if (contentLayout == ButtonContentLayout.iconAndLabel &&
                  architecture == ButtonArchitecture.standard) ...[
                const Divider(height: 16),
                const Text(
                  'Icon Alignment',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 8),
                M3EToggleButtonGroup(
                  type: M3EButtonGroupType.connected,
                  style: M3EButtonStyle.outlined,
                  size: M3EButtonSize.xs,
                  selectedIndex: ButtonPlaygroundOptions.iconAlignments.indexOf(
                    iconAlignment,
                  ),
                  onSelectedIndexChanged: (i) {
                    if (i != null) {
                      onIconAlignmentChanged(
                        ButtonPlaygroundOptions.iconAlignments[i],
                      );
                    }
                  },
                  actions: const [
                    M3EToggleButtonGroupAction(label: Text('Start / Leading')),
                    M3EToggleButtonGroupAction(label: Text('End / Trailing')),
                  ],
                ),
              ],
              const Divider(height: 16),
              Row(
                children: [
                  const Text('Button Icon:', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    icon: Icon(icon),
                    onPressed: () {
                      onIconChanged(
                        icon == Icons.rocket_launch_rounded
                            ? Icons.save_rounded
                            : (icon == Icons.save_rounded
                                  ? Icons.favorite_rounded
                                  : (icon == Icons.favorite_rounded
                                        ? Icons.send_rounded
                                        : Icons.rocket_launch_rounded)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to cycle icon',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
              if (architecture == ButtonArchitecture.standard ||
                  architecture == ButtonArchitecture.toggle) ...[
                const Divider(height: 16),
                const Text(
                  'Tooltip Text',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 8),
                M3EToggleButtonGroup(
                  type: M3EButtonGroupType.connected,
                  style: M3EButtonStyle.outlined,
                  size: M3EButtonSize.xs,
                  selectedIndex: buttonTooltip.isEmpty
                      ? 0
                      : (buttonTooltip == 'Explore M3E' ? 1 : 2),
                  onSelectedIndexChanged: (i) {
                    if (i != null) {
                      onButtonTooltipChanged(switch (i) {
                        0 => '',
                        1 => 'Explore M3E',
                        _ => 'Primary Button Action',
                      });
                    }
                  },
                  actions: const [
                    M3EToggleButtonGroupAction(label: Text('None')),
                    M3EToggleButtonGroupAction(label: Text('Short Tooltip')),
                    M3EToggleButtonGroupAction(label: Text('Descriptive')),
                  ],
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
