import 'package:flutter/material.dart';

import 'swipeable_m3e_card_controller.dart';
import 'swipeable_m3e_card_style.dart';

/// A swipeable M3E card list backed by a [Column] — the simplest variant,
/// ideal for small, fixed-size lists (menus, settings groups, etc.).
///
/// All items are materialised up-front so this should **not** be used for large
/// or lazily-loaded data sets.  Use [SwipeableM3CardListView] or
/// [SliverSwipeableM3CardList] instead.
///
/// ```dart
/// SwipeableM3CardColumn(
///   itemCount: items.length,
///   itemBuilder: (ctx, i) => Text(items[i].title),
///   onSwipe: (i, dir) async { items.removeAt(i); return true; },
/// )
/// ```
class SwipeableM3CardColumn extends StatefulWidget {
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

  const SwipeableM3CardColumn({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onSwipe,
    this.onTap,
    this.style = const SwipeableM3CardStyle(),
  });

  /// Convenience constructor for a pre-built list of widgets.
  factory SwipeableM3CardColumn.of({
    Key? key,
    required List<Widget> children,
    Future<bool> Function(int index, DismissDirection direction)? onSwipe,
    void Function(int index)? onTap,
    SwipeableM3CardStyle style = const SwipeableM3CardStyle(),
  }) {
    return SwipeableM3CardColumn(
      key: key,
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
      onSwipe: onSwipe,
      onTap: onTap,
      style: style,
    );
  }

  @override
  State<SwipeableM3CardColumn> createState() => _SwipeableM3CardColumnState();
}

class _SwipeableM3CardColumnState extends State<SwipeableM3CardColumn>
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
  void didUpdateWidget(SwipeableM3CardColumn old) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < slots.length; i++) buildSlot(context, i),
      ],
    );
  }
}
