// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../../common/m3e_common.dart';
import '../m3e_bottom_sheet.dart';
import '../style/m3e_bottom_sheet_style.dart';

/// Shows a Material 3 Expressive modal bottom sheet with spring entrance motion.
///
/// This function is a drop-in replacement for Flutter's standard
/// [showModalBottomSheet], providing:
/// - Expressive spring physics entrance and exit driven by [motor].
/// - Grounded bottom anchoring that eliminates gaps or detachment during overshoot.
/// - Full parameter compatibility with standard Flutter modal bottom sheets.
/// - Automatic support for [M3EBottomSheetStyle] and [M3EBottomSheet].
///
/// Example:
/// ```dart
/// showM3EModalBottomSheet(
///   context: context,
///   builder: (context) => M3EBottomSheet(
///     title: const Text('Theme Settings'),
///     child: MyContent(),
///   ),
/// );
/// ```
Future<T?> showM3EModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = true,
  double scrollControlDisabledMaxHeightRatio = 9.0 / 16.0,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  AnimationStyle? sheetAnimationStyle,
  M3EBottomSheetStyle? style,
  M3EMotion? motion,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: false, // Managed by M3EBottomSheet
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint,
    sheetAnimationStyle: sheetAnimationStyle,
    builder: (BuildContext sheetContext) {
      final builtChild = builder(sheetContext);

      // If the child is already an M3EBottomSheet, apply any additional style overrides
      if (builtChild is M3EBottomSheet) {
        if (style != null || backgroundColor != null || elevation != null) {
          return M3EBottomSheet(
            key: builtChild.key,
            style: (builtChild.style ?? style)?.copyWith(
              backgroundColor: backgroundColor,
              elevation: elevation,
              motion: motion,
            ),
            showDragHandle: builtChild.showDragHandle,
            dragHandle: builtChild.dragHandle,
            title: builtChild.title,
            actions: builtChild.actions,
            padding: builtChild.padding,
            backgroundColor: backgroundColor ?? builtChild.backgroundColor,
            animateEntrance: builtChild.animateEntrance,
            child: builtChild.child,
          );
        }
        return builtChild;
      }

      // Wrap standard/arbitrary widgets with M3EBottomSheet container for spring motion
      return M3EBottomSheet(
        style: style?.copyWith(
          backgroundColor: backgroundColor,
          elevation: elevation,
          motion: motion,
        ),
        showDragHandle: showDragHandle ?? false,
        backgroundColor: backgroundColor,
        child: builtChild,
      );
    },
  );
}
