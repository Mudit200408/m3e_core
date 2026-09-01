// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';
import '../models/bottom_sheet_models.dart';

class BottomSheetGeometryControls extends StatelessWidget {
  const BottomSheetGeometryControls({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final BottomSheetPlaygroundState state;
  final ValueChanged<BottomSheetPlaygroundState> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ControlSectionHeader(
          title: 'Geometry & Dimensions',
          icon: Icons.aspect_ratio_rounded,
        ),
        ControlCard(
          children: [
            M3ESliderRow(
              label: 'Border Radius',
              value: state.borderRadius,
              min: 0,
              max: 48,
              divisions: 24,
              format: (v) => '${v.toStringAsFixed(0)}dp',
              onChanged: (val) => onChanged(state.copyWith(borderRadius: val)),
            ),
            if (state.showDragHandle) ...[
              M3ESliderRow(
                label: 'Drag Handle Width',
                value: state.dragHandleWidth,
                min: 16,
                max: 80,
                divisions: 16,
                format: (v) => '${v.toStringAsFixed(0)}dp',
                onChanged: (val) =>
                    onChanged(state.copyWith(dragHandleWidth: val)),
              ),
              M3ESliderRow(
                label: 'Drag Handle Height',
                value: state.dragHandleHeight,
                min: 2,
                max: 12,
                divisions: 10,
                format: (v) => '${v.toStringAsFixed(0)}dp',
                onChanged: (val) =>
                    onChanged(state.copyWith(dragHandleHeight: val)),
              ),
              M3ESliderRow(
                label: 'Handle Vertical Padding',
                value: state.dragHandlePaddingV,
                min: 4,
                max: 32,
                divisions: 14,
                format: (v) => '${v.toStringAsFixed(0)}dp',
                onChanged: (val) =>
                    onChanged(state.copyWith(dragHandlePaddingV: val)),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
