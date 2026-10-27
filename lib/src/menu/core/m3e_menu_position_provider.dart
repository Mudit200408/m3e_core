// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import '../style/m3e_menu_position.dart';
import '../style/m3e_menu_tokens.dart';

/// Computed layout position and transform origin for an M3E Menu popup.
class M3EMenuLayoutResult {
  /// The resolved top-left screen position for the menu container.
  final Offset position;

  /// Whether the menu had to flip above the anchor due to screen constraints.
  final bool isAbove;

  /// Whether the menu had to flip to the left of the anchor.
  final bool isLeft;

  /// Whether the menu covers or overlaps the anchor on screen.
  final bool isCoveringAnchor;

  /// The calculated transform origin of the popup relative to its anchor.
  final FractionalOffset transformOrigin;

  /// Left offset for Stack Positioned, or null if anchored to the right.
  final double? left;

  /// Top offset for Stack Positioned, or null if anchored to the bottom.
  final double? top;

  /// Right offset for Stack Positioned, or null if anchored to the left.
  final double? right;

  /// Bottom offset for Stack Positioned, or null if anchored to the top.
  final double? bottom;

  /// Maximum available vertical space for the menu given its anchor position.
  final double? availableHeight;

  const M3EMenuLayoutResult({
    required this.position,
    required this.isAbove,
    required this.isLeft,
    this.isCoveringAnchor = false,
    this.transformOrigin = const FractionalOffset(0.5, 0.0),
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.availableHeight,
  });
}

/// Computes optimal popup positioning and dynamic transform origins
/// adhering to Material 3 Expressive menus specifications.
abstract final class M3EMenuPositionProvider {
  /// Calculates the menu popup layout given the anchor's global bounds,
  /// the menu's size, and the enclosing window/screen size.
  ///
  /// [bottomInset] is the height of any system UI (e.g. software keyboard)
  /// that occludes the bottom of the screen. Pass
  /// `MediaQuery.viewInsetsOf(context).bottom` from the caller. The inset
  /// reduces the usable vertical space for flip decisions and available-height
  /// calculations, while keeping `Positioned.bottom` values correct (they are
  /// measured against the full Stack height, not the usable height).
  static M3EMenuLayoutResult calculate({
    required Rect anchorBounds,
    required Size menuSize,
    required Size windowSize,
    Offset alignmentOffset = Offset.zero,
    bool isSubmenu = false,
    TextDirection textDirection = TextDirection.ltr,
    M3EMenuPosition position = M3EMenuPosition.under,
    double bottomInset = 0.0,
  }) {
    const marginH = M3EMenuTokens.screenMarginHorizontal;
    const marginV = M3EMenuTokens.screenMarginVertical;

    // Usable height excludes keyboard (or other bottom system insets).
    // Used for flip decisions and available-height calculations only.
    // windowSize.height is kept for Positioned.bottom/right values.
    final double usableHeight = windowSize.height - bottomInset;

    double x;
    double y;
    bool isAbove = false;
    bool isLeft = false;

    final double anchorGap = isSubmenu ? 0.0 : M3EMenuTokens.anchorGap;

    if (position == M3EMenuPosition.over) {
      // Centre the menu on the anchor on both axes. The transform origin is
      // derived from the anchor/menu overlap below, which for a fully covered
      // anchor resolves to the anchor centre.
      x = anchorBounds.center.dx - (menuSize.width / 2) + alignmentOffset.dx;
      y = anchorBounds.center.dy - (menuSize.height / 2) + alignmentOffset.dy;
    } else if (!isSubmenu) {
      // 1. Vertical positioning for primary menus: Prefer Below anchor
      final spaceBelow =
          usableHeight - anchorBounds.bottom - anchorGap - marginV;
      final spaceAbove = anchorBounds.top - anchorGap - marginV;

      if (spaceBelow >= menuSize.height || spaceBelow >= spaceAbove) {
        y = anchorBounds.bottom + anchorGap + alignmentOffset.dy;
        isAbove = false;
      } else {
        y = anchorBounds.top - menuSize.height - anchorGap - alignmentOffset.dy;
        isAbove = true;
      }

      // 2. Horizontal positioning: Start-aligned with anchor
      if (textDirection == TextDirection.ltr) {
        x = anchorBounds.left + alignmentOffset.dx;
        if (x + menuSize.width > windowSize.width - marginH) {
          x = anchorBounds.right - menuSize.width - alignmentOffset.dx;
          isLeft = true;
        }
      } else {
        x = anchorBounds.right - menuSize.width - alignmentOffset.dx;
        if (x < marginH) {
          x = anchorBounds.left + alignmentOffset.dx;
          isLeft = false;
        }
      }
    } else {
      // Cascading Submenu positioning: Prefer to the side of the parent item
      final isRtl = textDirection == TextDirection.rtl;

      if (!isRtl) {
        // Prefer placing to the right
        if (anchorBounds.right + menuSize.width <= windowSize.width - marginH) {
          x = anchorBounds.right + alignmentOffset.dx;
          isLeft = false;
        } else {
          x = anchorBounds.left - menuSize.width - alignmentOffset.dx;
          isLeft = true;
        }
      } else {
        // Prefer placing to the left
        if (anchorBounds.left - menuSize.width >= marginH) {
          x = anchorBounds.left - menuSize.width - alignmentOffset.dx;
          isLeft = true;
        } else {
          x = anchorBounds.right + alignmentOffset.dx;
          isLeft = false;
        }
      }

      // Align top with parent item, flipping if insufficient space below
      y = anchorBounds.top + alignmentOffset.dy;
      if (y + menuSize.height > usableHeight - marginV) {
        y = anchorBounds.bottom - menuSize.height - alignmentOffset.dy;
        isAbove = true;
      }
    }

    // Clamp within window screen margins
    x = x.clamp(
      marginH,
      math.max(marginH, windowSize.width - menuSize.width - marginH),
    );
    y = y.clamp(
      marginV,
      math.max(marginV, usableHeight - menuSize.height - marginV),
    );

    final menuBounds = Rect.fromLTWH(x, y, menuSize.width, menuSize.height);
    final transformOrigin = calculateTransformOrigin(
      anchorBounds: anchorBounds,
      menuBounds: menuBounds,
    );

    final bool overlapsY =
        math.max(anchorBounds.top, menuBounds.top) <
        math.min(anchorBounds.bottom, menuBounds.bottom);
    final bool overlapsX =
        math.max(anchorBounds.left, menuBounds.left) <
        math.min(anchorBounds.right, menuBounds.right);
    final bool isCoveringAnchor = overlapsY && overlapsX;

    final double? left;
    final double? right;
    final double? top;
    final double? bottom;

    left = !isLeft ? x : null;
    right = isLeft
        ? math.max(0.0, windowSize.width - (x + menuSize.width))
        : null;

    if (position == M3EMenuPosition.over && !isSubmenu) {
      // In over mode the menu hangs from its top-left corner y. Pinning only
      // `top` lets the menu grow to its natural height; pinning `bottom` as
      // well would give it a tight height equal to the size estimate, which
      // clips content when the estimate is too small.
      top = math.max(marginV, y);
      bottom = null;
    } else if (!isSubmenu) {
      top = !isAbove
          ? math.max(
              marginV,
              anchorBounds.bottom + anchorGap + alignmentOffset.dy,
            )
          : null;
      bottom = isAbove
          ? math.max(
              marginV,
              (windowSize.height - anchorBounds.top) +
                  anchorGap +
                  alignmentOffset.dy,
            )
          : null;
    } else {
      top = !isAbove ? y : null;
      bottom = isAbove
          ? math.max(0.0, windowSize.height - (y + menuSize.height))
          : null;
    }

    final double availableHeight;
    if (position == M3EMenuPosition.over && !isSubmenu) {
      // Menu hangs from y; available space is from y to the bottom margin.
      availableHeight = math.max(0.0, usableHeight - y - marginV);
    } else if (isAbove) {
      availableHeight = math.max(
        0.0,
        anchorBounds.top - anchorGap - alignmentOffset.dy - marginV,
      );
    } else {
      availableHeight = math.max(
        0.0,
        usableHeight -
            anchorBounds.bottom -
            anchorGap -
            alignmentOffset.dy -
            marginV,
      );
    }

    return M3EMenuLayoutResult(
      position: Offset(x, y),
      isAbove: isAbove,
      isLeft: isLeft,
      isCoveringAnchor: isCoveringAnchor,
      transformOrigin: transformOrigin,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      availableHeight: availableHeight,
    );
  }

