import 'package:flutter/material.dart';

import '../common/m3e_common.dart';
import 'm3e_card_widget.dart';

/// A Material 3 interactive card list with dynamically rounded corners.
///
/// `M3ECardList` renders a vertical list of items, where the first and last
/// items automatically have a larger outer radius, and the inner items have
/// a smaller inner radius, adhering to Material 3's expressive list design.
///
/// Use the default constructor for small lists (using [Column]) or
/// [M3ECardList.builder] for large or infinite lists (using [ListView.builder]).
class M3ECardList extends StatelessWidget {
  /// The number of items in the list.
  final int itemCount;

  /// Signature for a function that creates a widget for a given index.
  final IndexedWidgetBuilder itemBuilder;

  /// The radius used for the top corners of the first item, the bottom corners
  /// of the last item, and all corners of a single item.
  ///
  /// Defaults to `24.0`.
  final double outerRadius;

  /// The radius used for the inner corners of adjoining items.
  ///
  /// Defaults to `4.0`.
  final double innerRadius;

  /// The gap space between adjacent items.
  ///
  /// Defaults to `3.0`.
  final double gap;

  /// The background color for each card.
  ///
  /// Defaults to [ColorScheme.surfaceContainerHighest] if null.
  final Color? color;

  /// The inner padding applied to the [itemBuilder] child of each item.
  ///
  /// Defaults to `EdgeInsets.all(12.0)`.
  final EdgeInsetsGeometry? padding;

  /// The outer margin applied around the entire list of cards.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? margin;

  /// Optional callback invoked when an item is tapped.
  ///
  /// Provides the `index` of the tapped item. If null, the item will not be
  /// interactive.
  final void Function(int index)? onTap;

  /// Optional callback invoked when an item is long-pressed.
  ///
  /// Provides the `index` of the long-pressed item.
  final void Function(int index)? onLongPress;

  /// Optional semantic label builder for accessibility.
  ///
  /// Each card's label is derived from this builder for screen readers.
  final String Function(int index)? semanticLabelBuilder;

  /// The cursor for a mouse pointer when it enters a card's bounds.
  final MouseCursor? mouseCursor;

  /// The color to use when a card is focused by keyboard navigation.
  final Color? focusColor;

  /// The color to use when a card is hovered by a mouse pointer.
  final Color? hoverColor;

  /// Called when the focus state of a card changes.
  final void Function(int index, bool)? onFocusChange;

  /// The border drawn around each card item.
  ///
  /// Defaults to [BorderSide.none].
  final BorderSide? border;

  /// The elevation of the card.
  ///
  /// Defaults to `0`.
  final double elevation;

  /// The splash color of the ink response when tapped.
  final Color? splashColor;

  /// The highlight color of the ink response when tapped.
  final Color? highlightColor;

  /// Defines the appearance of the splash.
  ///
  /// Can be set to [NoSplash.splashFactory] to defeat the splash effect entirely.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// Defaults to `true`.
  final bool enableFeedback;

  /// The haptic feedback to provide on tap.
  final M3EHapticFeedback haptic;

  /// Widget displayed when the list is empty (itemCount is 0).
  ///
  /// If null, an empty container is shown.
  final Widget? emptyBuilder;

  /// Whether this list uses [ListView.builder] (true) or [Column] (false).
  final bool _isBuilder;

  /// Controls the scroll position of the list.
  ///
  /// Only used by [M3ECardList.builder].
  final ScrollController? controller;

  /// How the scroll view should respond to user input.
  ///
  /// Only used by [M3ECardList.builder].
  final ScrollPhysics? physics;

  /// Whether the scroll view should size itself to fit its children.
  ///
  /// When `false` (the default), the list expands to fill the available space.
  /// Set to `true` when embedding in another scrollable.
  ///
  /// Only used by [M3ECardList.builder].
  final bool shrinkWrap;

  /// Padding for the scrollable list itself.
  ///
  /// Adds empty space at the edges of the list. Distinct from [margin], which
  /// wraps the entire list, and [padding], which goes inside each card.
  ///
  /// Only used by [M3ECardList.builder].
  final EdgeInsetsGeometry? listPadding;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Only used by [M3ECardList.builder].
  /// Defaults to `true`.
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Only used by [M3ECardList.builder].
  /// Defaults to `true`.
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Only used by [M3ECardList.builder].
  /// Defaults to `true`.
  final bool addSemanticIndexes;

