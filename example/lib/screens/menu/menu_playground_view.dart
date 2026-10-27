// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../../../shared/shared.dart';
import 'controls/menu_controls.dart';
import 'models/menu_models.dart';
import 'preview/menu_preview.dart';
import 'snippets/menu_code_snippets.dart';

/// Interactive playground view for M3E Menu.
class MenuPlaygroundView extends StatefulWidget {
  const MenuPlaygroundView({super.key});

  @override
  State<MenuPlaygroundView> createState() => _MenuPlaygroundViewState();
}

class _MenuPlaygroundViewState extends State<MenuPlaygroundView> {
  final MenuPlaygroundState _state = MenuPlaygroundState();
  final ValueNotifier<String> _eventNotifier = ValueNotifier('Ready');

  @override
  void dispose() {
    _eventNotifier.dispose();
    super.dispose();
  }

  void _updateState(VoidCallback fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final generatedCode = MenuCodeSnippetGenerator.generate(_state);

    return PlaygroundSplitLayout(
      preview: MenuPreviewArea(state: _state, eventNotifier: _eventNotifier),
      codeSnippet: CodeSnippetCard(code: generatedCode),
      controls: [MenuControls(state: _state, updateState: _updateState)],
    );
  }
}
