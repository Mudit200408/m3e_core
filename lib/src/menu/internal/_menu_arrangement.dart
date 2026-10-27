// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import '../style/m3e_menu_tokens.dart';

/// Arranges a menu item's leading icon, label + supporting text, and trailing content.
class M3EMenuItemRow extends StatelessWidget {
  final Widget? leadingIcon;
  final Widget label;
  final Widget? supportingText;
  final Widget? trailingContent;
  final bool isPrecisionPointer;
  final bool leadingHasSpacing;

  const M3EMenuItemRow({
    super.key,
    this.leadingIcon,
    required this.label,
    this.supportingText,
    this.trailingContent,
    this.isPrecisionPointer = false,
    this.leadingHasSpacing = true,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = isPrecisionPointer
        ? M3EMenuTokens.iconTextSpacingPrecision
        : M3EMenuTokens.iconTextSpacingTouch;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          if (leadingHasSpacing)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: M3EMenuTokens.leadingIconSize,
                minHeight: M3EMenuTokens.leadingIconSize,
              ),
              child: Align(alignment: Alignment.center, child: leadingIcon),
            )
          else
            leadingIcon!,
          if (leadingHasSpacing) SizedBox(width: spacing),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label,
              if (supportingText != null) ...[
                const SizedBox(height: 2.0),
                supportingText!,
              ],
            ],
          ),
        ),
        if (trailingContent != null) ...[
          SizedBox(width: spacing),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: M3EMenuTokens.trailingIconSize,
              minHeight: M3EMenuTokens.trailingIconSize,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: trailingContent,
            ),
          ),
        ],
      ],
    );
  }
}
