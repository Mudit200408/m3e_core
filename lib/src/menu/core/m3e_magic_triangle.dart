// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

/// Implements the "Magic Triangle" geometric hit-testing algorithm for cascading submenus.
///
/// Ref: Material 3 Accessibility Guideline & Video (`GM3_Menus_Accesibility 06_IA_v02.mp4`).
/// When moving the cursor diagonally from a parent trigger item to its opened submenu,
/// the path may intersect adjacent sibling items. The magic triangle creates a safe
/// transit zone to avoid premature closing of the submenu.
class M3EMagicTriangle {
  /// Evaluates whether point [p] lies inside the triangle formed by [a], [b], and [c].
  static bool containsPoint(Offset p, Offset a, Offset b, Offset c) {
    final double d1 = _sign(p, a, b);
    final double d2 = _sign(p, b, c);
    final double d3 = _sign(p, c, a);

    final bool hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    final bool hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(hasNeg && hasPos);
  }

  /// Calculates whether the cursor at [cursorPosition] is currently travelling
  /// inside the safe triangle connecting [triggerPosition] to the [submenuBounds].
  static bool isCursorInSubmenuTransitZone({
    required Offset cursorPosition,
    required Rect submenuBounds,
    required bool isSubmenuOnRight,
    Offset? triggerPosition,
  }) {
    if (triggerPosition != null) {
      // If moving in opposite direction (away from submenu), not in transit.
      if (isSubmenuOnRight && cursorPosition.dx < triggerPosition.dx) {
        return false;
      }
      if (!isSubmenuOnRight && cursorPosition.dx > triggerPosition.dx) {
        return false;
      }
    }

    final Offset origin =
        triggerPosition ??
        (isSubmenuOnRight
            ? Offset(
                submenuBounds.left - 40,
                submenuBounds.top + submenuBounds.height / 2,
              )
            : Offset(
                submenuBounds.right + 40,
                submenuBounds.top + submenuBounds.height / 2,
              ));

    final Offset topCorner = isSubmenuOnRight
        ? submenuBounds.topLeft
        : submenuBounds.topRight;
    final Offset bottomCorner = isSubmenuOnRight
        ? submenuBounds.bottomLeft
        : submenuBounds.bottomRight;

    return containsPoint(cursorPosition, origin, topCorner, bottomCorner);
  }

  static double _sign(Offset p1, Offset p2, Offset p3) {
    return (p1.dx - p3.dx) * (p2.dy - p3.dy) -
        (p2.dx - p3.dx) * (p1.dy - p3.dy);
  }
}
