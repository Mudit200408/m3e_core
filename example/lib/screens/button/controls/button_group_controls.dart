// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonGroupControls extends StatelessWidget {
  const ButtonGroupControls({
    super.key,
    required this.groupPreset,
    required this.onGroupPresetSelected,
    required this.groupShowIcon,
    required this.onGroupShowIconChanged,
    required this.groupShowCheckedIcon,
    required this.onGroupShowCheckedIconChanged,
    required this.groupShowLabel,
    required this.onGroupShowLabelChanged,
    required this.groupShowCheckedLabel,
    required this.onGroupShowCheckedLabelChanged,
    required this.groupPerActionDecoration,
    required this.onGroupPerActionDecorationChanged,
    required this.showActionTooltips,
    required this.onShowActionTooltipsChanged,
    required this.hasDisabledAction,
    required this.onHasDisabledActionChanged,
    required this.useVariableActionWidths,
    required this.onUseVariableActionWidthsChanged,
    required this.groupType,
    required this.onGroupTypeChanged,
    required this.spacing,
    required this.onSpacingChanged,
    required this.useCustomHeight,
    required this.onUseCustomHeightChanged,
    required this.customHeight,
    required this.onCustomHeightChanged,
    required this.groupMultiSelect,
    required this.onGroupMultiSelectChanged,
    required this.neighborSquish,
    required this.onNeighborSquishChanged,
    required this.expandedRatio,
    required this.onExpandedRatioChanged,
    required this.density,
    required this.onDensityChanged,
    required this.direction,
    required this.onDirectionChanged,
    required this.overflow,
    required this.onOverflowChanged,
    required this.overflowMenuStyle,
    required this.onOverflowMenuStyleChanged,
    required this.overflowUseCardList,
    required this.onOverflowUseCardListChanged,
    required this.overflowIcon,
    required this.onOverflowIconChanged,
    required this.actionCount,
    required this.onActionCountChanged,
  });

  final GroupPreset groupPreset;
  final ValueChanged<GroupPreset> onGroupPresetSelected;
  final bool groupShowIcon;
  final ValueChanged<bool> onGroupShowIconChanged;
  final bool groupShowCheckedIcon;
  final ValueChanged<bool> onGroupShowCheckedIconChanged;
  final bool groupShowLabel;
  final ValueChanged<bool> onGroupShowLabelChanged;
  final bool groupShowCheckedLabel;
  final ValueChanged<bool> onGroupShowCheckedLabelChanged;
  final bool groupPerActionDecoration;
  final ValueChanged<bool> onGroupPerActionDecorationChanged;
  final bool showActionTooltips;
  final ValueChanged<bool> onShowActionTooltipsChanged;
  final bool hasDisabledAction;
  final ValueChanged<bool> onHasDisabledActionChanged;
  final bool useVariableActionWidths;
  final ValueChanged<bool> onUseVariableActionWidthsChanged;
  final M3EButtonGroupType groupType;
  final ValueChanged<M3EButtonGroupType> onGroupTypeChanged;
  final double spacing;
  final ValueChanged<double> onSpacingChanged;
  final bool useCustomHeight;
  final ValueChanged<bool> onUseCustomHeightChanged;
  final double customHeight;
  final ValueChanged<double> onCustomHeightChanged;
  final bool groupMultiSelect;
  final ValueChanged<bool> onGroupMultiSelectChanged;
  final bool neighborSquish;
  final ValueChanged<bool> onNeighborSquishChanged;
  final double expandedRatio;
  final ValueChanged<double> onExpandedRatioChanged;
  final M3EButtonGroupDensity density;
  final ValueChanged<M3EButtonGroupDensity> onDensityChanged;
  final Axis direction;
  final ValueChanged<Axis> onDirectionChanged;
  final M3EButtonGroupOverflow overflow;
  final ValueChanged<M3EButtonGroupOverflow> onOverflowChanged;
  final M3EButtonGroupOverflowMenuStyle overflowMenuStyle;
  final ValueChanged<M3EButtonGroupOverflowMenuStyle>
  onOverflowMenuStyleChanged;
  final bool overflowUseCardList;
  final ValueChanged<bool> onOverflowUseCardListChanged;
  final IconData overflowIcon;
  final ValueChanged<IconData> onOverflowIconChanged;
  final int actionCount;
  final ValueChanged<int> onActionCountChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Group Presets & Architecture',
          subtitle:
              'Compose variable-widths, morphing checked labels, connected shapes, and squish physics',
          icon: Icons.view_week_rounded,
        ),
        ControlCard(
          children: [
            const Text(
              'Group Presets',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  avatar: const Icon(Icons.format_bold_rounded, size: 16),
                  label: const Text('Text Formatting Group'),
                  selected: groupPreset == GroupPreset.formatting,
                  onSelected: (_) =>
                      onGroupPresetSelected(GroupPreset.formatting),
                ),
                FilterChip(
                  avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: const Text('Morphing Checked Label (Icon -> Label)'),
                  selected: groupPreset == GroupPreset.morphingCheckedLabel,
                  onSelected: (_) =>
                      onGroupPresetSelected(GroupPreset.morphingCheckedLabel),
                ),
                FilterChip(
                  avatar: const Icon(Icons.view_column_rounded, size: 16),
                  label: const Text(
                    'Compose Variable Widths (BT/Alarm/Link/Wi-Fi)',
                  ),
                  selected: groupPreset == GroupPreset.composeVariableWidths,
                  onSelected: (_) =>
                      onGroupPresetSelected(GroupPreset.composeVariableWidths),
                ),
                FilterChip(
                  avatar: const Icon(Icons.wifi_rounded, size: 16),
                  label: const Text('Quick Settings Group'),
                  selected: groupPreset == GroupPreset.quickSettings,
                  onSelected: (_) =>
                      onGroupPresetSelected(GroupPreset.quickSettings),
                ),
              ],
            ),
            const Divider(height: 16),
            const Text(
              'Per-Action Content Slots (M3EToggleButtonGroupAction)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Unchecked Icon (action.icon)',
                  subtitle: groupShowLabel
                      ? 'Shows icon when button is unselected/default'
                      : 'Required: at least icon or label must be active',
                  value: groupShowIcon,
                  onChanged: (v) {
                    if (!v && !groupShowLabel) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'M3EToggleButtonGroupAction requires either an icon or a label.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    onGroupShowIconChanged(v);
                  },
                ),
                M3ESwitchItem(
                  title: 'Checked Icon (action.checkedIcon)',
                  subtitle: 'Morphs to a distinct checkmark icon when selected',
                  value: groupShowCheckedIcon,
                  onChanged: onGroupShowCheckedIconChanged,
                ),
                M3ESwitchItem(
                  title: 'Unchecked Label (action.label)',
                  subtitle: groupShowIcon
                      ? 'Shows static text when unselected'
                      : 'Required: at least icon or label must be active',
                  value: groupShowLabel,
                  onChanged: (v) {
                    if (!v && !groupShowIcon) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'M3EToggleButtonGroupAction requires either an icon or a label.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    onGroupShowLabelChanged(v);
                  },
                ),
                M3ESwitchItem(
                  title: 'Checked Label (action.checkedLabel)',
                  subtitle:
                      'Expands/reveals label only when selected (e.g. icon-only -> icon + "Bold")',
                  value: groupShowCheckedLabel,
                  onChanged: onGroupShowCheckedLabelChanged,
                ),
                M3ESwitchItem(
                  title: 'Per-Action Custom Decoration',
                  subtitle:
                      'Applies individual M3EToggleButtonDecoration per action item',
                  value: groupPerActionDecoration,
                  onChanged: onGroupPerActionDecorationChanged,
                ),
                M3ESwitchItem(
                  title: 'Action Tooltips (action.tooltip)',
                  subtitle:
                      'Shows contextual tooltip on hovering each button in the group',
                  value: showActionTooltips,
                  onChanged: onShowActionTooltipsChanged,
                ),
                M3ESwitchItem(
                  title: 'Simulate Disabled Action Item',
                  subtitle:
                      'Disables the 3rd action item (Underline) in the group',
                  value: hasDisabledAction,
                  onChanged: onHasDisabledActionChanged,
                ),
                if (groupPreset == GroupPreset.composeVariableWidths)
                  M3ESwitchItem(
                    title: 'Fixed Action Widths (Alarm 80, Link 60, WiFi 120)',
                    subtitle:
                        'When enabled, explicit width parameters lock button widths. When disabled, all buttons scale dynamically with Button Size.',
                    value: useVariableActionWidths,
                    onChanged: onUseVariableActionWidthsChanged,
                  ),
              ],
            ),
            const Divider(height: 16),
            const Text(
              'Group Type (M3EButtonGroupType)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: ButtonPlaygroundOptions.groupTypes.indexOf(
                groupType,
              ),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onGroupTypeChanged(ButtonPlaygroundOptions.groupTypes[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  label: Text('Connected (Shared Border)'),
                ),
                M3EToggleButtonGroupAction(label: Text('Standard (Spaced)')),
              ],
            ),
            if (groupType == M3EButtonGroupType.standard) ...[
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Button Spacing',
                value: spacing,
                min: 0,
                max: 20,
                divisions: 20,
                format: (v) => '${v.toStringAsFixed(1)} dp',
                onChanged: onSpacingChanged,
              ),
            ],
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom Button Height (80dp Compose Style)',
                  subtitle:
                      'Uses M3EButtonSize.custom(height: ...) for oversized touch targets',
                  value: useCustomHeight,
                  onChanged: onUseCustomHeightChanged,
                ),
              ],
            ),
            if (useCustomHeight)
              M3ESliderRow(
                label: 'Custom Height',
                value: customHeight,
                min: 36,
                max: 120,
                divisions: 14,
                format: (v) => '${v.toInt()} dp',
                onChanged: onCustomHeightChanged,
              ),
            const Divider(height: 16),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Multi-Select Mode',
                  subtitle:
                      'Allows multiple buttons to be checked simultaneously',
                  value: groupMultiSelect,
                  onChanged: onGroupMultiSelectChanged,
                ),
                if (groupType == M3EButtonGroupType.standard)
                  M3ESwitchItem(
                    title: 'Neighbor Squish Physics',
                    subtitle:
                        'Adjacent buttons dynamically compress when one is pressed',
                    value: neighborSquish,
                    onChanged: onNeighborSquishChanged,
                  ),
              ],
            ),
            if (groupType == M3EButtonGroupType.standard && neighborSquish) ...[
              const SizedBox(height: 6),
              M3ESliderRow(
                label: 'Squish Expansion Ratio',
                value: expandedRatio,
                min: 0.04,
                max: 0.35,
                divisions: 31,
                format: (v) => '${(v * 100).toInt()}% width',
                onChanged: onExpandedRatioChanged,
              ),
            ],
            const Divider(height: 16),
            const Text(
              'Group Layout Density (M3EButtonGroupDensity)',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: ButtonPlaygroundOptions.densities.indexOf(density),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onDensityChanged(ButtonPlaygroundOptions.densities[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Regular (100%)')),
                M3EToggleButtonGroupAction(label: Text('Compact (75%)')),
              ],
            ),
            const Divider(height: 16),
            const Text(
              'Group Direction & Overflow',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: M3EToggleButtonGroup(
                    type: M3EButtonGroupType.connected,
                    style: M3EButtonStyle.outlined,
                    size: M3EButtonSize.xs,
                    selectedIndex: ButtonPlaygroundOptions.directions.indexOf(
                      direction,
                    ),
                    onSelectedIndexChanged: (i) {
                      if (i != null) {
                        onDirectionChanged(
                          ButtonPlaygroundOptions.directions[i],
                        );
                      }
                    },
                    actions: const [
                      M3EToggleButtonGroupAction(label: Text('Horizontal')),
                      M3EToggleButtonGroupAction(label: Text('Vertical')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Overflow Strategy',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EButtonGroupOverflow>(
              key: ValueKey('overflow_$overflow'),
              singleSelect: true,
              searchEnabled: false,
              items: const [
                M3EDropdownItem(
                  label: 'OVERFLOW: MENU',
                  value: M3EButtonGroupOverflow.menu,
                ),
                M3EDropdownItem(
                  label: 'OVERFLOW: SCROLL',
                  value: M3EButtonGroupOverflow.scroll,
                ),
                M3EDropdownItem(
                  label: 'OVERFLOW: EXPERIMENTAL PAGING',
                  value: M3EButtonGroupOverflow.experimentalPaging,
                ),
                M3EDropdownItem(
                  label: 'OVERFLOW: NONE',
                  value: M3EButtonGroupOverflow.none,
                ),
              ],
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Overflow Strategy',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != overflow) {
                  onOverflowChanged(selectedItems.first.value);
                }
              },
            ),
            if (overflow == M3EButtonGroupOverflow.menu) ...[
              const SizedBox(height: 12),
              const Text(
                'Overflow Menu Style (M3EButtonGroupOverflowMenuStyle)',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(height: 6),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: ButtonPlaygroundOptions.overflowMenuStyles
                    .indexOf(overflowMenuStyle),
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onOverflowMenuStyleChanged(
                      ButtonPlaygroundOptions.overflowMenuStyles[i],
                    );
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Popup Menu')),
                  M3EToggleButtonGroupAction(label: Text('Bottom Sheet')),
                ],
              ),
              const SizedBox(height: 8),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Overflow M3E Card List Style',
                    subtitle:
                        'Uses outer/inner rounded card treatments in popup menu',
                    value: overflowUseCardList,
                    onChanged: onOverflowUseCardListChanged,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Overflow Trigger Icon:',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    icon: Icon(overflowIcon),
                    onPressed: () {
                      onOverflowIconChanged(
                        overflowIcon == Icons.more_horiz_rounded
                            ? Icons.more_vert_rounded
                            : (overflowIcon == Icons.more_vert_rounded
                                  ? Icons.menu_rounded
                                  : Icons.more_horiz_rounded),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to cycle trigger icon',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
            if (groupPreset == GroupPreset.formatting) ...[
              const Divider(height: 16),
              M3ESliderRow(
                label: 'Action Button Count',
                value: actionCount.toDouble(),
                min: 2,
                max: 6,
                divisions: 4,
                format: (v) => '${v.toInt()} buttons',
                onChanged: (v) => onActionCountChanged(v.toInt()),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
