// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  testWidgets('M3EPullToRefreshIndicator renders child correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: M3EPullToRefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              children: const [Text('Test Item 1'), Text('Test Item 2')],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Item 1'), findsOneWidget);
    expect(find.text('Test Item 2'), findsOneWidget);
  });

  testWidgets('M3EPullToRefreshIndicator triggers refresh on pull gesture', (
    WidgetTester tester,
  ) async {
    bool refreshed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: M3EPullToRefreshIndicator(
            triggerDistance: 80.0,
            onRefresh: () async {
              refreshed = true;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200, child: Text('Pull Target')),
              ],
            ),
          ),
        ),
      ),
    );

    expect(refreshed, isFalse);

    // Perform vertical drag gesture down
    final firstLocation = tester.getCenter(find.text('Pull Target'));
    await tester.dragFrom(firstLocation, const Offset(0.0, 300.0));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(refreshed, isTrue);
  });

  testWidgets('M3EPullToRefreshController programmatically triggers refresh', (
    WidgetTester tester,
  ) async {
    bool refreshed = false;
    final controller = M3EPullToRefreshController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: M3EPullToRefreshIndicator(
            controller: controller,
            onRefresh: () async {
              refreshed = true;
            },
            child: ListView(children: const [Text('Content')]),
          ),
        ),
      ),
    );

    expect(refreshed, isFalse);
    await controller.refresh();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(refreshed, isTrue);
  });

  test('M3EPullToRefreshStyle copyWith and lerp test', () {
    const style1 = M3EPullToRefreshStyle(
      containerColor: Colors.red,
      elevation: 2.0,
      triggerDistance: 80.0,
    );

    final style2 = style1.copyWith(containerColor: Colors.blue, elevation: 4.0);

    expect(style2.containerColor, Colors.blue);
    expect(style2.elevation, 4.0);
    expect(style2.triggerDistance, 80.0);

    final lerped = M3EPullToRefreshStyle.lerp(style1, style2, 0.5);
    expect(lerped, isNotNull);
    expect(lerped!.elevation, 3.0);
  });
}
