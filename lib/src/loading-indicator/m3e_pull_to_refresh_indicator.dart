import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';
import '../common/m3e_common.dart';
import '../shapes/m3e_shapes_core.dart';
import 'm3e_contained_loading_indicator.dart';
import 'm3e_pull_to_refresh_controller.dart';
import 'm3e_pull_to_refresh_style.dart';

/// A Material 3 Expressive (M3E) Pull to Refresh Indicator.
///
/// Instead of an overlapping circular indicator, [M3EPullToRefreshIndicator]
/// pushes the scrollable content list DOWN as the user pulls.
/// Powered by the [motor] spring physics package, the indicator container and
/// content list retract back up with realistic spring motion and subtle
/// overshoots upon release.
///
/// ### Basic usage
/// ```dart
/// M3EPullToRefreshIndicator(
///   onRefresh: () async {
///     await fetchData();
///   },
///   child: ListView.builder(
///     physics: const AlwaysScrollableScrollPhysics(),
///     itemCount: items.length,
///     itemBuilder: (context, index) => ListTile(title: Text(items[index])),
///   ),
/// )
/// ```
class M3EPullToRefreshIndicator extends StatefulWidget {
  /// Callback executed when the pull-to-refresh is triggered.
  ///
  /// The header remains open until this future completes (or throws).
  final Future<void> Function() onRefresh;

  /// Optional callback invoked if [onRefresh] throws.
  ///
  /// Receives the error and stack trace. If null, errors are silently swallowed
  /// after the header retracts.
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Optional controller to observe or programmatically trigger pull-to-refresh.
  final M3EPullToRefreshController? controller;

  /// The scrollable child widget (e.g. [ListView], [CustomScrollView]).
  final Widget child;

  /// Settled height of the loading indicator container during refresh.
  final double? indicatorHeight;

  /// Pull distance required to trigger the refresh callback.
  final double? triggerDistance;

  /// Spring motion specification for retract animations.
  final M3EMotion? springMotion;

  /// Custom list of polygon shapes for the shape-morphing indicator.
  final List<Shapes>? shapes;

  /// Custom icon or animation widget to display instead of the default
  /// [M3EContainedLoadingIndicator].
  final Widget? indicatorIcon;

  /// Haptic feedback intensity when drag reaches trigger distance.
  final M3EHapticFeedback? hapticFeedback;

  /// Custom styling parameters for the loading indicator container.
  final M3EPullToRefreshStyle? style;

  /// Optional custom builder for rendering the header widget given drag
  /// progress and refresh state.
  ///
  /// - [progress] is in the range `[0.0, 1.0]` relative to trigger distance.
  /// - [isRefreshing] is `true` while [onRefresh] is executing.
  final Widget Function(
    BuildContext context,
    double progress,
    bool isRefreshing,
  )?
  indicatorBuilder;

  /// Resistance factor applied to the raw drag delta.
  ///
  /// Lower values make the drag feel heavier; higher values make it feel
  /// lighter. Must be in the range `(0.0, 1.0]`.
  final double? dragResistance;

  /// Multiplier applied to trigger distance to compute the maximum drag cap.
  final double? maxDragMultiplier;

  /// Predicate used to filter which [ScrollNotification]s activate the
  /// pull-to-refresh gesture.
  ///
  /// Defaults to depth-0 only (the direct scrollable child), which avoids
  /// accidentally triggering pull-to-refresh from a nested horizontal scroller.
  final bool Function(ScrollNotification)? notificationPredicate;

  /// Vertical offset applied to the top of the pull-to-refresh header.
  ///
  /// Useful when a floating [SliverAppBar] sits above the scrollable, so the
  /// header appears just below the app bar rather than behind it.
  /// Defaults to `0.0`.
  final double edgeOffset;

  const M3EPullToRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.onError,
    this.controller,
    this.indicatorHeight,
    this.triggerDistance,
    this.springMotion,
    this.shapes,
    this.indicatorIcon,
    this.hapticFeedback,
    this.style,
    this.indicatorBuilder,
    this.dragResistance,
    this.maxDragMultiplier,
    this.notificationPredicate,
    this.edgeOffset = 0.0,
  });

  @override
  State<M3EPullToRefreshIndicator> createState() =>
      _M3EPullToRefreshIndicatorState();
}

