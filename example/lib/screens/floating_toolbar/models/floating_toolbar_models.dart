// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

enum ToolbarVariant {
  horizontalFloating('Horizontal Floating'),
  verticalFloating('Vertical Floating'),
  horizontalFab('Horizontal FAB'),
  verticalFab('Vertical FAB'),
  docked('Docked Bottom Toolbar');

  final String label;
  const ToolbarVariant(this.label);
}

enum ToolbarContentPreset {
  bottomNav('Bottom Navigation Bar'),
  textFormatting('Rich Text Editor Formatting');

  final String label;
  const ToolbarContentPreset(this.label);
}

enum ToolbarColorMode {
  standard('Standard (M3E Surface)'),
  vibrant('Vibrant (M3E Spec)'),
  expressive('Expressive'),
  custom('Custom Colors');

  final String label;
  const ToolbarColorMode(this.label);
}

enum FabActionMode {
  toggleExpansion('Morph / Toggle Expansion'),
  customAction('Custom Primary Action (Add / Create / Trigger)');

  final String label;
  const FabActionMode(this.label);
}

enum ToolbarScreenAlignment {
  bottomCenter('Bottom Center', Alignment.bottomCenter),
  centerRight('Center Right', Alignment.centerRight),
  centerLeft('Center Left', Alignment.centerLeft),
  bottomRight('Bottom Right', Alignment.bottomRight),
  bottomLeft('Bottom Left', Alignment.bottomLeft),
  topCenter('Top Center', Alignment.topCenter);

  final String label;
  final Alignment alignment;
  const ToolbarScreenAlignment(this.label, this.alignment);
}
