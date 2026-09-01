// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';
import '../models/floating_toolbar_models.dart';
import 'floating_toolbar_nav_tab.dart';

class FloatingToolbarRenderWidget extends StatelessWidget {
  const FloatingToolbarRenderWidget({
    super.key,
    required this.variant,
    required this.effectiveContentPreset,
    required this.screenAlignment,
    required this.expanded,
    required this.onExpandedChanged,
    required this.showLeading,
    required this.showTrailing,
    required this.showDivider,
    required this.tooltip,
    required this.enableA11yCallbacks,
    required this.horizontalFabPosition,
    required this.verticalFabPosition,
    required this.fabActionMode,
    required this.customFabIcon,
    required this.fabActionToast,
    required this.dividerLength,
    required this.dividerThickness,
    required this.useCustomDividerColor,
    required this.customDividerColor,
    required this.bottomNavIndex,
    required this.onBottomNavIndexChanged,
    required this.haptic,
    required this.isBold,
    required this.onIsBoldChanged,
    required this.isItalic,
    required this.onIsItalicChanged,
    required this.isUnderline,
    required this.onIsUnderlineChanged,
    required this.isHighlight,
    required this.onIsHighlightChanged,
    required this.textAlign,
    required this.onTextAlignChanged,
    required this.activeTextColor,
    required this.onActiveTextColorChanged,
    required this.enableScrollBehavior,
    required this.scrollBehavior,
    required this.containerSize,
    required this.itemSpacing,
    required this.contentPaddingH,
    required this.contentPaddingV,
    required this.useCustomRadius,
    required this.customRadius,
    required this.expandedElevation,
    required this.collapsedElevation,
    required this.colorMode,
    required this.customContainerColor,
    required this.customContentColor,
    required this.customFabColor,
    required this.customFabContentColor,
    required this.useCustomSplashColor,
    required this.customSplashColor,
    required this.splashAlpha,
    required this.motion,
  });

  final ToolbarVariant variant;
  final ToolbarContentPreset effectiveContentPreset;
  final ToolbarScreenAlignment screenAlignment;
  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;
  final bool showLeading;
  final bool showTrailing;
  final bool showDivider;
  final String tooltip;
  final bool enableA11yCallbacks;
  final M3EFloatingToolbarHorizontalFabPosition horizontalFabPosition;
  final M3EFloatingToolbarVerticalFabPosition verticalFabPosition;
  final FabActionMode fabActionMode;
  final IconData customFabIcon;
  final String fabActionToast;
  final double dividerLength;
  final double dividerThickness;
  final bool useCustomDividerColor;
  final Color customDividerColor;
  final int bottomNavIndex;
  final ValueChanged<int> onBottomNavIndexChanged;
  final M3EHapticFeedback haptic;
  final bool isBold;
  final ValueChanged<bool> onIsBoldChanged;
  final bool isItalic;
  final ValueChanged<bool> onIsItalicChanged;
  final bool isUnderline;
  final ValueChanged<bool> onIsUnderlineChanged;
  final bool isHighlight;
  final ValueChanged<bool> onIsHighlightChanged;
  final TextAlign textAlign;
  final ValueChanged<TextAlign> onTextAlignChanged;
  final Color activeTextColor;
  final ValueChanged<Color> onActiveTextColorChanged;
  final bool enableScrollBehavior;
  final M3EFloatingToolbarScrollBehavior scrollBehavior;
  final double containerSize;
  final double itemSpacing;
  final double contentPaddingH;
  final double contentPaddingV;
  final bool useCustomRadius;
  final double customRadius;
  final double expandedElevation;
  final double collapsedElevation;
  final ToolbarColorMode colorMode;
  final Color customContainerColor;
  final Color customContentColor;
  final Color customFabColor;
  final Color customFabContentColor;
  final bool useCustomSplashColor;
  final Color customSplashColor;
  final double splashAlpha;
  final M3EMotion motion;

