import 'dart:async';

import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

import 'tabs/button_helpers.dart';
import 'tabs/split_button_tab.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class ButtonM3EScreen extends StatelessWidget {
  const ButtonM3EScreen({super.key, this.themeMode, this.onThemeModeChanged});

  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('M3E Buttons'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (themeMode != null && onThemeModeChanged != null)
              IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  final newMode = themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                  onThemeModeChanged!(newMode);
                },
              ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'M3EButton'),
              Tab(text: 'M3EToggleButton'),
              Tab(text: 'M3EToggleButtonGroup'),
              Tab(text: 'M3ESplitButton'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ButtonTab(),
            _ToggleButtonTab(),
            _ToggleButtonGroupTab(),
            SplitButtonTab(),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Tab 1 — M3EButton
// ════════════════════════════════════════════════════════════════════════════

class _ButtonTab extends StatelessWidget {
  const _ButtonTab();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Styles ────────────────────────────────────────────────────────
          _Header('Styles', tt),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton.icon(
                enableFeedback: true,
                size: M3EButtonSize.sm,
                tooltip: 'Filled',
                label: const Text('Filled'),
                icon: const Icon(Icons.save_rounded),
                onPressed: () {},
              ),
              M3EFilledButton.tonalIcon(
                label: const Text('Tonal'),
                icon: const Icon(Icons.share_rounded),
                onPressed: () {},
              ),
              M3EElevatedButton.icon(
                label: const Text('Elevated'),
                icon: const Icon(Icons.upload_rounded),
                onPressed: () {},
              ),
              M3EOutlinedButton(
                child: const Text('Outlined'),
                onPressed: () {},
              ),
              M3ETextButton(child: const Text('Text'), onPressed: () {}),
              const M3EFilledButton(onPressed: null, child: Text('Disabled')),
            ],
          ),

          // ── Sizes ─────────────────────────────────────────────────────────
          _Header('Sizes', tt),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EFilledButton.tonal(
                size: M3EButtonSize.xs,
                child: const Text('XS'),
                onPressed: () {},
              ),
              M3EFilledButton.tonal(
                size: M3EButtonSize.sm,
                child: const Text('SM'),
                onPressed: () {},
              ),
              M3EFilledButton.tonal(
                size: M3EButtonSize.md,
                child: const Text('MD'),
                onPressed: () {},
              ),
              M3EFilledButton.tonal(
                size: M3EButtonSize.lg,
                child: const Text('LG'),
                onPressed: () {},
              ),
              M3EFilledButton.tonal(
                size: M3EButtonSize.xl,
                child: const Text('XL'),
                onPressed: () {},
              ),
            ],
          ),

          // ── Shapes ────────────────────────────────────────────────────────
          _Header('Shapes', tt),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton(
                shape: M3EButtonShape.round,
                child: const Text('Round (default)'),
                onPressed: () {},
              ),
              M3EFilledButton(
                shape: M3EButtonShape.square,
                child: const Text('Square token'),
                onPressed: () {},
              ),
              M3EFilledButton(
                shape: M3EButtonShape.square,
                decoration: const M3EButtonDecoration(
                  pressedRadius: 8,
                  hoveredRadius: 12,
                  borderRadius: 16,
                ),
                child: const Text('borderRadius: 16'),
                onPressed: () {},
              ),
            ],
          ),

          // ── customSize ────────────────────────────────────────────────────
          _Header('customSize — height / hPadding / iconSize / width', tt),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton.icon(
                size: M3EButtonSize.custom(
                  height: 52,
                  hPadding: 28,
                  iconSize: 18,
                  iconGap: 6,
                ),
                label: const Text('h52 p28 icon18'),
                icon: const Icon(Icons.tune_rounded),
                onPressed: () {},
              ),
              M3EOutlinedButton(
                size: M3EButtonSize.custom(width: 160, height: 43),
                child: const Text('Fixed width 160'),
                onPressed: () {},
              ),
            ],
          ),

          // ── Haptic ────────────────────────────────────────────────────────
          _Header('Haptic feedback (0–3)', tt),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton.tonalIcon(
                decoration: M3EButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                label: const Text('haptic: light'),
                icon: const Icon(Icons.vibration),
                onPressed: () {},
              ),
              M3EFilledButton.tonalIcon(
                decoration: M3EButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.medium,
                ),
                label: const Text('haptic: medium'),
                icon: const Icon(Icons.vibration),
                onPressed: () {},
              ),
              M3EFilledButton.tonalIcon(
                decoration: M3EButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.heavy,
                ),
                label: const Text('haptic: heavy'),
                icon: const Icon(Icons.vibration),
                onPressed: () {},
              ),
            ],
          ),

          // ── Motion ────────────────────────────────────────────────────────
          _Header('Custom spring motion', tt),
          _Sub('Press to see the spring animation on square buttons.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton(
                shape: M3EButtonShape.round,
                decoration: M3EButtonDecoration.styleFrom(
                  motion: M3EMotion.standardSpatialSlow,
                ),
                onPressed: () {},
                child: const Text('Slow 300'),
              ),
              M3EFilledButton(
                shape: M3EButtonShape.round,
                decoration: M3EButtonDecoration.styleFrom(
                  motion: M3EMotion.standardSpatialFast,
                ),
                onPressed: () {},
                child: const Text('Default 1400'),
              ),
              M3EFilledButton(
                shape: M3EButtonShape.round,
                decoration: M3EButtonDecoration.styleFrom(
                  motion: M3EMotion.standardEffectsFast,
                ),
                onPressed: () {},
                child: const Text('Snappy 3800'),
              ),
              M3EFilledButton(
                shape: M3EButtonShape.round,
                decoration: M3EButtonDecoration.styleFrom(
                  motion: M3EMotion.custom(stiffness: 600, damping: 0.3),
                ),
                onPressed: () {},
                child: const Text('Bouncy 0.3'),
              ),
            ],
          ),

          // ── onLongPress ─────────────────────────────────────────────────────
          _Header('onLongPress callback', tt),
          _Sub('Triggered when button is long-pressed.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton.icon(
                label: const Text('Long press me'),
                icon: const Icon(Icons.touch_app_rounded),
                onPressed: () {},
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Long pressed!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              M3EFilledButton.tonalIcon(
                label: const Text('Long press for menu'),
                icon: const Icon(Icons.more_horiz_rounded),
                onPressed: () {},
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

          // ── onHover ────────────────────────────────────────────────────────
          _Header('onHover callback', tt),
          _Sub('Triggered when hover state changes (desktop/web).', cs, tt),
          const SizedBox(height: 12),
          _HoverExample(),

          // ── enableFeedback ──────────────────────────────────────────────────
          _Header('enableFeedback: false', tt),
          _Sub('Disables ripple and default haptic feedback on press.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton.tonal(
                decoration: M3EButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onPressed: () {},
                child: const Text('With feedback'),
              ),
              M3EFilledButton.tonal(
                enableFeedback: false,
                onPressed: () {},
                child: const Text('No feedback'),
              ),
            ],
          ),

          // ── splashFactory ──────────────────────────────────────────────────
          _Header('splashFactory: NoSplash', tt),
          _Sub('Removes the ink ripple effect entirely.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton(
                child: const Text('Default ripple'),
                onPressed: () {},
              ),
              M3EFilledButton(
                splashFactory: NoSplash.splashFactory,
                onPressed: () {},
                child: const Text('No splash'),
              ),
            ],
          ),

          // ── overlayColor ───────────────────────────────────────────────────
          _Header('overlayColor (via decoration)', tt),
          _Sub('Custom highlight color for pressed/hovered states.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton(
                decoration: M3EButtonDecoration(
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
                onPressed: () {},
                child: const Text('Custom overlay'),
              ),
              M3EOutlinedButton(
                decoration: M3EButtonDecoration(
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
                onPressed: () {},
                child: const Text('Custom overlay'),
              ),
            ],
          ),

          // ── surfaceTintColor ───────────────────────────────────────────────
          _Header('surfaceTintColor (via decoration)', tt),
          _Sub('Adds a tint layer on top of the button background.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton(child: const Text('No tint'), onPressed: () {}),
              M3EFilledButton(
                decoration: M3EButtonDecoration.styleFrom(
                  surfaceTintColor: cs.primary.withValues(alpha: 0.3),
                ),
                onPressed: () {},
                child: const Text('Blue tint'),
              ),
              M3EElevatedButton(
                decoration: M3EButtonDecoration.styleFrom(
                  surfaceTintColor: cs.tertiary.withValues(alpha: 0.5),
                ),
                onPressed: () {},
                child: const Text('Tertiary tint'),
              ),
            ],
          ),

          // ── ButtonStyle Alignment & Dimensions ─────────────────────────────
          _Header('Extended Dimensions & Layout', tt),
          _Sub(
            'Uses standard ButtonStyle sizes, padding, and alignments via M3EButtonDecoration.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EFilledButton(
                decoration: M3EButtonDecoration.styleFrom(
                  fixedSize: Size(150, 80),
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(8),
                ),
                child: const Text('Fixed bottom right'),
                onPressed: () {},
              ),
              M3EFilledButton.icon(
                decoration: M3EButtonDecoration.styleFrom(
                  minimumSize: Size(150, 50),
                  iconSize: 32,
                  foregroundColor: Colors.yellowAccent,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                icon: const Icon(Icons.star_rounded),
                label: const Text('LARGE'),
                onPressed: () {},
              ),
            ],
          ),

          // ── Advanced Material Styling ──────────────────────────────────────
          _Header('Advanced Material Styling', tt),
          _Sub(
            'elevation, shadowColor, visualDensity, backgroundBuilder, foregroundBuilder.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              M3EElevatedButton(
                decoration: M3EButtonDecoration.styleFrom(
                  elevation: 12,
                  shadowColor: Colors.blueAccent,
                ),
                child: const Text('Glowing Shadow'),
                onPressed: () {},
              ),
              M3EFilledButton(
                decoration: M3EButtonDecoration.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Compact Density'),
                onPressed: () {},
              ),
              M3EOutlinedButton(
                decoration: M3EButtonDecoration.styleFrom(
                  backgroundBuilder: (context, states, child) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink, Colors.orange],
                        ),
                      ),
                      child: child,
                    );
                  },
                  foregroundBuilder: (context, states, child) {
                    return DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      child: child!,
                    );
                  },
                ),
                child: const Text('Gradient Builder'),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ── Helper widget for onHover example ────────────────────────────────────────

