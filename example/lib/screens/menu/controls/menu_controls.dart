// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

import '../../../shared/shared.dart';
import '../models/menu_models.dart';

/// Control panels exposing 100% of M3EMenu features and configurations.
/// Selectable values for the popup menu `initialValue` playground knob.
const List<String?> _kInitialValueOptions = <String?>[
  null,
  'cut',
  'copy',
  'paste',
  'wrap',
];

class MenuControls extends StatelessWidget {
  final MenuPlaygroundState state;
  final ValueChanged<VoidCallback> updateState;

  const MenuControls({
    super.key,
    required this.state,
    required this.updateState,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPopup = state.useCase == MenuUseCase.popupButton;
    final bool hasSelection =
        state.useCase == MenuUseCase.preferences ||
        state.useCase == MenuUseCase.multiSection;
    final bool supportsIcons =
        state.useCase == MenuUseCase.actions ||
        state.useCase == MenuUseCase.cascading ||
        state.useCase == MenuUseCase.multiSection;
    final bool supportsShortcuts =
        state.useCase == MenuUseCase.actions ||
        state.useCase == MenuUseCase.cascading ||
        state.useCase == MenuUseCase.multiSection;
    final bool supportsSupportingText =
        state.useCase == MenuUseCase.actions ||
        state.useCase == MenuUseCase.preferences ||
        state.useCase == MenuUseCase.multiSection;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Menu Scenario / Use Case
        const ControlSectionHeader(
          title: 'Menu Scenario & Architecture',
          subtitle: 'Choose between separated expressive menu use cases',
          icon: Icons.category_rounded,
        ),
        ControlCard(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex: state.useCase.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    updateState(() => state.useCase = MenuUseCase.values[i]);
                  }
                },
                actions: MenuUseCase.values
                    .map(
                      (u) => M3EToggleButtonGroupAction(
                        icon: Icon(u.icon),
                        label: Text(u.label),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),

        // Preferences Scenario Controls
        if (state.useCase == MenuUseCase.preferences) ...[
          const ControlSectionHeader(
            title: 'Preferences Configuration',
            subtitle: 'Selection behavior and indicator presentation',
            icon: Icons.tune_rounded,
          ),
          ControlCard(
            children: [
              Text(
                'Selection Mode',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: M3EToggleButtonGroup(
                  type: M3EButtonGroupType.connected,
                  style: M3EButtonStyle.tonal,
                  size: M3EButtonSize.sm,
                  selectedIndex: state.preferencesSelectionMode.index,
                  onSelectedIndexChanged: (i) {
                    if (i != null) {
                      updateState(
                        () => state.preferencesSelectionMode =
                            PreferencesSelectionMode.values[i],
                      );
                    }
                  },
                  actions: PreferencesSelectionMode.values
                      .map(
                        (m) => M3EToggleButtonGroupAction(label: Text(m.label)),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Indicator Presentation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: M3EToggleButtonGroup(
                  type: M3EButtonGroupType.connected,
                  style: M3EButtonStyle.tonal,
                  size: M3EButtonSize.sm,
                  selectedIndex: state.preferencesIndicatorStyle.index,
                  onSelectedIndexChanged: (i) {
                    if (i != null) {
                      updateState(
                        () => state.preferencesIndicatorStyle =
                            PreferencesIndicatorStyle.values[i],
                      );
                    }
                  },
                  actions: PreferencesIndicatorStyle.values
                      .map(
                        (s) => M3EToggleButtonGroupAction(
                          icon: Icon(s.icon),
                          label: Text(s.label),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],

        // 2. Color Scheme Variant
        const ControlSectionHeader(
          title: 'Color Scheme Variant',
          subtitle:
              'M3 Expressive standard surface vs tertiary vibrant styling',
          icon: Icons.palette_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex:
                  state.colorSchemeVariant == M3EMenuColorSchemeVariant.standard
                  ? 0
                  : 1,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  updateState(
                    () => state.colorSchemeVariant = i == 0
                        ? M3EMenuColorSchemeVariant.standard
                        : M3EMenuColorSchemeVariant.vibrant,
                  );
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  icon: Icon(Icons.contrast_rounded),
                  label: Text('Standard (Surface)'),
                ),
                M3EToggleButtonGroupAction(
                  icon: Icon(Icons.auto_awesome_rounded),
                  label: Text('Vibrant (Tertiary)'),
                ),
              ],
            ),
          ],
        ),

        // 3. Reveal Animation Style
        const ControlSectionHeader(
          title: 'Reveal Animation',
          subtitle:
              'Jetpack Compose popup scale vs M3E dropdown vertical reveal',
          icon: Icons.animation_rounded,
        ),
        ControlCard(
          children: [
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.tonal,
              size: M3EButtonSize.sm,
              selectedIndex: state.animationStyle == M3EMenuAnimationStyle.popup
                  ? 0
                  : 1,
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  updateState(
                    () => state.animationStyle = i == 0
                        ? M3EMenuAnimationStyle.popup
                        : M3EMenuAnimationStyle.dropdown,
                  );
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(
                  icon: Icon(Icons.open_in_full_rounded),
                  label: Text('Popup'),
                ),
                M3EToggleButtonGroupAction(
                  icon: Icon(Icons.unfold_more_rounded),
                  label: Text('Dropdown'),
                ),
              ],
            ),
          ],
        ),

        // 4. Spring Motion Physics
        MotionPresetControlCard(
          title: 'Spring Physics & Motion',
          subtitle:
              'Motor spring physics driving popup entrance/exit and checkmarks',
          presetLabel: 'Motion Preset',
          selectedPreset: state.motionPreset,
          onPresetChanged: (preset) =>
              updateState(() => state.motionPreset = preset),
          stiffness: state.spatialStiffness,
          onStiffnessChanged: (val) =>
              updateState(() => state.spatialStiffness = val),
          damping: state.spatialDamping,
          onDampingChanged: (val) =>
              updateState(() => state.spatialDamping = val),
          minStiffness: 100,
          maxStiffness: 1600,
        ),

        // 5. Layout & Content Options
        const ControlSectionHeader(
          title: 'Layout & Elements',
          subtitle: 'Segmented grouping and content slots',
          icon: Icons.view_agenda_rounded,
        ),
        ControlCard(
          children: [
            if (!isPopup) ...[
              SwitchControlRow(
                title: 'Segmented Groups',
                subtitle:
                    'Group related actions with 2dp gaps and corner morphing',
                value: state.showGroups,
                onChanged: (val) => updateState(() => state.showGroups = val),
              ),
              const SizedBox(height: 8),
            ],
            if (supportsIcons) ...[
              SwitchControlRow(
                title: 'Leading Icons',
                subtitle: 'Show leading action icons',
                value: state.showIcons,
                onChanged: (val) => updateState(() => state.showIcons = val),
              ),
              const SizedBox(height: 8),
            ],
            if (supportsShortcuts) ...[
              SwitchControlRow(
                title: 'Trailing Shortcuts',
                subtitle: 'Show keyboard shortcuts (⌘S, ⌘C, etc.)',
                value: state.showShortcuts,
                onChanged: (val) =>
                    updateState(() => state.showShortcuts = val),
              ),
              const SizedBox(height: 8),
            ],
            if (supportsSupportingText) ...[
              SwitchControlRow(
                title: 'Supporting Text',
                subtitle: 'Show secondary descriptions under labels',
                value: state.showSupportingText,
                onChanged: (val) =>
                    updateState(() => state.showSupportingText = val),
              ),
              const SizedBox(height: 8),
            ],
            SwitchControlRow(
              title: 'Items Enabled',
              subtitle:
                  'Toggle active vs disabled state styling and interactions',
              value: state.enabled,
              onChanged: (val) => updateState(() => state.enabled = val),
            ),
            if (!isPopup) ...[
              const SizedBox(height: 8),
              SwitchControlRow(
                title: 'Custom Item Style',
                subtitle:
                    'Demonstrate M3EMenuItemStyle with custom padding, colors, and shapes',
                value: state.useCustomItemStyle,
                onChanged: (val) =>
                    updateState(() => state.useCustomItemStyle = val),
              ),
              if (state.useCustomItemStyle) ...[
                const Divider(height: 16),
                M3ESliderRow(
                  label: 'Horizontal Padding',
                  value: state.itemHorizontalPadding,
                  min: 8,
                  max: 28,
                  divisions: 10,
                  format: (val) => '${val.toStringAsFixed(0)}dp',
                  onChanged: (val) =>
                      updateState(() => state.itemHorizontalPadding = val),
                ),
                const SizedBox(height: 8),
                M3ESliderRow(
                  label: 'Vertical Padding',
                  value: state.itemVerticalPadding,
                  min: 4,
                  max: 20,
                  divisions: 8,
                  format: (val) => '${val.toStringAsFixed(0)}dp',
                  onChanged: (val) =>
                      updateState(() => state.itemVerticalPadding = val),
                ),
                if (hasSelection) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Selected Color Preset',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: M3EToggleButtonGroup(
                      type: M3EButtonGroupType.connected,
                      style: M3EButtonStyle.tonal,
                      size: M3EButtonSize.sm,
                      selectedIndex: state.itemColorPreset.index,
                      onSelectedIndexChanged: (i) {
                        if (i != null) {
                          updateState(
                            () => state.itemColorPreset =
                                MenuItemColorPreset.values[i],
                          );
                        }
                      },
                      actions: MenuItemColorPreset.values
                          .map(
                            (c) => M3EToggleButtonGroupAction(
                              label: Text(c.label),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                SwitchControlRow(
                  title: 'Morph Shape on Select',
                  subtitle: hasSelection
                      ? 'Smoothly morphs corner radii when item is selected'
                      : 'Smoothly morphs corner radii when item is hovered or pressed',
                  value: state.itemMorphShapeOnSelect,
                  onChanged: (val) =>
                      updateState(() => state.itemMorphShapeOnSelect = val),
                ),
              ],
            ],
          ],
        ),

        // 6. Anchor Placement & Offset
        const ControlSectionHeader(
          title: 'Anchor Placement & Offset',
          subtitle:
              'Test directional placement (top/bottom/left/right) and alignment offsets',
          icon: Icons.open_with_rounded,
        ),
        ControlCard(
          children: [
            Text(
              'Canvas Placement',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            _buildAnchorGrid(context),
            const SizedBox(height: 12),
            M3ESliderRow(
              label: 'Offset X',
              value: state.alignmentOffsetX,
              min: -60,
              max: 60,
              divisions: 24,
              format: (val) => '${val.toStringAsFixed(0)}dp',
              onChanged: (val) =>
                  updateState(() => state.alignmentOffsetX = val),
            ),
            const SizedBox(height: 8),
            M3ESliderRow(
              label: 'Offset Y',
              value: state.alignmentOffsetY,
              min: -60,
              max: 60,
              divisions: 24,
              format: (val) => '${val.toStringAsFixed(0)}dp',
              onChanged: (val) =>
                  updateState(() => state.alignmentOffsetY = val),
            ),
          ],
        ),

        // 7. Popup Menu Button (only relevant to the Popup Button scenario)
        if (state.useCase == MenuUseCase.popupButton) ...[
          const ControlSectionHeader(
            title: 'Popup Menu Button',
            subtitle:
                'Trigger, initialValue highlight, focus and interaction state',
            icon: Icons.more_vert_rounded,
          ),
          ControlCard(
            children: [
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex: state.menuPosition == M3EMenuPosition.under
                    ? 0
                    : 1,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    updateState(
                      () => state.menuPosition = i == 0
                          ? M3EMenuPosition.under
                          : M3EMenuPosition.over,
                    );
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(
                    icon: Icon(Icons.vertical_align_bottom_rounded),
                    label: Text('Under (M3E default)'),
                  ),
                  M3EToggleButtonGroupAction(
                    icon: Icon(Icons.center_focus_strong_rounded),
                    label: Text('Over'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchControlRow(
                title: 'Icon Trigger',
                subtitle:
                    'Off renders a labelled M3EButton instead of the overflow icon',
                value: state.triggerAsIcon,
                onChanged: (val) =>
                    updateState(() => state.triggerAsIcon = val),
              ),
              if (state.triggerAsIcon) ...[
                const SizedBox(height: 8),
                M3ESliderRow(
                  label: 'Icon Size',
                  value: state.triggerIconSize,
                  min: 16,
                  max: 40,
                  divisions: 12,
                  format: (val) => val.toStringAsFixed(0),
                  onChanged: (val) =>
                      updateState(() => state.triggerIconSize = val),
                ),
              ],
              const SizedBox(height: 8),
              SwitchControlRow(
                title: 'Enabled',
                subtitle: 'Disabled trigger blocks the menu entirely',
                value: state.popupEnabled,
                onChanged: (val) => updateState(() => state.popupEnabled = val),
              ),
              const SizedBox(height: 8),
              SwitchControlRow(
                title: 'Request Focus',
                subtitle: 'Autofocus the popup scope on open',
                value: state.popupRequestFocus,
                onChanged: (val) =>
                    updateState(() => state.popupRequestFocus = val),
              ),
              const SizedBox(height: 8),
              SwitchControlRow(
                title: 'Checked Entry',
                subtitle: 'Toggles the M3ECheckedPopupMenuItem state',
                value: state.showCheckedEntry,
                onChanged: (val) =>
                    updateState(() => state.showCheckedEntry = val),
              ),
              const SizedBox(height: 12),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.tonal,
                size: M3EButtonSize.sm,
                selectedIndex: _kInitialValueOptions.indexOf(
                  state.popupInitialValue,
                ),
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    updateState(
                      () => state.popupInitialValue = _kInitialValueOptions[i],
                    );
                  }
                },
                actions: [
                  for (final String? option in _kInitialValueOptions)
                    M3EToggleButtonGroupAction(label: Text(option ?? 'None')),
                ],
              ),
            ],
          ),
        ],

        // 8. Dimensions & Interaction
        const ControlSectionHeader(
          title: 'Dimensions & Interaction',
          subtitle: 'Width bounds, elevation, and outside tap behavior',
          icon: Icons.straighten_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Elevation',
              value: state.elevation,
              min: 0,
              max: 12,
              divisions: 12,
              format: (val) => val.toStringAsFixed(1),
              onChanged: (val) => updateState(() => state.elevation = val),
            ),
            const SizedBox(height: 8),
            M3ESliderRow(
              label: 'Min Width',
              value: state.minWidth,
              min: 140,
              max: 240,
              divisions: 10,
              format: (val) => '${val.toStringAsFixed(0)}dp',
              onChanged: (val) => updateState(() => state.minWidth = val),
            ),
            const SizedBox(height: 8),
            M3ESliderRow(
              label: 'Max Width',
              value: state.maxWidth,
              min: 260,
              max: 420,
              divisions: 16,
              format: (val) => '${val.toStringAsFixed(0)}dp',
              onChanged: (val) => updateState(() => state.maxWidth = val),
            ),
            const SizedBox(height: 8),
            SwitchControlRow(
              title: 'Constrain Max Height',
              subtitle: 'Limit menu height to test scrollability on long lists',
              value: state.enableMaxHeight,
              onChanged: (val) =>
                  updateState(() => state.enableMaxHeight = val),
            ),
            if (state.enableMaxHeight) ...[
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Max Height',
                value: state.maxHeight,
                min: 160,
                max: 400,
                divisions: 12,
                format: (val) => '${val.toStringAsFixed(0)}dp',
                onChanged: (val) => updateState(() => state.maxHeight = val),
              ),
            ],
            if (!isPopup) ...[
              const SizedBox(height: 12),
              SwitchControlRow(
                title: 'Consume Outside Taps',
                subtitle: 'Block background gestures on outside dismissal',
                value: state.consumeOutsideTaps,
                onChanged: (val) =>
                    updateState(() => state.consumeOutsideTaps = val),
              ),
              const SizedBox(height: 8),
              SwitchControlRow(
                title: 'Anchor Tap Closes Menu',
                subtitle: 'Tapping the anchor button toggles the menu closed',
                value: state.anchorTapClosesMenu,
                onChanged: (val) =>
                    updateState(() => state.anchorTapClosesMenu = val),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAnchorGrid(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rows = [
      [
        (MenuAnchorPosition.topLeft, Icons.north_west_rounded, 'Top-Left'),
        (MenuAnchorPosition.topCenter, Icons.north_rounded, 'Top'),
        (MenuAnchorPosition.topRight, Icons.north_east_rounded, 'Top-Right'),
      ],
      [
        (MenuAnchorPosition.centerLeft, Icons.west_rounded, 'Left'),
        (
          MenuAnchorPosition.center,
          Icons.filter_center_focus_rounded,
          'Center',
        ),
        (MenuAnchorPosition.centerRight, Icons.east_rounded, 'Right'),
      ],
      [
        (
          MenuAnchorPosition.bottomLeft,
          Icons.south_west_rounded,
          'Bottom-Left',
        ),
        (MenuAnchorPosition.bottomCenter, Icons.south_rounded, 'Bottom'),
        (
          MenuAnchorPosition.bottomRight,
          Icons.south_east_rounded,
          'Bottom-Right',
        ),
      ],
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: row.map((item) {
              final isSelected = state.anchorPosition == item.$1;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Material(
                    color: isSelected
                        ? cs.primaryContainer
                        : cs.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () =>
                          updateState(() => state.anchorPosition = item.$1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.$2,
                              size: 14,
                              color: isSelected
                                  ? cs.onPrimaryContainer
                                  : cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.$3,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? cs.onPrimaryContainer
                                    : cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
