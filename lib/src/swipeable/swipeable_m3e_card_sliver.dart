import 'package:flutter/material.dart';

import 'swipeable_m3e_card_controller.dart';
import 'swipeable_m3e_card_style.dart';

/// A swipeable M3E card list that plugs into a [CustomScrollView] as a sliver.
///
/// Items are built lazily by the viewport, making this suitable for very large
/// data sets sitting alongside other slivers.
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverSwipeableM3CardList(
///       itemCount: items.length,
///       itemBuilder: (ctx, i) => Text(items[i].title),
///       onSwipe: (i, dir) async { items.removeAt(i); return true; },
///     ),
///   ],
/// )
/// ```
class SliverSwipeableM3CardList extends StatefulWidget {
  /// Number of data items.
  final int itemCount;

  /// Builds content for the item at [index].
  final IndexedWidgetBuilder itemBuilder;

  /// Called when a swipe exceeds the dismiss threshold.
  final Future<bool> Function(int index, DismissDirection direction)? onSwipe;

  /// Called on tap (blocked while a drag or dismiss is in-flight).
  final void Function(int index)? onTap;

  /// Visual and interaction configuration.
  final SwipeableM3CardStyle style;

  const SliverSwipeableM3CardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onSwipe,
    this.onTap,
    this.style = const SwipeableM3CardStyle(),
  });

  @override
  State<SliverSwipeableM3CardList> createState() =>
      _SliverSwipeableM3CardListState();
}

class _SliverSwipeableM3CardListState extends State<SliverSwipeableM3CardList>
    with TickerProviderStateMixin, SwipeableM3CardMixin {
  // ── Mixin interface ──

  @override
  int get swipeItemCount => widget.itemCount;

  @override
  Widget swipeItemBuilder(BuildContext context, int dataIndex) =>
      widget.itemBuilder(context, dataIndex);

  @override
  SwipeableM3CardStyle get style => widget.style;

  @override
  Future<bool> Function(int, DismissDirection)? get onSwipeCallback =>
      widget.onSwipe;

  @override
  void Function(int)? get onTapCallback => widget.onTap;

  // ── Lifecycle ──

  @override
  void initState() {
    super.initState();
    initSlots();
  }

  @override
  void didUpdateWidget(SliverSwipeableM3CardList old) {
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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => buildSlot(ctx, i),
        childCount: slots.length,
      ),
    );
  }
}