class _HoverExample extends StatefulWidget {
  @override
  State<_HoverExample> createState() => _HoverExampleState();
}

class _HoverExampleState extends State<_HoverExample> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        M3EFilledButton.tonalIcon(
          label: Text(_isHovered ? 'Hovering!' : 'Hover over me'),
          icon: Icon(_isHovered ? Icons.check_circle : Icons.touch_app),
          onPressed: () {},
          onHover: (hovering) {
            setState(() => _isHovered = hovering);
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? cs.primaryContainer
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Hover state: ${_isHovered ? "hovered" : "not hovered"}',
            style: TextStyle(
              color: _isHovered ? cs.onPrimaryContainer : cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Tab 2 — M3EToggleButton
// ════════════════════════════════════════════════════════════════════════════

class _ToggleButtonTab extends StatefulWidget {
  const _ToggleButtonTab();

  @override
  State<_ToggleButtonTab> createState() => _ToggleButtonTabState();
}

class _ToggleButtonTabState extends State<_ToggleButtonTab> {
  bool _tbFav = false;
  bool _tbStar = false;
  bool _tbBookmark = false;
  bool _tbThumb = false;

  bool _tbsFilled = false;
  bool _tbsElevated = false;
  bool _tbsTonal = false;
  bool _tbsOutlined = false;
  bool _tbsText = false;

  bool _tbCustomA = false;
  bool _tbCustomB = false;
  bool _tbCustomC = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Standalone ────────────────────────────────────────────────────
          _Header('Standalone — icon / checkedIcon / colors / haptic', tt),
          _Sub(
            'Round → square on check. checkedIcon swaps icon on toggle.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EToggleButton(
                icon: const Icon(Icons.favorite_border),
                checkedIcon: const Icon(Icons.favorite),
                checked: _tbFav,
                decoration: M3EToggleButtonDecoration.styleFrom(
                  checkedForegroundColor: cs.error,
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (v) => setState(() => _tbFav = v),
              ),

              M3EToggleButton(
                icon: const Icon(Icons.star_border_rounded),
                checkedIcon: const Icon(Icons.star_rounded),
                checked: _tbStar,
                decoration: M3EToggleButtonDecoration.styleFrom(
                  checkedBackgroundColor: cs.tertiaryContainer,
                  checkedForegroundColor: cs.onTertiaryContainer,
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (v) => setState(() => _tbStar = v),
              ),
              M3EToggleButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                checkedIcon: const Icon(Icons.bookmark_rounded),
                checked: _tbBookmark,
                decoration: M3EToggleButtonDecoration.styleFrom(
                  checkedBackgroundColor: cs.primaryContainer,
                  checkedForegroundColor: cs.onPrimaryContainer,
                ),
                onCheckedChange: (v) => setState(() => _tbBookmark = v),
              ),
              M3EToggleButton(
                icon: const Icon(Icons.thumb_up_outlined),
                checkedIcon: const Icon(Icons.thumb_up),
                checked: _tbThumb,
                decoration: M3EToggleButtonDecoration.styleFrom(
                  checkedBackgroundColor: cs.primaryContainer,
                  checkedForegroundColor: cs.onPrimaryContainer,
                ),
                onCheckedChange: (v) => setState(() => _tbThumb = v),
              ),
              M3EToggleButton(
                enabled: false,
                icon: const Icon(Icons.lock_outline_rounded),
                onCheckedChange: (_) {},
              ),
            ],
          ),

          // ── All five styles ───────────────────────────────────────────────
          _Header('All five styles', tt),
          _Sub('Tap to see checked color mapping per style.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _Labelled(
                'filled',
                M3EFilledToggleButton(
                  tooltip: 'Filled',
                  icon: const Icon(Icons.add_rounded),
                  checkedIcon: const Icon(Icons.check_rounded),
                  checked: _tbsFilled,
                  onCheckedChange: (v) => setState(() => _tbsFilled = v),
                ),
              ),
              _Labelled(
                'elevated',
                M3EElevatedToggleButton(
                  tooltip: 'Elevated',
                  icon: const Icon(Icons.add_rounded),
                  checkedIcon: const Icon(Icons.check_rounded),
                  checked: _tbsElevated,
                  onCheckedChange: (v) => setState(() => _tbsElevated = v),
                ),
              ),
              _Labelled(
                'tonal',
                M3EFilledToggleButton.tonal(
                  icon: const Icon(Icons.add_rounded),
                  checkedIcon: const Icon(Icons.check_rounded),
                  checked: _tbsTonal,
                  onCheckedChange: (v) => setState(() => _tbsTonal = v),
                ),
              ),
              _Labelled(
                'outlined',
                M3EOutlinedToggleButton(
                  icon: const Icon(Icons.add_rounded),
                  checkedIcon: const Icon(Icons.check_rounded),
                  checked: _tbsOutlined,
                  onCheckedChange: (v) => setState(() => _tbsOutlined = v),
                ),
              ),
              _Labelled(
                'text',
                M3ETextToggleButton(
                  icon: const Icon(Icons.add_rounded),
                  checkedIcon: const Icon(Icons.check_rounded),
                  checked: _tbsText,
                  onCheckedChange: (v) => setState(() => _tbsText = v),
                ),
              ),
            ],
          ),

          // ── All five sizes ────────────────────────────────────────────────
          _Header('All five sizes', tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Labelled(
                'xs',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.xs,
                  icon: const Icon(Icons.music_note_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'sm',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.sm,
                  icon: const Icon(Icons.music_note_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'md',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.md,
                  icon: const Icon(Icons.music_note_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'lg',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.lg,
                  icon: const Icon(Icons.music_note_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'xl',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.xl,
                  icon: const Icon(Icons.music_note_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
            ],
          ),

          // ── Shape radius params ───────────────────────────────────────────
          _Header('uncheckedRadius / checkedRadius / pressedRadius', tt),
          _Sub(
            'A  uncheckedRadius:40  checkedRadius:8   pressedRadius:4\n'
            'B  uncheckedRadius:4   checkedRadius:20\n'
            'C  defaults (pill → token square)',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _Labelled(
                'A',
                M3EFilledToggleButton.tonal(
                  icon: const Icon(Icons.crop_square_rounded),
                  checkedIcon: const Icon(Icons.check_rounded),
                  decoration: M3EToggleButtonDecoration.styleFrom(
                    uncheckedRadius: 40,
                    checkedRadius: 8,
                    pressedRadius: 4,
                  ),
                  checked: _tbCustomA,
                  onCheckedChange: (v) => setState(() => _tbCustomA = v),
                ),
              ),
              _Labelled(
                'B',
                M3EFilledToggleButton.tonal(
                  icon: const Icon(Icons.circle_outlined),
                  checkedIcon: const Icon(Icons.check_rounded),
                  decoration: M3EToggleButtonDecoration.styleFrom(
                    uncheckedRadius: 4,
                    checkedRadius: 20,
                  ),
                  checked: _tbCustomB,
                  onCheckedChange: (v) => setState(() => _tbCustomB = v),
                ),
              ),
              _Labelled(
                'C defaults',
                M3EFilledToggleButton.tonal(
                  icon: const Icon(Icons.auto_fix_high_rounded),
                  checked: _tbCustomC,
                  onCheckedChange: (v) => setState(() => _tbCustomC = v),
                ),
              ),
            ],
          ),

          // ── customSize ────────────────────────────────────────────────────
          _Header('customSize — width / height', tt),
          _Sub(
            'width makes a wider rectangle. height makes it taller.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Labelled(
                'default',
                M3EFilledToggleButton.tonal(
                  icon: const Icon(Icons.crop_square_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'w:80',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.custom(width: 80),
                  icon: const Icon(Icons.crop_landscape_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'h:64',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.custom(height: 64),
                  icon: const Icon(Icons.crop_portrait_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
              _Labelled(
                'w:100 h:48',
                M3EFilledToggleButton.tonal(
                  size: M3EButtonSize.custom(width: 100, height: 48),
                  icon: const Icon(Icons.crop_rounded),
                  onCheckedChange: (_) {},
                ),
              ),
            ],
          ),

          // ── Labeled standalone ────────────────────────────────────────────
          _Header('Labeled — standalone M3EToggleButton', tt),
          _Sub(
            'icon + label on a single button. Width grows to fit content.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EFilledToggleButton(
                icon: const Icon(Icons.favorite_border),
                checkedIcon: const Icon(Icons.favorite),
                label: const Text('Like'),
                checkedLabel: const Text('Liked'),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (_) {},
              ),
              M3EOutlinedToggleButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                checkedIcon: const Icon(Icons.bookmark_rounded),
                label: const Text('Save'),
                checkedLabel: const Text('Saved'),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (_) {},
              ),
              M3EFilledToggleButton.tonal(
                icon: const Icon(Icons.notifications_none_rounded),
                checkedIcon: const Icon(Icons.notifications_active_rounded),
                label: const Text('Notify'),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (_) {},
              ),
            ],
          ),

          // ── onLongPress ─────────────────────────────────────────────────────
          _Header('onLongPress callback', tt),
          _Sub('Triggered when toggle button is long-pressed.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EToggleButton(
                icon: const Icon(Icons.edit_outlined),
                checkedIcon: const Icon(Icons.edit),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (_) {},
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit options...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              M3EToggleButton(
                icon: const Icon(Icons.copy_outlined),
                checkedIcon: const Icon(Icons.check),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (_) {},
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copy options...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),

          // ── onHover ────────────────────────────────────────────────────────
          _Header('onHover callback', tt),
          _Sub('Triggered when hover state changes (desktop/web).', cs, tt),
          const SizedBox(height: 12),
          _ToggleHoverExample(),

          // ── enableFeedback ──────────────────────────────────────────────────
          _Header('enableFeedback: false', tt),
          _Sub('Disables ripple and default haptic feedback on press.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EToggleButton(
                icon: const Icon(Icons.favorite_border),
                checkedIcon: const Icon(Icons.favorite),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  haptic: M3EHapticFeedback.light,
                ),
                onCheckedChange: (_) {},
              ),
              M3EToggleButton(
                icon: const Icon(Icons.favorite_border),
                checkedIcon: const Icon(Icons.favorite),
                enableFeedback: false,
                onCheckedChange: (_) {},
              ),
            ],
          ),

          // ── splashFactory ──────────────────────────────────────────────────
          _Header('splashFactory: NoSplash', tt),
          _Sub('Removes the ink ripple effect entirely.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EToggleButton(
                icon: const Icon(Icons.star_border_rounded),
                checkedIcon: const Icon(Icons.star_rounded),
                onCheckedChange: (_) {},
              ),
              M3EToggleButton(
                icon: const Icon(Icons.star_border_rounded),
                checkedIcon: const Icon(Icons.star_rounded),
                splashFactory: NoSplash.splashFactory,
                onCheckedChange: (_) {},
              ),
            ],
          ),

          // ── overlayColor ───────────────────────────────────────────────────
          _Header('overlayColor (via decoration)', tt),
          _Sub('Custom highlight color for pressed/hovered states.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EToggleButton(
                icon: const Icon(Icons.visibility_outlined),
                checkedIcon: const Icon(Icons.visibility),
                decoration: M3EToggleButtonDecoration(
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
                onCheckedChange: (_) {},
              ),
              M3EFilledToggleButton(
                icon: const Icon(Icons.visibility_outlined),
                checkedIcon: const Icon(Icons.visibility),
                decoration: M3EToggleButtonDecoration(
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
                onCheckedChange: (_) {},
              ),
            ],
          ),

          // ── surfaceTintColor ───────────────────────────────────────────────
          _Header('surfaceTintColor (via decoration)', tt),
          _Sub('Adds a tint layer on top of the button background.', cs, tt),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              M3EFilledToggleButton(
                icon: const Icon(Icons.dark_mode_outlined),
                checkedIcon: const Icon(Icons.dark_mode),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  surfaceTintColor: cs.primary.withValues(alpha: 0.3),
                ),
                onCheckedChange: (_) {},
              ),
              M3EElevatedToggleButton(
                icon: const Icon(Icons.light_mode_outlined),
                checkedIcon: const Icon(Icons.light_mode),
                decoration: M3EToggleButtonDecoration.styleFrom(
                  surfaceTintColor: cs.tertiary.withValues(alpha: 0.5),
                ),
                onCheckedChange: (_) {},
              ),
            ],
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ── Helper widget for toggle button onHover example ───────────────────────────

