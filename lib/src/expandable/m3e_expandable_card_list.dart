import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'm3e_expandable_item.dart';

void _applyHaptic(int hapticLevel) {
  switch (hapticLevel) {
    case 1:
      HapticFeedback.lightImpact();
      break;
    case 2:
      HapticFeedback.mediumImpact();
      break;
    case 3:
      HapticFeedback.heavyImpact();
      break;
    default:
      break;
  }
}

/// A scrolling, lazily-loaded Material 3 Expressive expandable card list.
///
/// Uses [ListView.builder] internally, ideal for large data sets that need
/// their own scroll axis.
///
/// ```dart
/// M3EExpandableCardList(
///   itemCount: 500,
///   headerBuilder: (context, index, isExpanded) => ListTile(
///     title: Text('Item $index'),
///   ),
///   bodyBuilder: (context, index) => Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Detail content for item $index'),
///   ),
/// )
/// ```
class M3EExpandableCardList extends StatefulWidget {
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

  // ── ListView properties ──

  /// An optional scroll controller.
  final ScrollController? controller;

  /// Scroll physics override.
  final ScrollPhysics? physics;

  /// Whether the list should wrap its content height.
  ///
  /// Defaults to `false`.
  final bool shrinkWrap;

  /// Optional outer padding around the entire list.
  final EdgeInsetsGeometry? padding;

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

  /// Creates an [M3EExpandableCardList].
  const M3EExpandableCardList({
    super.key,
    required this.itemCount,
    required this.headerBuilder,
    required this.bodyBuilder,
    this.allowMultipleExpanded = false,
    this.initiallyExpanded = const {},
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
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
  State<M3EExpandableCardList> createState() => _M3EExpandableCardListState();
}

class _M3EExpandableCardListState extends State<M3EExpandableCardList> {
  late Set<int> _expandedIndices;

  @override
  void initState() {
    super.initState();
    _expandedIndices = Set<int>.from(widget.initiallyExpanded);
  }

  void _handleToggle(int index) {
    _applyHaptic(widget.haptic);
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
    return ListView.builder(
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
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
