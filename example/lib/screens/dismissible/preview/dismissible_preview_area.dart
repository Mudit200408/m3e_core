// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../../../data/mock_data.dart';
import '../models/dismissible_models.dart';

class DismissiblePreviewArea extends StatelessWidget {
  const DismissiblePreviewArea({
    super.key,
    required this.layoutMode,
    required this.items,
    required this.style,
    required this.enableLazyLoading,
    required this.isLoadingMore,
    required this.totalAvailableItems,
    required this.listScrollController,
    required this.sliverScrollController,
    required this.onDismiss,
    required this.onResetItems,
    this.onReorder,
    this.resetKey = 0,
    this.buildDefaultDragHandles = true,
    this.dragScale = 1.0,
    this.dragElevation = 8.0,
  });

  final DismissibleLayoutMode layoutMode;
  final List<EmailItem> items;
  final M3EDismissibleCardStyle style;
  final bool enableLazyLoading;
  final bool isLoadingMore;
  final int totalAvailableItems;
  final ScrollController listScrollController;
  final ScrollController sliverScrollController;
  final Future<bool> Function(int index, DismissDirection direction) onDismiss;
  final VoidCallback onResetItems;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final int resetKey;
  final bool buildDefaultDragHandles;
  final double dragScale;
  final double dragElevation;

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 56, color: cs.outline),
            const SizedBox(height: 12),
            Text(
              'All items dismissed!',
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
              label: const Text('Reload Mock Inbox'),
              onPressed: onResetItems,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Column Mode ──
    if (layoutMode == DismissibleLayoutMode.column) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: M3EDismissibleCardColumn(
          key: ValueKey('col_list_$resetKey'),
          itemCount: items.length,
          onDismiss: onDismiss,
          onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
          style: style,
          emptyBuilder: _buildEmptyState,
          itemBuilder: (context, index) {
            final item = items[index];
            return KeyedSubtree(
              key: ValueKey('col_item_${item.id}'),
              child: buildEmailTile(context, item),
            );
          },
        ),
      );
    }

    // ── ListView Mode ──
    if (layoutMode == DismissibleLayoutMode.listView) {
      final totalCount = items.length + (isLoadingMore ? 1 : 0);
      return SizedBox(
        height: 520,
        child: Column(
          children: [
            if (enableLazyLoading)
              lazyLoadBanner(context, items.length, totalAvailableItems),
            Expanded(
              child: M3EDismissibleCardList(
                key: ValueKey('lv_list_$resetKey'),
                scrollController: listScrollController,
                listPadding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                itemCount: totalCount,
                onDismiss: onDismiss,
                onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
                style: style,
                emptyBuilder: _buildEmptyState,
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const KeyedSubtree(
                      key: ValueKey('__loader_list__'),
                      child: LoadingTile(),
                    );
                  }
                  final item = items[index];
                  return KeyedSubtree(
                    key: ValueKey('lv_item_${item.id}'),
                    child: buildEmailTile(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // ── Sliver Mode ──
    if (layoutMode == DismissibleLayoutMode.sliver) {
      final totalCount = items.length + (isLoadingMore ? 1 : 0);
      return SizedBox(
        height: 520,
        child: Column(
          children: [
            if (enableLazyLoading)
              lazyLoadBanner(context, items.length, totalAvailableItems),
            Expanded(
              child: CustomScrollView(
                controller: sliverScrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    sliver: SliverM3EDismissibleCardList(
                      key: ValueKey('sl_list_$resetKey'),
                      itemCount: totalCount,
                      onDismiss: onDismiss,
                      onTap: (i) =>
                          showSnack(context, 'Tapped: ${items[i].subject}'),
                      style: style,
                      emptyBuilder: _buildEmptyState,
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return const KeyedSubtree(
                            key: ValueKey('__loader_sliver__'),
                            child: LoadingTile(),
                          );
                        }
                        final item = items[index];
                        return KeyedSubtree(
                          key: ValueKey('sl_item_${item.id}'),
                          child: buildEmailTile(context, item),
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

    // ── Reorderable Dismissible Mode ──
    return SizedBox(
      height: 520,
      child: M3EReorderableDismissibleList(
        key: ValueKey('reorder_list_$resetKey'),
        scrollController: listScrollController,
        listPadding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
        itemCount: items.length,
        buildDefaultDragHandles: buildDefaultDragHandles,
        reorderMotion: style.neighbourMotion,
        dragScale: dragScale,
        dragElevation: dragElevation,
        keyBuilder: (index) => ValueKey('reorder_item_${items[index].id}'),
        onDismiss: onDismiss,
        onReorder: (oldIndex, newIndex) {
          onReorder?.call(oldIndex, newIndex);
        },
        onTap: (i) => showSnack(context, 'Tapped: ${items[i].subject}'),
        style: style,
        emptyBuilder: _buildEmptyState,
        itemBuilder: (context, index) {
          final item = items[index];
          return buildEmailTile(context, item);
        },
      ),
    );
  }
}
