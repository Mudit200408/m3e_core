// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';
import '../common/m3e_common.dart';
import 'm3e_floating_toolbar_theme.dart';

/// Directions in which a floating toolbar can exit the screen.
enum M3EFloatingToolbarExitDirection {
  /// Exit by moving upwards.
  top,

  /// Exit by moving downwards.
  bottom,

  /// Exit by moving towards the start (left in LTR).
  start,

  /// Exit by moving towards the end (right in LTR).
  end,
}

/// The state of a floating toolbar, tracking its scroll offsets.
class M3EFloatingToolbarState extends ChangeNotifier {
  double _offsetLimit = 0.0;
  double _offset = 0.0;
  double _contentOffset = 0.0;

  M3EFloatingToolbarState();

  /// Factory constructor to instantiate a new [M3EFloatingToolbarState] with zero values.
  factory M3EFloatingToolbarState.create() => M3EFloatingToolbarState();

  /// The maximum negative translation offset (in pixels) for the exit animation.
  /// Should always be less than or equal to 0.
  double get offsetLimit => _offsetLimit;
  set offsetLimit(double value) {
    if (_offsetLimit == value) return;
    _offsetLimit = value;
    // Force coercion of current offset within new bounds
    offset = _offset;
    notifyListeners();
  }

  /// The current translation offset of the toolbar (in pixels).
  /// Coerced within `[offsetLimit, 0.0]`.
  double get offset => _offset;
  set offset(double value) {
    final double coerced = _offsetLimit <= 0.0
        ? value.clamp(_offsetLimit, 0.0)
        : value.clamp(0.0, _offsetLimit);
    if (_offset == coerced) return;
    _offset = coerced;
    notifyListeners();
  }

  /// The accumulated scroll distance consumed by the nested scroll system.
  double get contentOffset => _contentOffset;
  set contentOffset(double value) {
    if (_contentOffset == value) return;
    _contentOffset = value;
    notifyListeners();
  }

  /// Fraction of the toolbar that is collapsed (0.0 = fully visible, 1.0 = fully hidden).
  double get collapsedFraction {
    if (_offsetLimit == 0.0) return 0.0;
    return _offset / _offsetLimit;
  }
}

/// Integrates scroll events with the [M3EFloatingToolbarState].
class M3EFloatingToolbarScrollBehavior {
  /// The direction in which the toolbar exits the screen.
  final M3EFloatingToolbarExitDirection exitDirection;

  /// The scroll state tracked by this behavior.
  final M3EFloatingToolbarState state;

  /// The motion configuration for the exit/settle animation.
  final M3EMotion motion;

  M3EFloatingToolbarScrollBehavior({
    required this.exitDirection,
    required this.state,
    this.motion = M3EMotion.expressiveSpatialFast,
  });

  /// Creates a default scroll behavior that exits the toolbar when scrolling.
  factory M3EFloatingToolbarScrollBehavior.exitAlways({
    required M3EFloatingToolbarExitDirection exitDirection,
    M3EFloatingToolbarState? state,
    M3EMotion motion = M3EMotion.expressiveSpatialFast,
  }) {
    return M3EFloatingToolbarScrollBehavior(
      exitDirection: exitDirection,
      state: state ?? M3EFloatingToolbarState.create(),
      motion: motion,
    );
  }
}

/// A wrapper widget that listens to scroll notifications on its [child] scrollable and
/// updates the associated [behavior]'s state to slide the toolbar off-screen.
class M3EFloatingToolbarScrollWrapper extends StatefulWidget {
  /// The scroll behavior to update.
  final M3EFloatingToolbarScrollBehavior behavior;

  /// The scrollable widget (e.g. ListView, SingleChildScrollView) to monitor.
  final Widget child;

  const M3EFloatingToolbarScrollWrapper({
    super.key,
    required this.behavior,
    required this.child,
  });

  @override
  State<M3EFloatingToolbarScrollWrapper> createState() =>
      _M3EFloatingToolbarScrollWrapperState();
}

