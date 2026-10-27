// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/menu_models.dart';

/// Generates live synchronized Dart code for M3EMenu based on playground knobs.
/// Produces clean component code ready for drop-in usage.
abstract final class MenuCodeSnippetGenerator {
  static String generate(MenuPlaygroundState state) {
    if (state.useCase == MenuUseCase.popupButton) {
      return _generatePopupMenuButton(state);
    }

    final variantStr =
        state.colorSchemeVariant == M3EMenuColorSchemeVariant.vibrant
        ? 'M3EMenuColorSchemeVariant.vibrant'
        : 'M3EMenuColorSchemeVariant.standard';

    String motionCode;
    if (state.motionPreset == M3EExampleMotionPreset.custom) {
      motionCode =
          "M3EMotion.custom(stiffness: ${state.spatialStiffness.toStringAsFixed(0)}, damping: ${state.spatialDamping.toStringAsFixed(2)})";
    } else {
      motionCode = "M3EMotion.${state.motionPreset.name}";
    }

    final buffer = StringBuffer();
    buffer.writeln("M3EMenuAnchor(");
    buffer.writeln("  controller: _menuController,");
    buffer.writeln("  colorSchemeVariant: $variantStr,");
    buffer.writeln("  consumeOutsideTaps: ${state.consumeOutsideTaps},");
    buffer.writeln("  anchorTapClosesMenu: ${state.anchorTapClosesMenu},");
    if (state.alignmentOffsetX != 0.0 || state.alignmentOffsetY != 0.0) {
      buffer.writeln(
        "  alignmentOffset: const Offset(${state.alignmentOffsetX.toStringAsFixed(0)}, ${state.alignmentOffsetY.toStringAsFixed(0)}),",
      );
    }
    buffer.writeln("  style: M3EMenuStyle(");
    buffer.writeln("    minWidth: ${state.minWidth.toStringAsFixed(0)},");
    buffer.writeln("    maxWidth: ${state.maxWidth.toStringAsFixed(0)},");
    if (state.enableMaxHeight) {
      buffer.writeln("    maxHeight: ${state.maxHeight.toStringAsFixed(0)},");
    }
    buffer.writeln("    elevation: ${state.elevation.toStringAsFixed(1)},");
    buffer.writeln("    spatialMotion: $motionCode,");
    buffer.writeln(
      "    animationStyle: M3EMenuAnimationStyle.${state.animationStyle.name},",
    );
    buffer.writeln("  ),");
    buffer.writeln("  builder: (context, controller, child) {");
    buffer.writeln("    return FilledButton.tonalIcon(");
    buffer.writeln("      onPressed: () => controller.toggle(),");
    buffer.writeln("      icon: const Icon(Icons.menu_rounded),");
    buffer.writeln(
      "      label: const Text('Open ${state.useCase.label} Menu'),",
    );
    buffer.writeln("    );");
    buffer.writeln("  },");
    buffer.writeln("  menuChildren: [");

    switch (state.useCase) {
      case MenuUseCase.actions:
        _writeActionsSnippet(buffer, state);
        break;
      case MenuUseCase.cascading:
        _writeCascadingSnippet(buffer, state);
        break;
      case MenuUseCase.preferences:
        _writePreferencesSnippet(buffer, state);
        break;
      case MenuUseCase.popupButton:
        _writeActionsSnippet(buffer, state);
        break;
      case MenuUseCase.multiSection:
        _writeActionsSnippet(buffer, state);
        if (!state.showGroups) {
          buffer.writeln(
            "    const Divider(height: 8, indent: 12, endIndent: 12),",
          );
        }
        _writeCascadingSnippet(buffer, state);
        if (!state.showGroups) {
          buffer.writeln(
            "    const Divider(height: 8, indent: 12, endIndent: 12),",
          );
        }
        _writePreferencesSnippet(buffer, state);
        break;
    }

    buffer.writeln("  ],");
    buffer.writeln(")");

    return buffer.toString();
  }

