import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final EdgeInsetsGeometry? itemPadding;

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

  /// The level of haptic feedback on tap.
  ///
  /// * 0 -> No haptics (default)
  /// * 1 -> Light impact
  /// * 2 -> Medium impact
  /// * 3 -> Heavy impact
  final int haptic;

  /// Creates a [M3ECardColumn].
  const M3ECardColumn({
    super.key,
    required this.children,
    this.outerRadius = 24.0,
    this.innerRadius = 4.0,
    this.gap = 3.0,
    this.color,
    this.itemPadding,
    this.margin,
    this.onTap,
    this.border,
    this.elevation = 0,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.haptic = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(children.length, (index) {
        final bool isFirst = index == 0;
        final bool isLast = index == children.length - 1;
        final bool isSingle = children.length == 1;

        BorderRadius borderRadius;
        if (isSingle) {
          borderRadius = BorderRadius.circular(outerRadius);
        } else if (isFirst) {
          borderRadius = BorderRadius.vertical(
            top: Radius.circular(outerRadius),
            bottom: Radius.circular(innerRadius),
          );
        } else if (isLast) {
          borderRadius = BorderRadius.vertical(
            top: Radius.circular(innerRadius),
            bottom: Radius.circular(outerRadius),
          );
        } else {
          borderRadius = BorderRadius.circular(innerRadius);
        }

        return RepaintBoundary(
          child: Padding(
            padding: margin ?? EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : gap),
              child: Material(
                elevation: elevation,
                color:
                    color ??
                    Theme.of(context).colorScheme.surfaceContainerHighest,
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
                  onTap: onTap != null
                      ? () {
                          onTap!(index);
                          switch (haptic) {
                            case 1:
                              HapticFeedback.lightImpact();
                              break;
                            case 2:
                              HapticFeedback.mediumImpact();
                              break;
                            case 3:
                              HapticFeedback.heavyImpact();
                              break;
                            case 0:
                            default:
                              break;
                          }
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    padding: itemPadding ?? const EdgeInsets.all(12),
                    child: children[index],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