class _ToggleHoverExample extends StatefulWidget {
  @override
  State<_ToggleHoverExample> createState() => _ToggleHoverExampleState();
}

class _ToggleHoverExampleState extends State<_ToggleHoverExample> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        M3EToggleButton(
          icon: const Icon(Icons.touch_app),
          decoration: M3EToggleButtonDecoration.styleFrom(
            haptic: M3EHapticFeedback.light,
          ),
          onCheckedChange: (_) {},
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
            _isHovered ? 'Hovering!' : 'Hover over the button',
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

// ════════════════════════════════════════════════════════════════════════════
// Tab 3 — M3EToggleButtonGroup
// ════════════════════════════════════════════════════════════════════════════

class _ToggleButtonGroupTab extends StatelessWidget {
  const _ToggleButtonGroupTab();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Jetpack Compose ──────────────────────
          _Header('Jetpack Compose Example', tt),
          _Sub(
            'Jetpack Compose Example of toggle button, Add Individual width for each button',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _JetpackComposeExample(),

          const SizedBox(height: 20),

          // ── Standard multi-select, squish on ─────────────────────────────
          _Header('Standard — neighborSquish: true (default)', tt),
          _Sub(
            'Pressed button expands +4 dp; neighbors compress by 2 dp.\n'
            'Multi-select — each action is independent.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgMultiSelectGroup(),

          const SizedBox(height: 20),

          // ── Standard single-select, squish on — RTL ──────────────────────
          _Header('Standard — Single-select, neighborSquish: true', tt),
          _Sub(
            'Only one button selected at a time. Rendered RTL to verify layout.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgRtlSingleSelectGroup(),

          const SizedBox(height: 20),

          // ── icon + checkedLabel ───────────────────────────────────────────
          _Header('Labeled — icon + checkedLabel, squish on', tt),
          _Sub(
            'Icon-only at rest, label appears when checked.\n'
            'Width is content-driven and measured after the first frame.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgCheckedLabelGroup(),

          const SizedBox(height: 20),

          // ── Labeled single-select, checkedLabel swap ──────────────────────
          _Header('Labeled — single-select, checkedLabel swap', tt),
          _Sub('checkedLabel replaces label on selection.', cs, tt),
          const SizedBox(height: 12),
          const _TbgLabeledSingleSelectGroup(),

          const SizedBox(height: 20),

          // ── Standard squish off + customSize ─────────────────────────────
          _Header(
            'Standard — neighborSquish: false, customSize, checkedRadius',
            tt,
          ),
          _Sub(
            'Shape morphs only — no width animation.\n'
            'Per-action customSize, checkedRadius: 10, pressedRadius: 4.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgMediaControlGroup(),

          const SizedBox(height: 20),

          // ── Per-action colors ─────────────────────────────────────────────
          _Header('Standard — Per-action colors', tt),
          _Sub(
            'Each action has its own backgroundColor / checkedBackgroundColor.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgPerActionColorsGroup(),

          const SizedBox(height: 20),

          // ── Overflow: menu ────────────────────────────────────────────────
          _Header('Standard — Overflow menu (popup)', tt),
          _Sub(
            'Labeled toggle actions collapse into an overflow popup menu.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _OverflowToggleDemoGroup(
            initialSelectedIndex: 0,

            overflow: M3EButtonGroupOverflow.menu,
            overflowMenuStyle: M3EButtonGroupOverflowMenuStyle.popup,
            style: M3EButtonStyle.filled,
            actions: [
              (Icons.format_bold_rounded, 'Bold'),
              (Icons.format_italic_rounded, 'Italic'),
              (Icons.format_underline_rounded, 'Underline'),
              (Icons.format_strikethrough_rounded, 'Strikethrough'),
              (Icons.subscript_rounded, 'Subscript'),
              (Icons.superscript_rounded, 'Superscript'),
              (Icons.highlight_rounded, 'Highlight'),
            ],
          ),

          const SizedBox(height: 20),

          // ── Overflow: menu (bottom sheet) ────────────────────────────────
          _Header('Standard — Overflow menu (bottom sheet)', tt),
          _Sub(
            'Labeled toggle actions collapse into an overflow bottom sheet while '
            'keeping single-select state local to this demo.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _OverflowToggleDemoGroup(
            initialSelectedIndex: 1,
            overflow: M3EButtonGroupOverflow.menu,
            overflowMenuStyle: M3EButtonGroupOverflowMenuStyle.bottomSheet,
            style: M3EButtonStyle.tonal,
            actions: [
              (Icons.grid_view_rounded, 'Board'),
              (Icons.view_agenda_rounded, 'List'),
              (Icons.calendar_view_week_rounded, 'Week'),
              (Icons.map_rounded, 'Map'),
              (Icons.analytics_rounded, 'Stats'),
              (Icons.archive_rounded, 'Archive'),
            ],
          ),

          const SizedBox(height: 20),

          // ── Overflow: experimental paging ─────────────────────────────────
          _Header('Standard — Overflow: experimental paging', tt),
          _Sub('Toggle API, pages through a larger toolset in-place.', cs, tt),
          const SizedBox(height: 12),
          const _OverflowToggleDemoGroup(
            initialSelectedIndex: 0,
            overflow: M3EButtonGroupOverflow.experimentalPaging,
            style: M3EButtonStyle.outlined,
            actions: [
              (Icons.crop_rounded, 'Crop'),
              (Icons.rotate_right_rounded, 'Rotate'),
              (Icons.tune_rounded, 'Tune'),
              (Icons.brush_rounded, 'Brush'),
              (Icons.text_fields_rounded, 'Text'),
              (Icons.layers_rounded, 'Layers'),
              (Icons.ios_share_rounded, 'Export'),
            ],
          ),
          const SizedBox(height: 20),

          // ── Custom Overflow Strategy ──────────────────────────────────────
          _Header('Custom — Custom OverflowStrategy', tt),
          _Sub(
            'A custom strategy that wraps overflowing buttons in a Card popup.\n'
            'Demonstrates how to implement OverflowStrategy for custom behavior.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _CustomOverflowDemoGroup(),

          const SizedBox(height: 20),

          // -- Connected toggle buttons ─────────────────────────────────────────
          _Header('Connected — Example', tt),
          _Sub('Default Example for connected toggle button group.', cs, tt),
          const SizedBox(height: 12),
          const _TbgConnectedExample(),
          const SizedBox(height: 20),

          // ── Connected round, single-select ────────────────────────────────
          _Header('Connected — Round, single-select', tt),
          _Sub(
            'Inner corners squish on press → pill on select.\n'
            'Outer corners locked (round shape).',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgConnectedRoundGroup(),

          const SizedBox(height: 20),

          // ── Connected square, deselectable ───────────────────────────────
          _Header(
            'Connected — Square, connectedInnerRadius: 10, pressedRadius: 3',
            tt,
          ),
          _Sub(
            'Softer joins at rest, tighter squish on press.\n'
            'Tap selected again to deselect.',
            cs,
            tt,
          ),
          const SizedBox(height: 12),
          const _TbgConnectedSquareGroup(),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ── Isolated group widgets for _ToggleButtonGroupTab ─────────────────────

class _TbgStressTestGroup extends StatefulWidget {
  const _TbgStressTestGroup();

  @override
  State<_TbgStressTestGroup> createState() => _TbgStressTestGroupState();
}

class _TbgStressTestGroupState extends State<_TbgStressTestGroup> {
  int? _index;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    style: M3EButtonStyle.tonal,
    spacing: 8.0,
    selectedIndex: _index,
    onSelectedIndexChanged: (i) => setState(() => _index = i),
    actions: List.generate(
      20,
      (i) => M3EToggleButtonGroupAction(
        icon: const Icon(Icons.star_outline_rounded),
        checkedIcon: const Icon(Icons.star_rounded),
        label: Text('Button $i'),
      ),
    ),
  );
}

class _TbgMultiSelectGroup extends StatefulWidget {
  const _TbgMultiSelectGroup();

  @override
  State<_TbgMultiSelectGroup> createState() => _TbgMultiSelectGroupState();
}

class _TbgMultiSelectGroupState extends State<_TbgMultiSelectGroup> {
  int? _index;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    style: M3EButtonStyle.filled,
    spacing: 8.0,
    decoration: M3EToggleButtonDecoration.styleFrom(
      checkedRadius: 99,
      pressedRadius: 8,
      uncheckedRadius: 18,
    ),
    expandedRatio: 0.15,
    selectedIndex: _index,
    onSelectedIndexChanged: (i) => setState(() => _index = i),
    actions: [
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_bold_rounded),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_italic_rounded),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_underline_rounded),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_strikethrough_rounded),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
    ],
  );
}

class _TbgRtlSingleSelectGroup extends StatefulWidget {
  const _TbgRtlSingleSelectGroup();
  @override
  State<_TbgRtlSingleSelectGroup> createState() =>
      _TbgRtlSingleSelectGroupState();
}

class _TbgRtlSingleSelectGroupState extends State<_TbgRtlSingleSelectGroup> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: M3EToggleButtonGroup(
      style: M3EButtonStyle.filled,
      spacing: 8.0,
      decoration: M3EToggleButtonDecoration.styleFrom(
        motion: M3EMotion.standardOverflow,
      ),
      neighborSquish: true,
      selectedIndex: _index,
      onSelectedIndexChanged: (i) => setState(() => _index = i ?? _index),
      actions: [
        M3EToggleButtonGroupAction(
          icon: const Icon(Icons.format_bold_rounded),
          label: const Text('B'),
          decoration: M3EToggleButtonDecoration.styleFrom(
            haptic: M3EHapticFeedback.light,
          ),
        ),
        M3EToggleButtonGroupAction(
          icon: const Icon(Icons.format_italic_rounded),
          label: const Text('I'),
          decoration: M3EToggleButtonDecoration.styleFrom(
            haptic: M3EHapticFeedback.light,
          ),
        ),
        M3EToggleButtonGroupAction(
          icon: const Icon(Icons.format_underline_rounded),
          label: const Text('U'),
          decoration: M3EToggleButtonDecoration.styleFrom(
            haptic: M3EHapticFeedback.light,
          ),
        ),
        M3EToggleButtonGroupAction(
          icon: const Icon(Icons.format_strikethrough_rounded),
          label: const Text('S'),
          decoration: M3EToggleButtonDecoration.styleFrom(
            haptic: M3EHapticFeedback.light,
          ),
        ),
      ],
    ),
  );
}

class _TbgCheckedLabelGroup extends StatefulWidget {
  const _TbgCheckedLabelGroup();

  @override
  State<_TbgCheckedLabelGroup> createState() => _TbgCheckedLabelGroupState();
}

class _TbgCheckedLabelGroupState extends State<_TbgCheckedLabelGroup> {
  Set<int> _selectedIndices = {};
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    style: M3EButtonStyle.filled,
    spacing: 8.0,
    expandedRatio: 0.15,
    decoration: M3EToggleButtonDecoration.styleFrom(
      motion: M3EMotion.expressiveSpatialDefault,
    ),
    selectedIndices: _selectedIndices,
    onSelectedIndicesChanged: (indices) =>
        setState(() => _selectedIndices = indices),
    actions: [
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_bold_rounded),
        checkedLabel: const Text('Bold'),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_italic_rounded),
        checkedLabel: const Text('Italic'),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_underline_rounded),
        checkedLabel: const Text('Underline'),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_strikethrough_rounded),
        checkedLabel: const Text('Strike'),
        decoration: M3EToggleButtonDecoration.styleFrom(
          haptic: M3EHapticFeedback.light,
        ),
      ),
    ],
  );
}

