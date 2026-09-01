// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../../shared/shared.dart';
import '../models/bottom_sheet_models.dart';

class BottomSheetInteractionControls extends StatelessWidget {
  const BottomSheetInteractionControls({
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
          title: 'Layout & Behavior',
          icon: Icons.tune_rounded,
        ),
        ControlCard(
          children: [
            M3ESegmentedSwitchGroup(
              items: [
                M3ESwitchItem(
                  title: 'Show Drag Handle',
                  value: state.showDragHandle,
                  onChanged: (val) =>
                      onChanged(state.copyWith(showDragHandle: val)),
                ),
                M3ESwitchItem(
                  title: 'Include Header Title',
                  value: state.hasTitle,
                  onChanged: (val) => onChanged(state.copyWith(hasTitle: val)),
                ),
                M3ESwitchItem(
                  title: 'Include Header Actions',
                  value: state.hasActions,
                  onChanged: (val) =>
                      onChanged(state.copyWith(hasActions: val)),
                ),
                M3ESwitchItem(
                  title: 'Is Dismissible (Barrier Tap)',
                  value: state.isDismissible,
                  onChanged: (val) =>
                      onChanged(state.copyWith(isDismissible: val)),
                ),
                M3ESwitchItem(
                  title: 'Enable Drag (Swipe Down to Dismiss)',
                  value: state.enableDrag,
                  onChanged: (val) =>
                      onChanged(state.copyWith(enableDrag: val)),
                ),
                M3ESwitchItem(
                  title: 'Use Safe Area',
                  value: state.useSafeArea,
                  onChanged: (val) =>
                      onChanged(state.copyWith(useSafeArea: val)),
                ),
                M3ESwitchItem(
                  title: 'Is Scroll Controlled',
                  value: state.isScrollControlled,
                  onChanged: (val) =>
                      onChanged(state.copyWith(isScrollControlled: val)),
                ),
                M3ESwitchItem(
                  title: 'Spring Entrance Motion',
                  value: state.animateEntrance,
                  onChanged: (val) =>
                      onChanged(state.copyWith(animateEntrance: val)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
