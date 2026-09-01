// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';

import 'package:m3e_core/m3e_core.dart';

import '../theme/theme_settings.dart';
import '../theme/theme_settings_sheet.dart';

/// Reusable AppBar action buttons for Theme Customizer (palette) and Light/Dark mode toggle.
class ThemeAppBarActions extends StatelessWidget {
  const ThemeAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        M3EButton(
          style: M3EButtonStyle.text,
          shape: M3EButtonShape.round,
          size: M3EButtonSize.sm,
          tooltip: 'Theme Customizer',
          onPressed: () {
            showM3EModalBottomSheet(
              context: context,
              builder: (context) => const ThemeSettingsSheet(),
            );
          },
          child: const Icon(Icons.palette_outlined, size: 20),
        ),
        const SizedBox(width: 4),
        M3EButton(
          style: M3EButtonStyle.text,
          shape: M3EButtonShape.round,
          size: M3EButtonSize.sm,
          tooltip: isLight ? 'Switch to Dark Mode' : 'Switch to Light Mode',
          onPressed: () {
            themeNotifier.value = isLight ? ThemeMode.dark : ThemeMode.light;
          },
          child: Icon(
            isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
