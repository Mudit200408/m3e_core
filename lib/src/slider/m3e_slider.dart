// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';
import 'm3e_slider_theme.dart';
import 'style/m3e_slider_decoration.dart';
import '../common/m3e_common.dart';

/// A Material 3 Expressive Slider.
///
/// Permits selecting a single value from a range. Supports keyboard focus,
/// custom decorations, haptic feedback, and snap-to-tick animations.
class M3ESlider extends StatefulWidget {
  /// The current value of the slider.
  final double value;

  /// Callback when the value is changing.
  final ValueChanged<double>? onChanged;

  /// Callback when the user starts changing the value.
  final ValueChanged<double>? onChangeStart;

  /// Callback when the user finishes changing the value.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value of the slider. Defaults to 0.0.
  final double min;

  /// The maximum value of the slider. Defaults to 1.0.
  final double max;

  /// The number of discrete intervals. If null, the slider is continuous.
  final int? divisions;

  /// Whether the slider is enabled.
  final bool enabled;

  /// The focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether to autofocus this widget.
  final bool autofocus;

  /// The decoration overrides (colors, haptics).
  final M3ESliderDecoration? decoration;

  /// The layout orientation of the slider. Defaults to [Axis.horizontal].
  final Axis orientation;

  /// An optional label shown in a pill above the thumb while pressed.
  final String? label;

  /// The icon to show inside the track bar.
  final Widget? icon;

  /// Whether the track icon is at the trailing end (default true) or leading end (false).
  final bool trailingIcon;

  /// Override for the track icon size.
  final double? iconSize;

  const M3ESlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.decoration,
    this.orientation = Axis.horizontal,
    this.label,
    this.icon,
    this.trailingIcon = true,
    this.iconSize,
  }) : assert(min <= max),
       assert(value >= min && value <= max),
       assert(divisions == null || divisions > 0),
       assert(
         divisions == null || icon == null,
         'Divisions are not allowed when an icon is provided.',
       );

  @override
  State<M3ESlider> createState() => _M3ESliderState();
}

