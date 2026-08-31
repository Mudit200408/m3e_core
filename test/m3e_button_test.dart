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
}
