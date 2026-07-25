// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3ELinearProgressIndicator tests', () {
    testWidgets('renders determinate linear indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ELinearProgressIndicator(value: 0.5),
          ),
        ),
      );

      expect(find.byType(M3ELinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders indeterminate linear indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ELinearProgressIndicator(value: null),
          ),
        ),
      );

      expect(find.byType(M3ELinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders in RTL mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: M3ELinearProgressIndicator(value: 0.5),
            ),
          ),
        ),
      );

      expect(find.byType(M3ELinearProgressIndicator), findsOneWidget);
    });

    testWidgets('occupies full width in Column with start alignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                M3ELinearProgressIndicator(value: 0.5),
              ],
            ),
          ),
        ),
      );

      final Size indicatorSize = tester.getSize(find.byType(M3ELinearProgressIndicator));
      expect(indicatorSize.width, equals(800.0));
    });
  });

  group('M3ECircularProgressIndicator tests', () {
    testWidgets('renders determinate circular indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ECircularProgressIndicator(value: 0.7),
          ),
        ),
      );

      expect(find.byType(M3ECircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders indeterminate circular indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ECircularProgressIndicator(value: null),
          ),
        ),
      );

      expect(find.byType(M3ECircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders in RTL mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: M3ECircularProgressIndicator(value: 0.7),
            ),
          ),
        ),
      );

      expect(find.byType(M3ECircularProgressIndicator), findsOneWidget);
    });
  });

  group('M3ELinearWavyProgressIndicator tests', () {
    testWidgets('renders determinate linear wavy indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ELinearWavyProgressIndicator(value: 0.4),
          ),
        ),
      );

      expect(find.byType(M3ELinearWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('renders indeterminate linear wavy indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ELinearWavyProgressIndicator(value: null),
          ),
        ),
      );

      expect(find.byType(M3ELinearWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('renders in RTL mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: M3ELinearWavyProgressIndicator(value: 0.4),
            ),
          ),
        ),
      );

      expect(find.byType(M3ELinearWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('animates smoothly when progress decreases (reverse animation)', (tester) async {
      double value = 0.8;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    M3ELinearWavyProgressIndicator(value: value),
                    ElevatedButton(
                      onPressed: () => setState(() => value = 0.2),
                      child: const Text('Decrease'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      expect(find.byType(M3ELinearWavyProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Decrease'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 250)); // Mid animation
      await tester.pump(const Duration(milliseconds: 500)); // Finish progress animation

      expect(find.byType(M3ELinearWavyProgressIndicator), findsOneWidget);
    });
  });

  group('M3ECircularWavyProgressIndicator tests', () {
    testWidgets('renders determinate circular wavy indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ECircularWavyProgressIndicator(value: 0.6),
          ),
        ),
      );

      expect(find.byType(M3ECircularWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('renders indeterminate circular wavy indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ECircularWavyProgressIndicator(value: null),
          ),
        ),
      );

      expect(find.byType(M3ECircularWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('renders in RTL mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: M3ECircularWavyProgressIndicator(value: 0.6),
            ),
          ),
        ),
      );

      expect(find.byType(M3ECircularWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('renders determinate circular wavy indicator with waveSpeed = 0 (non-animating)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3ECircularWavyProgressIndicator(
              value: 0.6,
              waveSpeed: 0.0,
            ),
          ),
        ),
      );

      expect(find.byType(M3ECircularWavyProgressIndicator), findsOneWidget);
    });

    testWidgets('animates smoothly when progress decreases (reverse animation)', (tester) async {
      double value = 0.8;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    M3ECircularWavyProgressIndicator(value: value),
                    ElevatedButton(
                      onPressed: () => setState(() => value = 0.2),
                      child: const Text('Decrease'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      expect(find.byType(M3ECircularWavyProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Decrease'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 250)); // Mid animation
      await tester.pump(const Duration(milliseconds: 500)); // Finish progress animation

      expect(find.byType(M3ECircularWavyProgressIndicator), findsOneWidget);
    });
  });
}
