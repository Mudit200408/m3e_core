// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';
import '../../common/m3e_common.dart';

class BalancedPaddingWidget extends StatelessWidget {
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
  Widget build(BuildContext context) => child;
}
