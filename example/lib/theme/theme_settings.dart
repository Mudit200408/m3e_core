// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

class DesktopScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse, // Enables mouse click-and-drag
    PointerDeviceKind.trackpad, // Enables trackpad drag
    PointerDeviceKind.stylus,
  };
}

class ThemeSettings {
  final Color seedColor;
  final M3EColorVariant variant;
  final double contrastLevel;
  final bool useM3EColorScheme;
  final bool useSystemColor;

  const ThemeSettings({
    required this.seedColor,
    required this.variant,
    required this.contrastLevel,
    required this.useM3EColorScheme,
    required this.useSystemColor,
  });

  ThemeSettings copyWith({
    Color? seedColor,
    M3EColorVariant? variant,
    double? contrastLevel,
    bool? useM3EColorScheme,
    bool? useSystemColor,
  }) {
    return ThemeSettings(
      seedColor: seedColor ?? this.seedColor,
      variant: variant ?? this.variant,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      useM3EColorScheme: useM3EColorScheme ?? this.useM3EColorScheme,
      useSystemColor: useSystemColor ?? this.useSystemColor,
    );
  }
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

final ValueNotifier<ThemeSettings> themeSettingsNotifier = ValueNotifier(
  const ThemeSettings(
    seedColor: Color(0xFF6750A4),
    variant: M3EColorVariant.tonalSpot,
    contrastLevel: 0.0,
    useM3EColorScheme: true,
    useSystemColor: true,
  ),
);

final Map<String, Color> seedColors = {
  'M3 Baseline': const Color(0xFF6750A4),
  'Purple': Colors.deepPurple,
  'Indigo': Colors.indigo,
  'Blue': Colors.blue,
  'Teal': Colors.teal,
  'Green': Colors.green,
  'Yellow': Colors.yellow,
  'Orange': Colors.orange,
  'Red': Colors.red,
  'Pink': Colors.pink,
};

ColorScheme? convertDynamicScheme(dynamic scheme, Brightness brightness) {
  if (scheme == null) return null;
  return ColorScheme(
    brightness: brightness,
    primary: scheme.primary,
    onPrimary: scheme.onPrimary,
    primaryContainer: scheme.primaryContainer,
    onPrimaryContainer: scheme.onPrimaryContainer,
    secondary: scheme.secondary,
    onSecondary: scheme.onSecondary,
    secondaryContainer: scheme.secondaryContainer,
    onSecondaryContainer: scheme.onSecondaryContainer,
    tertiary: scheme.tertiary,
    onTertiary: scheme.onTertiary,
    tertiaryContainer: scheme.tertiaryContainer,
    onTertiaryContainer: scheme.onTertiaryContainer,
    error: scheme.error,
    onError: scheme.onError,
    errorContainer: scheme.errorContainer,
    onErrorContainer: scheme.onErrorContainer,
    surface: scheme.surface,
    onSurface: scheme.onSurface,
    surfaceBright: scheme.surfaceBright,
    surfaceDim: scheme.surfaceDim,
    surfaceContainerLowest: scheme.surfaceContainerLowest,
    surfaceContainerLow: scheme.surfaceContainerLow,
    surfaceContainer: scheme.surfaceContainer,
    surfaceContainerHigh: scheme.surfaceContainerHigh,
    surfaceContainerHighest: scheme.surfaceContainerHighest,
    outline: scheme.outline,
    outlineVariant: scheme.outlineVariant,
    shadow: scheme.shadow,
    scrim: scheme.scrim,
    inverseSurface: scheme.inverseSurface,
    onInverseSurface: scheme.onInverseSurface,
    inversePrimary: scheme.inversePrimary,
    surfaceTint: scheme.surfaceTint,
  );
}
