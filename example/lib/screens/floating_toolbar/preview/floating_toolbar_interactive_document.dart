// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import '../models/floating_toolbar_models.dart';

class FloatingToolbarInteractiveDocument extends StatelessWidget {
  const FloatingToolbarInteractiveDocument({
    super.key,
    required this.effectiveContentPreset,
    required this.bottomNavIndex,
    required this.enableScrollBehavior,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isHighlight,
    required this.textAlign,
    required this.activeTextColor,
  });

  final ToolbarContentPreset effectiveContentPreset;
  final int bottomNavIndex;
  final bool enableScrollBehavior;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isHighlight;
  final TextAlign textAlign;
  final Color activeTextColor;

  Widget _buildNavPage({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String badge,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      key: ValueKey(title),
      elevation: 0,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: cs.primaryContainer,
              child: Icon(icon, size: 32, color: cs.onPrimaryContainer),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String label, bool active) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? cs.primary.withValues(alpha: 0.15)
            : cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? cs.primary : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        '$label: ${active ? "ON" : "OFF"}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: active ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (effectiveContentPreset == ToolbarContentPreset.bottomNav) {
      final navPages = [
        _buildNavPage(
          context: context,
          icon: Icons.home_rounded,
          title: 'Home Dashboard',
          description:
              'Expressive active dashboard: track active review cycles, memory retention trends, and today’s goals.',
          badge: 'Tab 1 Active',
        ),
        _buildNavPage(
          context: context,
          icon: Icons.search_rounded,
          title: 'Knowledge Search',
          description:
              'Instant AI vector search across all cards, lecture notes, voice recordings, and topics.',
          badge: 'Tab 2 Active',
        ),
        _buildNavPage(
          context: context,
          icon: Icons.favorite_rounded,
          title: 'Curated Library',
          description:
              'Your bookmarked cards, master decks, high-yield summaries, and saved AI prompts.',
          badge: 'Tab 3 Active',
        ),
        _buildNavPage(
          context: context,
          icon: Icons.person_rounded,
          title: 'Account & Settings',
          description:
              'Customize AI models, spaced repetition intervals, theme settings, and sync preferences.',
          badge: 'Tab 4 Active',
        ),
      ];

      return ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: navPages[bottomNavIndex],
          ),
          if (enableScrollBehavior) ...[
            const SizedBox(height: 16),
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Card(
                  elevation: 0,
                  color: cs.surfaceContainerLow,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('Scrollable Study Material ${index + 1}'),
                    subtitle: const Text(
                      'Scroll up or down to observe the bottom nav floating bar slide off-screen.',
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 100),
        ],
      );
    }

    // Default: Rich Text Editor
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Card(
          elevation: 0,
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: cs.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Interactive Document Canvas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Live Formatting Preview',
                        style: TextStyle(fontSize: 11, color: cs.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  'Material 3 Expressive Toolbar',
                  textAlign: textAlign,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: TextDecoration.combine([
                      if (isUnderline) TextDecoration.underline,
                    ]),
                    backgroundColor: isHighlight
                        ? Colors.amber.withValues(alpha: 0.4)
                        : null,
                    color: activeTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Floating toolbars provide rapid access to frequently used formatting controls. '
                  'Tap any action on the floating bar below to test live interactive state updates, '
                  'or toggle expansion to observe the spring physics unrolling effect.',
                  textAlign: textAlign,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: isUnderline ? TextDecoration.underline : null,
                    backgroundColor: isHighlight
                        ? Colors.amber.withValues(alpha: 0.3)
                        : null,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statusBadge(context, 'Bold', isBold),
                    _statusBadge(context, 'Italic', isItalic),
                    _statusBadge(context, 'Underline', isUnderline),
                    _statusBadge(context, 'Highlight', isHighlight),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (enableScrollBehavior) ...[
          const SizedBox(height: 16),
          ...List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 0,
                color: cs.surfaceContainerLow,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Scrollable Paragraph ${index + 1}'),
                  subtitle: const Text(
                    'Scroll up or down to observe the toolbar exiting off-screen smoothly with spring decay.',
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 100),
      ],
    );
  }
}
