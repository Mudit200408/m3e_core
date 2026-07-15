// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import 'm3e_haptic_tracker.dart';

/// Wraps any progress-driven widget and dispatches haptics as [progress]
/// changes.
///
/// This keeps pointer tracking and haptic lifecycle code out of individual
/// widgets while remaining generic enough for sliders, swipe actions, loaders,
/// and custom controls.
class M3EHapticListener extends StatefulWidget {
  final Widget child;
  final M3EHapticTracker tracker;
  final double progress;
  final bool enabled;
  final bool listenToPointer;
  final bool updateOnPointerMove;
  final bool updateOnProgressChange;

  const M3EHapticListener({
    super.key,
    required this.child,
    required this.tracker,
    required this.progress,
    this.enabled = true,
    this.listenToPointer = true,
    this.updateOnPointerMove = false,
    this.updateOnProgressChange = true,
  });

  @override
  State<M3EHapticListener> createState() => _M3EHapticListenerState();
}

class _M3EHapticListenerState extends State<M3EHapticListener> {
  Offset _lastGlobalPosition = Offset.zero;
  bool _hasStarted = false;

  @override
  void didUpdateWidget(M3EHapticListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tracker != widget.tracker || !widget.enabled) {
      _hasStarted = false;
    }

    if (!widget.enabled ||
        !widget.updateOnProgressChange ||
        oldWidget.progress == widget.progress) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.enabled) return;
      _update(widget.progress, _lastGlobalPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.listenToPointer) return widget.child;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _lastGlobalPosition = event.position;
        _start(widget.progress, event.position);
      },
      onPointerMove: (event) {
        _lastGlobalPosition = event.position;
        if (widget.updateOnPointerMove) {
          _update(widget.progress, event.position);
        }
      },
      child: widget.child,
    );
  }

  void _start(double progress, Offset position) {
    if (!widget.enabled) return;
    widget.tracker.start(progress.clamp(0.0, 1.0), position);
    _hasStarted = true;
  }

  void _update(double progress, Offset position) {
    if (!widget.enabled) return;
    if (!_hasStarted) {
      _start(progress, position);
    }
    widget.tracker.update(progress.clamp(0.0, 1.0), position);
  }
}
