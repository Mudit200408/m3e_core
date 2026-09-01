// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:m3e_core/m3e_core.dart';

/// Common motion presets used across M3E playground tabs.
enum M3EExampleMotionPreset {
  standardSpatialDefault(
    'Standard Spatial Default',
    M3EMotion.standardSpatialDefault,
  ),
  standardSpatialFast('Standard Spatial Fast', M3EMotion.standardSpatialFast),
  standardSpatialSlow('Standard Spatial Slow', M3EMotion.standardSpatialSlow),
  expressiveSpatialDefault(
    'Expressive Spatial Default',
    M3EMotion.expressiveSpatialDefault,
  ),
  expressiveSpatialFast(
    'Expressive Spatial Fast',
    M3EMotion.expressiveSpatialFast,
  ),
  expressiveSpatialSlow(
    'Expressive Spatial Slow',
    M3EMotion.expressiveSpatialSlow,
  ),
  standardEffectsFast('Standard Effects Fast', M3EMotion.standardEffectsFast),
  expressiveEffectsFast(
    'Expressive Effects Fast',
    M3EMotion.expressiveEffectsFast,
  ),
  custom('Custom (Stiffness & Damping)', null);

  final String label;
  final M3EMotion? motion;
  const M3EExampleMotionPreset(this.label, this.motion);

  /// Resolves the effective [M3EMotion] given custom stiffness and damping fallbacks.
  M3EMotion resolve({required double stiffness, required double damping}) {
    if (this == M3EExampleMotionPreset.custom) {
      return M3EMotion.custom(stiffness: stiffness, damping: damping);
    }
    return motion ?? M3EMotion.standardSpatialDefault;
  }
}
