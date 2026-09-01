// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/floating_toolbar_models.dart';

class FloatingToolbarCodeSnippets {
  static String _number(double v) => v.toStringAsFixed(1);

  static String generate({
    required ToolbarVariant variant,
    required ToolbarContentPreset effectiveContentPreset,
    required ToolbarScreenAlignment screenAlignment,
    required bool showLeading,
    required bool showTrailing,
    required double itemSpacing,
    required double expandedElevation,
    required double collapsedElevation,
    required double containerSize,
    required String tooltip,
    required bool enableA11yCallbacks,
    required ToolbarColorMode colorMode,
    required Color customContainerColor,
    required Color customContentColor,
    required Color customFabColor,
    required Color customFabContentColor,
    required bool useCustomRadius,
    required double customRadius,
    required double contentPaddingH,
    required double contentPaddingV,
    required M3EExampleMotionPreset motionPreset,
    required double stiffness,
    required double damping,
    required M3EFloatingToolbarHorizontalFabPosition horizontalFabPosition,
    required M3EFloatingToolbarVerticalFabPosition verticalFabPosition,
    required bool enableScrollBehavior,
    required M3EFloatingToolbarExitDirection exitDirection,
    required FabActionMode fabActionMode,
    required String customFabIconName,
    required String fabActionToast,
    required M3EHapticFeedback haptic,
    required bool useCustomSplashColor,
    required Color customSplashColor,
    required double splashAlpha,
  }) {
    final buf = StringBuffer();

    buf.writeln("// State variables in your StatefulWidget:");
    if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
      buf.writeln("int selectedIndex = 0;");
    }
    buf.writeln("bool isExpanded = true;\n");

