// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'typography_playground_view.dart';

/// Screen showcasing the Material 3 Expressive Typography playground.
class M3ETypographyScreen extends StatelessWidget {
  const M3ETypographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Typography'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const TypographyPlaygroundView(),
    );
  }
}
