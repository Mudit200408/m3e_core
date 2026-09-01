// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';
import '../models/slider_models.dart';

class SliderGeometryControls extends StatelessWidget {
  const SliderGeometryControls({
    super.key,
    required this.trackHeight,
    required this.onTrackHeightChanged,
    required this.trackCornerRadius,
    required this.onTrackCornerRadiusChanged,
    required this.thumbWidth,
    required this.onThumbWidthChanged,
    required this.thumbHeight,
    required this.onThumbHeightChanged,
    required this.kind,
    required this.motionPreset,
    required this.onMotionPresetChanged,
    required this.motionStiffness,
    required this.onMotionStiffnessChanged,
    required this.motionDamping,
    required this.onMotionDampingChanged,
    required this.trackIconActiveColor,
    required this.onTrackIconActiveColorChanged,
    required this.trackIconInactiveColor,
    required this.onTrackIconInactiveColorChanged,
  });

  final double trackHeight;
  final ValueChanged<double> onTrackHeightChanged;
  final double trackCornerRadius;
  final ValueChanged<double> onTrackCornerRadiusChanged;
  final double thumbWidth;
  final ValueChanged<double> onThumbWidthChanged;
  final double thumbHeight;
  final ValueChanged<double> onThumbHeightChanged;
  final SliderKind kind;
  final M3EExampleMotionPreset motionPreset;
  final ValueChanged<M3EExampleMotionPreset> onMotionPresetChanged;
  final double motionStiffness;
  final ValueChanged<double> onMotionStiffnessChanged;
  final double motionDamping;
  final ValueChanged<double> onMotionDampingChanged;
  final Color trackIconActiveColor;
  final ValueChanged<Color> onTrackIconActiveColorChanged;
  final Color trackIconInactiveColor;
  final ValueChanged<Color> onTrackIconInactiveColorChanged;

  String _number(double val) => val.toStringAsFixed(2);

  Widget _colorControl(
    BuildContext context,
    String label,
    Color value,
    ValueChanged<Color> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          ColorDotPicker(
            selectedColor: value,
            onColorSelected: onChanged,
            size: 26,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Geometry & Decoration',
          icon: Icons.aspect_ratio_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Track height',
              value: trackHeight,
              min: 4,
              max: 48,
              divisions: 44,
              format: (v) => v.round().toString(),
              onChanged: onTrackHeightChanged,
            ),
            M3ESliderRow(
              label: 'Track corner radius',
              value: trackCornerRadius,
              min: 0,
              max: 24,
              divisions: 24,
              format: _number,
              onChanged: onTrackCornerRadiusChanged,
            ),
            M3ESliderRow(
              label: 'Thumb width',
              value: thumbWidth,
              min: 2,
              max: 20,
              divisions: 18,
              format: _number,
              onChanged: onThumbWidthChanged,
            ),
            M3ESliderRow(
              label: 'Thumb height',
              value: thumbHeight,
              min: 12,
              max: 64,
              divisions: 52,
              format: (v) => v.round().toString(),
              onChanged: onThumbHeightChanged,
            ),
            if (kind == SliderKind.single) ...[
              const SizedBox(height: 8),
              MotionPresetControlCard(
                title: 'Spring Motion',
                subtitle: null,
                presetLabel: 'Spring Motion',
                selectedPreset: motionPreset,
                onPresetChanged: onMotionPresetChanged,
                stiffness: motionStiffness,
                onStiffnessChanged: onMotionStiffnessChanged,
                damping: motionDamping,
                onDampingChanged: onMotionDampingChanged,
                minStiffness: 100,
                maxStiffness: 2000,
                stiffnessDivisions: 38,
              ),
              const SizedBox(height: 8),
            ],
            _colorControl(
              context,
              'Active track icon',
              trackIconActiveColor,
              onTrackIconActiveColorChanged,
            ),
            _colorControl(
              context,
              'Inactive track icon',
              trackIconInactiveColor,
              onTrackIconInactiveColorChanged,
            ),
          ],
        ),
      ],
    );
  }
}
