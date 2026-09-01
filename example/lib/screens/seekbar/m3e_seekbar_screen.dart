// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'seekbar_playground_view.dart';

/// Screen showcasing Material 3 Expressive Seekbars and AOSP Squiggly seekbars in an interactive playground.
class M3ESeekbarScreen extends StatelessWidget {
  const M3ESeekbarScreen({super.key, this.themeMode, this.onThemeModeChanged});

  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Seekbar'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const SeekbarPlaygroundView(),
    );
  }
}
