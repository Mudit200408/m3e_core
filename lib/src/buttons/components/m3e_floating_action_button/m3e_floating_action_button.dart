// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../../common/m3e_common.dart';
import '../../style/m3e_button_decoration.dart';
import '../../style/m3e_button_enums.dart';
import '../m3e_button/m3e_button.dart';

/// Size variants for [M3EFloatingActionButton].
enum M3EFloatingActionButtonSize { small, standard, medium, large }

/// A Material 3 Expressive floating action button.
class M3EFloatingActionButton extends StatelessWidget {
  const M3EFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = M3EFloatingActionButtonSize.standard,
    this.containerColor,
    this.contentColor,
    this.elevation,
    this.shape = M3EButtonShape.round,
    this.decoration,
    this.enabled = true,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final M3EFloatingActionButtonSize size;
  final Color? containerColor;
  final Color? contentColor;
  final double? elevation;
  final M3EButtonShape shape;
  final M3EButtonDecoration? decoration;
  final bool enabled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final dimensions = _FabDimensions.from(size);
    final colors = Theme.of(context).colorScheme;
    final fabDecoration = (decoration ?? const M3EButtonDecoration()).copyWith(
      backgroundColor: WidgetStatePropertyAll(
        containerColor ?? colors.primaryContainer,
      ),
      foregroundColor: WidgetStatePropertyAll(
        contentColor ?? colors.onPrimaryContainer,
      ),
      elevation: WidgetStatePropertyAll(elevation ?? 6),
      minimumSize: Size(dimensions.size, dimensions.size),
      fixedSize: Size(dimensions.size, dimensions.size),
      padding: decoration?.padding ?? EdgeInsets.zero,
      borderRadius: shape == M3EButtonShape.round
          ? dimensions.size / 2
          : dimensions.radius,
    );

    return M3EButton(
      onPressed: onPressed,
      enabled: enabled,
      size: dimensions.buttonSize,
      shape: M3EButtonShape.square,
      decoration: fabDecoration,
      tooltip: tooltip,
      child: Center(child: child),
    );
  }
}

class M3ESmallFloatingActionButton extends M3EFloatingActionButton {
  const M3ESmallFloatingActionButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.containerColor,
    super.contentColor,
    super.elevation,
    super.shape,
    super.decoration,
    super.enabled,
    super.tooltip,
  }) : super(size: M3EFloatingActionButtonSize.small);
}

class M3EMediumFloatingActionButton extends M3EFloatingActionButton {
  const M3EMediumFloatingActionButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.containerColor,
    super.contentColor,
    super.elevation,
    super.shape,
    super.decoration,
    super.enabled,
    super.tooltip,
  }) : super(size: M3EFloatingActionButtonSize.medium);
}

class M3ELargeFloatingActionButton extends M3EFloatingActionButton {
  const M3ELargeFloatingActionButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.containerColor,
    super.contentColor,
    super.elevation,
    super.shape,
    super.decoration,
    super.enabled,
    super.tooltip,
  }) : super(size: M3EFloatingActionButtonSize.large);
}

/// An extended M3E FAB whose label expands and collapses using spring motion.
class M3EExtendedFloatingActionButton extends StatelessWidget {
  const M3EExtendedFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.expanded = true,
    this.size = M3EFloatingActionButtonSize.standard,
    this.containerColor,
    this.contentColor,
    this.elevation,
    this.decoration,
    this.enabled = true,
    this.tooltip,
    this.motion = M3EMotion.standardSpatialFast,
    this.effectsMotion = M3EMotion.standardEffectsFast,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final bool expanded;
  final M3EFloatingActionButtonSize size;
  final Color? containerColor;
  final Color? contentColor;
  final double? elevation;
  final M3EButtonDecoration? decoration;
  final bool enabled;
  final String? tooltip;
  final M3EMotion motion;
  final M3EMotion effectsMotion;

