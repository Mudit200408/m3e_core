import 'package:flutter/material.dart';

import 'm3e_expandable_item.dart';

/// A lazily-loaded Material 3 Expressive expandable card list for slivers.
///
/// Uses [SliverList.builder] internally, ideal for large data sets inside a
/// [CustomScrollView].
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverM3EExpandableCardList(
///       itemCount: 500,
///       headerBuilder: (context, index, isExpanded) => ListTile(
///         title: Text('Item $index'),
///       ),
///       bodyBuilder: (context, index) => Padding(
///         padding: EdgeInsets.all(16),
///         child: Text('Detail content for item $index'),
///       ),
///     ),
///   ],
/// )
/// ```
class SliverM3EExpandableCardList extends StatefulWidget {
  /// Number of expandable items.
  final int itemCount;

  /// Builds the always‑visible header of each item.
  final M3EExpandableHeaderBuilder headerBuilder;

  /// Builds the expandable body content of each item.
  final M3EExpandableBodyBuilder bodyBuilder;

  /// Whether multiple items can be expanded simultaneously.
  final bool allowMultipleExpanded;

  /// Indices that are expanded initially.
  final Set<int> initiallyExpanded;

  // ── Shape ──

  /// Outer radius for the first and last item (and single items).
  final double outerRadius;

  /// Inner radius for middle items.
  final double innerRadius;

  /// Gap between cards.
  final double gap;

  /// Background colour for each card.
  final Color? color;

  /// Padding applied inside each header.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding applied inside each body.
  final EdgeInsetsGeometry? bodyPadding;

  /// Outer margin around each card.
  final EdgeInsetsGeometry? margin;

  /// Border drawn around each card.
  final BorderSide? border;

  /// Elevation of the card.
  final double elevation;

  /// Border radius applied to expanded items.
  final BorderRadius? selectedBorderRadius;

  // ── Trailing icon ──

  /// Whether to show the default animated arrow.
  final bool showArrow;

  /// An optional custom trailing widget.
  final Widget? trailingIcon;

  // ── Animation ──

  /// Spring stiffness for the expand animation.
  final double openStiffness;

  /// Spring damping ratio for the expand animation.
  final double openDamping;

  /// Spring stiffness for the collapse animation.
  final double closeStiffness;

  /// Spring damping ratio for the collapse animation.
  final double closeDamping;

  // ── Haptics ──

  /// Haptic feedback level on tap (0 = none, 1 = light, 2 = medium, 3 = heavy).
  final int haptic;

  /// Ink splash colour.
  final Color? splashColor;

  /// Ink highlight colour.
  final Color? highlightColor;

  /// Splash factory.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic / haptic feedback.
  final bool enableFeedback;

  /// Called when an item is expanded or collapsed.
  final void Function(int index, bool isExpanded)? onExpansionChanged;

  /// Creates a [SliverM3EExpandableCardList].
  const SliverM3EExpandableCardList({
    super.key,
    required this.itemCount,
    required this.headerBuilder,
    required this.bodyBuilder,
    this.allowMultipleExpanded = false,
    this.initiallyExpanded = const {},
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 3.0,
    this.color,
    this.headerPadding,
    this.bodyPadding,
    this.margin,
    this.border,
    this.elevation = 0,
    this.selectedBorderRadius,
    this.showArrow = true,
    this.trailingIcon,
    this.openStiffness = 380,
    this.openDamping = 0.75,
    this.closeStiffness = 380,
    this.closeDamping = 0.75,
    this.haptic = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.onExpansionChanged,
  });

  @override
  State<SliverM3EExpandableCardList> createState() =>
      _SliverM3EExpandableCardListState();
}

class _SliverM3EExpandableCardListState
    extends State<SliverM3EExpandableCardList> {
  late Set<int> _expandedIndices;

  @override
  void initState() {
    super.initState();
    _expandedIndices = Set<int>.from(widget.initiallyExpanded);
  }

  void _handleToggle(int index) {
    applyHaptic(widget.haptic);
    final isExpanding = !_expandedIndices.contains(index);

    setState(() {
      if (isExpanding) {
        if (!widget.allowMultipleExpanded) _expandedIndices.clear();
        _expandedIndices.add(index);
      } else {
        _expandedIndices.remove(index);
      }
    });

    widget.onExpansionChanged?.call(index, isExpanding);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return M3EExpandableItem(
          index: index,
          totalCount: widget.itemCount,
          isExpanded: _expandedIndices.contains(index),
          headerBuilder: widget.headerBuilder,
          bodyBuilder: widget.bodyBuilder,
          outerRadius: widget.outerRadius,
          innerRadius: widget.innerRadius,
          gap: widget.gap,
          selectedBorderRadius: widget.selectedBorderRadius,
          margin: widget.margin,
          headerPadding: widget.headerPadding,
          bodyPadding: widget.bodyPadding,
          border: widget.border,
          elevation: widget.elevation,
          color: widget.color,
          showArrow: widget.showArrow,
          trailingIcon: widget.trailingIcon,
          openStiffness: widget.openStiffness,
          openDamping: widget.openDamping,
          closeStiffness: widget.closeStiffness,
          closeDamping: widget.closeDamping,
          haptic: widget.haptic,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          splashFactory: widget.splashFactory,
          enableFeedback: widget.enableFeedback,
          onToggle: () => _handleToggle(index),
        );
      },
    );
  }
}
