// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'm3e_progress_indicator_defaults.dart';
import 'm3e_progress_indicator_utils.dart';

/// A Material 3 Expressive linear wavy progress indicator.
///
/// Progress indicators express an unspecified wait time or display the duration
/// of a process. This expressive wavy variant displays the progress as a waveform.
class M3ELinearWavyProgressIndicator extends StatefulWidget {
  /// The progress value, between 0.0 and 1.0.
  /// If null, the indicator is indeterminate.
  final double? value;

  /// The color of the active progress indicator.
  final Color? color;

  /// The background color of the track.
  final Color? backgroundColor;

  /// The stroke width of the active wavy line.
  final double strokeWidth;

  /// The stroke width of the track.
  final double trackStrokeWidth;

  /// The gap size between the active progress and the track.
  final double gapSize;

  /// The size of the stop indicator at the end of the track.
  final double stopSize;

  /// The preferred wavelength of the wave.
  final double wavelength;

  /// The speed of the wave scrolling (logical pixels per second).
  final double waveSpeed;

  /// Height of the container, accommodating the wave amplitude.
  final double height;

  /// Width of the progress bar.
  final double width;

  /// Function that returns amplitude (between 0.0 and 1.0) based on progress.
  final double Function(double)? amplitude;

  const M3ELinearWavyProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = M3EProgressIndicatorDefaults.linearStrokeWidth,
    this.trackStrokeWidth = M3EProgressIndicatorDefaults.linearTrackStrokeWidth,
    this.gapSize = M3EProgressIndicatorDefaults.linearIndicatorTrackGapSize,
    this.stopSize = M3EProgressIndicatorDefaults.linearTrackStopIndicatorSize,
    this.wavelength = M3EProgressIndicatorDefaults.linearDeterminateWavelength,
    this.waveSpeed = M3EProgressIndicatorDefaults.linearWaveSpeed,
    this.height = M3EProgressIndicatorDefaults.linearContainerHeight,
    this.width = 240.0,
    this.amplitude,
  });

  @override
  State<M3ELinearWavyProgressIndicator> createState() =>
      _M3ELinearWavyProgressIndicatorState();
}

class _M3ELinearWavyProgressIndicatorState
    extends State<M3ELinearWavyProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _waveOffsetController;
  late AnimationController _amplitudeController;
  late AnimationController _indeterminateController;
  late AnimationController _progressController;
  late CurvedAnimation _progressCurve;

  double _targetAmplitude = 1.0;
  double _fromProgress = 0.0;
  double _toProgress = 0.0;
  final _WavyPathCache _pathCache = _WavyPathCache();

  @override
  void initState() {
    super.initState();

    // 1. Wave offset controller (scrolling): 1 cycle = wavelength / waveSpeed seconds
    final double waveCycleSec = widget.waveSpeed > 0
        ? widget.wavelength / widget.waveSpeed
        : 1.0;
    _waveOffsetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (waveCycleSec * 1000).round()),
    );
    if (widget.waveSpeed > 0) {
      _waveOffsetController.repeat();
    }

    // 2. Amplitude animation (transition when progress changes)
    _targetAmplitude = widget.value != null
        ? (widget.amplitude ?? M3EProgressIndicatorDefaults.indicatorAmplitude)(
            widget.value!,
          )
        : 1.0;
    _amplitudeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: _targetAmplitude,
    );

    // 3. Indeterminate progress positions controller
    _indeterminateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1750),
    );

    if (widget.value == null) {
      _indeterminateController.repeat();
    }

    // 4. Progress value animation (smooth transitions between values)
    _fromProgress = widget.value ?? 0.0;
    _toProgress = widget.value ?? 0.0;
    _progressController = AnimationController(
      vsync: this,
      duration: M3EProgressIndicatorDefaults.progressAnimationDuration,
      value: 1.0, // Start completed — no animation on initial render
    );
    _progressCurve = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant M3ELinearWavyProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update wave speed / wavelength duration
    if (widget.waveSpeed != oldWidget.waveSpeed ||
        widget.wavelength != oldWidget.wavelength) {
      if (widget.waveSpeed > 0) {
        final double waveCycleSec = widget.wavelength / widget.waveSpeed;
        _waveOffsetController.duration = Duration(
          milliseconds: (waveCycleSec * 1000).round(),
        );
        _waveOffsetController.repeat();
      } else {
        _waveOffsetController.stop();
        _waveOffsetController.value = 0.0;
      }
    }

    if (widget.value != oldWidget.value) {
      if (widget.value == null) {
        _indeterminateController.repeat();
        _targetAmplitude = 1.0;
        _amplitudeController.animateTo(1.0, curve: Curves.easeOut);
      } else {
        _indeterminateController.stop();
        if (oldWidget.value == null) {
          _fromProgress = widget.value!;
          _toProgress = widget.value!;
          _progressController.value = 1.0;
        } else {
          // Animate progress from current interpolated position to new value
          _fromProgress = lerpDouble(
            _fromProgress,
            _toProgress,
            _progressCurve.value,
          )!;
          _toProgress = widget.value!;
          _progressController.forward(from: 0.0);
        }

        final double newTarget =
            (widget.amplitude ??
            M3EProgressIndicatorDefaults.indicatorAmplitude)(widget.value!);
        if (newTarget != _targetAmplitude) {
          _targetAmplitude = newTarget;
          _amplitudeController.animateTo(
            _targetAmplitude,
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _waveOffsetController.dispose();
    _amplitudeController.dispose();
    _indeterminateController.dispose();
    _progressCurve.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
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
        height: widget.height,
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _waveOffsetController,
          _amplitudeController,
          _indeterminateController,
          _progressController,
        ]),
        builder: (context, child) {
          final double? animatedProgress = widget.value != null
              ? lerpDouble(_fromProgress, _toProgress, _progressCurve.value)
              : null;
          return CustomPaint(
            painter: _LinearWavyProgressPainter(
              cache: _pathCache,
              progress: animatedProgress,
              animationValue: _indeterminateController.value,
              waveOffset: _waveOffsetController.value,
              amplitude: _amplitudeController.value,
              color: activeColor,
              trackColor: trackColor,
              strokeWidth: widget.strokeWidth,
              trackStrokeWidth: widget.trackStrokeWidth,
              gapSize: widget.gapSize,
              stopSize: widget.stopSize,
              wavelength: widget.wavelength,
              isLtr: Directionality.of(context) == TextDirection.ltr,
            ),
          );
        },
      ),
    );
  }
}

