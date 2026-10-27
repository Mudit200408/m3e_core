// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

/// A controller used to manage the state of an [M3EMenuAnchor] or submenu.
///
/// Provides a drop-in replacement for Flutter's [MenuController].
class M3EMenuController extends ChangeNotifier {
  bool _isOpen = false;
  Offset? _anchorPosition;

  /// Internal reference to close callbacks or child controllers.
  VoidCallback? _openCallback;
  VoidCallback? _closeCallback;

  M3EMenuController? _parent;
  final Set<M3EMenuController> _children = <M3EMenuController>{};

  /// Whether the menu is currently visible and open.
  bool get isOpen => _isOpen;

  /// Optional custom position offset provided when opened.
  Offset? get anchorPosition => _anchorPosition;

  /// Registers [parent] as this controller's parent menu controller.
  void attachParent(M3EMenuController parent) {
    if (_parent == parent) return;
    _parent?._children.remove(this);
    _parent = parent;
    parent._children.add(this);
  }

  /// Detaches from the current parent menu controller.
  void detachParent() {
    _parent?._children.remove(this);
    _parent = null;
  }

  /// Closes all open child submenus belonging to this controller.
  void closeChildren() {
    for (final child in _children.toList()) {
      if (child._isOpen) {
        child.close();
      }
    }
  }

  /// Closes this menu and all ancestor menus up to the root.
  void closeAll() {
    M3EMenuController? root = this;
    while (root?._parent != null) {
      root = root!._parent;
    }
    root?.close();
  }

  /// Opens the menu.
  ///
  /// If [position] is supplied, the menu will anchor relative to that position.
  void open({Offset? position}) {
    if (_isOpen && _anchorPosition == position) return;
    _isOpen = true;
    _anchorPosition = position;

    // A menu level can have at most ONE open child submenu at any time.
    // Close any other sibling submenus!
    if (_parent != null) {
      for (final sibling in _parent!._children.toList()) {
        if (sibling != this && sibling._isOpen) {
          sibling.close();
        }
      }
    }

    _openCallback?.call();
    notifyListeners();
  }

  /// Closes the menu.
  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    _anchorPosition = null;

    // When this controller closes, close all child submenus recursively
    closeChildren();

    _closeCallback?.call();
    notifyListeners();
  }

  /// Toggles the menu between open and closed.
  void toggle({Offset? position}) {
    if (_isOpen) {
      close();
    } else {
      open(position: position);
    }
  }

  /// Internal registration for the host anchor.
  void attach({required VoidCallback onOpen, required VoidCallback onClose}) {
    _openCallback = onOpen;
    _closeCallback = onClose;
  }

  /// Internal unregistration.
  ///
  /// Resets [isOpen] silently so that an external controller that outlives its
  /// anchor does not stay stuck in the open state.
  void detach() {
    _openCallback = null;
    _closeCallback = null;
    resetSilently();
    detachParent();
  }

  /// Resets [isOpen] and [anchorPosition] without firing callbacks or
  /// notifying listeners. Called when the host overlay is removed without
  /// going through the normal close path (e.g. anchor disposed while open).
  void resetSilently() {
    _isOpen = false;
    _anchorPosition = null;
  }

  /// Whether any direct child controller is currently open.
  bool get hasOpenChildren => _children.any((c) => c._isOpen);

  @override
  void dispose() {
    detachParent();
    _children.clear();
    super.dispose();
  }
}
