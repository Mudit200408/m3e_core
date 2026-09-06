import 'package:material_ui/material_ui.dart';

import '../common/m3e_common.dart';
import 'internal/_dismissible_focus_ring.dart';

/// Represents an individual action button revealed when swiping a list item in
/// an M3E dismissible or swipeable list.
///
/// In Material 3 Expressive, swipeable list items reveal a row of vertical pill
/// action buttons with visual hierarchy (e.g. secondary tonal actions + primary filled action).
/// If [isPrimary] is `true`, swiping past the full-swipe threshold automatically
/// triggers this action.
class M3ESwipeAction {
  /// The icon widget representing this action.
  final Widget icon;

  /// Optional label text displayed below the icon if desired.
  final Widget? label;

  /// The background color for the action button.
  final Color? backgroundColor;

  /// The foreground color (icon & label color).
  final Color? foregroundColor;

  /// Callback executed when this action button is tapped or triggered by full swipe.
  final VoidCallback? onTap;

  /// Whether this action is the primary end-aligned action.
  ///
  /// The primary action is placed at the outer extremity and is automatically
  /// fired when a full swipe exceeds the dismiss threshold.
  final bool isPrimary;

  /// Width of the vertical pill button. Defaults to `52.0`.
  final double width;

  /// Optional explicit height of the button. If `null`, inherits the card slot height.
  final double? height;

  /// Custom border radius for the action button. Defaults to full pill ([BorderRadius.circular(100)]).
  final BorderRadiusGeometry? borderRadius;

  /// Haptic feedback triggered when this action is tapped.
  final M3EHapticFeedback haptic;

  /// Creates a Material 3 Expressive swipe action.
  const M3ESwipeAction({
    required this.icon,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.isPrimary = false,
    this.width = 52.0,
    this.height,
    this.borderRadius,
    this.haptic = M3EHapticFeedback.medium,
  });

  /// Builds the vertical pill action button.
  Widget buildButton(
    BuildContext context, {
    required VoidCallback? onTriggered,
    FocusNode? focusNode,
    KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final effectiveBg =
        backgroundColor ?? (isPrimary ? cs.primary : cs.secondaryContainer);
    final effectiveFg =
        foregroundColor ?? (isPrimary ? cs.onPrimary : cs.onSecondaryContainer);

    final effectiveRadius =
        (borderRadius as BorderRadius?) ?? BorderRadius.circular(100);

    if (focusNode != null && onKeyEvent != null) {
      focusNode.onKeyEvent = onKeyEvent;
    }

    void handlePress() {
      haptic.apply();
      onTap?.call();
      onTriggered?.call();
    }

    Widget buttonContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          focusNode: focusNode,
          splashFactory: InkSparkle.splashFactory,
          onTap: handlePress,
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: effectiveFg, size: 24.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: label != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon,
                          const SizedBox(height: 2.0),
                          DefaultTextStyle(
                            style:
                                (theme.textTheme.labelSmall ??
                                        const TextStyle())
                                    .copyWith(
                                      color: effectiveFg,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                            child: label!,
                          ),
                        ],
                      )
                    : icon,
              ),
            ),
          ),
        ),
      ),
    );

    if (focusNode != null) {
      final ringColor = isPrimary
          ? (cs.outline.a > 0 ? cs.outline : cs.onSurface)
          : cs.primary;

      return ListenableBuilder(
        listenable: focusNode,
        builder: (context, child) {
          return DismissibleFocusRing(
            focused: focusNode.hasFocus,
            radius: effectiveRadius,
            gap: 0.0,
            width: 2.0,
            color: ringColor,
            child: child!,
          );
        },
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}
