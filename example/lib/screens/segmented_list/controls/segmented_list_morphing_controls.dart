// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class SegmentedListMorphingControls extends StatelessWidget {
  const SegmentedListMorphingControls({
    super.key,
    required this.pressedRadius,
    required this.onPressedRadiusChanged,
    required this.pressedScale,
    required this.onPressedScaleChanged,
    required this.hoveredRadius,
    required this.onHoveredRadiusChanged,
    required this.restingMotionPreset,
    required this.onRestingMotionPresetChanged,
    required this.restingStiffness,
    required this.onRestingStiffnessChanged,
    required this.restingDamping,
    required this.onRestingDampingChanged,
    required this.pressedMotionPreset,
    required this.onPressedMotionPresetChanged,
    required this.pressedStiffness,
    required this.onPressedStiffnessChanged,
    required this.pressedDamping,
    required this.onPressedDampingChanged,
    this.isExpandable = false,
    this.expandMotionPreset = M3EExampleMotionPreset.expressiveSpatialFast,
    this.onExpandMotionPresetChanged,
    this.expandStiffness = 800,
    this.onExpandStiffnessChanged,
    this.expandDamping = 0.6,
    this.onExpandDampingChanged,
    this.collapseMotionPreset = M3EExampleMotionPreset.expressiveSpatialFast,
    this.onCollapseMotionPresetChanged,
    this.collapseStiffness = 800,
    this.onCollapseStiffnessChanged,
    this.collapseDamping = 0.6,
    this.onCollapseDampingChanged,
  });

  final double pressedRadius;
  final ValueChanged<double> onPressedRadiusChanged;
  final double pressedScale;
  final ValueChanged<double> onPressedScaleChanged;
  final double hoveredRadius;
  final ValueChanged<double> onHoveredRadiusChanged;
  final M3EExampleMotionPreset restingMotionPreset;
  final ValueChanged<M3EExampleMotionPreset> onRestingMotionPresetChanged;
  final double restingStiffness;
  final ValueChanged<double> onRestingStiffnessChanged;
  final double restingDamping;
  final ValueChanged<double> onRestingDampingChanged;
  final M3EExampleMotionPreset pressedMotionPreset;
  final ValueChanged<M3EExampleMotionPreset> onPressedMotionPresetChanged;
  final double pressedStiffness;
  final ValueChanged<double> onPressedStiffnessChanged;
  final double pressedDamping;
  final ValueChanged<double> onPressedDampingChanged;

  final bool isExpandable;
  final M3EExampleMotionPreset expandMotionPreset;
  final ValueChanged<M3EExampleMotionPreset>? onExpandMotionPresetChanged;
  final double expandStiffness;
  final ValueChanged<double>? onExpandStiffnessChanged;
  final double expandDamping;
  final ValueChanged<double>? onExpandDampingChanged;
  final M3EExampleMotionPreset collapseMotionPreset;
  final ValueChanged<M3EExampleMotionPreset>? onCollapseMotionPresetChanged;
  final double collapseStiffness;
  final ValueChanged<double>? onCollapseStiffnessChanged;
  final double collapseDamping;
  final ValueChanged<double>? onCollapseDampingChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Interactive Morphing',
          subtitle: 'Press and hover corner morphing parameters',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
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
              label: 'Pressed Content Scale',
              value: pressedScale,
              min: 0.85,
              max: 1.0,
              divisions: 15,
              format: (v) => v.toStringAsFixed(2),
              onChanged: onPressedScaleChanged,
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
          ],
        ),
        const ControlSectionHeader(
          title: 'Spring Motion Physics',
          subtitle:
              'Spring tokens for expansion, collapse, and touch-down morph transitions',
          icon: Icons.animation_rounded,
        ),
        ControlCard(
          children: [
            if (isExpandable) ...[
              MotionPresetControlCard(
                title: 'Expansion Motion',
                subtitle: 'Spring physics when expanding container',
                presetLabel: 'Expand Motion',
                selectedPreset: expandMotionPreset,
                onPresetChanged: (preset) =>
                    onExpandMotionPresetChanged?.call(preset),
                stiffness: expandStiffness,
                onStiffnessChanged: (val) =>
                    onExpandStiffnessChanged?.call(val),
                damping: expandDamping,
                onDampingChanged: (val) => onExpandDampingChanged?.call(val),
                minStiffness: 100,
                maxStiffness: 3000,
                stiffnessDivisions: 29,
              ),
              const SizedBox(height: 12),
              MotionPresetControlCard(
                title: 'Collapse Motion',
                subtitle: 'Spring physics when collapsing container',
                presetLabel: 'Collapse Motion',
                selectedPreset: collapseMotionPreset,
                onPresetChanged: (preset) =>
                    onCollapseMotionPresetChanged?.call(preset),
                stiffness: collapseStiffness,
                onStiffnessChanged: (val) =>
                    onCollapseStiffnessChanged?.call(val),
                damping: collapseDamping,
                onDampingChanged: (val) => onCollapseDampingChanged?.call(val),
                minStiffness: 100,
                maxStiffness: 3000,
                stiffnessDivisions: 29,
              ),
            ] else ...[
              MotionPresetControlCard(
                title: 'Resting & Selection Motion',
                subtitle: null,
                presetLabel: 'Resting Motion',
                selectedPreset: restingMotionPreset,
                onPresetChanged: onRestingMotionPresetChanged,
                stiffness: restingStiffness,
                onStiffnessChanged: onRestingStiffnessChanged,
                damping: restingDamping,
                onDampingChanged: onRestingDampingChanged,
                minStiffness: 100,
                maxStiffness: 3000,
                stiffnessDivisions: 29,
              ),
            ],
            const SizedBox(height: 12),
            MotionPresetControlCard(
              title: 'Pressed Motion (Touch-Down)',
              subtitle: null,
              presetLabel: 'Pressed Motion',
              selectedPreset: pressedMotionPreset,
              onPresetChanged: onPressedMotionPresetChanged,
              stiffness: pressedStiffness,
              onStiffnessChanged: onPressedStiffnessChanged,
              damping: pressedDamping,
              onDampingChanged: onPressedDampingChanged,
              minStiffness: 100,
              maxStiffness: 4000,
              stiffnessDivisions: 39,
            ),
          ],
        ),
      ],
    );
  }
}
