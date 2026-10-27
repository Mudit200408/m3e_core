// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

/// Distinct menu use cases / scenarios showcased in the playground.
enum MenuUseCase {
  actions('Actions & Nav', Icons.list_alt_rounded),
  cascading('Cascading', Icons.account_tree_rounded),
  preferences('Preferences', Icons.tune_rounded),
  popupButton('Popup Button', Icons.more_vert_rounded),
  multiSection('Multi-Section', Icons.dashboard_customize_rounded);

  final String label;
  final IconData icon;
  const MenuUseCase(this.label, this.icon);
}

/// Interactive anchor placement positions for testing directional popups.
enum MenuAnchorPosition {
  topLeft('Top Left', Alignment.topLeft),
  topCenter('Top', Alignment.topCenter),
  topRight('Top Right', Alignment.topRight),
  centerLeft('Left', Alignment.centerLeft),
  center('Center', Alignment.center),
  centerRight('Right', Alignment.centerRight),
  bottomLeft('Bottom Left', Alignment.bottomLeft),
  bottomCenter('Bottom', Alignment.bottomCenter),
  bottomRight('Bottom Right', Alignment.bottomRight);

  final String label;
  final Alignment alignment;
  const MenuAnchorPosition(this.label, this.alignment);
}

/// Selection mode for Preferences scenario.
enum PreferencesSelectionMode {
  multiSelect('Multi-select'),
  singleSelect('Single-select');

  final String label;
  const PreferencesSelectionMode(this.label);
}

/// Indicator presentation style for Preferences scenario.
enum PreferencesIndicatorStyle {
  tickIcon('Tick Icon', Icons.check_rounded),
  checkbox('Square Checkbox', Icons.check_box_rounded),
  activityIcons('Activity Icons (Color only)', Icons.directions_walk_rounded);

  final String label;
  final IconData icon;
  const PreferencesIndicatorStyle(this.label, this.icon);
}

/// Color preset options for custom M3EMenuItemStyle.
enum MenuItemColorPreset {
  tertiaryContainer('Tertiary'),
  secondaryContainer('Secondary'),
  primaryContainer('Primary'),
  errorContainer('Error');

  final String label;
  const MenuItemColorPreset(this.label);
}

/// Playground state configuration for M3E Menu.
class MenuPlaygroundState {
  MenuUseCase useCase = MenuUseCase.actions;
  M3EMenuColorSchemeVariant colorSchemeVariant =
      M3EMenuColorSchemeVariant.standard;
  M3EExampleMotionPreset motionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  M3EMenuAnimationStyle animationStyle = M3EMenuAnimationStyle.popup;
  MenuAnchorPosition anchorPosition = MenuAnchorPosition.center;
  double alignmentOffsetX = 0.0;
  double alignmentOffsetY = 0.0;
  bool showGroups = true;
  bool showIcons = true;
  bool showShortcuts = true;
  bool showSupportingText = false;
  double spatialStiffness = 800.0;
  double spatialDamping = 0.6;
  double elevation = 3.0;
  double minWidth = 180.0;
  double maxWidth = 300.0;
  bool consumeOutsideTaps = true;
  bool anchorTapClosesMenu = true;
  bool enabled = true;
  bool enableMaxHeight = false;
  double maxHeight = 260.0;
  bool useCustomItemStyle = false;
  double itemHorizontalPadding = 18.0;
  double itemVerticalPadding = 10.0;
  MenuItemColorPreset itemColorPreset = MenuItemColorPreset.secondaryContainer;
  bool itemMorphShapeOnSelect = true;
  M3EMenuPosition menuPosition = M3EMenuPosition.under;
  bool triggerAsIcon = true;
  double triggerIconSize = 24.0;
  bool popupEnabled = true;
  bool popupRequestFocus = true;
  String? popupInitialValue;
  bool showCheckedEntry = true;
  String? lastPopupSelection;
  bool lastPopupCanceled = false;
  PreferencesSelectionMode preferencesSelectionMode =
      PreferencesSelectionMode.multiSelect;
  PreferencesIndicatorStyle preferencesIndicatorStyle =
      PreferencesIndicatorStyle.tickIcon;

  MenuPlaygroundState({
    this.useCase = MenuUseCase.actions,
    this.colorSchemeVariant = M3EMenuColorSchemeVariant.standard,
    this.motionPreset = M3EExampleMotionPreset.expressiveSpatialFast,
    this.animationStyle = M3EMenuAnimationStyle.popup,
    this.anchorPosition = MenuAnchorPosition.center,
    this.alignmentOffsetX = 0.0,
    this.alignmentOffsetY = 0.0,
    this.showGroups = true,
    this.showIcons = true,
    this.showShortcuts = true,
    this.showSupportingText = false,
    this.spatialStiffness = 800.0,
    this.spatialDamping = 0.6,
    this.elevation = 3.0,
    this.minWidth = 180.0,
    this.maxWidth = 300.0,
    this.consumeOutsideTaps = true,
    this.anchorTapClosesMenu = true,
    this.enabled = true,
    this.enableMaxHeight = false,
    this.maxHeight = 260.0,
    this.useCustomItemStyle = false,
    this.itemHorizontalPadding = 18.0,
    this.itemVerticalPadding = 10.0,
    this.itemColorPreset = MenuItemColorPreset.secondaryContainer,
    this.itemMorphShapeOnSelect = true,
    this.menuPosition = M3EMenuPosition.under,
    this.triggerAsIcon = true,
    this.triggerIconSize = 24.0,
    this.popupEnabled = true,
    this.popupRequestFocus = true,
    this.popupInitialValue,
    this.showCheckedEntry = true,
    this.lastPopupSelection,
    this.lastPopupCanceled = false,
    this.preferencesSelectionMode = PreferencesSelectionMode.multiSelect,
    this.preferencesIndicatorStyle = PreferencesIndicatorStyle.tickIcon,
  });

