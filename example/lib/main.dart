import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart';

import 'package:m3e_core/m3e_core.dart';

import 'screens/m3e_dropdown_screen.dart';
import 'screens/m3e_button_screen.dart';
import 'screens/m3e_expandable_screen.dart';
import 'screens/m3e_card_screen.dart';
import 'screens/m3e_dismissible_screen.dart';
import 'screens/m3e_floating_toolbar_screen.dart';
import 'screens/m3e_slider_screen.dart';
import 'screens/m3e_progress_indicator_screen.dart';
import 'screens/m3e_loading_indicator_screen.dart';
import 'screens/m3e_seekbar_screen.dart';
import 'screens/m3e_typography_screen.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

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

  ThemeSettings({
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

final ValueNotifier<ThemeSettings> themeSettingsNotifier = ValueNotifier(
  ThemeSettings(
    seedColor: Colors.deepPurple,
    variant: M3EColorVariant.tonalSpot,
    contrastLevel: 0.0,
    useM3EColorScheme: true,
    useSystemColor: true,
  ),
);

final Map<String, Color> seedColors = {
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

ColorScheme? _convertDynamicScheme(dynamic scheme, Brightness brightness) {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, ThemeMode currentMode, _) {
            return ValueListenableBuilder<ThemeSettings>(
              valueListenable: themeSettingsNotifier,
              builder: (context, ThemeSettings settings, _) {
                final systemLightColor = lightDynamic?.primary;
                final systemDarkColor = darkDynamic?.primary;

                final lightSeed =
                    (settings.useSystemColor && systemLightColor != null)
                    ? systemLightColor
                    : settings.seedColor;

                final darkSeed =
                    (settings.useSystemColor && systemDarkColor != null)
                    ? systemDarkColor
                    : settings.seedColor;

                final convertedLight = _convertDynamicScheme(
                  lightDynamic,
                  Brightness.light,
                );
                final convertedDark = _convertDynamicScheme(
                  darkDynamic,
                  Brightness.dark,
                );

                final lightScheme = settings.useM3EColorScheme
                    ? M3EColorScheme.light(
                        seedColor: lightSeed,
                        systemColorScheme: settings.useSystemColor
                            ? convertedLight
                            : null,
                        variant: settings.variant,
                        contrastLevel: settings.contrastLevel,
                      )
                    : ((settings.useSystemColor && convertedLight != null)
                          ? convertedLight
                          : ColorScheme.fromSeed(
                              seedColor: lightSeed,
                              brightness: Brightness.light,
                            ));

                final darkScheme = settings.useM3EColorScheme
                    ? M3EColorScheme.dark(
                        seedColor: darkSeed,
                        systemColorScheme: settings.useSystemColor
                            ? convertedDark
                            : null,
                        variant: settings.variant,
                        contrastLevel: settings.contrastLevel,
                      )
                    : ((settings.useSystemColor && convertedDark != null)
                          ? convertedDark
                          : ColorScheme.fromSeed(
                              seedColor: darkSeed,
                              brightness: Brightness.dark,
                            ));

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  scrollBehavior: DesktopScrollBehavior(),
                  title: 'M3E Card List Demo',
                  themeMode: currentMode,
                  theme: ThemeData(
                    colorScheme: lightScheme,
                    useMaterial3: true,
                    fontFamily: 'GoogleSansFlex',
                  ),
                  darkTheme: ThemeData(
                    colorScheme: darkScheme,
                    useMaterial3: true,
                    fontFamily: 'GoogleSansFlex',
                  ),
                  home: const ExampleHomePage(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget destination,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: cs.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => destination));
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: cs.onPrimaryContainer, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const ThemeSettingsSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Component Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showThemeSettings(context),
            tooltip: 'Theme Customizer',
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeNotifier.value =
                  Theme.of(context).brightness == Brightness.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32, left: 8, right: 8),
            child: Text(
              'Explore the Expressive Component Library built for beautiful and responsive Flutter applications.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          _buildNavCard(
            context,
            title: 'M3E Cards',
            subtitle:
                'Standard expressive cards with custom splash states and radius bounds',
            icon: Icons.list_alt_rounded,
            destination: const M3ECardScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Dismissible',
            subtitle:
                'Archive or delete data using robust, highly-damped dismissible lists',
            icon: Icons.swipe_rounded,
            destination: const DismissibleM3EScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Expandable',
            subtitle:
                'Richly animated spring expansion lists covering Columns, Slivers, and ListViews',
            icon: Icons.expand_circle_down_rounded,
            destination: const ExpandableM3EScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Dropdown',
            subtitle:
                'Smooth OverlayPortal powered dropdowns with fluid chip morphing',
            icon: Icons.arrow_drop_down_circle_rounded,
            destination: const DropdownM3EScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Buttons',
            subtitle:
                'Expressive button system with neighbor squish, shape morphing, and overflow management',
            icon: Icons.smart_button_rounded,
            destination: const ButtonM3EScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Floating Toolbar',
            subtitle:
                'Expressive floating toolbars with morphing FAB and exit-always scroll physics',
            icon: Icons.subtitles_rounded,
            destination: const FloatingToolbarM3EScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Slider',
            subtitle:
                'Premium expressive sliders with dual-thumb ranges, ticks, custom decorations & haptics',
            icon: Icons.linear_scale_rounded,
            destination: const M3ESliderScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Progress Indicators',
            subtitle:
                'Expressive progress indicators including standard and wavy linear/circular rings',
            icon: Icons.hourglass_empty_rounded,
            destination: const M3EProgressIndicatorScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Seekbar',
            subtitle:
                'Interactive media seekbar with wavy animation, buffered progress & circle/rectangle handle tokens',
            icon: Icons.tune_rounded,
            destination: const M3ESeekbarScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Loading Indicators',
            subtitle:
                'Expressive loading indicators that morph smoothly between vector path shapes',
            icon: Icons.refresh_rounded,
            destination: const M3ELoadingIndicatorScreen(),
          ),
          _buildNavCard(
            context,
            title: 'M3E Typography',
            subtitle:
                'Material 3 Expressive emphasized typography scale with variable font axes',
            icon: Icons.text_fields_rounded,
            destination: const M3ETypographyScreen(),
          ),
        ],
      ),
    );
  }
}

