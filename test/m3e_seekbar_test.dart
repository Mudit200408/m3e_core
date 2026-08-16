// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  testWidgets('M3ESeekbar renders with circle handle shape token', (
    WidgetTester tester,
  ) async {
    double value = 0.5;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: M3ESeekbar(
              value: value,
              secondaryTrackValue: 0.8,
              onChanged: (val) => value = val,
              handleShape: M3ESeekbarHandleShape.circle,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(M3ESeekbar), findsOneWidget);
  });

  testWidgets('M3ESeekbar renders with rectangle handle shape token', (
    WidgetTester tester,
  ) async {
    double value = 0.3;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: M3ESeekbar(
              value: value,
              onChanged: (val) => value = val,
              handleShape: M3ESeekbarHandleShape.rectangle,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(M3ESeekbar), findsOneWidget);
  });

  testWidgets('M3EWavySeekbar renders and responds to drag gesture', (
    WidgetTester tester,
  ) async {
    double value = 0.2;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              child: M3EWavySeekbar(
                value: value,
                secondaryTrackValue: 0.7,
                onChanged: (val) => value = val,
                handleShape: M3ESeekbarHandleShape.rectangle,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(M3EWavySeekbar), findsOneWidget);

    final seekbarFinder = find.byType(M3EWavySeekbar);
    await tester.drag(seekbarFinder, const Offset(100, 0));
    await tester.pump(const Duration(milliseconds: 100));

    expect(value, greaterThan(0.2));
  });
}
