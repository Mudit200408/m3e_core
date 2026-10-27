// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';
import '../components/m3e_menu_group.dart';
import '../style/m3e_menu_animation_style.dart';
import '../style/m3e_menu_style.dart';
import '../style/m3e_menu_tokens.dart';

/// Animated surface container for M3E Menu popup.
///
/// Renders the menu container and drives its open / close reveal with a pair of
/// `motor` spring controllers: a spatial spring for scale and an effects spring
/// for opacity. Two reveal styles are supported, selected through
/// [M3EMenuStyle.animationStyle]:
///
/// * [M3EMenuAnimationStyle.popup] scales the surface uniformly from
///   [M3EMenuTokens.closedScaleTarget] around the transform origin supplied by
///   the position provider, so the menu grows out of the edge it is anchored to.
/// * [M3EMenuAnimationStyle.dropdown] squashes the surface along its Y axis with
///   the transform origin pinned to the edge nearest the anchor, so the menu
///   unrolls away from the anchor.
///
/// Both styles keep the anchor edge stationary and let the spatial spring
/// overshoot past its target for the M3 Expressive elastic feel.
class AnimatedMenuSurface extends StatefulWidget {
  /// Whether the popup is positioned above the anchor.
  final bool isAbove;

  /// Whether the popup is positioned to the left of the anchor.
  final bool isLeft;

  /// Whether the menu covers or overlaps the anchor on screen.
  final bool isCoveringAnchor;

  /// Dynamic transform origin where the menu scales from.
  final FractionalOffset? transformOrigin;

  final M3EMenuStyle style;
  final bool isVibrant;
  final List<Widget>? children;
  final Widget? child;
  final void Function(VoidCallback dismiss)? onDismissRequest;
  final VoidCallback? onDismiss;

  const AnimatedMenuSurface({
    super.key,
    required this.isAbove,
    this.isLeft = false,
    this.isCoveringAnchor = false,
    this.transformOrigin,
    required this.style,
    required this.isVibrant,
    this.children,
    this.child,
    this.onDismiss,
    this.onDismissRequest,
  });

  @override
  State<AnimatedMenuSurface> createState() => _AnimatedMenuSurfaceState();
}

