import 'package:material_ui/material_ui.dart';

/// A Material 3 standardized list item slot widget.
///
/// `M3EListItem` provides structured layout slots adhering to the Material 3
/// specification for list items:
/// - [leading]: Leading visual (icon, avatar, image, or selection control).
/// - [headline]: Primary headline text or widget.
/// - [supportingText]: Secondary text describing the item.
/// - [overline]: Tertiary label positioned above the headline.
/// - [trailing]: Trailing metadata, icon, control, or drag handle.
///
/// Automatic layout rules:
/// - One-line item (headline only): `56dp` standard height, middle-aligned.
/// - Two-line item (headline + supportingText or overline): `72dp` standard height, middle-aligned.
/// - Three-line item (headline + supportingText + overline): `88dp` standard height, **top-aligned**.
class M3EListItem extends StatelessWidget {
  /// Leading widget (e.g. [Icon], [CircleAvatar], [Checkbox], or thumbnail).
  final Widget? leading;

  /// Primary headline widget (typically a [Text]).
  final Widget headline;

  /// Secondary supporting text widget.
  final Widget? supportingText;

  /// Tertiary overline widget positioned above the [headline].
  final Widget? overline;

  /// Trailing widget (e.g. metadata text, [Icon], [Switch], or drag handle).
  final Widget? trailing;

  /// Whether this item represents a three-line layout.
  ///
  /// If null, automatically inferred as true if both [supportingText] and [overline]
  /// are provided. When true, [leading] and [trailing] are top-aligned rather than
  /// centered, matching the Material 3 specification.
  final bool? isThreeLine;

  /// Padding applied around the list item content.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)` for 1/2-line
  /// and `EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)` for 3-line.
  final EdgeInsetsGeometry? contentPadding;

  /// Minimum height for the item container.
  ///
  /// Defaults to `56.0` for one-line, `72.0` for two-line, and `88.0` for three-line items.
  final double? minHeight;

  /// Space between [leading] and the text column.
  ///
  /// Defaults to `12.0` (matching M3 [ListTokens.ItemBetweenSpace]).
  final double leadingSpacing;

  /// Space between the text column and [trailing].
  ///
  /// Defaults to `12.0` (matching M3 [ListTokens.ItemBetweenSpace]).
  final double trailingSpacing;

  /// Custom text style for [headline].
  final TextStyle? headlineStyle;

  /// Custom text style for [supportingText].
  final TextStyle? supportingTextStyle;

  /// Custom text style for [overline].
  final TextStyle? overlineStyle;

  /// Whether this list item is interactive and enabled.
  ///
  /// Defaults to `true`. When false, text and visual elements are rendered
  /// with disabled opacity and colors (matching M3 disabled state specification).
  final bool enabled;

  /// Creates a Material 3 standardized list item.
  const M3EListItem({
    super.key,
    this.leading,
    required this.headline,
    this.supportingText,
    this.overline,
    this.trailing,
    this.isThreeLine,
    this.contentPadding,
    this.minHeight,
    this.leadingSpacing = 12.0,
    this.trailingSpacing = 12.0,
    this.headlineStyle,
    this.supportingTextStyle,
    this.overlineStyle,
    this.enabled = true,
  });

  bool get _effectiveIsThreeLine =>
      isThreeLine ?? (supportingText != null && overline != null);

  double get _defaultMinHeight {
    if (_effectiveIsThreeLine) return 88.0;
    if (supportingText != null || overline != null) return 72.0;
    return 56.0;
  }

  EdgeInsetsGeometry get _defaultPadding {
    if (_effectiveIsThreeLine) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
    }
    return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final headlineColor = enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final supportingColor = enabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final effectiveHeadlineStyle =
        headlineStyle ??
        (textTheme.bodyLarge ?? const TextStyle(fontSize: 16.0)).copyWith(
          color: headlineColor,
        );

    final effectiveSupportingTextStyle =
        supportingTextStyle ??
        (textTheme.bodyMedium ?? const TextStyle(fontSize: 14.0)).copyWith(
          color: supportingColor,
        );

    final effectiveOverlineStyle =
        overlineStyle ??
        (textTheme.labelSmall ?? const TextStyle(fontSize: 11.0)).copyWith(
          color: supportingColor,
        );

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (overline != null)
          DefaultTextStyle(
            style: effectiveOverlineStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: overline!,
          ),
        DefaultTextStyle(
          style: effectiveHeadlineStyle,
          maxLines: _effectiveIsThreeLine ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          child: headline,
        ),
        if (supportingText != null)
          DefaultTextStyle(
            style: effectiveSupportingTextStyle,
            maxLines: _effectiveIsThreeLine ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            child: supportingText!,
          ),
      ],
    );

    final alignment = _effectiveIsThreeLine
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;

    Widget? leadingWidget = leading;
    if (leadingWidget != null && !enabled) {
      leadingWidget = Opacity(opacity: 0.38, child: leadingWidget);
    }

    Widget? trailingWidget = trailing;
    if (trailingWidget != null && !enabled) {
      trailingWidget = Opacity(opacity: 0.38, child: trailingWidget);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight ?? _defaultMinHeight),
      child: Padding(
        padding: contentPadding ?? _defaultPadding,
        child: Row(
          crossAxisAlignment: alignment,
          children: [
            if (leadingWidget != null) ...[
              leadingWidget,
              SizedBox(width: leadingSpacing),
            ],
            Expanded(child: textColumn),
            if (trailingWidget != null) ...[
              SizedBox(width: trailingSpacing),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}
