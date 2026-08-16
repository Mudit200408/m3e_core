// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';

import '../../common/m3e_common.dart';
import '../style/m3e_seekbar_decoration.dart';
import '../style/m3e_seekbar_handle_shape.dart';
import '../style/m3e_seekbar_theme.dart';

/// A Material 3 Expressive Seekbar component.
///
/// Direct drop-in replacement for Flutter's standard [Slider], extended with M3E spring physics,
/// handle shape tokens (`circle` vs `rectangle`), secondary (buffered) progress, keyboard navigation,
/// and rich haptics.
class M3ESeekbar extends StatefulWidget {
  /// The current value of the seekbar, between [min] and [max].
  final double value;

  /// Callback when the user is changing the value.
  final ValueChanged<double>? onChanged;

  /// Callback when the user starts changing the value.
  final ValueChanged<double>? onChangeStart;

  /// Callback when the user finishes changing the value.
  final ValueChanged<double>? onChangeEnd;

  /// Minimum value of the seekbar. Defaults to 0.0.
  final double min;

  /// Maximum value of the seekbar. Defaults to 1.0.
  final double max;

  /// Optional secondary value for progress (e.g., audio/video buffering).
  final double? secondaryTrackValue;

  /// Whether the seekbar is enabled for interaction.
  final bool enabled;

  /// Focus node for keyboard accessibility.
  final FocusNode? focusNode;

  /// Whether this seekbar should automatically request focus on launch.
  final bool autofocus;

  /// Optional label pill displayed above the handle while scrubbing.
  final String? label;

  /// Layout direction. Defaults to [Axis.horizontal].
  final Axis orientation;

  /// Shortcut override for handle shape token (`circle` or `rectangle`).
  final M3ESeekbarHandleShape? handleShape;

  /// Custom height of the seekbar track.
  final double? trackHeight;

  /// Custom corner radius of the seekbar track.
  final double? trackCornerRadius;

  /// Custom width of a rectangular handle.
  final double? handleWidth;

  /// Custom height of a rectangular handle.
  final double? handleHeight;

  /// Custom radius of a circular handle.
  final double? handleRadius;

  /// Override for the active track color (Flutter [Slider] parity).
  final Color? activeColor;

  /// Override for the inactive track color (Flutter [Slider] parity).
  final Color? inactiveColor;

  /// Override for the secondary track color (Flutter [Slider] parity).
  final Color? secondaryActiveColor;

  /// Override for the handle thumb color (Flutter [Slider] parity).
  final Color? thumbColor;

  /// Styling and haptic configuration overrides.
  final M3ESeekbarDecoration? decoration;

  const M3ESeekbar({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.secondaryTrackValue,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.label,
    this.orientation = Axis.horizontal,
    this.handleShape,
    this.trackHeight,
    this.trackCornerRadius,
    this.handleWidth,
    this.handleHeight,
    this.handleRadius,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.decoration,
  }) : assert(min <= max),
       assert(value >= min && value <= max),
       assert(
         secondaryTrackValue == null ||
             (secondaryTrackValue >= min && secondaryTrackValue <= max),
       );

  @override
  State<M3ESeekbar> createState() => _M3ESeekbarState();
}

class _M3ESeekbarState extends State<M3ESeekbar> with TickerProviderStateMixin {
  late FocusNode _focusNode;

  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  RenderBox? _renderBox;
  M3EHapticTracker? _hapticTracker;

  late final SingleMotionController _interactionMotionController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _interactionMotionController = SingleMotionController(
      motion: M3EMotion.expressiveSpatialFast.toMotion(),
      vsync: this,
      initialValue: 0.0,
    );

