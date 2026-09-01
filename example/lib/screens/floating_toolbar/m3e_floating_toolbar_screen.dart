// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'floating_toolbar_playground_view.dart';

/// Screen showcasing Material 3 Expressive Floating Toolbars and Playground.
class FloatingToolbarM3EScreen extends StatelessWidget {
  const FloatingToolbarM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Floating Toolbar'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const FloatingToolbarPlaygroundView(),
    );
  }
}

/// Alias for backwards compatibility.
typedef M3EFloatingToolbarScreen = FloatingToolbarM3EScreen;
