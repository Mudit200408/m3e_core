// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'm3e_progress_indicator_defaults.dart';
import 'm3e_progress_indicator_utils.dart';

/// A Material 3 Expressive linear progress indicator.
///
/// Progress indicators express an unspecified wait time or display the duration
/// of a process.
///
/// If [value] is null, this progress indicator is indeterminate, which means
/// it animates continuously to show that a process is ongoing.
/// If [value] is non-null, it is determinate and displays the progress.
class M3ELinearProgressIndicator extends StatefulWidget {
  /// The progress value, between 0.0 and 1.0.
  /// If null, the indicator is indeterminate.
  final double? value;

  /// The color of the active progress indicator.
  final Color? color;

  /// The background color of the track.
  final Color? backgroundColor;

  /// The height/thickness of the indicator.
  final double minHeight;

  /// The stroke cap style for the ends of the progress indicator and track.
  final StrokeCap strokeCap;

  /// The gap size between the active progress and the track.
  final double gapSize;

  /// The size of the stop indicator at the end of the track.
  final double stopSize;

  /// The width of the container. Defaults to double.infinity.
  final double width;

  const M3ELinearProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.minHeight = M3EProgressIndicatorDefaults.linearStrokeWidth,
    this.strokeCap = StrokeCap.round,
    this.gapSize = M3EProgressIndicatorDefaults.linearIndicatorTrackGapSize,
    this.stopSize = M3EProgressIndicatorDefaults.linearTrackStopIndicatorSize,
    this.width = double.infinity,
  });

  @override
  State<M3ELinearProgressIndicator> createState() =>
      _M3ELinearProgressIndicatorState();
}

class _M3ELinearProgressIndicatorState extends State<M3ELinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1750),
    );
    if (widget.value == null) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant M3ELinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null &&
        !oldWidget.value.runtimeType.toString().contains('Null')) {
      if (!_animationController.isAnimating) {
        _animationController.repeat();
      }
    } else if (widget.value != null) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        widget.color ?? M3EProgressIndicatorDefaults.activeColor(context);
    final trackColor =
        widget.backgroundColor ??
        M3EProgressIndicatorDefaults.trackColor(context);

    return Container(
      constraints: BoxConstraints.tightFor(
        width: widget.width,
        height: widget.minHeight,
      ),
      child: widget.value != null
          ? CustomPaint(
              painter: _LinearProgressPainter(
                progress: widget.value!.clamp(0.0, 1.0),
                color: activeColor,
                trackColor: trackColor,
                strokeHeight: widget.minHeight,
                strokeCap: widget.strokeCap,
                gapSize: widget.gapSize,
                stopSize: widget.stopSize,
                isLtr: Directionality.of(context) == TextDirection.ltr,
              ),
            )
          : AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _LinearProgressPainter(
                    progress: null,
                    animationValue: _animationController.value,
                    color: activeColor,
                    trackColor: trackColor,
                    strokeHeight: widget.minHeight,
                    strokeCap: widget.strokeCap,
                    gapSize: widget.gapSize,
                    stopSize: widget.stopSize,
                    isLtr: Directionality.of(context) == TextDirection.ltr,
                  ),
                );
              },
            ),
    );
  }
}

class _LinearProgressPainter extends CustomPainter {
  final double? progress;
  final double? animationValue;
  final Color color;
  final Color trackColor;
  final double strokeHeight;
  final StrokeCap strokeCap;
  final double gapSize;
  final double stopSize;
  final bool isLtr;

  static const Curve _lineEasing = Cubic(0.3, 0.0, 0.8, 0.15);

  _LinearProgressPainter({
    required this.progress,
    this.animationValue,
    required this.color,
    required this.trackColor,
    required this.strokeHeight,
    required this.strokeCap,
    required this.gapSize,
    required this.stopSize,
    required this.isLtr,
  });

