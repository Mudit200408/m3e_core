// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';

/// Colors for the [M3EHorizontalFloatingToolbar] and [M3EVerticalFloatingToolbar] families.
@immutable
class M3EFloatingToolbarColors {
  /// Background color of the toolbar container.
  final Color toolbarContainerColor;

  /// Foreground (icon/text) color of the toolbar content.
  final Color toolbarContentColor;

  /// Background color of the floating action button container.
  final Color fabContainerColor;

  /// Foreground (icon/text) color of the floating action button content.
  final Color fabContentColor;

  const M3EFloatingToolbarColors({
    required this.toolbarContainerColor,
    required this.toolbarContentColor,
    required this.fabContainerColor,
    required this.fabContentColor,
  });

  /// Creates a copy of this [M3EFloatingToolbarColors] with the given fields replaced.
  M3EFloatingToolbarColors copyWith({
    Color? toolbarContainerColor,
    Color? toolbarContentColor,
    Color? fabContainerColor,
    Color? fabContentColor,
  }) {
    return M3EFloatingToolbarColors(
      toolbarContainerColor:
          toolbarContainerColor ?? this.toolbarContainerColor,
      toolbarContentColor: toolbarContentColor ?? this.toolbarContentColor,
      fabContainerColor: fabContainerColor ?? this.fabContainerColor,
      fabContentColor: fabContentColor ?? this.fabContentColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is M3EFloatingToolbarColors &&
        other.toolbarContainerColor == toolbarContainerColor &&
        other.toolbarContentColor == toolbarContentColor &&
        other.fabContainerColor == fabContainerColor &&
        other.fabContentColor == fabContentColor;
  }

  @override
  int get hashCode => Object.hash(
    toolbarContainerColor,
    toolbarContentColor,
    fabContainerColor,
    fabContentColor,
  );
}

/// Token defaults and helper methods for Material 3 Expressive FloatingToolbar.
abstract class M3EFloatingToolbarDefaults {
  /// Container height (horizontal) or width (vertical).
  static const double containerSize = 64.0;

  /// Default shape of the floating toolbar container.
  static const ShapeBorder containerShape = StadiumBorder();

  /// Default padding for content within the floating toolbar.
  static const EdgeInsetsGeometry contentPadding = EdgeInsets.all(8.0);

  /// Standard external padding / screen offset from edge of container.
  static const double screenOffset = 16.0;

  /// Gap distance between the toolbar and the floating action button.
  static const double toolbarToFabGap = 8.0;

  /// Distance threshold in dp to trigger scroll exit or nested scroll expansion.
  static const double scrollDistanceThreshold = 40.0;

  /// FAB size when the floating toolbar is expanded (baseline size).
  static const double fabBaselineSize = 56.0;

  /// FAB size when the floating toolbar is collapsed (medium size).
  static const double fabMediumSize = 80.0;

  /// Default shadow elevation when toolbar is expanded (no-FAB variants).
  static const double expandedElevation = 0.0;

  /// Default shadow elevation when toolbar is collapsed (no-FAB variants).
  static const double collapsedElevation = 0.0;

  /// Default shadow elevation when toolbar is expanded (with-FAB variants).
  static const double expandedElevationWithFab = 1.0;

  /// Default shadow elevation when toolbar is collapsed (with-FAB variants).
  static const double collapsedElevationWithFab = 0.0;

  /// Default layout container height for the horizontal FAB variant.
  static const double fabVariantTotalHeight = 80.0;

  /// Default layout container width for the vertical FAB variant.
  static const double fabVariantTotalWidth = 80.0;

  /// Creates a standard [M3EFloatingToolbarColors] using the active [ColorScheme].
  static M3EFloatingToolbarColors standardColors(BuildContext context) {
    final theme = Theme.of(context);
    return M3EFloatingToolbarColors(
      toolbarContainerColor: theme.colorScheme.surfaceContainer,
      toolbarContentColor: theme.colorScheme.onSurface,
      fabContainerColor: theme.colorScheme.primaryContainer,
      fabContentColor: theme.colorScheme.onPrimaryContainer,
    );
  }

  /// Creates a vibrant [M3EFloatingToolbarColors] using the active [ColorScheme].
  static M3EFloatingToolbarColors vibrantColors(BuildContext context) {
    final theme = Theme.of(context);
    return M3EFloatingToolbarColors(
      toolbarContainerColor: theme.colorScheme.primaryContainer,
      toolbarContentColor: theme.colorScheme.onPrimaryContainer,
      fabContainerColor: theme.colorScheme.tertiaryContainer,
      fabContentColor: theme.colorScheme.onTertiaryContainer,
    );
  }

  /// Helper to create a standard Floating Action Button.
  static Widget standardFab({
    required VoidCallback onPressed,
    required Widget child,
    BuildContext? context,
    Object? heroTag,
  }) {
    Color? bg;
    Color? fg;
    if (context != null) {
      bg = Theme.of(context).colorScheme.primaryContainer;
      fg = Theme.of(context).colorScheme.onPrimaryContainer;
    }
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      heroTag: heroTag,
      child: child,
    );
  }

  /// Helper to create a vibrant Floating Action Button.
  static Widget vibrantFab({
    required VoidCallback onPressed,
    required Widget child,
    BuildContext? context,
    Object? heroTag,
  }) {
    Color? bg;
    Color? fg;
    if (context != null) {
      bg = Theme.of(context).colorScheme.tertiaryContainer;
      fg = Theme.of(context).colorScheme.onTertiaryContainer;
    }
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      heroTag: heroTag,
      child: child,
    );
  }
}

/// Positions for the FAB in a horizontal floating toolbar layout.
enum M3EFloatingToolbarHorizontalFabPosition {
  /// Place the FAB on the start side of the toolbar.
  start,

  /// Place the FAB on the end side of the toolbar.
  end,
}

/// Positions for the FAB in a vertical floating toolbar layout.
enum M3EFloatingToolbarVerticalFabPosition {
  /// Place the FAB on the top side of the toolbar.
  top,

  /// Place the FAB on the bottom side of the toolbar.
  bottom,
}
