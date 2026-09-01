// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../shared/shared.dart';
import 'controls/button_architecture_controls.dart';
import 'controls/button_color_controls.dart';
import 'controls/button_fab_controls.dart';
import 'controls/button_group_controls.dart';
import 'controls/button_morphing_controls.dart';
import 'controls/button_split_controls.dart';
import 'controls/button_standard_controls.dart';
import 'controls/button_toggle_controls.dart';
import 'models/button_models.dart';
import 'preview/button_preview_area.dart';
import 'snippets/button_code_snippets.dart';

export 'models/button_models.dart';

class ButtonPlaygroundView extends StatefulWidget {
  const ButtonPlaygroundView({super.key});

  @override
  State<ButtonPlaygroundView> createState() => _ButtonPlaygroundViewState();
}

class _ButtonPlaygroundViewState extends State<ButtonPlaygroundView> {
  // ── Architecture ──
  ButtonArchitecture _arch = ButtonArchitecture.standard;
  FabArchitectureMode _fabMode = FabArchitectureMode.extended;
  M3EFabSize _fabSize = M3EFabSize.medium;
  M3EFabColor _fabColor = M3EFabColor.primary;
  bool _fabExpanded = true;
  String _fabLabel = 'Create';
  IconData _fabIcon = Icons.add_rounded;
  M3EFabMenuPosition _fabMenuPosition = M3EFabMenuPosition.right;
  bool _fabEnabled = true;
  double _customFabCornerRadius = 16.0;
  bool _useCustomFabCornerRadius = false;
  double _fabPressedScale = 0.95;
  M3EExampleMotionPreset _fabMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialDefault;
  double _fabMotionStiffness = 380.0;
  double _fabMotionDamping = 0.55;

  // ── FAB Menu Layout & Geometry ──
  double _menuItemGap = 8.0;
  double _menuOffset = 12.0;
  double _menuItemHeight = 56.0;
  double _menuItemHorizontalPadding = 20.0;
  double _menuIconLabelGap = 12.0;
  double _menuItemElevation = 6.0;
  int _menuItemCount = 4;
  int _menuExpandStaggerMs = 35;
  M3EExampleMotionPreset _menuExpandMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialDefault;
  double _menuExpandMotionStiffness = 380.0;
  double _menuExpandMotionDamping = 0.55;
  M3EExampleMotionPreset _menuFabShapeMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialDefault;
  double _menuFabShapeMotionStiffness = 380.0;
  double _menuFabShapeMotionDamping = 0.70;
  bool _useMenuScrim = false;
  double _menuScrimOpacity = 0.32;
  bool _useCustomMenuItemBg = false;
  Color _customMenuItemBg = Colors.teal;
  bool _useCustomMenuItemFg = false;
  Color _customMenuItemFg = Colors.white;

  // ── Common Styling & Geometry ──
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonSize _size = M3EButtonSize.md;
  bool _isCustomSize = false;
  double _customButtonHeight = 48.0;
  double _customButtonHPadding = 16.0;
  double _customButtonIconSize = 20.0;
  double _customButtonIconGap = 8.0;
  bool _useCustomButtonWidth = false;
  double _customButtonWidth = 140.0;
  M3EButtonShape _shape = M3EButtonShape.round;
  bool _enabled = true;
  bool _useDecoration = true;
  bool _enableFeedback = true;
  MouseCursor _mouseCursor = SystemMouseCursors.click;

  void _updateCustomSize() {
    _size = M3EButtonSize.custom(
      height: _customButtonHeight,
      hPadding: _customButtonHPadding,
      iconSize: _customButtonIconSize,
      iconGap: _customButtonIconGap,
      width: _useCustomButtonWidth ? _customButtonWidth : null,
    );
  }

  // ── Content & Layout ──
  ButtonContentLayout _contentLayout = ButtonContentLayout.iconAndLabel;
  IconAlignment _iconAlignment = IconAlignment.start;
  String _label = 'Explore';
  IconData _icon = Icons.rocket_launch_rounded;
  String _buttonTooltip = 'Explore M3E';

  // ── Interactive Morphing & Physics ──
  double _restingBorderRadius = 0.0;
  double _pressedRadius = 8.0;
  double _hoveredRadius = 16.0;
  double _checkedRadius = 12.0;
  double _elevation = 0.0;
  M3EExampleMotionPreset _motionPreset =
      M3EExampleMotionPreset.standardSpatialDefault;
  double _motionStiffness = 700;
  double _motionDamping = 0.9;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;