  /// Creates a [M3ECardList] that uses a [Column] internally.
  ///
  /// Best for short lists where lazy loading is not required.
  ///
  /// [itemCount] — number of items in the list.
  /// [itemBuilder] — builds a widget for each index.
  /// [outerRadius] — radius for outer corners (default: `24.0`).
  /// [innerRadius] — radius for inner corners (default: `4.0`).
  /// [gap] — space between adjacent items (default: `3.0`).
  /// [color] — background color (default: [ColorScheme.surfaceContainerHighest]).
  /// [padding] — inner padding for each card (default: `EdgeInsets.all(12.0)`).
  /// [margin] — outer margin around the entire list.
  /// [onTap] — callback invoked with the tapped item's index.
  /// [onLongPress] — callback invoked with the long-pressed item's index.
  /// [semanticLabelBuilder] — accessibility label for each item.
  /// [mouseCursor] — mouse cursor on hover.
  /// [focusColor] — focus indicator color.
  /// [hoverColor] — hover indicator color.
  /// [onFocusChange] — focus state change callback.
  /// [border] — border drawn around each card.
  /// [elevation] — card elevation (default: `0`).
  /// [splashColor] — ink splash color.
  /// [highlightColor] — ink highlight color.
  /// [splashFactory] — custom ink splash factory.
  /// [enableFeedback] — whether to provide feedback on tap (default: `true`).
  /// [haptic] — haptic feedback level (default: [M3EHapticFeedback.none]).
  /// [emptyBuilder] — widget shown when the list is empty.
  const M3ECardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 3.0,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.onFocusChange,
    this.border,
    this.elevation = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = M3EHapticFeedback.none,
    this.emptyBuilder,
  }) : _isBuilder = false,
       controller = null,
       physics = null,
       shrinkWrap = false,
       listPadding = null,
       addAutomaticKeepAlives = true,
       addRepaintBoundaries = true,
       addSemanticIndexes = true;

  /// Creates a [M3ECardList] that uses a [ListView.builder] internally.
  ///
  /// Best for long or infinite lists where items should be built lazily.
  ///
  /// [itemCount] — number of items in the list.
  /// [itemBuilder] — builds a widget for each index.
  /// [outerRadius] — radius for outer corners (default: `24.0`).
  /// [innerRadius] — radius for inner corners (default: `4.0`).
  /// [gap] — space between adjacent items (default: `3.0`).
  /// [color] — background color (default: [ColorScheme.surfaceContainerHighest]).
  /// [padding] — inner padding for each card (default: `EdgeInsets.all(12.0)`).
  /// [margin] — outer margin around the entire list.
  /// [onTap] — callback invoked with the tapped item's index.
  /// [onLongPress] — callback invoked with the long-pressed item's index.
  /// [semanticLabelBuilder] — accessibility label for each item.
  /// [mouseCursor] — mouse cursor on hover.
  /// [focusColor] — focus indicator color.
  /// [hoverColor] — hover indicator color.
  /// [onFocusChange] — focus state change callback.
  /// [border] — border drawn around each card.
  /// [elevation] — card elevation (default: `0`).
  /// [splashColor] — ink splash color.
  /// [highlightColor] — ink highlight color.
  /// [splashFactory] — custom ink splash factory.
  /// [enableFeedback] — whether to provide feedback on tap (default: `true`).
  /// [haptic] — haptic feedback level (default: [M3EHapticFeedback.none]).
  /// [controller] — scroll position control.
  /// [physics] — scroll physics (e.g. [BouncingScrollPhysics]).
  /// [shrinkWrap] — size to children instead of viewport (default: `false`).
  /// [listPadding] — padding around the scrollable list content.
  /// [addAutomaticKeepAlives] — wrap children in [AutomaticKeepAlive] (default: `true`).
  /// [addRepaintBoundaries] — wrap children in [RepaintBoundary] (default: `true`).
  /// [addSemanticIndexes] — wrap children in [IndexedSemantics] (default: `true`).
  /// [emptyBuilder] — widget shown when the list is empty.
  const M3ECardList.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 3.0,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.onFocusChange,
    this.border,
    this.elevation = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = M3EHapticFeedback.none,
    this.emptyBuilder,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.listPadding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
  }) : _isBuilder = true;

  /// Creates a static [M3ECardList] from a list of pre-built widgets.
  ///
  /// [children] — the list of card contents.
  /// [outerRadius] — radius for outer corners (default: `24.0`).
  /// [innerRadius] — radius for inner corners (default: `4.0`).
  /// [gap] — space between adjacent items (default: `3.0`).
  /// [color] — background color (default: [ColorScheme.surfaceContainerHighest]).
  /// [padding] — inner padding for each card (default: `EdgeInsets.all(12.0)`).
  /// [margin] — outer margin around the entire list.
  /// [onTap] — callback invoked with the tapped item's index.
  /// [onLongPress] — callback invoked with the long-pressed item's index.
  /// [mouseCursor] — mouse cursor on hover.
  /// [focusColor] — focus indicator color.
  /// [hoverColor] — hover indicator color.
  /// [onFocusChange] — focus state change callback.
  /// [border] — border drawn around each card.
  /// [elevation] — card elevation (default: `0`).
  /// [splashColor] — ink splash color.
  /// [highlightColor] — ink highlight color.
  /// [splashFactory] — custom ink splash factory.
  /// [enableFeedback] — whether to provide feedback on tap (default: `true`).
  /// [haptic] — haptic feedback level (default: [M3EHapticFeedback.none]).
  /// [emptyBuilder] — widget shown when the list is empty.
  factory M3ECardList.of({
    required List<Widget> children,
    double outerRadius = 24.0,
    double innerRadius = 4.0,
    double gap = 3.0,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    void Function(int index)? onTap,
    void Function(int index)? onLongPress,
    MouseCursor? mouseCursor,
    Color? focusColor,
    Color? hoverColor,
    void Function(int index, bool)? onFocusChange,
    BorderSide? border,
    double elevation = 0,
    Color? splashColor,
    Color? highlightColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool enableFeedback = true,
    M3EHapticFeedback haptic = M3EHapticFeedback.none,
    Widget? emptyBuilder,
  }) {
    return M3ECardList(
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      color: color,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      onFocusChange: onFocusChange,
      border: border,
      elevation: elevation,
      splashColor: splashColor,
      highlightColor: highlightColor,
      splashFactory: splashFactory,
      enableFeedback: enableFeedback,
      haptic: haptic,
      emptyBuilder: emptyBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && emptyBuilder != null) {
      return margin != null
          ? Padding(padding: margin!, child: emptyBuilder!)
          : emptyBuilder!;
    }

    if (_isBuilder) {
      final Widget list = ListView.builder(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: listPadding,
        itemCount: itemCount,
        itemBuilder: _buildItemBuilder,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );

      return margin != null ? Padding(padding: margin!, child: list) : list;
    }

    final Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) => _buildItem(context, index, itemCount),
      ),
    );

    return margin != null ? Padding(padding: margin!, child: column) : column;
  }

  Widget _buildItemBuilder(BuildContext context, int index) {
    return _buildCard(context, index, itemCount, itemBuilder(context, index));
  }

  Widget _buildItem(BuildContext context, int index, int total) {
    return _buildCard(context, index, total, itemBuilder(context, index));
  }

  Widget _buildCard(
    BuildContext context,
    int index,
    int total,
    Widget content,
  ) {
    return M3ECard(
      index: index,
      position: calculateCardPosition(index, total),
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      color: color,
      padding: padding,
      onTap: onTap,
      onLongPress: onLongPress,
      semanticLabel: semanticLabelBuilder?.call(index),
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      onFocusChange: onFocusChange != null
          ? (focused) => onFocusChange!(index, focused)
          : null,
      border: border,
      elevation: elevation,
      splashColor: splashColor,
      highlightColor: highlightColor,
      splashFactory: splashFactory,
      enableFeedback: enableFeedback,
      haptic: haptic,
      child: itemBuilder(context, index),
    );
  }
}
