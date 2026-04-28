import 'package:flutter/material.dart';
import '../common/m3e_common.dart';
import 'm3e_expandable_style.dart';

/// Defines the visual properties and motion configurations for expandable cards.
///
/// This can be used to set global defaults for all [M3EExpandableCardList],
/// [M3EExpandableCardColumn], and [SliverM3EExpandableCardList] widgets in an app.
@immutable
class M3EExpandableThemeData {
  /// The default visual style for expandable cards.
  final M3EExpandableStyle style;

  /// The default motion for expanding cards.
  final M3EMotion expandMotion;

  /// The default motion for collapsing cards.
  final M3EMotion collapseMotion;

  /// Whether multiple cards can be expanded at once by default.
  final bool allowMultipleExpanded;

  const M3EExpandableThemeData({
    this.style = const M3EExpandableStyle(),
    this.expandMotion = M3EMotion.standardSpatialFast,
    this.collapseMotion = M3EMotion.standardSpatialFast,
    this.allowMultipleExpanded = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EExpandableThemeData &&
          style == other.style &&
          expandMotion == other.expandMotion &&
          collapseMotion == other.collapseMotion &&
          allowMultipleExpanded == other.allowMultipleExpanded;

  @override
  int get hashCode =>
      Object.hash(style, expandMotion, collapseMotion, allowMultipleExpanded);
}

/// An inherited widget that provides [M3EExpandableThemeData] to its descendants.
class M3EExpandableTheme extends InheritedWidget {
  final M3EExpandableThemeData data;

  const M3EExpandableTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static M3EExpandableThemeData of(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<M3EExpandableTheme>();
    return theme?.data ??
        const M3EExpandableThemeData(
          expandMotion: M3EMotion.standardSpatialFast,
          collapseMotion: M3EMotion.standardSpatialFast,
        );
  }

  @override
  bool updateShouldNotify(M3EExpandableTheme oldWidget) =>
      data != oldWidget.data;
}