class _TbgLabeledSingleSelectGroup extends StatefulWidget {
  const _TbgLabeledSingleSelectGroup();
  @override
  State<_TbgLabeledSingleSelectGroup> createState() =>
      _TbgLabeledSingleSelectGroupState();
}

class _TbgLabeledSingleSelectGroupState
    extends State<_TbgLabeledSingleSelectGroup> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    style: M3EButtonStyle.tonal,
    spacing: 8.0,
    selectedIndex: _index,
    onSelectedIndexChanged: (i) => setState(() => _index = i ?? _index),
    actions: [
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_left_rounded),
        label: const Text('Left'),
        checkedLabel: const Text('Left ✓'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_center_rounded),
        label: const Text('Center'),
        checkedLabel: const Text('Center ✓'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_right_rounded),
        label: const Text('Right'),
        checkedLabel: const Text('Right ✓'),
      ),
    ],
  );
}

class _TbgMediaControlGroup extends StatelessWidget {
  const _TbgMediaControlGroup();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MediaToggleButton(
          icon: Icon(Icons.play_arrow_rounded),
          checkedIcon: Icon(Icons.pause_rounded),
        ),
        SizedBox(width: 8),
        _MediaToggleButton(
          icon: Icon(Icons.shuffle_rounded),
          checkedIcon: Icon(Icons.shuffle_rounded),
        ),
        SizedBox(width: 8),
        _MediaToggleButton(
          icon: Icon(Icons.repeat_rounded),
          checkedIcon: Icon(Icons.repeat_one_rounded),
        ),
      ],
    );
  }
}

