// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'm3e_haptic_engine.dart';

/// Haptic feedback intensity levels.
enum M3EHapticFeedback {
  none(0),
  light(1),
  medium(2),
  heavy(3);

  final int value;
  const M3EHapticFeedback(this.value);

  /// Helper function to apply haptic feedback based on level.
  void apply() {
    applyHaptic(this);
  }
}
