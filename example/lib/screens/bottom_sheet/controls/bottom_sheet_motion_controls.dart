// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';
import '../models/bottom_sheet_models.dart';

class BottomSheetMotionControls extends StatelessWidget {
  const BottomSheetMotionControls({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final BottomSheetPlaygroundState state;
  final ValueChanged<BottomSheetPlaygroundState> onChanged;

  @override
  Widget build(BuildContext context) {
    return MotionPresetControlCard(
      title: 'Spring Motion & Physics',
      subtitle: 'Expressive spring physics for bottom sheet slide-up motion',
      selectedPreset: state.motionPreset,
      onPresetChanged: (preset) =>
          onChanged(state.copyWith(motionPreset: preset)),
      stiffness: state.motionStiffness,
      onStiffnessChanged: (val) =>
          onChanged(state.copyWith(motionStiffness: val)),
      damping: state.motionDamping,
      onDampingChanged: (val) => onChanged(state.copyWith(motionDamping: val)),
      minStiffness: 50.0,
      maxStiffness: 1600.0,
      stiffnessDivisions: 31,
    );
  }
}