class _LinearWavyProgressPainter extends CustomPainter {
  final _WavyPathCache cache;
  final double? progress;
  final double animationValue;
  final double waveOffset;
  final double amplitude;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double stopSize;
  final double wavelength;
  final bool isLtr;

  static const Curve _lineEasing = Cubic(0.3, 0.0, 0.8, 0.15);

  _LinearWavyProgressPainter({
    required this.cache,
    required this.progress,
    required this.animationValue,
    required this.waveOffset,
    required this.amplitude,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.stopSize,
    required this.wavelength,
    required this.isLtr,
  });

  // Pre-computes a full wavy path and scales it to fit size
  _WavyPathData _createWavyPath(Size size) {
    final Path path = Path();
    final double height = size.height;
    final double width = size.width;

    path.moveTo(0.0, 0.0);

    final double halfWavelength = wavelength / 2.0;
    double anchorX = halfWavelength;
    double controlX = halfWavelength / 2.0;
    double controlY = height - strokeWidth;

    // Plot path with extra phase to support continuous scroll
    final double widthWithExtraPhase = width + wavelength * 2.0;
    while (anchorX <= widthWithExtraPhase) {
      path.quadraticBezierTo(controlX, controlY, anchorX, 0.0);
      anchorX += halfWavelength;
      controlX += halfWavelength;
      controlY *= -1.0;
    }

    // Calculate path width and scale
    final Rect bounds = path.getBounds();
    // Translate to center vertically
    final Matrix4 translateMatrix = Matrix4.translationValues(
      0.0,
      height / 2.0,
      0.0,
    );
    final Path transformedPath = path.transform(translateMatrix.storage);

    final List<PathMetric> metricsList = transformedPath
        .computeMetrics()
        .toList();
    if (metricsList.isNotEmpty) {
      final PathMetric metric = metricsList.first;
      final double scale = metric.length / (bounds.width + 0.00000001);
      return _WavyPathData(transformedPath, metric, scale);
    } else {
      return _WavyPathData(transformedPath, null, 1.0);
    }
  }

  _WavyPathData _getOrBuildPath(Size size) {
    if (cache.size == size &&
        cache.strokeWidth == strokeWidth &&
        cache.wavelength == wavelength &&
        cache.pathData != null) {
      return cache.pathData!;
    }
    final pathData = _createWavyPath(size);
    cache.size = size;
    cache.strokeWidth = strokeWidth;
    cache.wavelength = wavelength;
    cache.pathData = pathData;
    return pathData;
  }

