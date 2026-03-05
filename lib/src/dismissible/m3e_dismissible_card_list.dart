import 'package:flutter/material.dart';

import 'm3e_dismissible_card_controller.dart';
import 'm3e_dismissible_card_style.dart';

/// A dismissible M3E card list backed by [ListView.builder] — suitable for large
/// or lazily-loaded data sets.
///
/// Only the visible cards are materialised, so this variant scales to thousands
/// of items without keeping them all in the widget tree at once.
///
/// ```dart
/// M3EDismissibleCardList(
///   itemCount: items.length,
///   itemBuilder: (ctx, i) => Text(items[i].title),
///   onDismiss: (i, dir) async { items.removeAt(i); return true; },
///   style: const M3EDismissibleCardStyle(outerRadius: 24),
/// )
/// ```
class M3EDismissibleCardList extends StatefulWidget {
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

  /// Standard [ListView] scroll physics.
  final ScrollPhysics? physics;

  /// Standard [ListView] controller.
  final ScrollController? scrollController;

  /// Padding around the entire list.
  final EdgeInsetsGeometry? listPadding;

  /// Whether the list should shrink-wrap its children.
  final bool shrinkWrap;

  /// Clip behavior for the list.
  final Clip clipBehavior;

  const M3EDismissibleCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.style = const M3EDismissibleCardStyle(),
    this.physics,
    this.scrollController,
    this.listPadding,
    this.shrinkWrap = false,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<M3EDismissibleCardList> createState() => _M3EDismissibleCardListState();
}

class _M3EDismissibleCardListState extends State<M3EDismissibleCardList>
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
  void didUpdateWidget(M3EDismissibleCardList old) {
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
    return ListView.builder(
      controller: widget.scrollController,
      physics: widget.physics,
      padding: widget.listPadding,
      shrinkWrap: widget.shrinkWrap,
      clipBehavior: widget.clipBehavior,
      itemCount: slots.length,
      itemBuilder: (ctx, i) => buildSlot(ctx, i, visible),
    );
  }
}
