// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

enum ButtonArchitecture { standard, toggle, group, split, floatingAction }

enum FabArchitectureMode { standard, extended, menu }

enum ButtonContentLayout { iconAndLabel, labelOnly, iconOnly }

enum GroupPreset {
  formatting,
  morphingCheckedLabel,
  composeVariableWidths,
  quickSettings,
}

class ButtonPlaygroundOptions {
  static const styles = [
    M3EButtonStyle.filled,
    M3EButtonStyle.tonal,
    M3EButtonStyle.elevated,
    M3EButtonStyle.outlined,
    M3EButtonStyle.text,
  ];

  static const availableSizes = [
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
    M3EButtonSize.lg,
    M3EButtonSize.xl,
  ];

  static const shapes = [M3EButtonShape.round, M3EButtonShape.square];

  static const contentLayouts = [
    ButtonContentLayout.iconAndLabel,
    ButtonContentLayout.labelOnly,
    ButtonContentLayout.iconOnly,
  ];

  static const iconAlignments = [IconAlignment.start, IconAlignment.end];

  static const groupTypes = [
    M3EButtonGroupType.connected,
    M3EButtonGroupType.standard,
  ];

  static const densities = [
    M3EButtonGroupDensity.regular,
    M3EButtonGroupDensity.compact,
  ];

  static const directions = [Axis.horizontal, Axis.vertical];

  static const splitAlignments = [
    M3ESplitButtonTrailingAlignment.opticalCenter,
    M3ESplitButtonTrailingAlignment.geometricCenter,
  ];

  static const splitMenuStyles = [
    SplitButtonMenuStyle.popup,
    SplitButtonMenuStyle.bottomSheet,
    SplitButtonMenuStyle.native,
  ];

  static const splitOptions = [
    'Save Draft',
    'Save & Publish',
    'Export PDF',
    'Archive',
  ];

  static const overflowMenuStyles = [
    M3EButtonGroupOverflowMenuStyle.popup,
    M3EButtonGroupOverflowMenuStyle.bottomSheet,
  ];

  static const mouseCursors = <MouseCursor>[
    SystemMouseCursors.click,
    SystemMouseCursors.grab,
    SystemMouseCursors.zoomIn,
    SystemMouseCursors.copy,
    SystemMouseCursors.forbidden,
  ];
}
