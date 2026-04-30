import 'package:flutter/material.dart';
import '../common/m3e_common.dart';

/// Internal helper to calculate [M3ECardPosition] based on index and total.
M3ECardPosition calculateCardPosition(int index, int total) => total == 1
    ? M3ECardPosition.single
    : index == 0
    ? M3ECardPosition.first
    : index == total - 1
    ? M3ECardPosition.last
    : M3ECardPosition.middle;

/// Internal helper to calculate [BorderRadius] based on [M3ECardPosition].
BorderRadius calculateCardRadius({
  required M3ECardPosition position,
  required double outerRadius,
  required double innerRadius,
}) {
  switch (position) {
    case M3ECardPosition.single:
      return BorderRadius.circular(outerRadius);
    case M3ECardPosition.first:
      return BorderRadius.vertical(
        top: Radius.circular(outerRadius),
        bottom: Radius.circular(innerRadius),
      );
    case M3ECardPosition.last:
      return BorderRadius.vertical(
        top: Radius.circular(innerRadius),
        bottom: Radius.circular(outerRadius),
      );
    case M3ECardPosition.middle:
      return BorderRadius.circular(innerRadius);
  }
}

/// A Material 3 Expressive card widget with flexible corner radii and interaction.
///
/// This is the building block for [M3ECardList] and [SliverM3ECardList]. It can
/// be used directly in a [ListView.builder] to create custom lazy-loading lists.
class M3ECard extends StatelessWidget {
  /// The index of the item (passed to the [onTap] callback).
  final int index;

  /// The logical position of the card in a sequence (e.g. first, middle, last).
  ///
  /// This determines which corners are "outer" (more rounded) and which are
  /// "inner" (sharper).
  final M3ECardPosition position;

  /// The primary content of the card.
  final Widget child;

  /// The radius used for "outer" corners.
  final double outerRadius;

  /// The radius used for "inner" corners.
  final double innerRadius;

  /// The vertical space below this card.
  ///
  /// Ignored if [position] is [M3ECardPosition.last] or [M3ECardPosition.single].
  final double gap;

  /// The background color of the card.
  final Color? color;

  /// The internal padding around the [child].
  ///
  /// Defaults to `EdgeInsets.all(12.0)`.
  final EdgeInsetsGeometry? padding;

  /// Optional callback triggered when the card is tapped.
  final void Function(int index)? onTap;

  /// Optional callback triggered when the card is long-pressed.
  final void Function(int index)? onLongPress;

  /// Optional semantic label for accessibility (screen readers).
  ///
  /// When provided, the card will announce this label to assistive technologies.
  final String? semanticLabel;

  /// The cursor for a mouse pointer when it enters the card's bounds.
  ///
  /// Defaults to [SystemMouseCursors.click] when [onTap] or [onLongPress]
  /// is set, otherwise [SystemMouseCursors.basic].
  final MouseCursor? mouseCursor;

  /// The color to use when the card is focused by keyboard navigation.
  final Color? focusColor;

  /// The color to use when the card is hovered by a mouse pointer.
  final Color? hoverColor;

  /// Called when the focus state of the card changes.
  final void Function(bool)? onFocusChange;

  /// Optional border drawn on the card.
  final BorderSide? border;

  /// The elevation of the card.
  final double elevation;

  /// The ink splash color.
  final Color? splashColor;

  /// The ink highlight color.
  final Color? highlightColor;

  /// Custom ink splash factory.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether to provide haptic/acoustic feedback on tap.
  ///
  /// Defaults to `true`.
  final bool enableFeedback;

  /// The haptic feedback level to apply on tap.
  ///
  /// Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  /// Creates a Material 3 Expressive card.
  const M3ECard({
    super.key,
    required this.index,
    required this.position,
    required this.child,
    required this.outerRadius,
    required this.innerRadius,
    required this.gap,
    this.color,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
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
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = calculateCardRadius(
      position: position,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
    );

    final bool isLast =
        position == M3ECardPosition.last || position == M3ECardPosition.single;

    final hasInteraction = onTap != null || onLongPress != null;

    Widget card = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : gap),
      child: Material(
        elevation: elevation,
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: splashColor,
          highlightColor: highlightColor,
          splashFactory: splashFactory,
          enableFeedback: enableFeedback,
          focusColor: focusColor,
          hoverColor: hoverColor,
          mouseCursor:
              mouseCursor ??
              (hasInteraction
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic),
          onTap: onTap != null
              ? () {
                  onTap!(index);
                  haptic.apply();
                }
              : null,
          onLongPress: onLongPress != null ? () => onLongPress!(index) : null,
          onFocusChange: onFocusChange,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );

    if (semanticLabel != null) {
      card = Semantics(
        label: semanticLabel,
        button: hasInteraction,
        child: card,
      );
    }

    return card;
  }
}
