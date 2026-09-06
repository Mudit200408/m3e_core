// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/expandable/internal/_expandable_focus_ring.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExpandableFocusRing Unit & Integration Tests', () {
    testWidgets(
      'ExpandableFocusRing renders concentric focus ring when focused',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: const Scaffold(
              body: Center(
                child: ExpandableFocusRing(
                  focused: true,
                  radius: BorderRadius.all(Radius.circular(24)),
                  color: Colors.teal,
                  gap: 0.0,
                  width: 2.0,
                  child: SizedBox(width: 200, height: 60),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(ExpandableFocusRing), findsOneWidget);
        expect(find.byType(AnimatedContainer), findsOneWidget);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(decoration.border!.top.color, Colors.teal);
        expect(decoration.border!.top.width, 2.0);
        // when gap = 0.0, radius is unchanged = 24
        expect(
          decoration.borderRadius,
          const BorderRadius.all(Radius.circular(24)),
        );
      },
    );

    testWidgets('M3EExpandableItem shows focus ring on header focus', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EExpandableItem(
              index: 0,
              totalCount: 1,
              isExpanded: false,
              onToggle: () {},
              headerBuilder: (context, index, progress) =>
                  const Text('Header 0'),
              bodyBuilder: (context, index, progress) => const Text('Body 0'),
              decoration: const M3EExpandableStyle(
                focusRingColor: Colors.deepPurple,
              ),
              expandMotion: M3EMotion.expressiveSpatialFast,
              collapseMotion: M3EMotion.expressiveSpatialFast,
            ),
          ),
        ),
      );

      expect(find.byType(ExpandableFocusRing), findsOneWidget);
      final ringBefore = tester.widget<ExpandableFocusRing>(
        find.byType(ExpandableFocusRing),
      );
      expect(ringBefore.focused, isFalse);

      final inkWellFinder = find.byType(InkWell).first;
      final inkWell = tester.widget<InkWell>(inkWellFinder);
      expect(inkWell.onFocusChange, isNotNull);
      inkWell.onFocusChange!(true);
      await tester.pumpAndSettle();

      final ringAfter = tester.widget<ExpandableFocusRing>(
        find.byType(ExpandableFocusRing),
      );
      expect(ringAfter.focused, isTrue);
      expect(ringAfter.color, Colors.deepPurple);
    });
  });
}