class _MediaToggleButton extends StatefulWidget {
  const _MediaToggleButton({required this.icon, required this.checkedIcon});

  final Widget icon;
  final Widget checkedIcon;

  @override
  State<_MediaToggleButton> createState() => _MediaToggleButtonState();
}

class _MediaToggleButtonState extends State<_MediaToggleButton> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => M3EToggleButton(
    style: M3EButtonStyle.outlined,
    icon: widget.icon,
    checkedIcon: widget.checkedIcon,
    checked: _checked,
    decoration: M3EToggleButtonDecoration.styleFrom(
      checkedRadius: 10,
      pressedRadius: 4,
    ),
    onCheckedChange: (v) => setState(() => _checked = v),
  );
}

class _JetpackComposeExample extends StatefulWidget {
  const _JetpackComposeExample();
  @override
  State<_JetpackComposeExample> createState() => _JetpackComposeExampleState();
}

class _JetpackComposeExampleState extends State<_JetpackComposeExample> {
  int? _index;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    style: M3EButtonStyle.filled,
    spacing: 6.0,
    expandedRatio: 0.08,

    size: M3EButtonSize.custom(height: 80),
    decoration: M3EToggleButtonDecoration.styleFrom(
      haptic: M3EHapticFeedback.light,

      motion: M3EMotion.expressiveSpatialDefault,
      checkedRadius: 12,
      pressedRadius: 6,
    ),
    neighborSquish: true,
    selectedIndex: _index,
    onSelectedIndexChanged: (i) => setState(() => _index = i),
    actions: [
      M3EToggleButtonGroupAction(icon: const Icon(Icons.bluetooth)),

      M3EToggleButtonGroupAction(icon: const Icon(Icons.alarm), width: 80),
      M3EToggleButtonGroupAction(icon: const Icon(Icons.link), width: 60),
      M3EToggleButtonGroupAction(icon: const Icon(Icons.wifi), width: 120),
    ],
  );
}

