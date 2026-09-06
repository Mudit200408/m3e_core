// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:m3e_core/src/segmented_list/internal/_segmented_focus_ring.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SegmentedFocusRing Unit & Integration Tests', () {
    testWidgets(
      'SegmentedFocusRing renders positioned focus ring when focused',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.light(primary: Colors.blue),
            ),
            home: const Scaffold(
              body: Center(
                child: SegmentedFocusRing(
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

        expect(find.byType(SegmentedFocusRing), findsOneWidget);
        expect(find.byType(AnimatedContainer), findsOneWidget);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
        expect(decoration.border!.top.color, Colors.red);
        expect(decoration.border!.top.width, 2.0);
        // when gap = 0.0, radius is unchanged = 16
        expect(
          decoration.borderRadius,
          const BorderRadius.all(Radius.circular(16)),
        );
      },
    );

    testWidgets(
      'M3ESegmentedItem displays focus ring when focusNode is focused',
      (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3ESegmentedItem(
                index: 0,
                focusNode: focusNode,
                position: M3ESegmentedItemPosition.single,
                outerRadius: 24.0,
                innerRadius: 4.0,
                focusRingColor: Colors.purple,
                onTap: (_) {},
                child: const Text('Focusable Item'),
              ),
            ),
          ),
        );

        // Initially not focused
        expect(find.byType(SegmentedFocusRing), findsOneWidget);
        final focusRingBefore = tester.widget<SegmentedFocusRing>(
          find.byType(SegmentedFocusRing),
        );
        expect(focusRingBefore.focused, isFalse);

        // Request focus
        focusNode.requestFocus();
        await tester.pumpAndSettle();

        final focusRingAfter = tester.widget<SegmentedFocusRing>(
          find.byType(SegmentedFocusRing),
        );
        expect(focusRingAfter.focused, isTrue);
        expect(focusRingAfter.color, Colors.purple);
      },
    );

    testWidgets(
      'M3ESegmentedItem with internal focusNode loses focus ring when external button is focused',
      (tester) async {
        final buttonFocusNode = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    focusNode: buttonFocusNode,
                    icon: const Icon(Icons.light_mode),
                    onPressed: () {},
                  ),
                ],
              ),
              body: M3ESegmentedItem(
                index: 0,
                position: M3ESegmentedItemPosition.single,
                outerRadius: 24.0,
                innerRadius: 4.0,
                focusRingColor: Colors.purple,
                onTap: (_) {},
                child: const Text('Item 0'),
              ),
            ),
          ),
        );

        // When external button is focused, segmented item should NOT show focus ring
        buttonFocusNode.requestFocus();
        await tester.pumpAndSettle();

        final focusRing = tester.widget<SegmentedFocusRing>(
          find.byType(SegmentedFocusRing),
        );
        expect(focusRing.focused, isFalse);
      },
    );
  });
}
