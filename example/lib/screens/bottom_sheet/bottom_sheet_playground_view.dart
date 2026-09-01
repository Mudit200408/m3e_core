// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'controls/bottom_sheet_color_controls.dart';
import 'controls/bottom_sheet_geometry_controls.dart';
import 'controls/bottom_sheet_interaction_controls.dart';
import 'controls/bottom_sheet_motion_controls.dart';
import 'models/bottom_sheet_models.dart';
import 'preview/bottom_sheet_preview_area.dart';
import 'snippets/bottom_sheet_code_snippets.dart';

export 'models/bottom_sheet_models.dart';

/// Interactive playground view for the M3E Bottom Sheet component.
class BottomSheetPlaygroundView extends StatefulWidget {
  const BottomSheetPlaygroundView({super.key});

  @override
  State<BottomSheetPlaygroundView> createState() =>
      _BottomSheetPlaygroundViewState();
}

class _BottomSheetPlaygroundViewState extends State<BottomSheetPlaygroundView> {
  BottomSheetPlaygroundState _state = const BottomSheetPlaygroundState();

  void _updateState(BottomSheetPlaygroundState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: BottomSheetPreviewArea(state: _state),
      codeSnippet: CodeSnippetCard(
        code: BottomSheetCodeSnippets.generate(_state),
      ),
      controls: [
        BottomSheetInteractionControls(state: _state, onChanged: _updateState),
        BottomSheetGeometryControls(state: _state, onChanged: _updateState),
        BottomSheetColorControls(state: _state, onChanged: _updateState),
        BottomSheetMotionControls(state: _state, onChanged: _updateState),
      ],
    );
  }
}
