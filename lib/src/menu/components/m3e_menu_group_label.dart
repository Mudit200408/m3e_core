// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import '../internal/_menu_scope.dart';
import '../style/m3e_menu_tokens.dart';

/// A standardized header label for an [M3EMenuGroup].
///
/// Ref: `DropdownMenuGroupLabel` in Compose reference (`code.txt`).
class M3EMenuGroupLabel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const M3EMenuGroupLabel({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.only(
      start: M3EMenuTokens.groupLabelPaddingStart,
      end: M3EMenuTokens.groupLabelPaddingEnd,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final menuScope = M3EMenuScope.maybeOf(context);
    final isVibrant = menuScope?.isVibrant ?? false;

    final color = isVibrant ? cs.onTertiaryContainer : cs.onSurfaceVariant;
    final style = (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
      color: color,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: M3EMenuTokens.groupLabelMinHeight,
      ),
      child: Padding(
        padding: padding,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: DefaultTextStyle(style: style, child: child),
        ),
      ),
    );
  }
}