  // ── Custom Colors & Borders ──
  bool _useCustomColor = false;
  Color _customColor = Colors.teal;
  bool _useCustomFg = false;
  Color _customFg = Colors.white;
  bool _useBorder = false;
  double _borderWidth = 1.5;

  // ── Toggle Button Controls ──
  bool _isChecked = false;
  bool _useCustomCheckedLabel = false;
  bool _useCustomCheckedIcon = false;
  IconData _checkedIcon = Icons.check_circle_rounded;
  String _checkedLabel = 'Selected';
  bool _allowMultilineLabel = false;

  // ── Toggle Button Group Controls ──
  GroupPreset _groupPreset = GroupPreset.formatting;
  bool _useVariableActionWidths = true;
  bool _groupShowIcon = true;
  bool _groupShowCheckedIcon = false;
  bool _groupShowLabel = true;
  bool _groupShowCheckedLabel = false;
  bool _groupPerActionDecoration = false;
  bool _hasDisabledAction = false;
  bool _showActionTooltips = true;

  M3EButtonGroupType _groupType = M3EButtonGroupType.connected;
  bool _groupMultiSelect = false;
  int? _singleSelectedIndex = 0;
  Set<int> _multiSelectedIndices = {0, 2};
  bool _neighborSquish = true;
  double _expandedRatio = 0.15;
  double _spacing = 6.0;
  bool _useCustomHeight = false;
  double _customHeight = 80.0;
  M3EButtonGroupDensity _density = M3EButtonGroupDensity.regular;
  Axis _direction = Axis.horizontal;
  M3EButtonGroupOverflow _overflow = M3EButtonGroupOverflow.menu;
  M3EButtonGroupOverflowMenuStyle _overflowMenuStyle =
      M3EButtonGroupOverflowMenuStyle.popup;
  bool _overflowUseCardList = true;
  IconData _overflowIcon = Icons.more_horiz_rounded;
  int _actionCount = 4;

  // ── Split Button Controls ──
  M3ESplitButtonTrailingAlignment _splitAlignment =
      M3ESplitButtonTrailingAlignment.opticalCenter;
  SplitButtonMenuStyle _splitMenuStyle = SplitButtonMenuStyle.popup;
  String _splitSelectedValue = 'Save Draft';
  String _leadingTooltip = 'Trigger Primary Action';
  String _trailingTooltip = 'More Actions';
  double _splitGap = 0.0;
  double _trailingSelectedRadius = 8.0;
  bool _useCustomDividerColor = false;
  Color _customDividerColor = Colors.teal;

  void _applyGroupPreset(GroupPreset preset) {
    setState(() {
      _groupPreset = preset;
      _isCustomSize = false;
      switch (preset) {
        case GroupPreset.formatting:
          _groupType = M3EButtonGroupType.connected;
          _style = M3EButtonStyle.tonal;
          _useCustomHeight = false;
          _size = M3EButtonSize.sm;
          _spacing = 0.0;
          _expandedRatio = 0.15;
          _checkedRadius = 12.0;
          _pressedRadius = 8.0;
          _neighborSquish = true;
          _groupShowIcon = true;
          _groupShowCheckedIcon = false;
          _groupShowLabel = true;
          _groupShowCheckedLabel = false;
          _groupPerActionDecoration = false;
          _groupMultiSelect = false;
          _hasDisabledAction = false;
          break;
        case GroupPreset.morphingCheckedLabel:
          _groupType = M3EButtonGroupType.standard;
          _style = M3EButtonStyle.filled;
          _useCustomHeight = false;
          _size = M3EButtonSize.md;
          _spacing = 8.0;
          _expandedRatio = 0.15;
          _checkedRadius = 12.0;
          _pressedRadius = 8.0;
          _neighborSquish = true;
          _groupMultiSelect = true;
          _groupShowIcon = true;
          _groupShowCheckedIcon = false;
          _groupShowLabel = false;
          _groupShowCheckedLabel = true;
          _groupPerActionDecoration = true;
          _multiSelectedIndices = {0};
          _hasDisabledAction = false;
          break;
        case GroupPreset.composeVariableWidths:
          _groupType = M3EButtonGroupType.standard;
          _style = M3EButtonStyle.filled;
          _spacing = 6.0;
          _expandedRatio = 0.08;
          _useCustomHeight = false;
          _customHeight = 80.0;
          _checkedRadius = 12.0;
          _pressedRadius = 6.0;
          _haptic = M3EHapticFeedback.light;
          _motionPreset = M3EExampleMotionPreset.expressiveSpatialDefault;
          _icon = Icons.bolt_rounded;
          _groupMultiSelect = false;
          _useVariableActionWidths = true;
          _groupShowIcon = true;
          _groupShowCheckedIcon = false;
          _groupShowLabel = false;
          _groupShowCheckedLabel = false;
          _groupPerActionDecoration = false;
          _hasDisabledAction = false;
          break;
        case GroupPreset.quickSettings:
          _groupType = M3EButtonGroupType.connected;
          _style = M3EButtonStyle.tonal;
          _useCustomHeight = false;
          _size = M3EButtonSize.md;
          _spacing = 0.0;
          _expandedRatio = 0.12;
          _checkedRadius = 16.0;
          _pressedRadius = 8.0;
          _neighborSquish = true;
          _groupShowIcon = true;
          _groupShowCheckedIcon = false;
          _groupShowLabel = true;
          _groupShowCheckedLabel = false;
          _groupPerActionDecoration = false;
          _hasDisabledAction = false;
          break;
      }
    });
  }

