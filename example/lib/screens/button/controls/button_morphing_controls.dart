// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonMorphingControls extends StatelessWidget {
  const ButtonMorphingControls({
    super.key,
    required this.architecture,
    required this.restingBorderRadius,
    required this.onRestingBorderRadiusChanged,
    required this.pressedRadius,
    required this.onPressedRadiusChanged,
    required this.hoveredRadius,
    required this.onHoveredRadiusChanged,
    required this.checkedRadius,
    required this.onCheckedRadiusChanged,
    required this.elevation,
    required this.onElevationChanged,
    required this.mouseCursor,
    required this.onMouseCursorChanged,
    required this.motionPreset,
    required this.onMotionPresetChanged,
    required this.motionStiffness,
    required this.onMotionStiffnessChanged,
    required this.motionDamping,
    required this.onMotionDampingChanged,
    required this.haptic,
    required this.onHapticChanged,
  });

  final ButtonArchitecture architecture;
  final double restingBorderRadius;
  final ValueChanged<double> onRestingBorderRadiusChanged;
  final double pressedRadius;
  final ValueChanged<double> onPressedRadiusChanged;
  final double hoveredRadius;
  final ValueChanged<double> onHoveredRadiusChanged;
  final double checkedRadius;
  final ValueChanged<double> onCheckedRadiusChanged;
  final double elevation;
  final ValueChanged<double> onElevationChanged;
  final MouseCursor mouseCursor;
  final ValueChanged<MouseCursor> onMouseCursorChanged;
  final M3EExampleMotionPreset motionPreset;
  final ValueChanged<M3EExampleMotionPreset> onMotionPresetChanged;
  final double motionStiffness;
  final ValueChanged<double> onMotionStiffnessChanged;
  final double motionDamping;
  final ValueChanged<double> onMotionDampingChanged;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EHapticFeedback> onHapticChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Morphing & Spring Physics',
          subtitle:
              'Resting radius overrides, touch-down morphing, elevations, and spring tokens',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Resting Border Radius Override',
              value: restingBorderRadius,
              min: 0,
              max: 32,
              divisions: 32,
              format: (v) => v == 0 ? 'Default' : '${v.toStringAsFixed(0)} dp',
              onChanged: onRestingBorderRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Pressed Morph Radius',
              value: pressedRadius,
              min: 0,
              max: 32,
              divisions: 32,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onPressedRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Hovered Morph Radius',
              value: hoveredRadius,
              min: 0,
              max: 32,
              divisions: 32,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onHoveredRadiusChanged,
            ),
            if (architecture == ButtonArchitecture.group ||
                architecture == ButtonArchitecture.toggle)
              M3ESliderRow(
                label: 'Checked Corner Radius',
                value: checkedRadius,
                min: 0,
                max: 32,
                divisions: 32,
                format: (v) => v.toStringAsFixed(0),
                onChanged: onCheckedRadiusChanged,
              ),
            M3ESliderRow(
              label: 'Resting Elevation',
              value: elevation,
              min: 0,
              max: 12,
              divisions: 12,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onElevationChanged,
            ),
            const Divider(height: 16),
            const Text(
              'Mouse Cursor (mouseCursor)',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: ButtonPlaygroundOptions.mouseCursors.indexOf(
                mouseCursor,
              ),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onMouseCursorChanged(ButtonPlaygroundOptions.mouseCursors[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Click')),
                M3EToggleButtonGroupAction(label: Text('Grab')),
                M3EToggleButtonGroupAction(label: Text('Zoom')),
                M3EToggleButtonGroupAction(label: Text('Copy')),
                M3EToggleButtonGroupAction(label: Text('Forbidden')),
              ],
            ),
            const Divider(height: 16),
            MotionPresetControlCard(
              title: 'Spring Motion Preset (M3EMotion)',
              subtitle: null,
              presetLabel: 'Motion Preset',
              selectedPreset: motionPreset,
              onPresetChanged: onMotionPresetChanged,
              stiffness: motionStiffness,
              onStiffnessChanged: onMotionStiffnessChanged,
              damping: motionDamping,
              onDampingChanged: onMotionDampingChanged,
              minStiffness: 100,
              maxStiffness: 3000,
              stiffnessDivisions: 29,
            ),
            const Divider(height: 16),
            const Text(
              'Haptic Feedback Preset (M3EHapticFeedback)',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            const SizedBox(height: 6),
            M3EDropdownMenu<M3EHapticFeedback>(
              key: ValueKey('haptic_$haptic'),
              singleSelect: true,
              searchEnabled: false,
              items: const [
                M3EDropdownItem(label: 'NONE', value: M3EHapticFeedback.none),
                M3EDropdownItem(
                  label: 'LIGHT IMPACT',
                  value: M3EHapticFeedback.light,
                ),
                M3EDropdownItem(
                  label: 'MEDIUM IMPACT',
                  value: M3EHapticFeedback.medium,
                ),
                M3EDropdownItem(
                  label: 'HEAVY IMPACT',
                  value: M3EHapticFeedback.heavy,
                ),
              ],
              fieldStyle: const M3EDropdownFieldStyle(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                hintText: 'Select Haptic Preset',
              ),
              dropdownStyle: const M3EDropdownStyle(containerRadius: 16),
              onSelectionChanged: (selectedItems) {
                if (selectedItems.isNotEmpty &&
                    selectedItems.first.value != haptic) {
                  onHapticChanged(selectedItems.first.value);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
