// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EFab tests', () {
    testWidgets('small FAB has 40x40 size and 24dp icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EFab(
              size: M3EFabSize.small,
              onPressed: null,
              icon: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(M3EFab)), const Size(40, 40));
    });

    testWidgets('medium FAB has 56x56 baseline size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EFab(
              size: M3EFabSize.medium,
              onPressed: null,
              icon: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(M3EFab)), const Size(56, 56));
    });

    testWidgets('large FAB has 96x96 size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EFab(
              size: M3EFabSize.large,
              onPressed: null,
              icon: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(M3EFab)), const Size(96, 96));
    });
  });

  group('M3EExtendedFab tests', () {
    testWidgets('small extended FAB has 40dp height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EExtendedFab(
              size: M3EFabSize.small,
              extended: true,
              label: 'Create',
              icon: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(M3EExtendedFab)).height, 40);
      expect(find.text('Create'), findsOneWidget);
    });

    testWidgets('large extended FAB has 96dp height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EExtendedFab(
              size: M3EFabSize.large,
              extended: true,
              label: 'Create',
              icon: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(M3EExtendedFab)).height, 96);
      expect(find.text('Create'), findsOneWidget);
    });
  });
}
