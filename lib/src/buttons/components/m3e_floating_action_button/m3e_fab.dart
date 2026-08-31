// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../../common/m3e_common.dart';
import '../../style/m3e_button_decoration.dart';
import '../../style/m3e_button_enums.dart';
import '../../style/m3e_fab_decoration.dart';
import '../m3e_button/m3e_button.dart';

/// FAB color roles matching the Material 3 Expressive implementation.
enum M3EFabColor { primary, secondary, tertiary, surface }

/// FAB sizes matching the Material 3 Expressive implementation.
enum M3EFabSize { small, medium, large }

const _kPressMotion = M3EMotion.custom(stiffness: 380, damping: 0.55);

/// Material 3 Expressive floating action button.
class M3EFab extends StatefulWidget {
  const M3EFab({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = M3EFabSize.medium,
    this.color = M3EFabColor.primary,
    this.cornerRadius,
    this.decoration,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final M3EFabSize size;
  final M3EFabColor color;
  final double? cornerRadius;
  final M3EFabDecoration? decoration;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<M3EFab> createState() => _M3EFabState();
}

class _M3EFabState extends State<M3EFab> {
  late final WidgetStatesController _statesController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController()..addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final pressed = _statesController.value.contains(WidgetState.pressed);
    if (pressed != _pressed && mounted) setState(() => _pressed = pressed);
  }

  @override
  void dispose() {
    _statesController
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _FabMetrics.from(widget.size);
    final colors = Theme.of(context).colorScheme;
    final decoration = widget.decoration;
    final background =
        decoration?.backgroundColor ??
        WidgetStatePropertyAll(_background(widget.color, colors));
    final foreground =
        decoration?.foregroundColor ??
        WidgetStatePropertyAll(_foreground(widget.color, colors));
    final borderRadius = widget.cornerRadius ?? metrics.radius;

    final button = M3EButton(
      onPressed: widget.onPressed,
      size: metrics.buttonSize,
      enabled: widget.onPressed != null,
      statesController: _statesController,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      tooltip: widget.tooltip,
      decoration: M3EButtonDecoration(
        backgroundColor: background,
        foregroundColor: foreground,
        overlayColor: decoration?.overlayColor,
        side: decoration?.side,
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0.0;
          if (states.contains(WidgetState.hovered)) return 8.0; // Level 4
          return 6.0; // Level 3 (Default, Pressed, Focused)
        }),
        minimumSize: Size(metrics.container, metrics.container),
        fixedSize: Size(metrics.container, metrics.container),
        padding: EdgeInsets.zero,
        borderRadius: borderRadius,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: SizedBox(
        width: metrics.container,
        height: metrics.container,
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(size: metrics.iconSize),
            child: widget.icon,
          ),
        ),
      ),
    );

    return _FabPressScale(
      pressed: _pressed,
      motion: decoration?.motion ?? _kPressMotion,
      scale: decoration?.pressedScale ?? 0.95,
      child: button,
    );
  }
}