  void _drawWavyProgressSegment(
    Canvas canvas,
    double startFraction,
    double endFraction,
    Size size,
    Paint activePaint,
    Paint trackPaint,
    List<Path> progressPathsToDraw,
    Path trackPathToDraw,
    _WavyPathData pathData,
  ) {
    final double width = size.width;
    final double halfHeight = size.height / 2;

    final double strokeCapWidth = (strokeWidth > width)
        ? 0.0
        : math.max(strokeWidth / 2, trackStrokeWidth / 2);

    final double barTail = startFraction * width;
    final double barHead = endFraction * width;

    final double adjustedBarHead = barHead.clamp(
      strokeCapWidth,
      width - strokeCapWidth,
    );
    final double adjustedBarTail = barTail.clamp(
      strokeCapWidth,
      width - strokeCapWidth,
    );

    // Draw active indicator segment
    if ((endFraction - startFraction).abs() > 0.0) {
      final double waveShift = amplitude > 0 ? waveOffset * wavelength : 0.0;

      if (pathData.metric != null) {
        final double startDist = (adjustedBarTail + waveShift) * pathData.scale;
        final double endDist = (adjustedBarHead + waveShift) * pathData.scale;

        final Path segmentPath = pathData.metric!.extractPath(
          startDist,
          endDist,
        );

        // Translate back the waveShift and scale by amplitude around baseline
        final Matrix4 matrix =
            Matrix4.translationValues(-waveShift, halfHeight, 0.0) *
            Matrix4.diagonal3Values(1.0, amplitude, 1.0) *
            Matrix4.translationValues(0.0, -halfHeight, 0.0);

        final Path transformedSegment = segmentPath.transform(matrix.storage);
        progressPathsToDraw.add(transformedSegment);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.save();
    if (!isLtr) {
      canvas.translate(size.width, 0);
      canvas.scale(-1.0, 1.0);
    }

    final List<Path> progressPaths = [];
    final Path trackPath = Path();
    final _WavyPathData pathData = _getOrBuildPath(size);

    if (progress != null) {
      // determinate mode
      final double currentProgress = progress!;

      _drawWavyProgressSegment(
        canvas,
        0.0,
        currentProgress,
        size,
        activePaint,
        trackPaint,
        progressPaths,
        trackPath,
        pathData,
      );

      // Remaining track to the right, ending at the left boundary of the stop indicator
      final double strokeCapWidth = math.max(
        strokeWidth / 2,
        trackStrokeWidth / 2,
      );
      final double adjustedBarHead = (currentProgress * size.width).clamp(
        strokeCapWidth,
        size.width - strokeCapWidth,
      );
      final double trackStart = adjustedBarHead + gapSize + strokeCapWidth * 2;
      final double trackEnd = size.width - strokeCapWidth;

      if (trackStart < trackEnd) {
        trackPath.moveTo(trackStart, size.height / 2);
        trackPath.lineTo(trackEnd, size.height / 2);
      }

      // Draw path and track
      if (trackColor != Colors.transparent) {
        canvas.drawPath(trackPath, trackPaint);
      }
      for (final path in progressPaths) {
        canvas.drawPath(path, activePaint);
      }

      canvas.restore();

      // Stop indicator
      M3EProgressIndicatorUtils.drawStopIndicator(
        canvas: canvas,
        size: size,
        progressEnd: currentProgress,
        stopSize: stopSize,
        strokeWidth: strokeWidth,
        color: color,
        isLtr: isLtr,
        strokeCap: StrokeCap.round,
      );
    } else {
      // indeterminate mode
      final double t = animationValue;

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

      // Let's compute the drawn segments
      final double strokeCapWidth = math.max(
        strokeWidth / 2,
        trackStrokeWidth / 2,
      );
      final double adjustedGap = gapSize + strokeCapWidth * 2;

      // Track segments in gaps:
      // Gap 1: from strokeCapWidth to secondLineTail - adjustedGap
      final double firstTrackEnd = secondLineTail * size.width - adjustedGap;
      if (firstTrackEnd > strokeCapWidth) {
        trackPath.moveTo(strokeCapWidth, size.height / 2);
        trackPath.lineTo(firstTrackEnd, size.height / 2);
      }

      // Line 2
      if (secondLineHead - secondLineTail > 0.0) {
        _drawWavyProgressSegment(
          canvas,
          secondLineTail,
          secondLineHead,
          size,
          activePaint,
          trackPaint,
          progressPaths,
          trackPath,
          pathData,
        );
      }

      // Gap 2: between secondLineHead and firstLineTail
      final double secondTrackStart = secondLineHead * size.width + adjustedGap;
      final double secondTrackEnd = firstLineTail * size.width - adjustedGap;
      if (secondTrackStart < secondTrackEnd) {
        trackPath.moveTo(secondTrackStart, size.height / 2);
        trackPath.lineTo(secondTrackEnd, size.height / 2);
      }

      // Line 1
      if (firstLineHead - firstLineTail > 0.0) {
        _drawWavyProgressSegment(
          canvas,
          firstLineTail,
          firstLineHead,
          size,
          activePaint,
          trackPaint,
          progressPaths,
          trackPath,
          pathData,
        );
      }

      // Gap 3: from firstLineHead + adjustedGap to size.width - strokeCapWidth
      final double thirdTrackStart = firstLineHead * size.width + adjustedGap;
      if (thirdTrackStart < size.width - strokeCapWidth) {
        trackPath.moveTo(thirdTrackStart, size.height / 2);
        trackPath.lineTo(size.width - strokeCapWidth, size.height / 2);
      }

      // Draw paths
      if (trackColor != Colors.transparent) {
        canvas.drawPath(trackPath, trackPaint);
      }
      for (final path in progressPaths) {
        canvas.drawPath(path, activePaint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LinearWavyProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.waveOffset != waveOffset ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.gapSize != gapSize ||
        oldDelegate.stopSize != stopSize ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.isLtr != isLtr;
  }
}

class _WavyPathData {
  final Path path;
  final PathMetric? metric;
  final double scale;
  _WavyPathData(this.path, this.metric, this.scale);
}

class _WavyPathCache {
  Size? size;
  double? strokeWidth;
  double? wavelength;
  _WavyPathData? pathData;
}
