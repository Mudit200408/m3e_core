// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/menu/core/m3e_menu_position_provider.dart';

void main() {
  group('M3EMenuStyle Tests', () {
    test('default properties align with M3E specification', () {
      const style = M3EMenuStyle();
      expect(style.minWidth, isNull);
      expect(style.maxWidth, isNull);
      expect(style.elevation, isNull);
      expect(M3EMenuTokens.containerMinWidth, 112.0);
      expect(M3EMenuTokens.containerMaxWidth, 280.0);
    });

    test('copyWith updates properties accurately', () {
      const style = M3EMenuStyle();
      final updated = style.copyWith(
        minWidth: 150.0,
        maxWidth: 320.0,
        elevation: 6.0,
      );
      expect(updated.minWidth, 150.0);
      expect(updated.maxWidth, 320.0);
      expect(updated.elevation, 6.0);
    });

    test('lerp interpolates correctly', () {
      const a = M3EMenuStyle(minWidth: 100.0, maxWidth: 200.0);
      const b = M3EMenuStyle(minWidth: 200.0, maxWidth: 300.0);
      final lerped = M3EMenuStyle.lerp(a, b, 0.5);
      expect(lerped?.minWidth, 150.0);
      expect(lerped?.maxWidth, 250.0);
    });
  });

  group('M3EMenuController Tests', () {
    test('controller manages open/closed state correctly', () {
      final controller = M3EMenuController();
      expect(controller.isOpen, isFalse);

      bool notified = false;
      controller.addListener(() => notified = true);

      controller.open();
      expect(controller.isOpen, isTrue);
      expect(notified, isTrue);

      notified = false;
      controller.close();
      expect(controller.isOpen, isFalse);
      expect(notified, isTrue);

      controller.toggle();
      expect(controller.isOpen, isTrue);
    });
  });

  group('M3EMagicTriangle Tests', () {
    test('containsPoint identifies point inside and outside triangle', () {
      const a = Offset(10, 10);
      const b = Offset(50, 0);
      const c = Offset(50, 50);

      // Centroid or point clearly inside
      expect(
        M3EMagicTriangle.containsPoint(const Offset(30, 20), a, b, c),
        isTrue,
      );
      // Point clearly outside
      expect(
        M3EMagicTriangle.containsPoint(const Offset(0, 0), a, b, c),
        isFalse,
      );
      expect(
        M3EMagicTriangle.containsPoint(const Offset(100, 100), a, b, c),
        isFalse,
      );
    });
  });

  group('M3EMenuAnchor Widget Tests', () {
    testWidgets('opens menu on trigger tap and activates item', (tester) async {
      String? clickedItem;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EMenuAnchor(
                builder: (context, controller, child) {
                  return ElevatedButton(
                    onPressed: () => controller.toggle(),
                    child: const Text('Open'),
                  );
                },
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () => clickedItem = 'Item 1',
                    child: const Text('Item 1'),
                  ),
                  M3EMenuItemButton(
                    onPressed: () => clickedItem = 'Item 2',
                    child: const Text('Item 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Menu is initially closed
      expect(find.text('Item 1'), findsNothing);

      // Tap trigger to open
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      // Tap item 1
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();

      expect(clickedItem, equals('Item 1'));
      // Menu closes on tap
      expect(find.text('Item 1'), findsNothing);
    });

    testWidgets('checkbox and radio menu buttons update states', (
      tester,
    ) async {
      bool checkboxVal = false;
      String radioVal = 'A';

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: M3EMenuAnchor(
                    builder: (context, controller, child) {
                      return ElevatedButton(
                        onPressed: () => controller.toggle(),
                        child: const Text('Open Options'),
                      );
                    },
                    menuChildren: [
                      M3ECheckboxMenuButton(
                        value: checkboxVal,
                        closeOnActivate: false,
                        onChanged: (val) {
                          setState(() => checkboxVal = val ?? false);
                        },
                        child: const Text('Checkbox Option'),
                      ),
                      M3ERadioMenuButton<String>(
                        value: 'A',
                        groupValue: radioVal,
                        closeOnActivate: false,
                        onChanged: (val) {
                          setState(() => radioVal = val!);
                        },
                        child: const Text('Radio A'),
                      ),
                      M3ERadioMenuButton<String>(
                        value: 'B',
                        groupValue: radioVal,
                        closeOnActivate: false,
                        onChanged: (val) {
                          setState(() => radioVal = val!);
                        },
                        child: const Text('Radio B'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Open menu
      await tester.tap(find.text('Open Options'));
      await tester.pumpAndSettle();

      // Tap checkbox
      await tester.tap(find.text('Checkbox Option'));
      await tester.pumpAndSettle();
      expect(checkboxVal, isTrue);

      // Tap radio B
      await tester.tap(find.text('Radio B'));
      await tester.pumpAndSettle();
      expect(radioVal, equals('B'));
    });

    testWidgets(
      'cascading submenus: opening sibling submenu closes previous submenu without overlap',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EMenuAnchor(
                  builder: (context, controller, child) {
                    return ElevatedButton(
                      onPressed: () => controller.toggle(),
                      child: const Text('Open Cascading'),
                    );
                  },
                  menuChildren: [
                    M3EMenuItemButton(
                      onPressed: () {},
                      child: const Text('Regular Action'),
                    ),
                    const M3ESubmenuButton(
                      menuChildren: [
                        M3EMenuItemButton(
                          onPressed: null,
                          child: Text('Submenu 1 Item'),
                        ),
                      ],
                      child: Text('Submenu 1'),
                    ),
                    const M3ESubmenuButton(
                      menuChildren: [
                        M3EMenuItemButton(
                          onPressed: null,
                          child: Text('Submenu 2 Item'),
                        ),
                      ],
                      child: Text('Submenu 2'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Open root menu
        await tester.tap(find.text('Open Cascading'));
        await tester.pumpAndSettle();

        expect(find.text('Submenu 1'), findsOneWidget);
        expect(find.text('Submenu 2'), findsOneWidget);
        expect(find.text('Submenu 1 Item'), findsNothing);
        expect(find.text('Submenu 2 Item'), findsNothing);

        // Hover over Submenu 1 to open it
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.text('Submenu 1')));
        await tester.pumpAndSettle();

        // Submenu 1 is open
        expect(find.text('Submenu 1 Item'), findsOneWidget);
        expect(find.text('Submenu 2 Item'), findsNothing);

        // Move mouse to Submenu 2
        await gesture.moveTo(tester.getCenter(find.text('Submenu 2')));
        await tester.pumpAndSettle();

        // Submenu 1 is closed, Submenu 2 is open - NO OVERLAP!
        expect(find.text('Submenu 1 Item'), findsNothing);
        expect(find.text('Submenu 2 Item'), findsOneWidget);

        // Move mouse back to Regular Action in parent menu
        await gesture.moveTo(tester.getCenter(find.text('Regular Action')));
        await tester.pumpAndSettle();

        // Submenu 2 is automatically closed!
        expect(find.text('Submenu 2 Item'), findsNothing);
      },
    );

    testWidgets(
      'cascading submenus: moving from inside 2nd popup back to parent item closes submenu',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EMenuAnchor(
                  builder: (context, controller, child) {
                    return ElevatedButton(
                      onPressed: () => controller.toggle(),
                      child: const Text('Open Cascading'),
                    );
                  },
                  menuChildren: [
                    M3EMenuItemButton(
                      onPressed: () {},
                      child: const Text('Root Item'),
                    ),
                    const M3ESubmenuButton(
                      menuChildren: [
                        M3EMenuItemButton(
                          onPressed: null,
                          child: Text('Nested Item'),
                        ),
                      ],
                      child: Text('Submenu Trigger'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Open root menu
        await tester.tap(find.text('Open Cascading'));
        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Hover over trigger
        await gesture.moveTo(tester.getCenter(find.text('Submenu Trigger')));
        await tester.pumpAndSettle();
        expect(find.text('Nested Item'), findsOneWidget);

        // Move inside the 2nd popup (Nested Item)
        await gesture.moveTo(tester.getCenter(find.text('Nested Item')));
        await tester.pumpAndSettle();
        expect(find.text('Nested Item'), findsOneWidget);

        // Move mouse back to 1st menu (Root Item)
        await gesture.moveTo(tester.getCenter(find.text('Root Item')));
        await tester.pumpAndSettle();

        // 2nd popup should be closed automatically
        expect(find.text('Nested Item'), findsNothing);
        expect(find.text('Root Item'), findsOneWidget);
      },
    );

    testWidgets(
      'cascading submenus: clicking submenu item with closeOnActivate closes all menus',
      (tester) async {
        bool activated = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EMenuAnchor(
                  builder: (context, controller, child) {
                    return ElevatedButton(
                      onPressed: () => controller.toggle(),
                      child: const Text('Open Cascading'),
                    );
                  },
                  menuChildren: [
                    M3ESubmenuButton(
                      menuChildren: [
                        M3EMenuItemButton(
                          onPressed: () => activated = true,
                          child: const Text('Action Item'),
                        ),
                      ],
                      child: const Text('Submenu'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Cascading'));
        await tester.pumpAndSettle();

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.text('Submenu')));
        await tester.pumpAndSettle();
        expect(find.text('Action Item'), findsOneWidget);

        await tester.tap(find.text('Action Item'));
        await tester.pumpAndSettle();

        expect(activated, isTrue);
        expect(find.text('Action Item'), findsNothing);
        expect(find.text('Submenu'), findsNothing);
      },
    );
  });

  group('M3EMenuPositionProvider & Reveal Animation Tests', () {
    test(
      'calculateTransformOrigin computes top-right pivot for overflow button',
      () {
        // Anchor is a 40x40 button at x: 350..390, y: 40..80.
        const anchor = Rect.fromLTWH(350, 40, 40, 40);
        // Menu is 200 wide, 150 high placed below and end-aligned: x: 190..390, y: 80..230.
        const menu = Rect.fromLTWH(190, 80, 200, 150);

        final origin = M3EMenuPositionProvider.calculateTransformOrigin(
          anchorBounds: anchor,
          menuBounds: menu,
        );

        // Top edge (pivotY == 0.0)
        expect(origin.dy, 0.0);
        // Anchor center is 370. In menu coordinates (left=190, width=200): (370-190)/200 = 0.9.
        expect(origin.dx, closeTo(0.9, 0.01));
      },
    );

    test(
      'calculateTransformOrigin computes bottom pivot when menu is above anchor',
      () {
        // Anchor is a dropdown field at x: 20..380, y: 500..550.
        const anchor = Rect.fromLTWH(20, 500, 360, 50);
        // Menu is above anchor: x: 20..380, y: 250..500.
        const menu = Rect.fromLTWH(20, 250, 360, 250);

        final origin = M3EMenuPositionProvider.calculateTransformOrigin(
          anchorBounds: anchor,
          menuBounds: menu,
        );

        // Bottom edge (pivotY == 1.0)
        expect(origin.dy, 1.0);
        // Center aligned horizontally (dx == 0.5)
        expect(origin.dx, closeTo(0.5, 0.01));
      },
    );

    test(
      'calculateTransformOrigin computes left pivot for right-cascading submenu',
      () {
        // Parent item at x: 100..250, y: 100..148.
        const parentItem = Rect.fromLTWH(100, 100, 150, 48);
        // Submenu placed to the right: x: 250..400, y: 100..200.
        const submenu = Rect.fromLTWH(250, 100, 150, 100);

        final origin = M3EMenuPositionProvider.calculateTransformOrigin(
          anchorBounds: parentItem,
          menuBounds: submenu,
        );

        // Left edge (pivotX == 0.0)
        expect(origin.dx, 0.0);
        // Parent item center is 124. Submenu y: 100, height: 100 -> (124 - 100)/100 = 0.24.
        expect(origin.dy, closeTo(0.24, 0.01));
      },
    );

    test('calculate incorporates transformOrigin into M3EMenuLayoutResult', () {
      const anchor = Rect.fromLTWH(300, 50, 40, 40);
      const menuSize = Size(200, 150);
      const windowSize = Size(400, 800);

      final layout = M3EMenuPositionProvider.calculate(
        anchorBounds: anchor,
        menuSize: menuSize,
        windowSize: windowSize,
      );

      expect(layout.transformOrigin, isA<FractionalOffset>());
      expect(layout.transformOrigin.dy, 0.0);
      expect(layout.transformOrigin.dx, greaterThan(0.5));
    });

    test('calculate anchors to top when menu is below button', () {
      const anchor = Rect.fromLTWH(100, 100, 100, 40);
      const menuSize = Size(200, 150);
      const windowSize = Size(800, 1000);

      final layout = M3EMenuPositionProvider.calculate(
        anchorBounds: anchor,
        menuSize: menuSize,
        windowSize: windowSize,
      );

      expect(layout.isAbove, isFalse);
      expect(layout.top, 140.0 + M3EMenuTokens.anchorGap);
      expect(layout.bottom, isNull);
      expect(layout.left, 100.0);
      expect(layout.right, isNull);
      expect(layout.availableHeight, greaterThan(700));
    });

    test('calculate anchors to bottom when menu is above button', () {
      const anchor = Rect.fromLTWH(100, 850, 100, 40);
      const menuSize = Size(200, 200);
      const windowSize = Size(800, 1000);

      final layout = M3EMenuPositionProvider.calculate(
        anchorBounds: anchor,
        menuSize: menuSize,
        windowSize: windowSize,
      );

      expect(layout.isAbove, isTrue);
      expect(layout.top, isNull);
      expect(layout.bottom, isNotNull);
      // Window height (1000) - anchorBounds.top (850) + anchorGap (8) = 158 from bottom
      expect(layout.bottom, 150.0 + M3EMenuTokens.anchorGap);
      expect(layout.left, 100.0);
      expect(layout.right, isNull);
      expect(layout.availableHeight, lessThan(850));
    });

    test('calculate anchors to right when menu flips to the left', () {
      const anchor = Rect.fromLTWH(700, 100, 80, 40);
      const menuSize = Size(200, 150);
      const windowSize = Size(800, 1000);

      final layout = M3EMenuPositionProvider.calculate(
        anchorBounds: anchor,
        menuSize: menuSize,
        windowSize: windowSize,
      );

      expect(layout.isLeft, isTrue);
      expect(layout.left, isNull);
      expect(layout.right, isNotNull);
    });

    test('calculate detects when menu covers or overlaps anchor', () {
      const anchor = Rect.fromLTWH(100, 200, 100, 40);
      const menuSize = Size(200, 400);
      const windowSize = Size(300, 450);

      final layout = M3EMenuPositionProvider.calculate(
        anchorBounds: anchor,
        menuSize: menuSize,
        windowSize: windowSize,
      );

      expect(layout.isCoveringAnchor, isTrue);
      expect(layout.top, isNotNull);
      expect(layout.bottom, isNull);
      expect(layout.left, isNull);
      expect(layout.right, isNotNull);
    });
  });

  group('M3E Menu Verified Review Tests (F1-F11)', () {
    testWidgets(
      'F1: Tap item twice within 100ms fires onPressed exactly once',
      (tester) async {
        int tapCount = 0;
        final controller = M3EMenuController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EMenuAnchor(
                controller: controller,
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () => tapCount++,
                    child: const Text('Action'),
                  ),
                ],
                builder: (context, controller, child) => ElevatedButton(
                  onPressed: () => controller.open(),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.text('Action'), findsOneWidget);

        // First tap starts closeAll() and calls onPressed
        await tester.tap(find.text('Action'));
        await tester.pump(const Duration(milliseconds: 50));
        // Second tap while still dismissing
        if (find.text('Action').evaluate().isNotEmpty) {
          await tester.tap(find.text('Action'), warnIfMissed: false);
        }
        await tester.pumpAndSettle();
        expect(tapCount, equals(1));
      },
    );

    testWidgets(
      'F3a: Open and close in same frame leaves no barrier or overlay',
      (tester) async {
        final controller = M3EMenuController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EMenuAnchor(
                controller: controller,
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () {},
                    child: const Text('Item'),
                  ),
                ],
                child: const Text('Anchor'),
              ),
            ),
          ),
        );

        controller.open();
        controller.close();
        await tester.pumpAndSettle();

        expect(find.text('Item'), findsNothing);
      },
    );

    testWidgets('F2: Swap controller on an open anchor without error', (
      tester,
    ) async {
      final ctrl1 = M3EMenuController();
      final ctrl2 = M3EMenuController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EMenuAnchor(
              controller: ctrl1,
              menuChildren: [
                M3EMenuItemButton(onPressed: () {}, child: const Text('Item')),
              ],
              child: const Text('Anchor'),
            ),
          ),
        ),
      );

      ctrl1.open();
      await tester.pumpAndSettle();
      expect(find.text('Item'), findsOneWidget);

      // Re-render with ctrl2
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EMenuAnchor(
              controller: ctrl2,
              menuChildren: [
                M3EMenuItemButton(onPressed: () {}, child: const Text('Item')),
              ],
              child: const Text('Anchor'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(ctrl1.isOpen, isFalse);
    });

    testWidgets(
      'F3b: Dispose open anchor resets controller so it can open again',
      (tester) async {
        final controller = M3EMenuController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EMenuAnchor(
                controller: controller,
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () {},
                    child: const Text('Item'),
                  ),
                ],
                child: const Text('Anchor'),
              ),
            ),
          ),
        );

        controller.open();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);

        // Remove anchor from tree
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox())),
        );
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);

        // Mount new anchor with same controller and open it
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EMenuAnchor(
                controller: controller,
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () {},
                    child: const Text('Item'),
                  ),
                ],
                child: const Text('Anchor'),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
        expect(find.text('Item'), findsOneWidget);
      },
    );

    testWidgets('F4: Three-level submenu stays open when child is hovered', (
      tester,
    ) async {
      final rootCtrl = M3EMenuController();
      final l2Ctrl = M3EMenuController();
      final l3Ctrl = M3EMenuController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EMenuAnchor(
              controller: rootCtrl,
              menuChildren: [
                M3ESubmenuButton(
                  controller: l2Ctrl,
                  menuChildren: [
                    M3ESubmenuButton(
                      controller: l3Ctrl,
                      menuChildren: [
                        M3EMenuItemButton(
                          onPressed: () {},
                          child: const Text('L3 Item'),
                        ),
                      ],
                      child: const Text('L2 Submenu'),
                    ),
                  ],
                  child: const Text('L1 Submenu'),
                ),
              ],
              child: const Text('Root Trigger'),
            ),
          ),
        ),
      );

      rootCtrl.open();
      await tester.pumpAndSettle();

      l2Ctrl.open();
      await tester.pumpAndSettle();
      expect(find.text('L2 Submenu'), findsOneWidget);

      l3Ctrl.open();
      await tester.pumpAndSettle();
      expect(find.text('L3 Item'), findsOneWidget);

      // Advance 500ms - L2 has open child (L3), so L2 should re-arm and stay open
      await tester.pump(const Duration(milliseconds: 500));
      expect(l2Ctrl.isOpen, isTrue);
      expect(find.text('L2 Submenu'), findsOneWidget);
      expect(find.text('L3 Item'), findsOneWidget);
    });

    test(
      'F5: position over in bottom 56dp produces non-trivial availableHeight and null bottom',
      () {
        const anchor = Rect.fromLTWH(100, 750, 100, 40);
        const menuSize = Size(200, 300);
        const windowSize = Size(800, 800);

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchor,
          menuSize: menuSize,
          windowSize: windowSize,
          position: M3EMenuPosition.over,
        );

        expect(layout.bottom, isNull);
        expect(layout.top, isNotNull);
        expect(layout.availableHeight, greaterThan(0.0));
      },
    );

    test(
      'F5 & F8: position over hangs from top with availableHeight to bottom margin',
      () {
        const anchor = Rect.fromLTWH(100, 300, 100, 50);
        const menuSize = Size(200, 250);
        const windowSize = Size(800, 600);

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchor,
          menuSize: menuSize,
          windowSize: windowSize,
          position: M3EMenuPosition.over,
        );

        expect(layout.top, 200.0);
        expect(layout.bottom, isNull);
        expect(
          layout.availableHeight,
          600.0 - 200.0 - M3EMenuTokens.screenMarginVertical,
        );
      },
    );

    test(
      'F6: above-anchor bottom includes alignmentOffset.dy with positive sign',
      () {
        const anchor = Rect.fromLTWH(100, 850, 100, 40);
        const menuSize = Size(200, 200);
        const windowSize = Size(800, 1000);
        const offset = Offset(0, 12);

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchor,
          menuSize: menuSize,
          windowSize: windowSize,
          alignmentOffset: offset,
        );

        expect(layout.isAbove, isTrue);
        expect(layout.bottom, 150.0 + M3EMenuTokens.anchorGap + 12.0);
      },
    );

    test(
      'F7: bottomInset reduces usableHeight and triggers above-flip without breaking bottom Positioned',
      () {
        const anchor = Rect.fromLTWH(100, 400, 100, 40);
        const menuSize = Size(200, 250);
        const windowSize = Size(800, 800);
        const bottomInset = 300.0;

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchor,
          menuSize: menuSize,
          windowSize: windowSize,
          bottomInset: bottomInset,
        );

        expect(layout.isAbove, isTrue);
        expect(layout.bottom, (800.0 - 400.0) + M3EMenuTokens.anchorGap);
      },
    );

    test(
      'F8b: anchor near right edge flips menu to the left to avoid overflow',
      () {
        const anchor = Rect.fromLTWH(600, 100, 100, 40);
        const menuSize = Size(M3EMenuTokens.containerMaxWidth, 200);
        const windowSize = Size(800, 1000);

        final layout = M3EMenuPositionProvider.calculate(
          anchorBounds: anchor,
          menuSize: menuSize,
          windowSize: windowSize,
        );

        expect(layout.isLeft, isTrue);
        expect(layout.left, isNull);
        expect(layout.right, isNotNull);
      },
    );

    testWidgets(
      'F11: Popup item with value: null triggers onCanceled and not onSelected',
      (tester) async {
        Object? selectedValue;
        bool canceled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EPopupMenuButton<String>(
                onSelected: (val) => selectedValue = val,
                onCanceled: () => canceled = true,
                itemBuilder: (context) => [
                  const M3EPopupMenuItem<String>(
                    value: null,
                    child: Text('Cancel Item'),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byType(M3EPopupMenuButton<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel Item'));
        await tester.pumpAndSettle();

        expect(selectedValue, isNull);
        expect(canceled, isTrue);
      },
    );

    testWidgets('F20: Directionality of subtree is preserved in overlay', (
      tester,
    ) async {
      final controller = M3EMenuController();
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: M3EMenuAnchor(
                controller: controller,
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () {},
                    child: const Text('RTL Item'),
                  ),
                ],
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pumpAndSettle();

      expect(
        Directionality.of(tester.element(find.text('RTL Item'))),
        equals(TextDirection.rtl),
      );
    });

    testWidgets(
      'F19: controller.open(position:) positions menu relative to custom offset',
      (tester) async {
        final controller = M3EMenuController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: M3EMenuAnchor(
                    controller: controller,
                    menuChildren: [
                      M3EMenuItemButton(
                        onPressed: () {},
                        child: const Text('Point Item'),
                      ),
                    ],
                    child: const SizedBox(width: 300, height: 300),
                  ),
                ),
              ),
            ),
          ),
        );

        controller.open(position: const Offset(150, 150));
        await tester.pumpAndSettle();

        final itemTopLeft = tester.getTopLeft(find.text('Point Item'));
        expect(itemTopLeft.dy, greaterThanOrEqualTo(150.0));
      },
    );

    testWidgets('F18: Semantics properties are assigned to item buttons', (
      tester,
    ) async {
      final controller = M3EMenuController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EMenuAnchor(
              controller: controller,
              menuChildren: [
                M3EMenuItemButton(
                  onPressed: () {},
                  semanticsLabel: 'Accessible Action',
                  child: const Text('Action'),
                ),
                M3ECheckboxMenuButton(
                  value: true,
                  onChanged: (_) {},
                  child: const Text('Check Item'),
                ),
                M3ERadioMenuButton<String>(
                  value: 'A',
                  groupValue: 'A',
                  onChanged: (_) {},
                  child: const Text('Radio Item'),
                ),
              ],
              child: const Text('Open'),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byType(M3EMenuItemButton)),
        matchesSemantics(
          label: 'Accessible Action',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.byType(M3ECheckboxMenuButton)),
        matchesSemantics(
          label: 'Check Item',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.byType(M3ERadioMenuButton<String>)),
        matchesSemantics(
          label: 'Radio Item',
          isSelected: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
    });

    testWidgets(
      'M3EMenuItemRow centers trailing content and leading icon vertically',
      (tester) async {
        final controller = M3EMenuController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EMenuAnchor(
                controller: controller,
                menuChildren: [
                  M3EMenuItemButton(
                    onPressed: () {},
                    leadingIcon: const Icon(Icons.delete_forever_rounded),
                    trailingIcon: const Text(
                      '⌫',
                      style: TextStyle(fontSize: 12),
                    ),
                    child: const Text('Delete document'),
                  ),
                ],
                child: const Text('Open'),
              ),
            ),
          ),
        );

        controller.open();
        await tester.pumpAndSettle();

        final leadRect = tester.getRect(
          find.byIcon(Icons.delete_forever_rounded),
        );
        final labelRect = tester.getRect(find.text('Delete document'));
        final trailRect = tester.getRect(find.text('⌫'));

        // Trailing text and leading icon centers should align with the row/label center
        expect((trailRect.center.dy - leadRect.center.dy).abs(), lessThan(1.0));
        expect(
          (trailRect.center.dy - labelRect.center.dy).abs(),
          lessThan(1.0),
        );
      },
    );
  });
}