  /// Resolves the effective [M3EMotion] from current preset and custom spring params.
  M3EMotion get effectiveMotion => motionPreset.resolve(
    stiffness: spatialStiffness,
    damping: spatialDamping,
  );

  MenuPlaygroundState copyWith({
    MenuUseCase? useCase,
    M3EMenuColorSchemeVariant? colorSchemeVariant,
    M3EExampleMotionPreset? motionPreset,
    M3EMenuAnimationStyle? animationStyle,
    MenuAnchorPosition? anchorPosition,
    double? alignmentOffsetX,
    double? alignmentOffsetY,
    bool? showGroups,
    bool? showIcons,
    bool? showShortcuts,
    bool? showSupportingText,
    double? spatialStiffness,
    double? spatialDamping,
    double? elevation,
    double? minWidth,
    double? maxWidth,
    bool? consumeOutsideTaps,
    bool? anchorTapClosesMenu,
    bool? enabled,
    bool? enableMaxHeight,
    double? maxHeight,
    bool? useCustomItemStyle,
    double? itemHorizontalPadding,
    double? itemVerticalPadding,
    MenuItemColorPreset? itemColorPreset,
    bool? itemMorphShapeOnSelect,
    M3EMenuPosition? menuPosition,
    bool? triggerAsIcon,
    double? triggerIconSize,
    bool? popupEnabled,
    bool? popupRequestFocus,
    String? popupInitialValue,
    bool? showCheckedEntry,
    String? lastPopupSelection,
    bool? lastPopupCanceled,
    PreferencesSelectionMode? preferencesSelectionMode,
    PreferencesIndicatorStyle? preferencesIndicatorStyle,
  }) {
    return MenuPlaygroundState(
      useCase: useCase ?? this.useCase,
      colorSchemeVariant: colorSchemeVariant ?? this.colorSchemeVariant,
      motionPreset: motionPreset ?? this.motionPreset,
      animationStyle: animationStyle ?? this.animationStyle,
      anchorPosition: anchorPosition ?? this.anchorPosition,
      alignmentOffsetX: alignmentOffsetX ?? this.alignmentOffsetX,
      alignmentOffsetY: alignmentOffsetY ?? this.alignmentOffsetY,
      showGroups: showGroups ?? this.showGroups,
      showIcons: showIcons ?? this.showIcons,
      showShortcuts: showShortcuts ?? this.showShortcuts,
      showSupportingText: showSupportingText ?? this.showSupportingText,
      spatialStiffness: spatialStiffness ?? this.spatialStiffness,
      spatialDamping: spatialDamping ?? this.spatialDamping,
      elevation: elevation ?? this.elevation,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      consumeOutsideTaps: consumeOutsideTaps ?? this.consumeOutsideTaps,
      anchorTapClosesMenu: anchorTapClosesMenu ?? this.anchorTapClosesMenu,
      enabled: enabled ?? this.enabled,
      enableMaxHeight: enableMaxHeight ?? this.enableMaxHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      useCustomItemStyle: useCustomItemStyle ?? this.useCustomItemStyle,
      itemHorizontalPadding:
          itemHorizontalPadding ?? this.itemHorizontalPadding,
      itemVerticalPadding: itemVerticalPadding ?? this.itemVerticalPadding,
      itemColorPreset: itemColorPreset ?? this.itemColorPreset,
      itemMorphShapeOnSelect:
          itemMorphShapeOnSelect ?? this.itemMorphShapeOnSelect,
      menuPosition: menuPosition ?? this.menuPosition,
      triggerAsIcon: triggerAsIcon ?? this.triggerAsIcon,
      triggerIconSize: triggerIconSize ?? this.triggerIconSize,
      popupEnabled: popupEnabled ?? this.popupEnabled,
      popupRequestFocus: popupRequestFocus ?? this.popupRequestFocus,
      popupInitialValue: popupInitialValue ?? this.popupInitialValue,
      showCheckedEntry: showCheckedEntry ?? this.showCheckedEntry,
      lastPopupSelection: lastPopupSelection ?? this.lastPopupSelection,
      lastPopupCanceled: lastPopupCanceled ?? this.lastPopupCanceled,
      preferencesSelectionMode:
          preferencesSelectionMode ?? this.preferencesSelectionMode,
      preferencesIndicatorStyle:
          preferencesIndicatorStyle ?? this.preferencesIndicatorStyle,
    );
  }
}