  String _generateCodeSnippet() {
    return ButtonCodeSnippets.generate(
      arch: _arch,
      fabMode: _fabMode,
      fabSize: _fabSize,
      fabColor: _fabColor,
      fabExpanded: _fabExpanded,
      fabLabel: _fabLabel,
      fabIcon: _fabIcon,
      fabMenuPosition: _fabMenuPosition,
      fabEnabled: _fabEnabled,
      customFabCornerRadius: _customFabCornerRadius,
      useCustomFabCornerRadius: _useCustomFabCornerRadius,
      fabPressedScale: _fabPressedScale,
      fabMotionPreset: _fabMotionPreset,
      fabMotionStiffness: _fabMotionStiffness,
      fabMotionDamping: _fabMotionDamping,
      menuItemGap: _menuItemGap,
      menuOffset: _menuOffset,
      menuItemHeight: _menuItemHeight,
      menuItemHorizontalPadding: _menuItemHorizontalPadding,
      menuIconLabelGap: _menuIconLabelGap,
      menuItemElevation: _menuItemElevation,
      menuItemCount: _menuItemCount,
      menuExpandStaggerMs: _menuExpandStaggerMs,
      menuExpandMotionPreset: _menuExpandMotionPreset,
      menuExpandMotionStiffness: _menuExpandMotionStiffness,
      menuExpandMotionDamping: _menuExpandMotionDamping,
      menuFabShapeMotionPreset: _menuFabShapeMotionPreset,
      menuFabShapeMotionStiffness: _menuFabShapeMotionStiffness,
      menuFabShapeMotionDamping: _menuFabShapeMotionDamping,
      useMenuScrim: _useMenuScrim,
      menuScrimOpacity: _menuScrimOpacity,
      useCustomMenuItemBg: _useCustomMenuItemBg,
      useCustomMenuItemFg: _useCustomMenuItemFg,
      style: _style,
      size: _size,
      shape: _shape,
      enabled: _enabled,
      useDecoration: _useDecoration,
      enableFeedback: _enableFeedback,
      mouseCursor: _mouseCursor,
      contentLayout: _contentLayout,
      iconAlignment: _iconAlignment,
      label: _label,
      buttonTooltip: _buttonTooltip,
      restingBorderRadius: _restingBorderRadius,
      pressedRadius: _pressedRadius,
      hoveredRadius: _hoveredRadius,
      checkedRadius: _checkedRadius,
      elevation: _elevation,
      motionPreset: _motionPreset,
      motionStiffness: _motionStiffness,
      motionDamping: _motionDamping,
      haptic: _haptic,
      useCustomColor: _useCustomColor,
      useCustomFg: _useCustomFg,
      useBorder: _useBorder,
      borderWidth: _borderWidth,
      isChecked: _isChecked,
      useCustomCheckedIcon: _useCustomCheckedIcon,
      useCustomCheckedLabel: _useCustomCheckedLabel,
      checkedLabel: _checkedLabel,
      allowMultilineLabel: _allowMultilineLabel,
      groupPreset: _groupPreset,
      useVariableActionWidths: _useVariableActionWidths,
      groupShowIcon: _groupShowIcon,
      groupShowCheckedIcon: _groupShowCheckedIcon,
      groupShowLabel: _groupShowLabel,
      groupShowCheckedLabel: _groupShowCheckedLabel,
      groupPerActionDecoration: _groupPerActionDecoration,
      hasDisabledAction: _hasDisabledAction,
      groupType: _groupType,
      groupMultiSelect: _groupMultiSelect,
      neighborSquish: _neighborSquish,
      expandedRatio: _expandedRatio,
      spacing: _spacing,
      useCustomHeight: _useCustomHeight,
      customHeight: _customHeight,
      density: _density,
      direction: _direction,
      overflow: _overflow,
      overflowMenuStyle: _overflowMenuStyle,
      overflowUseCardList: _overflowUseCardList,
      splitAlignment: _splitAlignment,
      splitMenuStyle: _splitMenuStyle,
      splitSelectedValue: _splitSelectedValue,
      leadingTooltip: _leadingTooltip,
      trailingTooltip: _trailingTooltip,
      splitGap: _splitGap,
      trailingSelectedRadius: _trailingSelectedRadius,
      useCustomDividerColor: _useCustomDividerColor,
    );
  }

