// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../data/mock_data.dart';
import '../../shared/shared.dart';
import 'controls/segmented_list_color_controls.dart';
import 'controls/segmented_list_geometry_controls.dart';
import 'controls/segmented_list_layout_controls.dart';
import 'controls/segmented_list_morphing_controls.dart';
import 'controls/segmented_list_reorderable_controls.dart';
import 'controls/segmented_list_selection_controls.dart';
import 'models/segmented_list_models.dart';
import 'preview/segmented_list_preview_area.dart';
import 'snippets/segmented_list_code_snippets.dart';

export 'models/segmented_list_models.dart';

class SegmentedListPlaygroundView extends StatefulWidget {
  const SegmentedListPlaygroundView({super.key});

  @override
  State<SegmentedListPlaygroundView> createState() =>
      _SegmentedListPlaygroundViewState();
}

class _SegmentedListPlaygroundViewState
    extends State<SegmentedListPlaygroundView> {
  // ── Layout Architecture ──
  SegmentedListType _listType = SegmentedListType.reorderable;
  SegmentedContainerMode _containerMode = SegmentedContainerMode.listView;
  SegmentedTileLayout _tileLayout = SegmentedTileLayout.email;
  RowFlexPreset _rowFlexPreset = RowFlexPreset.none;
  bool _useDecoration = true;
  bool _enableLazyLoading = true;
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  late final ScrollController _listScrollController;
  late final ScrollController _sliverScrollController;

  // ── Geometry & Spacing ──
  double _outerRadius = 24.0;
  double _innerRadius = 4.0;
  double _gap = 2.0;
  double _padding = 12.0;
  double _marginH = 12.0;
  double _marginV = 4.0;
  double _elevation = 0.0;

  // ── Interactive Morphing ──
  double _pressedRadius = 8.0;
  double _pressedScale = 0.98;
  double _hoveredRadius = 16.0;
  M3EExampleMotionPreset _restingMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _restingStiffness = 800;
  double _restingDamping = 0.6;

  M3EExampleMotionPreset _expandMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _expandStiffness = 800;
  double _expandDamping = 0.6;

  M3EExampleMotionPreset _collapseMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _collapseStiffness = 800;
  double _collapseDamping = 0.6;

  M3EExampleMotionPreset _pressedMotionPreset =
      M3EExampleMotionPreset.expressiveSpatialFast;
  double _pressedStiffness = 800;
  double _pressedDamping = 0.6;

  // ── Selection ──
  M3ESelectionMode _selectionMode = M3ESelectionMode.multiple;
  M3ESelectionTrigger _selectionTrigger = M3ESelectionTrigger.tap;
  Set<int> _selectedIndices = {0, 2};
  bool _showSelectionCheckmark = true;
  Alignment _checkmarkAlignment = Alignment.centerRight;
  double _selectedRadius = 28.0;
  double _selectedElevation = 0.0;
  bool _useCustomSelectedColor = false;
  Color _selectedColor = Colors.teal;
  bool _useSelectedBorder = false;
  double _selectedBorderWidth = 2.0;
  Color _selectedBorderColor = Colors.teal;

  // ── Reorderable ──
  bool _buildDefaultDragHandles = true;
  double _dragElevation = 8.0;
  double _dragScale = 1.0;
  double _dragRadius = 24.0;
  bool _useCustomDragColor = false;
  Color _dragColor = Colors.amber;
  bool _useCustomPlaceholderColor = false;
  Color _placeholderColor = Colors.deepPurple;
  bool _usePlaceholderBorder = false;
  double _placeholderBorderWidth = 1.5;
  bool _usePinnedHeaderFooter = false;

  // ── Data & Items ──

  late List<EmailItem> _items;
  bool _showEmpty = false;

  // ── Styling, Ink & Feedback Overrides ──
  bool _useCustomColor = false;
  Color _customColor = Colors.teal.shade50;
  bool _useBorder = false;
  double _borderWidth = 1.0;
  bool _useSplashColor = false;
  Color _splashColor = Colors.teal;
  bool _useHighlightColor = false;
  Color _highlightColor = Colors.teal;
  bool _enableFeedback = true;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;
  bool _useSemanticLabels = false;

  // ── Expandable Trailing Pill ──
  bool _showTrailingPill = true;
  bool _showTrailingPillOnlyWhenExpanded = true;
  bool _useCustomTrailingPillColor = false;
  Color _trailingPillColor = Colors.deepPurple;
  double _trailingPillWidth = 32.0;
  double _trailingPillHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _items = List.of(allItems.take(12));
    _listScrollController = ScrollController()..addListener(_onListScroll);
    _sliverScrollController = ScrollController()..addListener(_onSliverScroll);
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _sliverScrollController.dispose();
    super.dispose();
  }

  void _onListScroll() {
    if (!_enableLazyLoading ||
        _containerMode != SegmentedContainerMode.listView ||
        _isLoadingMore) {
      return;
    }
    if (!_listScrollController.hasClients) return;
    final pos = _listScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        _items.length < allItems.length) {
      _loadMore();
    }
  }

  void _onSliverScroll() {
    if (!_enableLazyLoading ||
        _containerMode != SegmentedContainerMode.sliver ||
        _isLoadingMore) {
      return;
    }
    if (!_sliverScrollController.hasClients) return;
    final pos = _sliverScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200 &&
        _items.length < allItems.length) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _items.length >= allItems.length) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      final nextItems = allItems.skip(_items.length).take(_pageSize);
      _items.addAll(nextItems);
      _isLoadingMore = false;
    });
  }

  void _resetItems() {
    setState(() {
      _items = List.of(
        allItems.take(
          _containerMode == SegmentedContainerMode.row
              ? 2
              : _containerMode == SegmentedContainerMode.column
              ? 5
              : _pageSize,
        ),
      );
      if (_containerMode == SegmentedContainerMode.row) {
        _selectionMode = M3ESelectionMode.none;
        _selectedIndices = {};
      } else {
        _selectedIndices = {0, 2};
      }
      _rowFlexPreset = RowFlexPreset.none;
      _showEmpty = false;
      _isLoadingMore = false;
    });
  }

  void _addItem() {
    if (_containerMode == SegmentedContainerMode.row && _items.length >= 3) {
      showSnack(
        context,
        'Material 3 Expressive companion rows support up to 3 items.',
      );
      return;
    }
    if (_items.length >= allItems.length) {
      showSnack(context, 'All mock emails are already in the list!');
      return;
    }
    setState(() {
      if (_containerMode == SegmentedContainerMode.row) {
        _items.add(allItems[_items.length]);
      } else {
        _items.insert(0, allItems[_items.length]);
        _selectedIndices = _selectedIndices.map((i) => i + 1).toSet();
      }
      _showEmpty = false;
    });
  }

  void _removeItem() {
    if (_containerMode == SegmentedContainerMode.row && _items.length <= 2) {
      showSnack(
        context,
        'Material 3 Expressive companion rows require at least 2 items.',
      );
      return;
    }
    if (_items.isEmpty) return;
    setState(() {
      if (_containerMode == SegmentedContainerMode.row) {
        final lastIdx = _items.length - 1;
        _items.removeAt(lastIdx);
        _selectedIndices = _selectedIndices.where((i) => i != lastIdx).toSet();
        if (!RowFlexPreset.presetsForCount(
          _items.length,
        ).contains(_rowFlexPreset)) {
          _rowFlexPreset = RowFlexPreset.none;
        }
      } else {
        _items.removeAt(0);
        _selectedIndices = _selectedIndices
            .where((i) => i != 0)
            .map((i) => i - 1)
            .toSet();
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedIndices = List.generate(_items.length, (i) => i).toSet();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIndices = {};
    });
  }

  void _invertSelection() {
    setState(() {
      final inverted = <int>{};
      for (int i = 0; i < _items.length; i++) {
        if (!_selectedIndices.contains(i)) {
          inverted.add(i);
        }
      }
      _selectedIndices = inverted;
    });
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);

      // Re-map selected indices so selection stays with the moved items
      final newSelected = <int>{};
      for (final selected in _selectedIndices) {
        if (selected == oldIndex) {
          newSelected.add(newIndex);
        } else if (oldIndex < newIndex) {
          if (selected > oldIndex && selected <= newIndex) {
            newSelected.add(selected - 1);
          } else {
            newSelected.add(selected);
          }
        } else {
          if (selected >= newIndex && selected < oldIndex) {
            newSelected.add(selected + 1);
          } else {
            newSelected.add(selected);
          }
        }
      }
      _selectedIndices = newSelected;
    });
  }

  String _generateCodeSnippet() {
    return SegmentedListCodeSnippets.generate(
      useDecoration: _useDecoration,
      listType: _listType,
      containerMode: _containerMode,
      showEmpty: _showEmpty,
      itemCount: _items.length,
      buildDefaultDragHandles: _buildDefaultDragHandles,
      usePinnedHeaderFooter: _usePinnedHeaderFooter,
      selectionMode: _selectionMode,
      selectionTrigger: _selectionTrigger,
      showSelectionCheckmark: _showSelectionCheckmark,
      checkmarkAlignment: _checkmarkAlignment,
      useSemanticLabels: _useSemanticLabels,
      outerRadius: _outerRadius,
      innerRadius: _innerRadius,
      pressedRadius: _pressedRadius,
      pressedScale: _pressedScale,
      hoveredRadius: _hoveredRadius,
      selectedRadius: _selectedRadius,
      useSelectedBorder: _useSelectedBorder,
      selectedBorderWidth: _selectedBorderWidth,
      dragRadius: _dragRadius,
      dragElevation: _dragElevation,
      dragScale: _dragScale,
      gap: _gap,
      padding: _padding,
      marginH: _marginH,
      marginV: _marginV,
      elevation: _elevation,
      haptic: _haptic,
      showTrailingPill: _showTrailingPill,
      showTrailingPillOnlyWhenExpanded: _showTrailingPillOnlyWhenExpanded,
      trailingPillColor: _useCustomTrailingPillColor
          ? _trailingPillColor
          : null,
      trailingPillSize: Size(_trailingPillWidth, _trailingPillHeight),
      expandMotionPreset: _expandMotionPreset,
      collapseMotionPreset: _collapseMotionPreset,
      expandStiffness: _expandStiffness,
      expandDamping: _expandDamping,
      collapseStiffness: _collapseStiffness,
      collapseDamping: _collapseDamping,
      flexes: _rowFlexPreset.computeFlexes(_items.length),
    );
  }

  List<Widget> _buildControls(BuildContext context) {
    return [
      SegmentedListLayoutControls(
        listType: _listType,
        onListTypeChanged: (type) {
          setState(() {
            _listType = type;
            if (_listType != SegmentedListType.normal &&
                _containerMode == SegmentedContainerMode.row) {
              _containerMode = SegmentedContainerMode.column;
            }
            _resetItems();
          });
        },
        containerMode: _containerMode,
        onContainerModeChanged: (mode) {
          setState(() {
            _containerMode = mode;
            if (_containerMode == SegmentedContainerMode.row) {
              _selectionMode = M3ESelectionMode.none;
              _selectedIndices = {};
            } else if (_selectionMode == M3ESelectionMode.none) {
              _selectionMode = M3ESelectionMode.multiple;
              _selectedIndices = {0, 2};
            }
            _resetItems();
          });
        },
        rowFlexPreset: _rowFlexPreset,
        onRowFlexPresetChanged: (preset) =>
            setState(() => _rowFlexPreset = preset),
        tileLayout: _tileLayout,
        onTileLayoutChanged: (layout) => setState(() => _tileLayout = layout),
        useDecoration: _useDecoration,
        onUseDecorationChanged: (val) => setState(() => _useDecoration = val),
        enableLazyLoading: _enableLazyLoading,
        onEnableLazyLoadingChanged: (val) =>
            setState(() => _enableLazyLoading = val),
        itemCount: _items.length,
        showEmpty: _showEmpty,
        onShowEmptyChanged: (val) => setState(() => _showEmpty = val),
        onAddItem: _addItem,
        onRemoveItem: _removeItem,
        onResetItems: _resetItems,
        showTrailingPill: _showTrailingPill,
        onShowTrailingPillChanged: (val) =>
            setState(() => _showTrailingPill = val),
        showTrailingPillOnlyWhenExpanded: _showTrailingPillOnlyWhenExpanded,
        onShowTrailingPillOnlyWhenExpandedChanged: (val) =>
            setState(() => _showTrailingPillOnlyWhenExpanded = val),
        useCustomTrailingPillColor: _useCustomTrailingPillColor,
        onUseCustomTrailingPillColorChanged: (val) =>
            setState(() => _useCustomTrailingPillColor = val),
        trailingPillColor: _trailingPillColor,
        onTrailingPillColorChanged: (color) =>
            setState(() => _trailingPillColor = color),
        trailingPillWidth: _trailingPillWidth,
        onTrailingPillWidthChanged: (val) =>
            setState(() => _trailingPillWidth = val),
        trailingPillHeight: _trailingPillHeight,
        onTrailingPillHeightChanged: (val) =>
            setState(() => _trailingPillHeight = val),
      ),

      SegmentedListSelectionControls(
        selectionMode: _selectionMode,
        onSelectionModeChanged: (mode) => setState(() => _selectionMode = mode),
        selectionTrigger: _selectionTrigger,
        onSelectionTriggerChanged: (trigger) =>
            setState(() => _selectionTrigger = trigger),
        showSelectionCheckmark: _showSelectionCheckmark,
        onShowSelectionCheckmarkChanged: (val) =>
            setState(() => _showSelectionCheckmark = val),
        checkmarkAlignment: _checkmarkAlignment,
        onCheckmarkAlignmentChanged: (alignment) =>
            setState(() => _checkmarkAlignment = alignment),
        selectedRadius: _selectedRadius,
        onSelectedRadiusChanged: (val) => setState(() => _selectedRadius = val),
        selectedElevation: _selectedElevation,
        onSelectedElevationChanged: (val) =>
            setState(() => _selectedElevation = val),
        useCustomSelectedColor: _useCustomSelectedColor,
        onUseCustomSelectedColorChanged: (val) =>
            setState(() => _useCustomSelectedColor = val),
        selectedColor: _selectedColor,
        onSelectedColorChanged: (color) =>
            setState(() => _selectedColor = color),
        useSelectedBorder: _useSelectedBorder,
        onUseSelectedBorderChanged: (val) =>
            setState(() => _useSelectedBorder = val),
        selectedBorderWidth: _selectedBorderWidth,
        onSelectedBorderWidthChanged: (val) =>
            setState(() => _selectedBorderWidth = val),
        selectedBorderColor: _selectedBorderColor,
        onSelectedBorderColorChanged: (color) =>
            setState(() => _selectedBorderColor = color),
        selectedCount: _selectedIndices.length,
        onSelectAll: _selectAll,
        onInvertSelection: _invertSelection,
        onClearSelection: _clearSelection,
      ),
      if (_listType == SegmentedListType.reorderable)
        SegmentedListReorderableControls(
          buildDefaultDragHandles: _buildDefaultDragHandles,
          onBuildDefaultDragHandlesChanged: (val) =>
              setState(() => _buildDefaultDragHandles = val),
          dragElevation: _dragElevation,
          onDragElevationChanged: (val) => setState(() => _dragElevation = val),
          dragScale: _dragScale,
          onDragScaleChanged: (val) => setState(() => _dragScale = val),
          dragRadius: _dragRadius,
          onDragRadiusChanged: (val) => setState(() => _dragRadius = val),
          useCustomDragColor: _useCustomDragColor,
          onUseCustomDragColorChanged: (val) =>
              setState(() => _useCustomDragColor = val),
          dragColor: _dragColor,
          onDragColorChanged: (color) => setState(() => _dragColor = color),
          useCustomPlaceholderColor: _useCustomPlaceholderColor,
          onUseCustomPlaceholderColorChanged: (val) =>
              setState(() => _useCustomPlaceholderColor = val),
          placeholderColor: _placeholderColor,
          onPlaceholderColorChanged: (color) =>
              setState(() => _placeholderColor = color),
          usePlaceholderBorder: _usePlaceholderBorder,
          onUsePlaceholderBorderChanged: (val) =>
              setState(() => _usePlaceholderBorder = val),
          placeholderBorderWidth: _placeholderBorderWidth,
          onPlaceholderBorderWidthChanged: (val) =>
              setState(() => _placeholderBorderWidth = val),
          usePinnedHeaderFooter: _usePinnedHeaderFooter,
          onUsePinnedHeaderFooterChanged: (val) =>
              setState(() => _usePinnedHeaderFooter = val),
        ),

      SegmentedListGeometryControls(
        outerRadius: _outerRadius,
        onOuterRadiusChanged: (val) => setState(() => _outerRadius = val),
        innerRadius: _innerRadius,
        onInnerRadiusChanged: (val) => setState(() => _innerRadius = val),
        gap: _gap,
        onGapChanged: (val) => setState(() => _gap = val),
        padding: _padding,
        onPaddingChanged: (val) => setState(() => _padding = val),
        marginH: _marginH,
        onMarginHChanged: (val) => setState(() => _marginH = val),
        marginV: _marginV,
        onMarginVChanged: (val) => setState(() => _marginV = val),
        elevation: _elevation,
        onElevationChanged: (val) => setState(() => _elevation = val),
      ),
      SegmentedListMorphingControls(
        isExpandable: _listType == SegmentedListType.expandable,
        pressedRadius: _pressedRadius,
        onPressedRadiusChanged: (val) => setState(() => _pressedRadius = val),
        pressedScale: _pressedScale,
        onPressedScaleChanged: (val) => setState(() => _pressedScale = val),
        hoveredRadius: _hoveredRadius,
        onHoveredRadiusChanged: (val) => setState(() => _hoveredRadius = val),
        restingMotionPreset: _restingMotionPreset,
        onRestingMotionPresetChanged: (preset) =>
            setState(() => _restingMotionPreset = preset),
        restingStiffness: _restingStiffness,
        onRestingStiffnessChanged: (val) =>
            setState(() => _restingStiffness = val),
        restingDamping: _restingDamping,
        onRestingDampingChanged: (val) => setState(() => _restingDamping = val),
        expandMotionPreset: _expandMotionPreset,
        onExpandMotionPresetChanged: (preset) =>
            setState(() => _expandMotionPreset = preset),
        expandStiffness: _expandStiffness,
        onExpandStiffnessChanged: (val) =>
            setState(() => _expandStiffness = val),
        expandDamping: _expandDamping,
        onExpandDampingChanged: (val) => setState(() => _expandDamping = val),
        collapseMotionPreset: _collapseMotionPreset,
        onCollapseMotionPresetChanged: (preset) =>
            setState(() => _collapseMotionPreset = preset),
        collapseStiffness: _collapseStiffness,
        onCollapseStiffnessChanged: (val) =>
            setState(() => _collapseStiffness = val),
        collapseDamping: _collapseDamping,
        onCollapseDampingChanged: (val) =>
            setState(() => _collapseDamping = val),
        pressedMotionPreset: _pressedMotionPreset,
        onPressedMotionPresetChanged: (preset) =>
            setState(() => _pressedMotionPreset = preset),
        pressedStiffness: _pressedStiffness,
        onPressedStiffnessChanged: (val) =>
            setState(() => _pressedStiffness = val),
        pressedDamping: _pressedDamping,
        onPressedDampingChanged: (val) => setState(() => _pressedDamping = val),
      ),

      SegmentedListColorControls(
        useCustomColor: _useCustomColor,
        onUseCustomColorChanged: (val) => setState(() => _useCustomColor = val),
        customColor: _customColor,
        onCustomColorChanged: (color) => setState(() => _customColor = color),
        useBorder: _useBorder,
        onUseBorderChanged: (val) => setState(() => _useBorder = val),
        borderWidth: _borderWidth,
        onBorderWidthChanged: (val) => setState(() => _borderWidth = val),
        useSplashColor: _useSplashColor,
        onUseSplashColorChanged: (val) => setState(() => _useSplashColor = val),
        splashColor: _splashColor,
        onSplashColorChanged: (color) => setState(() => _splashColor = color),
        useHighlightColor: _useHighlightColor,
        onUseHighlightColorChanged: (val) =>
            setState(() => _useHighlightColor = val),
        highlightColor: _highlightColor,
        onHighlightColorChanged: (color) =>
            setState(() => _highlightColor = color),
        enableFeedback: _enableFeedback,
        onEnableFeedbackChanged: (val) => setState(() => _enableFeedback = val),
        haptic: _haptic,
        onHapticChanged: (val) => setState(() => _haptic = val),
        useSemanticLabels: _useSemanticLabels,
        onUseSemanticLabelsChanged: (val) =>
            setState(() => _useSemanticLabels = val),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundSplitLayout(
      preview: SegmentedListPreviewArea(
        listType: _listType,
        containerMode: _containerMode,
        tileLayout: _tileLayout,
        flexes: _rowFlexPreset.computeFlexes(_items.length),
        items: _items,
        showEmpty: _showEmpty,
        isLoadingMore: _isLoadingMore,
        enableLazyLoading: _enableLazyLoading,
        totalAvailableItems: allItems.length,
        listScrollController: _listScrollController,
        sliverScrollController: _sliverScrollController,
        useDecoration: _useDecoration,
        selectionMode: _selectionMode,
        selectionTrigger: _selectionTrigger,
        selectedIndices: _selectedIndices,
        onSelectedIndicesChanged: (set) =>
            setState(() => _selectedIndices = set),
        showSelectionCheckmark: _showSelectionCheckmark,
        checkmarkAlignment: _checkmarkAlignment,
        useSemanticLabels: _useSemanticLabels,
        outerRadius: _outerRadius,
        innerRadius: _innerRadius,
        pressedRadius: _pressedRadius,
        pressedScale: _pressedScale,
        hoveredRadius: _hoveredRadius,
        selectedRadius: _selectedRadius,
        dragRadius: _dragRadius,
        gap: _gap,
        padding: _padding,
        marginH: _marginH,
        marginV: _marginV,
        elevation: _elevation,
        selectedElevation: _selectedElevation,
        dragElevation: _dragElevation,
        dragScale: _dragScale,
        useCustomColor: _useCustomColor,
        customColor: _customColor,
        useCustomSelectedColor: _useCustomSelectedColor,
        selectedColor: _selectedColor,
        useCustomDragColor: _useCustomDragColor,
        dragColor: _dragColor,
        useCustomPlaceholderColor: _useCustomPlaceholderColor,
        placeholderColor: _placeholderColor,
        usePlaceholderBorder: _usePlaceholderBorder,
        placeholderBorderWidth: _placeholderBorderWidth,
        useBorder: _useBorder,
        borderWidth: _borderWidth,
        useSelectedBorder: _useSelectedBorder,
        selectedBorderWidth: _selectedBorderWidth,
        selectedBorderColor: _selectedBorderColor,
        useSplashColor: _useSplashColor,
        splashColor: _splashColor,
        useHighlightColor: _useHighlightColor,
        highlightColor: _highlightColor,
        enableFeedback: _enableFeedback,
        haptic: _haptic,
        motion: _restingMotionPreset.resolve(
          stiffness: _restingStiffness,
          damping: _restingDamping,
        ),
        pressedMotion: _pressedMotionPreset.resolve(
          stiffness: _pressedStiffness,
          damping: _pressedDamping,
        ),
        expandMotion: _expandMotionPreset.resolve(
          stiffness: _expandStiffness,
          damping: _expandDamping,
        ),
        collapseMotion: _collapseMotionPreset.resolve(
          stiffness: _collapseStiffness,
          damping: _collapseDamping,
        ),
        buildDefaultDragHandles: _buildDefaultDragHandles,
        usePinnedHeaderFooter: _usePinnedHeaderFooter,
        showTrailingPill: _showTrailingPill,
        showTrailingPillOnlyWhenExpanded: _showTrailingPillOnlyWhenExpanded,
        trailingPillColor: _useCustomTrailingPillColor
            ? _trailingPillColor
            : null,
        trailingPillSize: Size(_trailingPillWidth, _trailingPillHeight),
        onReorder: _handleReorder,
        onResetItems: _resetItems,
      ),

      codeSnippet: CodeSnippetCard(code: _generateCodeSnippet()),
      controls: _buildControls(context),
    );
  }
}
