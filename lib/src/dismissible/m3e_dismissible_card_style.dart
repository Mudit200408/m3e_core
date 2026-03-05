import 'package:flutter/material.dart';

/// Immutable visual and interaction configuration for dismissible M3E cards.
///
/// Encapsulates all styling, animation tuning, and interaction parameters
/// so they can be shared across the three wrapper variants
/// ([M3EDismissibleCardColumn], [M3EDismissibleCardList],
/// [SliverM3EDismissibleCardList]).
class M3EDismissibleCardStyle {
  // ── Visual ──

  /// Outer corner radius for first / last / single items.
  final double outerRadius;

  /// Border radius applied to the dragged card once it crosses the dismiss
  /// threshold. Defaults to [outerRadius].
  final double? selectedBorderRadius;

  /// Inner corner radius for middle items.
  final double innerRadius;

  /// Vertical gap between cards.
  final double gap;

  /// Card background colour (defaults to [ColorScheme.surfaceContainerHighest]).
  final Color? color;

  /// Inner padding of each card's content area.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around each card.
  final EdgeInsetsGeometry? margin;

  /// Optional border drawn on every card.
  final BorderSide? border;

  /// Resting elevation.
  final double elevation;

  // ── Swipe backgrounds ──

  /// Background revealed when swiping start‑to‑end (left→right in LTR).
  final Widget? background;

  /// Background revealed when swiping end‑to‑start (right→left in LTR).
  /// Falls back to [background] if null.
  final Widget? secondaryBackground;

  /// Background Border Radius
  final double backgroundBorderRadius;

  /// Secondary Background Border Radius
  final double? secondaryBackgroundBorderRadius;

  /// Background And Secondary Background Collapse speed
  /// The speed becomes faster when the user swipes faster
  ///
  /// Higher Number = Faster Collapse
  /// Lower Number = Slower Collapse
  ///
  /// Defaults to `50` for that slower Gmail type collapse
  final double collapseSpeed;

  // ── Interaction ──

  final Color? splashColor;
  final Color? highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures provide acoustic / haptic feedback.
  final bool enableFeedback;

  /// Haptic intensity on tap: 0 = none, 1 = light, 2 = medium, 3 = heavy.
  final int hapticOnTap;

  /// Fraction of card width the user must drag before a dismiss triggers.
  final double dismissThreshold;

  /// Haptic intensity when the drag crosses / re‑crosses: 0 = none, 1 = light, 2 = medium, 3 = heavy.
  ///
  /// Defaults to `1`.
  final int hapticOnThreshold;

  /// Fire continuous light haptics during the drag.
  ///
  /// Defaults to `false`.
  ///
  /// Try it out once!!
  /// It's just me or it's super satisfying to use?
  final bool dismissHapticStream;

  // ── Neighbour physics ──

  /// Maximum pixel offset applied to neighbouring cards.
  final double neighbourPull;

  /// How many cards (above + below the dragged card) are affected.
  final int neighbourReach;

  /// Spring stiffness for neighbour snapping.
  final double neighbourStiffness;

  /// Spring damping for neighbour snapping.
  final double neighbourDamping;

  const M3EDismissibleCardStyle({
    this.outerRadius = 18.0,
    this.selectedBorderRadius,
    this.innerRadius = 4.0,
    this.gap = 3.0,
    this.color,
    this.padding,
    this.margin,
    this.border,
    this.elevation = 0.0,
    this.background,
    this.secondaryBackground,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.hapticOnTap = 0,
    this.dismissThreshold = 0.2,
    this.hapticOnThreshold = 1,
    this.dismissHapticStream = false,
    this.neighbourPull = 8.0,
    this.neighbourReach = 3,
    this.neighbourStiffness = 800,
    this.neighbourDamping = 0.7,
    this.backgroundBorderRadius = 100,
    this.secondaryBackgroundBorderRadius = 100,
    this.collapseSpeed = 50,
  });

  /// Creates a copy with the given fields replaced.
  M3EDismissibleCardStyle copyWith({
    double? outerRadius,
    double? selectedBorderRadius,
    double? innerRadius,
    double? gap,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderSide? border,
    double? elevation,
    Widget? background,
    Widget? secondaryBackground,
    Color? splashColor,
    Color? highlightColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool? enableFeedback,
    int? hapticOnTap,
    double? dismissThreshold,
    int? hapticOnThreshold,
    bool? dismissHapticStream,
    double? neighbourPull,
    int? neighbourReach,
    double? neighbourStiffness,
    double? neighbourDamping,
    double? backgroundBorderRadius,
    double? secondaryBackgroundBorderRadius,
    double? collapseSpeed,
  }) {
    return M3EDismissibleCardStyle(
      outerRadius: outerRadius ?? this.outerRadius,
      selectedBorderRadius: selectedBorderRadius ?? this.selectedBorderRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      color: color ?? this.color,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      border: border ?? this.border,
      elevation: elevation ?? this.elevation,
      background: background ?? this.background,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      splashFactory: splashFactory ?? this.splashFactory,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      hapticOnTap: hapticOnTap ?? this.hapticOnTap,
      dismissThreshold: dismissThreshold ?? this.dismissThreshold,
      hapticOnThreshold: hapticOnThreshold ?? this.hapticOnThreshold,
      dismissHapticStream: dismissHapticStream ?? this.dismissHapticStream,
      neighbourPull: neighbourPull ?? this.neighbourPull,
      neighbourReach: neighbourReach ?? this.neighbourReach,
      neighbourStiffness: neighbourStiffness ?? this.neighbourStiffness,
      neighbourDamping: neighbourDamping ?? this.neighbourDamping,
      backgroundBorderRadius:
          backgroundBorderRadius ?? this.backgroundBorderRadius,
      secondaryBackgroundBorderRadius:
          secondaryBackgroundBorderRadius ??
          this.secondaryBackgroundBorderRadius,
      collapseSpeed: collapseSpeed ?? this.collapseSpeed,
    );
  }
}
