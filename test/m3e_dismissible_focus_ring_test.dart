// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/dismissible/internal/_dismissible_focus_ring.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DismissibleFocusRing Unit & Integration Tests', () {
    testWidgets(
      'DismissibleFocusRing renders concentric focus ring when focused',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const Scaffold(
              body: Center(
                child: DismissibleFocusRing(
                  focused: true,
                  radius: BorderRadius.all(Radius.circular(18)),
                  color: Colors.green,
                  gap: 0.0,
                  width: 2.0,
                  child: SizedBox(width: 200, height: 60),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(DismissibleFocusRing), findsOneWidget);
        expect(find.byType(AnimatedContainer), findsOneWidget);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(decoration.border!.top.color, Colors.green);
        expect(decoration.border!.top.width, 2.0);
        // when gap = 0.0, radius is unchanged = 18
        expect(
          decoration.borderRadius,
          const BorderRadius.all(Radius.circular(18)),
        );
      },
    );

    testWidgets('M3EDismissibleCardList card shows focus ring on focus', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EDismissibleCardList(
              itemCount: 2,
              itemBuilder: (context, index) => Text('Item $index'),
              style: const M3EDismissibleCardStyle(
                focusRingColor: Colors.orange,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DismissibleFocusRing), findsNWidgets(2));
      final ring0 = tester.widget<DismissibleFocusRing>(
        find.byType(DismissibleFocusRing).first,
      );
      expect(ring0.focused, isFalse);

      // Focus via InkWell focus
      final inkWellFinder = find.byType(InkWell).first;
      final inkWell = tester.widget<InkWell>(inkWellFinder);
      expect(inkWell.onFocusChange, isNotNull);
      inkWell.onFocusChange!(true);
      await tester.pumpAndSettle();

      final ring0After = tester.widget<DismissibleFocusRing>(
        find.byType(DismissibleFocusRing).first,
      );
      expect(ring0After.focused, isTrue);
      expect(ring0After.color, Colors.orange);
    });
  });
}
