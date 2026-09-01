// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class SegmentedListGeometryControls extends StatelessWidget {
  const SegmentedListGeometryControls({
    super.key,
    required this.outerRadius,
    required this.onOuterRadiusChanged,
    required this.innerRadius,
    required this.onInnerRadiusChanged,
    required this.gap,
    required this.onGapChanged,
    required this.padding,
    required this.onPaddingChanged,
    required this.marginH,
    required this.onMarginHChanged,
    required this.marginV,
    required this.onMarginVChanged,
    required this.elevation,
    required this.onElevationChanged,
  });

  final double outerRadius;
  final ValueChanged<double> onOuterRadiusChanged;
  final double innerRadius;
  final ValueChanged<double> onInnerRadiusChanged;
  final double gap;
  final ValueChanged<double> onGapChanged;
  final double padding;
  final ValueChanged<double> onPaddingChanged;
  final double marginH;
  final ValueChanged<double> onMarginHChanged;
  final double marginV;
  final ValueChanged<double> onMarginVChanged;
  final double elevation;
  final ValueChanged<double> onElevationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Geometry & Spacing',
          subtitle:
              'Outer/inner pill corners, gaps, padding, margins, and elevations',
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
              label: 'Inter-card Gap',
              value: gap,
              min: 0,
              max: 16,
              divisions: 16,
              format: (v) => '${v.toStringAsFixed(1)} px',
              onChanged: onGapChanged,
            ),
            M3ESliderRow(
              label: 'Internal Padding',
              value: padding,
              min: 4,
              max: 28,
              divisions: 24,
              format: (v) => '${v.toInt()} px',
              onChanged: onPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Horizontal Margin',
              value: marginH,
              min: 0,
              max: 32,
              divisions: 32,
              format: (v) => '${v.toInt()} px',
              onChanged: onMarginHChanged,
            ),
            M3ESliderRow(
              label: 'Vertical Margin',
              value: marginV,
              min: 0,
              max: 24,
              divisions: 24,
              format: (v) => '${v.toInt()} px',
              onChanged: onMarginVChanged,
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
