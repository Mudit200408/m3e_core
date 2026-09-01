// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/floating_toolbar_models.dart';
import 'floating_toolbar_interactive_document.dart';
import 'floating_toolbar_render_widget.dart';

class FloatingToolbarPreviewArea extends StatelessWidget {
  const FloatingToolbarPreviewArea({
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
    this.isFullScreen = false,
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
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    final previewContent = FloatingToolbarInteractiveDocument(
      effectiveContentPreset: effectiveContentPreset,
      bottomNavIndex: bottomNavIndex,
      enableScrollBehavior: enableScrollBehavior,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
      isHighlight: isHighlight,
      textAlign: textAlign,
      activeTextColor: activeTextColor,
    );

    final toolbarWidget = FloatingToolbarRenderWidget(
      variant: variant,
      effectiveContentPreset: effectiveContentPreset,
      screenAlignment: screenAlignment,
      expanded: expanded,
      onExpandedChanged: onExpandedChanged,
      showLeading: showLeading,
      showTrailing: showTrailing,
      showDivider: showDivider,
      tooltip: tooltip,
      enableA11yCallbacks: enableA11yCallbacks,
      horizontalFabPosition: horizontalFabPosition,
      verticalFabPosition: verticalFabPosition,
      fabActionMode: fabActionMode,
      customFabIcon: customFabIcon,
      fabActionToast: fabActionToast,
      dividerLength: dividerLength,
      dividerThickness: dividerThickness,
      useCustomDividerColor: useCustomDividerColor,
      customDividerColor: customDividerColor,
      bottomNavIndex: bottomNavIndex,
      onBottomNavIndexChanged: onBottomNavIndexChanged,
      haptic: haptic,
      isBold: isBold,
      onIsBoldChanged: onIsBoldChanged,
      isItalic: isItalic,
      onIsItalicChanged: onIsItalicChanged,
      isUnderline: isUnderline,
      onIsUnderlineChanged: onIsUnderlineChanged,
      isHighlight: isHighlight,
      onIsHighlightChanged: onIsHighlightChanged,
      textAlign: textAlign,
      onTextAlignChanged: onTextAlignChanged,
      activeTextColor: activeTextColor,
      onActiveTextColorChanged: onActiveTextColorChanged,
      enableScrollBehavior: enableScrollBehavior,
      scrollBehavior: scrollBehavior,
      containerSize: containerSize,
      itemSpacing: itemSpacing,
      contentPaddingH: contentPaddingH,
      contentPaddingV: contentPaddingV,
      useCustomRadius: useCustomRadius,
      customRadius: customRadius,
      expandedElevation: expandedElevation,
      collapsedElevation: collapsedElevation,
      colorMode: colorMode,
      customContainerColor: customContainerColor,
      customContentColor: customContentColor,
      customFabColor: customFabColor,
      customFabContentColor: customFabContentColor,
      useCustomSplashColor: useCustomSplashColor,
      customSplashColor: customSplashColor,
      splashAlpha: splashAlpha,
      motion: motion,
    );

    if (isFullScreen) {
      final fullScreenStack = Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: previewContent),
          if (variant == ToolbarVariant.docked)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(top: false, child: toolbarWidget),
            )
          else
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 16.0,
                  ),
                  child: toolbarWidget,
                ),
              ),
            ),
        ],
      );

      if (enableScrollBehavior && variant != ToolbarVariant.docked) {
        return M3EFloatingToolbarScrollWrapper(
          behavior: scrollBehavior,
          child: fullScreenStack,
        );
      }

      return fullScreenStack;
    }

    final stack = SizedBox(
      height: 520,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: previewContent),
            if (variant == ToolbarVariant.docked)
              Positioned(left: 0, right: 0, bottom: 0, child: toolbarWidget)
            else
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: toolbarWidget,
                ),
              ),
          ],
        ),
      ),
    );

    if (enableScrollBehavior && variant != ToolbarVariant.docked) {
      return M3EFloatingToolbarScrollWrapper(
        behavior: scrollBehavior,
        child: stack,
      );
    }

    return stack;
  }
}
