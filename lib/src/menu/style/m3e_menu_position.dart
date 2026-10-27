// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

/// Where a popup menu is placed relative to its anchor.
///
/// Mirrors Flutter's `PopupMenuPosition`, with the M3 Expressive default of
/// [M3EMenuPosition.under].
enum M3EMenuPosition {
  /// The menu is centred on the anchor, appearing directly over it.
  ///
  /// The transform origin resolves to the anchor/menu overlap centre, so the
  /// menu scales out from the anchor's centre.
  over,

  /// The menu is placed below the anchor, flipping above it when the space
  /// below the anchor is insufficient.
  under,
}
