// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import '../core/m3e_menu_controller.dart';
import '../style/m3e_menu_style.dart';

/// Internal InheritedWidget that provides menu theme, color variant,
/// and controller context to child menu items and groups.
class M3EMenuScope extends InheritedWidget {
  final M3EMenuColorSchemeVariant colorSchemeVariant;
  final M3EMenuStyle style;
  final M3EMenuController controller;

  const M3EMenuScope({
    super.key,
    required this.colorSchemeVariant,
    required this.style,
    required this.controller,
    required super.child,
  });

  static M3EMenuScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3EMenuScope>();
  }

  static M3EMenuScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No M3EMenuScope found in context.');
    return scope!;
  }

  bool get isVibrant => colorSchemeVariant == M3EMenuColorSchemeVariant.vibrant;

  /// Whether the menu is currently open (not mid-close-animation).
  ///
  /// Used by item tap handlers to prevent double-firing during the close
  /// animation, when the overlay is still mounted and hit-testable.
  bool get isActive => controller.isOpen;

  @override
  bool updateShouldNotify(M3EMenuScope oldWidget) {
    return colorSchemeVariant != oldWidget.colorSchemeVariant ||
        style != oldWidget.style ||
        controller != oldWidget.controller;
  }
}

/// Internal InheritedWidget that passes group index and total count
/// down to child items so they can determine their shape morphing
/// (leading, middle, trailing, or standalone).
class M3EMenuGroupScope extends InheritedWidget {
  final int index;
  final int count;

  const M3EMenuGroupScope({
    super.key,
    required this.index,
    required this.count,
    required super.child,
  });

  static M3EMenuGroupScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3EMenuGroupScope>();
  }

  @override
  bool updateShouldNotify(M3EMenuGroupScope oldWidget) {
    return index != oldWidget.index || count != oldWidget.count;
  }
}
