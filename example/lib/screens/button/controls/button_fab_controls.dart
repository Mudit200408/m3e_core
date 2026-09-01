// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonFabControls extends StatelessWidget {
  const ButtonFabControls({
    super.key,
    required this.fabMode,
    required this.fabSize,
    required this.onFabSizeChanged,
    required this.fabColor,
    required this.onFabColorChanged,
    required this.fabExpanded,
    required this.onFabExpandedChanged,
    required this.fabLabel,
    required this.onFabLabelChanged,
    required this.onFabIconChanged,
    required this.fabMenuPosition,
    required this.onFabMenuPositionChanged,
    required this.fabEnabled,
    required this.onFabEnabledChanged,
    required this.customFabCornerRadius,
    required this.onCustomFabCornerRadiusChanged,
    required this.useCustomFabCornerRadius,
    required this.onUseCustomFabCornerRadiusChanged,
    required this.fabPressedScale,
    required this.onFabPressedScaleChanged,
    required this.fabMotionPreset,
    required this.onFabMotionPresetChanged,
    required this.fabMotionStiffness,
    required this.onFabMotionStiffnessChanged,
    required this.fabMotionDamping,
    required this.onFabMotionDampingChanged,
    required this.menuItemGap,
    required this.onMenuItemGapChanged,
    required this.menuOffset,
    required this.onMenuOffsetChanged,
    required this.menuItemHeight,
    required this.onMenuItemHeightChanged,
    required this.menuItemHorizontalPadding,
    required this.onMenuItemHorizontalPaddingChanged,
    required this.menuIconLabelGap,
    required this.onMenuIconLabelGapChanged,
    required this.menuItemElevation,
    required this.onMenuItemElevationChanged,
    required this.menuItemCount,
    required this.onMenuItemCountChanged,
    required this.menuExpandStaggerMs,
    required this.onMenuExpandStaggerMsChanged,
    required this.menuExpandMotionPreset,
    required this.onMenuExpandMotionPresetChanged,
    required this.menuExpandMotionStiffness,
    required this.onMenuExpandMotionStiffnessChanged,
    required this.menuExpandMotionDamping,
    required this.onMenuExpandMotionDampingChanged,
    required this.menuFabShapeMotionPreset,
    required this.onMenuFabShapeMotionPresetChanged,
    required this.menuFabShapeMotionStiffness,
    required this.onMenuFabShapeMotionStiffnessChanged,
    required this.menuFabShapeMotionDamping,
    required this.onMenuFabShapeMotionDampingChanged,
    required this.useMenuScrim,
    required this.onUseMenuScrimChanged,
    required this.menuScrimOpacity,
    required this.onMenuScrimOpacityChanged,
  });

  final FabArchitectureMode fabMode;
  final M3EFabSize fabSize;
  final ValueChanged<M3EFabSize> onFabSizeChanged;
  final M3EFabColor fabColor;
  final ValueChanged<M3EFabColor> onFabColorChanged;
  final bool fabExpanded;
  final ValueChanged<bool> onFabExpandedChanged;
  final String fabLabel;
  final ValueChanged<String> onFabLabelChanged;
  final ValueChanged<IconData> onFabIconChanged;
  final M3EFabMenuPosition fabMenuPosition;
  final ValueChanged<M3EFabMenuPosition> onFabMenuPositionChanged;
  final bool fabEnabled;
  final ValueChanged<bool> onFabEnabledChanged;
  final double customFabCornerRadius;
  final ValueChanged<double> onCustomFabCornerRadiusChanged;
  final bool useCustomFabCornerRadius;
  final ValueChanged<bool> onUseCustomFabCornerRadiusChanged;
  final double fabPressedScale;
  final ValueChanged<double> onFabPressedScaleChanged;
  final M3EExampleMotionPreset fabMotionPreset;
  final ValueChanged<M3EExampleMotionPreset> onFabMotionPresetChanged;
  final double fabMotionStiffness;
  final ValueChanged<double> onFabMotionStiffnessChanged;
  final double fabMotionDamping;
  final ValueChanged<double> onFabMotionDampingChanged;

  final double menuItemGap;
  final ValueChanged<double> onMenuItemGapChanged;
  final double menuOffset;
  final ValueChanged<double> onMenuOffsetChanged;
  final double menuItemHeight;
  final ValueChanged<double> onMenuItemHeightChanged;
  final double menuItemHorizontalPadding;
  final ValueChanged<double> onMenuItemHorizontalPaddingChanged;
  final double menuIconLabelGap;
  final ValueChanged<double> onMenuIconLabelGapChanged;
  final double menuItemElevation;
  final ValueChanged<double> onMenuItemElevationChanged;
  final int menuItemCount;
  final ValueChanged<int> onMenuItemCountChanged;
  final int menuExpandStaggerMs;
  final ValueChanged<int> onMenuExpandStaggerMsChanged;
  final M3EExampleMotionPreset menuExpandMotionPreset;
  final ValueChanged<M3EExampleMotionPreset> onMenuExpandMotionPresetChanged;
  final double menuExpandMotionStiffness;
  final ValueChanged<double> onMenuExpandMotionStiffnessChanged;
  final double menuExpandMotionDamping;
  final ValueChanged<double> onMenuExpandMotionDampingChanged;
  final M3EExampleMotionPreset menuFabShapeMotionPreset;
  final ValueChanged<M3EExampleMotionPreset> onMenuFabShapeMotionPresetChanged;
  final double menuFabShapeMotionStiffness;
  final ValueChanged<double> onMenuFabShapeMotionStiffnessChanged;
  final double menuFabShapeMotionDamping;
  final ValueChanged<double> onMenuFabShapeMotionDampingChanged;
  final bool useMenuScrim;
  final ValueChanged<bool> onUseMenuScrimChanged;
  final double menuScrimOpacity;
  final ValueChanged<double> onMenuScrimOpacityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'FAB Configuration',
          subtitle: 'Colors, sizing, animations, and actions',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            if (fabMode == FabArchitectureMode.standard) ...[
              const Text(
                'FAB Size (M3EFabSize)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabSize.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabSizeChanged(M3EFabSize.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Small (40)')),
                  M3EToggleButtonGroupAction(label: Text('Medium (56)')),
                  M3EToggleButtonGroupAction(label: Text('Large (96)')),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Color Role (M3EFabColor)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabColor.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabColorChanged(M3EFabColor.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Primary')),
                  M3EToggleButtonGroupAction(label: Text('Secondary')),
                  M3EToggleButtonGroupAction(label: Text('Tertiary')),
                  M3EToggleButtonGroupAction(label: Text('Surface')),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Icon & Action',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: switch (fabLabel) {
                  'Create' => 0,
                  'Save' => 1,
                  'Share' => 2,
                  _ => 3,
                },
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    final label = switch (i) {
                      0 => 'Create',
                      1 => 'Save',
                      2 => 'Share',
                      _ => 'Delete',
                    };
                    final icon = switch (i) {
                      0 => Icons.add_rounded,
                      1 => Icons.save_rounded,
                      2 => Icons.share_rounded,
                      _ => Icons.delete_rounded,
                    };
                    onFabLabelChanged(label);
                    onFabIconChanged(icon);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Create')),
                  M3EToggleButtonGroupAction(label: Text('Save')),
                  M3EToggleButtonGroupAction(label: Text('Share')),
                  M3EToggleButtonGroupAction(label: Text('Delete')),
                ],
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Custom Corner Radius',
                    subtitle: 'Overrides default M3E token corner radius',
                    value: useCustomFabCornerRadius,
                    onChanged: onUseCustomFabCornerRadiusChanged,
                  ),
                ],
              ),
              if (useCustomFabCornerRadius) ...[
                const SizedBox(height: 8),
                M3ESliderRow(
                  label: 'Corner Radius',
                  value: customFabCornerRadius,
                  min: 0,
                  max: 48,
                  divisions: 48,
                  onChanged: onCustomFabCornerRadiusChanged,
                ),
              ],
              const Divider(height: 16),
              M3ESliderRow(
                label: 'Press Scale (${fabPressedScale.toStringAsFixed(2)})',
                value: fabPressedScale,
                min: 0.80,
                max: 1.0,
                divisions: 20,
                onChanged: onFabPressedScaleChanged,
              ),
              const SizedBox(height: 12),
              MotionPresetControlCard(
                title: 'Press Motion Preset',
                subtitle: null,
                presetLabel: 'Motion Preset',
                selectedPreset: fabMotionPreset,
                onPresetChanged: onFabMotionPresetChanged,
                stiffness: fabMotionStiffness,
                onStiffnessChanged: onFabMotionStiffnessChanged,
                damping: fabMotionDamping,
                onDampingChanged: onFabMotionDampingChanged,
                minStiffness: 100,
                maxStiffness: 800,
                stiffnessDivisions: 70,
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'FAB Enabled',
                    value: fabEnabled,
                    onChanged: onFabEnabledChanged,
                  ),
                ],
              ),
            ] else if (fabMode == FabArchitectureMode.extended) ...[
              const Text(
                'Extended FAB Size (M3EFabSize)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabSize.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabSizeChanged(M3EFabSize.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Small (40)')),
                  M3EToggleButtonGroupAction(label: Text('Medium (56)')),
                  M3EToggleButtonGroupAction(label: Text('Large (96)')),
                ],
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Show text label (Extended)',
                    subtitle: 'Spring-animates the label beside the icon',
                    value: fabExpanded,
                    onChanged: onFabExpandedChanged,
                  ),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Color Role (M3EFabColor)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabColor.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabColorChanged(M3EFabColor.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Primary')),
                  M3EToggleButtonGroupAction(label: Text('Secondary')),
                  M3EToggleButtonGroupAction(label: Text('Tertiary')),
                  M3EToggleButtonGroupAction(label: Text('Surface')),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Label & Icon Action',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: switch (fabLabel) {
                  'Create' => 0,
                  'Save' => 1,
                  'Share' => 2,
                  _ => 3,
                },
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    final label = switch (i) {
                      0 => 'Create',
                      1 => 'Save',
                      2 => 'Share',
                      _ => 'Delete',
                    };
                    final icon = switch (i) {
                      0 => Icons.add_rounded,
                      1 => Icons.save_rounded,
                      2 => Icons.share_rounded,
                      _ => Icons.delete_rounded,
                    };
                    onFabLabelChanged(label);
                    onFabIconChanged(icon);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Create')),
                  M3EToggleButtonGroupAction(label: Text('Save')),
                  M3EToggleButtonGroupAction(label: Text('Share')),
                  M3EToggleButtonGroupAction(label: Text('Delete')),
                ],
              ),
              const Divider(height: 16),
              M3ESliderRow(
                label: 'Press Scale (${fabPressedScale.toStringAsFixed(2)})',
                value: fabPressedScale,
                min: 0.80,
                max: 1.0,
                divisions: 20,
                onChanged: onFabPressedScaleChanged,
              ),
              const SizedBox(height: 12),
              MotionPresetControlCard(
                title: 'Press Motion Preset',
                subtitle: null,
                presetLabel: 'Motion Preset',
                selectedPreset: fabMotionPreset,
                onPresetChanged: onFabMotionPresetChanged,
                stiffness: fabMotionStiffness,
                onStiffnessChanged: onFabMotionStiffnessChanged,
                damping: fabMotionDamping,
                onDampingChanged: onFabMotionDampingChanged,
                minStiffness: 100,
                maxStiffness: 800,
                stiffnessDivisions: 70,
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'FAB Enabled',
                    value: fabEnabled,
                    onChanged: onFabEnabledChanged,
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'Menu Position (M3EFabMenuPosition)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabMenuPosition.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabMenuPositionChanged(M3EFabMenuPosition.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Left')),
                  M3EToggleButtonGroupAction(label: Text('Right')),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Trigger FAB Size (M3EFabSize)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabSize.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabSizeChanged(M3EFabSize.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Small (40)')),
                  M3EToggleButtonGroupAction(label: Text('Medium (56)')),
                  M3EToggleButtonGroupAction(label: Text('Large (96)')),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Trigger FAB Color (M3EFabColor)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: fabColor.index,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onFabColorChanged(M3EFabColor.values[i]);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('Primary')),
                  M3EToggleButtonGroupAction(label: Text('Secondary')),
                  M3EToggleButtonGroupAction(label: Text('Tertiary')),
                  M3EToggleButtonGroupAction(label: Text('Surface')),
                ],
              ),
              const Divider(height: 20),
              const Text(
                'Menu Item Count',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              M3EToggleButtonGroup(
                type: M3EButtonGroupType.connected,
                style: M3EButtonStyle.outlined,
                size: M3EButtonSize.xs,
                selectedIndex: menuItemCount - 2,
                onSelectedIndexChanged: (i) {
                  if (i != null) {
                    onMenuItemCountChanged(i + 2);
                  }
                },
                actions: const [
                  M3EToggleButtonGroupAction(label: Text('2')),
                  M3EToggleButtonGroupAction(label: Text('3')),
                  M3EToggleButtonGroupAction(label: Text('4')),
                  M3EToggleButtonGroupAction(label: Text('5')),
                  M3EToggleButtonGroupAction(label: Text('6')),
                ],
              ),
            ],
          ],
        ),
        if (fabMode == FabArchitectureMode.menu) ...[
          const ControlSectionHeader(
            title: 'Menu Geometry & Layout',
            subtitle: 'Offsets, gaps, dimensions, elevations, and scrim',
            icon: Icons.aspect_ratio_rounded,
          ),
          ControlCard(
            children: [
              M3ESliderRow(
                label: 'Menu Offset (${menuOffset.toStringAsFixed(0)}dp)',
                value: menuOffset,
                min: 0,
                max: 32,
                divisions: 32,
                onChanged: onMenuOffsetChanged,
              ),
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Item Gap (${menuItemGap.toStringAsFixed(0)}dp)',
                value: menuItemGap,
                min: 2,
                max: 24,
                divisions: 22,
                onChanged: onMenuItemGapChanged,
              ),
              const SizedBox(height: 8),
              M3ESliderRow(
                label: 'Item Height (${menuItemHeight.toStringAsFixed(0)}dp)',
                value: menuItemHeight,
                min: 40,
                max: 72,
                divisions: 32,
                onChanged: onMenuItemHeightChanged,
              ),
              const SizedBox(height: 8),
              M3ESliderRow(
                label:
                    'Horizontal Padding (${menuItemHorizontalPadding.toStringAsFixed(0)}dp)',
                value: menuItemHorizontalPadding,
                min: 8,
                max: 32,
                divisions: 24,
                onChanged: onMenuItemHorizontalPaddingChanged,
              ),
              const SizedBox(height: 8),
              M3ESliderRow(
                label:
                    'Icon-to-Label Gap (${menuIconLabelGap.toStringAsFixed(0)}dp)',
                value: menuIconLabelGap,
                min: 4,
                max: 24,
                divisions: 20,
                onChanged: onMenuIconLabelGapChanged,
              ),
              const SizedBox(height: 8),
              M3ESliderRow(
                label:
                    'Item Elevation (${menuItemElevation.toStringAsFixed(0)}dp)',
                value: menuItemElevation,
                min: 0,
                max: 12,
                divisions: 12,
                onChanged: onMenuItemElevationChanged,
              ),
              const Divider(height: 16),
              M3ESegmentedSwitchGroup(
                items: [
                  M3ESwitchItem(
                    title: 'Background Scrim Overlay',
                    subtitle: 'Darkens the background when menu opens',
                    value: useMenuScrim,
                    onChanged: onUseMenuScrimChanged,
                  ),
                ],
              ),
              if (useMenuScrim) ...[
                const SizedBox(height: 8),
                M3ESliderRow(
                  label:
                      'Scrim Opacity (${(menuScrimOpacity * 100).toStringAsFixed(0)}%)',
                  value: menuScrimOpacity,
                  min: 0.1,
                  max: 0.8,
                  divisions: 14,
                  onChanged: onMenuScrimOpacityChanged,
                ),
              ],
            ],
          ),
          const ControlSectionHeader(
            title: 'Menu Spring Physics & Stagger',
            subtitle: 'Configure motion curves and reveal timing',
            icon: Icons.animation_rounded,
          ),
          ControlCard(
            children: [
              M3ESliderRow(
                label: 'Stagger Delay (${menuExpandStaggerMs}ms)',
                value: menuExpandStaggerMs.toDouble(),
                min: 10,
                max: 100,
                divisions: 18,
                onChanged: (v) => onMenuExpandStaggerMsChanged(v.round()),
              ),
              const SizedBox(height: 12),
              MotionPresetControlCard(
                title: 'Item Expand Motion Preset',
                subtitle: null,
                presetLabel: 'Motion Preset',
                selectedPreset: menuExpandMotionPreset,
                onPresetChanged: onMenuExpandMotionPresetChanged,
                stiffness: menuExpandMotionStiffness,
                onStiffnessChanged: onMenuExpandMotionStiffnessChanged,
                damping: menuExpandMotionDamping,
                onDampingChanged: onMenuExpandMotionDampingChanged,
                minStiffness: 100,
                maxStiffness: 800,
                stiffnessDivisions: 70,
              ),
              const SizedBox(height: 16),
              MotionPresetControlCard(
                title: 'FAB Shape Morph Motion Preset',
                subtitle: null,
                presetLabel: 'Motion Preset',
                selectedPreset: menuFabShapeMotionPreset,
                onPresetChanged: onMenuFabShapeMotionPresetChanged,
                stiffness: menuFabShapeMotionStiffness,
                onStiffnessChanged: onMenuFabShapeMotionStiffnessChanged,
                damping: menuFabShapeMotionDamping,
                onDampingChanged: onMenuFabShapeMotionDampingChanged,
                minStiffness: 100,
                maxStiffness: 800,
                stiffnessDivisions: 70,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