class ThemeSettingsSheet extends StatelessWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ValueListenableBuilder<ThemeSettings>(
      valueListenable: themeSettingsNotifier,
      builder: (context, settings, _) {
        return Material(
          color: cs.surfaceContainerHigh,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Theme Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enable M3E Color Scheme'),
                  subtitle: const Text('AOSP ColorSpec2026 overrides'),
                  value: settings.useM3EColorScheme,
                  onChanged: (val) {
                    themeSettingsNotifier.value = settings.copyWith(
                      useM3EColorScheme: val,
                    );
                  },
                ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Use System Dynamic Colors'),
                  subtitle: const Text(
                    'Syncs with wallpaper colors if supported',
                  ),
                  value: settings.useSystemColor,
                  onChanged: (val) {
                    themeSettingsNotifier.value = settings.copyWith(
                      useSystemColor: val,
                    );
                  },
                ),

                if (!settings.useSystemColor) ...[
                  const SizedBox(height: 12),
                  Text('Manual Seed Color', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: seedColors.entries.map((entry) {
                        final isSelected = settings.seedColor == entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              themeSettingsNotifier.value = settings.copyWith(
                                seedColor: entry.value,
                              );
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: entry.value,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: cs.onSurface, width: 3)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                if (settings.useM3EColorScheme) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Color Variant: '),
                      const Spacer(),
                      DropdownButton<M3EColorVariant>(
                        value: settings.variant,
                        onChanged: (val) {
                          if (val != null) {
                            themeSettingsNotifier.value = settings.copyWith(
                              variant: val,
                            );
                          }
                        },
                        items: M3EColorVariant.values.map((v) {
                          return DropdownMenuItem(
                            value: v,
                            child: Text(v.name),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Contrast Level: '),
                      Expanded(
                        child: Slider(
                          value: settings.contrastLevel,
                          min: -1.0,
                          max: 1.0,
                          divisions: 8,
                          label: settings.contrastLevel.toStringAsFixed(2),
                          onChanged: (val) {
                            themeSettingsNotifier.value = settings.copyWith(
                              contrastLevel: val,
                            );
                          },
                        ),
                      ),
                      Text(settings.contrastLevel.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
