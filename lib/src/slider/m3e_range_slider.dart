// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'm3e_slider_theme.dart';
import 'style/m3e_slider_decoration.dart';
import '../common/m3e_common.dart';

/// A Material 3 Expressive Range Slider.
///
/// Permits selecting a range of values (start and end). Supports independent
/// keyboard focus for both thumbs, custom decorations, haptic feedback, and
/// snap-to-tick animations.
class M3ERangeSlider extends StatefulWidget {
  /// The current range values of the slider.
  final RangeValues value;

  /// Callback when the range values are changing.
  final ValueChanged<RangeValues>? onChanged;

  /// Callback when the user starts changing the value.
  final ValueChanged<RangeValues>? onChangeStart;

  /// Callback when the user finishes changing the value.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// The minimum value of the slider. Defaults to 0.0.
  final double min;

  /// The maximum value of the slider. Defaults to 1.0.
  final double max;

  /// The number of discrete intervals. If null, the slider is continuous.
  final int? divisions;

  /// Whether the range slider is enabled.
  final bool enabled;

  /// The decoration overrides (colors, haptics).
  final M3ESliderDecoration? decoration;

  /// The layout orientation of the range slider. Defaults to [Axis.horizontal].
  final Axis orientation;

  /// The start thumb focus node for keyboard navigation.
  final FocusNode? startFocusNode;

  /// The end thumb focus node for keyboard navigation.
  final FocusNode? endFocusNode;

  /// Whether to autofocus this widget.
  final bool autofocus;

  /// An optional label shown in a pill above the active thumb while pressed.
  final String? label;

  const M3ERangeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.enabled = true,
    this.decoration,
    this.orientation = Axis.horizontal,
    this.startFocusNode,
    this.endFocusNode,
    this.autofocus = false,
    this.label,
  }) : assert(min <= max),
       assert(divisions == null || divisions > 0);

  @override
  State<M3ERangeSlider> createState() => _M3ERangeSliderState();
}