class _TbgPerActionColorsGroup extends StatelessWidget {
  const _TbgPerActionColorsGroup();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ColorToggleButton(
          icon: const Icon(Icons.favorite_rounded),
          decoration: M3EToggleButtonDecoration.styleFrom(
            backgroundColor: cs.errorContainer,
            foregroundColor: cs.onErrorContainer,
            checkedBackgroundColor: cs.error,
            checkedForegroundColor: cs.onError,
            haptic: M3EHapticFeedback.light,
          ),
        ),
        const SizedBox(width: 8),
        _ColorToggleButton(
          icon: const Icon(Icons.star_rounded),
          decoration: M3EToggleButtonDecoration.styleFrom(
            backgroundColor: cs.tertiaryContainer,
            foregroundColor: cs.onTertiaryContainer,
            checkedBackgroundColor: cs.tertiary,
            checkedForegroundColor: cs.onTertiary,
            haptic: M3EHapticFeedback.light,
          ),
        ),
        const SizedBox(width: 8),
        _ColorToggleButton(
          icon: const Icon(Icons.share_rounded),
          decoration: M3EToggleButtonDecoration.styleFrom(
            backgroundColor: cs.primaryContainer,
            foregroundColor: cs.onPrimaryContainer,
            checkedBackgroundColor: cs.primary,
            checkedForegroundColor: cs.onPrimary,
            haptic: M3EHapticFeedback.light,
          ),
        ),
      ],
    );
  }
}

