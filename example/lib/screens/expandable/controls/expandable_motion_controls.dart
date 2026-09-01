// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class ExpandableMotionControls extends StatelessWidget {
  const ExpandableMotionControls({
    super.key,
    required this.expandPreset,
    required this.onExpandPresetChanged,
    required this.expandStiffness,
    required this.onExpandStiffnessChanged,
    required this.expandDamping,
    required this.onExpandDampingChanged,
    required this.collapsePreset,
    required this.onCollapsePresetChanged,
    required this.collapseStiffness,
    required this.onCollapseStiffnessChanged,
    required this.collapseDamping,
    required this.onCollapseDampingChanged,
  });

  final M3EExampleMotionPreset expandPreset;
  final ValueChanged<M3EExampleMotionPreset> onExpandPresetChanged;
  final double expandStiffness;
  final ValueChanged<double> onExpandStiffnessChanged;
  final double expandDamping;
  final ValueChanged<double> onExpandDampingChanged;

  final M3EExampleMotionPreset collapsePreset;
  final ValueChanged<M3EExampleMotionPreset> onCollapsePresetChanged;
  final double collapseStiffness;
  final ValueChanged<double> onCollapseStiffnessChanged;
  final double collapseDamping;
  final ValueChanged<double> onCollapseDampingChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Expansion Motion',
          icon: Icons.motion_photos_on_rounded,
        ),
        MotionPresetControlCard(
          title: 'Expand Motion',
          subtitle: null,
          presetLabel: 'Expand Motion',
          selectedPreset: expandPreset,
          onPresetChanged: onExpandPresetChanged,
          stiffness: expandStiffness,
          onStiffnessChanged: onExpandStiffnessChanged,
          damping: expandDamping,
          onDampingChanged: onExpandDampingChanged,
          minStiffness: 100,
          maxStiffness: 1600,
          stiffnessDivisions: 30,
        ),
        const SizedBox(height: 12),
        MotionPresetControlCard(
          title: 'Collapse Motion',
          subtitle: null,
          presetLabel: 'Collapse Motion',
          selectedPreset: collapsePreset,
          onPresetChanged: onCollapsePresetChanged,
          stiffness: collapseStiffness,
          onStiffnessChanged: onCollapseStiffnessChanged,
          damping: collapseDamping,
          onDampingChanged: onCollapseDampingChanged,
          minStiffness: 100,
          maxStiffness: 1600,
          stiffnessDivisions: 30,
        ),
      ],
    );
  }
}
