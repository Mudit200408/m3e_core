import 'package:flutter/material.dart';

import 'm3e_expandable_item.dart';

/// A static, non-scrolling Material 3 Expressive expandable card list.
///
/// Uses a [Column] internally, ideal for short lists (FAQs, settings groups)
/// placed inside an already scrolling view.
///
/// ```dart
/// M3EExpandableCardColumn(
///   itemCount: emails.length,
///   headerBuilder: (context, index, isExpanded) => ListTile(
///     title: Text(emails[index].subject),
///     trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
///   ),
///   bodyBuilder: (context, index) => Padding(
///     padding: EdgeInsets.all(16),
///     child: Text(emails[index].body),
///   ),
/// )
/// ```
class M3EExpandableCardColumn extends StatefulWidget {
  /// Number of expandable items.
  final int itemCount;

  /// Builds the always‑visible header of each item.
  final M3EExpandableHeaderBuilder headerBuilder;

  /// Builds the expandable body content of each item.
  final M3EExpandableBodyBuilder bodyBuilder;

  /// Whether multiple items can be expanded simultaneously.
  ///
  /// When `false` (default), expanding an item collapses the previously
  /// expanded one.
  final bool allowMultipleExpanded;

  /// Indices that are expanded initially.
  final Set<int> initiallyExpanded;

  // ── Shape ──

  /// Outer radius for the first and last item (and single items).
  ///
  /// Defaults to `24.0`.
  final double outerRadius;

  /// Inner radius for middle items.
  ///
  /// Defaults to `4.0`.
  final double innerRadius;

  /// Gap between cards.
  ///
  /// Defaults to `3.0`.
  final double gap;

  /// Background colour for each card.
  ///
  /// Defaults to [ColorScheme.surfaceContainerHighest] if null.
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

  /// Border radius applied to expanded items. When non-null, the card
  /// spring-animates from its default position-based radius to this value
  /// on expand, and back on collapse.
  ///
  /// When `null` the radius stays as computed from [outerRadius] /
  /// [innerRadius].
  final BorderRadius? selectedBorderRadius;

  // ── Trailing icon ──

  /// Whether to show the default animated arrow on the right side of the
  /// header. Set to `false` to hide it (e.g. when you provide your own
  /// icon inside [headerBuilder]).
  ///
  /// Defaults to `true`.
  final bool showArrow;

  /// An optional widget placed on the trailing side of each header,
  /// replacing the default animated arrow when provided.
  final Widget? trailingIcon;

  // ── Animation ──

  /// Spring stiffness for the expand animation.
  ///
  /// Defaults to `380`.
  final double openStiffness;

  /// Spring damping ratio for the expand animation.
  ///
  /// Defaults to `0.75`.
  final double openDamping;

  /// Spring stiffness for the collapse animation.
  ///
  /// Defaults to `380`.
  final double closeStiffness;

  /// Spring damping ratio for the collapse animation.
  ///
  /// Defaults to `0.75`.
  final double closeDamping;

  // ── Haptics ──

  /// Haptic feedback level on tap (0 = none, 1 = light, 2 = medium, 3 = heavy).
  final int haptic;

  /// Ink splash colour.
  final Color? splashColor;

  /// Ink highlight colour.
  final Color? highlightColor;

  /// Splash factory (e.g. [NoSplash.splashFactory]).
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic / haptic feedback.
  final bool enableFeedback;

  /// Called when an item is expanded or collapsed.
  final void Function(int index, bool isExpanded)? onExpansionChanged;

  /// Creates an [M3EExpandableCardColumn].
  const M3EExpandableCardColumn({
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
  State<M3EExpandableCardColumn> createState() =>
      _M3EExpandableCardColumnState();
}

class _M3EExpandableCardColumnState extends State<M3EExpandableCardColumn> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.itemCount, (index) {
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
      }),
    );
  }
}