class _ColorToggleButton extends StatefulWidget {
  const _ColorToggleButton({required this.icon, required this.decoration});

  final Widget icon;
  final M3EToggleButtonDecoration decoration;

  @override
  State<_ColorToggleButton> createState() => _ColorToggleButtonState();
}

class _ColorToggleButtonState extends State<_ColorToggleButton> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => M3EToggleButton(
    style: M3EButtonStyle.filled,
    icon: widget.icon,
    checked: _checked,
    decoration: widget.decoration,
    onCheckedChange: (v) => setState(() => _checked = v),
  );
}

class _TbgConnectedRoundGroup extends StatefulWidget {
  const _TbgConnectedRoundGroup();
  @override
  State<_TbgConnectedRoundGroup> createState() =>
      _TbgConnectedRoundGroupState();
}

class _TbgConnectedRoundGroupState extends State<_TbgConnectedRoundGroup> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    type: M3EButtonGroupType.connected,
    shape: M3EButtonShape.round,
    style: M3EButtonStyle.tonal,
    spacing: 8.0,
    selectedIndex: _index,
    onSelectedIndexChanged: (i) => setState(() => _index = i ?? _index),
    decoration: M3EToggleButtonDecoration.styleFrom(
      hoveredRadius: 6,
      pressedRadius: 2,
      connectedInnerRadius: 10,
      checkedRadius: 99,
      uncheckedRadius: 12,
    ),
    actions: [
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_left_rounded),
        tooltip: 'Left',
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_center_rounded),
        tooltip: 'Center',
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_right_rounded),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.format_align_justify_rounded),
      ),
    ],
  );
}

class _TbgConnectedSquareGroup extends StatefulWidget {
  const _TbgConnectedSquareGroup();
  @override
  State<_TbgConnectedSquareGroup> createState() =>
      _TbgConnectedSquareGroupState();
}

class _TbgConnectedSquareGroupState extends State<_TbgConnectedSquareGroup> {
  int? _index;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    type: M3EButtonGroupType.connected,
    shape: M3EButtonShape.square,
    style: M3EButtonStyle.filled,
    spacing: 8.0,
    selectedIndex: _index,
    decoration: M3EToggleButtonDecoration.styleFrom(
      connectedInnerRadius: 10,
      pressedRadius: 3,
      motion: M3EMotion.custom(stiffness: 600, damping: 0.7),
    ),
    onSelectedIndexChanged: (i) => setState(() => _index = i),
    actions: [
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_one_rounded),
        checkedLabel: const Text('Look 1'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_two_rounded),
        checkedLabel: const Text('Look 2'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_3_rounded),
        checkedLabel: const Text('Look 3'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_4_rounded),
        checkedLabel: const Text('Look 4'),
      ),
    ],
  );
}

class _TbgConnectedExample extends StatefulWidget {
  const _TbgConnectedExample();
  @override
  State<_TbgConnectedExample> createState() => _TbgConnectedExampleState();
}

class _TbgConnectedExampleState extends State<_TbgConnectedExample> {
  int? _index;
  @override
  Widget build(BuildContext context) => M3EToggleButtonGroup(
    type: M3EButtonGroupType.connected,
    shape: M3EButtonShape.square,
    style: M3EButtonStyle.filled,
    spacing: 8.0,
    selectedIndex: _index,
    decoration: M3EToggleButtonDecoration.styleFrom(
      connectedInnerRadius: 10,
      pressedRadius: 3,
      motion: M3EMotion.custom(stiffness: 600, damping: 0.7),
    ),
    onSelectedIndexChanged: (i) => setState(() => _index = i),
    actions: [
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_one_rounded),
        label: const Text('Look 1'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_two_rounded),
        label: const Text('Look 2'),
      ),
      M3EToggleButtonGroupAction(
        icon: const Icon(Icons.looks_3_rounded),
        label: const Text('Look 3'),
      ),
    ],
  );
}

// ════════════════════════════════════════════════════════════════════════════
// Self-contained overflow demo widget
// ════════════════════════════════════════════════════════════════════════════

class _OverflowToggleDemoGroup extends StatefulWidget {
  const _OverflowToggleDemoGroup({
    required this.actions,
    required this.style,
    required this.overflow,
    this.initialSelectedIndex,
    this.overflowMenuStyle,
  });

  final List<(IconData, String)> actions;
  final M3EButtonStyle style;
  final M3EButtonGroupOverflow overflow;
  final int? initialSelectedIndex;
  final M3EButtonGroupOverflowMenuStyle? overflowMenuStyle;

  @override
  State<_OverflowToggleDemoGroup> createState() =>
      _OverflowToggleDemoGroupState();
}

class _OverflowToggleDemoGroupState extends State<_OverflowToggleDemoGroup> {
  late int? _selectedIndex = widget.initialSelectedIndex;

  late List<M3EToggleButtonGroupAction> _actions = _buildActions();

  List<M3EToggleButtonGroupAction> _buildActions() => [
    for (final action in widget.actions)
      M3EToggleButtonGroupAction(icon: Icon(action.$1), label: Text(action.$2)),
  ];

