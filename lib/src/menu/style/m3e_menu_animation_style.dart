// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

/// The reveal animation used when a menu popup opens and closes.
///
/// The two styles mirror the two reference implementations shipped by
/// Jetpack Compose for Material 3 menus.
enum M3EMenuAnimationStyle {
  /// A 1:1 port of the Jetpack Compose Material 3 menu popup animation.
  ///
  /// The whole surface scales uniformly from
  /// [M3EMenuTokens.closedScaleTarget] to [M3EMenuTokens.expandedScaleTarget]
  /// around the transform origin computed by the menu position provider, so
  /// the menu visually grows out of the edge it is anchored to. Opacity fades
  /// from [M3EMenuTokens.closedAlphaTarget] to
  /// [M3EMenuTokens.expandedAlphaTarget] on the effects spring.
  ///
  /// The spatial spring is allowed to overshoot past its target, which produces
  /// the elastic M3 Expressive pop on open.
  popup,

  /// The vertical reveal used by the M3 Expressive dropdown menu.
  ///
  /// The surface squashes along its Y axis only, from nothing up to its full
  /// height, with the transform origin pinned to the edge nearest the anchor so
  /// the menu unrolls away from the anchor while fading in.
  dropdown,
}
