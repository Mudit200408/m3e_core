// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../shared/shared.dart';
import 'slider_playground_view.dart';

/// Screen showcasing the complete interactive Material 3 Expressive Slider API.
class M3ESliderScreen extends StatelessWidget {
  const M3ESliderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3E Slider'),
        actions: const [ThemeAppBarActions()],
      ),
      body: const SliderPlaygroundView(),
    );
  }
}