  M3EFloatingToolbarColors _resolveColors(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (colorMode) {
      case ToolbarColorMode.standard:
        return M3EFloatingToolbarDefaults.standardColors(context);
      case ToolbarColorMode.vibrant:
        return M3EFloatingToolbarDefaults.vibrantColors(context);
      case ToolbarColorMode.expressive:
        return M3EFloatingToolbarColors(
          toolbarContainerColor: cs.primary,
          toolbarContentColor: cs.onPrimary,
          fabContainerColor: cs.primaryContainer,
          fabContentColor: cs.onPrimaryContainer,
        );
      case ToolbarColorMode.custom:
        return M3EFloatingToolbarColors(
          toolbarContainerColor: customContainerColor,
          toolbarContentColor: customContentColor,
          fabContainerColor: customFabColor,
          fabContentColor: customFabContentColor,
        );
    }
  }

  Widget _toolbarIconButton(
    BuildContext context, {
    required IconData icon,
    required bool selected,
    required VoidCallback onPressed,
    required String tooltip,
    required M3EFloatingToolbarColors colors,
    Color? customSplashColor,
    double splashAlpha = 0.12,
  }) {
    final cs = Theme.of(context).colorScheme;
    final Color selectedBg;
    final Color selectedFg;
    final Color unselectedFg;

    if (colorMode == ToolbarColorMode.expressive) {
      selectedBg = cs.surface;
      selectedFg = cs.primary;
      unselectedFg = cs.onPrimary;
    } else if (colorMode == ToolbarColorMode.vibrant) {
      selectedBg = cs.surfaceContainer;
      selectedFg = cs.onSurface;
      unselectedFg = colors.toolbarContentColor;
    } else if (colorMode == ToolbarColorMode.standard) {
      selectedBg = cs.primaryContainer.withValues(alpha: 0.5);
      selectedFg = cs.primary;
      unselectedFg = colors.toolbarContentColor;
    } else {
      selectedBg = colors.fabContainerColor.withValues(alpha: 0.25);
      selectedFg = colors.fabContainerColor;
      unselectedFg = colors.toolbarContentColor;
    }

    return M3EButton(
      style: selected ? M3EButtonStyle.tonal : M3EButtonStyle.text,
      shape: M3EButtonShape.round,
      size: M3EButtonSize.sm,
      tooltip: tooltip,
      decoration: M3EButtonDecoration(
        backgroundColor: selected ? WidgetStatePropertyAll(selectedBg) : null,
        foregroundColor: WidgetStatePropertyAll(
          selected ? selectedFg : unselectedFg,
        ),
        fixedSize: const Size(48, 48),
        minimumSize: const Size(48, 48),
        padding: EdgeInsets.zero,
        borderRadius: 24,
      ),
      onPressed: () {
        haptic.apply();
        onPressed();
      },
      child: Center(child: Icon(icon, size: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);

    final shape = useCustomRadius
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customRadius),
          )
        : M3EFloatingToolbarDefaults.containerShape;

    final decoration = M3EFloatingToolbarDecoration(
      colors: colors,
      shape: shape,
      containerSize: containerSize,
      contentPadding: EdgeInsets.symmetric(
        horizontal: contentPaddingH,
        vertical: contentPaddingV,
      ),
      expandedShadowElevation: expandedElevation,
      collapsedShadowElevation: collapsedElevation,
      motion: motion,
    );

    final isHorizontal =
        variant == ToolbarVariant.horizontalFloating ||
        variant == ToolbarVariant.horizontalFab;

    final dividerWidget = showDivider
        ? M3EFloatingToolbarDivider(
            orientation: isHorizontal ? Axis.vertical : Axis.horizontal,
            length: dividerLength,
            thickness: dividerThickness,
            color: useCustomDividerColor ? customDividerColor : null,
          )
        : null;

    final effectiveSplashColor = useCustomSplashColor
        ? customSplashColor
        : null;

    // ── Build Action Items according to Preset ──
    List<Widget> actions;

    if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
      const navItems = [
        (
          icon: Icons.home_outlined,
          selected: Icons.home_rounded,
          label: 'Home',
        ),
        (
          icon: Icons.search_rounded,
          selected: Icons.search_rounded,
          label: 'Search',
        ),
        (
          icon: Icons.favorite_outline_rounded,
          selected: Icons.favorite_rounded,
          label: 'Saved',
        ),
        (
          icon: Icons.person_outline_rounded,
          selected: Icons.person_rounded,
          label: 'Profile',
        ),
      ];

      actions = List.generate(navItems.length, (index) {
        final isSelected = index == bottomNavIndex;
        final item = navItems[index];
        return ExpressiveNavBarTab(
          key: ValueKey(item.label),
          icon: item.icon,
          selectedIcon: item.selected,
          label: item.label,
          isSelected: isSelected,
          motion: motion,
          colors: colors,
          colorMode: colorMode,
          haptic: haptic,
          customSplashColor: effectiveSplashColor,
          splashAlpha: splashAlpha,
          onTap: () => onBottomNavIndexChanged(index),
        );
      });
    } else {
      // Default: Text Formatting
      actions = [
        _toolbarIconButton(
          context,
          icon: Icons.format_bold_rounded,
          selected: isBold,
          colors: colors,
          customSplashColor: effectiveSplashColor,
          splashAlpha: splashAlpha,
          onPressed: () => onIsBoldChanged(!isBold),
          tooltip: 'Bold',
        ),
        _toolbarIconButton(
          context,
          icon: Icons.format_italic_rounded,
          selected: isItalic,
          colors: colors,
          customSplashColor: effectiveSplashColor,
          splashAlpha: splashAlpha,
          onPressed: () => onIsItalicChanged(!isItalic),
          tooltip: 'Italic',
        ),
        _toolbarIconButton(
          context,
          icon: Icons.format_underlined_rounded,
          selected: isUnderline,
          colors: colors,
          customSplashColor: effectiveSplashColor,
          splashAlpha: splashAlpha,
          onPressed: () => onIsUnderlineChanged(!isUnderline),
          tooltip: 'Underline',
        ),
        _toolbarIconButton(
          context,
          icon: Icons.highlight_rounded,
          selected: isHighlight,
          colors: colors,
          customSplashColor: effectiveSplashColor,
          onPressed: () => onIsHighlightChanged(!isHighlight),
          tooltip: 'Highlight',
        ),
        if (variant == ToolbarVariant.docked) ...[
          _toolbarIconButton(
            context,
            icon: Icons.format_align_left_rounded,
            selected: textAlign == TextAlign.left,
            colors: colors,
            onPressed: () => onTextAlignChanged(TextAlign.left),
            tooltip: 'Align Left',
          ),
          _toolbarIconButton(
            context,
            icon: Icons.format_align_center_rounded,
            selected: textAlign == TextAlign.center,
            colors: colors,
            onPressed: () => onTextAlignChanged(TextAlign.center),
            tooltip: 'Align Center',
          ),
        ],
      ];
    }

