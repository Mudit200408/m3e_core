// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../../buttons/button.dart';
import '../core/m3e_menu_controller.dart';
import '../internal/_popup_menu_scope.dart';
import '../style/m3e_menu_style.dart';
import 'm3e_menu_anchor.dart';
import 'm3e_popup_menu_entry.dart';

/// A Material 3 Expressive popup menu button.
///
/// Drop-in replacement for Flutter's `PopupMenuButton`, built on top of
/// [M3EMenuAnchor] so the popup is presented with M3 Expressive spring physics,
/// segmented groups and cascading submenus.
///
/// ## API mapping against Flutter's `PopupMenuButton`
///
/// Visual container properties are **not** redeclared here. They live on
/// [M3EMenuStyle], mirroring how `M3EMenuAnchor` retypes Flutter's `MenuStyle`
/// to `M3EMenuStyle`:
///
/// | `PopupMenuButton` | `M3EPopupMenuButton` |
/// |---|---|
/// | `elevation` | `style.elevation` |
/// | `color` | `style.backgroundColor` |
/// | `shape` | `style.shape` |
/// | `shadowColor` | `style.shadowColor` |
/// | `surfaceTintColor` | `style.surfaceTintColor` |
/// | `menuPadding` | `style.padding` |
/// | `constraints` | `style.minWidth` / `style.maxWidth` |
/// | `position` | `style.position` ([M3EMenuPosition]) |
///
/// The following Flutter parameters are intentionally not accepted:
/// `useRootNavigator` (the anchor resolves the nearest overlay, as
/// `MenuAnchor` does not expose `useRootOverlay` either), `routeSettings` and
/// `popUpAnimationStyle` (motion is spring-driven and not curve-driven), and
/// `padding` / `splashRadius` / `style: ButtonStyle?` (the trigger is an
/// [M3EButton], configured through [triggerStyle] and [triggerDecoration]).
///
/// `initialValue` highlights the matching entry, as in Flutter, but does not
/// reposition the menu to align that entry over the button, because the popup
/// is an overlay rather than a measured route.
///
/// The popup is dismissed by the anchor's own opaque outside-tap barrier and by
/// the Escape key. It is not a [Route], so there is no [Navigator.pop]
/// interop and no route transition.
class M3EPopupMenuButton<T> extends StatefulWidget {
  /// Called to build the entries of the popup menu.
  ///
  /// Invoked on every build of this widget rather than only on press, so that
  /// the anchor can size the popup accurately.
  final M3EPopupMenuItemBuilder<T> itemBuilder;

  /// The value of the entry to highlight when the menu opens.
  ///
  /// Purely visual, matching Flutter: activating the highlighted entry still
  /// reports its value to [onSelected].
  final T? initialValue;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user selects a value from the popup menu.
  final M3EPopupMenuItemSelected<T>? onSelected;

  /// Called when the popup menu is dismissed without selecting an item.
  ///
  /// If a value is selected, [onSelected] is called instead.
  final M3EPopupMenuCanceled? onCanceled;

  /// Text that describes the action performed by the button.
  ///
  /// Used for accessibility and as the trigger's tooltip.
  final String? tooltip;

  /// Applied relative to the resolved menu position.
  final Offset offset;

  /// Whether the button is interactive.
  ///
  /// When false the trigger renders disabled, no menu is shown, and
  /// [itemBuilder], [onOpened], [onSelected] and [onCanceled] are not invoked.
  final bool enabled;

  /// Whether the popup requests focus when it opens.
  final bool requestFocus;

  /// The clip behaviour applied to the popup container.
  final Clip clipBehavior;

  /// Visual styling of the popup menu container.
  ///
  /// See [M3EMenuStyle] for elevation, color, shape, padding, sizing, position
  /// and animation properties.
  final M3EMenuStyle? style;

  /// The color scheme variant applied to the popup and its entries.
  final M3EMenuColorSchemeVariant colorSchemeVariant;

  /// Visual style of the trigger button.
  final M3EButtonStyle triggerStyle;

  /// Decoration overrides for the trigger button.
  final M3EButtonDecoration? triggerDecoration;

  /// Whether acoustic and haptic feedback is emitted by the trigger.
  final bool enableFeedback;

