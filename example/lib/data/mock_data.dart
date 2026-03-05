import 'package:flutter/material.dart';
import 'package:m3e_core/m3e_core.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared swipe style
// ─────────────────────────────────────────────────────────────────────────────

M3EDismissibleCardStyle getDismissStyle() => M3EDismissibleCardStyle(
  hapticOnTap: 1,
  hapticOnThreshold: 1,
  backgroundBorderRadius: 100,
  secondaryBackgroundBorderRadius: 100,
  collapseSpeed: 60,
  dismissHapticStream: true,
  dismissThreshold: 0.3,
  background: Container(
    color: const Color.fromARGB(255, 80, 218, 87),
    alignment: Alignment.center,
    child: const Icon(Icons.archive, color: Colors.white, size: 28),
  ),
  secondaryBackground: Container(
    color: Colors.red.shade600,
    alignment: Alignment.center,
    child: const Icon(Icons.delete, color: Colors.white, size: 28),
  ),
);

// ─────────────────────────────────────────────────────────────────────────────
// Shared item data model
// ─────────────────────────────────────────────────────────────────────────────

class EmailItem {
  final int id;
  final String sender;
  final String subject;
  final String preview;
  final String time;
  final bool unread;

  const EmailItem({
    required this.id,
    required this.sender,
    required this.subject,
    required this.preview,
    required this.time,
    this.unread = false,
  });
}

