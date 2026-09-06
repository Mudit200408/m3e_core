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

  group('M3EExpandable Keyboard Shortcuts Tests', () {
    testWidgets(
      'Pressing Enter or Space toggles expansion; ArrowRight expands and ArrowLeft collapses',
      (tester) async {
        bool isExpanded = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EExpandableItem(
                    index: 0,
                    totalCount: 1,
                    isExpanded: isExpanded,
                    onToggle: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    decoration: const M3EExpandableStyle(),
                    expandMotion: M3EMotion.expressiveSpatialFast,
                    collapseMotion: M3EMotion.expressiveSpatialFast,
                    headerBuilder: (context, index, progress) =>
                        const Text('Expandable Header'),
                    bodyBuilder: (context, index, progress) =>
                        const Text('Expandable Body Content'),
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Expandable Header'), findsOneWidget);

        // Focus the header InkWell
        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Initially collapsed
        expect(isExpanded, isFalse);

        // Press Enter to toggle expand
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(isExpanded, isTrue);

        // Press Enter to toggle collapse
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(isExpanded, isFalse);

        // Press ArrowRight to expand
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(isExpanded, isTrue);

        // Press ArrowLeft to collapse
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(isExpanded, isFalse);
      },
    );

    testWidgets(
      'M3EReorderableExpandableList reorders items forward with Alt+ArrowDown and backward with Alt+ArrowUp',
      (tester) async {
        final items = ['Expandable 0', 'Expandable 1', 'Expandable 2'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableExpandableList.builder(
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                      });
                    },
                    headerBuilder: (context, index, progress) =>
                        Text(items[index]),
                    bodyBuilder: (context, index, progress) =>
                        Text('Body of ${items[index]}'),
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Expandable 0'), findsOneWidget);

        // Focus Expandable 0
        final inkWell = tester.widget<InkWell>(find.byType(InkWell).first);
        inkWell.focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Move Expandable 0 forward with Alt + ArrowDown
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Expandable 1', 'Expandable 0', 'Expandable 2']);

        // Consecutive reorder without manually requesting focus
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Expandable 1', 'Expandable 2', 'Expandable 0']);

        // Reorder backward with Alt + ArrowUp
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Expandable 1', 'Expandable 0', 'Expandable 2']);
      },
    );

    testWidgets('Expanded state follows item during keyboard reorder', (
      tester,
    ) async {
      final items = ['Item 0', 'Item 1', 'Item 2'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return M3EReorderableExpandableList.builder(
                  itemCount: items.length,
                  initiallyExpanded: const {0},
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = items.removeAt(oldIndex);
                      items.insert(newIndex, item);
                    });
                  },
                  headerBuilder: (context, index, progress) =>
                      Text(items[index]),
                  bodyBuilder: (context, index, progress) =>
                      Text('Body of ${items[index]}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Body of Item 0'), findsOneWidget);
      expect(find.text('Body of Item 1'), findsNothing);

      // Focus Item 0 (at index 0)
      final inkWells = tester
          .widgetList<InkWell>(find.byType(InkWell))
          .toList();
      inkWells[0].focusNode!.requestFocus();
      await tester.pumpAndSettle();

      // Reorder Item 0 forward to index 1 with Alt + ArrowDown
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await tester.pumpAndSettle();

      // Item 0 is now at index 1 and should still be the expanded item
      expect(items, ['Item 1', 'Item 0', 'Item 2']);
      expect(find.text('Body of Item 0'), findsOneWidget);
      expect(find.text('Body of Item 1'), findsNothing);
    });
  });
}
