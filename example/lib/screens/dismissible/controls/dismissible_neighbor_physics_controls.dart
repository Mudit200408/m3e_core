// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class DismissibleNeighborPhysicsControls extends StatelessWidget {
  const DismissibleNeighborPhysicsControls({
    super.key,
    required this.neighbourPull,
    required this.onNeighbourPullChanged,
    required this.neighbourReach,
    required this.onNeighbourReachChanged,
    required this.neighbourPreset,
    required this.onNeighbourPresetChanged,
    required this.neighbourStiffness,
    required this.onNeighbourStiffnessChanged,
    required this.neighbourDamping,
    required this.onNeighbourDampingChanged,
  });

  final double neighbourPull;
  final ValueChanged<double> onNeighbourPullChanged;
  final int neighbourReach;
  final ValueChanged<int> onNeighbourReachChanged;
  final M3EExampleMotionPreset neighbourPreset;
  final ValueChanged<M3EExampleMotionPreset> onNeighbourPresetChanged;
  final double neighbourStiffness;
  final ValueChanged<double> onNeighbourStiffnessChanged;
  final double neighbourDamping;
  final ValueChanged<double> onNeighbourDampingChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Neighbour Squish Physics',
          subtitle: 'Spring-driven displacement of adjacent cards during drag',
          icon: Icons.compress_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Neighbour Pull Offset',
              value: neighbourPull,
              min: 0,
              max: 60,
              divisions: 30,
              format: (v) => '${v.toInt()} px',
              onChanged: onNeighbourPullChanged,
            ),
            M3ESliderRow(
              label: 'Neighbour Reach (Cards)',
              value: neighbourReach.toDouble(),
              min: 1,
              max: 8,
              divisions: 7,
              format: (v) => '${v.toInt()} cards',
              onChanged: (v) => onNeighbourReachChanged(v.toInt()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        MotionPresetControlCard(
          title: 'Neighbour Spring Motion',
          subtitle: null,
          presetLabel: 'Neighbour Motion',
          selectedPreset: neighbourPreset,
          onPresetChanged: onNeighbourPresetChanged,
          stiffness: neighbourStiffness,
          onStiffnessChanged: onNeighbourStiffnessChanged,
          damping: neighbourDamping,
          onDampingChanged: onNeighbourDampingChanged,
          minStiffness: 50,
          maxStiffness: 1500,
          stiffnessDivisions: 29,
        ),
      ],
    );
  }
}
