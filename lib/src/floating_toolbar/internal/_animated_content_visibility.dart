// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';
import '../../common/m3e_common.dart';

class AnimatedContentVisibility extends StatefulWidget {
  final bool visible;
  final bool isVertical;
  final Widget child;
  final M3EMotion sizeMotion;
  final M3EMotion opacityMotion;

  const AnimatedContentVisibility({
    super.key,
    required this.visible,
    required this.isVertical,
    required this.child,
    this.sizeMotion = M3EMotion.expressiveSpatialFast,
    this.opacityMotion = M3EMotion.standardEffectsFast,
  });

  @override
  State<AnimatedContentVisibility> createState() =>
      _AnimatedContentVisibilityState();
}

class _AnimatedContentVisibilityState extends State<AnimatedContentVisibility>
    with TickerProviderStateMixin {
  late final SingleMotionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SingleMotionController(
      motion: widget.sizeMotion.toMotion(),
      vsync: this,
      initialValue: widget.visible ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedContentVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      _controller.motion = widget.visible
          ? widget.sizeMotion.toMotion()
          : widget.opacityMotion.toMotion();
      _controller.animateTo(widget.visible ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;
        if (!widget.visible && !_controller.isAnimating && value < 0.01) {
          return const SizedBox.shrink();
        }

        return SizeTransition(
          sizeFactor: _controller,
          axis: widget.isVertical ? Axis.vertical : Axis.horizontal,
          alignment: Alignment.center,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: widget.child),
        );
      },
    );
  }
}
