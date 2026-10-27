// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../common/m3e_common.dart';
import '../internal/_menu_scope.dart';
import '../style/m3e_menu_style.dart';
import '../style/m3e_menu_tokens.dart';

/// A visually distinct segmented group within an M3E Menu.
///
/// Ref: `DropdownMenuGroup` in Compose reference (`code.txt`).
/// Encapsulates related menu items with corner morphing and 4dp group spacing.
class M3EMenuGroup extends StatefulWidget {
  final List<Widget> children;
  final MenuGroupShapes? shapes;
  final Color? containerColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final M3EMotion spatialMotion;

  const M3EMenuGroup({
    super.key,
    required this.children,
    this.shapes,
    this.containerColor,
    this.padding = const EdgeInsets.symmetric(
      vertical: M3EMenuTokens.groupInnerPadding,
    ),
    this.margin,
    this.spatialMotion = M3EMotion.expressiveSpatialFast,
  });

  @override
  State<M3EMenuGroup> createState() => _M3EMenuGroupState();
}

class _M3EMenuGroupState extends State<M3EMenuGroup> {
  bool _isHovered = false;
  bool _hasBeenHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final menuScope = M3EMenuScope.maybeOf(context);
    final isVibrant = menuScope?.isVibrant ?? false;

    final shapes = widget.shapes ?? MenuGroupShapes.standalone();
    final effectiveColor =
        widget.containerColor ??
        (isVibrant ? cs.tertiaryContainer : cs.surfaceContainerLow);

    // Inactive shape morphing per M3 Expressive spec:
    // Group starts in active shape (16dp).
    // When unhovered after having been hovered, it morphs into inactiveShape (8dp).
    final bool isInactive = _hasBeenHovered && !_isHovered;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _hasBeenHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: Padding(
        padding:
            widget.margin ??
            const EdgeInsets.only(bottom: M3EMenuTokens.groupGap),
        child: SingleMotionBuilder(
          motion: widget.spatialMotion.toMotion(),
          value: isInactive ? 1.0 : 0.0,
          builder: (context, t, child) {
            final ShapeBorder animatedShape =
                ShapeBorder.lerp(
                  shapes.shape,
                  shapes.inactiveShape,
                  t.clamp(0.0, 1.0),
                ) ??
                shapes.shape;

            return Material(
              color: effectiveColor,
              shape: animatedShape,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: widget.padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < widget.children.length; i++)
                      M3EMenuGroupScope(
                        index: i,
                        count: widget.children.length,
                        child: widget.children[i],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
