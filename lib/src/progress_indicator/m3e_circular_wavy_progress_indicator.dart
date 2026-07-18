// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import 'm3e_progress_indicator_defaults.dart';

/// A Material 3 Expressive circular wavy progress indicator.
///
/// The active arc is drawn as a sinusoidal wave bent around the circle (the
/// radius oscillates in and out as the stroke travels around the ring).
/// The track is always a plain circle arc.
///
/// When [value] is `null` the indicator is indeterminate.
class M3ECircularWavyProgressIndicator extends StatefulWidget {
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

  /// The gap size between the active progress and the track (logical pixels).
  final double gapSize;

  /// The preferred wavelength of the wave (logical pixels).
  final double wavelength;

  /// The speed of the wave scrolling (logical pixels per second).
  final double waveSpeed;

  /// The size/diameter of the indicator.
  final double size;

  /// Optional function that returns amplitude (0.0 – 1.0) based on progress.
  /// Defaults to [M3EProgressIndicatorDefaults.indicatorAmplitude].
  final double Function(double)? amplitude;

  const M3ECircularWavyProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = M3EProgressIndicatorDefaults.circularStrokeWidth,
    this.trackStrokeWidth = M3EProgressIndicatorDefaults.circularStrokeWidth,
    this.gapSize = M3EProgressIndicatorDefaults.circularIndicatorTrackGapSize,
    this.wavelength = M3EProgressIndicatorDefaults.circularWavelength,
    this.waveSpeed = M3EProgressIndicatorDefaults.circularWavelength,
    this.size = M3EProgressIndicatorDefaults.circularContainerSize,
    this.amplitude,
  });

  @override
  State<M3ECircularWavyProgressIndicator> createState() =>
      _M3ECircularWavyProgressIndicatorState();
}

