// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';

import '../../common/m3e_common.dart';
import '../style/m3e_seekbar_decoration.dart';
import '../style/m3e_seekbar_handle_shape.dart';
import '../style/m3e_seekbar_theme.dart';
import 'm3e_seekbar.dart';

/// A Material 3 Expressive Wavy Seekbar component built on AOSP SystemUI [SquigglyProgress].
///
/// Implements Android SystemUI's squiggly wave progress bar:
/// - Smooth amplitude height transitions (`800ms` grow on playback, `550ms` flatten on pause/scrub)
/// - Cubic Bezier curve waveform rendering (`cubicTo`)
/// - Horizontal phase scrolling (`phaseSpeed`)
/// - Amplitude tapering across transition periods near the progress boundary
/// - Canvas clipRect masking for active progress and remaining track
/// - Dual handle shape tokens (`circle` vs `rectangle`) with spring interactions ([motor])
class M3EWavySeekbar extends StatefulWidget {
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

  /// Optional secondary value for progress (e.g. audio/video buffering).
  final double? secondaryTrackValue;

  /// Whether the seekbar is enabled.
  final bool enabled;

  /// Whether media playback is currently playing.
  /// When playing is true, the wave oscillates and reaches full amplitude height.
  /// When playing is false or scrubbing, the wave smoothly flattens to a straight line.
  final bool isPlaying;

  /// Horizontal length of the squiggly sine wave (AOSP `waveLength`).
  final double waveLength;

  /// Peak amplitude height of the squiggly sine wave (AOSP `lineAmplitude`).
  final double lineAmplitude;

  /// Phase speed in logical pixels per second (AOSP `phaseSpeed`).
  final double phaseSpeed;

  /// Stroke width of the wave and remaining track line.
  final double strokeWidth;

  /// Whether amplitude smooth transition tapering near progress point is enabled.
  final bool transitionEnabled;

  /// Height of the seekbar container.
  final double height;

  /// Custom corner radius of the seekbar track.
  final double? trackCornerRadius;

  /// Shortcut override for handle shape token (`circle` or `rectangle`).
  final M3ESeekbarHandleShape? handleShape;

  /// Custom width of a rectangular handle.
  final double? handleWidth;

  /// Custom height of a rectangular handle.
  final double? handleHeight;

  /// Custom radius of a circular handle.
  final double? handleRadius;

  /// Override for active track color (Flutter [Slider] parity).
  final Color? activeColor;

  /// Override for inactive track color (Flutter [Slider] parity).
  final Color? inactiveColor;

  /// Override for secondary track color (Flutter [Slider] parity).
  final Color? secondaryActiveColor;

  /// Override for handle thumb color (Flutter [Slider] parity).
  final Color? thumbColor;

  /// Focus node for keyboard accessibility.
  final FocusNode? focusNode;

  /// Whether this seekbar should automatically request focus on launch.
  final bool autofocus;

  /// Styling and haptic configuration overrides.
  final M3ESeekbarDecoration? decoration;

  const M3EWavySeekbar({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.secondaryTrackValue,
    this.enabled = true,
    this.isPlaying = true,
    this.focusNode,
    this.autofocus = false,
    this.waveLength = M3ESeekbarDefaults.waveLength,
    this.lineAmplitude = M3ESeekbarDefaults.lineAmplitude,
    this.phaseSpeed = M3ESeekbarDefaults.phaseSpeed,
    this.strokeWidth = M3ESeekbarDefaults.strokeWidth,
    this.transitionEnabled = true,
    this.height = 36.0,
    this.trackCornerRadius,
    this.handleShape,
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
  State<M3EWavySeekbar> createState() => _M3EWavySeekbarState();
}

class _M3EWavySeekbarState extends State<M3EWavySeekbar>
    with TickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _heightController;

  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  Ticker? _phaseTicker;
  Duration _lastElapsed = Duration.zero;
  late final ValueNotifier<double> _phaseNotifier = ValueNotifier<double>(0.0);

  RenderBox? _renderBox;
  M3EHapticTracker? _hapticTracker;

  late final SingleMotionController _interactionMotionController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _heightController = AnimationController(
      vsync: this,
      value: widget.isPlaying ? 1.0 : 0.0,
    );

    _interactionMotionController = SingleMotionController(
      motion: M3EMotion.expressiveSpatialFast.toMotion(),
      vsync: this,
      initialValue: 0.0,
    );

    _phaseTicker = createTicker(_onPhaseTick);
    if (widget.isPlaying) {
      _phaseTicker?.start();
    }

    _isHovered.addListener(_updateInteractionAnimation);
    _isPressed.addListener(_onScrubbingOrPlayingStateChanged);

    _updateAmplitudeState();
  }

  @override
  void didUpdateWidget(covariant M3EWavySeekbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _lastElapsed = Duration.zero;
        if (!(_phaseTicker?.isTicking ?? false)) {
          _phaseTicker?.start();
        }
      }
      _updateAmplitudeState();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _phaseTicker?.dispose();
    _phaseNotifier.dispose();
    _heightController.dispose();
    _interactionMotionController.dispose();
    _isHovered.removeListener(_updateInteractionAnimation);
    _isPressed.removeListener(_onScrubbingOrPlayingStateChanged);
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
      final actualSteps = 100;
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

