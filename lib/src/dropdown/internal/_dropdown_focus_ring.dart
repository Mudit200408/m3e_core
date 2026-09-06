// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

/// A decorator that draws the Material 3 Expressive focus ring around dropdown
/// elements (the trigger field, menu items, or chips).
///
/// The ring paints as a **zero-layout-impact overlay**: it does not inflate the
/// child's bounding box. Instead it uses [Stack] with [Clip.none] and a
/// [Positioned] child offset by [outset] on all sides, so the ring is free
/// to paint outside the item's natural bounds without pushing surrounding
/// content apart.
///
/// Each corner of the ring is expanded by exactly [gap] from the corresponding
/// item corner.
class DropdownFocusRing extends StatelessWidget {
  /// The border radius of the element being focused.
  final BorderRadius radius;

  /// The inner widget to decorate.
  final Widget child;

  /// Whether the focus ring should be painted.
  final bool focused;

  /// Duration for morphing animations when the border radius changes.
  final Duration animationDuration;

  /// Custom focus ring color. Defaults to [ColorScheme.primary].
  final Color? color;

  /// The gap between the item's outer edge and the inner edge of the focus ring.
  /// Defaults to `0.0`.
  final double gap;

  /// The stroke width of the focus ring.
  /// Defaults to `2.0`.
  final double width;

  const DropdownFocusRing({
    super.key,
    required this.radius,
    required this.child,
    this.focused = false,
    this.animationDuration = Duration.zero,
    this.color,
    this.gap = 0.0,
    this.width = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!focused) return RepaintBoundary(child: child);

    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    final double outset = gap > 0 ? gap + width : 0.0;

    // Conic/concentric radius expansion when outset > 0, otherwise match item radius.
    final adjustedRadius = gap > 0
        ? BorderRadius.only(
            topLeft: Radius.circular(radius.topLeft.x + outset),
            topRight: Radius.circular(radius.topRight.x + outset),
            bottomLeft: Radius.circular(radius.bottomLeft.x + outset),
            bottomRight: Radius.circular(radius.bottomRight.x + outset),
          )
        : radius;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            top: -outset,
            bottom: -outset,
            left: -outset,
            right: -outset,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  border: Border.all(color: effectiveColor, width: width),
                  borderRadius: adjustedRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
