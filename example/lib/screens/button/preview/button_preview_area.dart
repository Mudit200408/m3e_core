// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../data/mock_data.dart';
import '../models/button_models.dart';

class ButtonPreviewArea extends StatelessWidget {
  const ButtonPreviewArea({
    super.key,
    required this.architecture,
    required this.fabMode,
    required this.fabSize,
    required this.fabColor,
    required this.fabExpanded,
    required this.fabLabel,
    required this.fabIcon,
    required this.fabMenuPosition,
    required this.fabEnabled,
    required this.customFabCornerRadius,
    required this.useCustomFabCornerRadius,
    required this.fabPressedScale,
    required this.fabMotion,
    required this.menuItemGap,
    required this.menuOffset,
    required this.menuItemHeight,
    required this.menuItemHorizontalPadding,
    required this.menuIconLabelGap,
    required this.menuItemElevation,
    required this.menuItemCount,
    required this.menuExpandStaggerMs,
    required this.menuExpandMotion,
    required this.menuFabShapeMotion,
    required this.useMenuScrim,
    required this.menuScrimOpacity,
    required this.useCustomMenuItemBg,
    required this.customMenuItemBg,
    required this.useCustomMenuItemFg,
    required this.customMenuItemFg,
    required this.style,
    required this.size,
    required this.shape,
    required this.enabled,
    required this.useDecoration,
    required this.enableFeedback,
    required this.mouseCursor,
    required this.contentLayout,
    required this.iconAlignment,
    required this.label,
    required this.icon,
    required this.buttonTooltip,
    required this.isChecked,
    required this.onIsCheckedChanged,
    required this.useCustomCheckedIcon,
    required this.checkedIcon,
    required this.useCustomCheckedLabel,
    required this.checkedLabel,
    required this.allowMultilineLabel,
    required this.groupPreset,
    required this.useVariableActionWidths,
    required this.groupShowIcon,
    required this.groupShowCheckedIcon,
    required this.groupShowLabel,
    required this.groupShowCheckedLabel,
    required this.groupPerActionDecoration,
    required this.hasDisabledAction,
    required this.showActionTooltips,
    required this.groupType,
    required this.groupMultiSelect,
    required this.singleSelectedIndex,
    required this.onSingleSelectedIndexChanged,
    required this.multiSelectedIndices,
    required this.onMultiSelectedIndicesChanged,
    required this.neighborSquish,
    required this.expandedRatio,
    required this.spacing,
    required this.useCustomHeight,
    required this.customHeight,
    required this.density,
    required this.direction,
    required this.overflow,
    required this.overflowMenuStyle,
    required this.overflowUseCardList,
    required this.overflowIcon,
    required this.actionCount,
    required this.splitAlignment,
    required this.splitMenuStyle,
    required this.splitSelectedValue,
    required this.onSplitSelectedValueChanged,
    required this.leadingTooltip,
    required this.trailingTooltip,
    required this.splitGap,
    required this.trailingSelectedRadius,
    required this.useCustomDividerColor,
    required this.customDividerColor,
    required this.useCustomColor,
    required this.customColor,
    required this.useCustomFg,
    required this.customFg,
    required this.useBorder,
    required this.borderWidth,
    required this.elevation,
    required this.restingBorderRadius,
    required this.pressedRadius,
    required this.hoveredRadius,
    required this.checkedRadius,
    required this.motion,
    required this.haptic,
  });

  final ButtonArchitecture architecture;
  final FabArchitectureMode fabMode;
  final M3EFabSize fabSize;
  final M3EFabColor fabColor;
  final bool fabExpanded;
  final String fabLabel;
  final IconData fabIcon;
  final M3EFabMenuPosition fabMenuPosition;
  final bool fabEnabled;
  final double customFabCornerRadius;
  final bool useCustomFabCornerRadius;
  final double fabPressedScale;
  final M3EMotion fabMotion;
  final double menuItemGap;
  final double menuOffset;
  final double menuItemHeight;
  final double menuItemHorizontalPadding;
  final double menuIconLabelGap;
  final double menuItemElevation;
  final int menuItemCount;
  final int menuExpandStaggerMs;
  final M3EMotion menuExpandMotion;
  final M3EMotion menuFabShapeMotion;
  final bool useMenuScrim;
  final double menuScrimOpacity;
  final bool useCustomMenuItemBg;
  final Color customMenuItemBg;
  final bool useCustomMenuItemFg;
  final Color customMenuItemFg;

