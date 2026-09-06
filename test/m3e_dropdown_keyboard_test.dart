// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/dropdown/internal/_dropdown_focus_ring.dart';
import 'package:m3e_core/src/dropdown/widgets/m3e_dropdown_menu_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M3EDropdown Keyboard Navigation & Selection Tests', () {
    testWidgets(
      'Pressing Enter/Space/ArrowDown on focused field opens dropdown and Escape closes it',
      (tester) async {
        final focusNode = FocusNode();
        final controller = M3EDropdownController<String>();
        final items = [
          const M3EDropdownItem<String>(value: 'apple', label: 'Apple'),
          const M3EDropdownItem<String>(value: 'banana', label: 'Banana'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EDropdownMenu<String>(
                  controller: controller,
                  items: items,
                  focusNode: focusNode,
                ),
              ),
            ),
          ),
        );

        // Initially closed
        expect(controller.isOpen, isFalse);

        // Focus field
        focusNode.requestFocus();
        await tester.pumpAndSettle();

        // Press Enter to open
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);

        // Press Escape to close
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);

        // Press Space to open
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);

        // Close
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);

        // Press ArrowDown to open
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
      },
    );

    testWidgets('Menu items can be selected with Enter key', (tester) async {
      final controller = M3EDropdownController<String>();
      final items = [
        const M3EDropdownItem<String>(value: 'apple', label: 'Apple'),
        const M3EDropdownItem<String>(value: 'banana', label: 'Banana'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EDropdownMenu<String>(
                controller: controller,
                items: items,
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      controller.openDropdown();
      await tester.pumpAndSettle();

      // Focus first item
      final ringFinder = find.descendant(
        of: find.byType(M3EDropdownMenuItemWidget<String>).first,
        matching: find.byType(DropdownFocusRing),
      );
      expect(ringFinder, findsOneWidget);

      Focus.of(tester.element(ringFinder)).requestFocus();
      await tester.pumpAndSettle();

      // Press Enter to select
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(controller.selectedItems.any((i) => i.value == 'apple'), isTrue);
    });

    testWidgets(
      'Selected chips can be deleted with Backspace and Delete keys',
      (tester) async {
        final controller = M3EDropdownController<String>();
        final items = [
          const M3EDropdownItem<String>(
            value: 'apple',
            label: 'Apple',
            selected: true,
          ),
          const M3EDropdownItem<String>(
            value: 'banana',
            label: 'Banana',
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
                  singleSelect: false,
                ),
              ),
            ),
          ),
        );

        expect(controller.selectedItems.length, 2);

        // Focus chip for 'Apple'
        final appleChipText = find.text('Apple');
        expect(appleChipText, findsOneWidget);

        Focus.of(tester.element(appleChipText)).requestFocus();
        await tester.pumpAndSettle();

        // Press Backspace to remove
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();

        expect(
          controller.selectedItems.any((e) => e.value == 'apple'),
          isFalse,
        );
        expect(controller.selectedItems.length, 1);

        // Focus chip for 'Banana'
        final bananaChipText = find.text('Banana');
        expect(bananaChipText, findsOneWidget);

        Focus.of(tester.element(bananaChipText)).requestFocus();
        await tester.pumpAndSettle();

        // Press Delete to remove
        await tester.sendKeyEvent(LogicalKeyboardKey.delete);
        await tester.pumpAndSettle();

        expect(controller.selectedItems.isEmpty, isTrue);
      },
    );

    testWidgets('ArrowDown in search bar moves focus to the first menu item', (
      tester,
    ) async {
      final controller = M3EDropdownController<String>();
      final items = [
        const M3EDropdownItem<String>(value: 'apple', label: 'Apple'),
        const M3EDropdownItem<String>(value: 'banana', label: 'Banana'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EDropdownMenu<String>(
                controller: controller,
                items: items,
                searchEnabled: true,
                searchStyle: const M3ESearchStyle(autofocus: true),
              ),
            ),
          ),
        ),
      );

      controller.openDropdown();
      await tester.pumpAndSettle();

      // Search bar is focused
      final searchFieldFinder = find.byType(TextField);
      expect(searchFieldFinder, findsOneWidget);

      // Press ArrowDown to move to first item
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      // Press Enter to select the item
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(controller.selectedItems.any((i) => i.value == 'apple'), isTrue);
    });
  });
}
