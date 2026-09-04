// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EReorderableDismissibleList tests', () {
    testWidgets('renders items and handles tap callback', (tester) async {
      int? tappedIndex;
      final items = ['Card 0', 'Card 1', 'Card 2'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 500,
              child: M3EReorderableDismissibleList(
                itemCount: items.length,
                keyBuilder: (index) => ValueKey('card_${items[index]}'),
                onTap: (index) => tappedIndex = index,
                onReorder: (_, _) {},
                itemBuilder: (context, index) {
                  return SizedBox(height: 60, child: Text(items[index]));
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);
      expect(find.text('Card 1'), findsOneWidget);
      expect(find.text('Card 2'), findsOneWidget);

      await tester.tap(find.text('Card 1'));
      await tester.pump();
      expect(tappedIndex, equals(1));
    });

    testWidgets('supports custom placeholder and reveals on long-press drag', (
      tester,
    ) async {
      final items = ['Item A', 'Item B'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: M3EReorderableDismissibleList(
                itemCount: items.length,
                keyBuilder: (index) => ValueKey(items[index]),
                dragPlaceholderBuilder: (context, index, size) {
                  return Container(
                    key: ValueKey('custom_placeholder_$index'),
                    color: Colors.green,
                  );
                },
                onReorder: (_, _) {},
                itemBuilder: (context, index) {
                  return SizedBox(height: 60, child: Text(items[index]));
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item A'), findsOneWidget);

      // Long press Item A to begin reorder drag and reveal placeholder
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Item A')),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.byKey(const ValueKey('custom_placeholder_0')),
        findsOneWidget,
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('reorders items and calls onReorder', (tester) async {
      final items = ['Alpha', 'Beta', 'Gamma'];
      int reorderFrom = -1;
      int reorderTo = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableDismissibleList(
                    itemCount: items.length,
                    keyBuilder: (index) => ValueKey(items[index]),
                    onReorder: (oldIndex, newIndex) {
                      reorderFrom = oldIndex;
                      reorderTo = newIndex;
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 60,
                        child: Center(child: Text(items[index])),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      // Long press Alpha and drag past Beta
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Alpha')),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Drag down past item 1 (60px height + 4px gap)
      await gesture.moveBy(const Offset(0, 75));
      await tester.pump(const Duration(milliseconds: 50));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(reorderFrom, equals(0));
      expect(reorderTo, equals(2));
      expect(items[0], equals('Beta'));
      expect(items[1], equals('Alpha'));
    });

    testWidgets('swipes horizontally to dismiss card and calls onDismiss', (
      tester,
    ) async {
      final items = ['Keep', 'Dismiss Me'];
      int? dismissedIndex;
      DismissDirection? dismissedDir;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableDismissibleList(
                    itemCount: items.length,
                    keyBuilder: (index) => ValueKey(items[index]),
                    onDismiss: (index, direction) async {
                      dismissedIndex = index;
                      dismissedDir = direction;
                      setState(() {
                        items.removeAt(index);
                      });
                      return true;
                    },
                    onReorder: (_, _) {},
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 60,
                        child: Center(child: Text(items[index])),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Dismiss Me'), findsOneWidget);

      // Horizontal swipe to dismiss rightward
      await tester.drag(find.text('Dismiss Me'), const Offset(300, 0));
      await tester.pump(const Duration(milliseconds: 100));

      expect(dismissedIndex, equals(1));
      expect(dismissedDir, equals(DismissDirection.startToEnd));

      await tester.pumpAndSettle();
      expect(find.text('Dismiss Me'), findsNothing);
      expect(find.text('Keep'), findsOneWidget);
    });

    testWidgets('renders emptyBuilder when itemCount is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EReorderableDismissibleList(
              itemCount: 0,
              emptyBuilder: (context) => const Text('Empty Inbox'),
              onReorder: (_, _) {},
              itemBuilder: (context, index) => const Text('Item'),
            ),
          ),
        ),
      );

      expect(find.text('Empty Inbox'), findsOneWidget);
    });

    testWidgets('renders drag handles when buildDefaultDragHandles is true', (
      tester,
    ) async {
      final items = ['Card 0', 'Card 1'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: M3EReorderableDismissibleList(
                itemCount: items.length,
                buildDefaultDragHandles: true,
                onReorder: (_, _) {},
                itemBuilder: (context, index) => Text(items[index]),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.drag_handle_rounded), findsNWidgets(2));
    });

    testWidgets('applies pressScale on pointer down', (tester) async {
      final items = ['Press Item'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: M3EReorderableDismissibleList(
                itemCount: items.length,
                style: const M3EDismissibleCardStyle(pressedScale: 0.95),
                onReorder: (_, _) {},
                itemBuilder: (context, index) => Text(items[index]),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Press Item'), findsOneWidget);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Press Item')),
      );
      await tester.pump(const Duration(milliseconds: 50));

      final transformFinder = find.ancestor(
        of: find.text('Press Item'),
        matching: find.byType(Transform),
      );
      expect(transformFinder, findsWidgets);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
