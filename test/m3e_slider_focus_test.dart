// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M3ESlider focus behavior', () {
    testWidgets('touch and drag do not request focus or show focus ring', (
      tester,
    ) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 48,
                child: StatefulBuilder(
                  builder: (context, setState) => M3ESlider(
                    value: value,
                    focusNode: focusNode,
                    onChanged: (v) => setState(() => value = v),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final sliderFinder = find.byType(M3ESlider);
      final dynamic state = tester.state(sliderFinder);

      expect(focusNode.hasFocus, isFalse);
      expect(state.isFocusedForTesting, isFalse);

      // Tap on the slider with touch
      final tapGesture = await tester.startGesture(
        tester.getCenter(sliderFinder),
        kind: PointerDeviceKind.touch,
      );
      await tester.pump();
      await tapGesture.up();
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isFalse);
      expect(state.isFocusedForTesting, isFalse);

      // Drag the slider with touch
      final dragGesture = await tester.startGesture(
        tester.getCenter(sliderFinder),
        kind: PointerDeviceKind.touch,
      );
      await tester.pump();
      await dragGesture.moveBy(const Offset(40, 0));
      await tester.pump();
      await dragGesture.up();
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isFalse);
      expect(state.isFocusedForTesting, isFalse);
    });

    testWidgets('keyboard Tab focuses the slider and touch unfocuses it', (
      tester,
    ) async {
      double value = 0.5;
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 48,
                child: StatefulBuilder(
                  builder: (context, setState) => M3ESlider(
                    value: value,
                    focusNode: focusNode,
                    onChanged: (v) => setState(() => value = v),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final sliderFinder = find.byType(M3ESlider);
      final dynamic state = tester.state(sliderFinder);

      // Navigate to the slider using Tab
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      expect(state.isFocusedForTesting, isTrue);

      // Subsequent touch interaction clears focus
      final gesture = await tester.startGesture(
        tester.getCenter(sliderFinder),
        kind: PointerDeviceKind.touch,
      );
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
      expect(state.isFocusedForTesting, isFalse);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isFalse);
      expect(state.isFocusedForTesting, isFalse);
    });
  });

  group('M3ERangeSlider focus behavior', () {
    testWidgets('touch and drag do not request focus or show focus rings', (
      tester,
    ) async {
      RangeValues range = const RangeValues(0.3, 0.7);
      final startFocusNode = FocusNode();
      final endFocusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 48,
                child: StatefulBuilder(
                  builder: (context, setState) => M3ERangeSlider(
                    value: range,
                    startFocusNode: startFocusNode,
                    endFocusNode: endFocusNode,
                    onChanged: (v) => setState(() => range = v),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final rangeSliderFinder = find.byType(M3ERangeSlider);
      final dynamic state = tester.state(rangeSliderFinder);

      expect(startFocusNode.hasFocus, isFalse);
      expect(endFocusNode.hasFocus, isFalse);
      expect(state.isStartFocusedForTesting, isFalse);
      expect(state.isEndFocusedForTesting, isFalse);

      // Tap on the range slider
      final tapGesture = await tester.startGesture(
        tester.getCenter(rangeSliderFinder),
        kind: PointerDeviceKind.touch,
      );
      await tester.pump();
      await tapGesture.up();
      await tester.pumpAndSettle();

      expect(startFocusNode.hasFocus, isFalse);
      expect(endFocusNode.hasFocus, isFalse);
      expect(state.isStartFocusedForTesting, isFalse);
      expect(state.isEndFocusedForTesting, isFalse);
    });

    testWidgets('keyboard Tab focuses thumbs and touch unfocuses them', (
      tester,
    ) async {
      RangeValues range = const RangeValues(0.3, 0.7);
      final startFocusNode = FocusNode();
      final endFocusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 48,
                child: StatefulBuilder(
                  builder: (context, setState) => M3ERangeSlider(
                    value: range,
                    startFocusNode: startFocusNode,
                    endFocusNode: endFocusNode,
                    onChanged: (v) => setState(() => range = v),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final rangeSliderFinder = find.byType(M3ERangeSlider);
      final dynamic state = tester.state(rangeSliderFinder);

      // Tab to start thumb
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(startFocusNode.hasFocus, isTrue);
      expect(state.isStartFocusedForTesting, isTrue);
      expect(endFocusNode.hasFocus, isFalse);

      // Touch on range slider unfocuses
      final gesture = await tester.startGesture(
        tester.getCenter(rangeSliderFinder),
        kind: PointerDeviceKind.touch,
      );
      await tester.pump();
      expect(startFocusNode.hasFocus, isFalse);
      expect(state.isStartFocusedForTesting, isFalse);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
