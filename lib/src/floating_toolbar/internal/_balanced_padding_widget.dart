// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';
import '../../common/m3e_common.dart';

class BalancedPaddingWidget extends StatefulWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final bool expanded;
  final bool isVertical;
  final Widget child;
  final M3EMotion motion;

  const BalancedPaddingWidget({
    super.key,
    required this.hasLeading,
    required this.hasTrailing,
    required this.expanded,
    required this.isVertical,
    required this.child,
    this.motion = M3EMotion.expressiveSpatialFast,
  });

  @override
  State<BalancedPaddingWidget> createState() => _BalancedPaddingWidgetState();
}

class _BalancedPaddingWidgetState extends State<BalancedPaddingWidget>
    with TickerProviderStateMixin {
  late final SingleMotionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SingleMotionController(
      motion: widget.motion.toMotion(),
      vsync: this,
      initialValue: widget.expanded ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant BalancedPaddingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.motion != oldWidget.motion) {
      _controller.motion = widget.motion.toMotion();
    }
    if (widget.expanded != oldWidget.expanded) {
      _controller.animateTo(widget.expanded ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasLeading == widget.hasTrailing) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = _controller.value;
        final double paddingVal = progress * 48.0;

        final EdgeInsets padding;
        if (widget.isVertical) {
          padding = widget.hasLeading
              ? EdgeInsets.only(bottom: paddingVal)
              : EdgeInsets.only(top: paddingVal);
        } else {
          final bool isRtl = Directionality.of(context) == TextDirection.rtl;
          if (widget.hasLeading) {
            padding = isRtl
                ? EdgeInsets.only(left: paddingVal)
                : EdgeInsets.only(right: paddingVal);
          } else {
            padding = isRtl
                ? EdgeInsets.only(right: paddingVal)
                : EdgeInsets.only(left: paddingVal);
          }
        }

        return Padding(padding: padding, child: widget.child);
      },
    );
  }
}
