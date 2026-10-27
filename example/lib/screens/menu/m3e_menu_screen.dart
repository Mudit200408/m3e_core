// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../../shared/shared.dart';
import 'menu_playground_view.dart';

/// Screen showcasing Material 3 Expressive Menus and Playground.
class MenuM3EScreen extends StatelessWidget {
  const MenuM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Menus'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const MenuPlaygroundView(),
    );
  }
}

/// Alias for backwards compatibility and standard naming.
typedef M3EMenuScreen = MenuM3EScreen;
