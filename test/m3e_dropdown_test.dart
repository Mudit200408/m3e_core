// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EDropdown Style Tests (pressedScale)', () {
    test(
      'M3EDropdownFieldStyle equality, hashCode and copyWith with pressedScale',
      () {
        const style1 = M3EDropdownFieldStyle(pressedScale: 0.95);
        const style2 = M3EDropdownFieldStyle(pressedScale: 0.95);
        const style3 = M3EDropdownFieldStyle(pressedScale: 0.90);

        expect(style1 == style2, isTrue);
        expect(style1.hashCode == style2.hashCode, isTrue);
        expect(style1 == style3, isFalse);

        final copied = style1.copyWith(pressedScale: 0.92);
        expect(copied.pressedScale, 0.92);

        final lerped = M3EDropdownFieldStyle.lerp(style1, style3, 0.5);
        expect(lerped.pressedScale, closeTo(0.925, 0.001));
      },
    );

    test(
      'M3EDropdownItemStyle equality, hashCode and copyWith with pressedScale',
      () {
        const style1 = M3EDropdownItemStyle(pressedScale: 0.95);
        const style2 = M3EDropdownItemStyle(pressedScale: 0.95);
        const style3 = M3EDropdownItemStyle(pressedScale: 0.90);

        expect(style1 == style2, isTrue);
        expect(style1.hashCode == style2.hashCode, isTrue);
        expect(style1 == style3, isFalse);

        final copied = style1.copyWith(pressedScale: 0.92);
        expect(copied.pressedScale, 0.92);

        final lerped = M3EDropdownItemStyle.lerp(style1, style3, 0.5);
        expect(lerped.pressedScale, closeTo(0.925, 0.001));
      },
    );

    test('M3EChipStyle equality, hashCode and copyWith with pressedScale', () {
      const style1 = M3EChipStyle(pressedScale: 0.95);
      const style2 = M3EChipStyle(pressedScale: 0.95);
      const style3 = M3EChipStyle(pressedScale: 0.90);

      expect(style1 == style2, isTrue);
      expect(style1.hashCode == style2.hashCode, isTrue);
      expect(style1 == style3, isFalse);

      final copied = style1.copyWith(pressedScale: 0.92);
      expect(copied.pressedScale, 0.92);

      final lerped = M3EChipStyle.lerp(style1, style3, 0.5);
      expect(lerped.pressedScale, closeTo(0.925, 0.001));
    });
  });

  group('M3EDropdown Field pressedScale Interaction Tests', () {
    testWidgets(
      'Field shrinks on pointer down and springs back on pointer up',
      (tester) async {
        final items = [
          const M3EDropdownItem<String>(value: 'apple', label: 'Apple'),
          const M3EDropdownItem<String>(value: 'banana', label: 'Banana'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  fieldStyle: const M3EDropdownFieldStyle(
                    hintText: 'Select fruit',
                    pressedScale: 0.90,
                  ),
                ),
              ),
            ),
          ),
        );

        final textFinder = find.text('Select fruit');
        expect(textFinder, findsOneWidget);

        final transformFinder = find.ancestor(
          of: textFinder,
          matching: find.byType(Transform),
        );
        expect(transformFinder, findsOneWidget);

        // Initial resting state is 1.0
        final initialTransform = tester.widget<Transform>(transformFinder);
        expect(initialTransform.transform.entry(0, 0), closeTo(1.0, 0.01));

        // Pointer down
        final gesture = await tester.startGesture(tester.getCenter(textFinder));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        final pressedTransform = tester.widget<Transform>(transformFinder);
        expect(pressedTransform.transform.entry(0, 0), lessThan(1.0));

        // Pointer up
        await gesture.up();
        await tester.pumpAndSettle();

        final releasedTransform = tester.widget<Transform>(transformFinder);
        expect(releasedTransform.transform.entry(0, 0), closeTo(1.0, 0.01));
      },
    );

    testWidgets(
      'Default pressedScale: null does not inject extra Transform.scale into field',
      (tester) async {
        final items = [
          const M3EDropdownItem<String>(value: 'apple', label: 'Apple'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  fieldStyle: const M3EDropdownFieldStyle(
                    hintText: 'No scale field',
                  ),
                ),
              ),
            ),
          ),
        );

        final textFinder = find.text('No scale field');
        expect(textFinder, findsOneWidget);

        final transformFinder = find.ancestor(
          of: textFinder,
          matching: find.byType(Transform),
        );
        expect(transformFinder, findsNothing);
      },
    );
  });

  group('M3EDropdown Menu Items pressedScale Interaction Tests', () {
    testWidgets(
      'Item content shrinks on pointer down and springs back on pointer up',
      (tester) async {
        final items = [
          const M3EDropdownItem<String>(value: 'cherry', label: 'Cherry'),
          const M3EDropdownItem<String>(value: 'mango', label: 'Mango'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  fieldStyle: const M3EDropdownFieldStyle(
                    hintText: 'Select fruit',
                  ),
                  itemStyle: const M3EDropdownItemStyle(pressedScale: 0.90),
                ),
              ),
            ),
          ),
        );

        // Tap field to open menu
        await tester.tap(find.text('Select fruit'));
        await tester.pumpAndSettle();

        final cherryFinder = find.text('Cherry');
        expect(cherryFinder, findsOneWidget);

        // The closest ancestor Transform to 'Cherry' is the item's Transform.scale
        final cherryTransformFinder = find
            .ancestor(of: cherryFinder, matching: find.byType(Transform))
            .first;
        final initialCherryTransform = tester.widget<Transform>(
          cherryTransformFinder,
        );
        expect(
          initialCherryTransform.transform.entry(0, 0),
          closeTo(1.0, 0.01),
        );

        // Pointer down on item
        final gesture = await tester.startGesture(
          tester.getCenter(cherryFinder),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        final pressedTransform = tester.widget<Transform>(
          cherryTransformFinder,
        );
        expect(pressedTransform.transform.entry(0, 0), lessThan(1.0));

        await gesture.up();
        await tester.pumpAndSettle();

        final releasedTransform = tester.widget<Transform>(
          cherryTransformFinder,
        );
        expect(releasedTransform.transform.entry(0, 0), closeTo(1.0, 0.01));
      },
    );

    testWidgets(
      'Top-level M3EDropdownMenu.pressedScale cascades to both field and items',
      (tester) async {
        final items = [
          const M3EDropdownItem<String>(value: 'plum', label: 'Plum'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  pressedScale: 0.92,
                  fieldStyle: const M3EDropdownFieldStyle(hintText: 'Cascade'),
                ),
              ),
            ),
          ),
        );

        // Field has Transform
        final fieldTransform = find.ancestor(
          of: find.text('Cascade'),
          matching: find.byType(Transform),
        );
        expect(fieldTransform, findsOneWidget);

        // Open dropdown
        await tester.tap(find.text('Cascade'));
        await tester.pumpAndSettle();

        // Item has Transform (nearest ancestor Transform)
        final itemTransform = find
            .ancestor(of: find.text('Plum'), matching: find.byType(Transform))
            .first;
        final plumTransform = tester.widget<Transform>(itemTransform);
        expect(plumTransform.transform.entry(0, 0), closeTo(1.0, 0.01));
      },
    );
  });

  group('M3EDropdown Chips pressedScale Interaction Tests', () {
    testWidgets(
      'Interacting with a chip scales only that chip, not the dropdown field',
      (tester) async {
        final items = [
          const M3EDropdownItem<String>(
            value: 'kiwi',
            label: 'Kiwi',
            selected: true,
          ),
          const M3EDropdownItem<String>(value: 'lemon', label: 'Lemon'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  fieldStyle: const M3EDropdownFieldStyle(pressedScale: 0.90),
                  chipStyle: const M3EChipStyle(pressedScale: 0.85),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final kiwiFinder = find.text('Kiwi');
        expect(kiwiFinder, findsOneWidget);

        // Nearest Transform to Kiwi is the chip's Transform.scale
        final chipTransformFinder = find
            .ancestor(of: kiwiFinder, matching: find.byType(Transform))
            .first;

        // Pointer down on the Kiwi chip
        final gesture = await tester.startGesture(tester.getCenter(kiwiFinder));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // The chip should scale down (< 1.0)
        final pressedChipTransform = tester.widget<Transform>(
          chipTransformFinder,
        );
        expect(pressedChipTransform.transform.entry(0, 0), lessThan(1.0));

        // The outermost Transform ancestor (field scale) must remain at 1.0
        final fieldTransforms = tester
            .widgetList<Transform>(
              find.ancestor(of: kiwiFinder, matching: find.byType(Transform)),
            )
            .toList();
        final fieldTransform = fieldTransforms.last;
        expect(fieldTransform.transform.entry(0, 0), closeTo(1.0, 0.001));

        // Pointer up
        await gesture.up();
        await tester.pumpAndSettle();

        // Dropdown menu should NOT have opened from tapping the chip
        expect(find.text('Lemon'), findsNothing);
      },
    );

    testWidgets(
      'Tapping chip remove icon removes the chip without toggling dropdown menu',
      (tester) async {
        final items = [
          const M3EDropdownItem<String>(
            value: 'mango',
            label: 'Mango',
            selected: true,
          ),
          const M3EDropdownItem<String>(value: 'orange', label: 'Orange'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  fieldStyle: const M3EDropdownFieldStyle(pressedScale: 0.90),
                  chipStyle: const M3EChipStyle(pressedScale: 0.85),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Mango'), findsOneWidget);

        // Tap the remove icon on Mango
        final removeIcon = find.byTooltip('Remove Mango');
        expect(removeIcon, findsOneWidget);

        await tester.tap(removeIcon);
        await tester.pumpAndSettle();

        // Mango chip should be removed
        expect(find.text('Mango'), findsNothing);

        // Dropdown menu should NOT have opened
        expect(find.text('Orange'), findsNothing);
      },
    );
  });
}