    _isHovered.addListener(_updateInteractionAnimation);
    _isPressed.addListener(_updateInteractionAnimation);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _interactionMotionController.dispose();
    _isHovered.removeListener(_updateInteractionAnimation);
    _isPressed.removeListener(_updateInteractionAnimation);
    _isHovered.dispose();
    _isPressed.dispose();
    _isFocused.dispose();
    super.dispose();
  }

  bool _isFocusedFromPointer = false;

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _isFocusedFromPointer = false;
    }
    _isFocused.value = _focusNode.hasFocus && !_isFocusedFromPointer;
  }

  void _updateInteractionAnimation() {
    if (_isPressed.value || _isHovered.value) {
      _interactionMotionController.animateTo(1.0);
    } else {
      _interactionMotionController.animateTo(0.0);
    }
  }

  double _valueToFraction(double value) {
    if (widget.max == widget.min) return 0.0;
    return ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  }

  double _fractionToValue(double fraction) {
    return fraction * (widget.max - widget.min) + widget.min;
  }

  void _initHapticTracker(Offset globalPosition) {
    final haptic = widget.decoration?.haptic ?? M3EHapticFeedback.none;
    final config =
        widget.decoration?.hapticConfig ?? const M3EHapticConfig.continuous();

    _hapticTracker = M3EHapticTracker(baseHaptic: haptic, config: config);
    _hapticTracker!.start(_valueToFraction(widget.value), globalPosition);
  }

  void _updateValue(double newValue) {
    if (!widget.enabled || widget.onChanged == null) return;
    final clamped = newValue.clamp(widget.min, widget.max);
    widget.onChanged!(clamped);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled) return;
    _isFocusedFromPointer = true;
    _focusNode.requestFocus();
    _isPressed.value = true;
    _renderBox = context.findRenderObject() as RenderBox;
    _initHapticTracker(details.globalPosition);
    widget.onChangeStart?.call(widget.value);
  }

  void _handleDragUpdate(DragUpdateDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;
    final RenderBox renderBox = _renderBox!;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    final effectiveShape =
        widget.handleShape ??
        widget.decoration?.handleShape ??
        M3ESeekbarHandleShape.circle;
    final margin = effectiveShape == M3ESeekbarHandleShape.circle
        ? (widget.decoration?.handleRadius ??
              M3ESeekbarDefaults.circleHandleRadius)
        : ((widget.decoration?.handleWidth ??
                  M3ESeekbarDefaults.rectHandleWidth) /
              2);

    final usableLength = totalLength - 2 * margin;
    if (usableLength <= 0) return;

    final double fraction;
    if (widget.orientation == Axis.horizontal) {
      final localX = localPosition.dx - margin;
      fraction = (localX / usableLength).clamp(0.0, 1.0);
    } else {
      final localY = localPosition.dy - margin;
      fraction = (1.0 - (localY / usableLength)).clamp(0.0, 1.0);
    }

    final rawValue = _fractionToValue(fraction);
    _hapticTracker?.update(fraction, details.globalPosition);
    _updateValue(rawValue);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;
    _isPressed.value = false;
    _renderBox = null;
    _hapticTracker = null;
    widget.onChangeEnd?.call(widget.value);
  }

  void _handleTapDown(TapDownDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;
    _isFocusedFromPointer = true;
    _focusNode.requestFocus();
    _isPressed.value = true;
    _renderBox = context.findRenderObject() as RenderBox;
    _initHapticTracker(details.globalPosition);
    widget.onChangeStart?.call(widget.value);

    _handleTapUpDetails(details.globalPosition, totalLength);
  }

  void _handleTapUp(TapUpDetails details, double totalLength) {
    if (!widget.enabled) return;
    _isPressed.value = false;
    _renderBox = null;
    _hapticTracker = null;
    widget.onChangeEnd?.call(widget.value);
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    _isPressed.value = false;
    _renderBox = null;
    _hapticTracker = null;
  }

  void _handleTapUpDetails(Offset globalPos, double totalLength) {
    final RenderBox? renderBox = _renderBox;
    if (renderBox == null) return;
    final localPosition = renderBox.globalToLocal(globalPos);

    final effectiveShape =
        widget.handleShape ??
        widget.decoration?.handleShape ??
        M3ESeekbarHandleShape.circle;
    final margin = effectiveShape == M3ESeekbarHandleShape.circle
        ? (widget.decoration?.handleRadius ??
              M3ESeekbarDefaults.circleHandleRadius)
        : ((widget.decoration?.handleWidth ??
                  M3ESeekbarDefaults.rectHandleWidth) /
              2);

    final usableLength = totalLength - 2 * margin;
    if (usableLength <= 0) return;

    final double fraction;
    if (widget.orientation == Axis.horizontal) {
      final localX = localPosition.dx - margin;
      fraction = (localX / usableLength).clamp(0.0, 1.0);
    } else {
      final localY = localPosition.dy - margin;
      fraction = (1.0 - (localY / usableLength)).clamp(0.0, 1.0);
    }
    final targetVal = _fractionToValue(fraction);
    _updateValue(targetVal);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (_isFocusedFromPointer) {
      _isFocusedFromPointer = false;
      _isFocused.value = _focusNode.hasFocus;
    }
    if (!widget.enabled || widget.onChanged == null) {
      return KeyEventResult.ignored;
    }

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final range = widget.max - widget.min;
      const actualSteps = 100;
      final delta = range / actualSteps;

      double? targetValue;

      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        targetValue = widget.value + delta;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        targetValue = widget.value - delta;
      } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
        final page = math.max(1, actualSteps ~/ 10);
        targetValue = widget.value + page * delta;
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        final page = math.max(1, actualSteps ~/ 10);
        targetValue = widget.value - page * delta;
      } else if (event.logicalKey == LogicalKeyboardKey.home) {
        targetValue = widget.min;
      } else if (event.logicalKey == LogicalKeyboardKey.end) {
        targetValue = widget.max;
      }

      if (targetValue != null) {
        _updateValue(targetValue);
        return KeyEventResult.handled;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.pageUp ||
          event.logicalKey == LogicalKeyboardKey.pageDown ||
          event.logicalKey == LogicalKeyboardKey.home ||
          event.logicalKey == LogicalKeyboardKey.end) {
        widget.onChangeEnd?.call(widget.value);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final defaultColors = M3ESeekbarDefaults.colors(context);
    final decColors = widget.decoration?.colors;

    final resolvedColors = M3ESeekbarColors(
      handleColor:
          widget.thumbColor ??
          decColors?.handleColor ??
          defaultColors.handleColor,
      disabledHandleColor:
          decColors?.disabledHandleColor ?? defaultColors.disabledHandleColor,
      activeTrackColor:
          widget.activeColor ??
          decColors?.activeTrackColor ??
          defaultColors.activeTrackColor,
      inactiveTrackColor:
          widget.inactiveColor ??
          decColors?.inactiveTrackColor ??
          defaultColors.inactiveTrackColor,
      disabledActiveTrackColor:
          decColors?.disabledActiveTrackColor ??
          defaultColors.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          decColors?.disabledInactiveTrackColor ??
          defaultColors.disabledInactiveTrackColor,
      secondaryTrackColor:
          widget.secondaryActiveColor ??
          decColors?.secondaryTrackColor ??
          defaultColors.secondaryTrackColor,
      disabledSecondaryTrackColor:
          decColors?.disabledSecondaryTrackColor ??
          defaultColors.disabledSecondaryTrackColor,
    );

    final effectiveShape =
        widget.handleShape ??
        widget.decoration?.handleShape ??
        M3ESeekbarHandleShape.circle;

    final double trackHeight =
        widget.trackHeight ??
        widget.decoration?.trackHeight ??
        M3ESeekbarDefaults.trackHeight;

    final double handleRadius =
        widget.handleRadius ??
        widget.decoration?.handleRadius ??
        M3ESeekbarDefaults.circleHandleRadius;
    final double rectWidth =
        widget.handleWidth ??
        widget.decoration?.handleWidth ??
        M3ESeekbarDefaults.rectHandleWidth;
    final double rectHeight =
        widget.handleHeight ??
        widget.decoration?.handleHeight ??
        M3ESeekbarDefaults.rectHandleHeight;

    final double? trackCornerRadius =
        widget.trackCornerRadius ?? widget.decoration?.trackCornerRadius;

    final double valueFraction = _valueToFraction(widget.value);
    final double? secondaryFraction = widget.secondaryTrackValue != null
        ? _valueToFraction(widget.secondaryTrackValue!)
        : null;

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKeyEvent,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => _isHovered.value = true,
        onExit: (_) => _isHovered.value = false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalLength = widget.orientation == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: widget.orientation == Axis.horizontal
                  ? _handleDragStart
                  : null,
              onHorizontalDragUpdate: widget.orientation == Axis.horizontal
                  ? (d) => _handleDragUpdate(d, totalLength)
                  : null,
              onHorizontalDragEnd: widget.orientation == Axis.horizontal
                  ? _handleDragEnd
                  : null,
              onVerticalDragStart: widget.orientation == Axis.vertical
                  ? _handleDragStart
                  : null,
              onVerticalDragUpdate: widget.orientation == Axis.vertical
                  ? (d) => _handleDragUpdate(d, totalLength)
                  : null,
              onVerticalDragEnd: widget.orientation == Axis.vertical
                  ? _handleDragEnd
                  : null,
              onTapDown: (d) => _handleTapDown(d, totalLength),
              onTapUp: (d) => _handleTapUp(d, totalLength),
              onTapCancel: _handleTapCancel,
              child: SizedBox(
                width: widget.orientation == Axis.horizontal
                    ? double.infinity
                    : trackHeight,
                height: widget.orientation == Axis.horizontal
                    ? trackHeight
                    : double.infinity,
                child: RepaintBoundary(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isFocused,
                    builder: (context, isFocused, _) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _isPressed,
                        builder: (context, isPressed, _) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // 1. Track Painter
                              CustomPaint(
                                size: Size(
                                  widget.orientation == Axis.horizontal
                                      ? totalLength
                                      : trackHeight,
                                  widget.orientation == Axis.horizontal
                                      ? trackHeight
                                      : totalLength,
                                ),
                                painter: _SeekbarTrackPainter(
                                  valueFraction: valueFraction,
                                  secondaryFraction: secondaryFraction,
                                  colors: resolvedColors,
                                  enabled: widget.enabled,
                                  isFocused: isFocused,
                                  orientation: widget.orientation,
                                  trackHeight: trackHeight,
                                  trackCornerRadius: trackCornerRadius,
                                  handleShape: effectiveShape,
                                  circleHandleRadius: handleRadius,
                                  rectHandleWidth: rectWidth,
                                ),
                              ),
                              // 2. Handle Painter
                              CustomPaint(
                                size: Size(
                                  widget.orientation == Axis.horizontal
                                      ? totalLength
                                      : trackHeight,
                                  widget.orientation == Axis.horizontal
                                      ? trackHeight
                                      : totalLength,
                                ),
                                painter: M3ESeekbarHandlePainter(
                                  valueFraction: valueFraction,
                                  colors: resolvedColors,
                                  enabled: widget.enabled,
                                  isFocused: isFocused,
                                  isPressed: isPressed,
                                  interactionController:
                                      _interactionMotionController,
                                  orientation: widget.orientation,
                                  handleShape: effectiveShape,
                                  circleRadius: handleRadius,
                                  rectWidth: rectWidth,
                                  rectHeight: rectHeight,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class M3ESeekbarHandlePainter extends CustomPainter {
  final double valueFraction;
  final M3ESeekbarColors colors;
  final bool enabled;
  final bool isFocused;
  final bool isPressed;
  final ValueListenable<double>? interactionController;
  final double? interactionProgress;
  final Axis orientation;
  final M3ESeekbarHandleShape handleShape;
  final double circleRadius;
  final double rectWidth;
  final double rectHeight;

  M3ESeekbarHandlePainter({
    required this.valueFraction,
    required this.colors,
    required this.enabled,
    required this.isFocused,
    required this.isPressed,
    this.interactionController,
    this.interactionProgress,
    required this.orientation,
    required this.handleShape,
    required this.circleRadius,
    required this.rectWidth,
    required this.rectHeight,
    Listenable? repaint,
  }) : super(repaint: repaint ?? interactionController);

  @override
  void paint(Canvas canvas, Size size) {
    final margin = handleShape == M3ESeekbarHandleShape.circle
        ? circleRadius
        : (rectWidth / 2);

    final double trackLength =
        (orientation == Axis.horizontal ? size.width : size.height) -
        2 * margin;
    if (trackLength <= 0) return;

    final double startPos = margin;
    final double endPos =
        (orientation == Axis.horizontal ? size.width : size.height) - margin;

    final double handlePos = orientation == Axis.horizontal
        ? startPos + trackLength * valueFraction
        : endPos - trackLength * valueFraction;

    final handleCenter = orientation == Axis.horizontal
        ? Offset(handlePos, size.height / 2)
        : Offset(size.width / 2, handlePos);

    final bool showFocusRing =
        isFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    final handlePaint = Paint()
      ..color = enabled ? colors.handleColor : colors.disabledHandleColor
      ..style = PaintingStyle.fill;

    final currentInteractionProgress =
        interactionProgress ?? interactionController?.value ?? 0.0;

    if (handleShape == M3ESeekbarHandleShape.circle) {
      final effectiveRadius = lerpDouble(
        circleRadius,
        circleRadius * 1.25,
        currentInteractionProgress,
      )!;

      canvas.drawCircle(handleCenter, effectiveRadius, handlePaint);

      if (showFocusRing && enabled) {
        final focusPaint = Paint()
          ..color = colors.handleColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

        canvas.drawCircle(handleCenter, effectiveRadius + 4.0, focusPaint);
      }
    } else {
      final currentWidth = lerpDouble(
        rectWidth,
        rectWidth * 1.5,
        currentInteractionProgress,
      )!;
      final currentHeight = lerpDouble(
        rectHeight,
        rectHeight * 0.9,
        currentInteractionProgress,
      )!;

      final w = orientation == Axis.horizontal ? currentWidth : currentHeight;
      final h = orientation == Axis.horizontal ? currentHeight : currentWidth;
      final cornerRadius = Radius.circular(math.min(w, h) / 2);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: handleCenter, width: w, height: h),
        cornerRadius,
      );

      canvas.drawRRect(rrect, handlePaint);

      if (showFocusRing && enabled) {
        final focusPaint = Paint()
          ..color = colors.handleColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

        final focusRRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: handleCenter,
            width: w + 6.0,
            height: h + 6.0,
          ),
          Radius.circular((math.min(w, h) + 6.0) / 2),
        );
        canvas.drawRRect(focusRRect, focusPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant M3ESeekbarHandlePainter oldDelegate) {
    return oldDelegate.valueFraction != valueFraction ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.isFocused != isFocused ||
        oldDelegate.isPressed != isPressed ||
        oldDelegate.interactionController != interactionController ||
        oldDelegate.interactionProgress != interactionProgress ||
        oldDelegate.orientation != orientation ||
        oldDelegate.handleShape != handleShape ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.rectWidth != rectWidth ||
        oldDelegate.rectHeight != rectHeight;
  }
}

class _SeekbarTrackPainter extends CustomPainter {
  final double valueFraction;
  final double? secondaryFraction;
  final M3ESeekbarColors colors;
  final bool enabled;
  final bool isFocused;
  final Axis orientation;
  final double trackHeight;
  final double? trackCornerRadius;
  final M3ESeekbarHandleShape handleShape;
  final double circleHandleRadius;
  final double rectHandleWidth;

  _SeekbarTrackPainter({
    required this.valueFraction,
    required this.secondaryFraction,
    required this.colors,
    required this.enabled,
    required this.isFocused,
    required this.orientation,
    required this.trackHeight,
    required this.trackCornerRadius,
    required this.handleShape,
    required this.circleHandleRadius,
    required this.rectHandleWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final margin = handleShape == M3ESeekbarHandleShape.circle
        ? circleHandleRadius
        : (rectHandleWidth / 2);

    final double trackLength =
        (orientation == Axis.horizontal ? size.width : size.height) -
        2 * margin;
    if (trackLength <= 0) return;

    final double startPos = margin;
    final double endPos =
        (orientation == Axis.horizontal ? size.width : size.height) - margin;

    final double handlePos = orientation == Axis.horizontal
        ? startPos + trackLength * valueFraction
        : endPos - trackLength * valueFraction;

    final inactivePaint = Paint()
      ..color = enabled
          ? colors.inactiveTrackColor
          : colors.disabledInactiveTrackColor
      ..style = PaintingStyle.fill;

    final secondaryPaint = Paint()
      ..color = enabled
          ? colors.secondaryTrackColor
          : colors.disabledSecondaryTrackColor
      ..style = PaintingStyle.fill;

    final activePaint = Paint()
      ..color = enabled
          ? colors.activeTrackColor
          : colors.disabledActiveTrackColor
      ..style = PaintingStyle.fill;

    final double effectiveCornerRadius = trackCornerRadius ?? (trackHeight / 2);
    final radius = Radius.circular(effectiveCornerRadius);

    if (orientation == Axis.horizontal) {
      final centerY = size.height / 2;
      final top = centerY - trackHeight / 2;
      final bottom = centerY + trackHeight / 2;

      // Inactive
      final inactiveRRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(startPos, top, endPos, bottom),
        radius,
      );
      canvas.drawRRect(inactiveRRect, inactivePaint);

      // Secondary
      if (secondaryFraction != null && secondaryFraction! > valueFraction) {
        final secEnd = (startPos + trackLength * secondaryFraction!).clamp(
          startPos,
          endPos,
        );
        final secRRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(startPos, top, secEnd, bottom),
          radius,
        );
        canvas.drawRRect(secRRect, secondaryPaint);
      }

      // Active
      final activeEnd = handlePos.clamp(startPos, endPos);
      if (activeEnd > startPos) {
        final activeRRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(startPos, top, activeEnd, bottom),
          radius,
        );
        canvas.drawRRect(activeRRect, activePaint);
      }
    } else {
      final centerX = size.width / 2;
      final left = centerX - trackHeight / 2;
      final right = centerX + trackHeight / 2;

      // Inactive
      final inactiveRRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, startPos, right, endPos),
        radius,
      );
      canvas.drawRRect(inactiveRRect, inactivePaint);

      // Secondary
      if (secondaryFraction != null && secondaryFraction! > valueFraction) {
        final secEnd = (endPos - trackLength * secondaryFraction!).clamp(
          startPos,
          endPos,
        );
        final secRRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(left, secEnd, right, endPos),
          radius,
        );
        canvas.drawRRect(secRRect, secondaryPaint);
      }

      // Active
      final activeEnd = handlePos.clamp(startPos, endPos);
      if (activeEnd < endPos) {
        final activeRRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(left, activeEnd, right, endPos),
          radius,
        );
        canvas.drawRRect(activeRRect, activePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SeekbarTrackPainter oldDelegate) {
    return oldDelegate.valueFraction != valueFraction ||
        oldDelegate.secondaryFraction != secondaryFraction ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.isFocused != isFocused ||
        oldDelegate.orientation != orientation ||
        oldDelegate.trackHeight != trackHeight ||
        oldDelegate.handleShape != handleShape ||
        oldDelegate.circleHandleRadius != circleHandleRadius ||
        oldDelegate.rectHandleWidth != rectHandleWidth;
  }
}