  /// Generates a copy-paste ready M3EPopupMenuButton snippet.
  static String _generatePopupMenuButton(MenuPlaygroundState state) {
    final variantStr =
        state.colorSchemeVariant == M3EMenuColorSchemeVariant.vibrant
        ? 'M3EMenuColorSchemeVariant.vibrant'
        : 'M3EMenuColorSchemeVariant.standard';

    String motionCode;
    if (state.motionPreset == M3EExampleMotionPreset.custom) {
      motionCode =
          "M3EMotion.custom(stiffness: ${state.spatialStiffness.toStringAsFixed(0)}, damping: ${state.spatialDamping.toStringAsFixed(2)})";
    } else {
      motionCode = "M3EMotion.${state.motionPreset.name}";
    }

    final buffer = StringBuffer();
    buffer.writeln("// Open it programmatically with a GlobalKey:");
    buffer.writeln(
      "// final popupKey = GlobalKey<M3EPopupMenuButtonState<String>>();",
    );
    buffer.writeln("// popupKey.currentState?.showButtonMenu();");
    buffer.writeln("");
    buffer.writeln("M3EPopupMenuButton<String>(");
    buffer.writeln("  key: popupKey,");
    buffer.writeln("  colorSchemeVariant: $variantStr,");
    buffer.writeln("  enabled: ${state.popupEnabled},");
    buffer.writeln("  requestFocus: ${state.popupRequestFocus},");
    buffer.writeln("  tooltip: 'Popup menu',");
    if (state.triggerIconSize != 24.0) {
      buffer.writeln(
        "  iconSize: ${state.triggerIconSize.toStringAsFixed(1)},",
      );
    }
    if (state.popupInitialValue != null) {
      buffer.writeln("  initialValue: '${state.popupInitialValue}',");
    }
    buffer.writeln("  style: M3EMenuStyle(");
    buffer.writeln("    minWidth: ${state.minWidth.toStringAsFixed(0)},");
    buffer.writeln("    maxWidth: ${state.maxWidth.toStringAsFixed(0)},");
    buffer.writeln("    elevation: ${state.elevation.toStringAsFixed(1)},");
    buffer.writeln("    position: M3EMenuPosition.${state.menuPosition.name},");
    buffer.writeln("    spatialMotion: $motionCode,");
    buffer.writeln(
      "    animationStyle: M3EMenuAnimationStyle.${state.animationStyle.name},",
    );
    buffer.writeln("  ),");
    buffer.writeln("  itemBuilder: (context) => [");
    buffer.writeln(
      "    M3EPopupMenuItem(value: 'cut', child: const Text('Cut')),",
    );
    buffer.writeln(
      "    M3EPopupMenuItem(value: 'copy', child: const Text('Copy')),",
    );
    buffer.writeln(
      "    M3EPopupMenuItem(value: 'paste', child: const Text('Paste')),",
    );
    buffer.writeln("    const M3EPopupMenuDivider(),");
    buffer.writeln(
      "    M3ECheckedPopupMenuItem(value: 'wrap', checked: ${state.showCheckedEntry}, child: const Text('Wrap lines')),",
    );
    buffer.writeln(
      "    M3EPopupMenuItem(value: 'disabled', enabled: false, child: const Text('Unavailable')),",
    );
    buffer.writeln("  ],");
    buffer.writeln("  onOpened: () => debugPrint('popup opened'),");
    buffer.writeln("  onSelected: (value) => debugPrint('selected \$value'),");
    buffer.writeln(
      "  onCanceled: () => debugPrint('dismissed without selection'),",
    );
    buffer.writeln(")");

    return buffer.toString();
  }

