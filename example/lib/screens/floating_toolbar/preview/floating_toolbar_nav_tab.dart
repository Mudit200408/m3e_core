// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui' show lerpDouble;
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:motor/motor.dart';
import '../models/floating_toolbar_models.dart';

/// Spring-animated interactive navigation tab reproducing the Expressive look and feel.
class ExpressiveNavBarTab extends StatefulWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final M3EMotion motion;
  final M3EFloatingToolbarColors colors;
  final ToolbarColorMode colorMode;
  final M3EHapticFeedback haptic;
  final Color? customSplashColor;
  final double splashAlpha;
  final VoidCallback onTap;

  const ExpressiveNavBarTab({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.motion,
    required this.colors,
    required this.colorMode,
    required this.haptic,
    this.customSplashColor,
    this.splashAlpha = 0.12,
    required this.onTap,
  });

  @override
  State<ExpressiveNavBarTab> createState() => _ExpressiveNavBarTabState();
}

class _ExpressiveNavBarTabState extends State<ExpressiveNavBarTab>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SingleMotionController(
      motion: widget.motion.toMotion(),
      vsync: this,
      initialValue: widget.isSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant ExpressiveNavBarTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.motion != oldWidget.motion) {
      _controller.motion = widget.motion.toMotion();
    }
    if (widget.isSelected != oldWidget.isSelected) {
      _controller.animateTo(widget.isSelected ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final clampedProgress = progress.clamp(0.0, 1.0);

        final double width = lerpDouble(48.0, 110.0, progress)!;

        final Color selectedBg;
        final Color selectedFg;
        final Color unselectedFg;

        if (widget.colorMode == ToolbarColorMode.expressive) {
          // Expressive exact palette: solid primary bar, crisp white/surface active pill
          selectedBg = cs.surface;
          selectedFg = cs.primary;
          unselectedFg = cs.onPrimary;
        } else if (widget.colorMode == ToolbarColorMode.vibrant) {
          selectedBg = cs.surfaceContainer;
          selectedFg = cs.onSurface;
          unselectedFg = widget.colors.toolbarContentColor;
        } else if (widget.colorMode == ToolbarColorMode.standard) {
          selectedBg = cs.primaryContainer.withValues(alpha: 0.6);
          selectedFg = cs.primary;
          unselectedFg = cs.onSurfaceVariant;
        } else {
          selectedBg = widget.colors.fabContainerColor.withValues(alpha: 0.35);
          selectedFg = widget.colors.fabContainerColor;
          unselectedFg = widget.colors.toolbarContentColor;
        }

        final Color bgColor = widget.isSelected
            ? selectedBg
            : Colors.transparent;
        final Color contentColor = widget.isSelected
            ? selectedFg
            : unselectedFg;

        return Container(
          width: width,
          height: 48.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24.0),
              onTap: () {
                widget.haptic.apply();
                widget.onTap();
              },
              overlayColor: WidgetStateProperty.resolveWith((states) {
                final baseSplash = widget.customSplashColor ?? contentColor;
                if (states.contains(WidgetState.pressed)) {
                  return baseSplash.withValues(alpha: widget.splashAlpha);
                }
                if (states.contains(WidgetState.hovered)) {
                  return baseSplash.withValues(alpha: 0.08);
                }
                if (states.contains(WidgetState.focused)) {
                  return baseSplash.withValues(alpha: widget.splashAlpha);
                }
                return null;
              }),
              child: ClipRect(
                child: Center(
                  child: OverflowBox(
                    minWidth: 0,
                    maxWidth: 140,
                    minHeight: 0,
                    maxHeight: 48,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.isSelected ? widget.selectedIcon : widget.icon,
                          color: contentColor,
                          size: 24.0,
                        ),
                        if (progress > 0.01)
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: clampedProgress,
                              child: Opacity(
                                opacity: clampedProgress,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    widget.label,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: contentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
