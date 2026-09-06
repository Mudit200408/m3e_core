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

  group('M3ESegmentedItem & Reorderable Keyboard Shortcuts Tests', () {
    testWidgets('Pressing Enter/Space invokes onTap', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedItem(
              index: 0,
              position: M3ESegmentedItemPosition.single,
              outerRadius: 24.0,
              innerRadius: 4.0,
              onTap: (i) {
                tappedIndex = i;
              },
              child: const Text('Item 0'),
            ),
          ),
        ),
      );

      // Focus item
      final itemFinder = find.descendant(
        of: find.byType(M3ESegmentedItem).first,
        matching: find.byType(Focus),
      );
      tester.widget<Focus>(itemFinder.first).focusNode!.requestFocus();
      await tester.pumpAndSettle();

      // Press Enter to trigger onTap
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(tappedIndex, 0);
    });

    testWidgets('Pressing Alt+ArrowDown / Alt+ArrowUp invokes onReorderKey', (
      tester,
    ) async {
      int? reorderedIndex;
      bool? movedForward;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedItem(
              index: 1,
              position: M3ESegmentedItemPosition.middle,
              outerRadius: 24.0,
              innerRadius: 4.0,
              onReorderKey: (index, forward) {
                reorderedIndex = index;
                movedForward = forward;
              },
              child: const Text('Item 1'),
            ),
          ),
        ),
      );

      // Focus item
      final itemFinder = find.descendant(
        of: find.byType(M3ESegmentedItem).first,
        matching: find.byType(Focus),
      );
      tester.widget<Focus>(itemFinder.first).focusNode!.requestFocus();
      await tester.pumpAndSettle();

      // Simulate Alt key down
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await tester.pumpAndSettle();

      expect(reorderedIndex, 1);
      expect(movedForward, isTrue);

      // Simulate Alt + ArrowUp
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await tester.pumpAndSettle();

      expect(reorderedIndex, 1);
      expect(movedForward, isFalse);
    });

    testWidgets(
      'M3EReorderableSegmentedList reorders items forward with Alt+ArrowDown',
      (tester) async {
        final items = ['Item 0', 'Item 1', 'Item 2'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableSegmentedList.builder(
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      return Text(items[index]);
                    },
                  );
                },
              ),
            ),
          ),
        );

        // Focus Item 0
        final itemFinder = find.descendant(
          of: find.byType(M3ESegmentedItem).first,
          matching: find.byType(Focus),
        );
        tester.widget<Focus>(itemFinder.first).focusNode!.requestFocus();
        await tester.pumpAndSettle();

        // Move Item 0 down (Alt + ArrowDown)
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        // Item 0 should now be at index 1
        expect(items, ['Item 1', 'Item 0', 'Item 2']);

        // Next reorder key (without manually requesting focus) moves Item 0 again from index 1 to index 2
        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        await tester.pumpAndSettle();

        expect(items, ['Item 1', 'Item 2', 'Item 0']);
      },
    );
  });
}
