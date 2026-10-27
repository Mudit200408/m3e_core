// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

/// Carries popup-menu selection callbacks down to [M3EPopupMenuEntry]
/// descendants of an [M3EPopupMenuButton].
class M3EPopupMenuScope extends InheritedWidget {
  /// Called when an entry with a value is activated.
  ///
  /// The value is the activating entry's `value`, which may be null.
  final void Function(Object? value) onSelected;

  const M3EPopupMenuScope({
    super.key,
    required this.onSelected,
    required super.child,
  });

  /// Returns the enclosing popup menu scope, or null when the entry is used
  /// outside a popup menu.
  static M3EPopupMenuScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3EPopupMenuScope>();
  }

  @override
  bool updateShouldNotify(M3EPopupMenuScope oldWidget) {
    return onSelected != oldWidget.onSelected;
  }
}
