// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';

class ExpandableGeometryControls extends StatelessWidget {
  const ExpandableGeometryControls({
    super.key,
    required this.outerRadius,
    required this.onOuterRadiusChanged,
    required this.innerRadius,
    required this.onInnerRadiusChanged,
    required this.hoverRadius,
    required this.onHoverRadiusChanged,
    required this.pressedRadius,
    required this.onPressedRadiusChanged,
    required this.gap,
    required this.onGapChanged,
    required this.useExpandedRadius,
    required this.onUseExpandedRadiusChanged,
    required this.expandedRadius,
    required this.onExpandedRadiusChanged,
    required this.elevation,
    required this.onElevationChanged,
    required this.titleSubtitleGap,
    required this.onTitleSubtitleGapChanged,
    required this.iconRotation,
    required this.onIconRotationChanged,
    required this.iconPadding,
    required this.onIconPaddingChanged,
    required this.margin,
    required this.onMarginChanged,
  });

  final double outerRadius;
  final ValueChanged<double> onOuterRadiusChanged;
  final double innerRadius;
  final ValueChanged<double> onInnerRadiusChanged;
  final double hoverRadius;
  final ValueChanged<double> onHoverRadiusChanged;
  final double pressedRadius;
  final ValueChanged<double> onPressedRadiusChanged;
  final double gap;
  final ValueChanged<double> onGapChanged;
  final bool useExpandedRadius;
  final ValueChanged<bool> onUseExpandedRadiusChanged;
  final double expandedRadius;
  final ValueChanged<double> onExpandedRadiusChanged;
  final double elevation;
  final ValueChanged<double> onElevationChanged;
  final double titleSubtitleGap;
  final ValueChanged<double> onTitleSubtitleGapChanged;
  final double iconRotation;
  final ValueChanged<double> onIconRotationChanged;
  final double iconPadding;
  final ValueChanged<double> onIconPaddingChanged;
  final double margin;
  final ValueChanged<double> onMarginChanged;

  String _number(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Shape & Spacing',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Outer radius',
              value: outerRadius,
              min: 0,
              max: 40,
              divisions: 40,
              format: _number,
              onChanged: onOuterRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Inner radius',
              value: innerRadius,
              min: 0,
              max: 30,
              divisions: 30,
              format: _number,
              onChanged: onInnerRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Hover radius',
              value: hoverRadius,
              min: 0,
              max: 30,
              divisions: 30,
              format: _number,
              onChanged: onHoverRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Pressed radius',
              value: pressedRadius,
              min: 0,
              max: 30,
              divisions: 30,
              format: _number,
              onChanged: onPressedRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Card gap',
              value: gap,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onGapChanged,
            ),
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Custom expanded radius',
                  value: useExpandedRadius,
                  onChanged: onUseExpandedRadiusChanged,
                ),
              ],
            ),
            if (useExpandedRadius)
              M3ESliderRow(
                label: 'Expanded radius',
                value: expandedRadius,
                min: 0,
                max: 40,
                divisions: 40,
                format: _number,
                onChanged: onExpandedRadiusChanged,
              ),
            M3ESliderRow(
              label: 'Elevation',
              value: elevation,
              min: 0,
              max: 12,
              divisions: 24,
              format: _number,
              onChanged: onElevationChanged,
            ),
            M3ESliderRow(
              label: 'Title/subtitle gap',
              value: titleSubtitleGap,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onTitleSubtitleGapChanged,
            ),
            M3ESliderRow(
              label: 'Icon rotation (radians)',
              value: iconRotation,
              min: -6.28,
              max: 6.28,
              divisions: 40,
              format: _number,
              onChanged: onIconRotationChanged,
            ),
            M3ESliderRow(
              label: 'Icon padding',
              value: iconPadding,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onIconPaddingChanged,
            ),
            M3ESliderRow(
              label: 'Outer margin',
              value: margin,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onMarginChanged,
            ),
          ],
        ),
      ],
    );
  }
}