class _M3EFloatingToolbarScrollWrapperState
    extends State<M3EFloatingToolbarScrollWrapper>
    with TickerProviderStateMixin {
  SingleMotionController? _settleController;

  @override
  void dispose() {
    _settleController?.dispose();
    super.dispose();
  }

  void _updateOffset(double delta) {
    final state = widget.behavior.state;
    state.contentOffset += delta;
    state.offset -= delta;
  }

  void _settle(double velocity) {
    _settleController?.dispose();

    final state = widget.behavior.state;
    if (state.offset == 0.0 || state.offset == state.offsetLimit) {
      return;
    }

    double target;
    // velocity direction in Flutter:
    // velocity > 0: scrolling down / forward (collapse)
    // velocity < 0: scrolling up / backward (expand)
    if (velocity.abs() > 150.0) {
      target = velocity > 0 ? state.offsetLimit : 0.0;
    } else {
      target = state.collapsedFraction < 0.5 ? 0.0 : state.offsetLimit;
    }

    _settleController =
        SingleMotionController(
            motion: widget.behavior.motion.toMotion(),
            vsync: this,
            initialValue: state.offset,
          )
          ..addListener(() {
            if (mounted) {
              state.offset = _settleController!.value;
            }
          })
          ..animateTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          _settleController?.dispose();
          _settleController = null;
        } else if (notification is ScrollUpdateNotification) {
          if (_settleController == null) {
            final double delta = notification.scrollDelta ?? 0.0;
            if (delta != 0.0) {
              _updateOffset(delta);
            }
          }
        } else if (notification is ScrollEndNotification) {
          double velocity = 0.0;
          if (notification.dragDetails != null) {
            velocity = notification.dragDetails!.primaryVelocity ?? 0.0;
          }
          _settle(velocity);
        }
        return false;
      },
      child: widget.child,
    );
  }
}

/// A wrapper widget that monitors scrolling and implements a simple expand/collapse
/// threshold logic (typically used with vertical toolbars).
class M3EFloatingToolbarVerticalNestedScroll extends StatefulWidget {
  /// Whether the toolbar should currently be expanded.
  final bool expanded;

  /// Callback fired when the scroll distance threshold is crossed scrolling up.
  final VoidCallback onExpand;

  /// Callback fired when the scroll distance threshold is crossed scrolling down.
  final VoidCallback onCollapse;

  /// Distance threshold in dp to trigger expansion.
  final double expandScrollDistanceThreshold;

  /// Distance threshold in dp to trigger collapse.
  final double collapseScrollDistanceThreshold;

  /// Whether the scroll view layout is reversed.
  final bool reverseLayout;

  /// The scrollable child.
  final Widget child;

  const M3EFloatingToolbarVerticalNestedScroll({
    super.key,
    required this.expanded,
    required this.onExpand,
    required this.onCollapse,
    this.expandScrollDistanceThreshold =
        M3EFloatingToolbarDefaults.scrollDistanceThreshold,
    this.collapseScrollDistanceThreshold =
        M3EFloatingToolbarDefaults.scrollDistanceThreshold,
    this.reverseLayout = false,
    required this.child,
  });

  @override
  State<M3EFloatingToolbarVerticalNestedScroll> createState() =>
      _M3EFloatingToolbarVerticalNestedScrollState();
}

class _M3EFloatingToolbarVerticalNestedScrollState
    extends State<M3EFloatingToolbarVerticalNestedScroll> {
  double _accumulatedScroll = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          final double delta = notification.scrollDelta ?? 0.0;
          if (delta == 0.0) return false;

          final double adjustedDelta = widget.reverseLayout ? -delta : delta;

          if (adjustedDelta > 0) {
            // Scrolling down (collapsing direction)
            if (_accumulatedScroll < 0) {
              _accumulatedScroll = 0.0;
            }
            _accumulatedScroll += adjustedDelta;
            if (_accumulatedScroll >= widget.collapseScrollDistanceThreshold) {
              if (widget.expanded) {
                widget.onCollapse();
              }
              _accumulatedScroll = 0.0;
            }
          } else {
            // Scrolling up (expanding direction)
            if (_accumulatedScroll > 0) {
              _accumulatedScroll = 0.0;
            }
            _accumulatedScroll += adjustedDelta;
            if (_accumulatedScroll.abs() >=
                widget.expandScrollDistanceThreshold) {
              if (!widget.expanded) {
                widget.onExpand();
              }
              _accumulatedScroll = 0.0;
            }
          }
        }
        return false;
      },
      child: widget.child,
    );
  }
}
