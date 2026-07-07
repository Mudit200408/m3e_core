// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import '../../common/m3e_common.dart';
import '../m3e_floating_toolbar_theme.dart';

/// Styling and animation overrides for Material 3 Expressive floating toolbars.
///
/// Pass an instance to the `decoration` parameter to customize colors, shape,
/// padding, and motion.
@immutable
class M3EFloatingToolbarDecoration {
  /// Custom colors for the toolbar and its FAB.
  final M3EFloatingToolbarColors? colors;

  /// Custom padding inside the toolbar container.
  final EdgeInsetsGeometry? contentPadding;

  /// Custom border shape of the toolbar.
  final ShapeBorder? shape;

  /// Spring physics configuration.
  final M3EMotion? motion;

  /// Elevation when expanded.
  final double? expandedShadowElevation;

  /// Elevation when collapsed.
  final double? collapsedShadowElevation;

  const M3EFloatingToolbarDecoration({
    this.colors,
    this.contentPadding,
    this.shape,
    this.motion,
    this.expandedShadowElevation,
    this.collapsedShadowElevation,
  });

  /// Creates a copy of this decoration with the given fields replaced.
  M3EFloatingToolbarDecoration copyWith({
    M3EFloatingToolbarColors? colors,
    EdgeInsetsGeometry? contentPadding,
    ShapeBorder? shape,
    M3EMotion? motion,
    double? expandedShadowElevation,
    double? collapsedShadowElevation,
  }) {
    return M3EFloatingToolbarDecoration(
      colors: colors ?? this.colors,
      contentPadding: contentPadding ?? this.contentPadding,
      shape: shape ?? this.shape,
      motion: motion ?? this.motion,
      expandedShadowElevation:
          expandedShadowElevation ?? this.expandedShadowElevation,
      collapsedShadowElevation:
          collapsedShadowElevation ?? this.collapsedShadowElevation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EFloatingToolbarDecoration &&
          colors == other.colors &&
          contentPadding == other.contentPadding &&
          shape == other.shape &&
          motion == other.motion &&
          expandedShadowElevation == other.expandedShadowElevation &&
          collapsedShadowElevation == other.collapsedShadowElevation;

  @override
  int get hashCode => Object.hash(
    colors,
    contentPadding,
    shape,
    motion,
    expandedShadowElevation,
    collapsedShadowElevation,
  );
}