  final M3EButtonStyle style;
  final M3EButtonSize size;
  final M3EButtonShape shape;
  final bool enabled;
  final bool useDecoration;
  final bool enableFeedback;
  final MouseCursor mouseCursor;
  final ButtonContentLayout contentLayout;
  final IconAlignment iconAlignment;
  final String label;
  final IconData icon;
  final String buttonTooltip;

  final bool isChecked;
  final ValueChanged<bool> onIsCheckedChanged;
  final bool useCustomCheckedIcon;
  final IconData checkedIcon;
  final bool useCustomCheckedLabel;
  final String checkedLabel;
  final bool allowMultilineLabel;

  final GroupPreset groupPreset;
  final bool useVariableActionWidths;
  final bool groupShowIcon;
  final bool groupShowCheckedIcon;
  final bool groupShowLabel;
  final bool groupShowCheckedLabel;
  final bool groupPerActionDecoration;
  final bool hasDisabledAction;
  final bool showActionTooltips;
  final M3EButtonGroupType groupType;
  final bool groupMultiSelect;
  final int? singleSelectedIndex;
  final ValueChanged<int?> onSingleSelectedIndexChanged;
  final Set<int> multiSelectedIndices;
  final ValueChanged<Set<int>> onMultiSelectedIndicesChanged;
  final bool neighborSquish;
  final double expandedRatio;
  final double spacing;
  final bool useCustomHeight;
  final double customHeight;
  final M3EButtonGroupDensity density;
  final Axis direction;
  final M3EButtonGroupOverflow overflow;
  final M3EButtonGroupOverflowMenuStyle overflowMenuStyle;
  final bool overflowUseCardList;
  final IconData overflowIcon;
  final int actionCount;

  final M3ESplitButtonTrailingAlignment splitAlignment;
  final SplitButtonMenuStyle splitMenuStyle;
  final String splitSelectedValue;
  final ValueChanged<String> onSplitSelectedValueChanged;
  final String leadingTooltip;
  final String trailingTooltip;
  final double splitGap;
  final double trailingSelectedRadius;
  final bool useCustomDividerColor;
  final Color customDividerColor;

  final bool useCustomColor;
  final Color customColor;
  final bool useCustomFg;
  final Color customFg;
  final bool useBorder;
  final double borderWidth;
  final double elevation;
  final double restingBorderRadius;
  final double pressedRadius;
  final double hoveredRadius;
  final double checkedRadius;
  final M3EMotion motion;
  final M3EHapticFeedback haptic;

  M3EButtonDecoration _buildButtonDecoration(ColorScheme cs) {
    return M3EButtonDecoration.styleFrom(
      backgroundColor: useCustomColor ? customColor : null,
      foregroundColor: useCustomFg ? customFg : null,
      side: useBorder
          ? BorderSide(
              color: useCustomColor ? customColor : cs.outlineVariant,
              width: borderWidth,
            )
          : null,
      elevation: elevation > 0 ? elevation : null,
      borderRadius: restingBorderRadius > 0 ? restingBorderRadius : null,
      pressedRadius: pressedRadius,
      hoveredRadius: hoveredRadius,
      motion: motion,
      haptic: haptic,
      iconAlignment: iconAlignment,
      enableFeedback: enableFeedback,
      enabledMouseCursor: mouseCursor,
    );
  }

  M3EToggleButtonDecoration _buildToggleDecoration(ColorScheme cs) {
    return M3EToggleButtonDecoration.styleFrom(
      backgroundColor: useCustomColor ? customColor : null,
      foregroundColor: useCustomFg ? customFg : null,
      side: useBorder
          ? BorderSide(
              color: useCustomColor ? customColor : cs.outlineVariant,
              width: borderWidth,
            )
          : null,
      borderRadius: restingBorderRadius > 0 ? restingBorderRadius : null,
      checkedRadius: checkedRadius,
      pressedRadius: pressedRadius,
      hoveredRadius: hoveredRadius,
      motion: motion,
      haptic: haptic,
      enabledMouseCursor: mouseCursor,
    );
  }

