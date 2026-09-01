// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'bottom_sheet_playground_view.dart';

/// Screen showcasing the complete Material 3 Expressive Bottom Sheet component playground.
class M3EBottomSheetScreen extends StatelessWidget {
  const M3EBottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Bottom Sheet'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const BottomSheetPlaygroundView(),
    );
  }
}
