// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/button_models.dart';

class ButtonCodeSnippets {
  static String motionToCode(
    M3EExampleMotionPreset preset,
    double stiffness,
    double damping,
  ) {
    if (preset == M3EExampleMotionPreset.custom) {
      return 'M3EMotion.custom(stiffness: ${stiffness.toStringAsFixed(0)}, damping: ${damping.toStringAsFixed(2)})';
    }
    return 'M3EMotion.${preset.name}';
  }

  static String sizeToCode(M3EButtonSize size) {
    if (size.name == 'custom') {
      final parts = <String>[];
      if (size.height != null) {
        parts.add('height: ${size.height!.toStringAsFixed(0)}');
      }
      if (size.hPadding != null) {
        parts.add('hPadding: ${size.hPadding!.toStringAsFixed(0)}');
      }
      if (size.iconSize != null) {
        parts.add('iconSize: ${size.iconSize!.toStringAsFixed(0)}');
      }
      if (size.iconGap != null) {
        parts.add('iconGap: ${size.iconGap!.toStringAsFixed(0)}');
      }
      if (size.width != null) {
        parts.add('width: ${size.width!.toStringAsFixed(0)}');
      }
      return 'M3EButtonSize.custom(${parts.join(', ')})';
    }
    return 'M3EButtonSize.${size.name}';
  }

