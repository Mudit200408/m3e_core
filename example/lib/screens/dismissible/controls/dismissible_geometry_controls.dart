// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class DismissibleGeometryControls extends StatelessWidget {
  const DismissibleGeometryControls({
    super.key,
    required this.outerRadius,
    required this.onOuterRadiusChanged,
    required this.innerRadius,
    required this.onInnerRadiusChanged,
    required this.selectedBorderRadius,
    required this.onSelectedBorderRadiusChanged,
    required this.gap,
    required this.onGapChanged,
    required this.elevation,
    required this.onElevationChanged,
  });

  final double outerRadius;
  final ValueChanged<double> onOuterRadiusChanged;
  final double innerRadius;
  final ValueChanged<double> onInnerRadiusChanged;
  final double selectedBorderRadius;
  final ValueChanged<double> onSelectedBorderRadiusChanged;
  final double gap;
  final ValueChanged<double> onGapChanged;
  final double elevation;
  final ValueChanged<double> onElevationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Geometry & Spacing',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Outer Radius (Pill Edge)',
              value: outerRadius,
              min: 0,
              max: 48,
              divisions: 48,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onOuterRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Inner Radius (Neighbor Seam)',
              value: innerRadius,
              min: 0,
              max: 24,
              divisions: 24,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onInnerRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Selected Drag Radius',
              value: selectedBorderRadius,
              min: 0,
              max: 60,
              divisions: 60,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onSelectedBorderRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Inter-card Gap',
              value: gap,
              min: 0,
              max: 24,
              divisions: 24,
              format: (v) => v.toStringAsFixed(0),
              onChanged: onGapChanged,
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
          ],
        ),
      ],
    );
  }
}