  M3ESplitButtonDecoration _buildSplitDecoration(ColorScheme cs) {
    return M3ESplitButtonDecoration.styleFrom(
      backgroundColor: useCustomColor ? customColor : null,
      foregroundColor: useCustomFg ? customFg : null,
      side: useBorder
          ? BorderSide(
              color: useCustomColor ? customColor : cs.outlineVariant,
              width: borderWidth,
            )
          : null,
      elevation: elevation > 0 ? elevation : null,
      borderRadius: restingBorderRadius > 0 ? restingBorderRadius : null,
      pressedRadius: pressedRadius,
      hoveredRadius: hoveredRadius,
      trailingSelectedRadius: trailingSelectedRadius,
      gap: splitGap > 0 ? splitGap : null,
      dividerColor: useCustomDividerColor ? customDividerColor : null,
      motion: motion,
      haptic: haptic,
      menuStyle: splitMenuStyle,
      enabledMouseCursor: mouseCursor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final decoration = useDecoration ? _buildButtonDecoration(cs) : null;
    final toggleDecoration = useDecoration ? _buildToggleDecoration(cs) : null;
    final groupSize = useCustomHeight
        ? M3EButtonSize.custom(height: customHeight)
        : size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── FAB Preview ──
              if (architecture == ButtonArchitecture.floatingAction) ...[
                if (fabMode == FabArchitectureMode.standard)
                  Container(
                    constraints: const BoxConstraints(minHeight: 180),
                    alignment: Alignment.center,
                    child: M3EFab(
                      key: ValueKey(
                        'fab_${fabSize.name}_${fabColor.name}_${useCustomFabCornerRadius}_${customFabCornerRadius}_${fabEnabled}_${fabPressedScale}_${useCustomColor}_${customColor.hashCode}_${useCustomFg}_${customFg.hashCode}_${useBorder}_$borderWidth',
                      ),
                      size: fabSize,
                      color: fabColor,
                      cornerRadius: useCustomFabCornerRadius
                          ? customFabCornerRadius
                          : null,
                      decoration: M3EFabDecoration(
                        backgroundColor: useCustomColor
                            ? WidgetStatePropertyAll(customColor)
                            : null,
                        foregroundColor: useCustomFg
                            ? WidgetStatePropertyAll(customFg)
                            : null,
                        side: useBorder
                            ? WidgetStatePropertyAll(
                                BorderSide(
                                  color: useCustomColor
                                      ? customColor
                                      : cs.outlineVariant,
                                  width: borderWidth,
                                ),
                              )
                            : null,
                        pressedScale: fabPressedScale,
                        motion: fabMotion,
                      ),
                      icon: Icon(fabIcon),
                      onPressed: fabEnabled
                          ? () => showSnack(context, 'Tapped $fabLabel FAB!')
                          : null,
                      tooltip: '$fabLabel FAB',
                    ),
                  )
                else if (fabMode == FabArchitectureMode.extended)
                  Container(
                    constraints: const BoxConstraints(minHeight: 180),
                    alignment: Alignment.center,
                    child: M3EExtendedFab(
                      key: ValueKey(
                        'extended_fab_${fabSize.name}_${fabColor.name}_${fabExpanded}_${fabEnabled}_${fabPressedScale}_${useCustomColor}_${customColor.hashCode}_${useCustomFg}_${customFg.hashCode}_${useBorder}_$borderWidth',
                      ),
                      size: fabSize,
                      extended: fabExpanded,
                      color: fabColor,
                      decoration: M3EFabDecoration(
                        backgroundColor: useCustomColor
                            ? WidgetStatePropertyAll(customColor)
                            : null,
                        foregroundColor: useCustomFg
                            ? WidgetStatePropertyAll(customFg)
                            : null,
                        side: useBorder
                            ? WidgetStatePropertyAll(
                                BorderSide(
                                  color: useCustomColor
                                      ? customColor
                                      : cs.outlineVariant,
                                  width: borderWidth,
                                ),
                              )
                            : null,
                        pressedScale: fabPressedScale,
                        motion: fabMotion,
                      ),
                      icon: Icon(fabIcon),
                      label: fabLabel,
                      onPressed: fabEnabled
                          ? () => showSnack(
                              context,
                              'Tapped $fabLabel Extended FAB!',
                            )
                          : null,
                    ),
                  )
                else
                  Container(
                    height: 420,
                    alignment: fabMenuPosition == M3EFabMenuPosition.right
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: M3EFabMenu(
                      key: ValueKey(
                        'fab_menu_${fabMenuPosition.name}_${fabColor.name}_${fabSize.name}_${menuItemGap}_${menuOffset}_${menuItemHeight}_${menuItemHorizontalPadding}_${menuIconLabelGap}_${menuItemElevation}_${menuExpandStaggerMs}_${useMenuScrim}_${menuScrimOpacity}_${useCustomMenuItemBg}_${customMenuItemBg.hashCode}_${useCustomMenuItemFg}_${customMenuItemFg.hashCode}_$menuItemCount',
                      ),
                      position: fabMenuPosition,
                      color: fabColor,
                      size: fabSize,
                      decoration: M3EFabMenuDecoration(
                        itemGap: menuItemGap,
                        menuOffset: menuOffset,
                        itemHeight: menuItemHeight,
                        itemHorizontalPadding: menuItemHorizontalPadding,
                        iconLabelGap: menuIconLabelGap,
                        itemElevation: menuItemElevation,
                        expandStaggerMs: menuExpandStaggerMs,
                        expandMotion: menuExpandMotion,
                        fabShapeMotion: menuFabShapeMotion,
                        scrimColor: useMenuScrim
                            ? Color(((menuScrimOpacity * 255).round() << 24))
                            : const Color(0x00000000),
                        itemBackgroundColor: useCustomMenuItemBg
                            ? customMenuItemBg
                            : null,
                        itemForegroundColor: useCustomMenuItemFg
                            ? customMenuItemFg
                            : null,
                      ),
                      items: [
                        M3EFabMenuItem(
                          icon: const Icon(Icons.share_rounded),
                          label: 'Share',
                          onPressed: () => showSnack(
                            context,
                            'Selected Share from FAB Menu!',
                          ),
                        ),
                        M3EFabMenuItem(
                          icon: const Icon(Icons.favorite_rounded),
                          label: 'Favorite',
                          onPressed: () => showSnack(
                            context,
                            'Selected Favorite from FAB Menu!',
                          ),
                        ),
                        if (menuItemCount >= 3)
                          M3EFabMenuItem(
                            icon: const Icon(Icons.edit_rounded),
                            label: 'Edit',
                            onPressed: () => showSnack(
                              context,
                              'Selected Edit from FAB Menu!',
                            ),
                          ),
                        if (menuItemCount >= 4)
                          M3EFabMenuItem(
                            icon: const Icon(Icons.delete_rounded),
                            label: 'Delete',
                            onPressed: () => showSnack(
                              context,
                              'Selected Delete from FAB Menu!',
                            ),
                          ),
                        if (menuItemCount >= 5)
                          M3EFabMenuItem(
                            icon: const Icon(Icons.download_rounded),
                            label: 'Download',
                            onPressed: () => showSnack(
                              context,
                              'Selected Download from FAB Menu!',
                            ),
                          ),
                        if (menuItemCount >= 6)
                          M3EFabMenuItem(
                            icon: const Icon(Icons.settings_rounded),
                            label: 'Settings',
                            onPressed: () => showSnack(
                              context,
                              'Selected Settings from FAB Menu!',
                            ),
                          ),
                      ],
                    ),
                  ),
              ],

              // ── Standard Button Preview ──
              if (architecture == ButtonArchitecture.standard) ...[
                if (contentLayout == ButtonContentLayout.iconOnly)
                  M3EButton(
                    key: ValueKey(
                      'std_btn_icon_${size.name}_${shape.name}_${style.name}_${enabled}_${restingBorderRadius}_${pressedRadius}_${mouseCursor.hashCode}',
                    ),
                    style: style,
                    size: size,
                    shape: shape,
                    enabled: enabled,
                    decoration: decoration,
                    tooltip: buttonTooltip.isNotEmpty ? buttonTooltip : null,
                    mouseCursor: mouseCursor,
                    enableFeedback: enableFeedback,
                    onPressed: () => showSnack(context, 'Tapped M3EButton!'),
                    onLongPress: () =>
                        showSnack(context, 'Long-pressed M3EButton!'),
                    child: Icon(icon),
                  )
                else if (contentLayout == ButtonContentLayout.iconAndLabel)
                  M3EButton.icon(
                    key: ValueKey(
                      'std_btn_icon_lbl_${size.name}_${shape.name}_${style.name}_${enabled}_${restingBorderRadius}_${pressedRadius}_${iconAlignment.name}_${mouseCursor.hashCode}',
                    ),
                    style: style,
                    size: size,
                    shape: shape,
                    enabled: enabled,
                    decoration: decoration,
                    tooltip: buttonTooltip.isNotEmpty ? buttonTooltip : null,
                    mouseCursor: mouseCursor,
                    enableFeedback: enableFeedback,
                    icon: Icon(icon),
                    label: Text(label),
                    onPressed: () => showSnack(context, 'Tapped M3EButton!'),
                    onLongPress: () =>
                        showSnack(context, 'Long-pressed M3EButton!'),
                  )
                else
                  M3EButton(
                    key: ValueKey(
                      'std_btn_lbl_${size.name}_${shape.name}_${style.name}_${enabled}_${restingBorderRadius}_${pressedRadius}_${mouseCursor.hashCode}',
                    ),
                    style: style,
                    size: size,
                    shape: shape,
                    enabled: enabled,
                    decoration: decoration,
                    tooltip: buttonTooltip.isNotEmpty ? buttonTooltip : null,
                    mouseCursor: mouseCursor,
                    enableFeedback: enableFeedback,
                    onPressed: () => showSnack(context, 'Tapped M3EButton!'),
                    onLongPress: () =>
                        showSnack(context, 'Long-pressed M3EButton!'),
                    child: Text(label),
                  ),
              ],

              // ── Toggle Button Preview ──
              if (architecture == ButtonArchitecture.toggle) ...[
                M3EToggleButton(
                  key: ValueKey(
                    'toggle_btn_${size.name}_${shape.name}_${style.name}_${enabled}_${allowMultilineLabel}_${restingBorderRadius}_${checkedRadius}_$pressedRadius',
                  ),
                  checked: isChecked,
                  style: style,
                  size: size,
                  enabled: enabled,
                  allowMultilineLabel: allowMultilineLabel,
                  decoration: toggleDecoration,
                  tooltip: buttonTooltip.isNotEmpty ? buttonTooltip : null,
                  mouseCursor: mouseCursor,
                  enableFeedback: enableFeedback,
                  icon: contentLayout != ButtonContentLayout.labelOnly
                      ? Icon(icon)
                      : null,
                  checkedIcon:
                      useCustomCheckedIcon &&
                          contentLayout != ButtonContentLayout.labelOnly
                      ? Icon(checkedIcon)
                      : null,
                  label: contentLayout != ButtonContentLayout.iconOnly
                      ? Text(label)
                      : null,
                  checkedLabel:
                      useCustomCheckedLabel &&
                          contentLayout != ButtonContentLayout.iconOnly
                      ? Text(checkedLabel)
                      : null,
                  onCheckedChange: (val) {
                    onIsCheckedChanged(val);
                    showSnack(
                      context,
                      val
                          ? 'Checked M3EToggleButton'
                          : 'Unchecked M3EToggleButton',
                    );
                  },
                  onLongPress: () =>
                      showSnack(context, 'Long-pressed M3EToggleButton!'),
                ),
              ],

              // ── Toggle Button Group Preview ──
              if (architecture == ButtonArchitecture.group) ...[
                M3EToggleButtonGroup(
                  key: ValueKey(
                    'toggle_group_${groupSize.name}_${groupType.name}_${groupShowIcon}_${groupShowCheckedIcon}_${groupShowLabel}_${groupShowCheckedLabel}_${groupPreset.name}_${overflow.name}_${overflowMenuStyle.name}_${overflowUseCardList}_${hasDisabledAction}_$showActionTooltips',
                  ),
                  type: groupType,
                  shape: shape,
                  size: groupSize,
                  style: style,
                  spacing: groupType == M3EButtonGroupType.standard
                      ? spacing
                      : null,
                  density: density,
                  direction: direction,
                  neighborSquish:
                      groupType == M3EButtonGroupType.standard &&
                      neighborSquish,
                  expandedRatio: expandedRatio,
                  overflow: overflow,
                  overflowIcon: Icon(overflowIcon),
                  overflowMenuStyle: overflowMenuStyle,
                  overflowPopupDecoration: M3EOverflowPopupDecoration(
                    useCardList: overflowUseCardList,
                  ),
                  selectedIndex: !groupMultiSelect ? singleSelectedIndex : null,
                  selectedIndices: groupMultiSelect
                      ? multiSelectedIndices
                      : null,
                  onSelectedIndexChanged: !groupMultiSelect
                      ? (idx) {
                          onSingleSelectedIndexChanged(idx);
                          showSnack(context, 'Selected group index: $idx');
                        }
                      : null,
                  onSelectedIndicesChanged: groupMultiSelect
                      ? (set) {
                          onMultiSelectedIndicesChanged(set);
                          showSnack(context, 'Selected group set: $set');
                        }
                      : null,
                  actions: switch (groupPreset) {
                    GroupPreset.composeVariableWidths => [
                      M3EToggleButtonGroupAction(
                        icon: const Icon(Icons.bluetooth),
                        tooltip: showActionTooltips ? 'Bluetooth device' : null,
                      ),
                      M3EToggleButtonGroupAction(
                        icon: const Icon(Icons.alarm),
                        width: useVariableActionWidths ? 80 : null,
                        tooltip: showActionTooltips ? 'Alarm timer' : null,
                      ),
                      M3EToggleButtonGroupAction(
                        icon: const Icon(Icons.link),
                        width: useVariableActionWidths ? 60 : null,
                        tooltip: showActionTooltips ? 'Web link' : null,
                      ),
                      M3EToggleButtonGroupAction(
                        icon: const Icon(Icons.wifi),
                        width: useVariableActionWidths ? 120 : null,
                        tooltip: showActionTooltips ? 'Wi-Fi network' : null,
                      ),
                    ],
                    GroupPreset.quickSettings => [
                      M3EToggleButtonGroupAction(
                        icon: groupShowIcon
                            ? const Icon(Icons.wifi_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Wi-Fi') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Wi-Fi (On)')
                            : null,
                        tooltip: showActionTooltips ? 'Wi-Fi toggle' : null,
                      ),
                      M3EToggleButtonGroupAction(
                        icon: groupShowIcon
                            ? const Icon(Icons.bluetooth_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Bluetooth') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Bluetooth (On)')
                            : null,
                        tooltip: showActionTooltips ? 'Bluetooth toggle' : null,
                      ),
                      M3EToggleButtonGroupAction(
                        enabled: !hasDisabledAction,
                        icon: groupShowIcon
                            ? const Icon(Icons.airplanemode_active_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Airplane') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Airplane (On)')
                            : null,
                        tooltip: showActionTooltips ? 'Airplane mode' : null,
                      ),
                      M3EToggleButtonGroupAction(
                        icon: groupShowIcon
                            ? const Icon(Icons.flashlight_on_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Torch') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Torch (On)')
                            : null,
                        tooltip: showActionTooltips ? 'Flashlight' : null,
                      ),
                    ],
                    GroupPreset.formatting ||
                    GroupPreset.morphingCheckedLabel => [
                      M3EToggleButtonGroupAction(
                        icon: groupShowIcon
                            ? const Icon(Icons.format_bold_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Bold') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Bold')
                            : null,
                        tooltip: showActionTooltips ? 'Bold formatting' : null,
                        decoration: groupPerActionDecoration
                            ? M3EToggleButtonDecoration.styleFrom(
                                haptic: M3EHapticFeedback.light,
                              )
                            : null,
                      ),
                      M3EToggleButtonGroupAction(
                        icon: groupShowIcon
                            ? const Icon(Icons.format_italic_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Italic') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Italic')
                            : null,
                        tooltip: showActionTooltips
                            ? 'Italic formatting'
                            : null,
                        decoration: groupPerActionDecoration
                            ? M3EToggleButtonDecoration.styleFrom(
                                haptic: M3EHapticFeedback.light,
                              )
                            : null,
                      ),
                      M3EToggleButtonGroupAction(
                        enabled: !hasDisabledAction,
                        icon: groupShowIcon
                            ? const Icon(Icons.format_underlined_rounded)
                            : null,
                        checkedIcon: groupShowCheckedIcon
                            ? const Icon(Icons.check_rounded)
                            : null,
                        label: groupShowLabel ? const Text('Underline') : null,
                        checkedLabel: groupShowCheckedLabel
                            ? const Text('Underline')
                            : null,
                        tooltip: showActionTooltips
                            ? 'Underline formatting'
                            : null,
                        decoration: groupPerActionDecoration
                            ? M3EToggleButtonDecoration.styleFrom(
                                haptic: M3EHapticFeedback.light,
                              )
                            : null,
                      ),
                      if (actionCount >= 4 ||
                          groupPreset == GroupPreset.morphingCheckedLabel)
                        M3EToggleButtonGroupAction(
                          icon: groupShowIcon
                              ? const Icon(Icons.format_strikethrough_rounded)
                              : null,
                          checkedIcon: groupShowCheckedIcon
                              ? const Icon(Icons.check_rounded)
                              : null,
                          label: groupShowLabel ? const Text('Strike') : null,
                          checkedLabel: groupShowCheckedLabel
                              ? const Text('Strike')
                              : null,
                          tooltip: showActionTooltips
                              ? 'Strikethrough formatting'
                              : null,
                          decoration: groupPerActionDecoration
                              ? M3EToggleButtonDecoration.styleFrom(
                                  haptic: M3EHapticFeedback.light,
                                )
                              : null,
                        ),
                      if (actionCount >= 5 &&
                          groupPreset != GroupPreset.morphingCheckedLabel)
                        M3EToggleButtonGroupAction(
                          icon: groupShowIcon
                              ? const Icon(Icons.format_color_text_rounded)
                              : null,
                          checkedIcon: groupShowCheckedIcon
                              ? const Icon(Icons.check_rounded)
                              : null,
                          label: groupShowLabel ? const Text('Color') : null,
                          checkedLabel: groupShowCheckedLabel
                              ? const Text('Color')
                              : null,
                          tooltip: showActionTooltips ? 'Text color' : null,
                        ),
                      if (actionCount >= 6 &&
                          groupPreset != GroupPreset.morphingCheckedLabel)
                        M3EToggleButtonGroupAction(
                          icon: groupShowIcon
                              ? const Icon(Icons.format_align_center_rounded)
                              : null,
                          checkedIcon: groupShowCheckedIcon
                              ? const Icon(Icons.check_rounded)
                              : null,
                          label: groupShowLabel ? const Text('Center') : null,
                          checkedLabel: groupShowCheckedLabel
                              ? const Text('Center')
                              : null,
                          tooltip: showActionTooltips
                              ? 'Center alignment'
                              : null,
                        ),
                    ],
                  },
                ),
              ],

              // ── Split Button Preview ──
              if (architecture == ButtonArchitecture.split) ...[
                M3ESplitButton<String>(
                  key: ValueKey(
                    'split_btn_${size.name}_${shape.name}_${style.name}_${enabled}_${splitAlignment.name}_${splitSelectedValue}_${splitMenuStyle.name}_${contentLayout.name}_${useDecoration}_${restingBorderRadius}_${pressedRadius}_${splitGap}_$useCustomDividerColor',
                  ),
                  style: style == M3EButtonStyle.text
                      ? M3EButtonStyle.filled
                      : style,
                  size: size,
                  shape: shape,
                  enabled: enabled,
                  decoration: useDecoration ? _buildSplitDecoration(cs) : null,
                  trailingAlignment: splitAlignment,
                  mouseCursor: mouseCursor,
                  enableFeedback: enableFeedback,
                  leadingIcon: contentLayout != ButtonContentLayout.labelOnly
                      ? icon
                      : null,
                  label: contentLayout != ButtonContentLayout.iconOnly
                      ? splitSelectedValue
                      : null,
                  selectedValue: splitSelectedValue,
                  leadingTooltip: leadingTooltip.isNotEmpty
                      ? leadingTooltip
                      : null,
                  trailingTooltip: trailingTooltip.isNotEmpty
                      ? trailingTooltip
                      : null,
                  items: const [
                    M3ESplitButtonItem(
                      value: 'Save Draft',
                      child: Text('Save Draft'),
                    ),
                    M3ESplitButtonItem(
                      value: 'Save & Publish',
                      child: Text('Save & Publish'),
                    ),
                    M3ESplitButtonItem(
                      value: 'Export PDF',
                      child: Text('Export PDF'),
                    ),
                    M3ESplitButtonItem(
                      value: 'Archive',
                      child: Text('Archive Item'),
                    ),
                  ],
                  onPressed: enabled
                      ? () => showSnack(
                          context,
                          'Primary split action triggered: $splitSelectedValue',
                        )
                      : null,
                  onLongPress: enabled
                      ? () => showSnack(
                          context,
                          'Long-pressed primary split button!',
                        )
                      : null,
                  onSelected: (val) {
                    onSplitSelectedValueChanged(val);
                    showSnack(context, 'Menu option selected: $val');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