  static void _writeActionsSnippet(
    StringBuffer buffer,
    MenuPlaygroundState state,
  ) {
    final onPressedStr = state.enabled ? "() {}" : "null";

    if (state.showGroups) {
      buffer.writeln("    M3EMenuGroup(");
      buffer.writeln("      shapes: MenuGroupShapes.leading(),");
      buffer.writeln("      children: [");
      buffer.writeln(
        "        const M3EMenuGroupLabel(child: Text('Document')),",
      );
    }

    buffer.writeln("    M3EMenuItemButton(");
    buffer.writeln("      onPressed: $onPressedStr,");
    if (state.useCustomItemStyle) {
      buffer.writeln("      itemStyle: const M3EMenuItemStyle(minHeight: 52),");
    }
    if (state.showIcons) {
      buffer.writeln("      leadingIcon: const Icon(Icons.note_add_outlined),");
    }
    if (state.showShortcuts) {
      buffer.writeln(
        "      trailingIcon: const Text('⌘N', style: TextStyle(fontSize: 12)),",
      );
    }
    if (state.showSupportingText) {
      buffer.writeln(
        "      supportingText: const Text('Create a blank document'),",
      );
    }
    buffer.writeln("      child: const Text('New document'),");
    buffer.writeln("    ),");

    buffer.writeln("    M3EMenuItemButton(");
    buffer.writeln("      onPressed: $onPressedStr,");
    if (state.useCustomItemStyle) {
      buffer.writeln(
        "      itemStyle: const M3EMenuItemStyle(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10)),",
      );
    }
    if (state.showIcons) {
      buffer.writeln("      leadingIcon: const Icon(Icons.share_rounded),");
    }
    if (state.showShortcuts) {
      buffer.writeln(
        "      trailingIcon: const Text('⌘S', style: TextStyle(fontSize: 12)),",
      );
    }
    buffer.writeln("      child: const Text('Share'),");
    buffer.writeln("    ),");

    if (state.showGroups) {
      buffer.writeln("      ],");
      buffer.writeln("    ),");
      buffer.writeln("    M3EMenuGroup(");
      buffer.writeln("      shapes: MenuGroupShapes.trailing(),");
      buffer.writeln("      children: [");
      buffer.writeln(
        "        const M3EMenuGroupLabel(child: Text('Danger Zone')),",
      );
    } else {
      buffer.writeln(
        "    const Divider(height: 8, indent: 12, endIndent: 12),",
      );
    }

    buffer.writeln("    M3EMenuItemButton(");
    buffer.writeln("      onPressed: $onPressedStr,");
    if (state.showIcons) {
      buffer.writeln(
        "      leadingIcon: const Icon(Icons.delete_forever_rounded, color: Colors.red),",
      );
    }
    buffer.writeln(
      "      itemStyle: const M3EMenuItemStyle(foregroundColor: Colors.red),",
    );
    buffer.writeln("      child: const Text('Delete document'),");
    buffer.writeln("    ),");

    if (state.showGroups) {
      buffer.writeln("      ],");
      buffer.writeln("    ),");
    }
  }

  static void _writeCascadingSnippet(
    StringBuffer buffer,
    MenuPlaygroundState state,
  ) {
    final onPressedStr = state.enabled ? "() {}" : "null";

    if (state.showGroups) {
      buffer.writeln("    M3EMenuGroup(");
      buffer.writeln("      shapes: MenuGroupShapes.standalone(),");
      buffer.writeln("      children: [");
      buffer.writeln(
        "        const M3EMenuGroupLabel(child: Text('Actions')),",
      );
    }

    buffer.writeln("    M3EMenuItemButton(");
    buffer.writeln("      onPressed: $onPressedStr,");
    if (state.showIcons) {
      buffer.writeln("      leadingIcon: const Icon(Icons.save_outlined),");
    }
    buffer.writeln("      child: const Text('Quick save'),");
    buffer.writeln("    ),");

    buffer.writeln("    M3ESubmenuButton(");
    if (state.showIcons) {
      buffer.writeln(
        "      leadingIcon: const Icon(Icons.file_download_outlined),",
      );
    }
    buffer.writeln("      menuChildren: [");
    buffer.writeln(
      "        M3EMenuItemButton(onPressed: $onPressedStr, child: const Text('PDF Document (.pdf)')),",
    );
    buffer.writeln(
      "        M3EMenuItemButton(onPressed: $onPressedStr, child: const Text('PNG Image (.png)')),",
    );
    buffer.writeln(
      "        M3EMenuItemButton(onPressed: $onPressedStr, child: const Text('SVG Vector (.svg)')),",
    );
    buffer.writeln("      ],");
    buffer.writeln("      child: const Text('Export as'),");
    buffer.writeln("    ),");

    buffer.writeln("    M3ESubmenuButton(");
    if (state.showIcons) {
      buffer.writeln("      leadingIcon: const Icon(Icons.sort_rounded),");
    }
    buffer.writeln("      menuChildren: [");
    buffer.writeln(
      "        M3EMenuItemButton(onPressed: $onPressedStr, child: const Text('Name (A-Z)')),",
    );
    buffer.writeln(
      "        M3EMenuItemButton(onPressed: $onPressedStr, child: const Text('Date modified')),",
    );
    buffer.writeln("      ],");
    buffer.writeln("      child: const Text('Sort order'),");
    buffer.writeln("    ),");

    if (state.showGroups) {
      buffer.writeln("      ],");
      buffer.writeln("    ),");
    }
  }

