import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';

/// Haptic feedback intensity levels for Material 3 Expressive components.
///
/// ## Levels
/// - [none] — No haptic feedback (default)
/// - [light] — Light tap feedback for subtle interactions
/// - [medium] — Medium impact for standard button presses
/// - [heavy] — Heavy impact for significant actions
enum M3EHapticFeedback {
  /// No haptic feedback.
  none(0),

  /// Light tap feedback.
  light(1),

  /// Medium impact feedback.
  medium(2),

  /// Heavy impact feedback.
  heavy(3);

  final int value;
  const M3EHapticFeedback(this.value);

  /// Helper function to apply haptic feedback based on [M3EHapticFeedback].
  void apply() {
    applyHaptic(this);
  }
}

/// Helper function to apply haptic feedback based on [M3EHapticFeedback].
void applyHaptic(M3EHapticFeedback haptic) {
  switch (haptic) {
    case M3EHapticFeedback.light:
      HapticFeedback.lightImpact();
      break;
    case M3EHapticFeedback.medium:
      HapticFeedback.mediumImpact();
      break;
    case M3EHapticFeedback.heavy:
      HapticFeedback.heavyImpact();
      break;
    case M3EHapticFeedback.none:
      break;
  }
}

/// Spring animation configuration for Material 3 Expressive components.
///
/// Use to customize the spring physics for component animations.
///
/// ## Motion Presets
///
/// The class provides two families of presets:
/// - **Spatial** motions: animate shapes (like border radius)
/// - **Effects** motions: animate opacity/scale effects
///
/// Each family has three speed variants:
/// - **Fast**: Snappy, responsive animations
/// - **Default**: Balanced feel
/// - **Slow**: More relaxed, dramatic animations
///
/// ## Custom Motion
///
/// Use [M3EMotion.custom] to create a custom spring with specific physics:
/// ```dart
/// M3EMotion.custom(1600, 0.85)
/// ```
@immutable
class M3EMotion {
  const M3EMotion._({
    required this.stiffness,
    required this.damping,
    this.snapToEnd = false,
  });

  /// Fast spatial motion (stiffness: 1400, damping: 0.9).
  ///
  /// Snappy spring for responsive feel.
  static const M3EMotion standardSpatialFast = M3EMotion._(
    stiffness: 1400,
    damping: 0.9,
    snapToEnd: false,
  );

  /// Default spatial motion (stiffness: 700, damping: 0.9).
  static const M3EMotion standardSpatialDefault = M3EMotion._(
    stiffness: 700,
    damping: 0.9,
  );

  /// Slow spatial motion (stiffness: 300, damping: 0.9).
  ///
  /// Relaxed spring for dramatic feel.
  static const M3EMotion standardSpatialSlow = M3EMotion._(
    stiffness: 300,
    damping: 0.9,
  );

  /// Fast expressive spatial motion (stiffness: 800, damping: 0.6).
  ///
  /// Bouncier spring for expressive feel.
  static const M3EMotion expressiveSpatialFast = M3EMotion._(
    stiffness: 800,
    damping: 0.6,
  );

  /// Default expressive spatial motion (stiffness: 380, damping: 0.8).
  ///
  /// Bouncy, balanced spring for expressive feel.
  static const M3EMotion expressiveSpatialDefault = M3EMotion._(
    stiffness: 380,
    damping: 0.8,
  );

  /// Slow expressive spatial motion (stiffness: 200, damping: 0.8).
  ///
  /// Very bouncy spring for dramatic expressive feel.
  static const M3EMotion expressiveSpatialSlow = M3EMotion._(
    stiffness: 200,
    damping: 0.8,
  );

  /// Fast effects motion (stiffness: 3800, damping: 1).
  ///
  /// Snappy effect animation.
  static const M3EMotion standardEffectsFast = M3EMotion._(
    stiffness: 3800,
    damping: 1,
  );

  /// Default effects motion (stiffness: 1600, damping: 1).
  ///
  /// Balanced effect animation.
  static const M3EMotion standardEffectsDefault = M3EMotion._(
    stiffness: 1600,
    damping: 1,
  );

  /// Slow effects motion (stiffness: 800, damping: 1).
  ///
  /// Relaxed effect animation.
  static const M3EMotion standardEffectsSlow = M3EMotion._(
    stiffness: 800,
    damping: 1,
  );

  /// Fast expressive effects motion (stiffness: 3800, damping: 1).
  ///
  /// Snappy expressive effect animation.
  static const M3EMotion expressiveEffectsFast = M3EMotion._(
    stiffness: 3800,
    damping: 1,
  );

  /// Default expressive effects motion (stiffness: 1600, damping: 1).
  ///
  /// Balanced expressive effect animation.
  static const M3EMotion expressiveEffectsDefault = M3EMotion._(
    stiffness: 1600,
    damping: 1,
  );

  /// Slow expressive effects motion (stiffness: 800, damping: 1).
  ///
  /// Relaxed expressive effect animation.
  static const M3EMotion expressiveEffectsSlow = M3EMotion._(
    stiffness: 800,
    damping: 1,
  );

  /// Standard overflow animation (stiffness: 1600, damping: 0.85).
  ///
  /// Spring animation for overflow menus and popups.
  static const M3EMotion standardOverflow = M3EMotion._(
    stiffness: 1600,
    damping: 0.85,
  );

  /// Standard popup animation (stiffness: 1000, damping: 0.6).
  ///
  /// Bouncy spring for popup menus.
  static const M3EMotion standardPopup = M3EMotion._(
    stiffness: 1000,
    damping: 0.6,
  );

  /// Creates a custom spring motion with the specified physics.
  ///
  /// [stiffness] controls how fast the spring bounces (higher = faster).
  /// [damping] controls how quickly oscillations settle (0.7-1.0 recommended).
  const M3EMotion.custom({required this.stiffness, required this.damping})
    : snapToEnd = false;

  /// Spring stiffness. Higher values make the spring snappier.
  final double stiffness;

  /// Spring damping. Values closer to 1 make the spring less bouncy.
  final double damping;

  /// Whether the spring should snap to the end position.
  final bool snapToEnd;

  /// Converts this [M3EMotion] to a [SpringMotion] for animation use.
  SpringMotion toMotion() => MaterialSpringMotion.expressiveEffectsFast()
      .copyWith(stiffness: stiffness, damping: damping, snapToEnd: snapToEnd);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EMotion &&
          stiffness == other.stiffness &&
          damping == other.damping &&
          snapToEnd == other.snapToEnd;

  @override
  int get hashCode => Object.hash(stiffness, damping, snapToEnd);
}
