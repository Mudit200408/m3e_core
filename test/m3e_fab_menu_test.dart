// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EFabMenu Tests', () {
    testWidgets('renders closed FAB trigger by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EFabMenu(
                items: [
                  M3EFabMenuItem(
                    icon: const Icon(Icons.share),
                    label: 'Share',
                    onPressed: () {},
                  ),
                  M3EFabMenuItem(
                    icon: const Icon(Icons.favorite),
                    label: 'Favorite',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // FAB is visible
      expect(find.byType(M3EFab), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // Menu items are closed initially
      expect(find.text('Share'), findsNothing);
      expect(find.text('Favorite'), findsNothing);
    });

    testWidgets('tapping FAB opens menu and reveals items', (tester) async {
      bool openState = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EFabMenu(
                onOpenChanged: (open) => openState = open,
                items: [
                  M3EFabMenuItem(
                    icon: const Icon(Icons.share),
                    label: 'Share',
                    onPressed: () {},
                  ),
                  M3EFabMenuItem(
                    icon: const Icon(Icons.favorite),
                    label: 'Favorite',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Tap FAB to open
      await tester.tap(find.byType(M3EFab));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(openState, isTrue);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Favorite'), findsOneWidget);
    });

    testWidgets('tapping menu item calls callback and closes menu', (
      tester,
    ) async {
      bool shareTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EFabMenu(
                items: [
                  M3EFabMenuItem(
                    icon: const Icon(Icons.share),
                    label: 'Share',
                    onPressed: () => shareTapped = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Open menu
      await tester.tap(find.byType(M3EFab));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap Share item
      await tester.tap(find.text('Share'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(shareTapped, isTrue);
      expect(find.text('Share'), findsNothing);
    });

    testWidgets('large M3EFabMenu renders with 96x96 trigger', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EFabMenu(
                size: M3EFabSize.large,
                items: [
                  M3EFabMenuItem(
                    icon: const Icon(Icons.share),
                    label: 'Share',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(M3EFabMenu)), const Size(96, 96));
    });
  });

  group('M3EFabMenuDecoration Tests', () {
    test('copyWith works correctly', () {
      const dec = M3EFabMenuDecoration();
      final updated = dec.copyWith(
        menuOffset: 20.0,
        itemGap: 14.0,
        itemElevation: 8.0,
      );

      expect(updated.menuOffset, equals(20.0));
      expect(updated.itemGap, equals(14.0));
      expect(updated.itemElevation, equals(8.0));
      expect(updated.itemHeight, equals(56.0));
    });
  });
}
