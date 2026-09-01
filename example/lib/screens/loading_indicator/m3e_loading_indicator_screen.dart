// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'loading_playground_view.dart';

/// Screen showcasing Material 3 Expressive Loading Indicators and Playground.
class M3ELoadingIndicatorScreen extends StatelessWidget {
  const M3ELoadingIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Loading Indicator'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const LoadingPlaygroundView(),
    );
  }
}
