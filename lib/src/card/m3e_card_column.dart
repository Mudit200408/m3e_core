import 'package:flutter/material.dart';

import '../common/m3e_common.dart';
import 'm3e_card_widget.dart';

/// A Material 3 static card column with dynamically rounded corners.
///
/// `M3ECardColumn` renders a vertical column of items, where the first and last
/// items automatically have a larger outer radius, and the inner items have
/// a smaller inner radius, adhering to Material 3's expressive list design.
///
/// This is an alternative to [M3ECardList] useful when you simply want to
/// pass a `List<Widget>` consisting of pre-built children.
class M3ECardColumn extends StatelessWidget {
  /// The list of static children to display in the column.
  final List<Widget> children;

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

  /// The inner padding applied to each child.
  ///
  /// Defaults to `EdgeInsets.all(12.0)`.
  final EdgeInsetsGeometry? padding;

  /// The outer margin applied around the entire group of cards.
  ///
  /// Defaults to [EdgeInsets.zero]. The [gap] parameter handles the space
  /// between individual cards.
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

  /// Widget displayed when the column is empty.
  ///
  /// If null, [SizedBox.shrink] is shown.
  final Widget? emptyBuilder;

  /// Creates a [M3ECardColumn].
  ///
  /// [children] — the list of pre-built card widgets.
  /// [outerRadius] — radius for outer corners (default: `24.0`).
  /// [innerRadius] — radius for inner corners (default: `4.0`).
  /// [gap] — space between adjacent items (default: `3.0`).
  /// [color] — background color (default: [ColorScheme.surfaceContainerHighest]).
  /// [padding] — inner padding for each card (default: `EdgeInsets.all(12.0)`).
  /// [margin] — outer margin around the entire column.
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
  /// [emptyBuilder] — widget shown when the column is empty.
  const M3ECardColumn({
    super.key,
    required this.children,
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
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      final empty = emptyBuilder ?? const SizedBox.shrink();
      return margin != null ? Padding(padding: margin!, child: empty) : empty;
    }

    final total = children.length;

    final Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
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
          child: children[index],
        );
      }),
    );

    return margin != null ? Padding(padding: margin!, child: column) : column;
  }
}
