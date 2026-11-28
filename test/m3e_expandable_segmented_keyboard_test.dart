// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/segmented_list/internal/_segmented_focus_ring.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M3EExpandableSegmentedItem Keyboard & Focus Ring Tests', () {
    testWidgets('Header renders SegmentedFocusRing when focused', (
      tester,
    ) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EExpandableSegmentedItem(
              index: 0,
              totalCount: 1,
              isExpanded: false,
              focusNode: focusNode,
              onToggle: () {},
              header: const Text('Header 0'),
              children: const [Text('Child 0')],
            ),
          ),
        ),
      );

      // Initially not focused
      var focusRingFinder = find.byWidgetPredicate(
        (w) => w is SegmentedFocusRing && w.focused,
      );
      expect(focusRingFinder, findsNothing);

      // Request focus on header
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Focus ring is now painted
      focusRingFinder = find.byWidgetPredicate(
        (w) => w is SegmentedFocusRing && w.focused,
      );
      expect(focusRingFinder, findsOneWidget);

      focusNode.dispose();
    });

    testWidgets(
      'Enter/Space and ArrowRight/ArrowLeft keyboard shortcuts toggle expansion',
      (tester) async {
        bool isExpanded = false;
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EExpandableSegmentedItem(
                    index: 0,
                    totalCount: 1,
                    isExpanded: isExpanded,
                    focusNode: focusNode,
                    onToggle: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    header: const Text('Expandable Header'),
                    children: const [Text('Child Content 1')],
                  );
                },
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(isExpanded, isFalse);

        // Press Enter -> toggles expand
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(isExpanded, isTrue);

        // Press Enter -> toggles collapse
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(isExpanded, isFalse);

        // Press Space -> toggles expand
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(isExpanded, isTrue);

        // Press Space -> toggles collapse
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(isExpanded, isFalse);

        // Press ArrowRight -> expands
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(isExpanded, isTrue);

        // Press ArrowLeft -> collapses
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(isExpanded, isFalse);

        focusNode.dispose();
      },
    );

    testWidgets('Alt+ArrowUp and Alt+ArrowDown trigger onReorderKey callback', (
      tester,
    ) async {
      int? reorderedIndex;
      bool? reorderedForward;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EExpandableSegmentedItem(
              index: 2,
              totalCount: 5,
              isExpanded: false,
              focusNode: focusNode,
              onReorderKey: (index, moveForward) {
                reorderedIndex = index;
                reorderedForward = moveForward;
              },
              onToggle: () {},
              header: const Text('Header 2'),
              children: const [Text('Child')],
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      // Alt + ArrowUp -> reorder backward
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await tester.pumpAndSettle();

      expect(reorderedIndex, equals(2));
      expect(reorderedForward, isFalse);

      // Alt + ArrowDown -> reorder forward
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await tester.pumpAndSettle();

      expect(reorderedIndex, equals(2));
      expect(reorderedForward, isTrue);

      focusNode.dispose();
    });

    testWidgets(
      'Child items receive focus, render focus ring, and trigger onChildTap with Enter/Space',
      (tester) async {
        int? tappedChildIndex;
        final childFocusNodes = [FocusNode(), FocusNode()];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EExpandableSegmentedItem(
                index: 0,
                totalCount: 1,
                isExpanded: true,
                onToggle: () {},
                childFocusNodes: childFocusNodes,
                onChildTap: (idx) {
                  tappedChildIndex = idx;
                },
                header: const Text('Parent Header'),
                children: const [Text('Child 0'), Text('Child 1')],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Child 0'), findsOneWidget);
        expect(find.text('Child 1'), findsOneWidget);

        // Focus child 1
        childFocusNodes[1].requestFocus();
        await tester.pumpAndSettle();

        final activeFocusRings = find.byWidgetPredicate(
          (w) => w is SegmentedFocusRing && w.focused,
        );
        expect(activeFocusRings, findsOneWidget);

        // Press Enter on Child 1
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(tappedChildIndex, equals(1));

        // Focus child 0 and press Space
        childFocusNodes[0].requestFocus();
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(tappedChildIndex, equals(0));

        for (final node in childFocusNodes) {
          node.dispose();
        }
      },
    );

    testWidgets(
      'ArrowDown navigates from header into children, ArrowDown/ArrowUp navigates across children, and ArrowUp from child 0 returns to header',
      (tester) async {
        final headerFocusNode = FocusNode();
        final childFocusNodes = [FocusNode(), FocusNode(), FocusNode()];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EExpandableSegmentedItem(
                index: 0,
                totalCount: 1,
                isExpanded: true,
                focusNode: headerFocusNode,
                childFocusNodes: childFocusNodes,
                onToggle: () {},
                header: const Text('Parent Header'),
                children: const [
                  Text('Child 0'),
                  Text('Child 1'),
                  Text('Child 2'),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Focus header
        headerFocusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(headerFocusNode.hasFocus, isTrue);

        // ArrowDown -> moves focus to Child 0
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        expect(childFocusNodes[0].hasFocus, isTrue);

        // ArrowDown -> moves focus to Child 1
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        expect(childFocusNodes[1].hasFocus, isTrue);

        // ArrowDown -> moves focus to Child 2
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        expect(childFocusNodes[2].hasFocus, isTrue);

        // ArrowUp -> moves focus back to Child 1
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
        expect(childFocusNodes[1].hasFocus, isTrue);

        // ArrowUp -> moves focus back to Child 0
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
        expect(childFocusNodes[0].hasFocus, isTrue);

        // ArrowUp from Child 0 -> moves focus back to Header
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
        expect(headerFocusNode.hasFocus, isTrue);

        headerFocusNode.dispose();
        for (final node in childFocusNodes) {
          node.dispose();
        }
      },
    );

    testWidgets(
      'ArrowLeft or Escape from child collapses section and returns focus to header',
      (tester) async {
        bool isExpanded = true;
        final headerFocusNode = FocusNode();
        final childFocusNodes = [FocusNode(), FocusNode()];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EExpandableSegmentedItem(
                    index: 0,
                    totalCount: 1,
                    isExpanded: isExpanded,
                    focusNode: headerFocusNode,
                    childFocusNodes: childFocusNodes,
                    onToggle: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    header: const Text('Parent Header'),
                    children: const [Text('Child 0'), Text('Child 1')],
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Focus Child 1
        childFocusNodes[1].requestFocus();
        await tester.pumpAndSettle();
        expect(childFocusNodes[1].hasFocus, isTrue);

        // Press ArrowLeft on child -> collapses section and focuses header
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();

        expect(isExpanded, isFalse);
        expect(headerFocusNode.hasFocus, isTrue);

        headerFocusNode.dispose();
        for (final node in childFocusNodes) {
          node.dispose();
        }
      },
    );

    testWidgets(
      'Tab moves cleanly between M3ESegmentedColumn items in 1 press per item',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3ESegmentedColumn(
                // Interactive on purpose: only items with a handler mount a
                // Focus node, so a column with nothing to activate has no tab
                // stops at all (covered by the test below). This one is about
                // there being exactly one stop per item.
                onTap: (_) {},
                children: const [
                  Text('Item 0'),
                  Text('Item 1'),
                  Text('Item 2'),
                ],
              ),
            ),
          ),
        );

        // Press Tab 1 -> Item 0 is focused with ring
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        final ringsAfterTab1 = tester.widgetList<SegmentedFocusRing>(
          find.byWidgetPredicate((w) => w is SegmentedFocusRing && w.focused),
        );
        expect(ringsAfterTab1.length, 1);

        // Press Tab 2 -> Item 1 is focused with ring (no duplicate tab on Item 0)
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        final ringsAfterTab2 = tester.widgetList<SegmentedFocusRing>(
          find.byWidgetPredicate((w) => w is SegmentedFocusRing && w.focused),
        );
        expect(ringsAfterTab2.length, 1);

        // Press Tab 3 -> Item 2 is focused with ring
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        final ringsAfterTab3 = tester.widgetList<SegmentedFocusRing>(
          find.byWidgetPredicate((w) => w is SegmentedFocusRing && w.focused),
        );
        expect(ringsAfterTab3.length, 1);
      },
    );

    testWidgets('a column with no handlers has no tab stops', (tester) async {
      final fieldFocus = FocusNode();
      addTearDown(fieldFocus.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedColumn(
              children: [TextField(focusNode: fieldFocus)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(fieldFocus.hasPrimaryFocus, isTrue);
      await tester.enterText(find.byType(TextField), 'Campus');
      expect(find.text('Campus'), findsOneWidget);
    });

    testWidgets('toggling interactivity preserves child state', (tester) async {
      bool interactive = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => interactive = !interactive),
                      child: const Text('Toggle'),
                    ),
                    M3ESegmentedColumn(
                      onTap: interactive ? (_) {} : null,
                      children: const [_StatefulChild()],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Count: 0'));
      await tester.pumpAndSettle();
      expect(find.text('Count: 1'), findsOneWidget);

      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();

      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}

class _StatefulChild extends StatefulWidget {
  const _StatefulChild();

  @override
  State<_StatefulChild> createState() => _StatefulChildState();
}

class _StatefulChildState extends State<_StatefulChild> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _count++),
      child: Text('Count: $_count'),
    );
  }
}
