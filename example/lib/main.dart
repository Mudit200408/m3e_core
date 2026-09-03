// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

import 'screens/m3e_bottom_sheet_screen.dart';
import 'screens/m3e_button_screen.dart';
import 'screens/m3e_dismissible_screen.dart';
import 'screens/m3e_dropdown_screen.dart';
import 'screens/m3e_expandable_screen.dart';
import 'screens/m3e_floating_toolbar_screen.dart';
import 'screens/m3e_loading_indicator_screen.dart';
import 'screens/m3e_progress_indicator_screen.dart';
import 'screens/m3e_seekbar_screen.dart';
import 'screens/m3e_segmented_list_screen.dart';
import 'screens/m3e_slider_screen.dart';
import 'screens/m3e_typography_screen.dart';
import 'shared/shared.dart';
import 'theme/theme_settings.dart';

export 'theme/theme_settings.dart';

void main() {
  runApp(const MyApp());
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

                final convertedLight = convertDynamicScheme(
                  lightDynamic,
                  Brightness.light,
                );
                final convertedDark = convertDynamicScheme(
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
                  title: 'M3E Component Library',
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

class _HomeDestination {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;

  const _HomeDestination({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  static const List<_HomeDestination> _destinations = [
    _HomeDestination(
      title: 'M3E Segmented List',
      subtitle:
          'Expressive list items, segmented containers, selection, reordering, and decorations',
      icon: Icons.view_agenda_rounded,
      screen: M3ESegmentedListScreen(),
    ),
    _HomeDestination(
      title: 'M3E Dismissible',
      subtitle:
          'Archive or delete data using robust, highly-damped dismissible lists',
      icon: Icons.swipe_rounded,
      screen: DismissibleM3EScreen(),
    ),
    _HomeDestination(
      title: 'M3E Expandable',
      subtitle:
          'Richly animated spring expansion lists covering Columns, Slivers, and ListViews',
      icon: Icons.expand_circle_down_rounded,
      screen: ExpandableM3EScreen(),
    ),
    _HomeDestination(
      title: 'M3E Dropdown',
      subtitle:
          'Smooth OverlayPortal powered dropdowns with fluid chip morphing',
      icon: Icons.arrow_drop_down_circle_rounded,
      screen: DropdownM3EScreen(),
    ),
    _HomeDestination(
      title: 'M3E Buttons',
      subtitle:
          'Expressive button system with neighbor squish, shape morphing, and overflow management',
      icon: Icons.smart_button_rounded,
      screen: ButtonM3EScreen(),
    ),
    _HomeDestination(
      title: 'M3E Floating Toolbar',
      subtitle:
          'Expressive floating toolbars with morphing FAB and exit-always scroll physics',
      icon: Icons.subtitles_rounded,
      screen: FloatingToolbarM3EScreen(),
    ),
    _HomeDestination(
      title: 'M3E Slider',
      subtitle:
          'Premium expressive sliders with dual-thumb ranges, ticks, custom decorations & haptics',
      icon: Icons.linear_scale_rounded,
      screen: M3ESliderScreen(),
    ),
    _HomeDestination(
      title: 'M3E Progress Indicators',
      subtitle:
          'Expressive progress indicators including standard and wavy linear/circular rings',
      icon: Icons.hourglass_empty_rounded,
      screen: M3EProgressIndicatorScreen(),
    ),
    _HomeDestination(
      title: 'M3E Seekbar',
      subtitle:
          'Interactive media seekbar with wavy animation, buffered progress & circle/rectangle handles',
      icon: Icons.tune_rounded,
      screen: M3ESeekbarScreen(),
    ),
    _HomeDestination(
      title: 'M3E Loading Indicators',
      subtitle:
          'Expressive loading indicators that morph smoothly between vector path shapes',
      icon: Icons.refresh_rounded,
      screen: M3ELoadingIndicatorScreen(),
    ),
    _HomeDestination(
      title: 'M3E Bottom Sheet',
      subtitle:
          'Expressive modal bottom sheet with spring physics, drag handle, and seamless bottom anchoring',
      icon: Icons.vertical_align_top_rounded,
      screen: M3EBottomSheetScreen(),
    ),
    _HomeDestination(
      title: 'M3E Typography',
      subtitle:
          'Material 3 Expressive emphasized typography scale with variable font axes',
      icon: Icons.text_fields_rounded,
      screen: M3ETypographyScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('M3E Component Library'),
        actions: const [ThemeAppBarActions()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          M3ESegmentedList(
            itemCount: _destinations.length,
            outerRadius: 28,
            innerRadius: 6,
            gap: 4,
            pressedScale: 0.98,
            splashFactory: InkSparkle.splashFactory,
            color: cs.surfaceContainer,
            onTap: (index) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => _destinations[index].screen,
                ),
              );
            },
            itemBuilder: (context, index) {
              final item = _destinations[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: cs.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
