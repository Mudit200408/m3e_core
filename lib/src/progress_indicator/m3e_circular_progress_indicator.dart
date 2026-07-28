// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'm3e_progress_indicator_defaults.dart';

/// A Material 3 Expressive circular progress indicator.
///
/// Progress indicators express an unspecified wait time or display the duration
/// of a process.
///
/// If [value] is null, this progress indicator is indeterminate, which means
/// it animates continuously to show that a process is ongoing.
/// If [value] is non-null, it is determinate and displays the progress.
class M3ECircularProgressIndicator extends StatefulWidget {
  /// The progress value, between 0.0 and 1.0.
  /// If null, the indicator is indeterminate.
  final double? value;

  /// The color of the active progress indicator.
  final Color? color;

  /// The background color of the track.
  final Color? backgroundColor;

  /// The stroke width of the indicator's path.
  final double strokeWidth;

  /// The stroke cap style for the ends of the progress indicator.
  final StrokeCap strokeCap;

  /// The gap size between the active progress and the track.
  final double gapSize;

  /// The size/diameter of the indicator.
  final double size;

  const M3ECircularProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = M3EProgressIndicatorDefaults.circularStrokeWidth,
    this.strokeCap = StrokeCap.round,
    this.gapSize = M3EProgressIndicatorDefaults.circularIndicatorTrackGapSize,
    this.size = M3EProgressIndicatorDefaults.circularContainerSize,
  });

  @override
  State<M3ECircularProgressIndicator> createState() =>
      _M3ECircularProgressIndicatorState();
}

class _M3ECircularProgressIndicatorState
    extends State<M3ECircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    if (widget.value == null) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant M3ECircularProgressIndicator oldWidget) {
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.value != null
          ? CustomPaint(
              painter: _CircularProgressPainter(
                progress: widget.value!.clamp(0.0, 1.0),
                color: activeColor,
                trackColor: trackColor,
                strokeWidth: widget.strokeWidth,
                strokeCap: widget.strokeCap,
                gapSize: widget.gapSize,
                isLtr: Directionality.of(context) == TextDirection.ltr,
              ),
            )
          : AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: null,
                    animationValue: _animationController.value,
                    color: activeColor,
                    trackColor: trackColor,
                    strokeWidth: widget.strokeWidth,
                    strokeCap: widget.strokeCap,
                    gapSize: widget.gapSize,
                    isLtr: Directionality.of(context) == TextDirection.ltr,
                  ),
                );
              },
            ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double? progress;
  final double? animationValue;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final double gapSize;
  final bool isLtr;

  static const Curve _decelerateEasing = Cubic(0.05, 0.7, 0.1, 1.0);

  _CircularProgressPainter({
    required this.progress,
    this.animationValue,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.strokeCap,
    required this.gapSize,
    required this.isLtr,
  });

  void _drawArc(
    Canvas canvas,
    double startAngleDegrees,
    double sweepAngleDegrees,
    Color paintColor,
    Size size,
    Paint paint,
  ) {
    paint.color = paintColor;

    final double diameterOffset = strokeWidth / 2;
    final double arcWidth = size.width - 2 * diameterOffset;
    final double arcHeight = size.height - 2 * diameterOffset;

    // Convert degrees to radians
    final double startAngleRadians = startAngleDegrees * math.pi / 180;
    final double sweepAngleRadians = sweepAngleDegrees * math.pi / 180;

    canvas.drawArc(
      Rect.fromLTWH(diameterOffset, diameterOffset, arcWidth, arcHeight),
      startAngleRadians,
      sweepAngleRadians,
      false,
      paint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    final double adjustedGapSize = strokeCap == StrokeCap.butt
        ? gapSize
        : gapSize + strokeWidth;

    // gap size sweep angle in degrees: gapSize / (PI * diameter) * 360
    final double gapSizeSweep =
        (adjustedGapSize / (math.pi * size.width)) * 360.0;

    canvas.save();
    if (!isLtr) {
      final double centerX = size.width / 2;
      final double centerY = size.height / 2;
      canvas.translate(centerX, centerY);
      canvas.scale(-1.0, 1.0);
      canvas.translate(-centerX, -centerY);
    }

    if (progress != null) {
      // determinate mode
      final double currentProgress = progress!;
      const double startAngle = 270.0; // 12 o'clock
      final double sweep = currentProgress * 360.0;

      // Draw track
      final double gapSweep = math.min(sweep, gapSizeSweep);
      final double trackStart = startAngle + sweep + gapSweep;
      final double trackSweep = 360.0 - sweep - gapSweep * 2.0;

      if (trackSweep > 0 && trackColor != Colors.transparent) {
        _drawArc(canvas, trackStart, trackSweep, trackColor, size, paint);
      }

      // Draw active indicator
      _drawArc(canvas, startAngle, sweep, color, size, paint);
    } else {
      // indeterminate mode
      final double t = animationValue ?? 0.0;

      // 1. Global rotation: 3 full rotations (1080 degrees) in 6 seconds
      final double globalRotation = t * 1080.0;

      // 2. Additional rotation: 90 degrees every 1500 ms
      final int cycleIndex = (t * 4).floor();
      final double tCycle = (t * 4) % 1.0;
      double additionalRotation = cycleIndex * 90.0;
      if (tCycle <= 0.2) {
        final double u = tCycle / 0.2;
        additionalRotation += 90.0 * _decelerateEasing.transform(u);
      } else {
        additionalRotation += 90.0;
      }

      // 3. Progress sweep: min 0.1 to max 0.87 progress
      double progressSweepFraction = 0.1;
      if (t <= 0.5) {
        final double u = t / 0.5;
        progressSweepFraction = lerpDouble(
          0.1,
          0.87,
          Curves.fastOutSlowIn.transform(u),
        )!;
      } else {
        final double u = (t - 0.5) / 0.5;
        progressSweepFraction = lerpDouble(
          0.87,
          0.1,
          Curves.fastOutSlowIn.transform(u),
        )!;
      }

      final double sweep = progressSweepFraction * 360.0;
      final double gapSweep = math.min(sweep, gapSizeSweep);

      canvas.save();
      // Rotate canvas about center
      final double centerX = size.width / 2;
      final double centerY = size.height / 2;
      canvas.translate(centerX, centerY);
      canvas.rotate((globalRotation + additionalRotation) * math.pi / 180);
      canvas.translate(-centerX, -centerY);

      // Draw track
      final double trackStart = sweep + gapSweep;
      final double trackSweep = 360.0 - sweep - gapSweep * 2.0;
      if (trackSweep > 0 && trackColor != Colors.transparent) {
        _drawArc(canvas, trackStart, trackSweep, trackColor, size, paint);
      }

      // Draw active indicator
      _drawArc(canvas, 0.0, sweep, color, size, paint);

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.gapSize != gapSize ||
        oldDelegate.isLtr != isLtr;
  }
}
