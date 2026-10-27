// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:example/screens/menu/models/menu_models.dart';
import 'package:example/screens/menu/preview/menu_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('M3E Menu Playground Automated Scenarios (Chrome / Web)', () {
    testWidgets('Scenario 1: Actions & Navigation Menu', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = MenuPlaygroundState()..useCase = MenuUseCase.actions;
      final eventNotifier = ValueNotifier<String>('Ready');
      final logs = <String>[];
      eventNotifier.addListener(() => logs.add(eventNotifier.value));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MenuPreviewArea(
                state: state,
                eventNotifier: eventNotifier,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trigger button exists
      expect(find.text('Actions & Nav Menu'), findsOneWidget);

      // Open menu
      await tester.tap(find.text('Actions & Nav Menu'));
      await tester.pumpAndSettle();

      // Items are visible
      expect(find.text('New document'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Copy link'), findsOneWidget);
      expect(find.text('Duplicate'), findsOneWidget);
      expect(find.text('Delete document'), findsOneWidget);

      // Tap 'New document'
      await tester.tap(find.text('New document'));
      await tester.pumpAndSettle();

      // Action event was logged
      expect(logs, contains('Clicked "New Document"'));

      // Menu closed
      expect(find.text('New document'), findsNothing);
    });

    testWidgets('Scenario 2: Cascading Submenus', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = MenuPlaygroundState()..useCase = MenuUseCase.cascading;
      final eventNotifier = ValueNotifier<String>('Ready');
      final logs = <String>[];
      eventNotifier.addListener(() => logs.add(eventNotifier.value));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MenuPreviewArea(
                state: state,
                eventNotifier: eventNotifier,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open root menu
      await tester.tap(find.text('Cascading Menu'));
      await tester.pumpAndSettle();

      expect(find.text('Export as'), findsOneWidget);
      expect(find.text('Share with'), findsOneWidget);
      expect(find.text('Sort order'), findsOneWidget);

      // Open 'Export as' submenu
      await tester.tap(find.text('Export as'));
      await tester.pumpAndSettle();

      expect(find.text('PDF Document (.pdf)'), findsOneWidget);
      expect(find.text('PNG Image (.png)'), findsOneWidget);
      expect(find.text('SVG Vector (.svg)'), findsOneWidget);

      // Tap 'SVG Vector (.svg)'
      await tester.tap(find.text('SVG Vector (.svg)'));
      await tester.pumpAndSettle();

      expect(logs, contains('Export: SVG Vector'));
      // All levels closed
      expect(find.text('Export as'), findsNothing);
    });

    testWidgets('Scenario 3: Preferences (Checkbox & Radio)', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = MenuPlaygroundState()..useCase = MenuUseCase.preferences;
      final eventNotifier = ValueNotifier<String>('Ready');
      final logs = <String>[];
      eventNotifier.addListener(() => logs.add(eventNotifier.value));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MenuPreviewArea(
                state: state,
                eventNotifier: eventNotifier,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open menu
      await tester.tap(find.text('Preferences Menu'));
      await tester.pumpAndSettle();

      expect(find.text('Auto-save changes'), findsOneWidget);
      expect(find.text('Push notifications'), findsOneWidget);

      // Toggle checkbox
      await tester.tap(find.text('Auto-save changes'));
      await tester.pumpAndSettle();
      expect(logs.any((l) => l.contains('Auto-save')), isTrue);

      // Checkbox with closeOnActivate: false keeps menu open
      expect(find.text('Push notifications'), findsOneWidget);
    });

    testWidgets('Scenario 4: Popup Menu Button', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = MenuPlaygroundState()..useCase = MenuUseCase.popupButton;
      final eventNotifier = ValueNotifier<String>('Ready');
      final logs = <String>[];
      eventNotifier.addListener(() => logs.add(eventNotifier.value));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MenuPreviewArea(
                state: state,
                eventNotifier: eventNotifier,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap popup trigger
      await tester.tap(find.byType(M3EPopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Cut'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);

      // Select 'Copy'
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(logs, contains('Popup selected "copy"'));
      expect(find.text('Cut'), findsNothing);

      // Open again and tap outside barrier to cancel
      await tester.tap(find.byType(M3EPopupMenuButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('Cut'), findsOneWidget);

      // Tap outside (top left of screen)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(logs, contains('Popup canceled (no selection)'));
      expect(find.text('Cut'), findsNothing);
    });

    testWidgets('Scenario 5: Multi-Section Grouped Menu', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = MenuPlaygroundState()
        ..useCase = MenuUseCase.multiSection
        ..showGroups = true;
      final eventNotifier = ValueNotifier<String>('Ready');
      final logs = <String>[];
      eventNotifier.addListener(() => logs.add(eventNotifier.value));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MenuPreviewArea(
                state: state,
                eventNotifier: eventNotifier,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open multi-section menu
      await tester.tap(find.text('Multi-Section Menu'));
      await tester.pumpAndSettle();

      // Section items from actions, cascading, and preferences
      expect(find.text('New document'), findsOneWidget);
      expect(find.text('Quick save'), findsOneWidget);
      expect(find.text('Export as'), findsOneWidget);

      // Tap 'New document'
      await tester.tap(find.text('New document'));
      await tester.pumpAndSettle();

      expect(logs, contains('Clicked "New Document"'));
      expect(find.text('New document'), findsNothing);
    });
  });
}