  @override
  Widget build(BuildContext context) {
    final dimensions = _FabDimensions.from(size);
    return M3EButton(
      onPressed: onPressed,
      enabled: enabled,
      size: dimensions.buttonSize,
      decoration: (decoration ?? const M3EButtonDecoration()).copyWith(
        backgroundColor: WidgetStatePropertyAll(
          containerColor ?? Theme.of(context).colorScheme.primaryContainer,
        ),
        foregroundColor: WidgetStatePropertyAll(
          contentColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        elevation: WidgetStatePropertyAll(elevation ?? 6),
        padding: EdgeInsets.zero,
        minimumSize: Size(dimensions.size, dimensions.size),
        borderRadius: dimensions.size / 2,
      ),
      tooltip: tooltip,
      child: _AnimatedExtendedFabContent(
        icon: icon,
        label: label,
        expanded: expanded,
        dimensions: dimensions,
        motion: motion.toMotion(),
        effectsMotion: effectsMotion.toMotion(),
      ),
    );
  }
}

class M3ESmallExtendedFloatingActionButton
    extends M3EExtendedFloatingActionButton {
  const M3ESmallExtendedFloatingActionButton({
    super.key,
    required super.onPressed,
    required super.icon,
    required super.label,
    super.expanded,
    super.containerColor,
    super.contentColor,
    super.elevation,
    super.decoration,
    super.enabled,
    super.tooltip,
    super.motion,
    super.effectsMotion,
  }) : super(size: M3EFloatingActionButtonSize.small);
}

class M3EMediumExtendedFloatingActionButton
    extends M3EExtendedFloatingActionButton {
  const M3EMediumExtendedFloatingActionButton({
    super.key,
    required super.onPressed,
    required super.icon,
    required super.label,
    super.expanded,
    super.containerColor,
    super.contentColor,
    super.elevation,
    super.decoration,
    super.enabled,
    super.tooltip,
    super.motion,
    super.effectsMotion,
  }) : super(size: M3EFloatingActionButtonSize.medium);
}

class M3ELargeExtendedFloatingActionButton
    extends M3EExtendedFloatingActionButton {
  const M3ELargeExtendedFloatingActionButton({
    super.key,
    required super.onPressed,
    required super.icon,
    required super.label,
    super.expanded,
    super.containerColor,
    super.contentColor,
    super.elevation,
    super.decoration,
    super.enabled,
    super.tooltip,
    super.motion,
    super.effectsMotion,
  }) : super(size: M3EFloatingActionButtonSize.large);
}

class _AnimatedExtendedFabContent extends StatelessWidget {
  const _AnimatedExtendedFabContent({
    required this.icon,
    required this.label,
    required this.expanded,
    required this.dimensions,
    required this.motion,
    required this.effectsMotion,
  });

  final Widget icon;
  final Widget label;
  final bool expanded;
  final _FabDimensions dimensions;
  final SpringMotion motion;
  final SpringMotion effectsMotion;

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: motion,
      value: expanded ? 1 : 0,
      builder: (context, widthProgress, _) {
        return SingleMotionBuilder(
          motion: effectsMotion,
          value: expanded ? 1 : 0,
          builder: (context, opacityProgress, _) {
            final width = lerpDouble(
              dimensions.size,
              dimensions.extendedMinWidth,
              widthProgress,
            )!;
            return SizedBox(
              width: width,
              height: dimensions.size,
              child: opacityProgress <= 0.001 && !expanded
                  ? Center(
                      child: IconTheme.merge(
                        data: IconThemeData(size: dimensions.iconSize),
                        child: icon,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: expanded
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: expanded ? dimensions.leadingPadding : 0,
                        ),
                        IconTheme.merge(
                          data: IconThemeData(size: dimensions.iconSize),
                          child: icon,
                        ),
                        if (opacityProgress > 0)
                          Flexible(
                            child: Opacity(
                              opacity: opacityProgress,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: dimensions.iconLabelGap,
                                  right: dimensions.trailingPadding,
                                ),
                                child: label,
                              ),
                            ),
                          ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}

class _FabDimensions {
  const _FabDimensions({
    required this.size,
    required this.extendedMinWidth,
    required this.iconSize,
    required this.leadingPadding,
    required this.trailingPadding,
    required this.iconLabelGap,
    required this.radius,
    required this.buttonSize,
  });

  final double size;
  final double extendedMinWidth;
  final double iconSize;
  final double leadingPadding;
  final double trailingPadding;
  final double iconLabelGap;
  final double radius;
  final M3EButtonSize buttonSize;

  factory _FabDimensions.from(M3EFloatingActionButtonSize size) {
    return switch (size) {
      M3EFloatingActionButtonSize.small => const _FabDimensions(
        size: 40,
        extendedMinWidth: 80,
        iconSize: 24,
        leadingPadding: 16,
        trailingPadding: 16,
        iconLabelGap: 8,
        radius: 12,
        buttonSize: M3EButtonSize.sm,
      ),
      M3EFloatingActionButtonSize.standard => const _FabDimensions(
        size: 56,
        extendedMinWidth: 80,
        iconSize: 24,
        leadingPadding: 16,
        trailingPadding: 20,
        iconLabelGap: 12,
        radius: 16,
        buttonSize: M3EButtonSize.md,
      ),
      M3EFloatingActionButtonSize.medium => _FabDimensions(
        size: 80,
        extendedMinWidth: 120,
        iconSize: 28,
        leadingPadding: 26,
        trailingPadding: 26,
        iconLabelGap: 12,
        radius: 28,
        buttonSize: M3EButtonSize.custom(height: 80),
      ),
      M3EFloatingActionButtonSize.large => const _FabDimensions(
        size: 96,
        extendedMinWidth: 140,
        iconSize: 36,
        leadingPadding: 28,
        trailingPadding: 28,
        iconLabelGap: 16,
        radius: 28,
        buttonSize: M3EButtonSize.lg,
      ),
    };
  }
}
