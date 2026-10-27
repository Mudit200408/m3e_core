// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';
import '../../common/m3e_common.dart';
import '../internal/_menu_arrangement.dart';
import '../internal/_menu_scope.dart';
import '../style/m3e_menu_style.dart';
import '../style/m3e_menu_tokens.dart';

/// A Material 3 Expressive checkable menu item button.
///
/// Drop-in replacement for Flutter's [CheckboxMenuButton].
/// Ref: `CheckableDropdownMenuItem` in Compose reference (`code.txt`).
class M3ECheckboxMenuButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget? child;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? supportingText;
  final bool closeOnActivate;
  final M3EMenuItemStyle? itemStyle;
  final bool enabled;

  const M3ECheckboxMenuButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.leadingIcon,
    this.trailingIcon,
    this.supportingText,
    this.closeOnActivate = true,
    this.itemStyle,
    this.enabled = true,
  });

  @override
  State<M3ECheckboxMenuButton> createState() => _M3ECheckboxMenuButtonState();
}

class _M3ECheckboxMenuButtonState extends State<M3ECheckboxMenuButton> {
  // Optimistic local state: animates immediately on tap without waiting
  // for the overlay tree to rebuild from the parent.
  late bool _localValue;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(M3ECheckboxMenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync when parent rebuilds (e.g. after menu closes and reopens).
    if (oldWidget.value != widget.value) {
      _localValue = widget.value;
    }
  }

  void _handleTap() {
    if (!widget.enabled || widget.onChanged == null) return;
    // Guard against double-firing while the close animation is still running.
    final scope = M3EMenuScope.maybeOf(context);
    if (scope != null && !scope.isActive) return;
    final newValue = !_localValue;
    setState(() => _localValue = newValue);
    widget.onChanged!(newValue);
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

    final style = widget.itemStyle ?? const M3EMenuItemStyle();

    final MenuItemShapes shapes =
        style.shapes ??
        (groupScope != null
            ? MenuItemShapes.resolve(groupScope.index, groupScope.count)
            : MenuItemShapes.standalone());

    // Color resolution for selected vs unselected
    Color defaultSelectedBg;
    Color defaultSelectedFg;

    if (isVibrant) {
      defaultSelectedBg = cs.tertiary;
      defaultSelectedFg = cs.onTertiary;
    } else {
      defaultSelectedBg = cs.tertiaryContainer;
      defaultSelectedFg = cs.onTertiaryContainer;
    }

    final Color unselectedFg = isVibrant
        ? cs.onTertiaryContainer
        : cs.onSurface;
    final Color unselectedBg = isVibrant
        ? cs.tertiaryContainer
        : Colors.transparent;

    final Color effectiveFg = _localValue
        ? (style.selectedForegroundColor ?? defaultSelectedFg)
        : (style.foregroundColor ?? unselectedFg);

    final Color effectiveBg = _localValue
        ? (style.selectedBackgroundColor ?? defaultSelectedBg)
        : (style.backgroundColor ?? unselectedBg);

    final textStyle =
        (style.textStyle ?? theme.textTheme.labelLarge ?? const TextStyle())
            .copyWith(
              color: effectiveFg,
              fontWeight: _localValue ? FontWeight.w600 : FontWeight.w500,
            );

    final targetShape = _localValue ? shapes.selectedShape : shapes.shape;

    return Semantics(
      container: true,
      checked: _localValue,
      enabled: widget.enabled,
      child: SingleMotionBuilder(
        motion: style.spatialMotion.toMotion(),
        value: _localValue ? 1.0 : 0.0,
        builder: (context, t, _) {
          final ShapeBorder animatedShape =
              ShapeBorder.lerp(shapes.shape, targetShape, t.clamp(0.0, 1.0)) ??
              targetShape;

          final Color base = style.backgroundColor ?? unselectedBg;
          final Color animatedColor =
              Color.lerp(base, effectiveBg, t.clamp(0.0, 1.0)) ?? effectiveBg;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
            child: Material(
              color: animatedColor,
              shape: animatedShape,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: widget.enabled ? _handleTap : null,
                onHover: (hovered) {
                  if (hovered) {
                    M3EMenuScope.maybeOf(context)?.controller.closeChildren();
                  }
                },
                customBorder: animatedShape,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: M3EMenuTokens.itemMinHeight,
                  ),
                  child: Padding(
                    padding:
                        style.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: M3EMenuTokens.itemHorizontalPadding,
                          vertical: 12.0,
                        ),
                    child: IconTheme(
                      data: IconThemeData(
                        size: M3EMenuTokens.leadingIconSize,
                        color: effectiveFg,
                      ),
                      child: DefaultTextStyle(
                        style: textStyle,
                        child: M3EMenuItemRow(
                          leadingIcon:
                              widget.leadingIcon ??
                              _AnimatedCheckmarkLeading(
                                checked: _localValue,
                                color: effectiveFg,
                                spacing: M3EMenuTokens.iconTextSpacingTouch,
                                motion: style.spatialMotion,
                              ),
                          leadingHasSpacing: widget.leadingIcon != null,
                          label: widget.child ?? const SizedBox.shrink(),
                          supportingText: widget.supportingText,
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
    );
  }
}

class _AnimatedCheckmarkLeading extends StatelessWidget {
  final bool checked;
  final Color color;
  final double spacing;
  final M3EMotion motion;

  const _AnimatedCheckmarkLeading({
    required this.checked,
    required this.color,
    required this.spacing,
    required this.motion,
  });

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: motion.toMotion(),
      value: checked ? 1.0 : 0.0,
      builder: (context, t, _) {
        if (t <= 0.001) return const SizedBox.shrink();
        final double factor = t < 1.0
            ? t.clamp(0.0, 1.0)
            : 1.0 + (t - 1.0) * 1.5;
        final double opacity = t.clamp(0.0, 1.0);
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        // Horizontal translation on the icon: enters quickly from the leading
        // edge, overshoots past 0 with spring physics, then settles.
        final double rawDx = t < 1.0 ? (t - 1.0) * 18.0 : (t - 1.0) * 30.0;
        final double dx = isRtl ? -rawDx : rawDx;
        return Align(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: factor,
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(dx, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, size: 20, color: color),
                  SizedBox(width: spacing),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