  void _drawLinearIndicator(
    Canvas canvas,
    double startFraction,
    double endFraction,
    Color paintColor,
    Size size,
    Paint paint,
  ) {
    final double width = size.width;
    final double yOffset = size.height / 2;

    final double barStart = (isLtr ? startFraction : 1.0 - endFraction) * width;
    final double barEnd = (isLtr ? endFraction : 1.0 - startFraction) * width;

    paint.color = paintColor;

    if (strokeCap == StrokeCap.butt || strokeHeight > width) {
      canvas.drawLine(
        Offset(barStart, yOffset),
        Offset(barEnd, yOffset),
        paint..strokeCap = strokeCap,
      );
    } else {
      final double strokeCapOffset = strokeHeight / 2;
      final double adjustedBarStart = barStart.clamp(
        strokeCapOffset,
        width - strokeCapOffset,
      );
      final double adjustedBarEnd = barEnd.clamp(
        strokeCapOffset,
        width - strokeCapOffset,
      );

      if ((endFraction - startFraction).abs() > 0) {
        canvas.drawLine(
          Offset(adjustedBarStart, yOffset),
          Offset(adjustedBarEnd, yOffset),
          paint..strokeCap = strokeCap,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeHeight;

    final double adjustedGapSize = strokeCap == StrokeCap.butt
        ? gapSize
        : gapSize + strokeHeight;
    final double gapSizeFraction = adjustedGapSize / size.width;

    if (progress != null) {
      // determinate mode
      final double currentProgress = progress!;

      // track
      final double trackStartFraction =
          currentProgress + math.min(currentProgress, gapSizeFraction);
      if (trackStartFraction <= 1.0) {
        _drawLinearIndicator(
          canvas,
          trackStartFraction,
          1.0,
          trackColor,
          size,
          paint,
        );
      }

      // active progress
      _drawLinearIndicator(canvas, 0.0, currentProgress, color, size, paint);

      // stop indicator
      M3EProgressIndicatorUtils.drawStopIndicator(
        canvas: canvas,
        size: size,
        progressEnd: currentProgress,
        stopSize: stopSize,
        strokeWidth: strokeHeight,
        color: color,
        isLtr: isLtr,
        strokeCap: strokeCap,
      );
    } else {
      // indeterminate mode
      final double t = animationValue ?? 0.0;

      final double firstLineHead =
          M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
            t: t,
            delayMs: 0.0,
            durationMs: 1000.0,
            easing: _lineEasing,
          );
      final double firstLineTail =
          M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
            t: t,
            delayMs: 250.0,
            durationMs: 1000.0,
            easing: _lineEasing,
          );
      final double secondLineHead =
          M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
            t: t,
            delayMs: 650.0,
            durationMs: 850.0,
            easing: _lineEasing,
          );
      final double secondLineTail =
          M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
            t: t,
            delayMs: 900.0,
            durationMs: 850.0,
            easing: _lineEasing,
          );

      // Track before line 1
      if (firstLineHead < 1.0 - gapSizeFraction) {
        final double start = firstLineHead > 0
            ? firstLineHead + gapSizeFraction
            : 0.0;
        _drawLinearIndicator(canvas, start, 1.0, trackColor, size, paint);
      }

      // Line 1
      if (firstLineHead - firstLineTail > 0) {
        _drawLinearIndicator(
          canvas,
          firstLineTail,
          firstLineHead,
          color,
          size,
          paint,
        );
      }

      // Track between line 1 and line 2
      if (firstLineTail > gapSizeFraction) {
        final double start = secondLineHead > 0
            ? secondLineHead + gapSizeFraction
            : 0.0;
        final double end = firstLineTail < 1.0
            ? firstLineTail - gapSizeFraction
            : 1.0;
        if (start < end) {
          _drawLinearIndicator(canvas, start, end, trackColor, size, paint);
        }
      }

      // Line 2
      if (secondLineHead - secondLineTail > 0) {
        _drawLinearIndicator(
          canvas,
          secondLineTail,
          secondLineHead,
          color,
          size,
          paint,
        );
      }

      // Track after line 2
      if (secondLineTail > gapSizeFraction) {
        final double end = secondLineTail < 1.0
            ? secondLineTail - gapSizeFraction
            : 1.0;
        _drawLinearIndicator(canvas, 0.0, end, trackColor, size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinearProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeHeight != strokeHeight ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.gapSize != gapSize ||
        oldDelegate.stopSize != stopSize ||
        oldDelegate.isLtr != isLtr;
  }
}
