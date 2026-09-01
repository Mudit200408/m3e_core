// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'button_playground_view.dart';

/// Screen showcasing Material 3 Expressive Buttons, Toggle Buttons, Split Buttons, and Groups in a single interactive playground.
class ButtonM3EScreen extends StatelessWidget {
  const ButtonM3EScreen({super.key, this.themeMode, this.onThemeModeChanged});

  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Buttons'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const ButtonPlaygroundView(),
    );
  }
}

/// Alias for backwards-compatibility.
typedef M3EButtonScreen = ButtonM3EScreen;
