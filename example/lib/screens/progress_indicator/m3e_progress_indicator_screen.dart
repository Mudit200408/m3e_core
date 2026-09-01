// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'progress_playground_view.dart';

/// Screen showcasing Material 3 Expressive Progress Indicators and Playground.
class M3EProgressIndicatorScreen extends StatelessWidget {
  const M3EProgressIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Progress Indicators'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const ProgressPlaygroundView(),
    );
  }
}