class _M3ERangeSliderState extends State<M3ERangeSlider>
    with TickerProviderStateMixin {
  late FocusNode _startFocusNode;
  late FocusNode _endFocusNode;

  late AnimationController _snapStartController;
  late AnimationController _snapEndController;

  late AnimationController _interactionStartController;
  late AnimationController _interactionEndController;

  final ValueNotifier<bool> _isStartHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isStartPressed = ValueNotifier(false);
  final ValueNotifier<bool> _isStartFocused = ValueNotifier(false);

  final ValueNotifier<bool> _isEndHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isEndPressed = ValueNotifier(false);
  final ValueNotifier<bool> _isEndFocused = ValueNotifier(false);

  int _lastHapticTick = -1;
  bool _isDraggingStart = true;
  bool _isDragging = false;
  double? _lastTapValue;
  VoidCallback? _snapStartListener;
  VoidCallback? _snapEndListener;
  RenderBox? _renderBox;
  int? _cachedDivisions;
  List<double>? _cachedTickFractions;

  @override
  void initState() {
    super.initState();
    _startFocusNode = widget.startFocusNode ?? FocusNode();
    _endFocusNode = widget.endFocusNode ?? FocusNode();

    _startFocusNode.addListener(_handleStartFocusChange);
    _endFocusNode.addListener(_handleEndFocusChange);

    _snapStartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _snapEndController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _interactionStartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _interactionEndController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _isStartHovered.addListener(_updateStartInteraction);
    _isStartPressed.addListener(_updateStartInteraction);

    _isEndHovered.addListener(_updateEndInteraction);
    _isEndPressed.addListener(_updateEndInteraction);
  }

  void _clearSnapListeners() {
    if (_snapStartListener != null) {
      _snapStartController.removeListener(_snapStartListener!);
      _snapStartListener = null;
    }
    if (_snapEndListener != null) {
      _snapEndController.removeListener(_snapEndListener!);
      _snapEndListener = null;
    }
  }

  @override
  void dispose() {
    _clearSnapListeners();
    _startFocusNode.removeListener(_handleStartFocusChange);
    _endFocusNode.removeListener(_handleEndFocusChange);

    if (widget.startFocusNode == null) {
      _startFocusNode.dispose();
    }
    if (widget.endFocusNode == null) {
      _endFocusNode.dispose();
    }

    _snapStartController.dispose();
    _snapEndController.dispose();

    _interactionStartController.dispose();
    _interactionEndController.dispose();

    _isStartHovered.removeListener(_updateStartInteraction);
    _isStartPressed.removeListener(_updateStartInteraction);
    _isEndHovered.removeListener(_updateEndInteraction);
    _isEndPressed.removeListener(_updateEndInteraction);

    _isStartHovered.dispose();
    _isStartPressed.dispose();
    _isStartFocused.dispose();

    _isEndHovered.dispose();
    _isEndPressed.dispose();
    _isEndFocused.dispose();

    super.dispose();
  }

  bool _isStartFocusedFromPointer = false;
  bool _isEndFocusedFromPointer = false;

  void _handleStartFocusChange() {
    if (!_startFocusNode.hasFocus) {
      _isStartFocusedFromPointer = false;
    }
    _isStartFocused.value =
        _startFocusNode.hasFocus && !_isStartFocusedFromPointer;
  }

  void _handleEndFocusChange() {
    if (!_endFocusNode.hasFocus) {
      _isEndFocusedFromPointer = false;
    }
    _isEndFocused.value = _endFocusNode.hasFocus && !_isEndFocusedFromPointer;
  }

  @visibleForTesting
  bool get isStartFocusedForTesting => _isStartFocused.value;

  @visibleForTesting
  bool get isEndFocusedForTesting => _isEndFocused.value;

  void _updateStartInteraction() {
    if (_isStartPressed.value || _isStartHovered.value) {
      _interactionStartController.forward();
    } else {
      _interactionStartController.reverse();
    }
  }

  void _updateEndInteraction() {
    if (_isEndPressed.value || _isEndHovered.value) {
      _interactionEndController.forward();
    } else {
      _interactionEndController.reverse();
    }
  }

  List<double> get _tickFractions {
    final divs = widget.divisions;
    if (divs == null || divs <= 0) return const [];
    if (_cachedDivisions == divs && _cachedTickFractions != null) {
      return _cachedTickFractions!;
    }
    _cachedDivisions = divs;
    _cachedTickFractions = List<double>.generate(divs + 1, (i) => i / divs);
    return _cachedTickFractions!;
  }

  double _valueToFraction(double value) {
    if (widget.max == widget.min) return 0.0;
    return ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  }

  double _fractionToValue(double fraction) {
    return fraction * (widget.max - widget.min) + widget.min;
  }

  void _updateValue({double? start, double? end}) {
    if (!widget.enabled || widget.onChanged == null) return;

    final newStart = start ?? widget.value.start;
    final newEnd = end ?? widget.value.end;

    // Safety checks
    if (newStart > newEnd) return;

    final clampedStart = newStart.clamp(widget.min, widget.max);
    final clampedEnd = newEnd.clamp(widget.min, widget.max);

    // Haptic tick feedback
    final divs = widget.divisions;
    if (divs != null && divs > 0) {
      final activeFraction = _valueToFraction(
        _isDraggingStart ? clampedStart : clampedEnd,
      );
      final currentTick = (activeFraction * divs).round();
      if (currentTick != _lastHapticTick) {
        _lastHapticTick = currentTick;
        final haptic = widget.decoration?.haptic ?? M3EHapticFeedback.none;
        haptic.apply();
      }
    }

    widget.onChanged!(RangeValues(clampedStart, clampedEnd));
  }

  void _handleDragStart(DragStartDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;

    _clearSnapListeners();
    _snapStartController.stop();
    _snapEndController.stop();

    _isDragging = true;

    _renderBox = context.findRenderObject() as RenderBox;
    final localPosition = _renderBox!.globalToLocal(details.globalPosition);

    const margin = M3ESliderDefaults.thumbRadius;
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

    // Determine which thumb is closer
    final distStart = (rawValue - widget.value.start).abs();
    final distEnd = (rawValue - widget.value.end).abs();

    if (distStart < distEnd) {
      _isDraggingStart = true;
      _isStartPressed.value = true;
      _isStartFocusedFromPointer = true;
      _startFocusNode.requestFocus();
    } else if (distStart > distEnd) {
      _isDraggingStart = false;
      _isEndPressed.value = true;
      _isEndFocusedFromPointer = true;
      _endFocusNode.requestFocus();
    } else {
      // If equal, favor the side based on location
      _isDraggingStart = rawValue < widget.value.start;
      if (_isDraggingStart) {
        _isStartPressed.value = true;
        _isStartFocusedFromPointer = true;
        _startFocusNode.requestFocus();
      } else {
        _isEndPressed.value = true;
        _isEndFocusedFromPointer = true;
        _endFocusNode.requestFocus();
      }
    }

    _lastHapticTick = -1;
    widget.onChangeStart?.call(widget.value);
  }

  void _handleDragUpdate(DragUpdateDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;

    final localPosition = _renderBox!.globalToLocal(details.globalPosition);

    const margin = M3ESliderDefaults.thumbRadius;
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

    if (_isDraggingStart) {
      _updateValue(start: rawValue.clamp(widget.min, widget.value.end));
    } else {
      _updateValue(end: rawValue.clamp(widget.value.start, widget.max));
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;
    _isStartPressed.value = false;
    _isEndPressed.value = false;
    _isDragging = false;
    _renderBox = null;
    _snapToNearestTick(_isDraggingStart);
  }

  void _handleTapDown(TapDownDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;

    _clearSnapListeners();
    _snapStartController.stop();
    _snapEndController.stop();

    const margin = M3ESliderDefaults.thumbRadius;
    final usableLength = totalLength - 2 * margin;
    if (usableLength <= 0) return;

    final double fraction;
    if (widget.orientation == Axis.horizontal) {
      final localX = details.localPosition.dx - margin;
      fraction = (localX / usableLength).clamp(0.0, 1.0);
    } else {
      final localY = details.localPosition.dy - margin;
      fraction = (1.0 - (localY / usableLength)).clamp(0.0, 1.0);
    }
    final rawValue = _fractionToValue(fraction);
    _lastTapValue = rawValue;
    _lastHapticTick = -1;

    // Determine which thumb is closer
    final distStart = (rawValue - widget.value.start).abs();
    final distEnd = (rawValue - widget.value.end).abs();

    if (distStart < distEnd) {
      _isDraggingStart = true;
      _isStartPressed.value = true;
      _isStartFocusedFromPointer = true;
      _startFocusNode.requestFocus();
      widget.onChangeStart?.call(widget.value);
      _updateValue(start: rawValue.clamp(widget.min, widget.value.end));
    } else {
      _isDraggingStart = false;
      _isEndPressed.value = true;
      _isEndFocusedFromPointer = true;
      _endFocusNode.requestFocus();
      widget.onChangeStart?.call(widget.value);
      _updateValue(end: rawValue.clamp(widget.value.start, widget.max));
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _isStartPressed.value = false;
    _isEndPressed.value = false;
    _snapToNearestTick(_isDraggingStart, fromValue: _lastTapValue);
    _lastTapValue = null;
  }

  void _snapToNearestTick(bool isStart, {double? fromValue}) {
    final fractions = _tickFractions;
    if (fractions.isEmpty) {
      widget.onChangeEnd?.call(widget.value);
      return;
    }

    final currentValue =
        fromValue ?? (isStart ? widget.value.start : widget.value.end);
    final currentFraction = _valueToFraction(currentValue);

    double closestFraction = fractions.first;
    double minDistance = (closestFraction - currentFraction).abs();

    for (final frac in fractions) {
      final dist = (frac - currentFraction).abs();
      if (dist < minDistance) {
        minDistance = dist;
        closestFraction = frac;
      }
    }

    final targetValue = _fractionToValue(closestFraction);
    if (targetValue != currentValue) {
      final startVal = currentValue;
      final controller = isStart ? _snapStartController : _snapEndController;
      final animation = Tween<double>(begin: startVal, end: targetValue)
          .animate(
            CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
          );

      void listener() {
        if (isStart) {
          _updateValue(
            start: animation.value.clamp(widget.min, widget.value.end),
          );
        } else {
          _updateValue(
            end: animation.value.clamp(widget.value.start, widget.max),
          );
        }
      }

      _clearSnapListeners();
      if (isStart) {
        _snapStartListener = listener;
      } else {
        _snapEndListener = listener;
      }
      controller.addListener(listener);
      controller.forward(from: 0.0).then((_) {
        if (!mounted) return;
        controller.removeListener(listener);
        if (isStart && _snapStartListener == listener) {
          _snapStartListener = null;
        }
        if (!isStart && _snapEndListener == listener) _snapEndListener = null;
        widget.onChangeEnd?.call(widget.value);
      });
    } else {
      widget.onChangeEnd?.call(widget.value);
    }
  }

  KeyEventResult _handleStartKeyEvent(FocusNode node, KeyEvent event) {
    if (_isStartFocusedFromPointer) {
      _isStartFocusedFromPointer = false;
      _isStartFocused.value = _startFocusNode.hasFocus;
    }
    if (!widget.enabled || widget.onChanged == null) {
      return KeyEventResult.ignored;
    }

    if (event is KeyDownEvent) {
      final range = widget.max - widget.min;
      final actualSteps = widget.divisions ?? 100;
      final delta = range / actualSteps;

      double? targetValue;

      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        targetValue = widget.value.start + delta;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        targetValue = widget.value.start - delta;
      } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
        final page = math.max(1, actualSteps ~/ 10);
        targetValue = widget.value.start + page * delta;
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        final page = math.max(1, actualSteps ~/ 10);
        targetValue = widget.value.start - page * delta;
      } else if (event.logicalKey == LogicalKeyboardKey.home) {
        targetValue = widget.min;
      } else if (event.logicalKey == LogicalKeyboardKey.end) {
        targetValue = widget.value.end;
      }

      if (targetValue != null) {
        _clearSnapListeners();
        _snapStartController.stop();
        _isDraggingStart = true;
        _updateValue(start: targetValue.clamp(widget.min, widget.value.end));
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

  KeyEventResult _handleEndKeyEvent(FocusNode node, KeyEvent event) {
    if (_isEndFocusedFromPointer) {
      _isEndFocusedFromPointer = false;
      _isEndFocused.value = _endFocusNode.hasFocus;
    }
    if (!widget.enabled || widget.onChanged == null) {
      return KeyEventResult.ignored;
    }

    if (event is KeyDownEvent) {
      final range = widget.max - widget.min;
      final actualSteps = widget.divisions ?? 100;
      final delta = range / actualSteps;

      double? targetValue;

      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        targetValue = widget.value.end + delta;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        targetValue = widget.value.end - delta;
      } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
        final page = math.max(1, actualSteps ~/ 10);
        targetValue = widget.value.end + page * delta;
      } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
        final page = math.max(1, actualSteps ~/ 10);
        targetValue = widget.value.end - page * delta;
      } else if (event.logicalKey == LogicalKeyboardKey.home) {
        targetValue = widget.value.start;
      } else if (event.logicalKey == LogicalKeyboardKey.end) {
        targetValue = widget.max;
      }

      if (targetValue != null) {
        _clearSnapListeners();
        _snapEndController.stop();
        _isDraggingStart = false;
        _updateValue(end: targetValue.clamp(widget.value.start, widget.max));
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

  Widget _buildPill(M3ESliderColors colors) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.inverseSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        widget.label!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: cs.onInverseSurface,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assert range bounds in build at runtime
    assert(
      widget.value.start >= widget.min &&
          widget.value.start <= widget.value.end &&
          widget.value.end <= widget.max,
    );

    final themeColors =
        widget.decoration?.colors ?? M3ESliderDefaults.colors(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width;
        final double height;
        if (widget.orientation == Axis.horizontal) {
          width = constraints.maxWidth;
          height = constraints.hasBoundedHeight
              ? math.max(
                  constraints.maxHeight,
                  M3ESliderDefaults.thumbRippleRadius * 2,
                )
              : M3ESliderDefaults.thumbRippleRadius * 2;
        } else {
          width = constraints.hasBoundedWidth
              ? math.max(
                  constraints.maxWidth,
                  M3ESliderDefaults.thumbRippleRadius * 2,
                )
              : M3ESliderDefaults.thumbRippleRadius * 2;
          height = constraints.hasBoundedHeight ? constraints.maxHeight : 200.0;
        }

        const margin = M3ESliderDefaults.thumbRadius;
        final dragLength = widget.orientation == Axis.horizontal
            ? width
            : height;
        final trackLength = dragLength - 2 * margin;

        final startFraction = _valueToFraction(widget.value.start);
        final endFraction = _valueToFraction(widget.value.end);

        final double startThumbX;
        final double endThumbX;
        final double centerY;
        final double startThumbY;
        final double endThumbY;
        final double centerX;

        if (widget.orientation == Axis.horizontal) {
          startThumbX = margin + trackLength * startFraction;
          endThumbX = margin + trackLength * endFraction;
          centerY = height / 2;
          startThumbY = centerY;
          endThumbY = centerY;
          centerX = startThumbX; // not used for horiz
        } else {
          centerX = width / 2;
          startThumbY = (height - margin) - trackLength * startFraction;
          endThumbY = (height - margin) - trackLength * endFraction;
          startThumbX = centerX; // not used for vert
          endThumbX = centerX;
          centerY = startThumbY;
        }

        return Listener(
          onPointerCancel: (_) {
            _isStartPressed.value = false;
            _isEndPressed.value = false;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: widget.orientation == Axis.horizontal
                ? (details) => _handleDragStart(details, dragLength)
                : null,
            onHorizontalDragUpdate: widget.orientation == Axis.horizontal
                ? (details) => _handleDragUpdate(details, dragLength)
                : null,
            onHorizontalDragEnd: widget.orientation == Axis.horizontal
                ? _handleDragEnd
                : null,
            onVerticalDragStart: widget.orientation == Axis.vertical
                ? (details) => _handleDragStart(details, dragLength)
                : null,
            onVerticalDragUpdate: widget.orientation == Axis.vertical
                ? (details) => _handleDragUpdate(details, dragLength)
                : null,
            onVerticalDragEnd: widget.orientation == Axis.vertical
                ? _handleDragEnd
                : null,
            onTapDown: (details) => _handleTapDown(details, dragLength),
            onTapUp: _handleTapUp,
            onTapCancel: () {
              if (!_isDragging) {
                _isStartPressed.value = false;
                _isEndPressed.value = false;
                if (_isDraggingStart) {
                  _snapToNearestTick(true, fromValue: _lastTapValue);
                } else {
                  _snapToNearestTick(false, fromValue: _lastTapValue);
                }
                _lastTapValue = null;
              }
            },
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Track (bottom layer)
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _interactionStartController,
                          _interactionEndController,
                          _isStartFocused,
                          _isEndFocused,
                          _isStartPressed,
                          _isEndPressed,
                        ]),
                        builder: (context, child) {
                          final resolvedTrackHeight =
                              widget.decoration?.trackHeight ??
                              M3ESliderDefaults.trackHeight;
                          final resolvedTrackCornerRadius =
                              widget.decoration?.trackCornerRadius ??
                              (resolvedTrackHeight / 2);
                          final resolvedThumbWidth =
                              widget.decoration?.thumbWidth ??
                              M3ESliderDefaults.thumbWidth;

                          return CustomPaint(
                            painter: _RangeTrackPainter(
                              startFraction: startFraction,
                              endFraction: endFraction,
                              tickFractions: _tickFractions,
                              colors: themeColors,
                              enabled: widget.enabled,
                              startThumbX: widget.orientation == Axis.horizontal
                                  ? startThumbX
                                  : startThumbY,
                              endThumbX: widget.orientation == Axis.horizontal
                                  ? endThumbX
                                  : endThumbY,
                              centerY: widget.orientation == Axis.horizontal
                                  ? centerY
                                  : centerX,
                              startX: margin,
                              endX: dragLength - margin,
                              startOverlayProgress:
                                  _interactionStartController.value,
                              endOverlayProgress:
                                  _interactionEndController.value,
                              isStartPressed: _isStartPressed.value,
                              isEndPressed: _isEndPressed.value,
                              isStartHovered: _isStartHovered.value,
                              isEndHovered: _isEndHovered.value,
                              isStartFocused: _isStartFocused.value,
                              isEndFocused: _isEndFocused.value,
                              orientation: widget.orientation,
                              trackHeight: resolvedTrackHeight,
                              trackCornerRadius: resolvedTrackCornerRadius,
                              thumbWidth: resolvedThumbWidth,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // 2. Thumbs (painted below icons)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _interactionStartController,
                        _interactionEndController,
                        _isStartFocused,
                        _isEndFocused,
                        _isStartPressed,
                        _isEndPressed,
                      ]),
                      builder: (context, child) {
                        final resolvedThumbWidth =
                            widget.decoration?.thumbWidth ??
                            M3ESliderDefaults.thumbWidth;
                        final resolvedThumbHeight =
                            widget.decoration?.thumbHeight ??
                            M3ESliderDefaults.thumbHeight;

                        return CustomPaint(
                          painter: _RangeThumbPainter(
                            startFraction: startFraction,
                            endFraction: endFraction,
                            colors: themeColors,
                            enabled: widget.enabled,
                            startThumbX: widget.orientation == Axis.horizontal
                                ? startThumbX
                                : startThumbY,
                            endThumbX: widget.orientation == Axis.horizontal
                                ? endThumbX
                                : endThumbY,
                            centerY: widget.orientation == Axis.horizontal
                                ? centerY
                                : centerX,
                            startX: margin,
                            endX: dragLength - margin,
                            startOverlayProgress:
                                _interactionStartController.value,
                            endOverlayProgress: _interactionEndController.value,
                            isStartPressed: _isStartPressed.value,
                            isEndPressed: _isEndPressed.value,
                            isStartHovered: _isStartHovered.value,
                            isEndHovered: _isEndHovered.value,
                            isStartFocused: _isStartFocused.value,
                            isEndFocused: _isEndFocused.value,
                            orientation: widget.orientation,
                            thumbWidth: resolvedThumbWidth,
                            thumbHeight: resolvedThumbHeight,
                          ),
                        );
                      },
                    ),
                  ),

                  // 4. Label pill (topmost)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _interactionStartController,
                        _interactionEndController,
                        _isStartPressed,
                        _isEndPressed,
                      ]),
                      builder: (context, child) {
                        final resolvedThumbHeight =
                            widget.decoration?.thumbHeight ??
                            M3ESliderDefaults.thumbHeight;

                        if (widget.label != null &&
                            (_isStartPressed.value || _isEndPressed.value)) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: widget.orientation == Axis.horizontal
                                    ? (_isStartPressed.value
                                          ? startThumbX
                                          : endThumbX)
                                    : centerX + resolvedThumbHeight / 2 + 6,
                                top: widget.orientation == Axis.horizontal
                                    ? centerY - resolvedThumbHeight / 2 - 6 - 24
                                    : (_isStartPressed.value
                                          ? startThumbY
                                          : endThumbY),
                                child: FractionalTranslation(
                                  translation:
                                      widget.orientation == Axis.horizontal
                                      ? const Offset(-0.5, 0)
                                      : const Offset(0, -0.5),
                                  child: AnimatedBuilder(
                                    animation: Listenable.merge([
                                      _interactionStartController,
                                      _interactionEndController,
                                    ]),
                                    builder: (context, child) {
                                      final double val;
                                      if (_isStartPressed.value) {
                                        val = _interactionStartController.value;
                                      } else if (_isEndPressed.value) {
                                        val = _interactionEndController.value;
                                      } else {
                                        val = 0.0;
                                      }
                                      final t = ((val - 0.2) / 0.6).clamp(
                                        0.0,
                                        1.0,
                                      );
                                      return Opacity(
                                        opacity: t,
                                        child: Transform.scale(
                                          scale: 0.85 + 0.15 * t,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _buildPill(themeColors),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  // 4. Start Thumb Focus/Gesture Zone
                  Positioned(
                    left: widget.orientation == Axis.horizontal
                        ? startThumbX - M3ESliderDefaults.thumbRippleRadius
                        : centerX - M3ESliderDefaults.thumbRippleRadius,
                    top: widget.orientation == Axis.horizontal
                        ? centerY - M3ESliderDefaults.thumbRippleRadius
                        : startThumbY - M3ESliderDefaults.thumbRippleRadius,
                    width: M3ESliderDefaults.thumbRippleRadius * 2,
                    height: M3ESliderDefaults.thumbRippleRadius * 2,
                    child: Focus(
                      focusNode: _startFocusNode,
                      canRequestFocus: widget.enabled,
                      autofocus: widget.autofocus,
                      onKeyEvent: _handleStartKeyEvent,
                      child: MouseRegion(
                        onEnter: (_) => _isStartHovered.value = widget.enabled,
                        onExit: (_) => _isStartHovered.value = false,
                        cursor: widget.enabled
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),

                  // 3. End Thumb Focus/Gesture Zone
                  Positioned(
                    left: widget.orientation == Axis.horizontal
                        ? endThumbX - M3ESliderDefaults.thumbRippleRadius
                        : centerX - M3ESliderDefaults.thumbRippleRadius,
                    top: widget.orientation == Axis.horizontal
                        ? centerY - M3ESliderDefaults.thumbRippleRadius
                        : endThumbY - M3ESliderDefaults.thumbRippleRadius,
                    width: M3ESliderDefaults.thumbRippleRadius * 2,
                    height: M3ESliderDefaults.thumbRippleRadius * 2,
                    child: Focus(
                      focusNode: _endFocusNode,
                      canRequestFocus: widget.enabled,
                      onKeyEvent: _handleEndKeyEvent,
                      child: MouseRegion(
                        onEnter: (_) => _isEndHovered.value = widget.enabled,
                        onExit: (_) => _isEndHovered.value = false,
                        cursor: widget.enabled
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RangeTrackPainter extends CustomPainter {
  final double startFraction;
  final double endFraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final bool enabled;

  final double startThumbX;
  final double endThumbX;
  final double centerY;
  final double startX;
  final double endX;

  final double startOverlayProgress;
  final double endOverlayProgress;

  final bool isStartPressed;
  final bool isEndPressed;
  final bool isStartHovered;
  final bool isEndHovered;
  final bool isStartFocused;
  final bool isEndFocused;
  final Axis orientation;
  final double trackHeight;
  final double trackCornerRadius;
  final double thumbWidth;

  _RangeTrackPainter({
    required this.startFraction,
    required this.endFraction,
    required this.tickFractions,
    required this.colors,
    required this.enabled,
    required this.startThumbX,
    required this.endThumbX,
    required this.centerY,
    required this.startX,
    required this.endX,
    required this.startOverlayProgress,
    required this.endOverlayProgress,
    required this.isStartPressed,
    required this.isEndPressed,
    required this.isStartHovered,
    required this.isEndHovered,
    required this.isStartFocused,
    required this.isEndFocused,
    required this.orientation,
    required this.trackHeight,
    required this.trackCornerRadius,
    required this.thumbWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double startThumbWidth = lerpDouble(
      thumbWidth,
      thumbWidth / 2,
      startOverlayProgress,
    )!;

    final double endThumbWidth = lerpDouble(
      thumbWidth,
      thumbWidth / 2,
      endOverlayProgress,
    )!;

    final bool showStartFocusRing =
        isStartFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final bool showEndFocusRing =
        isEndFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    final double startGap =
        M3ESliderDefaults.thumbTrackGapSize + (showStartFocusRing ? 4.0 : 0.0);
    final double endGap =
        M3ESliderDefaults.thumbTrackGapSize + (showEndFocusRing ? 4.0 : 0.0);

    final double startGapDistance = startThumbWidth / 2 + startGap;
    final double endGapDistance = endThumbWidth / 2 + endGap;

    final double leftInactiveEnd;
    final double centerActiveStart;
    final double centerActiveEnd;
    final double rightInactiveStart;

    if (orientation == Axis.horizontal) {
      leftInactiveEnd = (startThumbX - startGapDistance).clamp(startX, endX);
      centerActiveStart = (startThumbX + startGapDistance).clamp(startX, endX);
      centerActiveEnd = (endThumbX - endGapDistance).clamp(startX, endX);
      rightInactiveStart = (endThumbX + endGapDistance).clamp(startX, endX);
    } else {
      leftInactiveEnd = (startThumbX + startGapDistance).clamp(startX, endX);
      centerActiveStart = (startThumbX - startGapDistance).clamp(startX, endX);
      centerActiveEnd = (endThumbX + endGapDistance).clamp(startX, endX);
      rightInactiveStart = (endThumbX - endGapDistance).clamp(startX, endX);
    }

    final trackPaint = Paint()..style = PaintingStyle.fill;

    // 1. Draw Left Inactive Track
    final double leftWidth = orientation == Axis.horizontal
        ? leftInactiveEnd - startX
        : endX - leftInactiveEnd;

    if (leftWidth > 0) {
      trackPaint.color = enabled
          ? colors.inactiveTrackColor
          : colors.disabledInactiveTrackColor;
      final RRect leftRRect;
      if (orientation == Axis.horizontal) {
        leftRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            startX,
            centerY - trackHeight / 2,
            leftInactiveEnd,
            centerY + trackHeight / 2,
          ),
          topLeft: Radius.circular(trackCornerRadius),
          bottomLeft: Radius.circular(trackCornerRadius),
          topRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
        );
      } else {
        leftRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            centerY - trackHeight / 2,
            leftInactiveEnd,
            centerY + trackHeight / 2,
            endX,
          ),
          bottomLeft: Radius.circular(trackCornerRadius),
          bottomRight: Radius.circular(trackCornerRadius),
          topLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          topRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
        );
      }
      canvas.drawRRect(leftRRect, trackPaint);
    }

    // 2. Draw Center Active Track
    final double activeWidth = orientation == Axis.horizontal
        ? centerActiveEnd - centerActiveStart
        : centerActiveStart - centerActiveEnd;

    if (activeWidth > 0) {
      trackPaint.color = enabled
          ? colors.activeTrackColor
          : colors.disabledActiveTrackColor;
      final RRect activeRRect;
      if (orientation == Axis.horizontal) {
        activeRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            centerActiveStart,
            centerY - trackHeight / 2,
            centerActiveEnd,
            centerY + trackHeight / 2,
          ),
          topLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          topRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
        );
      } else {
        activeRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            centerY - trackHeight / 2,
            centerActiveEnd,
            centerY + trackHeight / 2,
            centerActiveStart,
          ),
          topLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          topRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
        );
      }
      canvas.drawRRect(activeRRect, trackPaint);
    }

    // 3. Draw Right Inactive Track
    final double rightWidth = orientation == Axis.horizontal
        ? endX - rightInactiveStart
        : rightInactiveStart - startX;

    if (rightWidth > 0) {
      trackPaint.color = enabled
          ? colors.inactiveTrackColor
          : colors.disabledInactiveTrackColor;
      final RRect rightRRect;
      if (orientation == Axis.horizontal) {
        rightRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            rightInactiveStart,
            centerY - trackHeight / 2,
            endX,
            centerY + trackHeight / 2,
          ),
          topLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          topRight: Radius.circular(trackCornerRadius),
          bottomRight: Radius.circular(trackCornerRadius),
        );
      } else {
        rightRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            centerY - trackHeight / 2,
            startX,
            centerY + trackHeight / 2,
            rightInactiveStart,
          ),
          topLeft: Radius.circular(trackCornerRadius),
          topRight: Radius.circular(trackCornerRadius),
          bottomLeft: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
          bottomRight: const Radius.circular(
            M3ESliderDefaults.trackInsideCornerSize,
          ),
        );
      }
      canvas.drawRRect(rightRRect, trackPaint);
    }

    // 4. Draw Stop Indicators at endpoints if inactive (only if no icon is showing)
    final stopIndicatorPaint = Paint()..style = PaintingStyle.fill;
    stopIndicatorPaint.color = enabled
        ? colors.activeTrackColor
        : colors.disabledActiveTrackColor;
    final stopRadius = M3ESliderDefaults.tickSize / 2;

    if (leftWidth > 0) {
      if (orientation == Axis.horizontal) {
        canvas.drawCircle(
          Offset(startX + trackCornerRadius, centerY),
          stopRadius,
          stopIndicatorPaint,
        );
      } else {
        canvas.drawCircle(
          Offset(centerY, endX - trackCornerRadius),
          stopRadius,
          stopIndicatorPaint,
        );
      }
    }
    if (rightWidth > 0) {
      if (orientation == Axis.horizontal) {
        canvas.drawCircle(
          Offset(endX - trackCornerRadius, centerY),
          stopRadius,
          stopIndicatorPaint,
        );
      } else {
        canvas.drawCircle(
          Offset(centerY, startX + trackCornerRadius),
          stopRadius,
          stopIndicatorPaint,
        );
      }
    }

    // 5. Draw Tick Marks (only if no icon is showing)
    if (tickFractions.isNotEmpty) {
      final tickPaint = Paint()..style = PaintingStyle.fill;
      final trackLengthTotal = endX - startX;

      for (int i = 0; i < tickFractions.length; i++) {
        if (i == 0 || i == tickFractions.length - 1) continue;

        final double pos = startX + trackLengthTotal * tickFractions[i];
        final double drawPos = orientation == Axis.horizontal
            ? pos
            : endX - trackLengthTotal * tickFractions[i];

        if (drawPos >= startThumbX - startGapDistance &&
            drawPos <= startThumbX + startGapDistance) {
          continue;
        }
        if (drawPos >= endThumbX - endGapDistance &&
            drawPos <= endThumbX + endGapDistance) {
          continue;
        }

        final bool isActive =
            tickFractions[i] >= startFraction &&
            tickFractions[i] <= endFraction;
        tickPaint.color = enabled
            ? (isActive ? colors.activeTickColor : colors.inactiveTickColor)
            : (isActive
                  ? colors.disabledActiveTickColor
                  : colors.disabledInactiveTickColor);

        if (orientation == Axis.horizontal) {
          canvas.drawCircle(
            Offset(drawPos, centerY),
            M3ESliderDefaults.tickSize / 2,
            tickPaint,
          );
        } else {
          canvas.drawCircle(
            Offset(centerY, drawPos),
            M3ESliderDefaults.tickSize / 2,
            tickPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RangeTrackPainter oldDelegate) {
    return oldDelegate.startFraction != startFraction ||
        oldDelegate.endFraction != endFraction ||
        oldDelegate.tickFractions != tickFractions ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.startThumbX != startThumbX ||
        oldDelegate.endThumbX != endThumbX ||
        oldDelegate.centerY != centerY ||
        oldDelegate.startX != startX ||
        oldDelegate.endX != endX ||
        oldDelegate.startOverlayProgress != startOverlayProgress ||
        oldDelegate.endOverlayProgress != endOverlayProgress ||
        oldDelegate.isStartPressed != isStartPressed ||
        oldDelegate.isEndPressed != isEndPressed ||
        oldDelegate.isStartHovered != isStartHovered ||
        oldDelegate.isEndHovered != isEndHovered ||
        oldDelegate.isStartFocused != isStartFocused ||
        oldDelegate.isEndFocused != isEndFocused ||
        oldDelegate.orientation != orientation ||
        oldDelegate.trackHeight != trackHeight ||
        oldDelegate.trackCornerRadius != trackCornerRadius ||
        oldDelegate.thumbWidth != thumbWidth;
  }
}

class _RangeThumbPainter extends CustomPainter {
  final double startFraction;
  final double endFraction;
  final M3ESliderColors colors;
  final bool enabled;
  final double startThumbX;
  final double endThumbX;
  final double centerY;
  final double startX;
  final double endX;
  final double startOverlayProgress;
  final double endOverlayProgress;
  final bool isStartPressed;
  final bool isEndPressed;
  final bool isStartHovered;
  final bool isEndHovered;
  final bool isStartFocused;
  final bool isEndFocused;
  final Axis orientation;
  final double thumbWidth;
  final double thumbHeight;

  _RangeThumbPainter({
    required this.startFraction,
    required this.endFraction,
    required this.colors,
    required this.enabled,
    required this.startThumbX,
    required this.endThumbX,
    required this.centerY,
    required this.startX,
    required this.endX,
    required this.startOverlayProgress,
    required this.endOverlayProgress,
    required this.isStartPressed,
    required this.isEndPressed,
    required this.isStartHovered,
    required this.isEndHovered,
    required this.isStartFocused,
    required this.isEndFocused,
    required this.orientation,
    required this.thumbWidth,
    required this.thumbHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double startThumbWidth = lerpDouble(
      thumbWidth,
      thumbWidth / 2,
      startOverlayProgress,
    )!;

    final double endThumbWidth = lerpDouble(
      thumbWidth,
      thumbWidth / 2,
      endOverlayProgress,
    )!;

    final bool showStartFocusRing =
        isStartFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final bool showEndFocusRing =
        isEndFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // 1. Draw Thumbs
    final thumbPaint = Paint()
      ..color = enabled ? colors.thumbColor : colors.disabledThumbColor
      ..style = PaintingStyle.fill;

    // Start Thumb
    final double startThumbW = orientation == Axis.horizontal
        ? startThumbWidth
        : thumbHeight;
    final double startThumbH = orientation == Axis.horizontal
        ? thumbHeight
        : startThumbWidth;
    final startThumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: orientation == Axis.horizontal
            ? Offset(startThumbX, centerY)
            : Offset(centerY, startThumbX),
        width: startThumbW,
        height: startThumbH,
      ),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(startThumbRRect, thumbPaint);

    // End Thumb
    final double endThumbW = orientation == Axis.horizontal
        ? endThumbWidth
        : thumbHeight;
    final double endThumbH = orientation == Axis.horizontal
        ? thumbHeight
        : endThumbWidth;
    final endThumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: orientation == Axis.horizontal
            ? Offset(endThumbX, centerY)
            : Offset(centerY, endThumbX),
        width: endThumbW,
        height: endThumbH,
      ),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(endThumbRRect, thumbPaint);

    // 2. Draw concentric Focus Rings if focused via keyboard/traditional mode and enabled
    if (enabled) {
      final focusPaint = Paint()
        ..color = colors.thumbColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      if (showStartFocusRing) {
        final focusRRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: orientation == Axis.horizontal
                ? Offset(startThumbX, centerY)
                : Offset(centerY, startThumbX),
            width: startThumbW + 6.0,
            height: startThumbH + 6.0,
          ),
          const Radius.circular(5.0),
        );
        canvas.drawRRect(focusRRect, focusPaint);
      }

      if (showEndFocusRing) {
        final focusRRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: orientation == Axis.horizontal
                ? Offset(endThumbX, centerY)
                : Offset(centerY, endThumbX),
            width: endThumbW + 6.0,
            height: endThumbH + 6.0,
          ),
          const Radius.circular(5.0),
        );
        canvas.drawRRect(focusRRect, focusPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RangeThumbPainter oldDelegate) {
    return oldDelegate.startFraction != startFraction ||
        oldDelegate.endFraction != endFraction ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.startThumbX != startThumbX ||
        oldDelegate.endThumbX != endThumbX ||
        oldDelegate.centerY != centerY ||
        oldDelegate.startX != startX ||
        oldDelegate.endX != endX ||
        oldDelegate.startOverlayProgress != startOverlayProgress ||
        oldDelegate.endOverlayProgress != endOverlayProgress ||
        oldDelegate.isStartPressed != isStartPressed ||
        oldDelegate.isEndPressed != isEndPressed ||
        oldDelegate.isStartHovered != isStartHovered ||
        oldDelegate.isEndHovered != isEndHovered ||
        oldDelegate.isStartFocused != isStartFocused ||
        oldDelegate.isEndFocused != isEndFocused ||
        oldDelegate.orientation != orientation ||
        oldDelegate.thumbWidth != thumbWidth ||
        oldDelegate.thumbHeight != thumbHeight;
  }
}
