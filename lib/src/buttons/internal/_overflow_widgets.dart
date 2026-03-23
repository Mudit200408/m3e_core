// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';
import 'button_constants.dart';

class OverflowMenuItem extends StatelessWidget {
  const OverflowMenuItem({
    super.key,
    required this.action,
    required this.selected,
    required this.groupDecoration,
    required this.radius,
    required this.onTap,
  });

  final M3EToggleButtonGroupAction action;
  final bool selected;
  final M3EToggleButtonDecoration? groupDecoration;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final fgColor = selected
        ? (action.decoration?.checkedForegroundColor ??
              groupDecoration?.checkedForegroundColor ??
              cs.onSecondaryContainer)
        : (action.decoration?.foregroundColor ??
              groupDecoration?.foregroundColor ??
              cs.onSurface);

    final bgColor = selected
        ? (action.decoration?.checkedBackgroundColor ??
              groupDecoration?.checkedBackgroundColor ??
              cs.secondaryContainer)
        : Colors.transparent;

    final effectiveColor = action.enabled
        ? fgColor
        : (action.decoration?.disabledForegroundColor ??
              fgColor.withValues(
                alpha: ButtonConstants.kDisabledForegroundAlpha,
              ));

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: action.enabled ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: action.enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _buildLeading(effectiveColor),
                const SizedBox(width: 12),
                Expanded(child: _buildTitle(theme, effectiveColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(Color color) {
    final Widget? icon = selected
        ? (action.checkedIcon ?? action.icon)
        : action.icon;
    if (icon == null) return const SizedBox.shrink();
    return IconTheme.merge(
      data: IconThemeData(size: 18, color: color),
      child: icon,
    );
  }

  Widget _buildTitle(ThemeData theme, Color color) {
    final Widget label = selected
        ? (action.checkedLabel ?? action.label ?? const Text('Option'))
        : (action.label ?? action.checkedLabel ?? const Text('Option'));

    return DefaultTextStyle.merge(
      style: theme.textTheme.labelLarge?.copyWith(color: color),
      child: label,
    );
  }
}

class OverflowTriggerButton extends StatelessWidget {
  const OverflowTriggerButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.isGroupConnected,
    required this.isFirstInGroup,
    required this.isLastInGroup,
    required this.style,
    required this.size,
    required this.decoration,
    required this.checked,
    required this.onPressed,
  });

  final Widget icon;
  final String semanticLabel;
  final bool isGroupConnected;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final M3EButtonStyle style;
  final M3EButtonSize size;
  final M3EToggleButtonDecoration? decoration;
  final bool checked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return M3EToggleButton(
      icon: icon,
      checked: checked,
      onCheckedChange: (_) => onPressed(),
      style: style,
      size: size,
      decoration: decoration,
      isGroupConnected: isGroupConnected,
      isFirstInGroup: isFirstInGroup,
      isLastInGroup: isLastInGroup,
      semanticLabel: semanticLabel,
    );
  }
}