  @override
  void didUpdateWidget(covariant _OverflowToggleDemoGroup old) {
    super.didUpdateWidget(old);
    if (widget.actions != old.actions) {
      _actions = _buildActions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final overflowPopupDecoration = M3EOverflowPopupDecoration(
      trailing: Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
      motion: M3EMotion.custom(stiffness: 800, damping: 0.7),
    );

    final overflowBottomSheetDecoration = M3EOverflowBottomSheetDecoration(
      trailing: Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
      motion: M3EMotion.custom(stiffness: 700, damping: 0.4),
    );

    final group = M3EToggleButtonGroup(
      style: widget.style,
      overflow: widget.overflow,
      selectedIndex: _selectedIndex,
      onSelectedIndexChanged: (i) => setState(() => _selectedIndex = i),
      actions: _actions,
    );

    Widget result;
    if (widget.overflowMenuStyle != null) {
      result = M3EToggleButtonGroup(
        style: widget.style,
        overflow: widget.overflow,
        overflowMenuStyle: widget.overflowMenuStyle!,
        overflowPopupDecoration: overflowPopupDecoration,
        overflowBottomSheetDecoration: overflowBottomSheetDecoration,
        selectedIndex: _selectedIndex,
        onSelectedIndexChanged: (i) => setState(() => _selectedIndex = i),
        actions: _actions,
      );
    } else {
      result = group;
    }

    return result;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Shared UI helpers
// ════════════════════════════════════════════════════════════════════════════

typedef _Header = ButtonHeader;
typedef _Sub = ButtonSub;
typedef _Labelled = ButtonLabelled;

// ════════════════════════════════════════════════════════════════════════════
// Custom Overflow Strategy Demos
// ════════════════════════════════════════════════════════════════════════════

class _CustomOverflowDemoGroup extends StatefulWidget {
  const _CustomOverflowDemoGroup();

  @override
  State<_CustomOverflowDemoGroup> createState() =>
      _CustomOverflowDemoGroupState();
}

class _CustomOverflowDemoGroupState extends State<_CustomOverflowDemoGroup> {
  int _selectedIndex = 0;

  final List<_ToolbarAction> _actions = const [
    _ToolbarAction(Icons.format_bold_rounded, 'Bold'),
    _ToolbarAction(Icons.format_italic_rounded, 'Italic'),
    _ToolbarAction(Icons.format_underline_rounded, 'Underline'),
    _ToolbarAction(Icons.format_strikethrough_rounded, 'Strike'),
    _ToolbarAction(Icons.highlight_rounded, 'Highlight'),
    _ToolbarAction(Icons.text_fields_rounded, 'Text'),
    _ToolbarAction(Icons.code_rounded, 'Code'),
  ];

  @override
  Widget build(BuildContext context) {
    return M3EToggleButtonGroup(
      style: M3EButtonStyle.tonal,
      overflowStrategy: const _DialogOverflowStrategyDemo(),
      selectedIndex: _selectedIndex,
      onSelectedIndexChanged: (i) => setState(() => _selectedIndex = i ?? 0),
      spacing: 10,
      actions: [
        for (final action in _actions)
          M3EToggleButtonGroupAction(
            icon: Icon(action.icon),
            label: Text(action.label),
          ),
      ],
    );
  }
}

class _ToolbarAction {
  const _ToolbarAction(this.icon, this.label);
  final IconData icon;
  final String label;
}

// ── Dialog Overflow Strategy ────────────────────────────────────────────────

class _DialogOverflowStrategyDemo extends OverflowStrategy {
  const _DialogOverflowStrategyDemo();

  @override
  String get id => 'dialog-demo';

  @override
  double? get triggerExtent => 84.0; // wider size to accommodate text label

  @override
  Widget buildLayout({
    required BuildContext context,
    required List<M3EToggleButtonGroupAction> actions,
    required int visibleCount,
    required double spacing,
    required Axis direction,
    required M3EButtonStyle style,
    required M3EButtonSize size,
    required M3EToggleButtonDecoration? decoration,
    required bool connected,
    required bool isRtl,
    required Widget Function(int index, bool isFirst, bool isLast) buildButton,
  }) {
    final count = visibleCount;
    final children = <Widget>[];

    for (int i = 0; i < count; i++) {
      final isFirst = isRtl ? (i == count - 1) : (i == 0);
      final isLast = isRtl ? (i == 0) : (i == count - 1);
      children.add(buildButton(i, isFirst, isLast));
      if (i < count - 1) {
        children.add(
          direction == Axis.horizontal
              ? SizedBox(width: spacing)
              : SizedBox(height: spacing),
        );
      }
    }

    return direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget? buildOverflowTrigger({
    required BuildContext context,
    required int hiddenCount,
    required M3EButtonStyle style,
    required M3EButtonSize size,
    required M3EToggleButtonDecoration? decoration,
    required bool connected,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onPressed,
    required bool checked,
  }) {
    return M3EToggleButton(
      icon: const Icon(Icons.more_horiz_rounded),
      label: Text('+$hiddenCount'),
      checked: checked,
      onCheckedChange: (_) => onPressed(),
      style: style,
      size: size,
      decoration: decoration,
      isGroupConnected: connected,
      isFirstInGroup: isFirst,
      isLastInGroup: isLast,
    );
  }

  @override
  Future<int?> showOverflowMenu({
    required BuildContext context,
    required List<M3EToggleButtonGroupAction> actions,
    required int firstHiddenIndex,
    required int? selectedIndex,
  }) async {
    final cs = Theme.of(context).colorScheme;
    return showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('More Options'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = firstHiddenIndex; i < actions.length; i++)
                  _DialogMenuItem(
                    isSelected: selectedIndex == i,
                    icon: Icons.text_fields,
                    label: actions[i].label ?? const Text('Option'),
                    selectedColor: cs.secondaryContainer,
                    selectedBorderRadius: 12,
                    onTap: () => Navigator.of(ctx).pop(i),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class _DialogMenuItem extends StatelessWidget {
  const _DialogMenuItem({
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.selectedColor,
    required this.selectedBorderRadius,
    required this.onTap,
  });

  final bool isSelected;
  final IconData icon;
  final Widget label;
  final Color selectedColor;
  final double selectedBorderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(selectedBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(selectedBorderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? cs.onSecondaryContainer : cs.onSurface,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: isSelected
                          ? cs.onSecondaryContainer
                          : cs.onSurface,
                    ),
                    child: label,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 20,
                    color: cs.onSecondaryContainer,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
