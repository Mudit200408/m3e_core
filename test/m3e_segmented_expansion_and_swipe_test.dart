import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EExpandableSegmentedItem tests', () {
    testWidgets('renders collapsed header and reveals children when expanded', (
      tester,
    ) async {
      bool isExpanded = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return M3EExpandableSegmentedItem(
                  index: 0,
                  totalCount: 3,
                  isExpanded: isExpanded,
                  onToggle: () {
                    setState(() => isExpanded = !isExpanded);
                  },
                  header: const Text('Parent Header'),
                  children: const [Text('Child Item 1'), Text('Child Item 2')],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Parent Header'), findsOneWidget);
      // Tap to expand
      await tester.tap(find.text('Parent Header'));
      await tester.pumpAndSettle();

      expect(find.text('Child Item 1'), findsOneWidget);
      expect(find.text('Child Item 2'), findsOneWidget);
    });

    testWidgets('triggers onChildTap and applies child selection', (
      tester,
    ) async {
      int? tappedIndex;
      final selectedChildren = <int>{0};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return M3EExpandableSegmentedItem(
                  index: 0,
                  totalCount: 1,
                  isExpanded: true,
                  onToggle: () {},
                  selectedChildIndices: selectedChildren,
                  onChildTap: (idx) {
                    tappedIndex = idx;
                    setState(() {
                      if (selectedChildren.contains(idx)) {
                        selectedChildren.remove(idx);
                      } else {
                        selectedChildren.add(idx);
                      }
                    });
                  },
                  header: const Text('Parent Header'),
                  children: const [Text('Child 1'), Text('Child 2')],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Child 2'), findsOneWidget);

      await tester.tap(find.text('Child 2'));
      await tester.pumpAndSettle();

      expect(tappedIndex, equals(1));
      expect(selectedChildren.contains(1), isTrue);
    });

    testWidgets('collapses with bouncy header animation without overflow', (
      tester,
    ) async {
      bool isExpanded = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return M3EExpandableSegmentedItem(
                  index: 0,
                  totalCount: 1,
                  isExpanded: isExpanded,
                  onToggle: () {
                    setState(() => isExpanded = !isExpanded);
                  },
                  header: const Text('Parent Header'),
                  children: const [Text('Child 1'), Text('Child 2')],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Child 1'), findsOneWidget);

      // Trigger collapse
      await tester.tap(find.text('Parent Header'));
      // Step through intermediate frames of the spring collapse to verify no overflow exceptions
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(tester.takeException(), isNull);
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Parent Header'), findsOneWidget);
    });
  });

  group('M3ESwipeAction tests', () {
    testWidgets('renders action button and triggers callback', (tester) async {
      bool actionTriggered = false;

      final action = M3ESwipeAction(
        icon: const Icon(Icons.share_rounded),
        label: const Text('Share'),
        isPrimary: true,
        onTap: () {
          actionTriggered = true;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return action.buildButton(context, onTriggered: null);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.share_rounded), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(actionTriggered, isTrue);
    });
  });

  group('M3EDismissibleCardColumn with swipe actions', () {
    testWidgets('reveals actions on drag and stays anchored', (tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: M3EDismissibleCardColumn(
                itemCount: 2,
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.archive),
                      onTap: () => actionTapped = true,
                    ),
                  ],
                ),
                itemBuilder: (context, index) {
                  return SizedBox(height: 80, child: Text('Card Item $index'));
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card Item 0'), findsOneWidget);

      // Drag right by 80px to reveal action
      await tester.drag(find.text('Card Item 0'), const Offset(80, 0));
      await tester.pumpAndSettle();

      // Action button should be revealed and visible
      expect(find.byIcon(Icons.archive), findsOneWidget);

      // Tap action button
      await tester.tap(find.byIcon(Icons.archive));
      await tester.pumpAndSettle();

      expect(actionTapped, isTrue);
    });

    testWidgets('does not dismiss when action buttons are used', (
      tester,
    ) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: M3EDismissibleCardColumn(
                itemCount: 2,
                onDismiss: (index, direction) async {
                  dismissed = true;
                  return true;
                },
                style: M3EDismissibleCardStyle(
                  actions: [
                    M3ESwipeAction(
                      icon: const Icon(Icons.archive),
                      label: const Text('Archive'),
                    ),
                  ],
                ),

                itemBuilder: (context, index) {
                  return SizedBox(height: 80, child: Text('Card Item $index'));
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card Item 0'), findsOneWidget);

      // Full swipe across by 300px
      await tester.drag(find.text('Card Item 0'), const Offset(300, 0));
      await tester.pumpAndSettle();

      // Card item should still be in the tree and not dismissed
      expect(find.text('Card Item 0'), findsOneWidget);
      expect(dismissed, isFalse);
    });

    testWidgets(
      'M3EDismissibleCardColumn with DismissDirection.startToEnd blocks left-swipe',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: M3EDismissibleCardColumn(
                  itemCount: 2,
                  style: const M3EDismissibleCardStyle(
                    direction: DismissDirection.startToEnd,
                    actions: [M3ESwipeAction(icon: Icon(Icons.archive))],
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: Text('Directional Card $index'),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('Directional Card 0'), findsOneWidget);

        // Attempt drag to the left (should be blocked)
        await tester.drag(
          find.text('Directional Card 0'),
          const Offset(-150, 0),
        );
        await tester.pump();

        // Card offset should not move left
        expect(find.text('Directional Card 0'), findsOneWidget);
      },
    );

    testWidgets(
      'M3EDismissibleCardColumn with DismissDirection.none disables drag completely',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: M3EDismissibleCardColumn(
                  itemCount: 2,
                  style: const M3EDismissibleCardStyle(
                    direction: DismissDirection.none,
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: Text('Immutable Card $index'),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('Immutable Card 0'), findsOneWidget);

        // Drag right
        await tester.drag(find.text('Immutable Card 0'), const Offset(200, 0));
        await tester.pumpAndSettle();

        expect(find.text('Immutable Card 0'), findsOneWidget);
      },
    );

    testWidgets(
      'M3EDismissibleCardColumn with M3EActionRevealTrigger.doubleTap reveals actions on double tap',
      (tester) async {
        bool actionTriggered = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: M3EDismissibleCardColumn(
                  itemCount: 2,
                  style: M3EDismissibleCardStyle(
                    actionRevealTrigger: M3EActionRevealTrigger.doubleTap,
                    actions: [
                      M3ESwipeAction(
                        icon: const Icon(Icons.archive),
                        onTap: () => actionTriggered = true,
                      ),
                    ],
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: Text('DoubleTap Card $index'),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('DoubleTap Card 0'), findsOneWidget);

        // Double tap on card 0
        await tester.tap(find.text('DoubleTap Card 0'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('DoubleTap Card 0'));
        await tester.pumpAndSettle();

        // Action icon should now be revealed and tappable
        expect(find.byIcon(Icons.archive), findsOneWidget);
        await tester.tap(find.byIcon(Icons.archive));
        await tester.pumpAndSettle();

        expect(actionTriggered, isTrue);
      },
    );

    testWidgets(
      'M3EDismissibleCardColumn with M3EActionRevealTrigger.longPress reveals actions on long press',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: M3EDismissibleCardColumn(
                  itemCount: 2,
                  style: const M3EDismissibleCardStyle(
                    actionRevealTrigger: M3EActionRevealTrigger.longPress,
                    actions: [M3ESwipeAction(icon: Icon(Icons.bookmark))],
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: Text('LongPress Card $index'),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('LongPress Card 0'), findsOneWidget);

        // Long press on card 0
        await tester.longPress(find.text('LongPress Card 0'));
        await tester.pumpAndSettle();

        // Action icon should be visible
        expect(find.byIcon(Icons.bookmark), findsOneWidget);
      },
    );

    testWidgets(
      'M3EDismissibleCardColumn dismisses smoothly when only one item is left',
      (tester) async {
        final items = ['Sole Card'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return M3EDismissibleCardColumn(
                      itemCount: items.length,
                      onDismiss: (index, direction) async {
                        setState(() {
                          items.removeAt(index);
                        });
                        return true;
                      },
                      itemBuilder: (context, index) {
                        return SizedBox(height: 80, child: Text(items[index]));
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(find.text('Sole Card'), findsOneWidget);

        // Swipe right past dismiss threshold
        await tester.drag(find.text('Sole Card'), const Offset(300, 0));
        // Verify intermediate animation frames (collapsing card / flying card exists during animation)
        await tester.pump(const Duration(milliseconds: 100));
        expect(items, isEmpty);

        // Allow animations to fully settle
        await tester.pumpAndSettle();
        expect(find.text('Sole Card'), findsNothing);
      },
    );
  });

  group('M3EReorderableSegmentedList tests', () {
    testWidgets('renders items with placeholder slots and triggers onReorder', (
      tester,
    ) async {
      final items = ['Alpha', 'Beta', 'Gamma'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return M3EReorderableSegmentedList(
                    dragPlaceholderColor: Colors.purple.shade50,
                    dragPlaceholderBorder: const BorderSide(
                      color: Colors.purple,
                      width: 2.0,
                    ),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                      });
                    },
                    children: items
                        .map(
                          (t) => SizedBox(
                            height: 60,
                            child: Center(child: Text(t)),
                          ),
                        )
                        .toList(),
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
    });

    testWidgets('supports custom dragPlaceholderBuilder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: M3EReorderableSegmentedList.builder(
                itemCount: 2,
                dragPlaceholderBuilder: (context, index, size) {
                  return Container(
                    key: ValueKey('custom_placeholder_$index'),
                    color: Colors.amber,
                  );
                },
                onReorder: (_, _) {},
                itemBuilder: (context, index) {
                  return SizedBox(height: 60, child: Text('Item $index'));
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);

      // Long press item 0 to begin drag and reveal placeholder
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Item 0')),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.byKey(const ValueKey('custom_placeholder_0')),
        findsOneWidget,
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets(
      'dynamic position morphing and smooth spring settling during drag',
      (tester) async {
        final items = ['One', 'Two', 'Three'];
        int reorderFrom = -1;
        int reorderTo = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return M3EReorderableSegmentedList.builder(
                      itemCount: items.length,
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

        expect(find.text('One'), findsOneWidget);
        expect(find.text('Two'), findsOneWidget);

        // Start dragging item 0
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('One')),
        );
        await tester.pump(const Duration(milliseconds: 300));

        // Drag down past item 1
        await gesture.moveBy(const Offset(0, 70));
        await tester.pump(const Duration(milliseconds: 50));

        // Verify item 1 has dynamically morphed to visual position 'first'
        final segmentedItems = tester.widgetList<M3ESegmentedItem>(
          find.byType(M3ESegmentedItem),
        );
        final itemTwo = segmentedItems.firstWhere((w) => w.index == 1);
        expect(itemTwo.position, equals(M3ESegmentedItemPosition.first));

        // Release gesture to settle
        await gesture.up();
        await tester.pumpAndSettle();

        expect(reorderFrom, equals(0));
        expect(reorderTo, equals(2));
        expect(items[0], equals('Two'));
        expect(items[1], equals('One'));
      },
    );

    testWidgets(
      'M3EReorderableSegmentedList.builder constructor renders items correctly',
      (tester) async {
        final items = ['Alpha', 'Beta', 'Gamma'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EReorderableSegmentedList.builder(
                itemCount: items.length,
                onReorder: (oldIndex, newIndex) {},
                itemBuilder: (context, index) => Text(items[index]),
              ),
            ),
          ),
        );

        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsOneWidget);
        expect(find.text('Gamma'), findsOneWidget);
      },
    );
  });
}
