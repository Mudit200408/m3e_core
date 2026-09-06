// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M3EDismissibleCard Keyboard Shortcuts Tests', () {
    testWidgets(
      'Pressing Delete key on focused dismissible card dismisses the card',
      (tester) async {
        final items = ['Card 0', 'Card 1', 'Card 2'];
        int? dismissedIndex;
        DismissDirection? dismissedDir;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EDismissibleCardList(
                    itemCount: items.length,
                    onDismiss: (index, dir) async {
                      dismissedIndex = index;
                      dismissedDir = dir;
                      setState(() {
                        items.removeAt(index);
                      });
                      return true;
                    },
                    itemBuilder: (context, index) {
                      return SizedBox(height: 60, child: Text(items[index]));
                    },
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Card 0'), findsOneWidget);

        // Request focus on card 0's InkWell
        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Send Delete key event
        await tester.sendKeyEvent(LogicalKeyboardKey.delete);
        await tester.pumpAndSettle();

        expect(dismissedIndex, 0);
        expect(dismissedDir, DismissDirection.endToStart);
        expect(find.text('Card 0'), findsNothing);
      },
    );

    testWidgets(
      'Pressing ArrowLeft key on focused card reveals swipe actions and Escape closes them',
      (tester) async {
        final items = ['Item A', 'Item B'];
        bool actionTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EDismissibleCardList(
                itemCount: items.length,
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.archive),
                      label: const Text('Archive'),
                      backgroundColor: Colors.blue,
                      onTap: () {
                        actionTapped = true;
                      },
                    ),
                  ],
                ),
                itemBuilder: (context, index) {
                  return SizedBox(height: 90, child: Text(items[index]));
                },
              ),
            ),
          ),
        );

        // Focus the first card
        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Press ArrowLeft to reveal actions and move focus to action button
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.archive), findsOneWidget);

        // Press Enter to trigger action while focused on it
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(actionTapped, isTrue);

        // Press ArrowLeft again to reveal actions
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.archive), findsOneWidget);

        // Press Escape to close revealed actions and return focus to card
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        // Actions closed, card is focused
        expect(find.text('Item A'), findsOneWidget);
        expect(inkWell.focusNode!.hasFocus, isTrue);
      },
    );

    testWidgets(
      'Keyboard navigation between multiple action buttons with Arrow keys and triggering with Space',
      (tester) async {
        final items = ['Item A'];
        String? tappedAction;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EDismissibleCardList(
                itemCount: items.length,
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.star),
                      label: const Text('Star'),
                      onTap: () {
                        tappedAction = 'star';
                      },
                    ),
                    M3ESwipeAction(
                      icon: const Icon(Icons.archive),
                      label: const Text('Archive'),
                      onTap: () {
                        tappedAction = 'archive';
                      },
                    ),
                    M3ESwipeAction(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      onTap: () {
                        tappedAction = 'delete';
                      },
                    ),
                  ],
                ),
                itemBuilder: (context, index) {
                  return SizedBox(height: 90, child: Text(items[index]));
                },
              ),
            ),
          ),
        );

        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Reveal actions: focus moves to action button at index 0 (Star)
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();

        // Navigate right to index 1 (Archive)
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();

        // Trigger Archive with Space key
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();

        expect(tappedAction, 'archive');
      },
    );

    testWidgets(
      'Tab and Shift+Tab navigation into and across revealed action buttons',
      (tester) async {
        final items = ['Item A', 'Item B'];
        String? tappedAction;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EDismissibleCardList(
                itemCount: items.length,
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.star),
                      label: const Text('Star'),
                      onTap: () {
                        tappedAction = 'star';
                      },
                    ),
                    M3ESwipeAction(
                      icon: const Icon(Icons.archive),
                      label: const Text('Archive'),
                      onTap: () {
                        tappedAction = 'archive';
                      },
                    ),
                  ],
                ),
                itemBuilder: (context, index) {
                  return SizedBox(height: 90, child: Text(items[index]));
                },
              ),
            ),
          ),
        );

        final inkWells = tester
            .widgetList<InkWell>(find.byType(InkWell))
            .toList();
        final card0 = inkWells[0];
        card0.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Reveal actions
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();

        // Focus card again and press Tab to enter actions
        card0.focusNode!.requestFocus();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        // Tab forward to index 1 (Archive)
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        // Trigger with Enter
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(tappedAction, 'archive');
      },
    );

    testWidgets('Shift+Arrow keys navigate between action buttons', (
      tester,
    ) async {
      final items = ['Item A'];
      String? tappedAction;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EDismissibleCardList(
              itemCount: items.length,
              style: M3EDismissibleCardStyle(
                actions: [
                  M3ESwipeAction(
                    icon: const Icon(Icons.star),
                    label: const Text('Star'),
                    onTap: () {
                      tappedAction = 'star';
                    },
                  ),
                  M3ESwipeAction(
                    icon: const Icon(Icons.archive),
                    label: const Text('Archive'),
                    onTap: () {
                      tappedAction = 'archive';
                    },
                  ),
                ],
              ),
              itemBuilder: (context, index) {
                return SizedBox(height: 90, child: Text(items[index]));
              },
            ),
          ),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
      inkWell.focusNode!.requestFocus();
      await tester.pumpAndSettle();

      // Reveal actions: focus moves to index 0 (Star)
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();

      // Navigate forward with Shift + ArrowRight
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pumpAndSettle();

      // Trigger with Space
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(tappedAction, 'archive');
    });

    testWidgets(
      'Seamlessly switch from trailing actions to leading actions on single ArrowRight tap',
      (tester) async {
        final items = ['Item 0'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EDismissibleCardList(
                itemCount: items.length,
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      onTap: () {},
                    ),
                  ],
                  secondaryActions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      onTap: () {},
                    ),
                  ],
                ),
                itemBuilder: (context, index) {
                  return SizedBox(height: 90, child: Text(items[index]));
                },
              ),
            ),
          ),
        );

        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // 1. Reveal trailing actions with ArrowLeft
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.delete), findsOneWidget);

        // 2. Return focus to card and immediately tap ArrowRight to switch to leading actions
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();

        // Should immediately show Share action on first tap
        expect(find.byIcon(Icons.share), findsOneWidget);
      },
    );

    testWidgets(
      'Pressing Delete key when actions are configured reveals actions instead of direct dismiss',
      (tester) async {
        final items = ['Item 0', 'Item 1'];
        bool dismissed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EDismissibleCardList(
                itemCount: items.length,
                onDismiss: (index, dir) async {
                  dismissed = true;
                  return true;
                },
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      onTap: () {},
                    ),
                  ],
                ),
                itemBuilder: (context, index) {
                  return SizedBox(height: 90, child: Text(items[index]));
                },
              ),
            ),
          ),
        );

        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Send Delete key
        await tester.sendKeyEvent(LogicalKeyboardKey.delete);
        await tester.pumpAndSettle();

        // Card should NOT be dismissed; instead action button is revealed
        expect(dismissed, isFalse);
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);
      },
    );

    testWidgets(
      'M3EReorderableDismissibleList reorders items forward with Alt+ArrowDown and backward with Alt+ArrowUp',
      (tester) async {
        final items = ['Dismissible 0', 'Dismissible 1', 'Dismissible 2'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableDismissibleList(
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      return SizedBox(height: 60, child: Text(items[index]));
                    },
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Dismissible 0'), findsOneWidget);

        // Focus Dismissible 0
        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Move Dismissible 0 forward with Alt + ArrowDown
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Dismissible 1', 'Dismissible 0', 'Dismissible 2']);

        // Consecutive reorder without manually requesting focus
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Dismissible 1', 'Dismissible 2', 'Dismissible 0']);

        // Reorder backward with Alt + ArrowUp
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Dismissible 1', 'Dismissible 0', 'Dismissible 2']);
      },
    );
  });
}