  static String generate({
    required ButtonArchitecture arch,
    required FabArchitectureMode fabMode,
    required M3EFabSize fabSize,
    required M3EFabColor fabColor,
    required bool fabExpanded,
    required String fabLabel,
    required IconData fabIcon,
    required M3EFabMenuPosition fabMenuPosition,
    required bool fabEnabled,
    required double customFabCornerRadius,
    required bool useCustomFabCornerRadius,
    required double fabPressedScale,
    required M3EExampleMotionPreset fabMotionPreset,
    required double fabMotionStiffness,
    required double fabMotionDamping,
    required double menuItemGap,
    required double menuOffset,
    required double menuItemHeight,
    required double menuItemHorizontalPadding,
    required double menuIconLabelGap,
    required double menuItemElevation,
    required int menuItemCount,
    required int menuExpandStaggerMs,
    required M3EExampleMotionPreset menuExpandMotionPreset,
    required double menuExpandMotionStiffness,
    required double menuExpandMotionDamping,
    required M3EExampleMotionPreset menuFabShapeMotionPreset,
    required double menuFabShapeMotionStiffness,
    required double menuFabShapeMotionDamping,
    required bool useMenuScrim,
    required double menuScrimOpacity,
    required bool useCustomMenuItemBg,
    required bool useCustomMenuItemFg,
    required M3EButtonStyle style,
    required M3EButtonSize size,
    required M3EButtonShape shape,
    required bool enabled,
    required bool useDecoration,
    required bool enableFeedback,
    required MouseCursor mouseCursor,
    required ButtonContentLayout contentLayout,
    required IconAlignment iconAlignment,
    required String label,
    required String buttonTooltip,
    required double restingBorderRadius,
    required double pressedRadius,
    required double hoveredRadius,
    required double checkedRadius,
    required double elevation,
    required M3EExampleMotionPreset motionPreset,
    required double motionStiffness,
    required double motionDamping,
    required M3EHapticFeedback haptic,
    required bool useCustomColor,
    required bool useCustomFg,
    required bool useBorder,
    required double borderWidth,
    required bool isChecked,
    required bool useCustomCheckedIcon,
    required bool useCustomCheckedLabel,
    required String checkedLabel,
    required bool allowMultilineLabel,
    required GroupPreset groupPreset,
    required bool useVariableActionWidths,
    required bool groupShowIcon,
    required bool groupShowCheckedIcon,
    required bool groupShowLabel,
    required bool groupShowCheckedLabel,
    required bool groupPerActionDecoration,
    required bool hasDisabledAction,
    required M3EButtonGroupType groupType,
    required bool groupMultiSelect,
    required bool neighborSquish,
    required double expandedRatio,
    required double spacing,
    required bool useCustomHeight,
    required double customHeight,
    required M3EButtonGroupDensity density,
    required Axis direction,
    required M3EButtonGroupOverflow overflow,
    required M3EButtonGroupOverflowMenuStyle overflowMenuStyle,
    required bool overflowUseCardList,
    required M3ESplitButtonTrailingAlignment splitAlignment,
    required SplitButtonMenuStyle splitMenuStyle,
    required String splitSelectedValue,
    required String leadingTooltip,
    required String trailingTooltip,
    required double splitGap,
    required double trailingSelectedRadius,
    required bool useCustomDividerColor,
  }) {
    final buf = StringBuffer();

    if (arch == ButtonArchitecture.floatingAction) {
      final fabIconName = switch (fabIcon) {
        Icons.save_rounded => 'save_rounded',
        Icons.share_rounded => 'share_rounded',
        Icons.delete_rounded => 'delete_rounded',
        _ => 'add_rounded',
      };
      if (fabMode == FabArchitectureMode.standard) {
        buf.writeln('// Material 3 Expressive FAB');
        buf.writeln('M3EFab(');
        buf.writeln('  size: M3EFabSize.${fabSize.name},');
        buf.writeln('  color: M3EFabColor.${fabColor.name},');
        if (useCustomFabCornerRadius) {
          buf.writeln(
            '  cornerRadius: ${customFabCornerRadius.toStringAsFixed(1)},',
          );
        }
        buf.writeln('  icon: const Icon(Icons.$fabIconName),');
        if (fabPressedScale != 0.95 ||
            fabMotionPreset !=
                M3EExampleMotionPreset.expressiveSpatialDefault ||
            useCustomColor ||
            useCustomFg ||
            useBorder) {
          buf.writeln('  decoration: const M3EFabDecoration(');
          if (fabPressedScale != 0.95) {
            buf.writeln(
              '    pressedScale: ${fabPressedScale.toStringAsFixed(2)},',
            );
          }
          if (fabMotionPreset == M3EExampleMotionPreset.custom) {
            buf.writeln(
              '    motion: M3EMotion.custom(stiffness: ${fabMotionStiffness.toStringAsFixed(0)}, damping: ${fabMotionDamping.toStringAsFixed(2)}),',
            );
          } else if (fabMotionPreset !=
              M3EExampleMotionPreset.expressiveSpatialDefault) {
            buf.writeln('    motion: M3EMotion.${fabMotionPreset.name},');
          }
          if (useCustomColor) {
            buf.writeln(
              '    backgroundColor: WidgetStatePropertyAll(Colors.teal),',
            );
          }
          if (useCustomFg) {
            buf.writeln(
              '    foregroundColor: WidgetStatePropertyAll(Colors.white),',
            );
          }
          if (useBorder) {
            buf.writeln(
              '    side: WidgetStatePropertyAll(BorderSide(color: Colors.teal, width: ${borderWidth.toStringAsFixed(1)})),',
            );
          }
          buf.writeln('  ),');
        }
        buf.writeln(
          '  onPressed: ${fabEnabled ? '() { /* Tap action */ }' : 'null'},',
        );
        buf.write(');');
      } else if (fabMode == FabArchitectureMode.extended) {
        buf.writeln('// Material 3 Expressive Extended FAB');
        buf.writeln('M3EExtendedFab(');
        buf.writeln('  size: M3EFabSize.${fabSize.name},');
        buf.writeln('  color: M3EFabColor.${fabColor.name},');
        buf.writeln('  extended: $fabExpanded,');
        buf.writeln('  icon: const Icon(Icons.$fabIconName),');
        buf.writeln("  label: '$fabLabel',");
        if (fabPressedScale != 0.97 ||
            fabMotionPreset !=
                M3EExampleMotionPreset.expressiveSpatialDefault ||
            useCustomColor ||
            useCustomFg ||
            useBorder) {
          buf.writeln('  decoration: const M3EFabDecoration(');
          if (fabPressedScale != 0.97) {
            buf.writeln(
              '    pressedScale: ${fabPressedScale.toStringAsFixed(2)},',
            );
          }
          if (fabMotionPreset == M3EExampleMotionPreset.custom) {
            buf.writeln(
              '    motion: M3EMotion.custom(stiffness: ${fabMotionStiffness.toStringAsFixed(0)}, damping: ${fabMotionDamping.toStringAsFixed(2)}),',
            );
          } else if (fabMotionPreset !=
              M3EExampleMotionPreset.expressiveSpatialDefault) {
            buf.writeln('    motion: M3EMotion.${fabMotionPreset.name},');
          }
          if (useCustomColor) {
            buf.writeln(
              '    backgroundColor: WidgetStatePropertyAll(Colors.teal),',
            );
          }
          if (useCustomFg) {
            buf.writeln(
              '    foregroundColor: WidgetStatePropertyAll(Colors.white),',
            );
          }
          if (useBorder) {
            buf.writeln(
              '    side: WidgetStatePropertyAll(BorderSide(color: Colors.teal, width: ${borderWidth.toStringAsFixed(1)})),',
            );
          }
          buf.writeln('  ),');
        }
        buf.writeln(
          '  onPressed: ${fabEnabled ? '() { /* Tap action */ }' : 'null'},',
        );
        buf.write(');');
      } else {
        buf.writeln('// Material 3 Expressive FAB Menu');
        buf.writeln('M3EFabMenu(');
        buf.writeln('  position: M3EFabMenuPosition.${fabMenuPosition.name},');
        buf.writeln('  color: M3EFabColor.${fabColor.name},');
        buf.writeln('  size: M3EFabSize.${fabSize.name},');
        buf.writeln('  decoration: const M3EFabMenuDecoration(');
        if (menuItemGap != 8.0) {
          buf.writeln('    itemGap: ${menuItemGap.toStringAsFixed(1)},');
        }
        if (menuOffset != 12.0) {
          buf.writeln('    menuOffset: ${menuOffset.toStringAsFixed(1)},');
        }
        if (menuItemHeight != 56.0) {
          buf.writeln('    itemHeight: ${menuItemHeight.toStringAsFixed(1)},');
        }
        if (menuItemHorizontalPadding != 20.0) {
          buf.writeln(
            '    itemHorizontalPadding: ${menuItemHorizontalPadding.toStringAsFixed(1)},',
          );
        }
        if (menuIconLabelGap != 12.0) {
          buf.writeln(
            '    iconLabelGap: ${menuIconLabelGap.toStringAsFixed(1)},',
          );
        }
        if (menuItemElevation != 6.0) {
          buf.writeln(
            '    itemElevation: ${menuItemElevation.toStringAsFixed(1)},',
          );
        }
        if (menuExpandStaggerMs != 35) {
          buf.writeln('    expandStaggerMs: $menuExpandStaggerMs,');
        }
        if (useMenuScrim) {
          buf.writeln(
            '    scrimColor: Color(0x${(menuScrimOpacity * 255).round().toRadixString(16).padLeft(2, '0')}000000),',
          );
        }
        if (useCustomMenuItemBg) {
          buf.writeln('    itemBackgroundColor: Colors.teal,');
        }
        if (useCustomMenuItemFg) {
          buf.writeln('    itemForegroundColor: Colors.white,');
        }
        if (menuExpandMotionPreset == M3EExampleMotionPreset.custom) {
          buf.writeln(
            '    expandMotion: M3EMotion.custom(stiffness: ${menuExpandMotionStiffness.toStringAsFixed(0)}, damping: ${menuExpandMotionDamping.toStringAsFixed(2)}),',
          );
        } else if (menuExpandMotionPreset !=
            M3EExampleMotionPreset.expressiveSpatialDefault) {
          buf.writeln(
            '    expandMotion: M3EMotion.${menuExpandMotionPreset.name},',
          );
        }
        if (menuFabShapeMotionPreset == M3EExampleMotionPreset.custom) {
          buf.writeln(
            '    fabShapeMotion: M3EMotion.custom(stiffness: ${menuFabShapeMotionStiffness.toStringAsFixed(0)}, damping: ${menuFabShapeMotionDamping.toStringAsFixed(2)}),',
          );
        } else if (menuFabShapeMotionPreset !=
            M3EExampleMotionPreset.expressiveSpatialDefault) {
          buf.writeln(
            '    fabShapeMotion: M3EMotion.${menuFabShapeMotionPreset.name},',
          );
        }
        buf.writeln('  ),');
        buf.writeln('  items: const [');
        buf.writeln('    M3EFabMenuItem(');
        buf.writeln('      icon: Icon(Icons.share_rounded),');
        buf.writeln("      label: 'Share',");
        buf.writeln('      onPressed: null,');
        buf.writeln('    ),');
        buf.writeln('    M3EFabMenuItem(');
        buf.writeln('      icon: Icon(Icons.favorite_rounded),');
        buf.writeln("      label: 'Favorite',");
        buf.writeln('      onPressed: null,');
        buf.writeln('    ),');
        if (menuItemCount >= 3) {
          buf.writeln('    M3EFabMenuItem(');
          buf.writeln('      icon: Icon(Icons.edit_rounded),');
          buf.writeln("      label: 'Edit',");
          buf.writeln('      onPressed: null,');
          buf.writeln('    ),');
        }
        if (menuItemCount >= 4) {
          buf.writeln('    M3EFabMenuItem(');
          buf.writeln('      icon: Icon(Icons.delete_rounded),');
          buf.writeln("      label: 'Delete',");
          buf.writeln('      onPressed: null,');
          buf.writeln('    ),');
        }
        if (menuItemCount >= 5) {
          buf.writeln('    M3EFabMenuItem(');
          buf.writeln('      icon: Icon(Icons.download_rounded),');
          buf.writeln("      label: 'Download',");
          buf.writeln('      onPressed: null,');
          buf.writeln('    ),');
        }
        if (menuItemCount >= 6) {
          buf.writeln('    M3EFabMenuItem(');
          buf.writeln('      icon: Icon(Icons.settings_rounded),');
          buf.writeln("      label: 'Settings',");
          buf.writeln('      onPressed: null,');
          buf.writeln('    ),');
        }
        buf.writeln('  ],');
        buf.write(');');
      }
      return buf.toString();
    }

    // ── 1. Standard Button ──
    if (arch == ButtonArchitecture.standard) {
      buf.writeln("// Material 3 Expressive Standard Button");
      if (contentLayout == ButtonContentLayout.iconOnly) {
        buf.writeln("M3EButton(");
        buf.writeln("  style: M3EButtonStyle.${style.name},");
        buf.writeln("  size: ${sizeToCode(size)},");
        buf.writeln("  shape: M3EButtonShape.${shape.name},");
        if (!enabled) buf.writeln("  enabled: false,");
        if (buttonTooltip.isNotEmpty) {
          buf.writeln("  tooltip: '$buttonTooltip',");
        }
        buf.writeln("  onPressed: () { /* Tap action */ },");
        buf.writeln("  onLongPress: () { /* Long press action */ },");
        if (useDecoration) {
          buf.writeln("  decoration: M3EButtonDecoration.styleFrom(");
          if (useCustomColor) {
            buf.writeln("    backgroundColor: Colors.teal,");
          }
          if (useCustomFg) {
            buf.writeln("    foregroundColor: Colors.white,");
          }
          if (useBorder) {
            buf.writeln(
              "    side: const BorderSide(color: Colors.teal, width: ${borderWidth.toStringAsFixed(1)}),",
            );
          }
          if (restingBorderRadius > 0) {
            buf.writeln(
              "    borderRadius: ${restingBorderRadius.toStringAsFixed(1)},",
            );
          }
          if (pressedRadius != 8.0) {
            buf.writeln(
              "    pressedRadius: ${pressedRadius.toStringAsFixed(1)},",
            );
          }
          if (hoveredRadius != 16.0) {
            buf.writeln(
              "    hoveredRadius: ${hoveredRadius.toStringAsFixed(1)},",
            );
          }
          if (elevation > 0) {
            buf.writeln("    elevation: ${elevation.toStringAsFixed(1)},");
          }
          if (haptic != M3EHapticFeedback.none) {
            buf.writeln("    haptic: M3EHapticFeedback.${haptic.name},");
          }
          if (!enableFeedback) {
            buf.writeln("    enableFeedback: false,");
          }
          buf.writeln("  ),");
        }
        buf.writeln("  child: const Icon(Icons.rocket_launch_rounded),");
        buf.write(")");
      } else if (contentLayout == ButtonContentLayout.iconAndLabel) {
        buf.writeln("M3EButton.icon(");
        buf.writeln("  style: M3EButtonStyle.${style.name},");
        buf.writeln("  size: ${sizeToCode(size)},");
        buf.writeln("  shape: M3EButtonShape.${shape.name},");
        if (!enabled) buf.writeln("  enabled: false,");
        if (buttonTooltip.isNotEmpty) {
          buf.writeln("  tooltip: '$buttonTooltip',");
        }
        if (useDecoration || iconAlignment != IconAlignment.start) {
          buf.writeln("  decoration: M3EButtonDecoration.styleFrom(");
          if (iconAlignment != IconAlignment.start) {
            buf.writeln("    iconAlignment: IconAlignment.end,");
          }
          if (useCustomColor) {
            buf.writeln("    backgroundColor: Colors.teal,");
          }
          if (restingBorderRadius > 0) {
            buf.writeln(
              "    borderRadius: ${restingBorderRadius.toStringAsFixed(1)},",
            );
          }
          if (pressedRadius != 8.0) {
            buf.writeln(
              "    pressedRadius: ${pressedRadius.toStringAsFixed(1)},",
            );
          }
          buf.writeln("  ),");
        }
        buf.writeln("  icon: const Icon(Icons.rocket_launch_rounded),");
        buf.writeln("  label: const Text('$label'),");
        buf.writeln("  onPressed: () { /* Tap action */ },");
        buf.writeln("  onLongPress: () { /* Long press action */ },");
        buf.write(")");
      } else {
        buf.writeln("M3EButton(");
        buf.writeln("  style: M3EButtonStyle.${style.name},");
        buf.writeln("  size: ${sizeToCode(size)},");
        buf.writeln("  shape: M3EButtonShape.${shape.name},");
        if (!enabled) buf.writeln("  enabled: false,");
        if (buttonTooltip.isNotEmpty) {
          buf.writeln("  tooltip: '$buttonTooltip',");
        }
        buf.writeln("  onPressed: () { /* Tap action */ },");
        buf.writeln("  onLongPress: () { /* Long press action */ },");
        buf.writeln("  child: const Text('$label'),");
        buf.write(")");
      }
      return buf.toString();
    }

    // ── 2. Toggle Button ──
    if (arch == ButtonArchitecture.toggle) {
      buf.writeln("// Material 3 Expressive Pill / Toggle Button");
      buf.writeln("M3EToggleButton(");
      buf.writeln("  checked: _isChecked,");
      buf.writeln("  style: M3EButtonStyle.${style.name},");
      buf.writeln("  size: ${sizeToCode(size)},");
      if (allowMultilineLabel) {
        buf.writeln("  allowMultilineLabel: true,");
      }
      if (!enabled) buf.writeln("  enabled: false,");
      if (buttonTooltip.isNotEmpty) {
        buf.writeln("  tooltip: '$buttonTooltip',");
      }
      if (contentLayout != ButtonContentLayout.labelOnly) {
        buf.writeln("  icon: const Icon(Icons.rocket_launch_outlined),");
        if (useCustomCheckedIcon) {
          buf.writeln("  checkedIcon: const Icon(Icons.check_circle_rounded),");
        }
      }
      if (contentLayout != ButtonContentLayout.iconOnly) {
        buf.writeln("  label: const Text('$label'),");
        if (useCustomCheckedLabel) {
          buf.writeln("  checkedLabel: const Text('$checkedLabel'),");
        }
      }
      buf.writeln(
        "  onCheckedChange: (val) => setState(() => _isChecked = val),",
      );
      buf.write(")");
      return buf.toString();
    }

    // ── 3. Toggle Button Group ──
    if (arch == ButtonArchitecture.group) {
      if (groupPreset == GroupPreset.morphingCheckedLabel) {
        buf.writeln(
          "// Morphing Icon -> Checked Label Group (Expands text on selection)",
        );
        buf.writeln("M3EToggleButtonGroup(");
        buf.writeln("  style: M3EButtonStyle.${style.name},");
        buf.writeln("  spacing: ${spacing.toStringAsFixed(1)},");
        buf.writeln("  expandedRatio: ${expandedRatio.toStringAsFixed(2)},");
        buf.writeln("  decoration: M3EToggleButtonDecoration.styleFrom(");
        buf.writeln(
          "    motion: ${motionToCode(motionPreset, motionStiffness, motionDamping)},",
        );
        buf.writeln("  ),");
        buf.writeln("  selectedIndices: _multiSelectedIndices,");
        buf.writeln(
          "  onSelectedIndicesChanged: (indices) => setState(() => _multiSelectedIndices = indices),",
        );
        buf.writeln("  actions: [");
        buf.writeln("    M3EToggleButtonGroupAction(");
        buf.writeln("      icon: const Icon(Icons.format_bold_rounded),");
        buf.writeln("      checkedLabel: const Text('Bold'),");
        buf.writeln("      decoration: M3EToggleButtonDecoration.styleFrom(");
        buf.writeln("        haptic: M3EHapticFeedback.light,");
        buf.writeln("      ),");
        buf.writeln("    ),");
        buf.writeln("    M3EToggleButtonGroupAction(");
        buf.writeln("      icon: const Icon(Icons.format_italic_rounded),");
        buf.writeln("      checkedLabel: const Text('Italic'),");
        buf.writeln("      decoration: M3EToggleButtonDecoration.styleFrom(");
        buf.writeln("        haptic: M3EHapticFeedback.light,");
        buf.writeln("      ),");
        buf.writeln("    ),");
        buf.writeln("    M3EToggleButtonGroupAction(");
        buf.writeln("      icon: const Icon(Icons.format_underline_rounded),");
        buf.writeln("      checkedLabel: const Text('Underline'),");
        buf.writeln("      decoration: M3EToggleButtonDecoration.styleFrom(");
        buf.writeln("        haptic: M3EHapticFeedback.light,");
        buf.writeln("      ),");
        buf.writeln("    ),");
        buf.writeln("    M3EToggleButtonGroupAction(");
        buf.writeln(
          "      icon: const Icon(Icons.format_strikethrough_rounded),",
        );
        buf.writeln("      checkedLabel: const Text('Strike'),");
        buf.writeln("      decoration: M3EToggleButtonDecoration.styleFrom(");
        buf.writeln("        haptic: M3EHapticFeedback.light,");
        buf.writeln("      ),");
        buf.writeln("    ),");
        buf.writeln("  ],");
        buf.write(")");
        return buf.toString();
      }

      if (groupPreset == GroupPreset.composeVariableWidths) {
        buf.writeln("// Jetpack Compose Variable-Widths Toggle Button Group");
        buf.writeln("M3EToggleButtonGroup(");
        buf.writeln("  style: M3EButtonStyle.${style.name},");
        buf.writeln("  spacing: ${spacing.toStringAsFixed(1)},");
        buf.writeln("  expandedRatio: ${expandedRatio.toStringAsFixed(2)},");
        if (useCustomHeight) {
          buf.writeln(
            "  size: M3EButtonSize.custom(height: ${customHeight.toInt()}),",
          );
        } else {
          buf.writeln("  size: ${sizeToCode(size)},");
        }
        buf.writeln("  decoration: M3EToggleButtonDecoration.styleFrom(");
        buf.writeln("    haptic: M3EHapticFeedback.${haptic.name},");
        buf.writeln(
          "    motion: ${motionToCode(motionPreset, motionStiffness, motionDamping)},",
        );
        buf.writeln("    checkedRadius: ${checkedRadius.toStringAsFixed(0)},");
        buf.writeln("    pressedRadius: ${pressedRadius.toStringAsFixed(0)},");
        buf.writeln("  ),");
        buf.writeln("  neighborSquish: $neighborSquish,");
        buf.writeln("  selectedIndex: _singleSelectedIndex,");
        buf.writeln(
          "  onSelectedIndexChanged: (i) => setState(() => _singleSelectedIndex = i),",
        );
        buf.writeln("  actions: [");
        buf.writeln(
          "    const M3EToggleButtonGroupAction(icon: Icon(Icons.bluetooth)),",
        );
        buf.writeln(
          "    M3EToggleButtonGroupAction(icon: const Icon(Icons.alarm)${useVariableActionWidths ? ', width: 80' : ''}),",
        );
        buf.writeln(
          "    M3EToggleButtonGroupAction(icon: const Icon(Icons.link)${useVariableActionWidths ? ', width: 60' : ''}),",
        );
        buf.writeln(
          "    M3EToggleButtonGroupAction(icon: const Icon(Icons.wifi)${useVariableActionWidths ? ', width: 120' : ''}),",
        );
        buf.writeln("  ],");
        buf.write(")");
        return buf.toString();
      }

      buf.writeln("// Material 3 Expressive Toggle Button Group");
      buf.writeln("M3EToggleButtonGroup(");
      buf.writeln("  type: M3EButtonGroupType.${groupType.name},");
      buf.writeln("  style: M3EButtonStyle.${style.name},");
      if (useCustomHeight) {
        buf.writeln(
          "  size: M3EButtonSize.custom(height: ${customHeight.toInt()}),",
        );
      } else {
        buf.writeln("  size: ${sizeToCode(size)},");
      }
      buf.writeln("  shape: M3EButtonShape.${shape.name},");
      if (groupType == M3EButtonGroupType.standard && spacing > 0) {
        buf.writeln("  spacing: ${spacing.toStringAsFixed(1)},");
      }
      buf.writeln("  density: M3EButtonGroupDensity.${density.name},");
      if (direction != Axis.horizontal) {
        buf.writeln("  direction: Axis.vertical,");
      }
      if (groupType == M3EButtonGroupType.standard) {
        buf.writeln("  neighborSquish: $neighborSquish,");
        if (neighborSquish && expandedRatio != 0.15) {
          buf.writeln("  expandedRatio: ${expandedRatio.toStringAsFixed(2)},");
        }
      }
      buf.writeln("  overflow: M3EButtonGroupOverflow.${overflow.name},");
      if (overflow == M3EButtonGroupOverflow.menu) {
        buf.writeln(
          "  overflowMenuStyle: M3EButtonGroupOverflowMenuStyle.${overflowMenuStyle.name},",
        );
        if (overflowMenuStyle == M3EButtonGroupOverflowMenuStyle.popup) {
          buf.writeln(
            "  overflowPopupDecoration: const M3EOverflowPopupDecoration(useCardList: $overflowUseCardList),",
          );
        }
      }
      if (!groupMultiSelect) {
        buf.writeln("  selectedIndex: _singleSelectedIndex,");
        buf.writeln(
          "  onSelectedIndexChanged: (idx) => setState(() => _singleSelectedIndex = idx),",
        );
      } else {
        buf.writeln("  selectedIndices: _multiSelectedIndices,");
        buf.writeln(
          "  onSelectedIndicesChanged: (set) => setState(() => _multiSelectedIndices = set),",
        );
      }
      buf.writeln("  actions: [");
      buf.writeln("    M3EToggleButtonGroupAction(");
      if (groupShowIcon) {
        buf.writeln("      icon: const Icon(Icons.format_bold_rounded),");
      }
      if (groupShowCheckedIcon) {
        buf.writeln("      checkedIcon: const Icon(Icons.check_rounded),");
      }
      if (groupShowLabel) buf.writeln("      label: const Text('Bold'),");
      if (groupShowCheckedLabel) {
        buf.writeln("      checkedLabel: const Text('Bold (Active)'),");
      }
      buf.writeln("    ),");
      buf.writeln("    M3EToggleButtonGroupAction(");
      if (groupShowIcon) {
        buf.writeln("      icon: const Icon(Icons.format_italic_rounded),");
      }
      if (groupShowCheckedIcon) {
        buf.writeln("      checkedIcon: const Icon(Icons.check_rounded),");
      }
      if (groupShowLabel) buf.writeln("      label: const Text('Italic'),");
      if (groupShowCheckedLabel) {
        buf.writeln("      checkedLabel: const Text('Italic (Active)'),");
      }
      buf.writeln("    ),");
      buf.writeln("    M3EToggleButtonGroupAction(");
      if (hasDisabledAction) buf.writeln("      enabled: false,");
      if (groupShowIcon) {
        buf.writeln("      icon: const Icon(Icons.format_underlined_rounded),");
      }
      if (groupShowCheckedIcon) {
        buf.writeln("      checkedIcon: const Icon(Icons.check_rounded),");
      }
      if (groupShowLabel) {
        buf.writeln("      label: const Text('Underline'),");
      }
      if (groupShowCheckedLabel) {
        buf.writeln("      checkedLabel: const Text('Underline (Active)'),");
      }
      buf.writeln("    ),");
      buf.writeln("    M3EToggleButtonGroupAction(");
      if (groupShowIcon) {
        buf.writeln(
          "      icon: const Icon(Icons.format_strikethrough_rounded),",
        );
      }
      if (groupShowCheckedIcon) {
        buf.writeln("      checkedIcon: const Icon(Icons.check_rounded),");
      }
      if (groupShowLabel) buf.writeln("      label: const Text('Strike'),");
      if (groupShowCheckedLabel) {
        buf.writeln("      checkedLabel: const Text('Strike (Active)'),");
      }
      buf.writeln("    ),");
      buf.writeln("  ],");
      buf.write(")");
      return buf.toString();
    }

    // ── 4. Split Button ──
    final effectiveSplitStyle = style == M3EButtonStyle.text
        ? M3EButtonStyle.filled
        : style;
    buf.writeln("// Material 3 Expressive Split Button");
    buf.writeln("M3ESplitButton<String>(");
    buf.writeln("  style: M3EButtonStyle.${effectiveSplitStyle.name},");
    buf.writeln("  size: ${sizeToCode(size)},");
    buf.writeln("  shape: M3EButtonShape.${shape.name},");
    if (!enabled) buf.writeln("  enabled: false,");
    if (contentLayout != ButtonContentLayout.labelOnly) {
      buf.writeln("  leadingIcon: Icons.save_rounded,");
    }
    if (contentLayout != ButtonContentLayout.iconOnly) {
      buf.writeln("  label: '$splitSelectedValue',");
    }
    buf.writeln("  selectedValue: '$splitSelectedValue',");
    if (leadingTooltip.isNotEmpty) {
      buf.writeln("  leadingTooltip: '$leadingTooltip',");
    }
    if (trailingTooltip.isNotEmpty) {
      buf.writeln("  trailingTooltip: '$trailingTooltip',");
    }
    if (splitAlignment != M3ESplitButtonTrailingAlignment.opticalCenter) {
      buf.writeln(
        "  trailingAlignment: M3ESplitButtonTrailingAlignment.${splitAlignment.name},",
      );
    }
    if (useDecoration ||
        splitMenuStyle != SplitButtonMenuStyle.popup ||
        splitGap > 0 ||
        useCustomDividerColor) {
      buf.writeln("  decoration: M3ESplitButtonDecoration.styleFrom(");
      if (splitMenuStyle != SplitButtonMenuStyle.popup) {
        buf.writeln(
          "    menuStyle: SplitButtonMenuStyle.${splitMenuStyle.name},",
        );
      }
      if (splitGap > 0) {
        buf.writeln("    gap: ${splitGap.toStringAsFixed(1)},");
      }
      if (useCustomDividerColor) {
        buf.writeln("    dividerColor: Colors.teal,");
      }
      if (useCustomColor) {
        buf.writeln("    backgroundColor: Colors.teal,");
      }
      if (pressedRadius != 8.0) {
        buf.writeln("    pressedRadius: ${pressedRadius.toStringAsFixed(1)},");
      }
      buf.writeln("  ),");
    }
    buf.writeln("  items: const [");
    buf.writeln(
      "    M3ESplitButtonItem(value: 'Save Draft', child: Text('Save Draft')),",
    );
    buf.writeln(
      "    M3ESplitButtonItem(value: 'Save & Publish', child: Text('Save & Publish')),",
    );
    buf.writeln(
      "    M3ESplitButtonItem(value: 'Export PDF', child: Text('Export PDF')),",
    );
    buf.writeln(
      "    M3ESplitButtonItem(value: 'Archive', child: Text('Archive Item')),",
    );
    buf.writeln("  ],");
    buf.writeln("  onPressed: () { /* Trigger: $splitSelectedValue */ },");
    buf.writeln(
      "  onSelected: (val) => setState(() => _splitSelectedValue = val),",
    );
    buf.write(")");
    return buf.toString();
  }
}
