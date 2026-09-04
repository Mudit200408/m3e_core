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
          find.byType(M3EToggleButton),
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
  });
}
