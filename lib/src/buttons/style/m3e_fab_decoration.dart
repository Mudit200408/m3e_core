// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../../common/m3e_common.dart';

/// Styling overrides for [M3EFab] and [M3EExtendedFab].
@immutable
class M3EFabDecoration {
  const M3EFabDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.side,
    this.pressedScale,
    this.motion,
  });

  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? foregroundColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<BorderSide?>? side;
  final double? pressedScale;

  /// Custom spring motion for the press/scale physics.
  final M3EMotion? motion;

  M3EFabDecoration copyWith({
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? foregroundColor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<BorderSide?>? side,
    double? pressedScale,
    M3EMotion? motion,
  }) {
    return M3EFabDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      side: side ?? this.side,
      pressedScale: pressedScale ?? this.pressedScale,
      motion: motion ?? this.motion,
    );
  }
}