  void _onPhaseTick(Duration elapsed) {
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    final dtSeconds = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    final speed = widget.decoration?.phaseSpeed ?? widget.phaseSpeed;
    final wLength = widget.decoration?.waveLength ?? widget.waveLength;

    _phaseNotifier.value = (_phaseNotifier.value + dtSeconds * speed) % wLength;
  }

  void _onScrubbingOrPlayingStateChanged() {
    _updateInteractionAnimation();
    _updateAmplitudeState();
  }

  void _updateAmplitudeState() {
    final bool shouldAnimateWave = widget.isPlaying && !_isPressed.value;
    final double targetHeight = shouldAnimateWave ? 1.0 : 0.0;

    if (shouldAnimateWave) {
      _heightController.animateTo(
        targetHeight,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _heightController.animateTo(
        targetHeight,
        duration: const Duration(milliseconds: 550),
        curve: Curves.decelerate,
      );
    }
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

    final localX = localPosition.dx - margin;
    final fraction = (localX / usableLength).clamp(0.0, 1.0);

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

    final localPosition = _renderBox!.globalToLocal(details.globalPosition);
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
    if (usableLength > 0) {
      final localX = localPosition.dx - margin;
      final fraction = (localX / usableLength).clamp(0.0, 1.0);
      _updateValue(_fractionToValue(fraction));
    }
  }

  void _handleTapUp(TapUpDetails details) {
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

    final double waveLength =
        widget.decoration?.waveLength ?? widget.waveLength;
    final double lineAmplitude =
        widget.decoration?.lineAmplitude ?? widget.lineAmplitude;
    final bool transitionEnabled =
        widget.decoration?.transitionEnabled ?? widget.transitionEnabled;

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
            final totalLength = constraints.maxWidth;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: _handleDragStart,
              onHorizontalDragUpdate: (d) => _handleDragUpdate(d, totalLength),
              onHorizontalDragEnd: _handleDragEnd,
              onTapDown: (d) => _handleTapDown(d, totalLength),
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: SizedBox(
                width: double.infinity,
                height: widget.height,
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
                              // 1. AOSP Squiggly Progress Track Painter
                              CustomPaint(
                                size: Size(totalLength, widget.height),
                                painter: _AOSPSquigglyTrackPainter(
                                  valueFraction: valueFraction,
                                  secondaryFraction: secondaryFraction,
                                  heightAnimation: _heightController,
                                  phaseNotifier: _phaseNotifier,
                                  waveLength: waveLength,
                                  lineAmplitude: lineAmplitude,
                                  strokeWidth: widget.strokeWidth,
                                  transitionEnabled: transitionEnabled,
                                  colors: resolvedColors,
                                  enabled: widget.enabled,
                                  handleShape: effectiveShape,
                                  circleHandleRadius: handleRadius,
                                  rectHandleWidth: rectWidth,
                                  trackCornerRadius: trackCornerRadius,
                                ),
                              ),
                              // 2. Handle Painter
                              CustomPaint(
                                size: Size(totalLength, widget.height),
                                painter: M3ESeekbarHandlePainter(
                                  valueFraction: valueFraction,
                                  colors: resolvedColors,
                                  enabled: widget.enabled,
                                  isFocused: isFocused,
                                  isPressed: isPressed,
                                  interactionController:
                                      _interactionMotionController,
                                  orientation: Axis.horizontal,
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

class _AOSPSquigglyTrackPainter extends CustomPainter {
  final double valueFraction;
  final double? secondaryFraction;
  final Animation<double> heightAnimation;
  final ValueNotifier<double> phaseNotifier;
  final double waveLength;
  final double lineAmplitude;
  final double strokeWidth;
  final bool transitionEnabled;
  final M3ESeekbarColors colors;
  final bool enabled;
  final M3ESeekbarHandleShape handleShape;
  final double circleHandleRadius;
  final double rectHandleWidth;
  final double? trackCornerRadius;

  _AOSPSquigglyTrackPainter({
    required this.valueFraction,
    required this.secondaryFraction,
    required this.heightAnimation,
    required this.phaseNotifier,
    required this.waveLength,
    required this.lineAmplitude,
    required this.strokeWidth,
    required this.transitionEnabled,
    required this.colors,
    required this.enabled,
    required this.handleShape,
    required this.circleHandleRadius,
    required this.rectHandleWidth,
    required this.trackCornerRadius,
  }) : super(repaint: Listenable.merge([heightAnimation, phaseNotifier]));

  double _lerpInvSat(double a, double b, double value) {
    if (a == b) return 0.0;
    return ((value - a) / (b - a)).clamp(0.0, 1.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final margin = handleShape == M3ESeekbarHandleShape.circle
        ? circleHandleRadius
        : (rectHandleWidth / 2);

    final double trackLength = size.width - 2 * margin;
    if (trackLength <= 0) return;

    final double heightFraction = heightAnimation.value;
    final double phaseOffset = phaseNotifier.value;

    final double totalProgressPx = trackLength * valueFraction;

    // AOSP SquigglyProgress layout mapping
    const transitionPeriods = M3ESeekbarDefaults.transitionPeriods;
    const minWaveEndpoint = 0.2;
    const matchedWaveEndpoint = 0.6;

    final double waveProgressPx =
        trackLength *
        (!transitionEnabled || valueFraction > matchedWaveEndpoint
            ? valueFraction
            : (minWaveEndpoint +
                  (matchedWaveEndpoint - minWaveEndpoint) *
                      _lerpInvSat(0.0, matchedWaveEndpoint, valueFraction)));

    final double waveStart = -phaseOffset - waveLength / 2.0;
    final double waveEnd = totalProgressPx + waveLength;

    double computeAmplitude(double x, double sign) {
      if (transitionEnabled) {
        final length = transitionPeriods * waveLength;
        final coeff = _lerpInvSat(
          waveProgressPx + length / 2.0,
          waveProgressPx - length / 2.0,
          x,
        );
        return sign * heightFraction * lineAmplitude * coeff;
      } else {
        return sign * heightFraction * lineAmplitude;
      }
    }

    final wavePath = Path();
    wavePath.moveTo(waveStart, 0.0);

    var currentX = waveStart;
    var waveSign = 1.0;
    var currentAmp = computeAmplitude(currentX, waveSign);
    final dist = waveLength / 2.0;

    while (currentX < waveEnd) {
      waveSign = -waveSign;
      final nextX = currentX + dist;
      final midX = currentX + dist / 2.0;
      final nextAmp = computeAmplitude(nextX, waveSign);
      wavePath.cubicTo(midX, currentAmp, midX, nextAmp, nextX, nextAmp);
      currentAmp = nextAmp;
      currentX = nextX;
    }

    final double maxRadius = strokeWidth / 2;
    final double effectiveRadius = trackCornerRadius != null
        ? trackCornerRadius!.clamp(0.0, maxRadius)
        : maxRadius;
    final radius = Radius.circular(effectiveRadius);

    final strokeCap = effectiveRadius <= 0.0 ? StrokeCap.butt : StrokeCap.round;

    final wavePaint = Paint()
      ..color = enabled
          ? colors.activeTrackColor
          : colors.disabledActiveTrackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth;

    final linePaint = Paint()
      ..color = enabled
          ? colors.inactiveTrackColor
          : colors.disabledInactiveTrackColor
      ..style = PaintingStyle.fill;

    final secondaryPaint = Paint()
      ..color = enabled
          ? colors.secondaryTrackColor
          : colors.disabledSecondaryTrackColor
      ..style = PaintingStyle.fill;

    final clipTop = lineAmplitude + strokeWidth + 4.0;
    final capPadding = strokeCap == StrokeCap.round ? strokeWidth : 0.0;

    canvas.save();
    canvas.translate(margin, size.height / 2);

    final trackTop = -strokeWidth / 2;
    final trackBottom = strokeWidth / 2;

    // 1. Draw Active Progress Squiggle (clipped up to totalProgressPx)
    if (totalProgressPx > 0) {
      canvas.save();
      canvas.clipRect(
        Rect.fromLTRB(-capPadding, -clipTop, totalProgressPx, clipTop),
      );
      canvas.drawPath(wavePath, wavePaint);
      canvas.restore();
    }

    // 2. Draw Secondary (Buffered) Track line if present
    if (secondaryFraction != null && secondaryFraction! > valueFraction) {
      final secPx = (trackLength * secondaryFraction!).clamp(0.0, trackLength);
      if (secPx > totalProgressPx) {
        final secRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(totalProgressPx, trackTop, secPx, trackBottom),
          topRight: radius,
          bottomRight: radius,
        );
        canvas.drawRRect(secRRect, secondaryPaint);
      }
    }

    // 3. Draw Remaining Inactive Track Line (from progress/buffer to end of track)
    final double remainingStartPx =
        secondaryFraction != null && secondaryFraction! > valueFraction
        ? (trackLength * secondaryFraction!)
        : totalProgressPx;

    if (remainingStartPx < trackLength) {
      final lineRRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(remainingStartPx, trackTop, trackLength, trackBottom),
        topRight: radius,
        bottomRight: radius,
      );
      canvas.drawRRect(lineRRect, linePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AOSPSquigglyTrackPainter oldDelegate) {
    return oldDelegate.valueFraction != valueFraction ||
        oldDelegate.secondaryFraction != secondaryFraction ||
        oldDelegate.heightAnimation != heightAnimation ||
        oldDelegate.phaseNotifier != phaseNotifier ||
        oldDelegate.waveLength != waveLength ||
        oldDelegate.lineAmplitude != lineAmplitude ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.transitionEnabled != transitionEnabled ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.handleShape != handleShape ||
        oldDelegate.circleHandleRadius != circleHandleRadius ||
        oldDelegate.rectHandleWidth != rectHandleWidth ||
        oldDelegate.trackCornerRadius != trackCornerRadius;
  }
}
