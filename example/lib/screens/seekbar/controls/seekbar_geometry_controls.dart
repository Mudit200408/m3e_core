// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/seekbar_models.dart';

class SeekbarGeometryControls extends StatelessWidget {
  const SeekbarGeometryControls({
    super.key,
    required this.handleShape,
    required this.onHandleShapeChanged,
    required this.handleWidth,
    required this.onHandleWidthChanged,
    required this.handleHeight,
    required this.onHandleHeightChanged,
    required this.handleRadius,
    required this.onHandleRadiusChanged,
    required this.variant,
    required this.trackHeight,
    required this.onTrackHeightChanged,
    required this.trackCornerRadius,
    required this.onTrackCornerRadiusChanged,
  });

  final M3ESeekbarHandleShape handleShape;
  final ValueChanged<M3ESeekbarHandleShape> onHandleShapeChanged;
  final double handleWidth;
  final ValueChanged<double> onHandleWidthChanged;
  final double handleHeight;
  final ValueChanged<double> onHandleHeightChanged;
  final double handleRadius;
  final ValueChanged<double> onHandleRadiusChanged;
  final SeekbarVariant variant;
  final double trackHeight;
  final ValueChanged<double> onTrackHeightChanged;
  final double trackCornerRadius;
  final ValueChanged<double> onTrackCornerRadiusChanged;

  static const _handleShapes = [
    M3ESeekbarHandleShape.rectangle,
    M3ESeekbarHandleShape.circle,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Handle & Track Geometry',
          subtitle:
              'M3E Handle shape tokens (Pill/Rectangle vs Circle) and track corner radiuses',
          icon: Icons.rounded_corner_rounded,
        ),
        ControlCard(
          children: [
            const Text(
              'Handle Shape Token (M3ESeekbarHandleShape)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            M3EToggleButtonGroup(
              type: M3EButtonGroupType.connected,
              style: M3EButtonStyle.outlined,
              size: M3EButtonSize.xs,
              selectedIndex: _handleShapes.indexOf(handleShape),
              onSelectedIndexChanged: (i) {
                if (i != null) {
                  onHandleShapeChanged(_handleShapes[i]);
                }
              },
              actions: const [
                M3EToggleButtonGroupAction(label: Text('Rectangle / Pill')),
                M3EToggleButtonGroupAction(label: Text('Circular Thumb')),
              ],
            ),
            const Divider(height: 16),
            if (handleShape == M3ESeekbarHandleShape.rectangle) ...[
              M3ESliderRow(
                label: 'Handle Width (handleWidth)',
                value: handleWidth,
                min: 2,
                max: 16,
                divisions: 14,
                format: (v) => '${v.toStringAsFixed(0)} dp',
                onChanged: onHandleWidthChanged,
              ),
              M3ESliderRow(
                label: 'Handle Height (handleHeight)',
                value: handleHeight,
                min: 8,
                max: 48,
                divisions: 40,
                format: (v) => '${v.toStringAsFixed(0)} dp',
                onChanged: onHandleHeightChanged,
              ),
            ] else ...[
              M3ESliderRow(
                label: 'Handle Radius (handleRadius)',
                value: handleRadius,
                min: 4,
                max: 24,
                divisions: 20,
                format: (v) => '${v.toStringAsFixed(0)} dp',
                onChanged: onHandleRadiusChanged,
              ),
            ],
            const Divider(height: 16),
            if (variant == SeekbarVariant.standard)
              M3ESliderRow(
                label: 'Track Height (trackHeight)',
                value: trackHeight,
                min: 2,
                max: 24,
                divisions: 22,
                format: (v) => '${v.toStringAsFixed(0)} dp',
                onChanged: onTrackHeightChanged,
              ),
            M3ESliderRow(
              label: 'Track Corner Radius (trackCornerRadius)',
              value: trackCornerRadius,
              min: 0,
              max: 16,
              divisions: 16,
              format: (v) => '${v.toStringAsFixed(0)} dp',
              onChanged: onTrackCornerRadiusChanged,
            ),
          ],
        ),
      ],
    );
  }
}
