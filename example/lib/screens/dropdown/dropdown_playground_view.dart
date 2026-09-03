// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../data/mock_data.dart';
import '../../shared/shared.dart';
import 'controls/dropdown_data_controls.dart';
import 'controls/dropdown_field_panel_controls.dart';
import 'controls/dropdown_items_chips_controls.dart';
import 'controls/dropdown_motion_feedback_controls.dart';
import 'controls/dropdown_search_controls.dart';
import 'models/dropdown_models.dart';
import 'preview/dropdown_preview_area.dart';
import 'snippets/dropdown_code_snippets.dart';

export 'models/dropdown_models.dart';

/// Unified playground for the complete M3E dropdown API.
class DropdownPlaygroundView extends StatefulWidget {
  const DropdownPlaygroundView({super.key});

  @override
  State<DropdownPlaygroundView> createState() => _DropdownPlaygroundViewState();
}

class _DropdownPlaygroundViewState extends State<DropdownPlaygroundView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final M3EDropdownController<String> _controller =
      M3EDropdownController<String>();

  DropdownDataMode _dataMode = DropdownDataMode.staticItems;
  DropdownExpandDirection _expandDirection = DropdownExpandDirection.auto;
  M3EHapticFeedback _haptic = M3EHapticFeedback.light;
  bool _singleSelect = false;
  bool _searchEnabled = true;
  bool _showChipAnimation = true;
  bool _enabled = true;
  bool _showClearIcon = true;
  bool _searchFilled = false;
  bool _searchAutofocus = false;
  bool _searchClearIcon = true;
  bool _wrapChips = true;
  bool _closeOnBackButton = false;
  bool _customItemBuilder = false;
  bool _customSelectedBuilder = false;
  bool _customEmptyBuilder = false;
  bool _useSplash = false;
  bool _useFieldColor = false;
  bool _usePanelColor = false;
  bool _useChipColor = false;
  bool _useItemColor = false;
  bool _validationEnabled = false;
  bool _showHeader = false;
  bool _showFooter = false;
  bool _showItemSeparator = false;
  bool _showSelectedIcon = true;
  bool _independentRadii = false;
  int _maxSelections = 3;
  int _searchDebounceMs = 0;
  int _maxDisplayCount = 3;
  double _containerRadius = 28;
  double _fieldRadius = 18;
  double _selectedFieldRadius = 28;
  double _panelRadius = 24;
  double _panelElevation = 4;
  double _panelMaxHeight = 350;
  double _panelMarginTop = 4;
  double _fieldPadding = 14;
  double _panelPadding = 8;
  double _searchPadding = 8;
  double _itemOuterRadius = 18;
  double _itemInnerRadius = 6;
  double _itemGap = 3;
  double _chipRadius = 20;
  double _chipSpacing = 6;
  final double _chipRunSpacing = 6;
  double _chipPadding = 4;
  double _itemPadding = 12;
  double _openStiffness = 500;
  double _openDamping = .6;
  double _closeStiffness = 500;
  double _closeDamping = .6;
  double _pressedScale = 0.98;
  Color _fieldColor = Colors.teal;
  Color _panelColor = Colors.teal;
  Color _chipColor = Colors.teal;
  Color _itemColor = Colors.teal;
  final ValueNotifier<String> _lastEvent = ValueNotifier('No selection yet');
  final ValueNotifier<String> _lastSearch = ValueNotifier('No search yet');

  @override
  void dispose() {
    _controller.dispose();
    _lastEvent.dispose();
    _lastSearch.dispose();
    super.dispose();
  }

  M3EMotion get _openMotion =>
      M3EMotion.custom(stiffness: _openStiffness, damping: _openDamping);
  M3EMotion get _closeMotion =>
      M3EMotion.custom(stiffness: _closeStiffness, damping: _closeDamping);

  List<M3EDropdownItem<String>> get _items => fruitItems;

  Future<List<M3EDropdownItem<String>>> _loadItems() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _items;
  }

  void _onSelectionChanged(List<M3EDropdownItem<String>> items) {
    final labels = items.map((item) => item.label).join(', ');
    if (labels == _lastEvent.value) return;
    _lastEvent.value = labels.isEmpty ? 'Nothing selected' : labels;
  }

  void _onSearchChanged(String query) {
    if (query == _lastSearch.value) return;
    _lastSearch.value = query.isEmpty ? 'No search yet' : query;
  }

  String _generateCodeSnippet() {
    return DropdownCodeSnippets.generate(
      dataMode: _dataMode,
      expandDirection: _expandDirection,
      haptic: _haptic,
      singleSelect: _singleSelect,
      searchEnabled: _searchEnabled,
      showChipAnimation: _showChipAnimation,
      enabled: _enabled,
      showClearIcon: _showClearIcon,
      searchFilled: _searchFilled,
      searchAutofocus: _searchAutofocus,
      searchClearIcon: _searchClearIcon,
      wrapChips: _wrapChips,
      closeOnBackButton: _closeOnBackButton,
      customItemBuilder: _customItemBuilder,
      customSelectedBuilder: _customSelectedBuilder,
      customEmptyBuilder: _customEmptyBuilder,
      useSplash: _useSplash,
      useFieldColor: _useFieldColor,
      usePanelColor: _usePanelColor,
      useChipColor: _useChipColor,
      useItemColor: _useItemColor,
      validationEnabled: _validationEnabled,
      showHeader: _showHeader,
      showFooter: _showFooter,
      showItemSeparator: _showItemSeparator,
      showSelectedIcon: _showSelectedIcon,
      independentRadii: _independentRadii,
      maxSelections: _maxSelections,
      searchDebounceMs: _searchDebounceMs,
      maxDisplayCount: _maxDisplayCount,
      containerRadius: _containerRadius,
      fieldRadius: _fieldRadius,
      selectedFieldRadius: _selectedFieldRadius,
      panelRadius: _panelRadius,
      panelElevation: _panelElevation,
      panelMaxHeight: _panelMaxHeight,
      panelMarginTop: _panelMarginTop,
      fieldPadding: _fieldPadding,
      panelPadding: _panelPadding,
      searchPadding: _searchPadding,
      itemOuterRadius: _itemOuterRadius,
      itemInnerRadius: _itemInnerRadius,
      itemGap: _itemGap,
      chipRadius: _chipRadius,
      chipSpacing: _chipSpacing,
      chipRunSpacing: _chipRunSpacing,
      chipPadding: _chipPadding,
      itemPadding: _itemPadding,
      openStiffness: _openStiffness,
      openDamping: _openDamping,
      closeStiffness: _closeStiffness,
      closeDamping: _closeDamping,
      pressedScale: _pressedScale,
      fieldColor: _fieldColor,
      panelColor: _panelColor,
      chipColor: _chipColor,
      itemColor: _itemColor,
    );
  }

  List<Widget> _buildControls() => [
    DropdownDataControls(
      dataMode: _dataMode,
      onDataModeChanged: (val) => setState(() => _dataMode = val),
      singleSelect: _singleSelect,
      onSingleSelectChanged: (val) => setState(() => _singleSelect = val),
      enabled: _enabled,
      onEnabledChanged: (val) => setState(() => _enabled = val),
      maxSelections: _maxSelections,
      onMaxSelectionsChanged: (val) => setState(() => _maxSelections = val),
      controller: _controller,
      lastEvent: _lastEvent,
      lastSearch: _lastSearch,
    ),
    DropdownSearchControls(
      searchEnabled: _searchEnabled,
      onSearchEnabledChanged: (val) => setState(() => _searchEnabled = val),
      searchFilled: _searchFilled,
      onSearchFilledChanged: (val) => setState(() => _searchFilled = val),
      searchAutofocus: _searchAutofocus,
      onSearchAutofocusChanged: (val) => setState(() => _searchAutofocus = val),
      searchClearIcon: _searchClearIcon,
      onSearchClearIconChanged: (val) => setState(() => _searchClearIcon = val),
      searchDebounceMs: _searchDebounceMs,
      onSearchDebounceMsChanged: (val) =>
          setState(() => _searchDebounceMs = val),
      searchPadding: _searchPadding,
      onSearchPaddingChanged: (val) => setState(() => _searchPadding = val),
    ),
    DropdownFieldPanelControls(
      containerRadius: _containerRadius,
      onContainerRadiusChanged: (val) => setState(() => _containerRadius = val),
      independentRadii: _independentRadii,
      onIndependentRadiiChanged: (val) =>
          setState(() => _independentRadii = val),
      fieldRadius: _fieldRadius,
      onFieldRadiusChanged: (val) => setState(() => _fieldRadius = val),
      selectedFieldRadius: _selectedFieldRadius,
      onSelectedFieldRadiusChanged: (val) =>
          setState(() => _selectedFieldRadius = val),
      panelRadius: _panelRadius,
      onPanelRadiusChanged: (val) => setState(() => _panelRadius = val),
      panelElevation: _panelElevation,
      onPanelElevationChanged: (val) => setState(() => _panelElevation = val),
      panelMaxHeight: _panelMaxHeight,
      onPanelMaxHeightChanged: (val) => setState(() => _panelMaxHeight = val),
      panelMarginTop: _panelMarginTop,
      onPanelMarginTopChanged: (val) => setState(() => _panelMarginTop = val),
      fieldPadding: _fieldPadding,
      onFieldPaddingChanged: (val) => setState(() => _fieldPadding = val),
      panelPadding: _panelPadding,
      onPanelPaddingChanged: (val) => setState(() => _panelPadding = val),
      expandDirection: _expandDirection,
      onExpandDirectionChanged: (val) => setState(() => _expandDirection = val),
      showClearIcon: _showClearIcon,
      onShowClearIconChanged: (val) => setState(() => _showClearIcon = val),
      useFieldColor: _useFieldColor,
      onUseFieldColorChanged: (val) => setState(() => _useFieldColor = val),
      fieldColor: _fieldColor,
      onFieldColorChanged: (val) => setState(() => _fieldColor = val),
      usePanelColor: _usePanelColor,
      onUsePanelColorChanged: (val) => setState(() => _usePanelColor = val),
      panelColor: _panelColor,
      onPanelColorChanged: (val) => setState(() => _panelColor = val),
      showHeader: _showHeader,
      onShowHeaderChanged: (val) => setState(() => _showHeader = val),
      showFooter: _showFooter,
      onShowFooterChanged: (val) => setState(() => _showFooter = val),
      showItemSeparator: _showItemSeparator,
      onShowItemSeparatorChanged: (val) =>
          setState(() => _showItemSeparator = val),
    ),
    DropdownItemsChipsControls(
      itemOuterRadius: _itemOuterRadius,
      onItemOuterRadiusChanged: (val) => setState(() => _itemOuterRadius = val),
      itemInnerRadius: _itemInnerRadius,
      onItemInnerRadiusChanged: (val) => setState(() => _itemInnerRadius = val),
      itemGap: _itemGap,
      onItemGapChanged: (val) => setState(() => _itemGap = val),
      itemPadding: _itemPadding,
      onItemPaddingChanged: (val) => setState(() => _itemPadding = val),
      showSelectedIcon: _showSelectedIcon,
      onShowSelectedIconChanged: (val) =>
          setState(() => _showSelectedIcon = val),
      showChipAnimation: _showChipAnimation,
      onShowChipAnimationChanged: (val) =>
          setState(() => _showChipAnimation = val),
      wrapChips: _wrapChips,
      onWrapChipsChanged: (val) => setState(() => _wrapChips = val),
      chipRadius: _chipRadius,
      onChipRadiusChanged: (val) => setState(() => _chipRadius = val),
      chipSpacing: _chipSpacing,
      onChipSpacingChanged: (val) => setState(() => _chipSpacing = val),
      chipPadding: _chipPadding,
      onChipPaddingChanged: (val) => setState(() => _chipPadding = val),
      maxDisplayCount: _maxDisplayCount,
      onMaxDisplayCountChanged: (val) => setState(() => _maxDisplayCount = val),
      useChipColor: _useChipColor,
      onUseChipColorChanged: (val) => setState(() => _useChipColor = val),
      chipColor: _chipColor,
      onChipColorChanged: (val) => setState(() => _chipColor = val),
      useItemColor: _useItemColor,
      onUseItemColorChanged: (val) => setState(() => _useItemColor = val),
      itemColor: _itemColor,
      onItemColorChanged: (val) => setState(() => _itemColor = val),
      customItemBuilder: _customItemBuilder,
      onCustomItemBuilderChanged: (val) =>
          setState(() => _customItemBuilder = val),
      customSelectedBuilder: _customSelectedBuilder,
      onCustomSelectedBuilderChanged: (val) =>
          setState(() => _customSelectedBuilder = val),
      customEmptyBuilder: _customEmptyBuilder,
      onCustomEmptyBuilderChanged: (val) =>
          setState(() => _customEmptyBuilder = val),
    ),
    DropdownMotionFeedbackControls(
      haptic: _haptic,
      onHapticChanged: (val) => setState(() => _haptic = val),
      openStiffness: _openStiffness,
      onOpenStiffnessChanged: (val) => setState(() => _openStiffness = val),
      openDamping: _openDamping,
      onOpenDampingChanged: (val) => setState(() => _openDamping = val),
      closeStiffness: _closeStiffness,
      onCloseStiffnessChanged: (val) => setState(() => _closeStiffness = val),
      closeDamping: _closeDamping,
      onCloseDampingChanged: (val) => setState(() => _closeDamping = val),
      closeOnBackButton: _closeOnBackButton,
      onCloseOnBackButtonChanged: (val) =>
          setState(() => _closeOnBackButton = val),
      useSplash: _useSplash,
      onUseSplashChanged: (val) => setState(() => _useSplash = val),
      validationEnabled: _validationEnabled,
      onValidationEnabledChanged: (val) =>
          setState(() => _validationEnabled = val),
      pressedScale: _pressedScale,
      onPressedScaleChanged: (val) => setState(() => _pressedScale = val),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final fieldStyle = M3EDropdownFieldStyle(
      hintText: _singleSelect ? 'Select a fruit' : 'Select fruits',
      borderRadius: _independentRadii
          ? BorderRadius.circular(_fieldRadius)
          : null,
      selectedBorderRadius: _independentRadii ? _selectedFieldRadius : null,
      showClearIcon: _showClearIcon,
      backgroundColor: _useFieldColor ? _fieldColor : null,
      padding: EdgeInsets.all(_fieldPadding),
      pressedScale: _pressedScale,
    );
    final dropdownStyle = M3EDropdownStyle(
      containerRadius: _independentRadii ? _panelRadius : null,
      elevation: _panelElevation,
      maxHeight: _panelMaxHeight,
      marginTop: _panelMarginTop,
      expandDirection: ExpandDirection.values[_expandDirection.index],
      backgroundColor: _usePanelColor ? _panelColor : null,
      contentPadding: EdgeInsets.all(_panelPadding),
      header: _showHeader ? const Text('Fruit selection') : null,
      footer: _showFooter ? const Text('Tap an item to select it') : null,
    );
    final searchStyle = M3ESearchStyle(
      hintText: 'Search fruits…',
      filled: _searchFilled,
      autofocus: _searchAutofocus,
      showClearIcon: _searchClearIcon,
      searchDebounceMs: _searchDebounceMs,
      contentPadding: EdgeInsets.all(_searchPadding),
    );
    final chipStyle = M3EChipStyle(
      borderRadius: BorderRadius.circular(_chipRadius),
      spacing: _chipSpacing,
      runSpacing: _chipRunSpacing,
      wrap: _wrapChips,
      maxDisplayCount: _maxDisplayCount,
      padding: EdgeInsets.all(_chipPadding),
      backgroundColor: _useChipColor ? _chipColor : null,
      openMotion: _openMotion,
      closeMotion: _closeMotion,
      pressedScale: _pressedScale,
    );
    final itemStyle = M3EDropdownItemStyle(
      outerRadius: _itemOuterRadius,
      innerRadius: _itemInnerRadius,
      itemGap: _itemGap,
      itemPadding: EdgeInsets.all(_itemPadding),
      selectedBackgroundColor: _useItemColor ? _itemColor : null,
      selectedIcon: _showSelectedIcon ? const Icon(Icons.check_rounded) : null,
      pressedScale: _pressedScale,
    );
    M3EDropdownItemBuilder<String>? itemBuilder;
    if (_customItemBuilder) {
      itemBuilder = (item, selected, onTap) => ListTile(
        title: Text(item.label),
        trailing: selected ? const Icon(Icons.check_rounded) : null,
        onTap: onTap,
      );
    }
    Widget Function(M3EDropdownItem<String> item)? selectedItemBuilder;
    if (_customSelectedBuilder) {
      selectedItemBuilder = (item) => Text(item.label);
    }
    WidgetBuilder? emptyBuilder;
    if (_customEmptyBuilder) {
      emptyBuilder = (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Nothing matched'),
      );
    }
    final itemSeparator = _showItemSeparator
        ? (const Divider(height: 1) as Widget)
        : null;

    return PlaygroundSplitLayout(
      preview: DropdownPreviewArea(
        formKey: _formKey,
        dataMode: _dataMode,
        items: _items,
        loadItems: _loadItems,
        singleSelect: _singleSelect,
        searchEnabled: _searchEnabled,
        showChipAnimation: _showChipAnimation,
        maxSelections: _maxSelections,
        enabled: _enabled,
        containerRadius: _containerRadius,
        fieldStyle: fieldStyle,
        dropdownStyle: dropdownStyle,
        chipStyle: chipStyle,
        searchStyle: searchStyle,
        itemStyle: itemStyle,
        itemBuilder: itemBuilder,
        selectedItemBuilder: selectedItemBuilder,
        emptyBuilder: emptyBuilder,
        itemSeparator: itemSeparator,
        validationEnabled: _validationEnabled,
        closeOnBackButton: _closeOnBackButton,
        openMotion: _openMotion,
        closeMotion: _closeMotion,
        useSplash: _useSplash,
        haptic: _haptic,
        controller: _controller,
        onSelectionChanged: _onSelectionChanged,
        onSearchChanged: _onSearchChanged,
      ),
      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(),
    );
  }
}
