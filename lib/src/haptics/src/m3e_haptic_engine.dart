// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'm3e_haptic_types.dart';

const MethodChannel _hapticChannel = MethodChannel('m3e_haptics/haptics');

/// Helper function to apply haptic feedback based on [M3EHapticFeedback].
void applyHaptic(M3EHapticFeedback haptic) {
  if (haptic == M3EHapticFeedback.none) return;
  final type = switch (haptic) {
    M3EHapticFeedback.light => 'dragTexture',
    M3EHapticFeedback.medium => 'tickCrossing',
    M3EHapticFeedback.heavy => 'bookendUpper',
    M3EHapticFeedback.none => '',
  };
  if (type.isEmpty) return;
  applyTypedHaptic(type, 0.5);
}

/// Dispatch a typed haptic event with a pre-computed [amplitude] (0.0–1.0).
void applyTypedHaptic(String type, double amplitude) {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    _hapticChannel.invokeMethod(
        'vibrate', {'type': type, 'amplitude': amplitude}).catchError((_) {
      _fallbackHapticForType(type);
    });
  } else {
    _fallbackHapticForType(type);
  }
}

void _fallbackHapticForType(String type) {
  switch (type) {
    case 'dragTexture':
    case 'bookendLower':
      HapticFeedback.lightImpact();
    case 'tickCrossing':
      HapticFeedback.mediumImpact();
    case 'bookendUpper':
      HapticFeedback.heavyImpact();
    default:
      HapticFeedback.selectionClick();
  }
}