  List<Widget> _buildControls(BuildContext context) {
    if (_arch == ButtonArchitecture.floatingAction) {
      return [
        ButtonArchitectureControls(
          architecture: _arch,
          onArchitectureChanged: (arch) {
            setState(() {
              _arch = arch;
              if (_arch == ButtonArchitecture.split &&
                  _style == M3EButtonStyle.text) {
                _style = M3EButtonStyle.filled;
              }
            });
          },
          fabMode: _fabMode,
          onFabModeChanged: (mode) => setState(() => _fabMode = mode),
        ),
        ButtonFabControls(
          fabMode: _fabMode,
          fabSize: _fabSize,
          onFabSizeChanged: (size) => setState(() => _fabSize = size),
          fabColor: _fabColor,
          onFabColorChanged: (color) => setState(() => _fabColor = color),
          fabExpanded: _fabExpanded,
          onFabExpandedChanged: (val) => setState(() => _fabExpanded = val),
          fabLabel: _fabLabel,
          onFabLabelChanged: (val) => setState(() => _fabLabel = val),
          onFabIconChanged: (icon) => setState(() => _fabIcon = icon),
          fabMenuPosition: _fabMenuPosition,
          onFabMenuPositionChanged: (pos) =>
              setState(() => _fabMenuPosition = pos),
          fabEnabled: _fabEnabled,
          onFabEnabledChanged: (val) => setState(() => _fabEnabled = val),
          customFabCornerRadius: _customFabCornerRadius,
          onCustomFabCornerRadiusChanged: (val) =>
              setState(() => _customFabCornerRadius = val),
          useCustomFabCornerRadius: _useCustomFabCornerRadius,
          onUseCustomFabCornerRadiusChanged: (val) =>
              setState(() => _useCustomFabCornerRadius = val),
          fabPressedScale: _fabPressedScale,
          onFabPressedScaleChanged: (val) =>
              setState(() => _fabPressedScale = val),
          fabMotionPreset: _fabMotionPreset,
          onFabMotionPresetChanged: (preset) =>
              setState(() => _fabMotionPreset = preset),
          fabMotionStiffness: _fabMotionStiffness,
          onFabMotionStiffnessChanged: (val) =>
              setState(() => _fabMotionStiffness = val),
          fabMotionDamping: _fabMotionDamping,
          onFabMotionDampingChanged: (val) =>
              setState(() => _fabMotionDamping = val),
          menuItemGap: _menuItemGap,
          onMenuItemGapChanged: (val) => setState(() => _menuItemGap = val),
          menuOffset: _menuOffset,
          onMenuOffsetChanged: (val) => setState(() => _menuOffset = val),
          menuItemHeight: _menuItemHeight,
          onMenuItemHeightChanged: (val) =>
              setState(() => _menuItemHeight = val),
          menuItemHorizontalPadding: _menuItemHorizontalPadding,
          onMenuItemHorizontalPaddingChanged: (val) =>
              setState(() => _menuItemHorizontalPadding = val),
          menuIconLabelGap: _menuIconLabelGap,
          onMenuIconLabelGapChanged: (val) =>
              setState(() => _menuIconLabelGap = val),
          menuItemElevation: _menuItemElevation,
          onMenuItemElevationChanged: (val) =>
              setState(() => _menuItemElevation = val),
          menuItemCount: _menuItemCount,
          onMenuItemCountChanged: (val) => setState(() => _menuItemCount = val),
          menuExpandStaggerMs: _menuExpandStaggerMs,
          onMenuExpandStaggerMsChanged: (val) =>
              setState(() => _menuExpandStaggerMs = val),
          menuExpandMotionPreset: _menuExpandMotionPreset,
          onMenuExpandMotionPresetChanged: (val) =>
              setState(() => _menuExpandMotionPreset = val),
          menuExpandMotionStiffness: _menuExpandMotionStiffness,
          onMenuExpandMotionStiffnessChanged: (val) =>
              setState(() => _menuExpandMotionStiffness = val),
          menuExpandMotionDamping: _menuExpandMotionDamping,
          onMenuExpandMotionDampingChanged: (val) =>
              setState(() => _menuExpandMotionDamping = val),
          menuFabShapeMotionPreset: _menuFabShapeMotionPreset,
          onMenuFabShapeMotionPresetChanged: (val) =>
              setState(() => _menuFabShapeMotionPreset = val),
          menuFabShapeMotionStiffness: _menuFabShapeMotionStiffness,
          onMenuFabShapeMotionStiffnessChanged: (val) =>
              setState(() => _menuFabShapeMotionStiffness = val),
          menuFabShapeMotionDamping: _menuFabShapeMotionDamping,
          onMenuFabShapeMotionDampingChanged: (val) =>
              setState(() => _menuFabShapeMotionDamping = val),
          useMenuScrim: _useMenuScrim,
          onUseMenuScrimChanged: (val) => setState(() => _useMenuScrim = val),
          menuScrimOpacity: _menuScrimOpacity,
          onMenuScrimOpacityChanged: (val) =>
              setState(() => _menuScrimOpacity = val),
        ),
        ButtonColorControls(
          isFabMenu: _fabMode == FabArchitectureMode.menu,
          useCustomColor: _useCustomColor,
          onUseCustomColorChanged: (val) =>
              setState(() => _useCustomColor = val),
          customColor: _customColor,
          onCustomColorChanged: (val) => setState(() => _customColor = val),
          useCustomFg: _useCustomFg,
          onUseCustomFgChanged: (val) => setState(() => _useCustomFg = val),
          customFg: _customFg,
          onCustomFgChanged: (val) => setState(() => _customFg = val),
          useBorder: _useBorder,
          onUseBorderChanged: (val) => setState(() => _useBorder = val),
          borderWidth: _borderWidth,
          onBorderWidthChanged: (val) => setState(() => _borderWidth = val),
          useCustomMenuItemBg: _useCustomMenuItemBg,
          onUseCustomMenuItemBgChanged: (val) =>
              setState(() => _useCustomMenuItemBg = val),
          customMenuItemBg: _customMenuItemBg,
          onCustomMenuItemBgChanged: (val) =>
              setState(() => _customMenuItemBg = val),
          useCustomMenuItemFg: _useCustomMenuItemFg,
          onUseCustomMenuItemFgChanged: (val) =>
              setState(() => _useCustomMenuItemFg = val),
          customMenuItemFg: _customMenuItemFg,
          onCustomMenuItemFgChanged: (val) =>
              setState(() => _customMenuItemFg = val),
        ),
      ];
    }

    return [
      ButtonArchitectureControls(
        architecture: _arch,
        onArchitectureChanged: (arch) {
          setState(() {
            _arch = arch;
            if (_arch == ButtonArchitecture.split &&
                _style == M3EButtonStyle.text) {
              _style = M3EButtonStyle.filled;
            }
          });
        },
        fabMode: _fabMode,
        onFabModeChanged: (mode) => setState(() => _fabMode = mode),
      ),
      ButtonStandardControls(
        architecture: _arch,
        style: _style,
        onStyleChanged: (style) => setState(() => _style = style),
        size: _size,
        onSizeChanged: (size) => setState(() {
          _size = size;
          _isCustomSize = false;
          _useCustomHeight = false;
        }),
        isCustomSize: _isCustomSize,
        onIsCustomSizeChanged: (isCustom) => setState(() {
          _isCustomSize = isCustom;
          if (isCustom) {
            _updateCustomSize();
          } else {
            _size = M3EButtonSize.md;
          }
        }),
        customHeight: _customButtonHeight,
        onCustomHeightChanged: (val) => setState(() {
          _customButtonHeight = val;
          if (_isCustomSize) _updateCustomSize();
        }),
        customHPadding: _customButtonHPadding,
        onCustomHPaddingChanged: (val) => setState(() {
          _customButtonHPadding = val;
          if (_isCustomSize) _updateCustomSize();
        }),
        customIconSize: _customButtonIconSize,
        onCustomIconSizeChanged: (val) => setState(() {
          _customButtonIconSize = val;
          if (_isCustomSize) _updateCustomSize();
        }),
        customIconGap: _customButtonIconGap,
        onCustomIconGapChanged: (val) => setState(() {
          _customButtonIconGap = val;
          if (_isCustomSize) _updateCustomSize();
        }),
        useCustomWidth: _useCustomButtonWidth,
        onUseCustomWidthChanged: (val) => setState(() {
          _useCustomButtonWidth = val;
          if (_isCustomSize) _updateCustomSize();
        }),
        customWidth: _customButtonWidth,
        onCustomWidthChanged: (val) => setState(() {
          _customButtonWidth = val;
          if (_isCustomSize) _updateCustomSize();
        }),
        shape: _shape,
        onShapeChanged: (shape) => setState(() => _shape = shape),
        useDecoration: _useDecoration,
        onUseDecorationChanged: (val) => setState(() => _useDecoration = val),
        enabled: _enabled,
        onEnabledChanged: (val) => setState(() => _enabled = val),
        enableFeedback: _enableFeedback,
        onEnableFeedbackChanged: (val) => setState(() => _enableFeedback = val),
        contentLayout: _contentLayout,
        onContentLayoutChanged: (layout) =>
            setState(() => _contentLayout = layout),
        iconAlignment: _iconAlignment,
        onIconAlignmentChanged: (align) =>
            setState(() => _iconAlignment = align),
        label: _label,
        onLabelChanged: (val) => setState(() => _label = val),
        icon: _icon,
        onIconChanged: (icon) => setState(() => _icon = icon),
        buttonTooltip: _buttonTooltip,
        onButtonTooltipChanged: (val) => setState(() => _buttonTooltip = val),
      ),
      if (_arch == ButtonArchitecture.toggle)
        ButtonToggleControls(
          isChecked: _isChecked,
          onIsCheckedChanged: (val) => setState(() => _isChecked = val),
          allowMultilineLabel: _allowMultilineLabel,
          onAllowMultilineLabelChanged: (val) =>
              setState(() => _allowMultilineLabel = val),
          useCustomCheckedLabel: _useCustomCheckedLabel,
          onUseCustomCheckedLabelChanged: (val) =>
              setState(() => _useCustomCheckedLabel = val),
          checkedLabel: _checkedLabel,
          onCheckedLabelChanged: (val) => setState(() => _checkedLabel = val),
          useCustomCheckedIcon: _useCustomCheckedIcon,
          onUseCustomCheckedIconChanged: (val) =>
              setState(() => _useCustomCheckedIcon = val),
          checkedIcon: _checkedIcon,
          onCheckedIconChanged: (val) => setState(() => _checkedIcon = val),
        ),
      if (_arch == ButtonArchitecture.group)
        ButtonGroupControls(
          groupPreset: _groupPreset,
          onGroupPresetSelected: _applyGroupPreset,
          groupShowIcon: _groupShowIcon,
          onGroupShowIconChanged: (val) => setState(() => _groupShowIcon = val),
          groupShowCheckedIcon: _groupShowCheckedIcon,
          onGroupShowCheckedIconChanged: (val) =>
              setState(() => _groupShowCheckedIcon = val),
          groupShowLabel: _groupShowLabel,
          onGroupShowLabelChanged: (val) =>
              setState(() => _groupShowLabel = val),
          groupShowCheckedLabel: _groupShowCheckedLabel,
          onGroupShowCheckedLabelChanged: (val) =>
              setState(() => _groupShowCheckedLabel = val),
          groupPerActionDecoration: _groupPerActionDecoration,
          onGroupPerActionDecorationChanged: (val) =>
              setState(() => _groupPerActionDecoration = val),
          showActionTooltips: _showActionTooltips,
          onShowActionTooltipsChanged: (val) =>
              setState(() => _showActionTooltips = val),
          hasDisabledAction: _hasDisabledAction,
          onHasDisabledActionChanged: (val) =>
              setState(() => _hasDisabledAction = val),
          useVariableActionWidths: _useVariableActionWidths,
          onUseVariableActionWidthsChanged: (val) =>
              setState(() => _useVariableActionWidths = val),
          groupType: _groupType,
          onGroupTypeChanged: (type) => setState(() => _groupType = type),
          spacing: _spacing,
          onSpacingChanged: (val) => setState(() => _spacing = val),
          useCustomHeight: _useCustomHeight,
          onUseCustomHeightChanged: (val) =>
              setState(() => _useCustomHeight = val),
          customHeight: _customHeight,
          onCustomHeightChanged: (val) => setState(() => _customHeight = val),
          groupMultiSelect: _groupMultiSelect,
          onGroupMultiSelectChanged: (val) =>
              setState(() => _groupMultiSelect = val),
          neighborSquish: _neighborSquish,
          onNeighborSquishChanged: (val) =>
              setState(() => _neighborSquish = val),
          expandedRatio: _expandedRatio,
          onExpandedRatioChanged: (val) => setState(() => _expandedRatio = val),
          density: _density,
          onDensityChanged: (val) => setState(() => _density = val),
          direction: _direction,
          onDirectionChanged: (val) => setState(() => _direction = val),
          overflow: _overflow,
          onOverflowChanged: (val) => setState(() => _overflow = val),
          overflowMenuStyle: _overflowMenuStyle,
          onOverflowMenuStyleChanged: (val) =>
              setState(() => _overflowMenuStyle = val),
          overflowUseCardList: _overflowUseCardList,
          onOverflowUseCardListChanged: (val) =>
              setState(() => _overflowUseCardList = val),
          overflowIcon: _overflowIcon,
          onOverflowIconChanged: (val) => setState(() => _overflowIcon = val),
          actionCount: _actionCount,
          onActionCountChanged: (val) => setState(() => _actionCount = val),
        ),
      if (_arch == ButtonArchitecture.split)
        ButtonSplitControls(
          splitMenuStyle: _splitMenuStyle,
          onSplitMenuStyleChanged: (style) =>
              setState(() => _splitMenuStyle = style),
          splitAlignment: _splitAlignment,
          onSplitAlignmentChanged: (align) =>
              setState(() => _splitAlignment = align),
          splitSelectedValue: _splitSelectedValue,
          onSplitSelectedValueChanged: (val) =>
              setState(() => _splitSelectedValue = val),
          splitGap: _splitGap,
          onSplitGapChanged: (val) => setState(() => _splitGap = val),
          trailingSelectedRadius: _trailingSelectedRadius,
          onTrailingSelectedRadiusChanged: (val) =>
              setState(() => _trailingSelectedRadius = val),
          useCustomDividerColor: _useCustomDividerColor,
          onUseCustomDividerColorChanged: (val) =>
              setState(() => _useCustomDividerColor = val),
          customDividerColor: _customDividerColor,
          onCustomDividerColorChanged: (val) =>
              setState(() => _customDividerColor = val),
          leadingTooltip: _leadingTooltip,
          onLeadingTooltipChanged: (val) =>
              setState(() => _leadingTooltip = val),
          onTrailingTooltipChanged: (val) =>
              setState(() => _trailingTooltip = val),
        ),
      ButtonMorphingControls(
        architecture: _arch,
        restingBorderRadius: _restingBorderRadius,
        onRestingBorderRadiusChanged: (val) =>
            setState(() => _restingBorderRadius = val),
        pressedRadius: _pressedRadius,
        onPressedRadiusChanged: (val) => setState(() => _pressedRadius = val),
        hoveredRadius: _hoveredRadius,
        onHoveredRadiusChanged: (val) => setState(() => _hoveredRadius = val),
        checkedRadius: _checkedRadius,
        onCheckedRadiusChanged: (val) => setState(() => _checkedRadius = val),
        elevation: _elevation,
        onElevationChanged: (val) => setState(() => _elevation = val),
        mouseCursor: _mouseCursor,
        onMouseCursorChanged: (val) => setState(() => _mouseCursor = val),
        motionPreset: _motionPreset,
        onMotionPresetChanged: (val) => setState(() => _motionPreset = val),
        motionStiffness: _motionStiffness,
        onMotionStiffnessChanged: (val) =>
            setState(() => _motionStiffness = val),
        motionDamping: _motionDamping,
        onMotionDampingChanged: (val) => setState(() => _motionDamping = val),
        haptic: _haptic,
        onHapticChanged: (val) => setState(() => _haptic = val),
      ),
      ButtonColorControls(
        useCustomColor: _useCustomColor,
        onUseCustomColorChanged: (val) => setState(() => _useCustomColor = val),
        customColor: _customColor,
        onCustomColorChanged: (val) => setState(() => _customColor = val),
        useCustomFg: _useCustomFg,
        onUseCustomFgChanged: (val) => setState(() => _useCustomFg = val),
        customFg: _customFg,
        onCustomFgChanged: (val) => setState(() => _customFg = val),
        useBorder: _useBorder,
        onUseBorderChanged: (val) => setState(() => _useBorder = val),
        borderWidth: _borderWidth,
        onBorderWidthChanged: (val) => setState(() => _borderWidth = val),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: ButtonPreviewArea(
        architecture: _arch,
        fabMode: _fabMode,
        fabSize: _fabSize,
        fabColor: _fabColor,
        fabExpanded: _fabExpanded,
        fabLabel: _fabLabel,
        fabIcon: _fabIcon,
        fabMenuPosition: _fabMenuPosition,
        fabEnabled: _fabEnabled,
        customFabCornerRadius: _customFabCornerRadius,
        useCustomFabCornerRadius: _useCustomFabCornerRadius,
        fabPressedScale: _fabPressedScale,
        fabMotion: _fabMotionPreset.resolve(
          stiffness: _fabMotionStiffness,
          damping: _fabMotionDamping,
        ),
        menuItemGap: _menuItemGap,
        menuOffset: _menuOffset,
        menuItemHeight: _menuItemHeight,
        menuItemHorizontalPadding: _menuItemHorizontalPadding,
        menuIconLabelGap: _menuIconLabelGap,
        menuItemElevation: _menuItemElevation,
        menuItemCount: _menuItemCount,
        menuExpandStaggerMs: _menuExpandStaggerMs,
        menuExpandMotion: _menuExpandMotionPreset.resolve(
          stiffness: _menuExpandMotionStiffness,
          damping: _menuExpandMotionDamping,
        ),
        menuFabShapeMotion: _menuFabShapeMotionPreset.resolve(
          stiffness: _menuFabShapeMotionStiffness,
          damping: _menuFabShapeMotionDamping,
        ),
        useMenuScrim: _useMenuScrim,
        menuScrimOpacity: _menuScrimOpacity,
        useCustomMenuItemBg: _useCustomMenuItemBg,
        customMenuItemBg: _customMenuItemBg,
        useCustomMenuItemFg: _useCustomMenuItemFg,
        customMenuItemFg: _customMenuItemFg,
        style: _style,
        size: _size,
        shape: _shape,
        enabled: _enabled,
        useDecoration: _useDecoration,
        enableFeedback: _enableFeedback,
        mouseCursor: _mouseCursor,
        contentLayout: _contentLayout,
        iconAlignment: _iconAlignment,
        label: _label,
        icon: _icon,
        buttonTooltip: _buttonTooltip,
        isChecked: _isChecked,
        onIsCheckedChanged: (val) => setState(() => _isChecked = val),
        useCustomCheckedIcon: _useCustomCheckedIcon,
        checkedIcon: _checkedIcon,
        useCustomCheckedLabel: _useCustomCheckedLabel,
        checkedLabel: _checkedLabel,
        allowMultilineLabel: _allowMultilineLabel,
        groupPreset: _groupPreset,
        useVariableActionWidths: _useVariableActionWidths,
        groupShowIcon: _groupShowIcon,
        groupShowCheckedIcon: _groupShowCheckedIcon,
        groupShowLabel: _groupShowLabel,
        groupShowCheckedLabel: _groupShowCheckedLabel,
        groupPerActionDecoration: _groupPerActionDecoration,
        hasDisabledAction: _hasDisabledAction,
        showActionTooltips: _showActionTooltips,
        groupType: _groupType,
        groupMultiSelect: _groupMultiSelect,
        singleSelectedIndex: _singleSelectedIndex,
        onSingleSelectedIndexChanged: (idx) =>
            setState(() => _singleSelectedIndex = idx),
        multiSelectedIndices: _multiSelectedIndices,
        onMultiSelectedIndicesChanged: (set) =>
            setState(() => _multiSelectedIndices = set),
        neighborSquish: _neighborSquish,
        expandedRatio: _expandedRatio,
        spacing: _spacing,
        useCustomHeight: _useCustomHeight,
        customHeight: _customHeight,
        density: _density,
        direction: _direction,
        overflow: _overflow,
        overflowMenuStyle: _overflowMenuStyle,
        overflowUseCardList: _overflowUseCardList,
        overflowIcon: _overflowIcon,
        actionCount: _actionCount,
        splitAlignment: _splitAlignment,
        splitMenuStyle: _splitMenuStyle,
        splitSelectedValue: _splitSelectedValue,
        onSplitSelectedValueChanged: (val) =>
            setState(() => _splitSelectedValue = val),
        leadingTooltip: _leadingTooltip,
        trailingTooltip: _trailingTooltip,
        splitGap: _splitGap,
        trailingSelectedRadius: _trailingSelectedRadius,
        useCustomDividerColor: _useCustomDividerColor,
        customDividerColor: _customDividerColor,
        useCustomColor: _useCustomColor,
        customColor: _customColor,
        useCustomFg: _useCustomFg,
        customFg: _customFg,
        useBorder: _useBorder,
        borderWidth: _borderWidth,
        elevation: _elevation,
        restingBorderRadius: _restingBorderRadius,
        pressedRadius: _pressedRadius,
        hoveredRadius: _hoveredRadius,
        checkedRadius: _checkedRadius,
        motion: _motionPreset.resolve(
          stiffness: _motionStiffness,
          damping: _motionDamping,
        ),
        haptic: _haptic,
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(context),
    );
  }
}