class _M3ESliderState extends State<M3ESlider> with TickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _snapController;
  late AnimationController _interactionController;

  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  int _lastHapticTick = -1;
  double? _lastTapValue;
  bool _isDragging = false;
  VoidCallback? _snapListener;
  RenderBox? _renderBox;
  int? _cachedDivisions;
  List<double>? _cachedTickFractions;

  late final SingleMotionController _dockController;
  bool _isDocked = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _interactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _dockController =
        SingleMotionController(
          motion: M3EMotion.expressiveSpatialFast.toMotion(),
          vsync: this,
          initialValue: 0.0,
        )..addListener(() {
          if (mounted) setState(() {});
        });

    _isHovered.addListener(_updateInteractionAnimation);
    _isPressed.addListener(_updateInteractionAnimation);
  }

  void _clearSnapListener() {
    if (_snapListener != null) {
      _snapController.removeListener(_snapListener!);
      _snapListener = null;
    }
  }

  @override
  void dispose() {
    _clearSnapListener();
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _snapController.dispose();
    _interactionController.dispose();
    _dockController.dispose();
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

  @visibleForTesting
  bool get isFocusedForTesting => _isFocused.value;

  void _updateInteractionAnimation() {
    if (_isPressed.value || _isHovered.value) {
      _interactionController.forward();
    } else {
      _interactionController.reverse();
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

  void _updateValue(double newValue) {
    if (!widget.enabled || widget.onChanged == null) return;
    final clamped = newValue.clamp(widget.min, widget.max);

    // Check haptic tick crossing
    final divs = widget.divisions;
    if (divs != null && divs > 0) {
      final fraction = _valueToFraction(clamped);
      final currentTick = (fraction * divs).round();
      if (currentTick != _lastHapticTick) {
        _lastHapticTick = currentTick;
        final haptic = widget.decoration?.haptic ?? M3EHapticFeedback.none;
        haptic.apply();
      }
    }

    widget.onChanged!(clamped);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled) return;
    _isFocusedFromPointer = true;
    _focusNode.requestFocus();
    _clearSnapListener();
    _snapController.stop();
    _isPressed.value = true;
    _isDragging = true;
    _renderBox = context.findRenderObject() as RenderBox;
    _lastHapticTick = -1;
    widget.onChangeStart?.call(widget.value);
  }

  void _handleDragUpdate(DragUpdateDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;
    final RenderBox renderBox = _renderBox!;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

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

    _updateValue(rawValue);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;
    _isPressed.value = false;
    _isDragging = false;
    _renderBox = null;
    _snapToNearestTick();
  }

  void _handleTapDown(TapDownDetails details, double totalLength) {
    if (!widget.enabled || totalLength <= 0) return;
    _isFocusedFromPointer = true;
    _focusNode.requestFocus();
    _clearSnapListener();
    _snapController.stop();
    _isPressed.value = true;
    _lastHapticTick = -1;
    widget.onChangeStart?.call(widget.value);

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

    _updateValue(rawValue);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _isPressed.value = false;
    _snapToNearestTick(fromValue: _lastTapValue);
    _lastTapValue = null;
  }

  void _snapToNearestTick({double? fromValue}) {
    final fractions = _tickFractions;
    if (fractions.isEmpty) {
      widget.onChangeEnd?.call(widget.value);
      return;
    }

    final double actualValue = fromValue ?? widget.value;
    final currentFraction = _valueToFraction(actualValue);
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
    if (targetValue != actualValue) {
      final startValue = actualValue;
      final animation = Tween<double>(begin: startValue, end: targetValue)
          .animate(
            CurvedAnimation(
              parent: _snapController,
              curve: Curves.fastOutSlowIn,
            ),
          );

      void listener() {
        _updateValue(animation.value);
      }

      _clearSnapListener();
      _snapListener = listener;
      _snapController.addListener(listener);
      _snapController.forward(from: 0.0).then((_) {
        if (!mounted) return;
        _snapController.removeListener(listener);
        if (_snapListener == listener) _snapListener = null;
        widget.onChangeEnd?.call(targetValue);
      });
    } else {
      widget.onChangeEnd?.call(widget.value);
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (_isFocusedFromPointer) {
      _isFocusedFromPointer = false;
      _isFocused.value = _focusNode.hasFocus;
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
        _clearSnapListener();
        _snapController.stop();
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
    final themeColors =
        widget.decoration?.colors ?? M3ESliderDefaults.colors(context);

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: widget.enabled,
      onKeyEvent: _handleKeyEvent,
      child: MouseRegion(
        onEnter: (_) => _isHovered.value = widget.enabled,
        onExit: (_) => _isHovered.value = false,
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: LayoutBuilder(
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
              height = constraints.hasBoundedHeight
                  ? constraints.maxHeight
                  : 200.0;
            }

            final dragLength = widget.orientation == Axis.horizontal
                ? width
                : height;

            final valueFraction = _valueToFraction(widget.value);
            const margin = M3ESliderDefaults.thumbRadius;
            final trackLength = dragLength - 2 * margin;

            return Listener(
              onPointerCancel: (_) {
                _isPressed.value = false;
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: widget.orientation == Axis.horizontal
                    ? _handleDragStart
                    : null,
                onHorizontalDragUpdate: widget.orientation == Axis.horizontal
                    ? (details) => _handleDragUpdate(details, dragLength)
                    : null,
                onHorizontalDragEnd: widget.orientation == Axis.horizontal
                    ? _handleDragEnd
                    : null,
                onVerticalDragStart: widget.orientation == Axis.vertical
                    ? _handleDragStart
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
                    _isPressed.value = false;
                    _snapToNearestTick(fromValue: _lastTapValue);
                    _lastTapValue = null;
                  }
                },
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _interactionController,
                      _isFocused,
                      _isPressed,
                    ]),
                    builder: (context, child) {
                      final thumbPos = widget.orientation == Axis.horizontal
                          ? margin + trackLength * valueFraction
                          : (height - margin) - trackLength * valueFraction;
                      final cs = Theme.of(context).colorScheme;
                      final totalLength = widget.orientation == Axis.horizontal
                          ? width
                          : height;
                      final startPos = widget.orientation == Axis.horizontal
                          ? margin
                          : totalLength - margin;
                      final endPos = widget.orientation == Axis.horizontal
                          ? totalLength - margin
                          : margin;

                      final resolvedTrackHeight =
                          widget.decoration?.trackHeight ??
                          M3ESliderDefaults.trackHeight;
                      final resolvedTrackCornerRadius =
                          widget.decoration?.trackCornerRadius ??
                          (resolvedTrackHeight / 2);
                      final resolvedThumbWidth =
                          widget.decoration?.thumbWidth ??
                          M3ESliderDefaults.thumbWidth;
                      final resolvedThumbHeight =
                          widget.decoration?.thumbHeight ??
                          M3ESliderDefaults.thumbHeight;

                      final isIconVisible = widget.icon != null;

                      final iconSize =
                          widget.iconSize ??
                          widget.decoration?.trackIconSize ??
                          M3ESliderDefaults.trackIconSize;
                      final iconActiveColor =
                          widget.decoration?.trackIconActiveColor ??
                          M3ESliderDefaults.trackIconActiveColor(cs);
                      final iconInactiveColor =
                          widget.decoration?.trackIconInactiveColor ??
                          M3ESliderDefaults.trackIconInactiveColor(cs);

                      final double iconRestingCenter;
                      if (widget.trailingIcon) {
                        if (widget.orientation == Axis.horizontal) {
                          iconRestingCenter =
                              endPos - resolvedTrackCornerRadius - iconSize / 2;
                        } else {
                          iconRestingCenter =
                              endPos + resolvedTrackCornerRadius + iconSize / 2;
                        }
                      } else {
                        if (widget.orientation == Axis.horizontal) {
                          iconRestingCenter =
                              startPos +
                              resolvedTrackCornerRadius +
                              iconSize / 2;
                        } else {
                          iconRestingCenter =
                              startPos -
                              resolvedTrackCornerRadius -
                              iconSize / 2;
                        }
                      }

                      final dockDistanceLimit =
                          (resolvedThumbWidth / 2 + iconSize / 2) + 8.0;

                      final bool isDocked;
                      if (widget.trailingIcon) {
                        isDocked =
                            isIconVisible &&
                            (widget.orientation == Axis.horizontal
                                ? (iconRestingCenter - thumbPos) <=
                                      dockDistanceLimit
                                : (thumbPos - iconRestingCenter) <=
                                      dockDistanceLimit);
                      } else {
                        isDocked =
                            isIconVisible &&
                            (widget.orientation == Axis.horizontal
                                ? (thumbPos - iconRestingCenter) <=
                                      dockDistanceLimit
                                : (iconRestingCenter - thumbPos) <=
                                      dockDistanceLimit);
                      }

                      // Update dock animation target
                      if (isDocked != _isDocked) {
                        _isDocked = isDocked;
                        _dockController.animateTo(isDocked ? 1.0 : 0.0);
                      }

                      final double iconDockedTarget;
                      if (widget.trailingIcon) {
                        if (widget.orientation == Axis.horizontal) {
                          iconDockedTarget =
                              thumbPos -
                              (resolvedThumbWidth / 2 + iconSize / 2 + 12.0);
                        } else {
                          iconDockedTarget =
                              thumbPos +
                              (resolvedThumbWidth / 2 + iconSize / 2 + 12.0);
                        }
                      } else {
                        if (widget.orientation == Axis.horizontal) {
                          iconDockedTarget =
                              thumbPos +
                              (resolvedThumbWidth / 2 + iconSize / 2 + 12.0);
                        } else {
                          iconDockedTarget =
                              thumbPos -
                              (resolvedThumbWidth / 2 + iconSize / 2 + 12.0);
                        }
                      }

                      // Interpolate icon center
                      final double iconCenter = lerpDouble(
                        iconRestingCenter,
                        iconDockedTarget,
                        _dockController.value,
                      )!;

                      final bool isIconOnActive;
                      if (widget.trailingIcon) {
                        isIconOnActive = widget.orientation == Axis.horizontal
                            ? thumbPos >= iconCenter
                            : thumbPos <= iconCenter;
                      } else {
                        isIconOnActive = widget.orientation == Axis.horizontal
                            ? thumbPos <= iconCenter
                            : thumbPos >= iconCenter;
                      }

                      Widget buildIcon(
                        Widget? icon,
                        bool isActive,
                        double position,
                        double center,
                        double dockProgress,
                      ) {
                        if (icon == null) return const SizedBox.shrink();
                        final baseIconColor = isActive
                            ? iconActiveColor
                            : iconInactiveColor;
                        final finalIconColor = widget.trailingIcon
                            ? Color.lerp(
                                baseIconColor,
                                cs.onPrimary,
                                dockProgress,
                              )!
                            : Color.lerp(
                                cs.onPrimary,
                                baseIconColor,
                                dockProgress,
                              )!;

                        return Positioned(
                          left: widget.orientation == Axis.horizontal
                              ? position
                              : center,
                          top: widget.orientation == Axis.horizontal
                              ? center
                              : position,
                          child: FractionalTranslation(
                            translation: const Offset(-0.5, -0.5),
                            child: IconTheme.merge(
                              data: IconThemeData(
                                size: iconSize,
                                color: finalIconColor,
                              ),
                              child: icon,
                            ),
                          ),
                        );
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 1. Track (bottom layer)
                          CustomPaint(
                            size: Size(width, height),
                            painter: _SliderTrackPainter(
                              valueFraction: valueFraction,
                              tickFractions: _tickFractions,
                              colors: themeColors,
                              enabled: widget.enabled,
                              isFocused: _isFocused.value,
                              interactionProgress: _interactionController.value,
                              orientation: widget.orientation,
                              trackHeight: resolvedTrackHeight,
                              trackCornerRadius: resolvedTrackCornerRadius,
                              thumbWidth: resolvedThumbWidth,
                              showIcon: widget.icon != null,
                            ),
                          ),
                          // 2. Thumb
                          CustomPaint(
                            size: Size(width, height),
                            painter: _SliderThumbPainter(
                              valueFraction: valueFraction,
                              colors: themeColors,
                              enabled: widget.enabled,
                              isFocused: _isFocused.value,
                              isPressed: _isPressed.value,
                              interactionProgress: _interactionController.value,
                              orientation: widget.orientation,
                              thumbWidth: resolvedThumbWidth,
                              thumbHeight: resolvedThumbHeight,
                            ),
                          ),

                          // 4. Trailing icon (on top of thumb)
                          if (isIconVisible)
                            buildIcon(
                              widget.icon,
                              isIconOnActive,
                              iconCenter,
                              widget.orientation == Axis.horizontal
                                  ? height / 2
                                  : width / 2,
                              _dockController.value,
                            ),
                          // 5. Label pill (topmost)
                          if (widget.label != null && _isPressed.value)
                            Positioned(
                              left: widget.orientation == Axis.horizontal
                                  ? thumbPos
                                  : width / 2 + resolvedThumbHeight / 2 + 6,
                              top: widget.orientation == Axis.horizontal
                                  ? height / 2 -
                                        resolvedThumbHeight / 2 -
                                        6 -
                                        24
                                  : thumbPos,
                              child: FractionalTranslation(
                                translation:
                                    widget.orientation == Axis.horizontal
                                    ? const Offset(-0.5, 0)
                                    : const Offset(0, -0.5),
                                child: AnimatedBuilder(
                                  animation: _interactionController,
                                  builder: (context, child) {
                                    final t =
                                        ((_interactionController.value - 0.2) /
                                                0.6)
                                            .clamp(0.0, 1.0);
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

class _SliderTrackPainter extends CustomPainter {
  final double valueFraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final bool enabled;
  final bool isFocused;
  final double interactionProgress;
  final Axis orientation;
  final double trackHeight;
  final double trackCornerRadius;
  final double thumbWidth;
  final bool showIcon;

  _SliderTrackPainter({
    required this.valueFraction,
    required this.tickFractions,
    required this.colors,
    required this.enabled,
    required this.isFocused,
    required this.interactionProgress,
    required this.orientation,
    required this.trackHeight,
    required this.trackCornerRadius,
    required this.thumbWidth,
    required this.showIcon,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const margin = M3ESliderDefaults.thumbRadius;
    final double trackLength =
        (orientation == Axis.horizontal ? size.width : size.height) -
        2 * margin;
    if (trackLength <= 0) return;

    final double currentThumbThickness = lerpDouble(
      thumbWidth,
      thumbWidth / 2,
      interactionProgress,
    )!;

    final bool showFocusRing =
        isFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    final double gap =
        M3ESliderDefaults.thumbTrackGapSize + (showFocusRing ? 4.0 : 0.0);
    final double gapDistance = currentThumbThickness / 2 + gap;

    final double startPosition = margin;
    final double endPosition =
        (orientation == Axis.horizontal ? size.width : size.height) - margin;

    final double thumbPosition;
    if (orientation == Axis.horizontal) {
      thumbPosition = startPosition + trackLength * valueFraction;
    } else {
      thumbPosition = (size.height - margin) - trackLength * valueFraction;
    }

    final double activeTrackEnd;
    final double inactiveTrackStart;

    if (orientation == Axis.horizontal) {
      activeTrackEnd = (thumbPosition - gapDistance).clamp(
        startPosition,
        endPosition,
      );
      inactiveTrackStart = (thumbPosition + gapDistance).clamp(
        startPosition,
        endPosition,
      );
    } else {
      activeTrackEnd = (thumbPosition + gapDistance).clamp(
        startPosition,
        endPosition,
      );
      inactiveTrackStart = (thumbPosition - gapDistance).clamp(
        startPosition,
        endPosition,
      );
    }

    final trackPaint = Paint()..style = PaintingStyle.fill;

    // 1. Draw Inactive Track
    final double inactiveWidth = orientation == Axis.horizontal
        ? endPosition - inactiveTrackStart
        : inactiveTrackStart - startPosition;

    if (inactiveWidth > 0) {
      trackPaint.color = enabled
          ? colors.inactiveTrackColor
          : colors.disabledInactiveTrackColor;
      final RRect inactiveRRect;
      if (orientation == Axis.horizontal) {
        inactiveRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            inactiveTrackStart,
            size.height / 2 - trackHeight / 2,
            endPosition,
            size.height / 2 + trackHeight / 2,
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
        inactiveRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            size.width / 2 - trackHeight / 2,
            startPosition,
            size.width / 2 + trackHeight / 2,
            inactiveTrackStart,
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
      canvas.drawRRect(inactiveRRect, trackPaint);
    }

    // 2. Draw Active Track
    final double activeWidth = orientation == Axis.horizontal
        ? activeTrackEnd - startPosition
        : (size.height - margin) - activeTrackEnd;

    if (activeWidth > 0) {
      trackPaint.color = enabled
          ? colors.activeTrackColor
          : colors.disabledActiveTrackColor;
      final RRect activeRRect;
      if (orientation == Axis.horizontal) {
        activeRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            startPosition,
            size.height / 2 - trackHeight / 2,
            activeTrackEnd,
            size.height / 2 + trackHeight / 2,
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
        activeRRect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            size.width / 2 - trackHeight / 2,
            activeTrackEnd,
            size.width / 2 + trackHeight / 2,
            size.height - margin,
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
      canvas.drawRRect(activeRRect, trackPaint);
    }

    // 3. Draw Stop Indicators at endpoints if inactive (only if no icon is showing)
    final stopIndicatorPaint = Paint()..style = PaintingStyle.fill;
    stopIndicatorPaint.color = enabled
        ? colors.activeTrackColor
        : colors.disabledActiveTrackColor;
    final stopRadius = M3ESliderDefaults.tickSize / 2;

    if (inactiveWidth > 0 && !showIcon) {
      if (orientation == Axis.horizontal) {
        canvas.drawCircle(
          Offset(endPosition - trackCornerRadius, size.height / 2),
          stopRadius,
          stopIndicatorPaint,
        );
      } else {
        canvas.drawCircle(
          Offset(size.width / 2, startPosition + trackCornerRadius),
          stopRadius,
          stopIndicatorPaint,
        );
      }
    }

    // 4. Draw Tick Marks (only if no icon is showing)
    if (tickFractions.isNotEmpty && !showIcon) {
      final tickPaint = Paint()..style = PaintingStyle.fill;

      for (int i = 0; i < tickFractions.length; i++) {
        if (i == 0 || i == tickFractions.length - 1) continue;

        final double pos = startPosition + trackLength * tickFractions[i];
        final double drawPos = orientation == Axis.horizontal
            ? pos
            : (size.height - margin) - trackLength * tickFractions[i];

        if (drawPos >= thumbPosition - gapDistance &&
            drawPos <= thumbPosition + gapDistance) {
          continue;
        }

        final bool isActive = tickFractions[i] <= valueFraction;
        tickPaint.color = enabled
            ? (isActive ? colors.activeTickColor : colors.inactiveTickColor)
            : (isActive
                  ? colors.disabledActiveTickColor
                  : colors.disabledInactiveTickColor);

        if (orientation == Axis.horizontal) {
          canvas.drawCircle(
            Offset(drawPos, size.height / 2),
            M3ESliderDefaults.tickSize / 2,
            tickPaint,
          );
        } else {
          canvas.drawCircle(
            Offset(size.width / 2, drawPos),
            M3ESliderDefaults.tickSize / 2,
            tickPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SliderTrackPainter oldDelegate) {
    return oldDelegate.valueFraction != valueFraction ||
        oldDelegate.tickFractions != tickFractions ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.isFocused != isFocused ||
        oldDelegate.interactionProgress != interactionProgress ||
        oldDelegate.orientation != orientation ||
        oldDelegate.trackHeight != trackHeight ||
        oldDelegate.trackCornerRadius != trackCornerRadius ||
        oldDelegate.thumbWidth != thumbWidth ||
        oldDelegate.showIcon != showIcon;
  }
}

class _SliderThumbPainter extends CustomPainter {
  final double valueFraction;
  final M3ESliderColors colors;
  final bool enabled;
  final bool isFocused;
  final bool isPressed;
  final double interactionProgress;
  final Axis orientation;
  final double thumbWidth;
  final double thumbHeight;

  _SliderThumbPainter({
    required this.valueFraction,
    required this.colors,
    required this.enabled,
    required this.isFocused,
    required this.isPressed,
    required this.interactionProgress,
    required this.orientation,
    required this.thumbWidth,
    required this.thumbHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const margin = M3ESliderDefaults.thumbRadius;
    final double trackLength =
        (orientation == Axis.horizontal ? size.width : size.height) -
        2 * margin;
    if (trackLength <= 0) return;

    final double currentThumbThickness = lerpDouble(
      thumbWidth,
      thumbWidth / 2,
      interactionProgress,
    )!;

    final bool showFocusRing =
        isFocused &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    final double startPosition = margin;
    final double thumbPosition;
    if (orientation == Axis.horizontal) {
      thumbPosition = startPosition + trackLength * valueFraction;
    } else {
      thumbPosition = (size.height - margin) - trackLength * valueFraction;
    }

    // 1. Draw Thumb
    final thumbPaint = Paint()
      ..color = enabled ? colors.thumbColor : colors.disabledThumbColor
      ..style = PaintingStyle.fill;

    final double thumbW = orientation == Axis.horizontal
        ? currentThumbThickness
        : thumbHeight;
    final double thumbH = orientation == Axis.horizontal
        ? thumbHeight
        : currentThumbThickness;

    final RRect thumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: orientation == Axis.horizontal
            ? Offset(thumbPosition, size.height / 2)
            : Offset(size.width / 2, thumbPosition),
        width: thumbW,
        height: thumbH,
      ),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(thumbRRect, thumbPaint);

    // 2. Draw concentric Focus Ring if focused via keyboard/traditional mode and enabled
    if (showFocusRing && enabled) {
      final focusPaint = Paint()
        ..color = colors.thumbColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final focusRRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: orientation == Axis.horizontal
              ? Offset(thumbPosition, size.height / 2)
              : Offset(size.width / 2, thumbPosition),
          width: thumbW + 6.0,
          height: thumbH + 6.0,
        ),
        const Radius.circular(5.0),
      );
      canvas.drawRRect(focusRRect, focusPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SliderThumbPainter oldDelegate) {
    return oldDelegate.valueFraction != valueFraction ||
        oldDelegate.colors != colors ||
        oldDelegate.enabled != enabled ||
        oldDelegate.isFocused != isFocused ||
        oldDelegate.isPressed != isPressed ||
        oldDelegate.interactionProgress != interactionProgress ||
        oldDelegate.orientation != orientation ||
        oldDelegate.thumbWidth != thumbWidth ||
        oldDelegate.thumbHeight != thumbHeight;
  }
}
