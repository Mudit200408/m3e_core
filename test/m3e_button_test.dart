// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EButtonSize', () {
    test('fromBase preserves base size variant name and overrides width', () {
      final customXl = M3EButtonSize.fromBase(M3EButtonSize.xl, width: 80);
      expect(customXl.name, 'xl');
      expect(customXl.width, 80);
    });

    test('fromBase preserves base size variant name and overrides height', () {
      final customSm = M3EButtonSize.fromBase(M3EButtonSize.sm, height: 48);
      expect(customSm.name, 'sm');
      expect(customSm.height, 48);
    });
  });

  group('M3EToggleButtonGroup Action Widths', () {
    testWidgets(
      'action.width preserves group token height and applies custom width',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EToggleButtonGroup(
                  size: M3EButtonSize.xl,
                  selectedIndex: 0,
                  onSelectedIndexChanged: (_) {},
                  actions: const [
                    M3EToggleButtonGroupAction(icon: Icon(Icons.bluetooth)),
                    M3EToggleButtonGroupAction(
                      icon: Icon(Icons.alarm),
                      width: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final buttons = tester.widgetList<M3EToggleButton>(
          find.byType(M3EToggleButton).hitTestable(),
        );
        expect(buttons.length, 2);

        // Both buttons should preserve XL height tokens
        final firstButton = buttons.elementAt(0);
        final secondButton = buttons.elementAt(1);

        expect(firstButton.size.name, 'xl');
        expect(secondButton.size.name, 'xl');
        expect(secondButton.size.width, 80);
      },
    );
  });

  group('M3EToggleButtonGroup connected corners', () {
    String outerSide(WidgetTester tester, Finder button) {
      final material = tester.widget<Material>(
        find.descendant(of: button, matching: find.byType(Material)).first,
      );
      final radius = (material.shape! as RoundedRectangleBorder).borderRadius
          .resolve(Directionality.of(tester.element(button)));
      return radius.topLeft.x > radius.topRight.x ? 'left' : 'right';
    }

    for (final direction in TextDirection.values) {
      testWidgets('end buttons round their outer edge in ${direction.name}', (
        WidgetTester tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: direction,
              child: Scaffold(
                body: Center(
                  child: M3EToggleButtonGroup(
                    type: M3EButtonGroupType.connected,
                    selectedIndex: 1,
                    onSelectedIndexChanged: (_) {},
                    actions: const [
                      M3EToggleButtonGroupAction(label: Text('A')),
                      M3EToggleButtonGroupAction(label: Text('B')),
                      M3EToggleButtonGroupAction(label: Text('C')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act
        // The group also builds hidden, unconnected buttons to measure them.
        final buttons = find.byWidgetPredicate(
          (widget) => widget is M3EToggleButton && widget.isGroupConnected,
        );
        final byLeftEdge =
            [for (var i = 0; i < buttons.evaluate().length; i++) buttons.at(i)]
              ..sort(
                (a, b) =>
                    tester.getRect(a).left.compareTo(tester.getRect(b).left),
              );
        final sides = [
          outerSide(tester, byLeftEdge.first),
          outerSide(tester, byLeftEdge.last),
        ];

        // Assert
        expect(sides, ['left', 'right']);
      });
    }
  });

  group('M3ESplitButtonDecoration', () {
    test('styleFrom preserves borderRadius', () {
      final dec = M3ESplitButtonDecoration.styleFrom(
        borderRadius: 20.0,
        gap: 6.0,
      );
      expect(dec.borderRadius, 20.0);
      expect(dec.gap, 6.0);
    });
  });

  group('Button Splash Factory Defaults', () {
    testWidgets('M3EButton defaults to InkSparkle.splashFactory', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EButton(onPressed: () {}, child: const Text('Test')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ButtonStyleButton>(
        find.byWidgetPredicate(
          (w) =>
              w is ElevatedButton ||
              w is FilledButton ||
              w is OutlinedButton ||
              w is TextButton,
        ),
      );
      expect(button.style?.splashFactory, InkSparkle.splashFactory);
    });

    testWidgets('M3EToggleButton defaults to InkSparkle.splashFactory', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EToggleButton(
              onCheckedChange: (_) {},
              icon: const Icon(Icons.star),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ButtonStyleButton>(
        find.byWidgetPredicate(
          (w) =>
              w is ElevatedButton ||
              w is FilledButton ||
              w is OutlinedButton ||
              w is TextButton,
        ),
      );
      expect(button.style?.splashFactory, InkSparkle.splashFactory);
    });

    testWidgets(
      'M3ESplitButton defaults to InkSparkle.splashFactory on segments',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3ESplitButton(
                onPressed: () {},
                label: 'Split',
                items: const [M3ESplitButtonItem(value: 1, child: Text('1'))],
                onSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final inkWells = tester.widgetList<InkWell>(find.byType(InkWell));
        expect(inkWells.isNotEmpty, isTrue);
        for (final inkWell in inkWells) {
          expect(inkWell.splashFactory, InkSparkle.splashFactory);
        }
      },
    );

    test('M3EToggleButtonDecoration supports splashFactory', () {
      const dec = M3EToggleButtonDecoration(
        splashFactory: InkRipple.splashFactory,
      );
      expect(dec.splashFactory, InkRipple.splashFactory);

      final copy = dec.copyWith(splashFactory: InkSparkle.splashFactory);
      expect(copy.splashFactory, InkSparkle.splashFactory);

      final fromStyle = M3EToggleButtonDecoration.styleFrom(
        splashFactory: InkRipple.splashFactory,
      );
      expect(fromStyle.splashFactory, InkRipple.splashFactory);
    });

    test('M3EToggleButtonDecoration supports minSquishPadding', () {
      const dec = M3EToggleButtonDecoration(minSquishPadding: 6.0);
      expect(dec.minSquishPadding, 6.0);

      final copy = dec.copyWith(minSquishPadding: 2.0);
      expect(copy.minSquishPadding, 2.0);

      final fromStyle = M3EToggleButtonDecoration.styleFrom(
        minSquishPadding: 8.0,
      );
      expect(fromStyle.minSquishPadding, 8.0);
    });
  });

  group('M3EToggleButtonGroup MinSquishPadding', () {
    testWidgets(
      'group propagates minSquishPadding and allows action override',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: M3EToggleButtonGroup(
                  minSquishPadding: 2.0,
                  selectedIndex: 0,
                  onSelectedIndexChanged: (_) {},
                  actions: const [
                    M3EToggleButtonGroupAction(
                      icon: Icon(Icons.format_bold),
                      label: Text('Bold'),
                    ),
                    M3EToggleButtonGroupAction(
                      icon: Icon(Icons.format_italic),
                      label: Text('Italic'),
                      minSquishPadding: 6.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final buttons = tester.widgetList<M3EToggleButton>(
          find.byType(M3EToggleButton).hitTestable(),
        );
        expect(buttons.length, 2);

        expect(buttons.elementAt(0).minSquishPadding, 2.0);
        expect(buttons.elementAt(1).minSquishPadding, 6.0);
      },
    );

    testWidgets(
      'labels remain rendered and visible during neighbor squishing',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 260,
                  child: M3EToggleButtonGroup(
                    neighborSquish: true,
                    expandedRatio: 0.25,
                    minSquishPadding: 2.0,
                    selectedIndex: 0,
                    onSelectedIndexChanged: (_) {},
                    actions: const [
                      M3EToggleButtonGroupAction(
                        icon: Icon(Icons.format_bold),
                        label: Text('Bold'),
                      ),
                      M3EToggleButtonGroupAction(
                        icon: Icon(Icons.format_italic),
                        label: Text('Italic'),
                      ),
                      M3EToggleButtonGroupAction(
                        icon: Icon(Icons.format_underlined),
                        label: Text('Underline'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the third action to squish neighbors
        await tester.tap(find.byType(M3EToggleButton).hitTestable().last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify all labels are still found in tree
        expect(find.text('Bold'), findsWidgets);
        expect(find.text('Italic'), findsWidgets);
        expect(find.text('Underline'), findsWidgets);
      },
    );
  });
}
