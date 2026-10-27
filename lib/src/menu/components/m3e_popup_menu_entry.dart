// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../internal/_popup_menu_scope.dart';
import '../style/m3e_menu_style.dart';
import 'm3e_checkbox_menu_button.dart';
import 'm3e_menu_item_button.dart';

/// Signature for the builder callback used by `M3EPopupMenuButton.itemBuilder`.
///
/// Mirrors Flutter's `PopupMenuItemBuilder`.
typedef M3EPopupMenuItemBuilder<T> =
    List<M3EPopupMenuEntry<T>> Function(BuildContext context);

/// Signature for the callback invoked when a popup menu value is selected.
///
/// Mirrors Flutter's `PopupMenuItemSelected`.
typedef M3EPopupMenuItemSelected<T> = void Function(T value);

/// Signature for the callback invoked when a popup menu is dismissed without a
/// selection.
///
/// Mirrors Flutter's `PopupMenuCanceled`.
typedef M3EPopupMenuCanceled = void Function();

/// A base class for entries in a Material 3 Expressive popup menu.
///
/// Mirrors Flutter's [PopupMenuEntry]. Entries are declarative descriptions
/// rather than ready-made widgets: `M3EPopupMenuButton` inspects them through
/// [represents] and [height] before rendering them as M3E menu rows.
abstract class M3EPopupMenuEntry<T> extends StatelessWidget {
  /// Creates a popup menu entry.
  const M3EPopupMenuEntry({super.key});

  /// The amount of vertical space occupied by this entry.
  ///
  /// Defaults to [kMinInteractiveDimension] for interactive entries.
  double get height;

  /// Whether this entry represents [value].
  ///
  /// Used by `M3EPopupMenuButton` to highlight the entry matching its
  /// `initialValue` when the menu opens. Matching Flutter, this is purely
  /// visual — activating a highlighted entry still selects it.
  bool represents(T? value);

  /// Type-safe [represents] for callers holding an untyped value, such as a
  /// popup menu button comparing against its `initialValue`.
  ///
  /// Returns false without invoking [represents] when [value] cannot possibly
  /// be a `T`. This keeps entries such as [M3EPopupMenuDivider], whose `T` is
  /// `Never`, from being handed a value their parameter type cannot hold.
  bool representsValue(Object? value) {
    if (value is! T) return false;
    return represents(value);
  }
}

/// A single selectable item in a Material 3 Expressive popup menu.
///
/// Renders as an [M3EMenuItemButton] inside the menu. Mirrors Flutter's
/// [PopupMenuItem].
class M3EPopupMenuItem<T> extends M3EPopupMenuEntry<T> {
  /// The value reported to `M3EPopupMenuButton.onSelected` when activated.
  final T? value;

  /// Called when the entry is tapped, before the menu closes.
  final VoidCallback? onTap;

  /// Whether the user is permitted to select this entry.
  ///
  /// Defaults to true. When false the row renders in its disabled colours and
  /// does not react to taps.
  final bool enabled;

  @override
  final double height;

  /// Inner padding applied to the entry content.
  final EdgeInsetsGeometry? padding;

  /// Primary label text style.
  final TextStyle? textStyle;

  /// Label text style used when the entry is highlighted as the `initialValue`.
  final TextStyle? labelTextStyle;

  /// Additional styling for this entry.
  final M3EMenuItemStyle? itemStyle;

  /// The content of this entry.
  final Widget child;

  /// Creates a popup menu item.
  const M3EPopupMenuItem({
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.labelTextStyle,
    this.itemStyle,
    required this.child,
  });

  @override
  bool represents(T? value) => this.value == value;

  /// Merges the Flutter-facing entry properties into the M3E item style.
  M3EMenuItemStyle _effectiveItemStyle() {
    final M3EMenuItemStyle base = itemStyle ?? const M3EMenuItemStyle();
    return base.copyWith(
      padding: padding ?? base.padding,
      textStyle: textStyle ?? base.textStyle,
      selectedTextStyle: labelTextStyle ?? base.selectedTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EPopupMenuScope? scope = M3EPopupMenuScope.maybeOf(context);

    void handleTap() {
      onTap?.call();
      scope?.onSelected(value);
    }

    return M3EMenuItemButton(
      onPressed: enabled ? handleTap : null,
      itemStyle: _effectiveItemStyle(),
      child: child,
    );
  }
}

/// A checkable item in a Material 3 Expressive popup menu.
///
/// Renders as an [M3ECheckboxMenuButton] inside the menu. Mirrors Flutter's
/// [CheckedPopupMenuItem].
class M3ECheckedPopupMenuItem<T> extends M3EPopupMenuEntry<T> {
  /// The value reported to `M3EPopupMenuButton.onSelected` when activated.
  final T? value;

  /// Called when the entry is tapped, before the menu closes.
  final VoidCallback? onTap;

  /// Whether the entry renders as checked.
  final bool checked;

  /// Whether the user is permitted to toggle this entry.
  ///
  /// Defaults to true. When false the row renders in its disabled colours and
  /// does not react to taps.
  final bool enabled;

  @override
  final double height;

  /// Inner padding applied to the entry content.
  final EdgeInsetsGeometry? padding;

  /// Primary label text style.
  final TextStyle? textStyle;

  /// Label text style used when the entry is highlighted as the `initialValue`.
  final TextStyle? labelTextStyle;

  /// Additional styling for this entry.
  final M3EMenuItemStyle? itemStyle;

  /// The content of this entry.
  final Widget child;

  /// Creates a checkable popup menu item.
  const M3ECheckedPopupMenuItem({
    super.key,
    this.value,
    this.onTap,
    this.checked = false,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.labelTextStyle,
    this.itemStyle,
    required this.child,
  });

  @override
  bool represents(T? value) => this.value == value;

  M3EMenuItemStyle _effectiveItemStyle() {
    final M3EMenuItemStyle base = itemStyle ?? const M3EMenuItemStyle();
    return base.copyWith(
      padding: padding ?? base.padding,
      textStyle: textStyle ?? base.textStyle,
      selectedTextStyle: labelTextStyle ?? base.selectedTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EPopupMenuScope? scope = M3EPopupMenuScope.maybeOf(context);

    void handleTap() {
      onTap?.call();
      scope?.onSelected(value);
    }

    return M3ECheckboxMenuButton(
      value: checked,
      enabled: enabled,
      onChanged: enabled ? (bool? _) => handleTap() : null,
      itemStyle: _effectiveItemStyle(),
      child: child,
    );
  }
}

/// A horizontal divider in a Material 3 Expressive popup menu.
///
/// Mirrors Flutter's [PopupMenuDivider].
///
/// Typed as [M3EPopupMenuEntry]`<Never>`, which is what allows a divider to be
/// mixed into a `List<M3EPopupMenuEntry<T>>` for any `T`. Callers must use
/// [representsValue] rather than [represents] to test an entry, because
/// `Never?` normalises to `Null` and a raw `represents(someString)` call would
/// fail at runtime.
class M3EPopupMenuDivider extends M3EPopupMenuEntry<Never> {
  /// The amount of vertical space occupied by this divider.
  static const double dividerHeight = 16.0;

  /// Creates a popup menu divider.
  const M3EPopupMenuDivider({super.key});

  @override
  double get height => dividerHeight;

  @override
  bool represents(Never? value) => false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Divider(
      height: dividerHeight,
      thickness: 1.0,
      color: theme.dividerColor,
    );
  }
}
