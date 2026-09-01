// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/floating_toolbar_models.dart';

class FloatingToolbarVariantControls extends StatelessWidget {
  const FloatingToolbarVariantControls({
    super.key,
    required this.variant,
    required this.onVariantChanged,
    required this.effectiveContentPreset,
    required this.onContentPresetChanged,
    required this.isVertical,
    required this.screenAlignment,
    required this.onScreenAlignmentChanged,
    required this.expanded,
    required this.onExpandedChanged,
    required this.showLeading,
    required this.onShowLeadingChanged,
    required this.showTrailing,
    required this.onShowTrailingChanged,
    required this.showDivider,
    required this.onShowDividerChanged,
    required this.haptic,
    required this.onHapticChanged,
    required this.horizontalFabPosition,
    required this.onHorizontalFabPositionChanged,
    required this.verticalFabPosition,
    required this.onVerticalFabPositionChanged,
    required this.fabActionMode,
    required this.onFabActionModeChanged,
    required this.customFabIcon,
    required this.onCustomFabIconChanged,
    required this.fabActionToast,
    required this.onFabActionToastChanged,
  });

  final ToolbarVariant variant;
  final ValueChanged<ToolbarVariant> onVariantChanged;
  final ToolbarContentPreset effectiveContentPreset;
  final ValueChanged<ToolbarContentPreset> onContentPresetChanged;
  final bool isVertical;
  final ToolbarScreenAlignment screenAlignment;
  final ValueChanged<ToolbarScreenAlignment> onScreenAlignmentChanged;
  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;
  final bool showLeading;
  final ValueChanged<bool> onShowLeadingChanged;
  final bool showTrailing;
  final ValueChanged<bool> onShowTrailingChanged;
  final bool showDivider;
  final ValueChanged<bool> onShowDividerChanged;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;
  final M3EFloatingToolbarHorizontalFabPosition horizontalFabPosition;
  final ValueChanged<M3EFloatingToolbarHorizontalFabPosition>
  onHorizontalFabPositionChanged;
  final M3EFloatingToolbarVerticalFabPosition verticalFabPosition;
  final ValueChanged<M3EFloatingToolbarVerticalFabPosition>
  onVerticalFabPositionChanged;
  final FabActionMode fabActionMode;
  final ValueChanged<FabActionMode> onFabActionModeChanged;
  final IconData customFabIcon;
  final void Function(IconData icon, String name) onCustomFabIconChanged;
  final String fabActionToast;
  final ValueChanged<String> onFabActionToastChanged;

