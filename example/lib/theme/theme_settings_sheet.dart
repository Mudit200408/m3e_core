// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

import '../shared/shared.dart';
import 'theme_settings.dart';

class ThemeSettingsSheet extends StatelessWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return M3EBottomSheet(
      title: const Text('Theme Settings'),
      child: ValueListenableBuilder<ThemeSettings>(
        valueListenable: themeSettingsNotifier,
        builder: (context, settings, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                M3ESegmentedSwitchGroup(
                  items: [
                    M3ESwitchItem(
                      title: 'Enable M3E Color Scheme',
                      subtitle: 'AOSP ColorSpec2026 overrides',
                      value: settings.useM3EColorScheme,
                      onChanged: (val) {
                        themeSettingsNotifier.value = settings.copyWith(
                          useM3EColorScheme: val,
                        );
                      },
                    ),
                    M3ESwitchItem(
                      title: 'Use System Dynamic Colors',
                      subtitle: 'Syncs with wallpaper colors if supported',
                      value: settings.useSystemColor,
                      onChanged: (val) {
                        themeSettingsNotifier.value = settings.copyWith(
                          useSystemColor: val,
                        );
                      },
                    ),
                  ],
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
                  Text('Color Variant', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: M3EColorVariant.values.map((v) {
                      final isSelected = settings.variant == v;
                      return M3EToggleButton(
                        style: M3EButtonStyle.outlined,
                        size: M3EButtonSize.xs,
                        checked: isSelected,
                        onCheckedChange: (val) {
                          if (val) {
                            themeSettingsNotifier.value = settings.copyWith(
                              variant: v,
                            );
                          }
                        },
                        label: Text(switch (v) {
                          M3EColorVariant.tonalSpot => 'Tonal Spot',
                          M3EColorVariant.vibrant => 'Vibrant',
                          M3EColorVariant.fidelity => 'Fidelity',
                          M3EColorVariant.expressive => 'Expressive',
                          M3EColorVariant.monochrome => 'Monochrome',
                          M3EColorVariant.neutral => 'Neutral',
                          M3EColorVariant.rainbow => 'Rainbow',
                          M3EColorVariant.fruitSalad => 'Fruit Salad',
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  M3ESliderRow(
                    label: 'Contrast Level',
                    value: settings.contrastLevel,
                    min: -1.0,
                    max: 1.0,
                    divisions: 8,
                    format: (v) => v.toStringAsFixed(2),
                    onChanged: (val) {
                      themeSettingsNotifier.value = settings.copyWith(
                        contrastLevel: val,
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