/// Extended FAB with size support, asymmetric padding, and spring press physics.
class M3EExtendedFab extends StatefulWidget {
  const M3EExtendedFab({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.size = M3EFabSize.medium,
    this.color = M3EFabColor.primary,
    this.extended = true,
    this.decoration,
    this.focusNode,
    this.autofocus = false,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final M3EFabSize size;
  final M3EFabColor color;
  final bool extended;
  final M3EFabDecoration? decoration;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<M3EExtendedFab> createState() => _M3EExtendedFabState();
}

class _M3EExtendedFabState extends State<M3EExtendedFab> {
  late final WidgetStatesController _statesController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController()..addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final pressed = _statesController.value.contains(WidgetState.pressed);
    if (pressed != _pressed && mounted) setState(() => _pressed = pressed);
  }

  @override
  void dispose() {
    _statesController
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _ExtendedFabMetrics.from(widget.size);
    final colors = Theme.of(context).colorScheme;
    final decoration = widget.decoration;
    final background =
        decoration?.backgroundColor ??
        WidgetStatePropertyAll(_background(widget.color, colors));
    final foreground =
        decoration?.foregroundColor ??
        WidgetStatePropertyAll(_foreground(widget.color, colors));

    final button = M3EButton(
      onPressed: widget.onPressed,
      size: metrics.buttonSize,
      enabled: widget.onPressed != null,
      statesController: _statesController,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      decoration: M3EButtonDecoration(
        backgroundColor: background,
        foregroundColor: foreground,
        overlayColor: decoration?.overlayColor,
        side: decoration?.side,
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0.0;
          if (states.contains(WidgetState.hovered)) return 8.0; // Level 4
          return 6.0; // Level 3 (Default, Pressed, Focused)
        }),
        minimumSize: Size(metrics.height, metrics.height),
        padding: EdgeInsets.zero,
        borderRadius: metrics.radius,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: const Cubic(0.2, 0, 0, 1),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
            left: metrics.startPadding,
            right: widget.extended ? metrics.endPadding : metrics.startPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme.merge(
                data: IconThemeData(size: metrics.iconSize),
                child: widget.icon,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: const Cubic(0.2, 0, 0, 1),
                child: widget.extended
                    ? Padding(
                        padding: EdgeInsets.only(left: metrics.iconGap),
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );

    return _FabPressScale(
      pressed: _pressed,
      motion: decoration?.motion ?? _kPressMotion,
      scale: decoration?.pressedScale ?? 0.97,
      child: button,
    );
  }
}

class _FabPressScale extends StatelessWidget {
  const _FabPressScale({
    required this.pressed,
    required this.scale,
    required this.motion,
    required this.child,
  });

  final bool pressed;
  final double scale;
  final M3EMotion motion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: motion.toMotion(),
      value: pressed ? scale : 1,
      builder: (context, value, _) =>
          Transform.scale(scale: value, child: child),
    );
  }
}

class _FabMetrics {
  const _FabMetrics(
    this.container,
    this.iconSize,
    this.radius,
    this.buttonSize,
  );

  final double container;
  final double iconSize;
  final double radius;
  final M3EButtonSize buttonSize;

  factory _FabMetrics.from(M3EFabSize size) {
    return switch (size) {
      M3EFabSize.small => const _FabMetrics(40, 24, 12, M3EButtonSize.sm),
      M3EFabSize.medium => const _FabMetrics(56, 24, 16, M3EButtonSize.md),
      M3EFabSize.large => const _FabMetrics(96, 36, 28, M3EButtonSize.lg),
    };
  }
}

class _ExtendedFabMetrics {
  const _ExtendedFabMetrics({
    required this.height,
    required this.startPadding,
    required this.endPadding,
    required this.iconGap,
    required this.iconSize,
    required this.radius,
    required this.buttonSize,
  });

  final double height;
  final double startPadding;
  final double endPadding;
  final double iconGap;
  final double iconSize;
  final double radius;
  final M3EButtonSize buttonSize;

  factory _ExtendedFabMetrics.from(M3EFabSize size) {
    return switch (size) {
      M3EFabSize.small => const _ExtendedFabMetrics(
        height: 40,
        startPadding: 16,
        endPadding: 16,
        iconGap: 8,
        iconSize: 24,
        radius: 12,
        buttonSize: M3EButtonSize.sm,
      ),
      M3EFabSize.medium => const _ExtendedFabMetrics(
        height: 56,
        startPadding: 16,
        endPadding: 20,
        iconGap: 12,
        iconSize: 24,
        radius: 16,
        buttonSize: M3EButtonSize.md,
      ),
      M3EFabSize.large => const _ExtendedFabMetrics(
        height: 96,
        startPadding: 28,
        endPadding: 28,
        iconGap: 16,
        iconSize: 36,
        radius: 28,
        buttonSize: M3EButtonSize.lg,
      ),
    };
  }
}

Color _background(M3EFabColor color, ColorScheme scheme) => switch (color) {
  M3EFabColor.primary => scheme.primaryContainer,
  M3EFabColor.secondary => scheme.secondaryContainer,
  M3EFabColor.tertiary => scheme.tertiaryContainer,
  M3EFabColor.surface => scheme.surfaceContainerHigh,
};

Color _foreground(M3EFabColor color, ColorScheme scheme) => switch (color) {
  M3EFabColor.primary => scheme.onPrimaryContainer,
  M3EFabColor.secondary => scheme.onSecondaryContainer,
  M3EFabColor.tertiary => scheme.onTertiaryContainer,
  M3EFabColor.surface => scheme.primary,
};
