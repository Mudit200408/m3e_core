// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'dropdown_playground_view.dart';

/// Screen showcasing Material 3 Expressive Dropdown Menus and Playground.
class DropdownM3EScreen extends StatelessWidget {
  const DropdownM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Dropdown'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const DropdownPlaygroundView(),
    );
  }
}

/// Alias for backwards compatibility.
typedef M3EDropdownScreen = DropdownM3EScreen;
