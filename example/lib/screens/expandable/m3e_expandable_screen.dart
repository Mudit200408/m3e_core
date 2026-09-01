// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'expandable_playground_view.dart';

/// Screen showcasing the complete interactive Expandable API.
class ExpandableM3EScreen extends StatelessWidget {
  const ExpandableM3EScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Expandable Cards'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const ExpandablePlaygroundView(),
    );
  }
}

/// Alias for backwards compatibility.
typedef M3EExpandableScreen = ExpandableM3EScreen;
