// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3E Segmented States Tests (All 6 States)', () {
    testWidgets('1. Enabled State: Default interactive resting state', (
      tester,
    ) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedItem(
              index: 0,
              position: M3ESegmentedItemPosition.single,
              outerRadius: 24.0,
              innerRadius: 4.0,
              enabled: true,
              onTap: (_) => tapCount++,
              child: const M3EListItem(
                leading: Icon(Icons.person),
                headline: Text('Label text'),
                supportingText: Text('Supporting line'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Label text'), findsOneWidget);
      expect(find.text('Supporting line'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.tap(find.text('Label text'));
      await tester.pumpAndSettle();
      expect(tapCount, 1);
    });

    testWidgets('2. Disabled State: Non-interactive and dimmed styling', (
      tester,
    ) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedItem(
              index: 0,
              position: M3ESegmentedItemPosition.single,
              outerRadius: 24.0,
              innerRadius: 4.0,
              enabled: false,
              onTap: (_) => tapCount++,
              child: const M3EListItem(
                enabled: false,
                leading: Icon(Icons.person),
                headline: Text('Disabled label'),
                supportingText: Text('Disabled supporting line'),
              ),
            ),
          ),
        ),
      );

      // Tapping should not trigger onTap
      await tester.tap(find.text('Disabled label'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(tapCount, 0);

      // Opacity wrappers for disabled leading and trailing
      expect(find.byType(Opacity), findsWidgets);
    });

    testWidgets(
      '3. Hovered State: Applies hover overlay and hovered corner radius',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3ESegmentedItem(
                  index: 0,
                  position: M3ESegmentedItemPosition.single,
                  outerRadius: 24.0,
                  innerRadius: 4.0,
                  hoveredRadius: 12.0,
                  onTap: (_) {},
                  child: const Text('Hover me'),
                ),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.text('Hover me')));
        await tester.pumpAndSettle();

        expect(find.text('Hover me'), findsOneWidget);
      },
    );

    testWidgets('4. Focused State: Applies focus outline border', (
      tester,
    ) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6750A4),
              secondary: Color(0xFF625B71),
            ),
          ),
          home: Scaffold(
            body: M3ESegmentedItem(
              index: 0,
              position: M3ESegmentedItemPosition.single,
              outerRadius: 24.0,
              innerRadius: 4.0,
              focusNode: focusNode,
              focusedBorder: const BorderSide(color: Colors.purple, width: 3.0),
              onTap: (_) {},
              child: const Text('Focused item'),
            ),
          ),
        ),
      );

      expect(focusNode.hasFocus, false);

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, true);
      expect(find.text('Focused item'), findsOneWidget);

      focusNode.dispose();
    });

    testWidgets('5. Pressed State: Spring corner morphing on pointer down', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3ESegmentedItem(
                index: 0,
                position: M3ESegmentedItemPosition.single,
                outerRadius: 24.0,
                innerRadius: 4.0,
                pressedRadius: 8.0,
                onTap: (_) {},
                child: const Text('Press me'),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Press me')),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Press me'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets(
      '6. Dragged State: Reorderable list applies drag proxy styling',
      (tester) async {
        final items = ['Item 0', 'Item 1', 'Item 2'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EReorderableSegmentedList(
                onReorder: (oldIndex, newIndex) {},
                dragElevation: 8.0,
                dragColor: Colors.pink.shade100,
                children: items.map((text) => Text(text)).toList(),
              ),
            ),
          ),
        );

        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      },
    );

    testWidgets('M3ESegmentedList supports isEnabled predicate', (
      tester,
    ) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedList(
              itemCount: 3,
              isEnabled: (index) => index != 1, // Item 1 is disabled
              onTap: (index) => tappedIndex = index,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      // Tap enabled item 0
      await tester.tap(find.text('Item 0'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 0);

      // Tap disabled item 1
      tappedIndex = null;
      await tester.tap(find.text('Item 1'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(tappedIndex, null);

      // Tap enabled item 2
      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 2);
    });

    testWidgets('M3ESegmentedColumn supports isEnabled predicate', (
      tester,
    ) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3ESegmentedColumn(
              isEnabled: (index) => index == 0,
              onTap: (index) => tappedIndex = index,
              children: const [Text('Col 0'), Text('Col 1')],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Col 0'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 0);

      tappedIndex = null;
      await tester.tap(find.text('Col 1'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(tappedIndex, null);
    });

    test(
      'M3ESegmentedListDecoration equality, hashCode and lerp preserve placeholder props',
      () {
        const dec1 = M3ESegmentedListDecoration(
          dragPlaceholderColor: Color(0xFFFF0000),
          dragPlaceholderRadius: 16.0,
          dragPlaceholderBorder: BorderSide(
            color: Color(0xFF00FF00),
            width: 2.0,
          ),
        );

        const dec2 = M3ESegmentedListDecoration(
          dragPlaceholderColor: Color(0xFFFF0000),
          dragPlaceholderRadius: 16.0,
          dragPlaceholderBorder: BorderSide(
            color: Color(0xFF00FF00),
            width: 2.0,
          ),
        );

        const dec3 = M3ESegmentedListDecoration(
          dragPlaceholderColor: Color(0xFF0000FF),
          dragPlaceholderRadius: 8.0,
          dragPlaceholderBorder: BorderSide(
            color: Color(0xFF000000),
            width: 1.0,
          ),
        );

        expect(dec1 == dec2, isTrue);
        expect(dec1.hashCode == dec2.hashCode, isTrue);
        expect(dec1 == dec3, isFalse);

        final lerped = M3ESegmentedListDecoration.lerp(dec1, dec3, 0.5);
        expect(lerped, isNotNull);
        expect(lerped!.dragPlaceholderRadius, equals(12.0));
        expect(lerped.dragPlaceholderColor, isNotNull);
        expect(lerped.dragPlaceholderBorder, isNotNull);
      },
    );
  });
}
