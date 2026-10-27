// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:m3e_core/m3e_core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';
import '../internal/_menu_arrangement.dart';
import '../internal/_menu_scope.dart';

/// A Material 3 Expressive radio menu item button.
///
/// Drop-in replacement for Flutter's [RadioMenuButton].
/// Ref: `SelectableDropdownMenuItem` in Compose reference (`code.txt`).
class M3ERadioMenuButton<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget? child;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? supportingText;
  final bool closeOnActivate;
  final M3EMenuItemStyle? itemStyle;
  final bool enabled;

  const M3ERadioMenuButton({
    super.key,
    required this.value,
    required this.groupValue,
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
  State<M3ERadioMenuButton<T>> createState() => _M3ERadioMenuButtonState<T>();
}

class _M3ERadioMenuButtonState<T> extends State<M3ERadioMenuButton<T>> {
  // Optimistic local selected state: animates immediately on tap without
  // waiting for the overlay tree to rebuild from the parent.
  late bool _localSelected;

  @override
  void initState() {
    super.initState();
    _localSelected = widget.value == widget.groupValue;
  }

  @override
  void didUpdateWidget(M3ERadioMenuButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync when parent rebuilds.
    final nowSelected = widget.value == widget.groupValue;
    if ((oldWidget.value == oldWidget.groupValue) != nowSelected) {
      _localSelected = nowSelected;
    }
  }

  void _handleTap() {
    if (!widget.enabled || widget.onChanged == null) return;
    // Guard against double-firing while the close animation is still running.
    final scope = M3EMenuScope.maybeOf(context);
    if (scope != null && !scope.isActive) return;
    setState(() => _localSelected = true);
    widget.onChanged!(widget.value);
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

    final Color effectiveFg = _localSelected
        ? (style.selectedForegroundColor ?? defaultSelectedFg)
        : (style.foregroundColor ?? unselectedFg);

    final Color effectiveBg = _localSelected
        ? (style.selectedBackgroundColor ?? defaultSelectedBg)
        : (style.backgroundColor ?? unselectedBg);

    final textStyle =
        (style.textStyle ?? theme.textTheme.labelLarge ?? const TextStyle())
            .copyWith(
              color: effectiveFg,
              fontWeight: _localSelected ? FontWeight.w600 : FontWeight.w500,
            );

    final targetShape = _localSelected ? shapes.selectedShape : shapes.shape;

    return Semantics(
      container: true,
      selected: _localSelected,
      inMutuallyExclusiveGroup: true,
      enabled: widget.enabled,
      child: SingleMotionBuilder(
        motion: style.spatialMotion.toMotion(),
        value: _localSelected ? 1.0 : 0.0,
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
                              _AnimatedRadioLeading(
                                selected: _localSelected,
                                color: effectiveFg,
                                motion: style.spatialMotion,
                              ),
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

class _AnimatedRadioLeading extends StatelessWidget {
  final bool selected;
  final Color color;
  final M3EMotion motion;

  const _AnimatedRadioLeading({
    required this.selected,
    required this.color,
    required this.motion,
  });

  @override
  Widget build(BuildContext context) {
    return SingleMotionBuilder(
      motion: motion.toMotion(),
      value: selected ? 1.0 : 0.0,
      builder: (context, t, _) {
        final double dotScale = t.clamp(0.0, 1.3);
        return SizedBox(
          width: 20,
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.radio_button_unchecked_rounded,
                size: 20,
                color: color.withValues(alpha: selected ? 1.0 : 0.5),
              ),
              if (t > 0.001)
                Transform.scale(
                  scale: dotScale,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
