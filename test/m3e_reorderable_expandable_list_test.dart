// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EReorderableExpandableList tests', () {
    testWidgets('renders items and handles expand toggle callback', (
      tester,
    ) async {
      int? toggledIndex;
      bool? toggledExpanded;

      final data = [
        M3EExpandableData(title: 'Card 0', body: const Text('Body 0')),
        M3EExpandableData(title: 'Card 1', body: const Text('Body 1')),
        M3EExpandableData(title: 'Card 2', body: const Text('Body 2')),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: M3EReorderableExpandableList(
                data: data,
                onReorder: (_, _) {},
                onExpansionChanged: (index, isExpanded) {
                  toggledIndex = index;
                  toggledExpanded = isExpanded;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card 0'), findsOneWidget);
      expect(find.text('Card 1'), findsOneWidget);
      expect(find.text('Card 2'), findsOneWidget);

      // Tap Card 1 to expand
      await tester.tap(find.text('Card 1'));
      await tester.pumpAndSettle();

      expect(toggledIndex, equals(1));
      expect(toggledExpanded, isTrue);
      expect(find.text('Body 1'), findsOneWidget);
    });

    testWidgets('builder constructor renders items correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 500,
              child: M3EReorderableExpandableList.builder(
                itemCount: 3,
                headerBuilder: (context, index, progress) =>
                    Text('Header $index'),
                bodyBuilder: (context, index, progress) =>
                    Text('Content $index'),
                onReorder: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Header 0'), findsOneWidget);
      expect(find.text('Header 1'), findsOneWidget);
      expect(find.text('Header 2'), findsOneWidget);
    });

    testWidgets('supports custom dragPlaceholderBuilder and reveals on drag', (
      tester,
    ) async {
      final data = [
        M3EExpandableData(title: 'Item A', body: const Text('Body A')),
        M3EExpandableData(title: 'Item B', body: const Text('Body B')),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: M3EReorderableExpandableList(
                data: data,
                dragPlaceholderBuilder: (context, index, size) {
                  return Container(
                    key: ValueKey('custom_expandable_placeholder_$index'),
                    color: Colors.amber,
                  );
                },
                onReorder: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item A'), findsOneWidget);

      // Long press Item A to start reorder drag
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Item A')),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.byKey(const ValueKey('custom_expandable_placeholder_0')),
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
              height: 500,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableExpandableList(
                    data: items
                        .map(
                          (title) => M3EExpandableData(
                            title: title,
                            body: Text('Body for $title'),
                          ),
                        )
                        .toList(),
                    onReorder: (from, to) {
                      reorderFrom = from;
                      reorderTo = to;
                      setState(() {
                        final item = items.removeAt(from);
                        final target = to > from ? to - 1 : to;
                        items.insert(target, item);
                      });
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
      expect(find.text('Gamma'), findsOneWidget);

      // Drag Alpha downwards past Gamma
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Alpha')),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final gammaCenter = tester.getCenter(find.text('Gamma'));
      await gesture.moveTo(gammaCenter + const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(reorderFrom, equals(0));
      expect(reorderTo, equals(3));
      expect(items, equals(['Beta', 'Gamma', 'Alpha']));
    });

    testWidgets('preserves expanded state across reordering', (tester) async {
      final items = ['First', 'Second', 'Third'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableExpandableList(
                    initiallyExpanded: const {0},
                    data: items
                        .map(
                          (title) => M3EExpandableData(
                            title: title,
                            body: Text('Body for $title'),
                          ),
                        )
                        .toList(),
                    onReorder: (from, to) {
                      setState(() {
                        final item = items.removeAt(from);
                        final target = to > from ? to - 1 : to;
                        items.insert(target, item);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially 'First' (index 0) is expanded
      expect(find.text('Body for First'), findsOneWidget);

      // Drag 'First' down to index 2
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('First')),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final thirdCenter = tester.getCenter(find.text('Third'));
      await gesture.moveTo(thirdCenter + const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.up();
      await tester.pumpAndSettle();

      // After reorder, 'First' should still be expanded
      expect(items, equals(['Second', 'Third', 'First']));
      expect(find.text('Body for First'), findsOneWidget);
    });

    testWidgets('renders emptyBuilder when itemCount is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: M3EReorderableExpandableList(
                data: const [],
                emptyBuilder: (context) => const Text('No expandables here'),
                onReorder: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('No expandables here'), findsOneWidget);
    });

    testWidgets(
      'reordering non-expanded item when another item is expanded preserves expanded item position',
      (tester) async {
        final items = ['Alpha', 'Beta', 'Gamma'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 600,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return M3EReorderableExpandableList(
                      initiallyExpanded: const {1},
                      data: items
                          .map(
                            (title) => M3EExpandableData(
                              title: title,
                              body: Text('Body for $title'),
                            ),
                          )
                          .toList(),
                      onReorder: (from, to) {
                        setState(() {
                          final item = items.removeAt(from);
                          final target = to > from ? to - 1 : to;
                          items.insert(target, item);
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Initially 'Beta' (index 1) is expanded
        expect(find.text('Body for Beta'), findsOneWidget);

        // Drag 'Alpha' (index 0, collapsed) down below Gamma
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Alpha')),
        );
        await tester.pump(const Duration(milliseconds: 300));

        final gammaCenter = tester.getCenter(find.text('Gamma'));
        await gesture.moveTo(gammaCenter + const Offset(0, 40));
        await tester.pump(const Duration(milliseconds: 100));

        await gesture.up();
        await tester.pumpAndSettle();

        // After reorder, list is [Beta, Gamma, Alpha] and Beta is still expanded at index 0
        expect(items, equals(['Beta', 'Gamma', 'Alpha']));
        expect(find.text('Body for Beta'), findsOneWidget);
      },
    );

    testWidgets('buildDefaultDragHandles renders drag handles in header', (
      tester,
    ) async {
      final data = [
        M3EExpandableData(
          title: 'Handle Card',
          body: const Text('Handle Body'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: M3EReorderableExpandableList(
                data: data,
                buildDefaultDragHandles: true,
                onReorder: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.drag_handle_rounded), findsOneWidget);
    });

    testWidgets(
      'placeholder maintains correct gap and dimensions at first and last slots when item is expanded',
      (tester) async {
        const testGap = 6.0;
        final style = const M3EExpandableStyle(
          gap: testGap,
          headerPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );

        final data = List.generate(
          4,
          (i) => M3EExpandableData(title: 'Item $i', body: Text('Body for $i')),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 800,
                width: 500,
                child: M3EReorderableExpandableList(
                  data: data,
                  style: style,
                  initiallyExpanded: const {0},
                  dragPlaceholderColor: Colors.purple,
                  listPadding: const EdgeInsets.all(12),
                  onReorder: (_, _) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Drag item 0 (initially expanded) around slot 0
        final item0Finder = find.byKey(
          ValueKey('m3e_exp_item_${data[0].title}'),
        );
        final gesture = await tester.startGesture(
          tester.getCenter(item0Finder),
        );
        await tester.pump(const Duration(milliseconds: 300));

        final pFinder = find.byWidgetPredicate(
          (w) =>
              w is Container &&
              (w.decoration as BoxDecoration?)?.color == Colors.purple,
        );
        expect(pFinder, findsOneWidget);

        final pBox0 = tester.renderObject(pFinder) as RenderBox;
        final pTop0 = pBox0.localToGlobal(Offset.zero).dy;
        final pBottom0 = pTop0 + pBox0.size.height;

        // Slot 1 card (Item 1)
        final item1Card = find.descendant(
          of: find.byKey(ValueKey('m3e_exp_item_${data[1].title}')),
          matching: find.byType(Material),
        );
        final item1Box = tester.renderObject(item1Card.first) as RenderBox;
        final item1Top = item1Box.localToGlobal(Offset.zero).dy;

        // Gap between placeholder bottom and item 1 top must equal testGap
        expect((item1Top - pBottom0 - testGap).abs(), lessThanOrEqualTo(0.5));

        // 2. Drag down to slot 3 (bottom)
        final item3Finder = find.byKey(
          ValueKey('m3e_exp_item_${data[3].title}'),
        );
        final item3Box = tester.renderObject(item3Finder) as RenderBox;
        final item3Center = item3Box.localToGlobal(
          Offset(item3Box.size.width / 2, item3Box.size.height / 2),
        );
        await gesture.moveTo(item3Center + const Offset(0, 40));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        final pBox3 = tester.renderObject(pFinder) as RenderBox;
        final pTop3 = pBox3.localToGlobal(Offset.zero).dy;

        // Visual neighbor above placeholder at slot 3 is Item 3 (displaced to slot 2)
        final item3DisplacedCard = find.descendant(
          of: find.byKey(ValueKey('m3e_exp_item_${data[3].title}')),
          matching: find.byType(Material),
        );
        final item3DisplacedBox =
            tester.renderObject(item3DisplacedCard.first) as RenderBox;
        final item3DisplacedBottom =
            item3DisplacedBox.localToGlobal(Offset.zero).dy +
            item3DisplacedBox.size.height;

        // Gap between neighbor card above and placeholder top must equal testGap
        expect(
          (pTop3 - item3DisplacedBottom - testGap).abs(),
          lessThanOrEqualTo(1.0),
        );

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'animates collapse when dragging an initially expanded item and animates expand on settling',
      (tester) async {
        final data = List.generate(
          3,
          (i) => M3EExpandableData(title: 'Item $i', body: Text('Body for $i')),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 600,
                width: 400,
                child: M3EReorderableExpandableList(
                  data: data,
                  initiallyExpanded: const {0},
                  onReorder: (_, _) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Body for 0'), findsOneWidget);

        // Trigger drag on item 0
        final item0Finder = find.byKey(
          ValueKey('m3e_exp_item_${data[0].title}'),
        );
        final gesture = await tester.startGesture(
          tester.getCenter(item0Finder),
        );
        await tester.pump(const Duration(milliseconds: 250)); // triggers drag

        // The floating proxy is created and the body is still rendered
        final proxyFinder = find.byKey(
          const ValueKey('proxy_expandable_item_0'),
        );
        expect(proxyFinder, findsOneWidget);
        expect(find.text('Body for 0'), findsOneWidget);

        // Pump frames to verify collapse progress
        await tester.pump(const Duration(milliseconds: 60));
        // Still animating collapse
        expect(proxyFinder, findsOneWidget);

        // Pump until collapse animation finishes
        await tester.pump(const Duration(milliseconds: 500));

        // Release drag and settle
        await gesture.up();
        await tester.pumpAndSettle();

        // After settling at its target position, the card re-expands
        expect(find.text('Body for 0'), findsOneWidget);
      },
    );

    testWidgets(
      'reordering item to last position triggers expand animation and stays visible',
      (tester) async {
        final items = ['Section 0', 'Section 1', 'Section 2', 'Section 3'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    height: 800,
                    width: 400,
                    child: M3EReorderableExpandableList(
                      data: items
                          .map(
                            (t) => M3EExpandableData(
                              title: t,
                              body: SizedBox(
                                height: 120,
                                child: Text('Body of $t'),
                              ),
                            ),
                          )
                          .toList(),
                      keyBuilder: (index) => ValueKey(items[index]),
                      allowMultipleExpanded: true,
                      initiallyExpanded: const {0, 1, 2, 3},
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          final item = items.removeAt(oldIndex);
                          final target = newIndex > oldIndex
                              ? newIndex - 1
                              : newIndex;
                          items.insert(target, item);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Drag item 0 down to the bottom past section 3
        final item0Finder = find.text('Section 0');
        final gesture = await tester.startGesture(
          tester.getCenter(item0Finder),
        );
        await tester.pump(const Duration(milliseconds: 250)); // triggers drag

        final item3Finder = find.text('Section 3');
        await gesture.moveTo(
          tester.getCenter(item3Finder) + const Offset(0, 50),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Release drag
        await gesture.up();

        // Pump settling animation
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // After settling, verify item 0 is now at index 3 and expands
        await tester.pumpAndSettle();

        expect(items.last, equals('Section 0'));
        expect(find.text('Body of Section 0'), findsOneWidget);
      },
    );

    testWidgets(
      'animates collapse when tapping an expanded card in reorderable list',
      (tester) async {
        final data = [
          M3EExpandableData(title: 'Card 0', body: const Text('Body 0')),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 600,
                child: M3EReorderableExpandableList(
                  data: data,
                  initiallyExpanded: const {0},
                  onReorder: (_, _) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Body 0'), findsOneWidget);

        // Tap Card 0 to collapse
        await tester.tap(find.text('Card 0'));
        // Advance slightly - animation should be in progress
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Body 0'), findsOneWidget);

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'reordering last item to 1st position when all cards are expanded snaps accurately',
      (tester) async {
        final items = ['Card A', 'Card B', 'Card C'];
        int? reorderFrom;
        int? reorderTo;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    height: 800,
                    width: 400,
                    child: M3EReorderableExpandableList(
                      data: items
                          .map(
                            (title) => M3EExpandableData(
                              title: title,
                              body: SizedBox(
                                height: 80,
                                child: Text('Body for $title'),
                              ),
                            ),
                          )
                          .toList(),
                      initiallyExpanded: const {0, 1, 2},
                      allowMultipleExpanded: true,
                      onReorder: (from, to) {
                        reorderFrom = from;
                        reorderTo = to;
                        setState(() {
                          final item = items.removeAt(from);
                          final target = to > from ? to - 1 : to;
                          items.insert(target, item);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Body for Card A'), findsOneWidget);
        expect(find.text('Body for Card B'), findsOneWidget);
        expect(find.text('Body for Card C'), findsOneWidget);

        // Drag Card C (last item, index 2) to slot 0 (1st position)
        final cardCFinder = find.text('Card C');
        final gesture = await tester.startGesture(
          tester.getCenter(cardCFinder),
        );
        await tester.pump(const Duration(milliseconds: 250));

        final cardAFinder = find.text('Card A');
        await gesture.moveTo(
          tester.getCenter(cardAFinder) - const Offset(0, 10),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Release drag and verify snap settling
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        expect(reorderFrom, equals(2));
        expect(reorderTo, equals(0));
        expect(items, equals(['Card C', 'Card A', 'Card B']));
        expect(find.text('Body for Card C'), findsOneWidget);
      },
    );
  });
}
