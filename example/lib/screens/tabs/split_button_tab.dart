import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

import 'button_helpers.dart';

class SplitButtonTab extends StatelessWidget {
  const SplitButtonTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonHeader('Styles', tt),
          ButtonSub(
            'Four supported emphasis styles (filled, tonal, elevated, outlined).',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledSplitButton<String>(
                label: 'Filled',
                leadingTooltip: 'leading',
                trailingTooltip: 'trailing',
                leadingIcon: Icons.save_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'save', child: Text('Save')),
                  M3ESplitButtonItem(value: 'save_as', child: Text('Save As')),
                  M3ESplitButtonItem(value: 'export', child: Text('Export')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3EFilledSplitButton<String>.tonal(
                label: 'Tonal',
                leadingIcon: Icons.share_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'share', child: Text('Share')),
                  M3ESplitButtonItem(value: 'copy', child: Text('Copy Link')),
                  M3ESplitButtonItem(value: 'email', child: Text('Email')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3EElevatedSplitButton<String>(
                label: 'Elevated',
                leadingIcon: Icons.upload_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'upload', child: Text('Upload')),
                  M3ESplitButtonItem(
                    value: 'cloud',
                    child: Text('Cloud Upload'),
                  ),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3EOutlinedSplitButton<String>(
                label: 'Outlined',
                items: const [
                  M3ESplitButtonItem(value: 'option1', child: Text('Option 1')),
                  M3ESplitButtonItem(value: 'option2', child: Text('Option 2')),
                  M3ESplitButtonItem(value: 'option3', child: Text('Option 3')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              const M3EFilledSplitButton<String>(
                label: 'Disabled',
                items: [
                  M3ESplitButtonItem(value: 'a', child: Text('Option A')),
                ],
                enabled: false,
              ),
            ],
          ),

          ButtonHeader('Sizes', tt),
          ButtonSub('Five sizes from XS to XL.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3ESplitButton<String>(
                size: M3EButtonSize.xs,
                style: M3EButtonStyle.tonal,
                label: 'XS',
                items: const [
                  M3ESplitButtonItem(value: 'xs1', child: Text('XS Option 1')),
                  M3ESplitButtonItem(value: 'xs2', child: Text('XS Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                size: M3EButtonSize.sm,
                style: M3EButtonStyle.tonal,
                label: 'SM',
                items: const [
                  M3ESplitButtonItem(value: 'sm1', child: Text('SM Option 1')),
                  M3ESplitButtonItem(value: 'sm2', child: Text('SM Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                size: M3EButtonSize.md,
                style: M3EButtonStyle.tonal,
                label: 'MD',
                items: const [
                  M3ESplitButtonItem(value: 'md1', child: Text('MD Option 1')),
                  M3ESplitButtonItem(value: 'md2', child: Text('MD Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                size: M3EButtonSize.lg,
                style: M3EButtonStyle.tonal,
                label: 'LG',
                items: const [
                  M3ESplitButtonItem(value: 'lg1', child: Text('LG Option 1')),
                  M3ESplitButtonItem(value: 'lg2', child: Text('LG Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                size: M3EButtonSize.xl,
                style: M3EButtonStyle.tonal,
                label: 'XL',
                items: const [
                  M3ESplitButtonItem(value: 'xl1', child: Text('XL Option 1')),
                  M3ESplitButtonItem(value: 'xl2', child: Text('XL Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('Shapes', tt),
          ButtonSub('Round (default) vs Square with spring motion.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                shape: M3EButtonShape.round,
                label: 'Round',
                items: const [
                  M3ESplitButtonItem(
                    value: 'r1',
                    child: Text('Round Option 1'),
                  ),
                  M3ESplitButtonItem(
                    value: 'r2',
                    child: Text('Round Option 2'),
                  ),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                shape: M3EButtonShape.square,
                label: 'Square',
                items: const [
                  M3ESplitButtonItem(
                    value: 's1',
                    child: Text('Square Option 1'),
                  ),
                  M3ESplitButtonItem(
                    value: 's2',
                    child: Text('Square Option 2'),
                  ),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('Leading Content', tt),
          ButtonSub('Icon only, label only, or icon + label.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                label: 'With Icon',
                leadingIcon: Icons.settings_rounded,

                items: const [
                  M3ESplitButtonItem(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  M3ESplitButtonItem(
                    value: 'preferences',
                    child: Text('Preferences'),
                  ),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                leadingIcon: Icons.add_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'add1', child: Text('Add Item')),
                  M3ESplitButtonItem(value: 'add2', child: Text('Add Another')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                label: 'Label Only',
                items: const [
                  M3ESplitButtonItem(value: 'opt1', child: Text('Option 1')),
                  M3ESplitButtonItem(value: 'opt2', child: Text('Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('Custom Decoration', tt),
          ButtonSub(
            'Background, foreground, trailing, and menu colors.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  backgroundColor: WidgetStatePropertyAll(cs.primaryContainer),
                  foregroundColor: WidgetStatePropertyAll(
                    cs.onPrimaryContainer,
                  ),
                  haptic: M3EHapticFeedback.light,
                ),
                label: 'Custom BG',
                leadingIcon: Icons.palette_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'color1', child: Text('Color 1')),
                  M3ESplitButtonItem(value: 'color2', child: Text('Color 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  trailingBackgroundColor: cs.errorContainer,
                  trailingForegroundColor: cs.onErrorContainer,
                  haptic: M3EHapticFeedback.heavy,
                ),
                label: 'Custom Trailing',
                items: const [
                  M3ESplitButtonItem(value: 't1', child: Text('Trailing 1')),
                  M3ESplitButtonItem(value: 't2', child: Text('Trailing 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  backgroundBuilder: (context, states, child) {
                    final pressed = states.contains(WidgetState.pressed);
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            pressed ? cs.primary : cs.primaryContainer,
                            pressed ? cs.tertiary : cs.secondaryContainer,
                          ],
                        ),
                      ),
                      child: child,
                    );
                  },
                ),
                label: 'Gradient BG',
                leadingIcon: Icons.gradient_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'g1', child: Text('Gradient 1')),
                  M3ESplitButtonItem(value: 'g2', child: Text('Gradient 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  foregroundBuilder: (context, states, child) {
                    return Stack(
                      fit: StackFit.passthrough,
                      children: [
                        child ?? const SizedBox.shrink(),
                        IgnorePointer(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cs.inverseSurface,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'fg',
                                style: tt.labelSmall?.copyWith(
                                  color: cs.onInverseSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                label: 'Foreground Badge',
                leadingIcon: Icons.bookmark_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'f1', child: Text('Badge 1')),
                  M3ESplitButtonItem(value: 'f2', child: Text('Badge 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('Custom Size', tt),
          ButtonSub(
            'leadingCustomSize and trailingCustomSize overrides.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  leadingCustomSize: M3EButtonSize.custom(
                    height: 52,
                    hPadding: 28,
                  ),
                ),
                label: 'Leading Custom',
                items: const [
                  M3ESplitButtonItem(value: 'c1', child: Text('Custom 1')),
                  M3ESplitButtonItem(value: 'c2', child: Text('Custom 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  trailingCustomSize: M3EButtonSize.custom(width: 60),
                ),
                label: 'Trailing Custom',
                items: const [
                  M3ESplitButtonItem(value: 'tc1', child: Text('Trailing 1')),
                  M3ESplitButtonItem(value: 'tc2', child: Text('Trailing 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('Menu Styles', tt),
          ButtonSub(
            'Three menu display options: popup (default), bottomSheet, and native.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                style: M3EButtonStyle.filled,
                label: 'Popup (Default)',
                leadingIcon: Icons.arrow_drop_down_rounded,
                items: const [
                  M3ESplitButtonItem(
                    value: 'p1',
                    child: Text('Popup Option 1'),
                  ),
                  M3ESplitButtonItem(
                    value: 'p2',
                    child: Text('Popup Option 2'),
                  ),
                  M3ESplitButtonItem(
                    value: 'p3',
                    child: Text('Popup Option 3'),
                  ),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
              M3ESplitButton<String>(
                decoration: const M3ESplitButtonDecoration(
                  menuStyle: SplitButtonMenuStyle.bottomSheet,
                ),
                style: M3EButtonStyle.filled,
                label: 'Bottom Sheet',
                leadingIcon: Icons.keyboard_arrow_down_rounded,
                items: const [
                  M3ESplitButtonItem(
                    value: 'bs1',
                    child: Text('Sheet Option 1'),
                  ),
                  M3ESplitButtonItem(
                    value: 'bs2',
                    child: Text('Sheet Option 2'),
                  ),
                  M3ESplitButtonItem(
                    value: 'bs3',
                    child: Text('Sheet Option 3'),
                  ),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
              M3ESplitButton<String>(
                decoration: const M3ESplitButtonDecoration(
                  menuStyle: SplitButtonMenuStyle.native,
                ),
                style: M3EButtonStyle.filled,
                label: 'Native',
                leadingIcon: Icons.menu_rounded,
                items: const [
                  M3ESplitButtonItem(
                    value: 'n1',
                    child: Text('Native Option 1'),
                  ),
                  M3ESplitButtonItem(
                    value: 'n2',
                    child: Text('Native Option 2'),
                  ),
                  M3ESplitButtonItem(
                    value: 'n3',
                    child: Text('Native Option 3'),
                  ),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
            ],
          ),

          ButtonHeader('Popup Customization', tt),
          ButtonSub(
            'Custom spring physics and styling for the popup menu.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  popupDecoration: M3ESplitButtonPopupDecoration(
                    motion: M3EMotion.custom(stiffness: 200, damping: 0.6),
                    elevation: 8,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                style: M3EButtonStyle.tonal,
                label: 'Bouncy',
                leadingIcon: Icons.sports_basketball_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'b1', child: Text('Bouncy 1')),
                  M3ESplitButtonItem(value: 'b2', child: Text('Bouncy 2')),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  popupDecoration: M3ESplitButtonPopupDecoration(
                    motion: M3EMotion.custom(stiffness: 600, damping: 0.95),
                    elevation: 2,
                  ),
                ),
                style: M3EButtonStyle.tonal,
                label: 'Snappy',
                leadingIcon: Icons.flash_on_rounded,
                items: const [
                  M3ESplitButtonItem(value: 's1', child: Text('Snappy 1')),
                  M3ESplitButtonItem(value: 's2', child: Text('Snappy 2')),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
            ],
          ),

          ButtonHeader('Bottom Sheet Customization', tt),
          ButtonSub(
            'Custom title and drag handle for the bottom sheet.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                decoration: M3ESplitButtonDecoration(
                  menuStyle: SplitButtonMenuStyle.bottomSheet,
                  bottomSheetDecoration: M3ESplitButtonBottomSheetDecoration(
                    title: Text('Select Action'),
                    motion: M3EMotion.custom(stiffness: 1200, damping: 0.8),
                    showDragHandle: true,
                  ),
                ),
                style: M3EButtonStyle.tonal,
                label: 'With Title',
                leadingIcon: Icons.folder_open_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'f1', child: Text('Open File')),
                  M3ESplitButtonItem(value: 'f2', child: Text('Open Folder')),
                  M3ESplitButtonItem(value: 'f3', child: Text('Open Recent')),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
              M3ESplitButton<String>(
                decoration: const M3ESplitButtonDecoration(
                  menuStyle: SplitButtonMenuStyle.bottomSheet,
                  bottomSheetDecoration: M3ESplitButtonBottomSheetDecoration(
                    showDragHandle: false,
                  ),
                ),
                style: M3EButtonStyle.tonal,
                label: 'No Handle',
                leadingIcon: Icons.list_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'l1', child: Text('List Item 1')),
                  M3ESplitButtonItem(value: 'l2', child: Text('List Item 2')),
                  M3ESplitButtonItem(value: 'l3', child: Text('List Item 3')),
                ],
                onPressed: () {},
                onSelected: (value) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $value')));
                },
              ),
            ],
          ),

          ButtonHeader('With MenuBuilder', tt),
          ButtonSub('Custom PopupMenuEntry via menuBuilder callback.', cs, tt),
          const SizedBox(height: 12),
          M3ESplitButton<String>(
            style: M3EButtonStyle.filled,
            label: 'Custom Menu',
            leadingIcon: Icons.more_horiz_rounded,
            items: const [
              M3ESplitButtonItem(value: 'edit', child: Text('Edit')),
              M3ESplitButtonItem(value: 'delete', child: Text('Delete')),
              M3ESplitButtonItem(value: 'share', child: Text('Share')),
            ],
            menuBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Delete'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Share'),
                  ],
                ),
              ),
            ],
            onPressed: () {},
            onSelected: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Selected: $value')));
            },
          ),

          ButtonHeader('Selection State', tt),
          ButtonSub(
            'Popup shows highlighted selected item with selectedColor.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          _SelectionStateExample(),
          const SizedBox(height: 24),

          ButtonHeader('Multi-Select Bottom Sheet', tt),
          ButtonSub(
            'Bottom sheet with checkbox style for selecting multiple options.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          _MultiSelectExample(),

          ButtonHeader('onLongPress Callback', tt),
          ButtonSub(
            'Triggered when the leading button is long-pressed.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                style: M3EButtonStyle.filled,
                label: 'Long Press Me',
                leadingIcon: Icons.touch_app_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'option1', child: Text('Option 1')),
                  M3ESplitButtonItem(value: 'option2', child: Text('Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Long pressed!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              M3ESplitButton<String>(
                style: M3EButtonStyle.tonal,
                label: 'Context Menu',
                leadingIcon: Icons.more_horiz_rounded,
                items: const [
                  M3ESplitButtonItem(value: 'edit', child: Text('Edit')),
                  M3ESplitButtonItem(value: 'delete', child: Text('Delete')),
                ],
                onPressed: () {},
                onSelected: (_) {},
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening context menu...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),

          ButtonHeader('onHover Callback', tt),
          ButtonSub(
            'Triggered when hover state changes (desktop/web).',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          _SplitHoverExample(),

          ButtonHeader('enableFeedback: false', tt),
          ButtonSub(
            'Disables ripple and default haptic feedback on press.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                style: M3EButtonStyle.tonal,
                label: 'With Feedback',
                leadingIcon: Icons.vibration,
                decoration: const M3ESplitButtonDecoration(
                  haptic: M3EHapticFeedback.light,
                ),
                items: const [
                  M3ESplitButtonItem(value: 'a', child: Text('Option A')),
                  M3ESplitButtonItem(value: 'b', child: Text('Option B')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                style: M3EButtonStyle.tonal,
                label: 'No Feedback',
                leadingIcon: Icons.touch_app,
                enableFeedback: false,
                items: const [
                  M3ESplitButtonItem(value: 'a', child: Text('Option A')),
                  M3ESplitButtonItem(value: 'b', child: Text('Option B')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('splashFactory: NoSplash', tt),
          ButtonSub('Removes the ink ripple effect entirely.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                style: M3EButtonStyle.filled,
                label: 'Default Ripple',
                items: const [
                  M3ESplitButtonItem(value: 'opt1', child: Text('Option 1')),
                  M3ESplitButtonItem(value: 'opt2', child: Text('Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                style: M3EButtonStyle.filled,
                label: 'No Splash',
                splashFactory: NoSplash.splashFactory,
                items: const [
                  M3ESplitButtonItem(value: 'opt1', child: Text('Option 1')),
                  M3ESplitButtonItem(value: 'opt2', child: Text('Option 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('overlayColor (via decoration)', tt),
          ButtonSub(
            'Custom highlight color for pressed/hovered states.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                style: M3EButtonStyle.filled,
                label: 'Custom Overlay',
                leadingIcon: Icons.palette_rounded,
                decoration: M3ESplitButtonDecoration(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white.withValues(alpha: 0.2);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white.withValues(alpha: 0.1);
                    }
                    return null;
                  }),
                ),
                items: const [
                  M3ESplitButtonItem(value: 'c1', child: Text('Custom 1')),
                  M3ESplitButtonItem(value: 'c2', child: Text('Custom 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                style: M3EButtonStyle.outlined,
                label: 'Outlined Overlay',
                leadingIcon: Icons.brush_rounded,
                decoration: M3ESplitButtonDecoration(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return cs.primary.withValues(alpha: 0.2);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return cs.primary.withValues(alpha: 0.1);
                    }
                    return null;
                  }),
                ),
                items: const [
                  M3ESplitButtonItem(value: 'b1', child: Text('Brush 1')),
                  M3ESplitButtonItem(value: 'b2', child: Text('Brush 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          ButtonHeader('surfaceTintColor (via decoration)', tt),
          ButtonSub(
            'Adds a tint layer on top of the button background.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3ESplitButton<String>(
                style: M3EButtonStyle.filled,
                label: 'Blue Tint',
                leadingIcon: Icons.water_drop_rounded,
                decoration: M3ESplitButtonDecoration(
                  surfaceTintColor: WidgetStateProperty.all(
                    cs.primary.withValues(alpha: 0.3),
                  ),
                ),
                items: const [
                  M3ESplitButtonItem(value: 't1', child: Text('Tint 1')),
                  M3ESplitButtonItem(value: 't2', child: Text('Tint 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
              M3ESplitButton<String>(
                style: M3EButtonStyle.elevated,
                label: 'Tertiary Tint',
                leadingIcon: Icons.auto_awesome_rounded,
                decoration: M3ESplitButtonDecoration(
                  surfaceTintColor: WidgetStateProperty.all(
                    cs.tertiary.withValues(alpha: 0.5),
                  ),
                ),
                items: const [
                  M3ESplitButtonItem(value: 'a1', child: Text('Awesome 1')),
                  M3ESplitButtonItem(value: 'a2', child: Text('Awesome 2')),
                ],
                onPressed: () {},
                onSelected: (_) {},
              ),
            ],
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ── Helper widget for split button onHover example ──────────────────────────────

class _SplitHoverExample extends StatefulWidget {
  @override
  State<_SplitHoverExample> createState() => _SplitHoverExampleState();
}

class _SplitHoverExampleState extends State<_SplitHoverExample> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        M3ESplitButton<String>(
          style: M3EButtonStyle.tonal,
          label: _isHovered ? 'Hovering!' : 'Hover over me',
          leadingIcon: _isHovered ? Icons.check_circle : Icons.touch_app,
          decoration: const M3ESplitButtonDecoration(
            haptic: M3EHapticFeedback.light,
          ),
          items: const [
            M3ESplitButtonItem(value: 'h1', child: Text('Hover 1')),
            M3ESplitButtonItem(value: 'h2', child: Text('Hover 2')),
          ],
          onPressed: () {},
          onSelected: (_) {},
          onHover: (hovering) {
            setState(() => _isHovered = hovering);
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered
                ? cs.primaryContainer
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Hover state: ${_isHovered ? "hovered" : "not hovered"}',
            style: TextStyle(
              color: _isHovered ? cs.onPrimaryContainer : cs.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionStateExample extends StatefulWidget {
  @override
  State<_SelectionStateExample> createState() => _SelectionStateExampleState();
}

class _SelectionStateExampleState extends State<_SelectionStateExample> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        M3ESplitButton<String>(
          decoration: M3ESplitButtonDecoration(
            popupDecoration: M3ESplitButtonPopupDecoration(
              selectedColor: cs.primaryContainer,
              selectedBorderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
          style: M3EButtonStyle.filled,
          label: _selectedValue ?? 'Select',
          selectedValue: _selectedValue,
          items: const [
            M3ESplitButtonItem(value: 'save', child: Text('Save')),
            M3ESplitButtonItem(value: 'save_as', child: Text('Save As')),
            M3ESplitButtonItem(value: 'export', child: Text('Export')),
          ],
          onPressed: () {},
          onSelected: (value) {
            setState(() => _selectedValue = value);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Selected: $value')));
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Current selection: ${_selectedValue ?? 'none'}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _MultiSelectExample extends StatefulWidget {
  @override
  State<_MultiSelectExample> createState() => _MultiSelectExampleState();
}

class _MultiSelectExampleState extends State<_MultiSelectExample> {
  final Set<String> _selectedDevices = {};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        M3ESplitButton<String>(
          decoration: M3ESplitButtonDecoration(
            menuStyle: SplitButtonMenuStyle.bottomSheet,
            bottomSheetDecoration: M3ESplitButtonBottomSheetDecoration(
              title: const Text('Select Devices'),
              selectionMode: SplitButtonSelectionMode.multiple,
              checkboxStyle: M3ESplitButtonCheckboxStyle(
                activeColor: cs.primary,
                nonActiveColor: cs.onSurfaceVariant,
                iconColor: cs.onPrimary,
                activeBorderRadius: BorderRadius.circular(99),
                nonActiveBorderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          style: M3EButtonStyle.filled,
          label: _selectedDevices.isEmpty
              ? 'Install App'
              : 'Install to ${_selectedDevices.length} Devices',
          leadingIcon: Icons.install_desktop_rounded,
          items: const [
            M3ESplitButtonItem(value: 'phone', child: Text('Phone')),
            M3ESplitButtonItem(value: 'tablet', child: Text('Tablet')),
            M3ESplitButtonItem(value: 'tv', child: Text('TV')),
            M3ESplitButtonItem(value: 'watch', child: Text('Watch')),
          ],
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Installing app...')));
          },
          onMultiSelected: (devices) {
            setState(() => _selectedDevices.clear());
            if (devices.isNotEmpty) {
              setState(() => _selectedDevices.addAll(devices));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Installing to: ${devices.join(", ")}')),
              );
            }
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Selected: ${_selectedDevices.isEmpty ? 'none' : _selectedDevices.join(", ")}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