// A pool of 200 pre-built items. Lazy-load examples page through this.
final List<EmailItem> allItems = List.generate(200, (i) {
  const senders = [
    'Alice Johnson',
    'Bob Martinez',
    'Carol White',
    'David Kim',
    'Eva Müller',
    'Frank Li',
    'Grace Park',
    'Henry Brown',
  ];
  const subjects = [
    'Meeting rescheduled',
    'Invoice',
    'Quick question',
    'Project update',
    'Weekend plans?',
    'New feature request',
    'Follow-up needed',
    'Reminder: deadline',
  ];
  const previews = [
    'Just wanted to let you know that the meeting has been moved…',
    'Please find attached the invoice for last month\'s work…',
    'Hey, do you have a minute to chat about the design?',
    'Here\'s the latest status on the Q3 roadmap items…',
    'A few of us are planning a hike on Saturday morning…',
    'I had an idea that could really improve the onboarding flow…',
    'Following up on my previous message from last week…',
    'Don\'t forget — the deliverable is due this Friday at 5pm…',
  ];
  return EmailItem(
    id: i + 1,
    sender: senders[i % senders.length],
    subject: '${subjects[i % subjects.length]} (#${i + 1})',
    preview: previews[i % previews.length],
    time:
        '${(i % 12) + 1}:${(i * 7 % 60).toString().padLeft(2, '0')} ${i % 2 == 0 ? 'AM' : 'PM'}',
    unread: i % 3 == 0,
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Shared Dropdown Data
// ─────────────────────────────────────────────────────────────────────────────

final List<M3EDropdownItem<String>> fruitItems = [
  M3EDropdownItem(label: 'Apple', value: 'apple'),
  M3EDropdownItem(label: 'Banana', value: 'banana'),
  M3EDropdownItem(label: 'Cherry', value: 'cherry'),
  M3EDropdownItem(label: 'Date', value: 'date'),
  M3EDropdownItem(label: 'Elderberry', value: 'elderberry'),
  M3EDropdownItem(label: 'Fig', value: 'fig'),
  M3EDropdownItem(label: 'Grape', value: 'grape'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Shared Expandable List Emails
// ─────────────────────────────────────────────────────────────────────────────

const List<(String, String)> expandableEmails = [
  (
    'Team standup notes',
    'Here are the key points from today\'s standup meeting. We discussed sprint progress, blockers, and upcoming deadlines for the Q3 release.\nSarah mentioned the API integration is 80% complete, while Dave is still investigating the memory leak in the navigation stack.\nWe need to finalize the PR reviews by EOD Thursday to stay on track for the staging deployment.\nPlease update your Jira tickets before the next sync on Monday morning.',
  ),
  (
    'Design review feedback',
    'Attached are the design review comments. Please update the card corner radius to 24dp for outer and 4dp for inner as per the M3 Expressive spec.\nThe current elevation shadows are too harsh on dark mode and need to be softened using the new design system tokens.\nSpecifically, check the contrast ratio on the disabled state of the dropdown chips to ensure WCAG AA compliance.\nWe also need to align the padding of the "more" badge with the primary action items for visual consistency.',
  ),
  (
    'Build pipeline fix',
    'The CI build failure has been resolved. The issue was a missing dependency in the pubspec.yaml that was accidentally stripped during the last merge.\nI have also optimized the Docker layer caching which should reduce our total build time by approximately 45 seconds per run.\nPlease perform a "flutter clean" and "flutter pub get" to ensure your local environment matches the remote build state.\nIf you encounter any further 403 errors during the fetching phase, please reach out to the DevOps channel immediately.',
  ),
  (
    'Lunch plan tomorrow',
    'Anyone up for trying that new ramen place on 5th? Thinking 12:30 PM works best to beat the rush from the neighboring offices.\nI checked the menu and they have several vegetarian and gluten-free options available for those with dietary restrictions.\nI can make a reservation for 6-8 people if we get a headcount by the end of today\'s afternoon break.\nOtherwise, we might end up waiting in line for 30 minutes, which would eat into our scheduled sprint planning session.',
  ),
  (
    'Quarterly planning',
    'The Q4 planning doc is ready for review. Key initiatives include the new dropdown component and expandable list widget for the mobile SDK.\nWe are prioritizing developer experience improvements, specifically around the documentation and auto-generated code examples.\nProduct management has signaled that we need to increase our velocity on the "Expressive" design implementation to meet the holiday deadline.\nPlease leave your comments and suggestions directly in the shared document by Friday at noon.',
  ),
  (
    'Release v2.1 checklist',
    'Final checklist before release: 1) Run full test suite across all supported platforms (iOS, Android, Web), 2) Update CHANGELOG with latest bug fixes.\n3) Bump version in pubspec.yaml and verify the build number, 4) Tag the release in Git and trigger the production deployment pipeline.\nWe also need to verify that the analytics event tracking is firing correctly for the new onboarding flow.\nOnce the smoke tests pass on production, we will send out the internal announcement to the stakeholders.',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Shared card UI & Helpers
// ─────────────────────────────────────────────────────────────────────────────

Widget buildEmailTile(BuildContext context, EmailItem item) {
  final cs = Theme.of(context).colorScheme;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: cs.primaryContainer,
        child: Text(
          item.sender[0],
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.sender,
                    style: TextStyle(
                      fontWeight: item.unread
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  item.time,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              item.subject,
              style: TextStyle(
                fontSize: 13,
                fontWeight: item.unread ? FontWeight.w600 : FontWeight.normal,
                color: cs.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item.preview,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      if (item.unread)
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 2),
          child: CircleAvatar(radius: 4, backgroundColor: cs.primary),
        ),
    ],
  );
}

void showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}

Widget buildSectionHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Widget lazyLoadBanner(BuildContext context, int loaded, int total) {
  final cs = Theme.of(context).colorScheme;
  return Container(
    color: cs.secondaryContainer,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: cs.onSecondaryContainer),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Lazy loading: $loaded / $total items loaded — scroll to load more',
            style: TextStyle(fontSize: 12, color: cs.onSecondaryContainer),
          ),
        ),
      ],
    ),
  );
}

SliverToBoxAdapter sliverHeader(BuildContext context, String title) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: buildSectionHeader(context, title),
    ),
  );
}

SliverToBoxAdapter sliverGap() =>
    const SliverToBoxAdapter(child: SizedBox(height: 8));

class LoadingTile extends StatelessWidget {
  const LoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading more…',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class SliderRow extends StatelessWidget {
  const SliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.format,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String Function(double) format;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: cs.onSurface),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: cs.primary,
              inactiveTrackColor: cs.surfaceContainerHighest,
              thumbColor: cs.primary,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            format(value),
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}
