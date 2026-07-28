// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Shared helper utility methods for M3E progress indicators.
class M3EProgressIndicatorUtils {
  M3EProgressIndicatorUtils._();

  /// Evaluates an animation segment for indeterminate progress bars.
  static double evaluateIndeterminateSegment({
    required double t,
    required double delayMs,
    required double durationMs,
    required Curve easing,
    double totalDurationMs = 1750.0,
  }) {
    final double start = delayMs / totalDurationMs;
    final double end = (delayMs + durationMs) / totalDurationMs;
    if (t < start) return 0.0;
    if (t > end) return 1.0;
    final double localT = (t - start) / (end - start);
    return easing.transform(localT);
  }

  /// Draws a circular or rectangular stop indicator at the end of the track.
  static void drawStopIndicator({
    required Canvas canvas,
    required Size size,
    required double progressEnd,
    required double stopSize,
    required double strokeWidth,
    required Color color,
    required bool isLtr,
    required StrokeCap strokeCap,
  }) {
    if (stopSize <= 0) return;

    final double strokeCapOffset = strokeWidth / 2;
    double finalStopSize = math.min(stopSize, strokeWidth);

    // Max offset from end to prevent too much spacing
    final double maxStopOffset = 6.0; // 6.dp
    final double stopOffset = math.min(
      (strokeWidth - finalStopSize) / 2,
      maxStopOffset,
    );

    double indicatorX = size.width - finalStopSize - stopOffset;
    final double progressX = size.width * progressEnd + strokeCapOffset;

    if (indicatorX <= progressX) {
      finalStopSize = math.max(0.0, finalStopSize - (progressX - indicatorX));
      indicatorX = progressX;
    }

    if (finalStopSize > 0) {
      final Paint stopPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.save();
      if (!isLtr) {
        // Mirror horizontally
        canvas.translate(size.width, 0);
        canvas.scale(-1.0, 1.0);
      }

      if (strokeCap == StrokeCap.round) {
        canvas.drawCircle(
          Offset(indicatorX + finalStopSize / 2, size.height / 2),
          finalStopSize / 2,
          stopPaint,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(
            indicatorX,
            (size.height - finalStopSize) / 2,
            finalStopSize,
            finalStopSize,
          ),
          stopPaint,
        );
      }
      canvas.restore();
    }
  }
}