  /// Calculates the dynamic [FractionalOffset] transform origin based on the
  /// geometric intersection center between the anchor bounds and menu bounds,
  /// matching the Material 3 Expressive and Jetpack Compose specification.
  static FractionalOffset calculateTransformOrigin({
    required Rect anchorBounds,
    required Rect menuBounds,
  }) {
    double pivotX;
    if (menuBounds.left >= anchorBounds.right) {
      pivotX = 0.0;
    } else if (menuBounds.right <= anchorBounds.left) {
      pivotX = 1.0;
    } else if (menuBounds.width == 0) {
      pivotX = 0.0;
    } else {
      final intersectionCenter =
          (math.max(anchorBounds.left, menuBounds.left) +
              math.min(anchorBounds.right, menuBounds.right)) /
          2;
      pivotX = (intersectionCenter - menuBounds.left) / menuBounds.width;
    }

    double pivotY;
    if (menuBounds.top >= anchorBounds.bottom) {
      pivotY = 0.0;
    } else if (menuBounds.bottom <= anchorBounds.top) {
      pivotY = 1.0;
    } else if (menuBounds.height == 0) {
      pivotY = 0.0;
    } else {
      final intersectionCenter =
          (math.max(anchorBounds.top, menuBounds.top) +
              math.min(anchorBounds.bottom, menuBounds.bottom)) /
          2;
      pivotY = (intersectionCenter - menuBounds.top) / menuBounds.height;
    }

    return FractionalOffset(pivotX.clamp(0.0, 1.0), pivotY.clamp(0.0, 1.0));
  }
}
