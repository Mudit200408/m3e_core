// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

enum DropdownDataMode { staticItems, asyncFuture }

enum DropdownExpandDirection { auto, down, up }

enum DropdownSplashFactory {
  noSplash('NoSplash', NoSplash.splashFactory),
  inkSparkle('InkSparkle', InkSparkle.splashFactory),
  inkSplash('InkSplash', InkSplash.splashFactory),
  inkRipple('InkRipple', InkRipple.splashFactory);

  const DropdownSplashFactory(this.label, this.factory);
  final String label;
  final InteractiveInkFeatureFactory factory;
}