class _M3ECircularWavyProgressIndicatorState
    extends State<M3ECircularWavyProgressIndicator>
    with TickerProviderStateMixin {
  /// Wave-phase controller: 0 → 1 in (wavelength / waveSpeed) seconds.
  /// One full cycle = one wavelength of travel on the arc.
  late AnimationController _wavePhaseController;

  /// Amplitude morph: 0 → 1 when the amplitude target changes.
  late AnimationController _amplitudeController;

  /// Indeterminate: global spin (0→1 maps to 0→1080°).
  late AnimationController _globalRotController;

  /// Indeterminate: additional rotation (0→1 maps to 0→360°).
  late AnimationController _additionalRotController;

  /// Indeterminate: sweep fraction, ping-pongs between minProgress / maxProgress.
  late AnimationController _sweepController;

  /// Smooth progress value transitions.
  late AnimationController _progressController;
  late CurvedAnimation _progressCurve;

  double _targetAmplitude = 1.0;
  bool _sweepExpanding = true;
  double _fromProgress = 0.0;
  double _toProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final double waveCycleSec = widget.waveSpeed > 0
        ? widget.wavelength / widget.waveSpeed
        : 1.0;
    _wavePhaseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (waveCycleSec * 1000).round()),
    );
    if (widget.waveSpeed > 0) {
      _wavePhaseController.repeat();
    }

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

    _globalRotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    _additionalRotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    if (widget.value == null) {
      _startIndeterminate();
    }

    // Progress value animation (smooth transitions between values)
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

  void _startIndeterminate() {
    _globalRotController.repeat();
    _additionalRotController.repeat();
    _sweepExpanding = true;
    _sweepController.forward().then((_) => _pingPong());
  }

  void _pingPong() {
    if (!mounted) return;
    _sweepExpanding = !_sweepExpanding;
    final future = _sweepExpanding
        ? _sweepController.forward()
        : _sweepController.reverse();
    future.then((_) => _pingPong());
  }

  void _stopIndeterminate() {
    _globalRotController.stop();
    _additionalRotController.stop();
    _sweepController.stop();
  }

  @override
  void didUpdateWidget(covariant M3ECircularWavyProgressIndicator old) {
    super.didUpdateWidget(old);

    if (widget.waveSpeed != old.waveSpeed ||
        widget.wavelength != old.wavelength) {
      if (widget.waveSpeed > 0) {
        final double waveCycleSec = widget.wavelength / widget.waveSpeed;
        _wavePhaseController.duration = Duration(
          milliseconds: (waveCycleSec * 1000).round(),
        );
        _wavePhaseController.repeat();
      } else {
        _wavePhaseController.stop();
        _wavePhaseController.value = 0.0;
      }
    }

    if (widget.value != old.value) {
      if (widget.value == null) {
        _startIndeterminate();
        _targetAmplitude = 1.0;
        _amplitudeController.animateTo(1.0, curve: Curves.easeOut);
      } else {
        if (old.value == null) {
          _stopIndeterminate();
          _fromProgress = widget.value!;
          _toProgress = widget.value!;
          _progressController.value = 1.0;
        } else if (widget.value! < old.value!) {
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
    _wavePhaseController.dispose();
    _amplitudeController.dispose();
    _globalRotController.dispose();
    _additionalRotController.dispose();
    _sweepController.dispose();
    _progressCurve.dispose();
    _progressController.dispose();
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
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _wavePhaseController,
          _amplitudeController,
          _globalRotController,
          _additionalRotController,
          _sweepController,
          _progressController,
        ]),
        builder: (context, child) {
          final double sweepFraction = lerpDouble(
            _CircularWavyProgressPainter.minSweep,
            _CircularWavyProgressPainter.maxSweep,
            _sweepController.value,
          )!;
          final double? animatedProgress = widget.value != null
              ? lerpDouble(_fromProgress, _toProgress, _progressCurve.value)
              : null;

          return CustomPaint(
            painter: _CircularWavyProgressPainter(
              progress: animatedProgress,
              globalRotation: _globalRotController.value,
              additionalRotation: _additionalRotController.value,
              sweepFraction: sweepFraction,
              wavePhase: _wavePhaseController.value,
              amplitude: _amplitudeController.value,
              color: activeColor,
              trackColor: trackColor,
              strokeWidth: widget.strokeWidth,
              trackStrokeWidth: widget.trackStrokeWidth,
              gapSize: widget.gapSize,
              wavelength: widget.wavelength,
              isLtr: Directionality.of(context) == TextDirection.ltr,
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _CircularWavyProgressPainter extends CustomPainter {
  final double? progress;

  // Indeterminate animation values
  final double globalRotation; // 0→1 = 0→1080°
  final double additionalRotation; // 0→1 = 0→360°
  final double sweepFraction; // current indeterminate sweep fraction

  final double wavePhase; // 0→1, one wavelength of scroll per cycle
  final double amplitude; // 0→1 (morphed)
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double wavelength;
  final bool isLtr;

  // Compose-matching constants
  static const double minSweep = 0.10;
  static const double maxSweep = 0.87;
  static const double _globalRotDeg = 1080.0;
  static const double _additionalRotDeg = 360.0;

  _CircularWavyProgressPainter({
    required this.progress,
    required this.globalRotation,
    required this.additionalRotation,
    required this.sweepFraction,
    required this.wavePhase,
    required this.amplitude,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.wavelength,
    required this.isLtr,
  });

  // ---------------------------------------------------------------------------
  // Wave arc path
  //
  // Traces an arc from [startAngle] to [startAngle + sweepAngle] (radians,
  // clockwise) where the radius oscillates sinusoidally:
  //
  //   r(θ) = R + A * sin(θ * N + phase)
  //
  // where N = number of complete wave cycles around the full circle,
  // A = amplitude in pixels,  and phase = wavePhase * 2π (scroll offset).
  //
  // The path is built using quadratic bezier segments, each spanning one
  // half-wavelength (matching the linear wavy indicator approach).
  // ---------------------------------------------------------------------------
  Path _buildWaveArcPath({
    required double cx,
    required double cy,
    required double R,
    required double A, // amplitude in px
    required double startAngle, // radians, 12 o'clock = -π/2
    required double sweepAngle, // radians (positive = clockwise)
    required double N, // number of full wave cycles in 2π
    required double phase, // radians: wavePhase * 2π
  }) {
    final Path path = Path();
    if (sweepAngle <= 0) return path;

    // Angle step per bezier segment = half a wavelength on the arc.
    final double halfWaveAngle = math.pi / N;
    final double endAngle = startAngle + sweepAngle;

    // Taper/dampen amplitude near the endpoints to prevent excessive bouncing.
    // The taper range is set to 1.5 half-wavelengths to fade smoothly.
    final double taperRange = halfWaveAngle * 0.5;

    double localA(double angle) {
      if (taperRange <= 0) return A;
      final double distFromStart = angle - startAngle;
      final double distFromEnd = endAngle - angle;

      double factor = 1.0;
      if (distFromStart < taperRange) {
        factor = math.min(factor, distFromStart / taperRange);
      }
      if (distFromEnd < taperRange) {
        factor = math.min(factor, distFromEnd / taperRange);
      }

      // Smooth step tapering factor
      final double smoothFactor = 0.5 - 0.5 * math.cos(factor * math.pi);
      return A * smoothFactor;
    }

    // First point on the path
    double currentAngle = startAngle;
    final double r0 =
        R + localA(currentAngle) * math.sin(currentAngle * N + phase);
    path.moveTo(
      cx + r0 * math.cos(currentAngle),
      cy + r0 * math.sin(currentAngle),
    );

    // Step through the arc in half-wave segments, using quadratic bezier.
    // The bezier control point is placed at the mid-angle with the peak radius.
    double segEnd = _nextHalfWaveBoundary(startAngle, halfWaveAngle, phase, N);

    while (currentAngle < endAngle) {
      final double segEndClamped = math.min(segEnd, endAngle);
      final double midAngle = (currentAngle + segEndClamped) / 2;
      final double actualSpan = segEndClamped - currentAngle;
      final double segmentCos = math.cos(actualSpan / 2);

      // Control radius = peak / trough at midAngle, adjusted by segmentCos to draw a smooth circle when amplitude is 0
      final double rMid =
          (R / segmentCos) + localA(midAngle) * math.sin(midAngle * N + phase);
      final double rEnd =
          R + localA(segEndClamped) * math.sin(segEndClamped * N + phase);

      final double cpx = cx + rMid * math.cos(midAngle);
      final double cpy = cy + rMid * math.sin(midAngle);
      final double epx = cx + rEnd * math.cos(segEndClamped);
      final double epy = cy + rEnd * math.sin(segEndClamped);

      path.quadraticBezierTo(cpx, cpy, epx, epy);

      currentAngle = segEndClamped;
      segEnd += halfWaveAngle;
    }

    return path;
  }

  /// Returns the angle of the first half-wave boundary AFTER [startAngle].
  /// Half-wave boundaries are where the sinusoid crosses zero (sin=0),
  /// i.e. θ * N + phase = k * π → θ = (k*π - phase) / N.
  double _nextHalfWaveBoundary(
    double startAngle,
    double halfWaveAngle,
    double phase,
    double N,
  ) {
    // The zero crossings of sin(θ*N + phase) occur at θ = (kπ - phase)/N.
    // The first one strictly after startAngle:
    final double k = ((startAngle * N + phase) / math.pi).ceil().toDouble();
    final double boundary = (k * math.pi - phase) / N;
    // If boundary == startAngle (already on a crossing), step one half-wave further.
    if ((boundary - startAngle).abs() < 1e-9) {
      return boundary + halfWaveAngle;
    }
    return boundary;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    canvas.save();
    if (!isLtr) {
      canvas.translate(cx, cy);
      canvas.scale(-1.0, 1.0);
      canvas.translate(-cx, -cy);
    }

    final double maxStroke = math.max(strokeWidth, trackStrokeWidth);
    final double R = (math.min(size.width, size.height) - maxStroke) / 2;

    // Number of full wave cycles around the full circle so that the wave fits
    // perfectly: N = round(2πR / wavelength), minimum 3.
    final double N = math.max(
      3.0,
      (2 * math.pi * R / wavelength).roundToDouble(),
    );

    // Amplitude in pixels: scales the wave radially.
    // The maximum sensible amplitude is half the stroke width away from R,
    // but we use strokeWidth as the amplitude reference (as in the linear
    // indicator where controlY = height - strokeWidth).
    final double A = amplitude * strokeWidth * 1.5;

    // Phase: wavePhase 0→1 scrolls one full wavelength.
    final double phase = wavePhase * 2 * math.pi;

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

    // Gap in radians (arc length gapSize at radius R).
    final double capWidth = maxStroke / 2.0;
    final double gapRad = (gapSize + capWidth * 2.0) / R;

    if (progress != null) {
      _paintDeterminate(
        canvas,
        cx,
        cy,
        R,
        N,
        A,
        phase,
        gapRad,
        activePaint,
        trackPaint,
      );
    } else {
      _paintIndeterminate(
        canvas,
        cx,
        cy,
        R,
        N,
        A,
        phase,
        gapRad,
        activePaint,
        trackPaint,
      );
    }

    canvas.restore();
  }

  void _paintDeterminate(
    Canvas canvas,
    double cx,
    double cy,
    double R,
    double N,
    double A,
    double phase,
    double gapRad,
    Paint activePaint,
    Paint trackPaint,
  ) {
    final double prog = progress!.clamp(0.0, 1.0);
    final double progressSweep = prog * 2 * math.pi;

    // Progress arc: starts at 12 o'clock (-π/2), goes clockwise.
    const double startAngle = -math.pi / 2;

    if (progressSweep > 0) {
      final Path wavePath = _buildWaveArcPath(
        cx: cx,
        cy: cy,
        R: R,
        A: A,
        startAngle: startAngle,
        sweepAngle: progressSweep,
        N: N,
        phase: phase,
      );
      canvas.drawPath(wavePath, activePaint);
    }

    // Track: plain circle arc from (progress + gap) to (360° - gap).
    final double trackSweep = 2 * math.pi - progressSweep - 2 * gapRad;
    if (trackSweep > 0 && trackColor != Colors.transparent) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: R),
        startAngle + progressSweep + gapRad, // start after gap
        trackSweep,
        false,
        trackPaint,
      );
    }
  }

  void _paintIndeterminate(
    Canvas canvas,
    double cx,
    double cy,
    double R,
    double N,
    double A,
    double phase,
    double gapRad,
    Paint activePaint,
    Paint trackPaint,
  ) {
    // Total canvas rotation: matches Compose's
    //   rotate(globalRotation + additionalRotation + 90°)
    // We use +90° to shift the arc start from 3 o'clock to 12 o'clock; the
    // wave path already uses -π/2 as start so we don't need it here.
    final double totalDeg =
        globalRotation * _globalRotDeg + additionalRotation * _additionalRotDeg;
    final double totalRad = totalDeg * math.pi / 180.0;

    // Rotate canvas so the arc sweeps from 12 o'clock.
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(totalRad);
    canvas.translate(-cx, -cy);

    final double progressSweep = sweepFraction * 2 * math.pi;
    const double startAngle = -math.pi / 2;

    // Wavy progress arc.
    if (progressSweep > 0) {
      final Path wavePath = _buildWaveArcPath(
        cx: cx,
        cy: cy,
        R: R,
        A: A,
        startAngle: startAngle,
        sweepAngle: progressSweep,
        N: N,
        phase: phase,
      );
      canvas.drawPath(wavePath, activePaint);
    }

    // Plain circle track arc.
    final double trackSweep = 2 * math.pi - progressSweep - 2 * gapRad;
    if (trackSweep > 0 && trackColor != Colors.transparent) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: R),
        startAngle + progressSweep + gapRad,
        trackSweep,
        false,
        trackPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircularWavyProgressPainter old) {
    return old.progress != progress ||
        old.globalRotation != globalRotation ||
        old.additionalRotation != additionalRotation ||
        old.sweepFraction != sweepFraction ||
        old.wavePhase != wavePhase ||
        old.amplitude != amplitude ||
        old.color != color ||
        old.trackColor != trackColor ||
        old.strokeWidth != strokeWidth ||
        old.trackStrokeWidth != trackStrokeWidth ||
        old.gapSize != gapSize ||
        old.wavelength != wavelength ||
        old.isLtr != isLtr;
  }
}
