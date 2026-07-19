// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:m3e_core/src/shapes/enums/shapes.dart';
import 'm3e_loading_indicator.dart';

/// A Material Design contained loading indicator.
///
/// This version of the loading indicator is enclosed within a container.
/// By default, the container color is [ColorScheme.primaryContainer] and
/// the loading indicator color is [ColorScheme.onPrimaryContainer].
class M3EContainedLoadingIndicator extends StatelessWidget {
  /// Defines the sequence of shapes this loading indicator will morph between.
  final List<Shapes>? shapes;

  /// The padding inside the container around the loading indicator.
  /// If null, defaults to 16.0 on all sides.
  final EdgeInsetsGeometry? padding;

  /// The width of the container. If null, it wraps the content or defaults.
  final double? width;

  /// The height of the container. If null, it wraps the content or defaults.
  final double? height;

  /// The background color of the container.
  /// If null, defaults to [ColorScheme.primaryContainer].
  final Color? containerColor;

  /// The color of the loading indicator.
  /// If null, defaults to [ColorScheme.onPrimaryContainer].
  final Color? indicatorColor;

  /// The border radius of the container.
  /// If null, defaults to a fully rounded circular container ([BorderRadius.circular(9999.0)]).
  final BorderRadiusGeometry? borderRadius;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Semantic value for accessibility.
  final String? semanticsValue;

  const M3EContainedLoadingIndicator({
    super.key,
    this.shapes,
    this.padding,
    this.width,
    this.height,
    this.containerColor,
    this.indicatorColor,
    this.borderRadius,
    this.semanticsLabel,
    this.semanticsValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color effectiveContainerColor =
        containerColor ?? theme.colorScheme.primaryContainer;
    final Color effectiveIndicatorColor =
        indicatorColor ?? theme.colorScheme.onPrimaryContainer;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.all(8.0);

    final resolvedPadding = effectivePadding.resolve(
      Directionality.maybeOf(context),
    );
    final BoxConstraints? innerConstraints = (width != null || height != null)
        ? BoxConstraints(
            minWidth: width != null
                ? (width! - resolvedPadding.horizontal).clamp(
                    0,
                    double.infinity,
                  )
                : 48.0,
            maxWidth: width != null
                ? (width! - resolvedPadding.horizontal).clamp(
                    0,
                    double.infinity,
                  )
                : 48.0,
            minHeight: height != null
                ? (height! - resolvedPadding.vertical).clamp(0, double.infinity)
                : 48.0,
            maxHeight: height != null
                ? (height! - resolvedPadding.vertical).clamp(0, double.infinity)
                : 48.0,
          )
        : null;

    return Container(
      width: width,
      height: height,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveContainerColor,
        borderRadius: borderRadius ?? BorderRadius.circular(9999.0),
      ),
      child: M3ELoadingIndicator(
        shapes: shapes,
        color: effectiveIndicatorColor,
        constraints: innerConstraints,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}
