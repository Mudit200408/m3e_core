// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EFloatingToolbarDefaults spec tests', () {
    test('Default tokens match Material 3 specifications', () {
      expect(M3EFloatingToolbarDefaults.containerSize, 64.0);
      expect(M3EFloatingToolbarDefaults.containerHeightStandard, 64.0);
      expect(M3EFloatingToolbarDefaults.containerHeightCompact, 48.0);
      expect(M3EFloatingToolbarDefaults.dockedHeight, 64.0);
      expect(M3EFloatingToolbarDefaults.dockedHorizontalPadding, 16.0);
      expect(M3EFloatingToolbarDefaults.dockedElevation, 2.0);
      expect(M3EFloatingToolbarDefaults.expandedElevation, 2.0);
      expect(M3EFloatingToolbarDefaults.collapsedElevation, 0.0);
      expect(M3EFloatingToolbarDefaults.expandedElevationWithFab, 2.0);
      expect(M3EFloatingToolbarDefaults.collapsedElevationWithFab, 3.0);
      expect(M3EFloatingToolbarDefaults.fabBaselineSize, 56.0);
      expect(M3EFloatingToolbarDefaults.fabMediumSize, 80.0);
      expect(M3EFloatingToolbarDefaults.toolbarToFabGap, 8.0);
      expect(M3EFloatingToolbarDefaults.dividerHeight, 24.0);
    });
  });

  group('M3EFloatingToolbarDecoration tests', () {
    test('copyWith and equality work properly', () {
      const dec1 = M3EFloatingToolbarDecoration(
        containerSize: 56.0,
        expandedShadowElevation: 3.0,
      );
      final dec2 = dec1.copyWith(expandedShadowElevation: 4.0);

      expect(dec2.containerSize, 56.0);
      expect(dec2.expandedShadowElevation, 4.0);
      expect(dec1 == dec2, isFalse);

      final dec3 = dec2.copyWith(expandedShadowElevation: 3.0);
      expect(dec1 == dec3, isTrue);
      expect(dec1.hashCode == dec3.hashCode, isTrue);
    });
  });

  group('M3EFloatingToolbarDivider tests', () {
    testWidgets('renders vertical divider with 24dp height by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: M3EFloatingToolbarDivider())),
        ),
      );

      expect(find.byType(M3EFloatingToolbarDivider), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(M3EFloatingToolbarDivider),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, 24.0);
      expect(sizedBox.width, 1.0);
    });

    testWidgets('renders horizontal divider with 24dp width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EFloatingToolbarDivider(orientation: Axis.horizontal),
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(M3EFloatingToolbarDivider),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 24.0);
      expect(sizedBox.height, 1.0);
    });
  });

  group('M3EDockedToolbar widget tests', () {
    testWidgets('renders docked toolbar with leading, content, and trailing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EDockedToolbar(
              leading: const Icon(Icons.menu),
              content: const Text('Docked Content'),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(M3EDockedToolbar), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('Docked Content'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });
  });

  group('M3EHorizontalFloatingToolbar widget tests', () {
    testWidgets('renders floating toolbar content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EHorizontalFloatingToolbar(
                expanded: true,
                content: Text('Toolbar Actions'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(M3EHorizontalFloatingToolbar), findsOneWidget);
      expect(find.text('Toolbar Actions'), findsOneWidget);
    });

    testWidgets('renders leading and trailing content when expanded', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EHorizontalFloatingToolbar(
                expanded: true,
                leadingContent: Text('Leading'),
                trailingContent: Text('Trailing'),
                content: Text('Center Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Leading'), findsOneWidget);
      expect(find.text('Center Content'), findsOneWidget);
      expect(find.text('Trailing'), findsOneWidget);
    });
  });

  group('M3EFabHorizontalFloatingToolbar widget tests', () {
    testWidgets('renders FAB and morphs content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: M3EFabHorizontalFloatingToolbar(
                expanded: true,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
                content: const Text('Morphing Actions'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(M3EFabHorizontalFloatingToolbar), findsOneWidget);
      expect(find.text('Morphing Actions'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('respects alignment property and wraps with Align widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                M3EHorizontalFloatingToolbar(
                  expanded: true,
                  alignment: Alignment.bottomCenter,
                  content: Text('Aligned Toolbar'),
                ),
              ],
            ),
          ),
        ),
      );

      final alignFinder = find.ancestor(
        of: find.text('Aligned Toolbar'),
        matching: find.byType(Align),
      );
      expect(alignFinder, findsWidgets);

      final alignWidget = tester.widget<Align>(alignFinder.first);
      expect(alignWidget.alignment, Alignment.bottomCenter);
    });

    testWidgets('respects custom screenOffset in scroll behavior', (
      tester,
    ) async {
      final state = M3EFloatingToolbarState();
      final behavior = M3EFloatingToolbarScrollBehavior.exitAlways(
        exitDirection: M3EFloatingToolbarExitDirection.bottom,
        state: state,
        screenOffset: 48.0,
      );

      expect(behavior.screenOffset, 48.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                M3EHorizontalFloatingToolbar(
                  expanded: true,
                  scrollBehavior: behavior,
                  content: const SizedBox(width: 100, height: 60),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // With container height = 64 and screenOffset = 48, offsetLimit should be -(64 + 48) = -112.0
      expect(state.offsetLimit, -112.0);
    });
  });
}
