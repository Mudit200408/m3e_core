// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../internal/_button_motion.dart';
import '../../internal/button_constants.dart';
import '../../internal/m3e_base_button_state.dart';
import '../../style/button_tokens_adapter.dart';
import '../../style/m3e_button_decoration.dart';
import '../../style/m3e_button_enums.dart';
import '../../style/m3e_motion.dart';

const Alignment _kAlignmentCenter = Alignment.center;
const VisualDensity _kVisualDensityStandard = VisualDensity.standard;
const Duration _kDurationZero = Duration.zero;
const InteractiveInkFeatureFactory _kDefaultSplashFactory =
    InkRipple.splashFactory;
const bool _kDefaultEnableFeedback = true;
final _kPressedRadiusMotion = M3EMotion.expressiveEffectsFast.toMotion();

/// Material 3 Expressive Button.
///
/// A highly customizable button that follows Material 3 Expressive design
/// principles, with smooth spring animations, five visual styles, five sizes.
///
/// ## Styles
/// [M3EButtonStyle.filled], [M3EButtonStyle.tonal], [M3EButtonStyle.elevated],
/// [M3EButtonStyle.outlined], [M3EButtonStyle.text].
///
/// ## Basic usage
/// ```dart
/// M3EButton(
///   style: M3EButtonStyle.filled,
///   label: const Text('Save'),
///   onPressed: _save,
/// )
/// ```
///
/// ## Accessibility
/// Provide [semanticLabel] when the visual label is not sufficiently descriptive.
class M3EButton extends StatefulWidget {
  const M3EButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.style = M3EButtonStyle.filled,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
    this.enabled = true,
    this.statesController,
    this.decoration,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : assert(
         label != null || icon != null,
         'M3EButton must be provided with either a label or an icon (or both).',
       );

  /// Callback invoked when the button is pressed. Null disables the button.
  final VoidCallback? onPressed;

  /// Optional text label displayed on the button.
  final Widget? label;

  /// Optional leading icon displayed before the label.
  final Widget? icon;

  /// Visual style of the button.
  ///
  /// See [M3EButtonStyle] for available styles (filled, outlined, tonal, etc.).
  final M3EButtonStyle style;

  /// Size variant of the button.
  ///
  /// See [M3EButtonSize] for available sizes (xs, sm, md, lg, xl).
  final M3EButtonSize size;

  /// Corner radius strategy for the button.
  ///
  /// See [M3EButtonShape] for available shapes (round, square).
  final M3EButtonShape shape;

  /// Whether the button is enabled. Defaults to true.
  final bool enabled;

  /// Optional controller for managing widget states externally.
  ///
  /// Allows programmatic control of pressed, hovered, focused states.
  final WidgetStatesController? statesController;

  /// Optional decoration that bundles styling properties together.
  ///
  /// When provided, decoration values take precedence over individual flat
  /// parameters (e.g. [backgroundColor], [foregroundColor], etc.).
  final M3EButtonDecoration? decoration;

  /// External focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this button should focus itself on mount.
  final bool autofocus;

  /// Callback fired when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Accessibility label. Merged on top of the button's own semantics.
  final String? semanticLabel;

  /// Custom mouse cursor.
  final MouseCursor mouseCursor;

  /// Callback invoked when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback invoked when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Whether to show a ripple/splash effect and haptic feedback on press.
  ///
  /// Defaults to true.
  final bool enableFeedback;

  /// The splash factory for the ink ripple effect.
  ///
  /// See [InteractiveInkFeatureFactory] for available options.
  final InteractiveInkFeatureFactory? splashFactory;

  // ── Decoration property helpers ───────────────────────────────────────────

  Color? get decorationBackgroundColor => decoration?.backgroundColor;
  Color? get decorationForegroundColor => decoration?.foregroundColor;
  BorderSide? get decorationBorderSide => decoration?.borderSide;
  BorderRadius? get decorationBorderRadius => decoration?.borderRadius;
  M3EMotion? get decorationMotion => decoration?.motion;
  M3EHapticFeedback get decorationHaptic =>
      decoration?.haptic ?? M3EHapticFeedback.none;
  MouseCursor? get decorationMouseCursor => decoration?.mouseCursor;
  double? get decorationPressedRadius => decoration?.pressedRadius;
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;
  WidgetStateProperty<Color?>? get decorationSurfaceTintColor =>
      decoration?.surfaceTintColor;

  @override
  State<M3EButton> createState() => _M3EButtonState();
}