class _M3EPullToRefreshIndicatorState extends State<M3EPullToRefreshIndicator>
    with SingleTickerProviderStateMixin {
  static const List<Shapes> _defaultShapes = [
    Shapes.softBurst,
    Shapes.pentagon,
    Shapes.pill,
    Shapes.arch,
    Shapes.c6SidedCookie,
  ];

  late final SingleMotionController _motionCtrl;

  double _rawDistancePulled = 0.0;
  double _dragOffset = 0.0;
  bool _isRefreshing = false;
  bool _isDragging = false;
  bool _hasTriggeredHaptic = false;

  bool _isAnimating = false;

  double get _effectiveTriggerDistance =>
      widget.triggerDistance ?? widget.style?.triggerDistance ?? 80.0;

  double get _effectiveIndicatorHeight =>
      widget.indicatorHeight ?? widget.style?.indicatorHeight ?? 70.0;

  M3EMotion get _effectiveSpringMotion =>
      widget.springMotion ??
      widget.style?.springMotion ??
      M3EMotion.expressiveSpatialDefault;

  M3EHapticFeedback get _effectiveHapticFeedback =>
      widget.hapticFeedback ??
      widget.style?.hapticFeedback ??
      M3EHapticFeedback.medium;

  double get _effectiveDragResistance =>
      widget.dragResistance ?? widget.style?.dragResistance ?? 0.55;

  double get _effectiveMaxDragMultiplier =>
      widget.maxDragMultiplier ?? widget.style?.maxDragMultiplier ?? 1.8;

  @override
  void initState() {
    super.initState();
    _motionCtrl = SingleMotionController(
      vsync: this,
      motion: _effectiveSpringMotion.toMotion(),
    );
    _motionCtrl.addListener(() {
      if (_isAnimating && mounted) {
        setState(() {
          _dragOffset = _motionCtrl.value;
        });
        _updateControllerState();
      }
    });

    widget.controller?.attach(_startRefresh);
    _updateControllerState();
  }

  @override
  void didUpdateWidget(M3EPullToRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(_startRefresh);
    }
    if (_effectiveSpringMotion != oldWidget.springMotion) {
      _motionCtrl.motion = _effectiveSpringMotion.toMotion();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateControllerState();
      }
    });
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _motionCtrl.dispose();
    super.dispose();
  }

  void _updateControllerState() {
    final double fraction = _effectiveTriggerDistance > 0
        ? (_dragOffset / _effectiveTriggerDistance)
        : 0.0;
    widget.controller?.updateState(
      distanceFraction: fraction,
      isRefreshing: _isRefreshing,
      isAnimating: _isAnimating,
    );
  }

  bool _defaultNotificationPredicate(ScrollNotification notification) {
    return notification.depth == 0;
  }

  void _handleScrollNotification(ScrollNotification notification) {
    final predicate =
        widget.notificationPredicate ?? _defaultNotificationPredicate;
    if (!predicate(notification)) return;

    if (_isRefreshing) return;
    if (notification is ScrollStartNotification) {
      if (notification.metrics.extentBefore == 0 &&
          notification.dragDetails != null) {
        _isDragging = true;
        _hasTriggeredHaptic = false;
      }
    } else if (notification is OverscrollNotification && _isDragging) {
      if (notification.dragDetails == null) {
        _isDragging = false;
        _onDragEnd();
        return;
      }
      if (notification.overscroll < 0) {
        final double rawDelta = -notification.overscroll;
        _updateDragDistance(
          _rawDistancePulled + rawDelta * _effectiveDragResistance,
        );
      }
    } else if (notification is ScrollUpdateNotification && _isDragging) {
      if (notification.dragDetails == null) {
        _isDragging = false;
        _onDragEnd();
        return;
      }
      if (notification.metrics.extentBefore == 0 &&
          notification.scrollDelta != null &&
          notification.scrollDelta! < 0) {
        final double rawDelta = -notification.scrollDelta!;
        _updateDragDistance(
          _rawDistancePulled + rawDelta * _effectiveDragResistance,
        );
      } else if (_rawDistancePulled > 0 &&
          notification.scrollDelta != null &&
          notification.scrollDelta! > 0) {
        final double newDistance = math.max(
          0.0,
          _rawDistancePulled -
              notification.scrollDelta! * _effectiveDragResistance,
        );
        _updateDragDistance(newDistance);
      }
    } else if (notification is ScrollEndNotification && _isDragging) {
      _isDragging = false;
      _onDragEnd();
    }
  }

  double _calculateVerticalOffset(double distancePulled) {
    final double thresholdPx = _effectiveTriggerDistance;
    if (distancePulled <= thresholdPx) {
      return distancePulled;
    }
    final double progress = distancePulled / thresholdPx;
    final double overshootPercent = progress - 1.0;
    final double linearTension = overshootPercent.clamp(0.0, 2.0);
    final double tensionPercent =
        linearTension - (linearTension * linearTension / 4.0);
    final double extraOffset = thresholdPx * tensionPercent;
    return thresholdPx + extraOffset;
  }

  void _updateDragDistance(double newDistance) {
    final double maxRaw =
        _effectiveTriggerDistance * _effectiveMaxDragMultiplier;
    final double clampedDistance = newDistance.clamp(0.0, maxRaw);
    final double offset = _calculateVerticalOffset(clampedDistance);

    setState(() {
      _rawDistancePulled = clampedDistance;
      _dragOffset = offset;
      _isAnimating = false;
      _motionCtrl.value = offset;
    });

    _updateControllerState();

    if (_rawDistancePulled >= _effectiveTriggerDistance &&
        !_hasTriggeredHaptic) {
      _hasTriggeredHaptic = true;
      applyHaptic(_effectiveHapticFeedback);
    } else if (_rawDistancePulled < _effectiveTriggerDistance) {
      _hasTriggeredHaptic = false;
    }
  }

  void _onDragEnd() {
    if (_isRefreshing) return;

    if (_rawDistancePulled >= _effectiveTriggerDistance) {
      _motionCtrl.motion = _effectiveSpringMotion.toMotion();
      _startRefresh();
    } else if (_dragOffset > 0) {
      _motionCtrl.motion = M3EMotion.expressiveEffectsFast.toMotion();
      _isAnimating = true;
      _rawDistancePulled = 0.0;
      _motionCtrl.animateTo(0.0);
    }
  }

  Future<void> _startRefresh() async {
    setState(() {
      _isRefreshing = true;
      _isAnimating = true;
    });

    _updateControllerState();

    _motionCtrl.motion = _effectiveSpringMotion.toMotion();
    _motionCtrl.animateTo(_effectiveIndicatorHeight);

    try {
      await widget.onRefresh();
    } catch (error, stackTrace) {
      widget.onError?.call(error, stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _isAnimating = true;
          _rawDistancePulled = 0.0;
        });
        _motionCtrl.motion = _effectiveSpringMotion.toMotion();
        _motionCtrl.animateTo(0.0);
        _updateControllerState();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;

    final double headerHeight = math.max(0.0, _dragOffset);
    final double progress = _effectiveTriggerDistance > 0
        ? (headerHeight / _effectiveTriggerDistance).clamp(0.0, 2.0)
        : 0.0;

    final double visualProgress;
    if (_isRefreshing) {
      visualProgress = 1.0;
    } else if (_rawDistancePulled > 0) {
      visualProgress = (headerHeight / _effectiveTriggerDistance).clamp(
        0.0,
        1.0,
      );
    } else {
      visualProgress = _effectiveIndicatorHeight > 0
          ? (headerHeight / _effectiveIndicatorHeight).clamp(0.0, 1.0)
          : 0.0;
    }

    Widget headerChild;
    if (widget.indicatorBuilder != null) {
      headerChild = widget.indicatorBuilder!(
        context,
        progress.clamp(0.0, 1.0),
        _isRefreshing,
      );
    } else if (widget.indicatorIcon != null) {
      headerChild = widget.indicatorIcon!;
    } else {
      headerChild = M3EContainedLoadingIndicator(
        shapes: widget.shapes ?? _defaultShapes,
        containerColor: style?.containerColor,
        indicatorColor: style?.indicatorColor,
        width: style?.size ?? 48.0,
        height: style?.size ?? 48.0,
        padding: style?.padding,
        borderRadius: style?.borderRadius,
        progress: _isRefreshing ? null : progress.clamp(0.0, 1.0),
        semanticsLabel: 'Refreshing',
        semanticsValue: _isRefreshing ? 'In progress' : null,
      );
    }

    if (!_isRefreshing && progress > 1.0) {
      final double overshootAngle = -(progress - 1.0) * math.pi;
      headerChild = Transform.rotate(angle: overshootAngle, child: headerChild);
    }

    Widget containerWidget = headerChild;
    if (style?.elevation != null && style!.elevation! > 0) {
      containerWidget = Material(
        elevation: style.elevation!,
        color: Colors.transparent,
        borderRadius: style.borderRadius,
        child: containerWidget,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _handleScrollNotification(notification);
        return false;
      },
      child: Column(
        children: [
          if (widget.edgeOffset > 0) SizedBox(height: widget.edgeOffset),
          if (headerHeight > 0.5)
            SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: ClipRect(
                child: Center(
                  child: OverflowBox(
                    minWidth: 0.0,
                    maxWidth: double.infinity,
                    minHeight: 0.0,
                    maxHeight: double.infinity,
                    child: Opacity(
                      opacity: visualProgress,
                      child: Transform.scale(
                        scale: 0.6 + (0.4 * visualProgress),
                        child: containerWidget,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