    final fab = M3EFloatingActionButton(
      elevation: 0,
      containerColor: colors.fabContainerColor,
      contentColor: colors.fabContentColor,
      onPressed: () {
        haptic.apply();
        if (fabActionMode == FabActionMode.toggleExpansion) {
          onExpandedChanged(!expanded);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(fabActionToast),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Icon(
        fabActionMode == FabActionMode.toggleExpansion
            ? (expanded ? Icons.close_rounded : Icons.edit_rounded)
            : customFabIcon,
      ),
    );

    final leadingWidget = showLeading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: M3EButton(
              style: M3EButtonStyle.text,
              shape: M3EButtonShape.round,
              size: M3EButtonSize.sm,
              tooltip: 'Change Color',
              decoration: M3EButtonDecoration(
                foregroundColor: WidgetStatePropertyAll(
                  effectiveContentPreset == ToolbarContentPreset.textFormatting
                      ? activeTextColor
                      : colors.toolbarContentColor,
                ),
                fixedSize: const Size(48, 48),
                minimumSize: const Size(48, 48),
                padding: EdgeInsets.zero,
                borderRadius: 24,
              ),
              onPressed: () async {
                haptic.apply();
                final picked = await showDialog<Color>(
                  context: context,
                  builder: (ctx) =>
                      M3EColorPickerDialog(initialColor: activeTextColor),
                );
                if (picked != null) {
                  onActiveTextColorChanged(picked);
                }
              },
              child: const Center(
                child: Icon(Icons.palette_outlined, size: 20),
              ),
            ),
          )
        : null;

    final trailingWidget = showTrailing
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: M3EButton(
              style: M3EButtonStyle.text,
              shape: M3EButtonShape.round,
              size: M3EButtonSize.sm,
              tooltip: 'More options',
              decoration: M3EButtonDecoration(
                foregroundColor: WidgetStatePropertyAll(
                  colors.toolbarContentColor,
                ),
                fixedSize: const Size(48, 48),
                minimumSize: const Size(48, 48),
                padding: EdgeInsets.zero,
                borderRadius: 24,
              ),
              onPressed: () {
                haptic.apply();
              },
              child: const Center(
                child: Icon(Icons.more_vert_rounded, size: 20),
              ),
            ),
          )
        : null;