class _M3EButtonState extends State<M3EButton>
    with M3EBaseButtonState<M3EButton> {
  late M3EButtonTokensAdapter _tokens;
  late M3EButtonMeasurements _measurements;

  @override
  M3EButtonSize get buttonSize => widget.size;

  @override
  WidgetStatesController? get externalStatesController =>
      widget.statesController;

  @override
  FocusNode? get externalFocusNode => widget.focusNode;

  @override
  M3EMotion? get effectiveMotion => widget.decorationMotion;

  @override
  void initState() {
    super.initState();
    initBaseButtonState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tokens = M3EButtonTokensAdapter(context);
    _tokens.didChangeDependencies();
    _updateMeasurements();
    updateLabelStyle(context);
    updateSpringMotion();
  }

  void _updateMeasurements() {
    _measurements = _tokens.measurements(widget.size);
  }

  @override
  void didUpdateWidget(covariant M3EButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleStatesControllerUpdate(
      oldWidget.statesController,
      widget.statesController,
    );
    handleFocusNodeUpdate(oldWidget.focusNode, widget.focusNode);

    if (oldWidget.size != widget.size) {
      _updateMeasurements();
    }

    if (oldWidget.size != widget.size ||
        oldWidget.decoration?.foregroundColor !=
            widget.decoration?.foregroundColor ||
        oldWidget.style != widget.style) {
      updateLabelStyle(context);
    }

    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      updateSpringMotion();
    }
  }

  @override
  void dispose() {
    disposeBaseButtonState();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<M3EButtonStyle>('style', widget.style));
    properties.add(DiagnosticsProperty<M3EButtonSize>('size', widget.size));
    properties.add(EnumProperty<M3EButtonShape>('shape', widget.shape));
    properties.add(
      FlagProperty('enabled', value: widget.enabled, ifFalse: 'disabled'),
    );
  }

  ButtonStyle _buildBaseStyle() {
    final isOutlinedOrText =
        widget.style == M3EButtonStyle.outlined ||
        widget.style == M3EButtonStyle.text;

    final fgColor =
        widget.decorationForegroundColor ?? _tokens.foreground(widget.style);
    final bgColor =
        widget.decorationBackgroundColor ??
        (isOutlinedOrText
            ? Colors.transparent
            : _tokens.container(widget.style));
    final outlineColor = widget.style == M3EButtonStyle.outlined
        ? (widget.decorationForegroundColor ?? _tokens.outline())
        : null;

    return ButtonStyle(
      alignment: _kAlignmentCenter,
      textStyle: WidgetStateProperty.all(labelStyle),
      minimumSize: WidgetStateProperty.all(
        Size(_tokens.minWidthFloor(), _measurements.height),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return widget.decoration?.disabledForegroundColor ??
              _tokens.c.onSurface.withValues(
                alpha: ButtonConstants.kDisabledForegroundAlpha,
              );
        }
        return fgColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          if (widget.decoration?.disabledBackgroundColor != null) {
            return widget.decoration!.disabledBackgroundColor!;
          }
          final isTransparent =
              widget.style == M3EButtonStyle.outlined ||
              widget.style == M3EButtonStyle.text;
          return isTransparent
              ? Colors.transparent
              : _tokens.c.onSurface.withValues(
                  alpha: ButtonConstants.kDisabledBackgroundAlpha,
                );
        }
        return bgColor;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        return _tokens.elevation(widget.style, states);
      }),
      side: outlineColor != null
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(
                  color: _tokens.c.onSurface.withValues(
                    alpha: ButtonConstants.kDisabledOutlineAlpha,
                  ),
                  width: 1,
                );
              }
              return BorderSide(color: outlineColor, width: 1);
            })
          : WidgetStateProperty.all(BorderSide.none),
      mouseCursor: WidgetStateProperty.all(
        widget.decorationMouseCursor ?? widget.mouseCursor,
      ),
      animationDuration: _kDurationZero,
      visualDensity: _kVisualDensityStandard,
      splashFactory: widget.splashFactory ?? _kDefaultSplashFactory,
      overlayColor: widget.decorationOverlayColor,
      surfaceTintColor: widget.decorationSurfaceTintColor,
      enableFeedback:
          (widget.decoration?.haptic != null &&
              widget.decoration!.haptic != M3EHapticFeedback.none)
          ? false
          : widget.enableFeedback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = _measurements;

    final EdgeInsets baseInternalPadding = EdgeInsets.symmetric(
      horizontal: m.hPadding,
    );

    final BorderRadius fullyRound = BorderRadius.circular(m.height / 2);
    final double tokenPressed = _tokens.pressedRadius(widget.size);
    final BorderRadius? explicitResting = widget.decorationBorderRadius;

    final BorderRadius defaultShape = widget.shape == M3EButtonShape.round
        ? fullyRound
        : (explicitResting ??
              BorderRadius.circular(_tokens.squareRadius(widget.size)));

    final double? explicitPressed = widget.decorationPressedRadius;
    final BorderRadius pressedShape = explicitPressed != null
        ? BorderRadius.circular(explicitPressed)
        : (explicitResting ?? BorderRadius.circular(tokenPressed));

    final double tokenHovered = _tokens.hoveredRadius(widget.size);
    final double? defaultExplicitHovered = widget.decoration?.hoveredRadius;
    final BorderRadius hoveredShape = defaultExplicitHovered != null
        ? BorderRadius.circular(defaultExplicitHovered)
        : (explicitResting ?? BorderRadius.circular(tokenHovered));

    final baseStyle = _buildBaseStyle();

    return buildAnimatedContent(
      builder: (context, pressed, hovered, focused) {
        final effectivelyEnabled = widget.enabled && widget.onPressed != null;
        final targetRadius = (effectivelyEnabled && pressed)
            ? pressedShape
            : (effectivelyEnabled && hovered)
            ? hoveredShape
            : defaultShape;

        Widget core = RepaintBoundary(
          child: RadiusAndPaddingMotion(
            motion: (effectivelyEnabled && pressed)
                ? _kPressedRadiusMotion
                : springMotion,
            internalLeft: baseInternalPadding.left,
            internalRight: baseInternalPadding.right,
            internalTop: baseInternalPadding.top,
            internalBottom: baseInternalPadding.bottom,
            targetRadius: targetRadius,
            freezeTopLeft: false,
            freezeBottomLeft: false,
            freezeTopRight: false,
            freezeBottomRight: false,
            builder: (animatedInternal, animatedRadius) {
              final buttonCore = _buildButtonCore(
                m,
                baseStyle,
                animatedInternal,
                animatedRadius,
              );
              return FocusRing(
                focused: focused,
                radius: animatedRadius,
                child: buttonCore,
              );
            },
          ),
        );

        final fixedWidth = widget.size.width;
        if (fixedWidth != null) {
          core = SizedBox(width: fixedWidth, child: core);
        }

        return core;
      },
    );
  }

  Widget _buildButtonCore(
    M3EButtonMeasurements m,
    ButtonStyle baseStyle,
    EdgeInsets internalPadding,
    BorderRadius animatedRadius,
  ) {
    Widget child = _buildContent(m);
    if (widget.semanticLabel != null) {
      child = ExcludeSemantics(child: child);
    }

    final shape = WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: animatedRadius),
    );
    final padding = WidgetStateProperty.all<EdgeInsetsGeometry>(
      internalPadding,
    );

    final style = baseStyle.copyWith(padding: padding, shape: shape);

    VoidCallback? onPressed;
    if (widget.enabled && widget.onPressed != null) {
      onPressed = () {
        if (widget.decoration?.haptic != null &&
            widget.decoration!.haptic != M3EHapticFeedback.none) {
          ButtonConstants.triggerHapticFeedback(widget.decoration!.haptic!);
        }
        widget.onPressed?.call();
      };
    }

    VoidCallback? onLongPress;
    if (widget.enabled && widget.onLongPress != null) {
      onLongPress = widget.onLongPress;
    }

    Widget button;
    switch (widget.style) {
      case M3EButtonStyle.filled:
        button = FilledButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.tonal:
        button = FilledButton.tonal(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.elevated:
        button = ElevatedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.outlined:
        button = OutlinedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.text:
        button = TextButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
    }

    // Flutter's built-in button widgets already expose button/enabled
    // semantics. Only add a wrapper when a custom label is required.
    Widget result = button;
    if (widget.semanticLabel != null) {
      result = Semantics(label: widget.semanticLabel, child: result);
    }

    return result;
  }

  Widget _buildContent(M3EButtonMeasurements m) {
    if (widget.label == null && widget.icon != null) {
      return RepaintBoundary(
        child: IconTheme.merge(
          data: IconThemeData(size: m.iconSize),
          child: widget.icon!,
        ),
      );
    }

    final text = DefaultTextStyle.merge(
      maxLines: 2,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: widget.label!,
    );

    if (widget.icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          child: IconTheme.merge(
            data: IconThemeData(size: m.iconSize),
            child: widget.icon!,
          ),
        ),
        SizedBox(width: m.iconGap),
        Flexible(child: text),
      ],
    );
  }
}
