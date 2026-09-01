// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'segmented_list_playground_view.dart';

/// Screen showcasing Material 3 Expressive Segmented Lists with a full-featured interactive playground.
class M3ESegmentedListScreen extends StatelessWidget {
  const M3ESegmentedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Segmented List'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const SegmentedListPlaygroundView(),
    );
  }
}

/// Deprecated alias for backwards compatibility.
@Deprecated('Use M3ESegmentedListScreen instead')
typedef M3ECardScreen = M3ESegmentedListScreen;
