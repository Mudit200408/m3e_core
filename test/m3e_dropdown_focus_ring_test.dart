// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/dropdown/internal/_dropdown_focus_ring.dart';
import 'package:m3e_core/src/dropdown/widgets/m3e_dropdown_chips.dart';
import 'package:m3e_core/src/dropdown/widgets/m3e_dropdown_menu_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DropdownFocusRing Unit & Integration Tests', () {
    testWidgets(
      'DropdownFocusRing renders positioned focus ring when focused',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(primary: Colors.blue),
            ),
            home: const Scaffold(
              body: Center(
                child: DropdownFocusRing(
                  focused: true,
                  radius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.red,
                  gap: 0.0,
                  width: 2.0,
                  child: SizedBox(width: 100, height: 50),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(DropdownFocusRing), findsOneWidget);
        expect(find.byType(AnimatedContainer), findsOneWidget);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
        expect(decoration.border!.top.color, Colors.red);
        expect(decoration.border!.top.width, 2.0);
        expect(
          decoration.borderRadius,
          const BorderRadius.all(Radius.circular(16)),
        );
      },
    );

    testWidgets('DropdownFocusRing expands radius when gap > 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: Center(
              child: DropdownFocusRing(
                focused: true,
                radius: BorderRadius.all(Radius.circular(12)),
                gap: 4.0,
                width: 2.0,
                child: SizedBox(width: 100, height: 50),
              ),
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = animatedContainer.decoration as BoxDecoration;
      final borderRad = decoration.borderRadius as BorderRadius;
      // outset = 4.0 + 2.0 = 6.0, so radius is 12.0 + 6.0 = 18.0
      expect(borderRad.topLeft.x, 18.0);
    });

    testWidgets(
      'M3EDropdownMenu field displays focus ring when focusNode is focused',
      (tester) async {
        final focusNode = FocusNode();
        final items = [
          const M3EDropdownItem<String>(value: 'opt1', label: 'Option 1'),
          const M3EDropdownItem<String>(value: 'opt2', label: 'Option 2'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  items: items,
                  focusNode: focusNode,
                  fieldStyle: const M3EDropdownFieldStyle(
                    focusRingColor: Colors.purple,
                    focusRingWidth: 3.0,
                  ),
                ),
              ),
            ),
          ),
        );

        // Before focus
        final ringsBefore = tester
            .widgetList<DropdownFocusRing>(find.byType(DropdownFocusRing))
            .where((r) => r.focused)
            .toList();
        expect(ringsBefore.isEmpty, isTrue);

        // Request focus
        focusNode.requestFocus();
        await tester.pumpAndSettle();

        final ringAfter = tester
            .widgetList<DropdownFocusRing>(find.byType(DropdownFocusRing))
            .firstWhere((r) => r.focused);
        expect(ringAfter.focused, isTrue);
        expect(ringAfter.color, Colors.purple);
        expect(ringAfter.width, 3.0);
      },
    );

    testWidgets('M3EDropdownMenuItem displays focus ring when focused', (
      tester,
    ) async {
      final controller = M3EDropdownController<String>();
      final items = [
        const M3EDropdownItem<String>(value: 'opt1', label: 'Option 1'),
        const M3EDropdownItem<String>(value: 'opt2', label: 'Option 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EDropdownMenu<String>(
                controller: controller,
                items: items,
                itemStyle: const M3EDropdownItemStyle(
                  focusRingColor: Colors.teal,
                  focusRingWidth: 3.0,
                ),
              ),
            ),
          ),
        ),
      );

      controller.openDropdown();
      await tester.pumpAndSettle();

      final item1Ring = find.descendant(
        of: find.byType(M3EDropdownMenuItemWidget<String>).first,
        matching: find.byType(DropdownFocusRing),
      );
      expect(item1Ring, findsOneWidget);

      Focus.of(tester.element(item1Ring)).requestFocus();
      await tester.pumpAndSettle();

      final focusedRing = tester
          .widgetList<DropdownFocusRing>(find.byType(DropdownFocusRing))
          .firstWhere((r) => r.focused);
      expect(focusedRing.focused, isTrue);
      expect(focusedRing.color, Colors.teal);
      expect(focusedRing.width, 3.0);
    });

    testWidgets('M3ESpringChip displays focus ring when focused', (
      tester,
    ) async {
      final controller = M3EDropdownController<String>();
      final items = [
        const M3EDropdownItem<String>(
          value: 'opt1',
          label: 'Option 1',
          selected: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EDropdownMenu<String>(
                controller: controller,
                items: items,
                showChipAnimation: true,
                chipStyle: const M3EChipStyle(
                  focusRingColor: Colors.amber,
                  focusRingWidth: 2.5,
                ),
              ),
            ),
          ),
        ),
      );

      final chipRing = find.descendant(
        of: find.byType(M3ESpringChip<String>).first,
        matching: find.byType(DropdownFocusRing),
      );
      expect(chipRing, findsOneWidget);

      Focus.of(tester.element(chipRing)).requestFocus();
      await tester.pumpAndSettle();

      final focusedRing = tester
          .widgetList<DropdownFocusRing>(find.byType(DropdownFocusRing))
          .firstWhere((r) => r.focused);
      expect(focusedRing.focused, isTrue);
      expect(focusedRing.color, Colors.amber);
      expect(focusedRing.width, 2.5);
    });
  });

  group('Dropdown Style Classes Focus Ring Equality & copyWith Tests', () {
    test('M3EDropdownFieldStyle focus ring properties', () {
      const s1 = M3EDropdownFieldStyle(
        focusRingColor: Colors.blue,
        focusRingWidth: 3.0,
        focusRingGap: 2.0,
      );
      const s2 = M3EDropdownFieldStyle(
        focusRingColor: Colors.blue,
        focusRingWidth: 3.0,
        focusRingGap: 2.0,
      );
      const s3 = M3EDropdownFieldStyle(focusRingColor: Colors.red);

      expect(s1 == s2, isTrue);
      expect(s1.hashCode == s2.hashCode, isTrue);
      expect(s1 == s3, isFalse);

      final copied = s1.copyWith(focusRingColor: Colors.green);
      expect(copied.focusRingColor, Colors.green);
      expect(copied.focusRingWidth, 3.0);
      expect(copied.focusRingGap, 2.0);
    });

    test('M3EDropdownItemStyle focus ring properties', () {
      const s1 = M3EDropdownItemStyle(
        focusRingColor: Colors.blue,
        focusRingWidth: 3.0,
        focusRingGap: 2.0,
      );
      const s2 = M3EDropdownItemStyle(
        focusRingColor: Colors.blue,
        focusRingWidth: 3.0,
        focusRingGap: 2.0,
      );
      const s3 = M3EDropdownItemStyle(focusRingColor: Colors.red);

      expect(s1 == s2, isTrue);
      expect(s1.hashCode == s2.hashCode, isTrue);
      expect(s1 == s3, isFalse);

      final copied = s1.copyWith(focusRingColor: Colors.green);
      expect(copied.focusRingColor, Colors.green);
      expect(copied.focusRingWidth, 3.0);
      expect(copied.focusRingGap, 2.0);
    });

    test('M3EChipStyle focus ring properties', () {
      const s1 = M3EChipStyle(
        focusRingColor: Colors.blue,
        focusRingWidth: 3.0,
        focusRingGap: 2.0,
      );
      const s2 = M3EChipStyle(
        focusRingColor: Colors.blue,
        focusRingWidth: 3.0,
        focusRingGap: 2.0,
      );
      const s3 = M3EChipStyle(focusRingColor: Colors.red);

      expect(s1 == s2, isTrue);
      expect(s1.hashCode == s2.hashCode, isTrue);
      expect(s1 == s3, isFalse);

      final copied = s1.copyWith(focusRingColor: Colors.green);
      expect(copied.focusRingColor, Colors.green);
      expect(copied.focusRingWidth, 3.0);
      expect(copied.focusRingGap, 2.0);
    });
  });
}