  @override
  Widget build(BuildContext context) {
    final isFab =
        variant == ToolbarVariant.horizontalFab ||
        variant == ToolbarVariant.verticalFab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Toolbar Architecture & Use Case',
          icon: Icons.view_quilt_rounded,
        ),
        ControlCard(
          children: [
            Text('Variant', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 6),
            M3EDropdownMenu<ToolbarVariant>(
              key: ValueKey('toolbar_variant_$variant'),
              singleSelect: true,
              searchEnabled: false,
              items: ToolbarVariant.values
                  .map(
                    (v) => M3EDropdownItem<ToolbarVariant>(
                      label: v.label,
                      value: v,
                      selected: v == variant,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select Toolbar Variant',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != variant) {
                  onVariantChanged(items.first.value);
                }
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Content Use Case / Preset',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<ToolbarContentPreset>(
              key: ValueKey(
                'toolbar_preset_${variant}_$effectiveContentPreset',
              ),
              singleSelect: true,
              searchEnabled: false,
              items: ToolbarContentPreset.values
                  .where((p) {
                    if (isVertical && p == ToolbarContentPreset.bottomNav) {
                      return false;
                    }
                    return true;
                  })
                  .map(
                    (p) => M3EDropdownItem<ToolbarContentPreset>(
                      label: p.label,
                      value: p,
                      selected: p == effectiveContentPreset,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select Content Preset',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty &&
                    items.first.value != effectiveContentPreset) {
                  onContentPresetChanged(items.first.value);
                }
              },
            ),
            if (variant != ToolbarVariant.docked) ...[
              const SizedBox(height: 12),
              Text(
                'Screen Placement / Alignment',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              M3EDropdownMenu<ToolbarScreenAlignment>(
                key: ValueKey('toolbar_align_${variant}_$screenAlignment'),
                singleSelect: true,
                searchEnabled: false,
                items: ToolbarScreenAlignment.values
                    .map(
                      (a) => M3EDropdownItem<ToolbarScreenAlignment>(
                        label: a.label,
                        value: a,
                        selected: a == screenAlignment,
                      ),
                    )
                    .toList(),
                fieldStyle: const M3EDropdownFieldStyle(
                  hintText: 'Select Screen Alignment',
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
                onSelectionChanged: (items) {
                  if (items.isNotEmpty &&
                      items.first.value != screenAlignment) {
                    onScreenAlignmentChanged(items.first.value);
                  }
                },
              ),
            ],
            const SizedBox(height: 12),
            M3ESegmentedSwitchGroup(
              items: [
                if (variant != ToolbarVariant.docked)
                  M3ESwitchItem(
                    title: 'Expanded (Toolbar Open)',
                    subtitle: 'Toggles spring unroll visibility of actions',
                    value: expanded,
                    onChanged: onExpandedChanged,
                  ),
                M3ESwitchItem(
                  title: 'Leading Content Slot',
                  value: showLeading,
                  onChanged: onShowLeadingChanged,
                ),
                M3ESwitchItem(
                  title: 'Trailing Content Slot',
                  value: showTrailing,
                  onChanged: onShowTrailingChanged,
                ),
                M3ESwitchItem(
                  title: 'Divider Slot (M3EFloatingToolbarDivider)',
                  value: showDivider,
                  onChanged: onShowDividerChanged,
                ),
              ],
            ),
            const Divider(height: 16),
            Text(
              'Haptic Feedback (M3EHapticFeedback)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('toolbar_haptic_$haptic'),
              singleSelect: true,
              searchEnabled: false,
              items: M3EHapticFeedback.values
                  .map(
                    (h) => M3EDropdownItem<M3EHapticFeedback>(
                      label: h.name.toUpperCase(),
                      value: h,
                      selected: h == haptic,
                    ),
                  )
                  .toList(),
              fieldStyle: const M3EDropdownFieldStyle(
                hintText: 'Select Haptic Intensity',
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (items) {
                if (items.isNotEmpty && items.first.value != haptic) {
                  onHapticChanged(items.first.value);
                }
              },
            ),
            if (variant == ToolbarVariant.horizontalFab) ...[
              const Divider(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'FAB Position',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  M3EToggleButtonGroup(
                    type: M3EButtonGroupType.connected,
                    style: M3EButtonStyle.tonal,
                    size: M3EButtonSize.xs,
                    selectedIndex: horizontalFabPosition.index,
                    onSelectedIndexChanged: (idx) {
                      if (idx != null) {
                        onHorizontalFabPositionChanged(
                          M3EFloatingToolbarHorizontalFabPosition.values[idx],
                        );
                      }
                    },
                    actions: const [
                      M3EToggleButtonGroupAction(label: Text('Start')),
                      M3EToggleButtonGroupAction(label: Text('End')),
                    ],
                  ),
                ],
              ),
            ],
            if (variant == ToolbarVariant.verticalFab) ...[
              const Divider(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'FAB Position',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  M3EToggleButtonGroup(
                    type: M3EButtonGroupType.connected,
                    style: M3EButtonStyle.tonal,
                    size: M3EButtonSize.xs,
                    selectedIndex: verticalFabPosition.index,
                    onSelectedIndexChanged: (idx) {
                      if (idx != null) {
                        onVerticalFabPositionChanged(
                          M3EFloatingToolbarVerticalFabPosition.values[idx],
                        );
                      }
                    },
                    actions: const [
                      M3EToggleButtonGroupAction(label: Text('Top')),
                      M3EToggleButtonGroupAction(label: Text('Bottom')),
                    ],
                  ),
                ],
              ),
            ],
            if (isFab) ...[
              const Divider(height: 16),
              Text(
                'FAB Behavior / Action Mode',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              M3EDropdownMenu<FabActionMode>(
                key: ValueKey('fab_action_mode_$fabActionMode'),
                singleSelect: true,
                searchEnabled: false,
                items: FabActionMode.values
                    .map(
                      (m) => M3EDropdownItem<FabActionMode>(
                        label: m.label,
                        value: m,
                        selected: m == fabActionMode,
                      ),
                    )
                    .toList(),
                fieldStyle: const M3EDropdownFieldStyle(
                  hintText: 'Select FAB Action Mode',
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
                onSelectionChanged: (items) {
                  if (items.isNotEmpty && items.first.value != fabActionMode) {
                    onFabActionModeChanged(items.first.value);
                  }
                },
              ),
              if (fabActionMode == FabActionMode.customAction) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'FAB Action Icon',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      children:
                          [
                            (icon: Icons.add_rounded, name: 'add_rounded'),
                            (
                              icon: Icons.edit_note_rounded,
                              name: 'edit_note_rounded',
                            ),
                            (icon: Icons.mic_rounded, name: 'mic_rounded'),
                            (icon: Icons.send_rounded, name: 'send_rounded'),
                            (
                              icon: Icons.bookmark_add_rounded,
                              name: 'bookmark_add_rounded',
                            ),
                          ].map((item) {
                            final isSelected = customFabIcon == item.icon;
                            return GestureDetector(
                              onTap: () =>
                                  onCustomFabIconChanged(item.icon, item.name),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Icon(
                                  item.icon,
                                  size: 18,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'FAB Action Toast / Feedback Message',
                    hintText: 'e.g. Created new study deck!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  controller: TextEditingController(text: fabActionToast)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: fabActionToast.length),
                    ),
                  onChanged: onFabActionToastChanged,
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }
}
