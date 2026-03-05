import 'package:flutter/material.dart';

import 'm3e_dismissible_card_controller.dart';
import 'm3e_dismissible_card_style.dart';

/// A dismissible M3E card list backed by a [Column] — the simplest variant,
/// ideal for small, fixed-size lists (menus, settings groups, etc.).
///
/// All items are materialised up-front so this should **not** be used for large
/// or lazily-loaded data sets.  Use [M3EDismissibleCardList] or
/// [SliverM3EDismissibleCardList] instead.
///
/// ```dart
/// M3EDismissibleCardColumn(
///   itemCount: items.length,
///   itemBuilder: (ctx, i) => Text(items[i].title),
///   onDismiss: (i, dir) async { items.removeAt(i); return true; },
/// )
/// ```
class M3EDismissibleCardColumn extends StatefulWidget {
  /// Number of data items.
  final int itemCount;

  /// Builds content for the item at the given index.
  final IndexedWidgetBuilder itemBuilder;

  /// Called when a swipe exceeds the dismiss threshold.
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;

  /// Called on tap (blocked while a drag or dismiss is in-flight).
  final void Function(int index)? onTap;

  /// Visual and interaction configuration.
  final M3EDismissibleCardStyle style;

  const M3EDismissibleCardColumn({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.style = const M3EDismissibleCardStyle(),
  });

  /// Convenience constructor for a pre-built list of widgets.
  factory M3EDismissibleCardColumn.of({
    Key? key,
    required List<Widget> children,
    Future<bool> Function(int index, DismissDirection direction)? onDismiss,
    void Function(int index)? onTap,
    M3EDismissibleCardStyle style = const M3EDismissibleCardStyle(),
  }) {
    return M3EDismissibleCardColumn(
      key: key,
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
      onDismiss: onDismiss,
      onTap: onTap,
      style: style,
    );
  }

  @override
  State<M3EDismissibleCardColumn> createState() =>
      _M3EDismissibleCardColumnState();
}

class _M3EDismissibleCardColumnState extends State<M3EDismissibleCardColumn>
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
  void didUpdateWidget(M3EDismissibleCardColumn old) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < slots.length; i++) buildSlot(context, i, visible),
      ],
    );
  }
}