  /// The icon shown on the trigger when [child] is null.
  ///
  /// Defaults to [Icons.more_vert_rounded].
  final Widget? icon;

  /// The icon size applied to [icon].
  final double? iconSize;

  /// The color applied to [icon].
  final Color? iconColor;

  /// Custom trigger content.
  ///
  /// Mutually exclusive with [icon], matching Flutter's assertion.
  final Widget? child;

  /// Creates a Material 3 Expressive popup menu button.
  const M3EPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.offset = Offset.zero,
    this.enabled = true,
    this.requestFocus = true,
    this.clipBehavior = Clip.hardEdge,
    this.style,
    this.colorSchemeVariant = M3EMenuColorSchemeVariant.standard,
    this.triggerStyle = M3EButtonStyle.tonal,
    this.triggerDecoration,
    this.enableFeedback = true,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.child,
  }) : assert(
         !(child != null && icon != null),
         'You can only pass [child] or [icon], not both.',
       );

  @override
  State<M3EPopupMenuButton<T>> createState() => M3EPopupMenuButtonState<T>();
}

/// The [State] for an [M3EPopupMenuButton].
///
/// See [showButtonMenu] for a way to programmatically open the popup menu of
/// this button.
class M3EPopupMenuButtonState<T> extends State<M3EPopupMenuButton<T>> {
  final M3EMenuController _controller = M3EMenuController();

  /// Entries produced by the most recent build, used to decide whether there is
  /// anything to show.
  List<M3EPopupMenuEntry<T>> _entries = <M3EPopupMenuEntry<T>>[];

  /// Whether the menu that just closed was closed by a selection, which
  /// suppresses [M3EPopupMenuButton.onCanceled].
  bool _didSelect = false;

  /// Shows the popup menu at the position of this button.
  ///
  /// Called automatically when the trigger is pressed. Can also be invoked
  /// manually through a [GlobalKey], e.g.
  /// `key.currentState?.showButtonMenu()`.
  void showButtonMenu() {
    if (!widget.enabled) return;
    // Nothing to show: Flutter skips opening the menu for an empty item list.
    if (_entries.isEmpty) return;
    widget.onOpened?.call();
    _controller.open();
  }

  void _handleSelected(Object? value) {
    if (value is T) {
      _didSelect = true;
      widget.onSelected?.call(value);
    }
  }

  void _handleClosed() {
    if (!_didSelect) {
      widget.onCanceled?.call();
    }
    _didSelect = false;
  }

  List<Widget> _buildEntries(BuildContext context) {
    final List<M3EPopupMenuEntry<T>> entries = widget.itemBuilder(context);
    _entries = entries;

    final T? initialValue = widget.initialValue;
    final Color highlightColor = Theme.of(context).highlightColor;

    return <Widget>[
      for (final M3EPopupMenuEntry<T> entry in entries)
        M3EPopupMenuScope(
          onSelected: _handleSelected,
          child: initialValue != null && entry.representsValue(initialValue)
              ? ColoredBox(color: highlightColor, child: entry)
              : entry,
        ),
    ];
  }

  Widget _buildTrigger() {
    final VoidCallback? onPressed = widget.enabled ? showButtonMenu : null;

    final Widget content;
    if (widget.child != null) {
      content = widget.child!;
    } else {
      final Widget icon = widget.icon ?? const Icon(Icons.more_vert_rounded);
      content = (widget.iconSize == null && widget.iconColor == null)
          ? icon
          : IconTheme.merge(
              data: IconThemeData(
                size: widget.iconSize,
                color: widget.iconColor,
              ),
              child: icon,
            );
    }

    return M3EButton(
      onPressed: onPressed,
      enabled: widget.enabled,
      style: widget.triggerStyle,
      decoration: widget.triggerDecoration,
      tooltip: widget.tooltip,
      enableFeedback: widget.enableFeedback,
      child: content,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EMenuAnchor(
      controller: _controller,
      style: widget.style,
      colorSchemeVariant: widget.colorSchemeVariant,
      alignmentOffset: widget.offset,
      clipBehavior: widget.clipBehavior,
      requestFocus: widget.requestFocus,
      onClose: _handleClosed,
      menuChildren: _buildEntries(context),
      builder: (context, controller, child) => _buildTrigger(),
    );
  }
}
