// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../data/mock_data.dart';
import '../models/segmented_list_models.dart';
import 'segmented_list_tiles.dart';

class SegmentedListPreviewArea extends StatelessWidget {
  const SegmentedListPreviewArea({
    super.key,
    required this.listType,
    required this.containerMode,
    required this.tileLayout,
    required this.items,
    required this.showEmpty,
    required this.isLoadingMore,
    required this.enableLazyLoading,
    required this.totalAvailableItems,
    required this.listScrollController,
    required this.sliverScrollController,
    required this.useDecoration,
    required this.selectionMode,
    required this.selectionTrigger,
    required this.selectedIndices,
    required this.onSelectedIndicesChanged,
    required this.showSelectionCheckmark,
    required this.checkmarkAlignment,
    required this.useSemanticLabels,
    required this.outerRadius,
    required this.innerRadius,
    required this.pressedRadius,
    required this.pressedScale,
    required this.hoveredRadius,
    required this.selectedRadius,
    required this.dragRadius,
    required this.gap,
    required this.padding,
    required this.marginH,
    required this.marginV,
    required this.elevation,
    required this.selectedElevation,
    required this.dragElevation,
    required this.dragScale,
    required this.useCustomColor,
    required this.customColor,
    required this.useCustomSelectedColor,
    required this.selectedColor,
    required this.useCustomDragColor,
    required this.dragColor,
    this.useCustomPlaceholderColor = false,
    this.placeholderColor = Colors.deepPurple,
    this.usePlaceholderBorder = false,
    this.placeholderBorderWidth = 1.5,
    required this.useBorder,
    required this.borderWidth,
    required this.useSelectedBorder,
    required this.selectedBorderWidth,
    required this.selectedBorderColor,
    required this.useSplashColor,
    required this.splashColor,
    required this.useHighlightColor,
    required this.highlightColor,
    required this.enableFeedback,
    required this.haptic,
    required this.motion,
    required this.pressedMotion,
    this.expandMotion = M3EMotion.expressiveSpatialFast,
    this.collapseMotion = M3EMotion.expressiveSpatialFast,
    required this.buildDefaultDragHandles,
    required this.usePinnedHeaderFooter,
    required this.onReorder,
    required this.onResetItems,
    this.showTrailingPill = true,
    this.showTrailingPillOnlyWhenExpanded = true,
    this.trailingPillColor,
    this.trailingPillSize = const Size(32.0, 48.0),
    this.flexes,
  });

  final SegmentedListType listType;
  final SegmentedContainerMode containerMode;
  final SegmentedTileLayout tileLayout;
  final List<EmailItem> items;
  final bool showEmpty;
  final bool isLoadingMore;
  final bool enableLazyLoading;
  final int totalAvailableItems;
  final ScrollController listScrollController;
  final ScrollController sliverScrollController;
  final bool useDecoration;
  final M3ESelectionMode selectionMode;
  final M3ESelectionTrigger selectionTrigger;
  final Set<int> selectedIndices;
  final ValueChanged<Set<int>> onSelectedIndicesChanged;
  final bool showSelectionCheckmark;
  final Alignment checkmarkAlignment;
  final bool useSemanticLabels;
  final double outerRadius;
  final double innerRadius;
  final double pressedRadius;
  final double pressedScale;
  final double hoveredRadius;
  final double selectedRadius;
  final double dragRadius;
  final double gap;
  final double padding;
  final double marginH;
  final double marginV;
  final double elevation;
  final double selectedElevation;
  final double dragElevation;
  final double dragScale;
  final bool useCustomColor;
  final Color customColor;
  final bool useCustomSelectedColor;
  final Color selectedColor;
  final bool useCustomDragColor;
  final Color dragColor;
  final bool useCustomPlaceholderColor;
  final Color placeholderColor;
  final bool usePlaceholderBorder;
  final double placeholderBorderWidth;
  final bool useBorder;
  final double borderWidth;
  final bool useSelectedBorder;
  final double selectedBorderWidth;
  final Color selectedBorderColor;
  final bool useSplashColor;
  final Color splashColor;
  final bool useHighlightColor;
  final Color highlightColor;
  final bool enableFeedback;
  final M3EHapticFeedback haptic;
  final M3EMotion motion;
  final M3EMotion pressedMotion;
  final M3EMotion expandMotion;
  final M3EMotion collapseMotion;
  final bool buildDefaultDragHandles;