class _AnimatedMenuSurfaceState extends State<AnimatedMenuSurface>
    with TickerProviderStateMixin {
  late final SingleMotionController _spatialCtrl;
  late final SingleMotionController _effectsCtrl;
  late final Listenable _mergedAnimation;
  bool _isDismissing = false;
  bool _closeRequested = false;

  @override
  void initState() {
    super.initState();

    _spatialCtrl = SingleMotionController(
      motion: widget.style.spatialMotion.toMotion(),
      vsync: this,
    );

    _effectsCtrl = SingleMotionController(
      motion: widget.style.effectsMotion.toMotion(),
      vsync: this,
    )..addListener(_onEffectsTick);

    _mergedAnimation = Listenable.merge([_spatialCtrl, _effectsCtrl]);

    widget.onDismissRequest?.call(_dismiss);

    // Deferred so the overlay entry is laid out at its full size on the first
    // frame; scaling from a collapsed layout would otherwise reflow mid-reveal.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_closeRequested) {
        _spatialCtrl.animateTo(1.0);
        _effectsCtrl.animateTo(1.0);
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedMenuSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style.spatialMotion != oldWidget.style.spatialMotion) {
      _spatialCtrl.motion = widget.style.spatialMotion.toMotion();
    }
    if (widget.style.effectsMotion != oldWidget.style.effectsMotion) {
      _effectsCtrl.motion = widget.style.effectsMotion.toMotion();
    }
  }

  @override
  void dispose() {
    _effectsCtrl.removeListener(_onEffectsTick);
    _spatialCtrl.dispose();
    _effectsCtrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_isDismissing) return;
    _isDismissing = true;
    _closeRequested = true;
    _spatialCtrl.animateTo(0.0);
    _effectsCtrl.animateTo(0.0);
    // If the effects spring is already at or near zero (open and close happened
    // within a single frame before animateTo(1.0) ran), no tick will fire.
    // Complete the dismiss synchronously so the barrier does not stay mounted.
    if (_effectsCtrl.value <= 0.01) {
      _isDismissing = false;
      widget.onDismiss?.call();
    }
  }

  /// Removes the host overlay once the collapse spring has settled, rather than
  /// after a fixed delay that would either cut the animation short or leave the
  /// invisible overlay mounted.
  void _onEffectsTick() {
    if (!_isDismissing || !mounted) return;
    if (_effectsCtrl.value > 0.01) return;
    // One-shot: a bouncy spring can cross the threshold more than once.
    _isDismissing = false;
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bool hasGroups =
        widget.children?.any((w) => w is M3EMenuGroup) ?? false;

    final Color defaultBg = widget.isVibrant
        ? cs.tertiaryContainer
        : cs.surfaceContainerLow;

    final Color bgColor = widget.style.backgroundColor ?? defaultBg;
    final double elevation =
        widget.style.elevation ?? M3EMenuTokens.containerElevation;
    final Color shadowColor = widget.style.shadowColor ?? cs.shadow;
    final Color surfaceTintColor =
        widget.style.surfaceTintColor ?? Colors.transparent;

    final ShapeBorder shape =
        widget.style.shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(M3EMenuTokens.cornerLarge),
          ),
        );

    Widget content =
        widget.child ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.children ?? const [],
        );

    final innerContent = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.style.minWidth ?? M3EMenuTokens.containerMinWidth,
        maxWidth: widget.style.maxWidth ?? M3EMenuTokens.containerMaxWidth,
        maxHeight: widget.style.maxHeight ?? double.infinity,
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: hasGroups
            ? content
            : Padding(
                padding:
                    widget.style.padding ??
                    const EdgeInsets.symmetric(
                      vertical: M3EMenuTokens.containerVerticalPadding,
                    ),
                child: content,
              ),
      ),
    );

    final Alignment revealAlignment = widget.isAbove
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    // The popup style pivots around the point where the menu overlaps its
    // anchor, so it appears to grow out of the anchor. The dropdown style always
    // unrolls away from the anchor along the cross axis.
    final Alignment transformAlignment = widget.transformOrigin == null
        ? revealAlignment
        : Alignment(
            widget.transformOrigin!.dx * 2 - 1,
            widget.transformOrigin!.dy * 2 - 1,
          );

    final Widget surface = hasGroups
        ? ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(M3EMenuTokens.cornerLarge),
            ),
            child: innerContent,
          )
        : Material(
            color: bgColor,
            elevation: elevation,
            shadowColor: shadowColor,
            surfaceTintColor: surfaceTintColor,
            shape: shape,
            clipBehavior: Clip.antiAlias,
            child: innerContent,
          );

    return AnimatedBuilder(
      animation: _mergedAnimation,
      builder: (context, _) {
        final double t = _spatialCtrl.value;
        final double containerAlpha = _effectsCtrl.value.clamp(0.0, 1.0);
        if (containerAlpha <= 0.001 && _isDismissing) {
          return const SizedBox.shrink();
        }

        switch (widget.style.animationStyle) {
          case M3EMenuAnimationStyle.popup:
            // Uniform scale from the closed to the expanded target around the
            // anchor overlap. The spatial spring is free to overshoot past 1.0,
            // which is what produces the elastic M3 Expressive pop.
            final double scale =
                M3EMenuTokens.closedScaleTarget +
                (M3EMenuTokens.expandedScaleTarget -
                        M3EMenuTokens.closedScaleTarget) *
                    math.max(0.0, t);
            return Opacity(
              opacity: containerAlpha,
              child: Transform(
                transform: Matrix4.diagonal3Values(scale, scale, 1.0),
                alignment: transformAlignment,
                child: surface,
              ),
            );

          case M3EMenuAnimationStyle.dropdown:
            // Vertical squash away from the anchor. Progress runs slightly past
            // 1.0 so the spring can overshoot before settling back.
            final double progress = t.clamp(0.0, 1.5);
            final double scaleY = progress.clamp(0.0, 1.2);
            return Opacity(
              opacity: progress.clamp(0.0, 1.0),
              child: Transform(
                transform: Matrix4.diagonal3Values(1.0, scaleY, 1.0),
                alignment: revealAlignment,
                child: surface,
              ),
            );
        }
      },
    );
  }
}