  static String _itemStyleSnippet(MenuPlaygroundState state) {
    if (!state.useCustomItemStyle) return "";
    final h = state.itemHorizontalPadding.toStringAsFixed(0);
    final v = state.itemVerticalPadding.toStringAsFixed(0);
    final bool hasSelection =
        state.useCase == MenuUseCase.preferences ||
        state.useCase == MenuUseCase.multiSection;
    if (hasSelection) {
      return "      itemStyle: M3EMenuItemStyle(\n"
          "        padding: const EdgeInsets.symmetric(horizontal: $h, vertical: $v),\n"
          "        selectedBackgroundColor: colorScheme.${state.itemColorPreset.name},\n"
          "      ),\n";
    }
    return "      itemStyle: const M3EMenuItemStyle(\n"
        "        padding: EdgeInsets.symmetric(horizontal: $h, vertical: $v),\n"
        "      ),\n";
  }

  static void _writePreferencesSnippet(
    StringBuffer buffer,
    MenuPlaygroundState state,
  ) {
    final enabledProp = state.enabled ? "" : "      enabled: false,\n";
    final styleSnippet = _itemStyleSnippet(state);

    if (state.preferencesIndicatorStyle ==
        PreferencesIndicatorStyle.activityIcons) {
      final isMulti =
          state.preferencesSelectionMode ==
          PreferencesSelectionMode.multiSelect;
      if (state.showGroups) {
        buffer.writeln("    M3EMenuGroup(");
        buffer.writeln("      shapes: MenuGroupShapes.standalone(),");
        buffer.writeln("      children: [");
        buffer.writeln(
          "        const M3EMenuGroupLabel(child: Text('${isMulti ? "Active Profiles (Multi)" : "Active Profile (Single)"}')),",
        );
      }

      if (isMulti) {
        buffer.writeln("        M3ECheckboxMenuButton(");
        buffer.writeln("          value: true,");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln(
          "          leadingIcon: const Icon(Icons.directions_walk_rounded),",
        );
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Walking'),");
        buffer.writeln("        ),");
        buffer.writeln("        M3ECheckboxMenuButton(");
        buffer.writeln("          value: false,");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln(
          "          leadingIcon: const Icon(Icons.sports_esports_rounded),",
        );
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Gaming'),");
        buffer.writeln("        ),");
      } else {
        buffer.writeln("        M3ERadioMenuButton<String>(");
        buffer.writeln("          value: 'Walking',");
        buffer.writeln("          groupValue: 'Walking',");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln(
          "          leadingIcon: const Icon(Icons.directions_walk_rounded),",
        );
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Walking'),");
        buffer.writeln("        ),");
        buffer.writeln("        M3ERadioMenuButton<String>(");
        buffer.writeln("          value: 'Gaming',");
        buffer.writeln("          groupValue: 'Walking',");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln(
          "          leadingIcon: const Icon(Icons.sports_esports_rounded),",
        );
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Gaming'),");
        buffer.writeln("        ),");
      }

      if (state.showGroups) {
        buffer.writeln("      ],");
        buffer.writeln("    ),");
      }
      return;
    }

    if (state.preferencesIndicatorStyle == PreferencesIndicatorStyle.tickIcon) {
      final isMulti =
          state.preferencesSelectionMode ==
          PreferencesSelectionMode.multiSelect;
      if (state.showGroups) {
        buffer.writeln("    M3EMenuGroup(");
        buffer.writeln("      shapes: MenuGroupShapes.standalone(),");
        buffer.writeln("      children: [");
        buffer.writeln(
          "        const M3EMenuGroupLabel(child: Text('${isMulti ? "Settings & Sync" : "View Layout"}')),",
        );
      }

      if (isMulti) {
        buffer.writeln("        M3ECheckboxMenuButton(");
        buffer.writeln("          value: true,");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Auto-save changes'),");
        buffer.writeln("        ),");
        buffer.writeln("        M3ECheckboxMenuButton(");
        buffer.writeln("          value: false,");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Push notifications'),");
        buffer.writeln("        ),");
      } else {
        buffer.writeln("        M3ECheckboxMenuButton(");
        buffer.writeln("          value: true,");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('Grid layout'),");
        buffer.writeln("        ),");
        buffer.writeln("        M3ECheckboxMenuButton(");
        buffer.writeln("          value: false,");
        if (!state.enabled) buffer.write("    $enabledProp");
        if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
        buffer.writeln("          closeOnActivate: false,");
        buffer.writeln("          onChanged: (val) {},");
        buffer.writeln("          child: const Text('List layout'),");
        buffer.writeln("        ),");
      }

      if (state.showGroups) {
        buffer.writeln("      ],");
        buffer.writeln("    ),");
      }
      return;
    }

    // Square Checkbox & Radio
    final isMulti =
        state.preferencesSelectionMode == PreferencesSelectionMode.multiSelect;
    if (state.showGroups) {
      buffer.writeln("    M3EMenuGroup(");
      buffer.writeln("      shapes: MenuGroupShapes.standalone(),");
      buffer.writeln("      children: [");
      buffer.writeln(
        "        const M3EMenuGroupLabel(child: Text('${isMulti ? "Settings & Sync" : "View Layout"}')),",
      );
    }

    if (isMulti) {
      buffer.writeln("        M3ECheckboxMenuButton(");
      buffer.writeln("          value: true,");
      if (!state.enabled) buffer.write("    $enabledProp");
      if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
      buffer.writeln("          closeOnActivate: false,");
      buffer.writeln(
        "          leadingIcon: const Checkbox(value: true, onChanged: null),",
      );
      buffer.writeln("          onChanged: (val) {},");
      buffer.writeln("          child: const Text('Auto-save changes'),");
      buffer.writeln("        ),");
      buffer.writeln("        M3ECheckboxMenuButton(");
      buffer.writeln("          value: false,");
      if (!state.enabled) buffer.write("    $enabledProp");
      if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
      buffer.writeln("          closeOnActivate: false,");
      buffer.writeln(
        "          leadingIcon: const Checkbox(value: false, onChanged: null),",
      );
      buffer.writeln("          onChanged: (val) {},");
      buffer.writeln("          child: const Text('Push notifications'),");
      buffer.writeln("        ),");
    } else {
      buffer.writeln("        M3ERadioMenuButton<String>(");
      buffer.writeln("          value: 'Grid',");
      buffer.writeln("          groupValue: 'Grid',");
      if (!state.enabled) buffer.write("    $enabledProp");
      if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
      buffer.writeln("          closeOnActivate: false,");
      buffer.writeln("          onChanged: (val) {},");
      buffer.writeln("          child: const Text('Grid layout'),");
      buffer.writeln("        ),");
      buffer.writeln("        M3ERadioMenuButton<String>(");
      buffer.writeln("          value: 'List',");
      buffer.writeln("          groupValue: 'Grid',");
      if (!state.enabled) buffer.write("    $enabledProp");
      if (styleSnippet.isNotEmpty) buffer.write("    $styleSnippet");
      buffer.writeln("          closeOnActivate: false,");
      buffer.writeln("          onChanged: (val) {},");
      buffer.writeln("          child: const Text('List layout'),");
      buffer.writeln("        ),");
    }

    if (state.showGroups) {
      buffer.writeln("      ],");
      buffer.writeln("    ),");
    }
  }
}
