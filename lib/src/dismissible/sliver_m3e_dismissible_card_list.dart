import 'package:flutter/material.dart';

import 'm3e_dismissible_card_controller.dart';
import 'm3e_dismissible_card_style.dart';

/// A dismissible M3E card list that plugs into a [CustomScrollView] as a sliver.
///
/// Items are built lazily by the viewport, making this suitable for very large
/// data sets sitting alongside other slivers.
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverM3EDismissibleCardList(
///       itemCount: items.length,
///       itemBuilder: (ctx, i) => Text(items[i].title),
///       onDismiss: (i, dir) async { items.removeAt(i); return true; },
///     ),
///   ],
/// )
/// ```
class SliverM3EDismissibleCardList extends StatefulWidget {
  /// Number of data items.
  final int itemCount;

  /// Builds content for the item at [index].
  final IndexedWidgetBuilder itemBuilder;

  /// Called when a swipe exceeds the dismiss threshold.
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;

  /// Called on tap (blocked while a drag or dismiss is in-flight).
  final void Function(int index)? onTap;

  /// Visual and interaction configuration.
  final M3EDismissibleCardStyle style;

  const SliverM3EDismissibleCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.style = const M3EDismissibleCardStyle(),
  });

  @override
  State<SliverM3EDismissibleCardList> createState() =>
      _SliverM3EDismissibleCardListState();
}

class _SliverM3EDismissibleCardListState
    extends State<SliverM3EDismissibleCardList>
    with TickerProviderStateMixin, M3EDismissibleCardMixin {
  // ── Mixin interface ──

  @override
  int get swipeItemCount => widget.itemCount;

  @override
  Widget swipeItemBuilder(BuildContext context, int dataIndex) =>
      widget.itemBuilder(context, dataIndex);

  @override
  M3EDismissibleCardStyle get style => widget.style;

  @override
  Future<bool> Function(int, DismissDirection)? get onDismissCallback =>
      widget.onDismiss;

  @override
  void Function(int)? get onTapCallback => widget.onTap;

  // ── Lifecycle ──

  @override
  void initState() {
    super.initState();
    initSlots();
  }

  @override
  void didUpdateWidget(SliverM3EDismissibleCardList old) {
    super.didUpdateWidget(old);
    syncSlotsIfNeeded(old.itemCount);
  }

  @override
  void dispose() {
    disposeSlots();
    super.dispose();
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final visible = computeVisibleIndices();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => buildSlot(ctx, i, visible),
        childCount: slots.length,
      ),
    );
  }
}