    final onExpandA11y = enableA11yCallbacks
        ? () => onExpandedChanged(true)
        : null;
    final onCollapseA11y = enableA11yCallbacks
        ? () => onExpandedChanged(false)
        : null;

    if (variant == ToolbarVariant.docked) {
      return M3EDockedToolbar(
        elevation: expandedElevation,
        height: containerSize,
        backgroundColor: colors.toolbarContainerColor,
        leading: leadingWidget,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: itemSpacing,
          children: actions,
        ),
        trailing: trailingWidget,
      );
    }

    if (variant == ToolbarVariant.horizontalFab) {
      return M3EFabHorizontalFloatingToolbar(
        expanded: expanded,
        alignment: screenAlignment.alignment,
        decoration: decoration,
        tooltip: tooltip.isNotEmpty ? tooltip : null,
        fabPosition: horizontalFabPosition,
        scrollBehavior: enableScrollBehavior ? scrollBehavior : null,
        onExpandA11y: onExpandA11y,
        onCollapseA11y: onCollapseA11y,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: itemSpacing,
          children: [
            ?leadingWidget,
            if (leadingWidget != null) ?dividerWidget,
            ...actions,
          ],
        ),
        floatingActionButton: fab,
      );
    }

    if (variant == ToolbarVariant.horizontalFloating) {
      return M3EHorizontalFloatingToolbar(
        expanded: expanded,
        alignment: screenAlignment.alignment,
        decoration: decoration,
        tooltip: tooltip.isNotEmpty ? tooltip : null,
        onExpandA11y: onExpandA11y,
        onCollapseA11y: onCollapseA11y,
        leadingContent: leadingWidget != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                spacing: itemSpacing,
                children: [leadingWidget, ?dividerWidget],
              )
            : null,
        trailingContent: trailingWidget,
        scrollBehavior: enableScrollBehavior ? scrollBehavior : null,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: itemSpacing,
          children: actions,
        ),
      );
    }

    if (variant == ToolbarVariant.verticalFab) {
      return M3EFabVerticalFloatingToolbar(
        expanded: expanded,
        alignment: screenAlignment.alignment,
        decoration: decoration,
        tooltip: tooltip.isNotEmpty ? tooltip : null,
        fabPosition: verticalFabPosition,
        scrollBehavior: enableScrollBehavior ? scrollBehavior : null,
        onExpandA11y: onExpandA11y,
        onCollapseA11y: onCollapseA11y,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: itemSpacing,
          children: [
            ?leadingWidget,
            if (leadingWidget != null) ?dividerWidget,
            ...actions,
          ],
        ),
        floatingActionButton: fab,
      );
    }

    return M3EVerticalFloatingToolbar(
      expanded: expanded,
      alignment: screenAlignment.alignment,
      decoration: decoration,
      tooltip: tooltip.isNotEmpty ? tooltip : null,
      onExpandA11y: onExpandA11y,
      onCollapseA11y: onCollapseA11y,
      leadingContent: leadingWidget != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              spacing: itemSpacing,
              children: [leadingWidget, ?dividerWidget],
            )
          : null,
      trailingContent: trailingWidget,
      scrollBehavior: enableScrollBehavior ? scrollBehavior : null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: itemSpacing,
        children: actions,
      ),
    );
  }
}