    if (variant == ToolbarVariant.docked) {
      buf.writeln("// M3EDockedToolbar (full width bottom toolbar)");
      buf.writeln("M3EDockedToolbar(");
      if (showLeading) {
        buf.writeln("  leading: M3EButton(");
        buf.writeln("    style: M3EButtonStyle.text,");
        buf.writeln("    shape: M3EButtonShape.round,");
        buf.writeln("    size: M3EButtonSize.sm,");
        buf.writeln("    child: const Icon(Icons.menu_rounded, size: 20),");
        buf.writeln("    onPressed: () {},");
        buf.writeln("  ),");
      }
      buf.writeln("  content: Row(");
      buf.writeln("    spacing: ${_number(itemSpacing)},");
      buf.writeln("    mainAxisAlignment: MainAxisAlignment.spaceEvenly,");
      buf.writeln("    children: [");
      if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
        buf.writeln("      // Expressive Interactive Navigation Tabs");
        buf.writeln(
          "      _M3ENavBarTab(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home', isSelected: selectedIndex == 0, onTap: () => setState(() => selectedIndex = 0)),",
        );
        buf.writeln(
          "      _M3ENavBarTab(icon: Icons.search_rounded, selectedIcon: Icons.search_rounded, label: 'Search', isSelected: selectedIndex == 1, onTap: () => setState(() => selectedIndex = 1)),",
        );
        buf.writeln(
          "      _M3ENavBarTab(icon: Icons.favorite_outline_rounded, selectedIcon: Icons.favorite_rounded, label: 'Saved', isSelected: selectedIndex == 2, onTap: () => setState(() => selectedIndex = 2)),",
        );
        buf.writeln(
          "      _M3ENavBarTab(icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: 'Profile', isSelected: selectedIndex == 3, onTap: () => setState(() => selectedIndex = 3)),",
        );
      } else {
        buf.writeln(
          "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.format_bold_rounded, size: 20), onPressed: () {}),",
        );
        buf.writeln(
          "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.format_italic_rounded, size: 20), onPressed: () {}),",
        );
        buf.writeln(
          "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.format_underlined_rounded, size: 20), onPressed: () {}),",
        );
        buf.writeln(
          "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.highlight_rounded, size: 20), onPressed: () {}),",
        );
      }
      buf.writeln("    ],");
      buf.writeln("  ),");
      if (showTrailing) {
        buf.writeln("  trailing: M3EButton(");
        buf.writeln("    style: M3EButtonStyle.text,");
        buf.writeln("    shape: M3EButtonShape.round,");
        buf.writeln("    size: M3EButtonSize.sm,");
        buf.writeln(
          "    child: const Icon(Icons.more_vert_rounded, size: 20),",
        );
        buf.writeln("    onPressed: () {},");
        buf.writeln("  ),");
      }
      if (expandedElevation != 2.0) {
        buf.writeln("  elevation: ${_number(expandedElevation)},");
      }
      if (containerSize != 64.0) {
        buf.writeln("  height: ${_number(containerSize)},");
      }
      if (tooltip.isNotEmpty) {
        buf.writeln("  tooltip: '$tooltip',");
      }
      if (enableA11yCallbacks) {
        buf.writeln("  onExpandA11y: () => print('Expanded'),");
        buf.writeln("  onCollapseA11y: () => print('Collapsed'),");
      }
      buf.write(")");
      if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
        _appendNavBarTabCode(
          buf,
          colorMode,
          customFabColor,
          customContentColor,
          useCustomSplashColor,
          customSplashColor,
          splashAlpha,
          haptic,
          motionPreset,
          stiffness,
          damping,
        );
      }
      return buf.toString();
    }

    final isHorizontal =
        variant == ToolbarVariant.horizontalFloating ||
        variant == ToolbarVariant.horizontalFab;
    final isFab =
        variant == ToolbarVariant.horizontalFab ||
        variant == ToolbarVariant.verticalFab;

    final className = isHorizontal
        ? (isFab
              ? 'M3EFabHorizontalFloatingToolbar'
              : 'M3EHorizontalFloatingToolbar')
        : (isFab
              ? 'M3EFabVerticalFloatingToolbar'
              : 'M3EVerticalFloatingToolbar');

    final alignName = screenAlignment.alignment == Alignment.centerRight
        ? 'centerRight'
        : (screenAlignment.alignment == Alignment.bottomCenter
              ? 'bottomCenter'
              : screenAlignment.alignment == Alignment.centerLeft
              ? 'centerLeft'
              : screenAlignment.alignment == Alignment.bottomRight
              ? 'bottomRight'
              : screenAlignment.alignment == Alignment.bottomLeft
              ? 'bottomLeft'
              : 'topCenter');

    buf.writeln(
      "// Placed within a Stack or screen layout (Screen Alignment: ${screenAlignment.label}):",
    );
    buf.writeln("$className(");
    buf.writeln("  expanded: isExpanded,");
    buf.writeln("  alignment: Alignment.$alignName,");

    buf.writeln("  decoration: M3EFloatingToolbarDecoration(");
    if (colorMode == ToolbarColorMode.standard) {
      buf.writeln(
        "    colors: M3EFloatingToolbarDefaults.standardColors(context),",
      );
    } else if (colorMode == ToolbarColorMode.vibrant) {
      buf.writeln(
        "    colors: M3EFloatingToolbarDefaults.vibrantColors(context),",
      );
    } else if (colorMode == ToolbarColorMode.expressive) {
      buf.writeln("    colors: M3EFloatingToolbarColors(");
      buf.writeln("      toolbarContainerColor: theme.colorScheme.primary,");
      buf.writeln("      toolbarContentColor: theme.colorScheme.onPrimary,");
      buf.writeln(
        "      fabContainerColor: theme.colorScheme.primaryContainer,",
      );
      buf.writeln(
        "      fabContentColor: theme.colorScheme.onPrimaryContainer,",
      );
      buf.writeln("    ),");
    } else {
      buf.writeln("    colors: const M3EFloatingToolbarColors(");
      buf.writeln(
        "      toolbarContainerColor: Color(0x${customContainerColor.toARGB32().toRadixString(16).toUpperCase()}),",
      );
      buf.writeln(
        "      toolbarContentColor: Color(0x${customContentColor.toARGB32().toRadixString(16).toUpperCase()}),",
      );
      buf.writeln(
        "      fabContainerColor: Color(0x${customFabColor.toARGB32().toRadixString(16).toUpperCase()}),",
      );
      buf.writeln(
        "      fabContentColor: Color(0x${customFabContentColor.toARGB32().toRadixString(16).toUpperCase()}),",
      );
      buf.writeln("    ),");
    }

    if (useCustomRadius) {
      buf.writeln(
        "    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(${_number(customRadius)})),",
      );
    }
    if (containerSize != 64.0) {
      buf.writeln("    containerSize: ${_number(containerSize)},");
    }
    if (contentPaddingH != 8.0 || contentPaddingV != 8.0) {
      buf.writeln(
        "    contentPadding: const EdgeInsets.symmetric(horizontal: ${_number(contentPaddingH)}, vertical: ${_number(contentPaddingV)}),",
      );
    }
    if (expandedElevation != 2.0) {
      buf.writeln(
        "    expandedShadowElevation: ${_number(expandedElevation)},",
      );
    }
    if (collapsedElevation != 0.0) {
      buf.writeln(
        "    collapsedShadowElevation: ${_number(collapsedElevation)},",
      );
    }
    if (motionPreset == M3EExampleMotionPreset.custom) {
      buf.writeln(
        "    motion: M3EMotion.custom(stiffness: ${stiffness.toStringAsFixed(0)}, damping: ${damping.toStringAsFixed(2)}),",
      );
    } else {
      buf.writeln("    motion: M3EMotion.${motionPreset.name},");
    }
    buf.writeln("  ),");

    if (isFab) {
      if (isHorizontal) {
        buf.writeln(
          "  fabPosition: M3EFloatingToolbarHorizontalFabPosition.${horizontalFabPosition.name},",
        );
      } else {
        buf.writeln(
          "  fabPosition: M3EFloatingToolbarVerticalFabPosition.${verticalFabPosition.name},",
        );
      }
    }

    if (enableScrollBehavior) {
      buf.writeln(
        "  scrollBehavior: M3EFloatingToolbarScrollBehavior.exitAlways(",
      );
      buf.writeln(
        "    exitDirection: M3EFloatingToolbarExitDirection.${exitDirection.name},",
      );
      buf.writeln("  ),");
    }

    if (tooltip.isNotEmpty) {
      buf.writeln("  tooltip: '$tooltip',");
    }

    if (enableA11yCallbacks) {
      buf.writeln("  onExpandA11y: () => setState(() => isExpanded = true),");
      buf.writeln(
        "  onCollapseA11y: () => setState(() => isExpanded = false),",
      );
    }

    if (!isFab && showLeading) {
      buf.writeln("  leadingContent: const Padding(");
      buf.writeln("    padding: EdgeInsets.symmetric(horizontal: 4.0),");
      buf.writeln("    child: Icon(Icons.palette_outlined),");
      buf.writeln("  ),");
    }

    if (!isFab && showTrailing) {
      buf.writeln("  trailingContent: const Padding(");
      buf.writeln("    padding: EdgeInsets.symmetric(horizontal: 4.0),");
      buf.writeln("    child: Icon(Icons.more_vert_rounded),");
      buf.writeln("  ),");
    }

    final flex = isHorizontal ? 'Row' : 'Column';
    buf.writeln("  content: $flex(");
    buf.writeln("    mainAxisSize: MainAxisSize.min,");
    buf.writeln("    spacing: ${_number(itemSpacing)},");
    buf.writeln("    children: [");
    if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
      buf.writeln(
        "      _M3ENavBarTab(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home', isSelected: selectedIndex == 0, onTap: () => setState(() => selectedIndex = 0)),",
      );
      buf.writeln(
        "      _M3ENavBarTab(icon: Icons.search_rounded, selectedIcon: Icons.search_rounded, label: 'Search', isSelected: selectedIndex == 1, onTap: () => setState(() => selectedIndex = 1)),",
      );
      buf.writeln(
        "      _M3ENavBarTab(icon: Icons.favorite_outline_rounded, selectedIcon: Icons.favorite_rounded, label: 'Saved', isSelected: selectedIndex == 2, onTap: () => setState(() => selectedIndex = 2)),",
      );
      buf.writeln(
        "      _M3ENavBarTab(icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: 'Profile', isSelected: selectedIndex == 3, onTap: () => setState(() => selectedIndex = 3)),",
      );
    } else {
      buf.writeln(
        "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.format_bold_rounded, size: 20), onPressed: () {}),",
      );
      buf.writeln(
        "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.format_italic_rounded, size: 20), onPressed: () {}),",
      );
      buf.writeln(
        "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.format_underlined_rounded, size: 20), onPressed: () {}),",
      );
      buf.writeln(
        "      M3EButton(style: M3EButtonStyle.text, shape: M3EButtonShape.round, size: M3EButtonSize.sm, child: const Icon(Icons.highlight_rounded, size: 20), onPressed: () {}),",
      );
    }
    buf.writeln("    ],");
    buf.writeln("  ),");

    if (isFab) {
      buf.writeln("  floatingActionButton: M3EFloatingActionButton(");
      buf.writeln("    elevation: 0,");
      if (fabActionMode == FabActionMode.toggleExpansion) {
        if (haptic != M3EHapticFeedback.none) {
          buf.writeln("    onPressed: () {");
          buf.writeln("      M3EHapticFeedback.${haptic.name}.apply();");
          buf.writeln("      setState(() => isExpanded = !isExpanded);");
          buf.writeln("    },");
        } else {
          buf.writeln(
            "    onPressed: () => setState(() => isExpanded = !isExpanded),",
          );
        }
        buf.writeln(
          "    child: Icon(isExpanded ? Icons.close_rounded : Icons.edit_rounded),",
        );
      } else {
        buf.writeln("    onPressed: () {");
        if (haptic != M3EHapticFeedback.none) {
          buf.writeln("      M3EHapticFeedback.${haptic.name}.apply();");
        }
        buf.writeln("      // Trigger custom primary action");
        buf.writeln("      ScaffoldMessenger.of(context).showSnackBar(");
        buf.writeln(
          "        const SnackBar(content: Text('$fabActionToast')),",
        );
        buf.writeln("      );");
        buf.writeln("    },");
        buf.writeln("    child: const Icon(Icons.$customFabIconName),");
      }
      buf.writeln("  ),");
    }

    buf.write(")");

    if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
      _appendNavBarTabCode(
        buf,
        colorMode,
        customFabColor,
        customContentColor,
        useCustomSplashColor,
        customSplashColor,
        splashAlpha,
        haptic,
        motionPreset,
        stiffness,
        damping,
      );
    }

    return buf.toString();
  }

  static void _appendNavBarTabCode(
    StringBuffer buf,
    ToolbarColorMode colorMode,
    Color customFabColor,
    Color customContentColor,
    bool useCustomSplashColor,
    Color customSplashColor,
    double splashAlpha,
    M3EHapticFeedback haptic,
    M3EExampleMotionPreset motionPreset,
    double stiffness,
    double damping,
  ) {
    buf.writeln(
      "\n\n// ── Helper Tab Widget (Spring Physics & Splash Highlight) ──",
    );
    buf.writeln("class _M3ENavBarTab extends StatefulWidget {");
    buf.writeln("  final IconData icon;");
    buf.writeln("  final IconData? selectedIcon;");
    buf.writeln("  final String label;");
    buf.writeln("  final bool isSelected;");
    buf.writeln("  final M3EHapticFeedback haptic;");
    buf.writeln("  final VoidCallback onTap;");
    buf.writeln("");
    buf.writeln("  const _M3ENavBarTab({");
    buf.writeln("    super.key,");
    buf.writeln("    required this.icon,");
    buf.writeln("    this.selectedIcon,");
    buf.writeln("    required this.label,");
    buf.writeln("    required this.isSelected,");
    buf.writeln("    this.haptic = M3EHapticFeedback.${haptic.name},");
    buf.writeln("    required this.onTap,");
    buf.writeln("  });");
    buf.writeln("");
    buf.writeln("  @override");
    buf.writeln(
      "  State<_M3ENavBarTab> createState() => _M3ENavBarTabState();",
    );
    buf.writeln("}");
    buf.writeln("");
    buf.writeln("class _M3ENavBarTabState extends State<_M3ENavBarTab>");
    buf.writeln("    with SingleTickerProviderStateMixin {");
    buf.writeln("  late final SingleMotionController _controller;");
    buf.writeln("");
    buf.writeln("  @override");
    buf.writeln("  void initState() {");
    buf.writeln("    super.initState();");
    if (motionPreset == M3EExampleMotionPreset.custom) {
      buf.writeln(
        "    _controller = SingleMotionController(\n      motion: M3EMotion.custom(stiffness: ${stiffness.toStringAsFixed(0)}, damping: ${damping.toStringAsFixed(2)}).toMotion(),\n      vsync: this,\n      initialValue: widget.isSelected ? 1.0 : 0.0,\n    );",
      );
    } else {
      buf.writeln(
        "    _controller = SingleMotionController(\n      motion: M3EMotion.${motionPreset.name}.toMotion(),\n      vsync: this,\n      initialValue: widget.isSelected ? 1.0 : 0.0,\n    );",
      );
    }
    buf.writeln("  }");
    buf.writeln("");
    buf.writeln("  @override");
    buf.writeln("  void didUpdateWidget(covariant _M3ENavBarTab oldWidget) {");
    buf.writeln("    super.didUpdateWidget(oldWidget);");
    buf.writeln("    if (widget.isSelected != oldWidget.isSelected) {");
    buf.writeln("      _controller.animateTo(widget.isSelected ? 1.0 : 0.0);");
    buf.writeln("    }");
    buf.writeln("  }");
    buf.writeln("");
    buf.writeln("  @override");
    buf.writeln("  void dispose() {");
    buf.writeln("    _controller.dispose();");
    buf.writeln("    super.dispose();");
    buf.writeln("  }");
    buf.writeln("");
    buf.writeln("  @override");
    buf.writeln("  Widget build(BuildContext context) {");
    buf.writeln("    final theme = Theme.of(context);");
    buf.writeln("    final cs = theme.colorScheme;");
    buf.writeln("");
    buf.writeln("    return AnimatedBuilder(");
    buf.writeln("      animation: _controller,");
    buf.writeln("      builder: (context, child) {");
    buf.writeln("        final progress = _controller.value.clamp(0.0, 1.0);");
    buf.writeln(
      "        final double width = lerpDouble(48.0, 110.0, progress)!;",
    );
    buf.writeln("");
    if (colorMode == ToolbarColorMode.expressive) {
      buf.writeln("        final Color selectedBg = cs.surface;");
      buf.writeln("        final Color selectedFg = cs.primary;");
      buf.writeln("        final Color unselectedFg = cs.onPrimary;");
    } else if (colorMode == ToolbarColorMode.vibrant) {
      buf.writeln("        final Color selectedBg = cs.surfaceContainer;");
      buf.writeln("        final Color selectedFg = cs.onSurface;");
      buf.writeln("        final Color unselectedFg = cs.onPrimaryContainer;");
    } else if (colorMode == ToolbarColorMode.standard) {
      buf.writeln(
        "        final Color selectedBg = cs.primaryContainer.withValues(alpha: 0.6);",
      );
      buf.writeln("        final Color selectedFg = cs.primary;");
      buf.writeln("        final Color unselectedFg = cs.onSurfaceVariant;");
    } else {
      buf.writeln(
        "        final Color selectedBg = const Color(0x${customFabColor.toARGB32().toRadixString(16).toUpperCase()}).withValues(alpha: 0.35);",
      );
      buf.writeln(
        "        final Color selectedFg = const Color(0x${customFabColor.toARGB32().toRadixString(16).toUpperCase()});",
      );
      buf.writeln(
        "        final Color unselectedFg = const Color(0x${customContentColor.toARGB32().toRadixString(16).toUpperCase()});",
      );
    }
    buf.writeln("");
    buf.writeln(
      "        final Color bgColor = widget.isSelected ? selectedBg : Colors.transparent;",
    );
    buf.writeln(
      "        final Color contentColor = widget.isSelected ? selectedFg : unselectedFg;",
    );
    buf.writeln("");
    buf.writeln("        return Container(");
    buf.writeln("          width: width,");
    buf.writeln("          height: 48.0,");
    buf.writeln(
      "          margin: const EdgeInsets.symmetric(horizontal: 4.0),",
    );
    buf.writeln("          decoration: BoxDecoration(");
    buf.writeln("            color: bgColor,");
    buf.writeln("            borderRadius: BorderRadius.circular(24.0),");
    buf.writeln("          ),");
    buf.writeln("          child: Material(");
    buf.writeln("            color: Colors.transparent,");
    buf.writeln("            child: InkWell(");
    buf.writeln("              borderRadius: BorderRadius.circular(24.0),");
    buf.writeln("              onTap: () {");
    if (haptic != M3EHapticFeedback.none) {
      buf.writeln("                widget.haptic.apply();");
    }
    buf.writeln("                widget.onTap();");
    buf.writeln("              },");
    buf.writeln(
      "              overlayColor: WidgetStateProperty.resolveWith((states) {",
    );
    if (useCustomSplashColor) {
      buf.writeln(
        "                final baseSplash = const Color(0x${customSplashColor.toARGB32().toRadixString(16).toUpperCase()});",
      );
    } else {
      buf.writeln("                final baseSplash = contentColor;");
    }
    buf.writeln("                if (states.contains(WidgetState.pressed)) {");
    buf.writeln(
      "                  return baseSplash.withValues(alpha: ${_number(splashAlpha)});",
    );
    buf.writeln("                }");
    buf.writeln("                if (states.contains(WidgetState.hovered)) {");
    buf.writeln("                  return baseSplash.withValues(alpha: 0.08);");
    buf.writeln("                }");
    buf.writeln("                return null;");
    buf.writeln("              }),");
    buf.writeln("              child: ClipRect(");
    buf.writeln("                child: Center(");
    buf.writeln("                  child: OverflowBox(");
    buf.writeln("                    minWidth: 0,");
    buf.writeln("                    maxWidth: 140,");
    buf.writeln("                    minHeight: 0,");
    buf.writeln("                    maxHeight: 48,");
    buf.writeln("                    alignment: Alignment.center,");
    buf.writeln("                    child: Row(");
    buf.writeln("                      mainAxisSize: MainAxisSize.min,");
    buf.writeln(
      "                      mainAxisAlignment: MainAxisAlignment.center,",
    );
    buf.writeln("                      children: [");
    buf.writeln("                        Icon(");
    buf.writeln("                          widget.isSelected");
    buf.writeln(
      "                              ? (widget.selectedIcon ?? widget.icon)",
    );
    buf.writeln("                              : widget.icon,");
    buf.writeln("                          color: contentColor,");
    buf.writeln("                          size: 24.0,");
    buf.writeln("                        ),");
    buf.writeln("                        if (progress > 0.01)");
    buf.writeln("                          ClipRect(");
    buf.writeln("                            child: Align(");
    buf.writeln(
      "                              alignment: Alignment.centerLeft,",
    );
    buf.writeln("                              widthFactor: progress,");
    buf.writeln("                              child: Opacity(");
    buf.writeln("                                opacity: progress,");
    buf.writeln("                                child: Padding(");
    buf.writeln(
      "                                  padding: const EdgeInsets.only(left: 6.0),",
    );
    buf.writeln("                                  child: Text(");
    buf.writeln("                                    widget.label,");
    buf.writeln(
      "                                    style: theme.textTheme.bodyMedium?.copyWith(",
    );
    buf.writeln("                                      color: contentColor,");
    buf.writeln(
      "                                      fontWeight: FontWeight.w600,",
    );
    buf.writeln("                                    ),");
    buf.writeln("                                    maxLines: 1,");
    buf.writeln(
      "                                    overflow: TextOverflow.clip,",
    );
    buf.writeln("                                  ),");
    buf.writeln("                                ),");
    buf.writeln("                              ),");
    buf.writeln("                            ),");
    buf.writeln("                          ),");
    buf.writeln("                      ],");
    buf.writeln("                    ),");
    buf.writeln("                  ),");
    buf.writeln("                ),");
    buf.writeln("              ),");
    buf.writeln("            ),");
    buf.writeln("          ),");
    buf.writeln("        );");
    buf.writeln("      },");
    buf.writeln("    );");
    buf.writeln("  }");
    buf.writeln("}");
  }
}
