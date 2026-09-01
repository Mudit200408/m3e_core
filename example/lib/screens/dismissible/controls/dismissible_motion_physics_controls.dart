// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class DismissibleMotionPhysicsControls extends StatelessWidget {
  const DismissibleMotionPhysicsControls({
    super.key,
    required this.snapBackPreset,
    required this.onSnapBackPresetChanged,
    required this.snapBackStiffness,
    required this.onSnapBackStiffnessChanged,
    required this.snapBackDamping,
    required this.onSnapBackDampingChanged,
    required this.flyPreset,
    required this.onFlyPresetChanged,
    required this.flyStiffness,
    required this.onFlyStiffnessChanged,
    required this.flyDamping,
    required this.onFlyDampingChanged,
    required this.collapseSpeed,
    required this.onCollapseSpeedChanged,
    this.isActionButtonsMode = false,
  });

  final M3EExampleMotionPreset snapBackPreset;
  final ValueChanged<M3EExampleMotionPreset> onSnapBackPresetChanged;
  final double snapBackStiffness;
  final ValueChanged<double> onSnapBackStiffnessChanged;
  final double snapBackDamping;
  final ValueChanged<double> onSnapBackDampingChanged;

  final M3EExampleMotionPreset flyPreset;
  final ValueChanged<M3EExampleMotionPreset> onFlyPresetChanged;
  final double flyStiffness;
  final ValueChanged<double> onFlyStiffnessChanged;
  final double flyDamping;
  final ValueChanged<double> onFlyDampingChanged;

  final double collapseSpeed;
  final ValueChanged<double> onCollapseSpeedChanged;
  final bool isActionButtonsMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ControlSectionHeader(
          title: isActionButtonsMode
              ? 'Snap Back Spring Motion'
              : 'Release & Flight Motion',
          subtitle: isActionButtonsMode
              ? 'Spring physics used when revealing action buttons or closing'
              : 'Spring curves for snap back, dismissal fly-off, and collapse speed',
          icon: isActionButtonsMode
              ? Icons.replay_rounded
              : Icons.flight_takeoff_rounded,
        ),
        MotionPresetControlCard(
          title: 'Snap Back Motion',
          subtitle: isActionButtonsMode
              ? 'Governs spring rebound and action button anchoring'
              : null,
          presetLabel: 'Snap Back Motion',
          selectedPreset: snapBackPreset,
          onPresetChanged: onSnapBackPresetChanged,
          stiffness: snapBackStiffness,
          onStiffnessChanged: onSnapBackStiffnessChanged,
          damping: snapBackDamping,
          onDampingChanged: onSnapBackDampingChanged,
          minStiffness: 50,
          maxStiffness: 1500,
          stiffnessDivisions: 29,
        ),
        if (!isActionButtonsMode) ...[
          const SizedBox(height: 12),
          MotionPresetControlCard(
            title: 'Fly Off Motion',
            subtitle: null,
            presetLabel: 'Fly Off Motion',
            selectedPreset: flyPreset,
            onPresetChanged: onFlyPresetChanged,
            stiffness: flyStiffness,
            onStiffnessChanged: onFlyStiffnessChanged,
            damping: flyDamping,
            onDampingChanged: onFlyDampingChanged,
            minStiffness: 50,
            maxStiffness: 1500,
            stiffnessDivisions: 29,
          ),
          const SizedBox(height: 12),
          ControlCard(
            children: [
              M3ESliderRow(
                label: 'Collapse Speed (Gmail Style)',
                value: collapseSpeed,
                min: 10,
                max: 200,
                divisions: 19,
                format: (v) => v.toStringAsFixed(0),
                onChanged: onCollapseSpeedChanged,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
