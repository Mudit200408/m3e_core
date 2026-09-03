// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('calculateSegmentedItemRadius with Axis.horizontal', () {
    const outer = 24.0;
    const inner = 4.0;

    test('single item has outer radius on all 4 corners', () {
      final radius = calculateSegmentedItemRadius(
        position: M3ESegmentedItemPosition.single,
        outerRadius: outer,
        innerRadius: inner,
        axis: Axis.horizontal,
      );
      expect(radius.topLeft, const Radius.circular(outer));
      expect(radius.bottomLeft, const Radius.circular(outer));
      expect(radius.topRight, const Radius.circular(outer));
      expect(radius.bottomRight, const Radius.circular(outer));
    });

    test('first item has outer radius on left and inner on right', () {
      final radius = calculateSegmentedItemRadius(
        position: M3ESegmentedItemPosition.first,
        outerRadius: outer,
        innerRadius: inner,
        axis: Axis.horizontal,
      );
      expect(radius.topLeft, const Radius.circular(outer));
      expect(radius.bottomLeft, const Radius.circular(outer));
      expect(radius.topRight, const Radius.circular(inner));
      expect(radius.bottomRight, const Radius.circular(inner));
    });

    test('middle item has inner radius on all 4 corners', () {
      final radius = calculateSegmentedItemRadius(
        position: M3ESegmentedItemPosition.middle,
        outerRadius: outer,
        innerRadius: inner,
        axis: Axis.horizontal,
      );
      expect(radius.topLeft, const Radius.circular(inner));
      expect(radius.bottomLeft, const Radius.circular(inner));
      expect(radius.topRight, const Radius.circular(inner));
      expect(radius.bottomRight, const Radius.circular(inner));
    });

    test('last item has inner radius on left and outer on right', () {
      final radius = calculateSegmentedItemRadius(
        position: M3ESegmentedItemPosition.last,
        outerRadius: outer,
        innerRadius: inner,
        axis: Axis.horizontal,
      );
      expect(radius.topLeft, const Radius.circular(inner));
      expect(radius.bottomLeft, const Radius.circular(inner));
      expect(radius.topRight, const Radius.circular(outer));
      expect(radius.bottomRight, const Radius.circular(outer));
    });
  });

  group('M3ESegmentedRow Widget Tests', () {
    testWidgets('renders children in a horizontal row', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: M3ESegmentedRow(
                  children: const [Text('Item 1'), Text('Item 2')],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      final rowFinder = find.byType(Row);
      expect(rowFinder, findsOneWidget);
      expect(find.byType(Expanded), findsNWidgets(2));
    });

    testWidgets('respects equalWidth: false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedRow(
              equalWidth: false,
              children: const [Text('Item 1'), Text('Item 2')],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.byType(Expanded), findsNothing);
    });

    testWidgets('respects flexes property', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: M3ESegmentedRow(
                  flexes: const [2, 1],
                  children: const [Text('Item 1'), Text('Item 2')],
                ),
              ),
            ),
          ),
        ),
      );

      final expandedWidgets = tester
          .widgetList<Expanded>(find.byType(Expanded))
          .toList();
      expect(expandedWidgets.length, 2);
      expect(expandedWidgets[0].flex, 2);
      expect(expandedWidgets[1].flex, 1);
    });

    testWidgets('handles tap events', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: M3ESegmentedRow(
                  onTap: (index) => tappedIndex = index,
                  children: const [Text('Left'), Text('Right')],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Right'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 1);

      await tester.tap(find.text('Left'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 0);
    });

    testWidgets('supports single selection mode', (tester) async {
      Set<int> selection = {};

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 300,
                    child: M3ESegmentedRow(
                      selectionMode: M3ESelectionMode.single,
                      selectedIndices: selection,
                      onSelectionChanged: (s) {
                        setState(() => selection = s);
                      },
                      children: const [Text('First'), Text('Second')],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

      await tester.tap(find.text('First'));
      await tester.pumpAndSettle();
      expect(selection, {0});

      await tester.tap(find.text('Second'));
      await tester.pumpAndSettle();
      expect(selection, {1});
    });

    testWidgets('renders emptyBuilder when children is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ESegmentedRow(
              emptyBuilder: Text('No Items Available'),
              children: [],
            ),
          ),
        ),
      );

      expect(find.text('No Items Available'), findsOneWidget);
    });

    testWidgets('applies margin padding around Row', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ESegmentedRow(
              margin: EdgeInsets.all(16.0),
              children: [Text('Card A'), Text('Card B')],
            ),
          ),
        ),
      );

      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final hasMargin = paddingWidgets.any(
        (p) => p.padding == const EdgeInsets.all(16.0),
      );
      expect(hasMargin, isTrue);
    });
  });
}
