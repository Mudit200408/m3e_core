import 'package:flutter/material.dart';

/// A data container used to configure items for [M3EExpandableCardList],
/// [M3EExpandableCardColumn], and [SliverM3EExpandableCardList].
///
/// This class allows you to quickly define the content of an expandable card without
/// writing custom builders. It handles the layout of common elements like titles,
/// subtitles, and leading/trailing icons automatically.
///
/// ### Example:
/// ```dart
/// M3EExpandableCardList(
///   data: [
///     M3EExpandableData(
///       title: 'Battery level low',
///       subtitle: 'Plug in your device to avoid losing your work.',
///       leading: const Icon(Icons.battery_alert),
///       body: Column(
///         children: [
///           const Text('Your battery is at 10% and will run out soon.'),
///           TextButton(onPressed: () {}, child: const Text('Enable battery saver')),
///         ],
///       ),
///     ),
///   ],
/// )
/// ```
class M3EExpandableData {
  /// The main title text shown in the header.
  final String title;

  /// Optional custom text styles for the title.
  ///
  /// Provide a list of 2 styles: `[collapsedStyle, expandedStyle]` to enable
  /// smooth lerp animation between them.
  ///
  /// Provide a list of 1 style to use the same style for both states (no animation).
  ///
  /// When null, defaults to [Theme.of(context).textTheme.titleSmall] with
  /// [FontWeight.w500] (collapsed) and [FontWeight.bold] (expanded).
  final List<TextStyle>? titleStyle;

  /// An optional text-only subtitle.
  ///
  /// This text is displayed in the header when collapsed (often ellipsized)
  /// and smoothly transitions its style and layout as the card expands.
  final String? subtitle;

  /// Optional custom text styles for the subtitle.
  ///
  /// Provide a list of 2 styles: `[collapsedStyle, expandedStyle]` to enable
  /// smooth lerp animation between them.
  ///
  /// Provide a list of 1 style to use the same style for both states (no animation).
  ///
  /// When null, defaults to [Theme.of(context).textTheme.bodyMedium].
  final List<TextStyle>? subtitleStyle;

  /// Maximum number of lines for the subtitle when collapsed.
  ///
  /// Defaults to 1. Set to a higher number to show more lines in collapsed state.
  final int? subtitleMaxLines;

  /// A custom widget to display in the expanded body.
  ///
  /// This widget will automatically fade in smoothly during expansion.
  /// Use this for complex content like rows of buttons, chips, or forms.
  ///
  /// **Note**: Avoid storing complex stateful widgets directly here as they
  /// are stored as instances. If you need a fully dynamic/rebuilding body,
  /// use the [bodyBuilder] property instead.
  final Widget? body;

  /// A builder function to create the body content dynamically.
  ///
  /// This is preferred for complex or stateful content as it allows the body
  /// to be rebuilt only when necessary.
  ///
  /// If both [body] and [bodyBuilder] are provided, [bodyBuilder] takes precedence.
  final Widget Function(BuildContext context)? bodyBuilder;

  /// An optional leading widget for the header (e.g., an [Icon] or [CircleAvatar]).
  final Widget? leading;

  /// An optional trailing widget for the header.
  ///
  /// Note: If the [M3EExpandableStyle] has an expansion icon configured,
  /// it will be placed alongside or instead of this trailing widget depending
  /// on the [IconPlacement].
  final Widget? trailing;

  /// Creates a data configuration for an expandable item.
  const M3EExpandableData({
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.subtitleMaxLines,
    this.body,
    this.bodyBuilder,
    this.leading,
    this.trailing,
  }) : assert(
         subtitle != null || body != null || bodyBuilder != null,
         'Provide either a subtitle (text), a body (widget), or a bodyBuilder to display content.',
       );
}
