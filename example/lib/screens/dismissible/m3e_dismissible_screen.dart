// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'dismissible_playground_view.dart';

/// Screen showcasing Material 3 Expressive Dismissible Cards with a full-featured interactive playground.
class DismissibleM3EScreen extends StatelessWidget {
  const DismissibleM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Dismissible'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const DismissiblePlaygroundView(),
    );
  }
}

/// Alias for backwards compatibility.
typedef M3EDismissibleScreen = DismissibleM3EScreen;
