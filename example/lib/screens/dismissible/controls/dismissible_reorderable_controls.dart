// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class DismissibleReorderableControls extends StatelessWidget {
  const DismissibleReorderableControls({
    super.key,
    required this.buildDefaultDragHandles,
    required this.onBuildDefaultDragHandlesChanged,
    required this.dragElevation,
    required this.onDragElevationChanged,
    required this.dragScale,
    required this.onDragScaleChanged,
  });

  final bool buildDefaultDragHandles;
  final ValueChanged<bool> onBuildDefaultDragHandlesChanged;
  final double dragElevation;
  final ValueChanged<double> onDragElevationChanged;
  final double dragScale;
  final ValueChanged<double> onDragScaleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Reorderable Drag Physics & Handles',
          subtitle:
              'Drag handles, lift elevation, pop scale factor, and spring physics',
          icon: Icons.drag_indicator_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Build Default Drag Handles',
                  subtitle:
                      'When on: trailing drag handle • When off: long-press card to reorder',
                  value: buildDefaultDragHandles,
                  onChanged: onBuildDefaultDragHandlesChanged,
                ),
              ],
            ),
            M3ESliderRow(
              label: 'Drag Elevation',
              value: dragElevation,
              min: 0,
              max: 24,
              divisions: 24,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onDragElevationChanged,
            ),
            M3ESliderRow(
              label: 'Drag Scale Factor',
              value: dragScale,
              min: 1.0,
              max: 1.20,
              divisions: 20,
              format: (v) => '${((v - 1.0) * 100).toInt()}% pop',
              onChanged: onDragScaleChanged,
            ),
          ],
        ),
      ],
    );
  }
}