  final bool usePinnedHeaderFooter;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onResetItems;
  final bool showTrailingPill;
  final bool showTrailingPillOnlyWhenExpanded;
  final Color? trailingPillColor;
  final Size trailingPillSize;
  final List<int>? flexes;

  M3ESegmentedListDecoration _buildDecoration(ColorScheme cs) {
    return M3ESegmentedListDecoration(
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      pressedRadius: pressedRadius,
      pressedScale: pressedScale,
      hoveredRadius: hoveredRadius,
      selectedRadius: selectedRadius,
      dragRadius: dragRadius,
      gap: gap,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.symmetric(horizontal: marginH, vertical: marginV),
      elevation: elevation,
      selectedElevation: selectedElevation,
      dragElevation: dragElevation,
      dragScale: dragScale,
      color: useCustomColor ? customColor : null,
      selectedColor: useCustomSelectedColor ? selectedColor : null,
      dragColor: useCustomDragColor ? dragColor : null,
      dragPlaceholderColor: useCustomPlaceholderColor ? placeholderColor : null,
      dragPlaceholderBorder: usePlaceholderBorder
          ? BorderSide(color: cs.outlineVariant, width: placeholderBorderWidth)
          : null,
      border: useBorder
          ? BorderSide(color: cs.outlineVariant, width: borderWidth)
          : null,
      selectedBorder: useSelectedBorder
          ? BorderSide(color: selectedBorderColor, width: selectedBorderWidth)
          : null,
      splashColor: useSplashColor ? splashColor.withValues(alpha: 0.16) : null,
      highlightColor: useHighlightColor
          ? highlightColor.withValues(alpha: 0.12)
          : null,
      enableFeedback: enableFeedback,
      haptic: haptic,
      showSelectionCheckmark: showSelectionCheckmark,
      selectionCheckmarkAlignment: checkmarkAlignment,
      motion: motion,
      pressedMotion: pressedMotion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (showEmpty || items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_rounded, size: 56, color: cs.outline),
              const SizedBox(height: 12),
              Text(
                'List is empty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              M3EButton.icon(
                style: M3EButtonStyle.tonal,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reload Mock Data'),
                onPressed: onResetItems,
              ),
            ],
          ),
        ),
      );
    }

    final decoration = useDecoration ? _buildDecoration(cs) : null;
    final paddingInsets = EdgeInsets.all(padding);
    final marginInsets = EdgeInsets.symmetric(
      horizontal: marginH,
      vertical: marginV,
    );

    final semanticLabelBuilder = useSemanticLabels
        ? (int i) =>
              'Item ${i + 1} of ${items.length}: ${items[i].sender}, ${items[i].subject}'
        : null;

    // ── Expandable Mode ──
    if (listType == SegmentedListType.expandable) {
      return _ExpandableSegmentedPreview(
        containerMode: containerMode,
        outerRadius: outerRadius,
        innerRadius: innerRadius,
        pressedRadius: pressedRadius,
        pressedScale: pressedScale,
        hoveredRadius: hoveredRadius,
        gap: gap,
        padding: paddingInsets,
        margin: marginInsets,
        motion: motion,
        pressedMotion: pressedMotion,
        expandMotion: expandMotion,
        collapseMotion: collapseMotion,
        selectionMode: selectionMode,
        selectionTrigger: selectionTrigger,
        showSelectionCheckmark: showSelectionCheckmark,
        checkmarkAlignment: checkmarkAlignment,
        selectedRadius: selectedRadius,
        selectedColor: useCustomSelectedColor ? selectedColor : null,
        selectedBorder: useSelectedBorder
            ? BorderSide(color: selectedBorderColor, width: selectedBorderWidth)
            : null,
        elevation: elevation,
        selectedElevation: selectedElevation,
        haptic: haptic,
        showTrailingPill: showTrailingPill,
        showTrailingPillOnlyWhenExpanded: showTrailingPillOnlyWhenExpanded,
        trailingPillColor: trailingPillColor,
        trailingPillSize: trailingPillSize,
      );
    }

    // ── Reorderable Mode ──
    if (listType == SegmentedListType.reorderable) {
      Widget? pinnedHeader;
      Widget? pinnedFooter;
      if (usePinnedHeaderFooter) {
        pinnedHeader = Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.push_pin_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Pinned Header (Fixed / Non-reorderable)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ],
          ),
        );

        pinnedFooter = Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: cs.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.secondary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 16, color: cs.secondary),
              const SizedBox(width: 8),
              Text(
                'Pinned Footer (Fixed / Non-reorderable)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: cs.onSecondaryContainer,
                ),
              ),
            ],
          ),
        );
      }

      if (containerMode == SegmentedContainerMode.column) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: M3EReorderableSegmentedList(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            keyBuilder: (index) => ValueKey(
              'seg_reorder_col_${items[index].id}_${tileLayout.name}',
            ),
            header: pinnedHeader,
            footer: pinnedFooter,
            buildDefaultDragHandles: buildDefaultDragHandles,
            selectionMode: selectionMode,
            selectionTrigger: selectionTrigger,
            selectedIndices: selectedIndices,
            showSelectionCheckmark: showSelectionCheckmark,
            selectionCheckmarkAlignment: checkmarkAlignment,
            onSelectionChanged: onSelectedIndicesChanged,
            onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
            onReorder: onReorder,
            semanticLabelBuilder: semanticLabelBuilder,
            decoration: decoration,
            dragPlaceholderColor: useCustomPlaceholderColor
                ? placeholderColor
                : null,
            dragPlaceholderBorder: usePlaceholderBorder
                ? BorderSide(
                    color: cs.outlineVariant,
                    width: placeholderBorderWidth,
                  )
                : null,
            outerRadius: outerRadius,
            innerRadius: innerRadius,
            gap: gap,
            padding: paddingInsets,
            margin: marginInsets,
            elevation: elevation,
            dragScale: dragScale,
            dragElevation: dragElevation,
            dragColor: useCustomDragColor ? dragColor : null,
            dragRadius: dragRadius,
            pressedRadius: pressedRadius,
            pressedScale: pressedScale,
            hoveredRadius: hoveredRadius,
            children: List.generate(items.length, (index) {
              return buildSegmentedListItemTile(
                context: context,
                item: items[index],
                tileLayout: tileLayout,
              );
            }),
          ),
        );
      }

      final reorderableWidget = M3EReorderableSegmentedList.builder(
        keyBuilder: (index) =>
            ValueKey('seg_reorder_${items[index].id}_${tileLayout.name}'),
        itemCount: items.length,
        header: pinnedHeader,
        footer: pinnedFooter,
        buildDefaultDragHandles: buildDefaultDragHandles,
        selectionMode: selectionMode,
        selectionTrigger: selectionTrigger,
        selectedIndices: selectedIndices,
        showSelectionCheckmark: showSelectionCheckmark,
        selectionCheckmarkAlignment: checkmarkAlignment,
        onSelectionChanged: onSelectedIndicesChanged,
        onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
        onReorder: onReorder,
        semanticLabelBuilder: semanticLabelBuilder,
        decoration: decoration,
        dragPlaceholderColor: useCustomPlaceholderColor
            ? placeholderColor
            : null,
        dragPlaceholderBorder: usePlaceholderBorder
            ? BorderSide(
                color: cs.outlineVariant,
                width: placeholderBorderWidth,
              )
            : null,
        outerRadius: outerRadius,
        innerRadius: innerRadius,
        gap: gap,
        padding: paddingInsets,
        margin: marginInsets,
        elevation: elevation,
        dragScale: dragScale,
        dragElevation: dragElevation,
        dragColor: useCustomDragColor ? dragColor : null,
        dragRadius: dragRadius,
        pressedRadius: pressedRadius,
        pressedScale: pressedScale,
        hoveredRadius: hoveredRadius,
        itemBuilder: (context, index) {
          return buildSegmentedListItemTile(
            context: context,
            item: items[index],
            tileLayout: tileLayout,
          );
        },
      );

      if (containerMode == SegmentedContainerMode.sliver) {
        return SizedBox(
          height: 540,
          child: CustomScrollView(
            controller: sliverScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: 540, child: reorderableWidget),
              ),
            ],
          ),
        );
      }

      return SizedBox(height: 540, child: reorderableWidget);
    }

    // ── Normal Mode: Row Architecture ──
    if (containerMode == SegmentedContainerMode.row) {
      final displayItems = items;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            M3ESegmentedRow(
              selectionMode: selectionMode,
              selectionTrigger: selectionTrigger,
              selectedIndices: selectedIndices,
              showSelectionCheckmark: showSelectionCheckmark,
              selectionCheckmarkAlignment: checkmarkAlignment,
              onSelectionChanged: onSelectedIndicesChanged,
              onTap: (i) {
                const labels = [
                  'Date picker tapped: Sep 1, 2026',
                  'Time picker tapped: 11:39 AM',
                  'Timezone picker tapped: GMT+5:30',
                ];
                showSnack(context, labels[i % labels.length]);
              },
              semanticLabelBuilder: semanticLabelBuilder,
              decoration: decoration,
              outerRadius: outerRadius,
              innerRadius: innerRadius,
              gap: gap,
              padding: paddingInsets,
              margin: marginInsets,
              elevation: elevation,
              pressedRadius: pressedRadius,
              pressedScale: pressedScale,
              hoveredRadius: hoveredRadius,
              equalWidth: flexes == null,
              flexes: flexes,
              children: List.generate(displayItems.length, (index) {
                const cardDefs = [
                  (icon: Icons.calendar_today_outlined, title: 'Sep 1, 2026'),
                  (icon: Icons.access_time_rounded, title: '11:39 AM'),
                  (icon: Icons.public_rounded, title: 'GMT+5:30'),
                ];
                final def = cardDefs[index % cardDefs.length];
                return KeyedSubtree(
                  key: ValueKey('row_card_$index'),
                  child: Row(
                    children: [
                      Icon(def.icon, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          def.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, size: 18),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }

    // ── Normal Mode: Column Architecture ──
    if (containerMode == SegmentedContainerMode.column) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: M3ESegmentedColumn(
          selectionMode: selectionMode,
          selectionTrigger: selectionTrigger,
          selectedIndices: selectedIndices,
          showSelectionCheckmark: showSelectionCheckmark,
          selectionCheckmarkAlignment: checkmarkAlignment,
          onSelectionChanged: onSelectedIndicesChanged,
          onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
          semanticLabelBuilder: semanticLabelBuilder,
          decoration: decoration,
          outerRadius: outerRadius,
          innerRadius: innerRadius,
          gap: gap,
          padding: paddingInsets,
          margin: marginInsets,
          elevation: elevation,
          pressedRadius: pressedRadius,
          pressedScale: pressedScale,
          hoveredRadius: hoveredRadius,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return KeyedSubtree(
              key: ValueKey('col_${item.id}_${tileLayout.name}'),
              child: buildSegmentedListItemTile(
                context: context,
                item: item,
                tileLayout: tileLayout,
              ),
            );
          }),
        ),
      );
    }

    // ── Normal Mode: Lazy Loading (ListView.builder) ──
    if (containerMode == SegmentedContainerMode.listView) {
      final totalCount = items.length + (isLoadingMore ? 1 : 0);
      return SizedBox(
        height: 540,
        child: Column(
          children: [
            if (enableLazyLoading)
              lazyLoadBanner(context, items.length, totalAvailableItems),
            Expanded(
              child: M3ESegmentedList.builder(
                controller: listScrollController,
                itemCount: totalCount,
                selectionMode: selectionMode,
                selectionTrigger: selectionTrigger,
                selectedIndices: selectedIndices,
                showSelectionCheckmark: showSelectionCheckmark,
                selectionCheckmarkAlignment: checkmarkAlignment,
                onSelectionChanged: onSelectedIndicesChanged,
                onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
                semanticLabelBuilder: semanticLabelBuilder,
                decoration: decoration,
                outerRadius: outerRadius,
                innerRadius: innerRadius,
                gap: gap,
                padding: paddingInsets,
                margin: marginInsets,
                elevation: elevation,
                pressedRadius: pressedRadius,
                pressedScale: pressedScale,
                hoveredRadius: hoveredRadius,
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const KeyedSubtree(
                      key: ValueKey('__seg_loader_list__'),
                      child: LoadingTile(),
                    );
                  }
                  final item = items[index];
                  return KeyedSubtree(
                    key: ValueKey('list_${item.id}_${tileLayout.name}'),
                    child: buildSegmentedListItemTile(
                      context: context,
                      item: item,
                      tileLayout: tileLayout,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // ── Normal Mode: Sliver Architecture ──
    final totalCount = items.length + (isLoadingMore ? 1 : 0);
    return SizedBox(
      height: 540,
      child: Column(
        children: [
          if (enableLazyLoading)
            lazyLoadBanner(context, items.length, totalAvailableItems),
          Expanded(
            child: CustomScrollView(
              controller: sliverScrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: SliverM3ESegmentedList(
                    itemCount: totalCount,
                    selectionMode: selectionMode,
                    selectionTrigger: selectionTrigger,
                    selectedIndices: selectedIndices,
                    showSelectionCheckmark: showSelectionCheckmark,
                    selectionCheckmarkAlignment: checkmarkAlignment,
                    onSelectionChanged: onSelectedIndicesChanged,
                    onTap: (i) =>
                        showSnack(context, 'Tapped: ${items[i].subject}'),
                    semanticLabelBuilder: semanticLabelBuilder,
                    decoration: decoration,
                    outerRadius: outerRadius,
                    innerRadius: innerRadius,
                    gap: gap,
                    padding: paddingInsets,
                    margin: marginInsets,
                    elevation: elevation,
                    pressedRadius: pressedRadius,
                    pressedScale: pressedScale,
                    hoveredRadius: hoveredRadius,
                    itemBuilder: (context, index) {
                      if (index >= items.length) {
                        return const KeyedSubtree(
                          key: ValueKey('__seg_loader_sliver__'),
                          child: LoadingTile(),
                        );
                      }
                      final item = items[index];
                      return KeyedSubtree(
                        key: ValueKey('sliver_${item.id}_${tileLayout.name}'),
                        child: buildSegmentedListItemTile(
                          context: context,
                          item: item,
                          tileLayout: tileLayout,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableSegmentedPreview extends StatefulWidget {
  final SegmentedContainerMode containerMode;
  final double outerRadius;
  final double innerRadius;
  final double pressedRadius;
  final double pressedScale;
  final double hoveredRadius;
  final double gap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final M3EMotion motion;
  final M3EMotion pressedMotion;
  final M3EMotion expandMotion;
  final M3EMotion collapseMotion;
  final M3ESelectionMode selectionMode;
  final M3ESelectionTrigger selectionTrigger;
  final bool showSelectionCheckmark;
  final Alignment checkmarkAlignment;
  final double selectedRadius;
  final Color? selectedColor;
  final BorderSide? selectedBorder;
  final double elevation;
  final double selectedElevation;
  final M3EHapticFeedback haptic;
  final bool showTrailingPill;
  final bool showTrailingPillOnlyWhenExpanded;
  final Color? trailingPillColor;
  final Size trailingPillSize;

  const _ExpandableSegmentedPreview({
    required this.containerMode,
    required this.outerRadius,
    required this.innerRadius,
    required this.pressedRadius,
    required this.pressedScale,
    required this.hoveredRadius,
    required this.gap,
    required this.padding,
    required this.margin,
    required this.motion,
    required this.pressedMotion,
    required this.expandMotion,
    required this.collapseMotion,
    required this.selectionMode,
    required this.selectionTrigger,
    required this.showSelectionCheckmark,
    required this.checkmarkAlignment,
    required this.selectedRadius,
    required this.selectedColor,
    required this.selectedBorder,
    required this.elevation,
    required this.selectedElevation,
    required this.haptic,
    this.showTrailingPill = true,
    this.showTrailingPillOnlyWhenExpanded = true,
    this.trailingPillColor,
    this.trailingPillSize = const Size(32.0, 48.0),
  });

  @override
  State<_ExpandableSegmentedPreview> createState() =>
      _ExpandableSegmentedPreviewState();
}

class _ExpandableSegmentedPreviewState
    extends State<_ExpandableSegmentedPreview> {
  final Set<int> _expandedIndices = {0};
  final Set<String> _selectedItems = {'0_0'};

  final List<Map<String, dynamic>> _expandableData = [
    {
      'title': 'Project milestones',
      'subtitle': 'Q3 deliverables • 4 items',
      'icon': Icons.flag_outlined,
      'children': [
        {
          'title': 'Design system tokens',
          'subtitle': 'Material 3 Expressive shapes',
          'icon': Icons.palette_outlined,
        },
        {
          'title': 'Segmented expansion',
          'subtitle': 'Dynamic spring physics',
          'icon': Icons.animation_outlined,
        },
        {
          'title': 'Swipe action reveal',
          'subtitle': 'Multi-action elastic stretch',
          'icon': Icons.swipe_left_outlined,
        },
        {
          'title': 'Accessibility triggers',
          'subtitle': 'Tap, double tap, and long press',
          'icon': Icons.accessibility_new_outlined,
        },
      ],
    },
    {
      'title': 'Sprint backlog',
      'subtitle': 'Active sprint • 3 items',
      'icon': Icons.task_alt_outlined,
      'children': [
        {
          'title': 'Interactive selection tests',
          'subtitle': 'Unit & integration test suite',
          'icon': Icons.checklist_rtl_outlined,
        },
        {
          'title': 'Playground documentation',
          'subtitle': 'Code snippets & live controls',
          'icon': Icons.menu_book_outlined,
        },
        {
          'title': 'Release notes v0.2.0',
          'subtitle': 'Changelog updates',
          'icon': Icons.campaign_outlined,
        },
      ],
    },
    {
      'title': 'Architecture reviews',
      'subtitle': 'Upcoming reviews • 2 items',
      'icon': Icons.hub_outlined,
      'children': [
        {
          'title': 'Motion controller optimizations',
          'subtitle': 'Frame budget & render passes',
          'icon': Icons.speed_outlined,
        },
        {
          'title': 'Component boundary decoupling',
          'subtitle': 'Zero cross-package leakage',
          'icon': Icons.account_tree_outlined,
        },
      ],
    },
  ];

  void _handleItemInteraction(
    int parentIndex,
    int childIndex, {
    required bool isLongPress,
  }) {
    final canTrigger = isLongPress
        ? (widget.selectionTrigger == M3ESelectionTrigger.longPress ||
              widget.selectionTrigger == M3ESelectionTrigger.both)
        : (widget.selectionTrigger == M3ESelectionTrigger.tap ||
              widget.selectionTrigger == M3ESelectionTrigger.both);

    if (widget.selectionMode == M3ESelectionMode.none || !canTrigger) {
      if (!isLongPress) {
        final child =
            (_expandableData[parentIndex]['children']
                as List<Map<String, dynamic>>)[childIndex];
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Triggered: ${child['title']}'),
            duration: const Duration(milliseconds: 900),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final itemKey = '${parentIndex}_$childIndex';
    widget.haptic.apply();

    setState(() {
      if (widget.selectionMode == M3ESelectionMode.single) {
        if (_selectedItems.contains(itemKey)) {
          _selectedItems.clear();
        } else {
          _selectedItems.clear();
          _selectedItems.add(itemKey);
        }
      } else {
        if (_selectedItems.contains(itemKey)) {
          _selectedItems.remove(itemKey);
        } else {
          _selectedItems.add(itemKey);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final triggerText = widget.selectionMode == M3ESelectionMode.none
        ? 'Selection disabled in controls • Tap child to trigger'
        : widget.selectionTrigger == M3ESelectionTrigger.longPress
        ? 'Long press child item to toggle selection'
        : widget.selectionTrigger == M3ESelectionTrigger.none
        ? 'Selection gesture disabled in controls'
        : 'Tap header to expand • Tap child to toggle selection';

    final expandableWidgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
        child: Row(
          children: [
            Icon(
              widget.selectionMode == M3ESelectionMode.none
                  ? Icons.touch_app_outlined
                  : Icons.checklist_rounded,
              size: 16,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                triggerText,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      for (int index = 0; index < _expandableData.length; index++) ...[
        () {
          final data = _expandableData[index];
          final isExpanded = _expandedIndices.contains(index);
          final childrenList = data['children'] as List<Map<String, dynamic>>;

          final selectedChildIndices = <int>{};
          if (widget.selectionMode != M3ESelectionMode.none) {
            for (int c = 0; c < childrenList.length; c++) {
              if (_selectedItems.contains('${index}_$c')) {
                selectedChildIndices.add(c);
              }
            }
          }

          return M3EExpandableSegmentedItem(
            key: ValueKey('expand_item_$index'),
            index: index,
            totalCount: _expandableData.length,
            isExpanded: isExpanded,
            outerRadius: widget.outerRadius,
            innerRadius: widget.innerRadius,
            pressedRadius: widget.pressedRadius,
            pressedScale: widget.pressedScale,
            hoveredRadius: widget.hoveredRadius,
            gap: widget.gap,
            padding: widget.padding,
            childPadding: widget.padding,
            expandMotion: widget.expandMotion,
            collapseMotion: widget.collapseMotion,
            pressedMotion: widget.pressedMotion,
            elevation: widget.elevation,
            selectedElevation: widget.selectedElevation,
            showSelectionCheckmark: widget.showSelectionCheckmark,
            selectionCheckmarkAlignment: widget.checkmarkAlignment,
            showTrailingPill: widget.showTrailingPill,
            showTrailingPillOnlyWhenExpanded:
                widget.showTrailingPillOnlyWhenExpanded,
            trailingPillColor: widget.trailingPillColor,
            trailingPillSize: widget.trailingPillSize,
            selectedRadius: widget.selectedRadius,
            selectedColor: widget.selectedColor ?? cs.secondaryContainer,
            selectedBorder: widget.selectedBorder,
            selectedChildIndices: selectedChildIndices,
            onChildTap: (childIdx) =>
                _handleItemInteraction(index, childIdx, isLongPress: false),
            onChildLongPress: (childIdx) =>
                _handleItemInteraction(index, childIdx, isLongPress: true),
            onToggle: () {
              setState(() {
                if (isExpanded) {
                  _expandedIndices.remove(index);
                } else {
                  _expandedIndices.add(index);
                }
              });
            },
            header: M3EListItem(
              leading: Icon(data['icon'] as IconData),
              headline: Text(
                data['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              supportingText: Text(data['subtitle'] as String),
            ),
            children: [
              for (
                int childIdx = 0;
                childIdx < childrenList.length;
                childIdx++
              ) ...[
                () {
                  final child = childrenList[childIdx];
                  final itemKey = '${index}_$childIdx';
                  final isSelected =
                      widget.selectionMode != M3ESelectionMode.none &&
                      _selectedItems.contains(itemKey);
                  final iconData = child['icon'] as IconData?;

                  return M3EListItem(
                    leading: Icon(
                      iconData ?? Icons.circle_outlined,
                      color: isSelected
                          ? cs.onSecondaryContainer
                          : cs.onSurfaceVariant,
                    ),
                    headline: Text(
                      child['title'] as String,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? cs.onSecondaryContainer
                            : cs.onSurface,
                      ),
                    ),
                    supportingText: Text(
                      child['subtitle'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? cs.onSecondaryContainer.withValues(alpha: 0.85)
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }(),
              ],
            ],
          );
        }(),
      ],
    ];

    if (widget.containerMode == SegmentedContainerMode.listView) {
      return SizedBox(
        height: 540,
        child: ListView(padding: widget.margin, children: expandableWidgets),
      );
    }

    if (widget.containerMode == SegmentedContainerMode.sliver) {
      return SizedBox(
        height: 540,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: widget.margin,
              sliver: SliverList(
                delegate: SliverChildListDelegate(expandableWidgets),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: widget.margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: expandableWidgets,
      ),
    );
  }
}
