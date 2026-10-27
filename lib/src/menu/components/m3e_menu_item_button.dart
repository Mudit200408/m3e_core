// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';
import '../internal/_menu_arrangement.dart';
import '../internal/_menu_scope.dart';
import '../style/m3e_menu_style.dart';
import '../style/m3e_menu_tokens.dart';

/// A Material 3 Expressive menu item button.
///
/// Drop-in replacement for Flutter's [MenuItemButton].
class M3EMenuItemButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final MenuSerializableShortcut? shortcut;
  final String? semanticsLabel;
  final ButtonStyle? style;
  final M3EMenuItemStyle? itemStyle;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? supportingText;
  final bool closeOnActivate;
  final bool closeSubmenusOnHover;
  final Widget? child;

  const M3EMenuItemButton({
    super.key,
    required this.onPressed,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.shortcut,
    this.semanticsLabel,
    this.style,
    this.itemStyle,
    this.leadingIcon,
    this.trailingIcon,
    this.supportingText,
    this.closeOnActivate = true,
    this.closeSubmenusOnHover = true,
    required this.child,
  });

  @override
  State<M3EMenuItemButton> createState() => _M3EMenuItemButtonState();
}

class _M3EMenuItemButtonState extends State<M3EMenuItemButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  void _handleTap() {
    if (widget.onPressed == null) return;
    // Guard against double-firing while the close animation is still running.
    final scope = M3EMenuScope.maybeOf(context);
    if (scope != null && !scope.isActive) return;
    widget.onPressed!();
    if (widget.closeOnActivate) {
      scope?.controller.closeAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final menuScope = M3EMenuScope.maybeOf(context);
    final groupScope = M3EMenuGroupScope.maybeOf(context);
    final isVibrant = menuScope?.isVibrant ?? false;
    final isEnabled = widget.onPressed != null;

    final itemStyle = widget.itemStyle ?? const M3EMenuItemStyle();

    // 1. Shapes determination
    final MenuItemShapes shapes =
        itemStyle.shapes ??
        (groupScope != null
            ? MenuItemShapes.resolve(groupScope.index, groupScope.count)
            : MenuItemShapes.standalone());

    // 2. Colors resolution (Standard vs Vibrant)
    final Color defaultTextColor = isVibrant
        ? cs.onTertiaryContainer
        : cs.onSurface;
    final Color defaultIconColor = isVibrant
        ? ((_isHovered || _isPressed) ? cs.tertiary : cs.onTertiaryContainer)
        : cs.onSurfaceVariant;
    final Color defaultBgColor = isVibrant
        ? cs.tertiaryContainer
        : Colors.transparent;

    final Color effectiveTextColor = isEnabled
        ? (itemStyle.foregroundColor ?? defaultTextColor)
        : (itemStyle.disabledForegroundColor ??
              defaultTextColor.withValues(
                alpha: M3EMenuTokens.disabledOpacity,
              ));

    final Color effectiveIconColor = isEnabled
        ? (itemStyle.leadingIconColor ?? defaultIconColor)
        : defaultIconColor.withValues(alpha: M3EMenuTokens.disabledOpacity);

    final Color effectiveBgColor = itemStyle.backgroundColor ?? defaultBgColor;

    final textStyle =
        (itemStyle.textStyle ?? theme.textTheme.labelLarge ?? const TextStyle())
            .copyWith(color: effectiveTextColor);

    final supportingStyle =
        (itemStyle.supportingTextStyle ??
                theme.textTheme.bodySmall ??
                const TextStyle())
            .copyWith(color: effectiveTextColor.withValues(alpha: 0.8));

    final padding =
        itemStyle.padding ??
        EdgeInsets.symmetric(
          horizontal: M3EMenuTokens.itemHorizontalPadding,
          vertical: widget.supportingText != null ? 8.0 : 0.0,
        );

    final currentShape = (_isHovered || _isFocused || _isPressed)
        ? shapes.selectedShape
        : shapes.shape;

    return Semantics(
      container: true,
      button: true,
      enabled: isEnabled,
      label: widget.semanticsLabel,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
          widget.onFocusChange?.call(focused);
        },
        child: MouseRegion(
          cursor: isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) {
            setState(() => _isHovered = true);
            widget.onHover?.call(true);
            if (widget.closeSubmenusOnHover) {
              M3EMenuScope.maybeOf(context)?.controller.closeChildren();
            }
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            widget.onHover?.call(false);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: isEnabled ? _handleTap : null,
            child: SingleMotionBuilder(
              motion: itemStyle.spatialMotion.toMotion(),
              value: (_isHovered || _isFocused || _isPressed) ? 1.0 : 0.0,
              builder: (context, t, _) {
                final ShapeBorder animatedShape =
                    ShapeBorder.lerp(
                      shapes.shape,
                      currentShape,
                      t.clamp(0.0, 1.0),
                    ) ??
                    currentShape;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 1.0,
                  ),
                  child: Material(
                    color: effectiveBgColor,
                    shape: animatedShape,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: isEnabled ? _handleTap : null,
                      customBorder: animatedShape,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: M3EMenuTokens.itemMinHeight,
                        ),
                        child: Padding(
                          padding: padding,
                          child: IconTheme(
                            data: IconThemeData(
                              size: M3EMenuTokens.leadingIconSize,
                              color: effectiveIconColor,
                            ),
                            child: DefaultTextStyle(
                              style: textStyle,
                              child: M3EMenuItemRow(
                                leadingIcon: widget.leadingIcon,
                                label: widget.child ?? const SizedBox.shrink(),
                                supportingText: widget.supportingText != null
                                    ? DefaultTextStyle(
                                        style: supportingStyle,
                                        child: widget.supportingText!,
                                      )
                                    : null,
                                trailingContent: widget.trailingIcon,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
