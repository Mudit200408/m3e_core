// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'm3e_bottom_sheet_style.dart';

/// Theme extension for configuring default styles of [M3EBottomSheet].
@immutable
class M3EBottomSheetThemeData extends ThemeExtension<M3EBottomSheetThemeData> {
  /// Creates an [M3EBottomSheetThemeData].
  const M3EBottomSheetThemeData({this.style = const M3EBottomSheetStyle()});

  /// The default style for [M3EBottomSheet] widgets.
  final M3EBottomSheetStyle? style;

  @override
  M3EBottomSheetThemeData copyWith({M3EBottomSheetStyle? style}) {
    return M3EBottomSheetThemeData(style: style ?? this.style);
  }

  @override
  M3EBottomSheetThemeData lerp(
    ThemeExtension<M3EBottomSheetThemeData>? other,
    double t,
  ) {
    if (other is! M3EBottomSheetThemeData) return this;
    return M3EBottomSheetThemeData(
      style: M3EBottomSheetStyle.lerp(style, other.style, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EBottomSheetThemeData &&
          runtimeType == other.runtimeType &&
          style == other.style;

  @override
  int get hashCode => style.hashCode;
}

/// An inherited widget that defines the visual properties for [M3EBottomSheet]s
/// in this widget's subtree.
class M3EBottomSheetTheme extends InheritedTheme {
  /// Creates an [M3EBottomSheetTheme].
  const M3EBottomSheetTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The properties used to configure child [M3EBottomSheet] widgets.
  final M3EBottomSheetThemeData data;

  /// Returns the [data] from the closest [M3EBottomSheetTheme] ancestor, or
  /// looks up the [M3EBottomSheetThemeData] extension on [Theme.of], or defaults to
  /// a new [M3EBottomSheetThemeData].
  static M3EBottomSheetThemeData of(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<M3EBottomSheetTheme>();
    return theme?.data ??
        Theme.of(context).extension<M3EBottomSheetThemeData>() ??
        const M3EBottomSheetThemeData();
  }

  @override
  bool updateShouldNotify(M3EBottomSheetTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return M3EBottomSheetTheme(data: data, child: child);
  }
}
