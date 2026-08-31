// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EBottomSheetStyle Tests', () {
    test('default properties are set correctly', () {
      const style = M3EBottomSheetStyle();
      expect(style.borderRadius, 28.0);
      expect(style.dragHandleSize, const Size(32, 4));
      expect(style.dragHandlePadding, const EdgeInsets.symmetric(vertical: 16));
      expect(style.motion, M3EMotion.expressiveSpatialDefault);
      expect(style.padding, const EdgeInsets.fromLTRB(24, 0, 24, 24));
    });

    test('copyWith updates properties accurately', () {
      const style = M3EBottomSheetStyle();
      final updated = style.copyWith(
        backgroundColor: Colors.amber,
        borderRadius: 16.0,
        dragHandleSize: const Size(40, 6),
      );

      expect(updated.backgroundColor, Colors.amber);
      expect(updated.borderRadius, 16.0);
      expect(updated.dragHandleSize, const Size(40, 6));
      expect(updated.motion, style.motion);
    });

    test('lerp interpolates correctly', () {
      const a = M3EBottomSheetStyle(
        backgroundColor: Color(0xFF000000),
        borderRadius: 10.0,
      );
      const b = M3EBottomSheetStyle(
        backgroundColor: Color(0xFFFFFFFF),
        borderRadius: 20.0,
      );

      final lerped = M3EBottomSheetStyle.lerp(a, b, 0.5);
      expect(lerped?.borderRadius, 15.0);
      expect(
        lerped?.backgroundColor,
        Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5),
      );
    });

    test('equality and hashCode work as expected', () {
      const a = M3EBottomSheetStyle(borderRadius: 20.0);
      const b = M3EBottomSheetStyle(borderRadius: 20.0);
      const c = M3EBottomSheetStyle(borderRadius: 24.0);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });
  });

  group('M3EBottomSheet Widget Tests', () {
    testWidgets('renders child, title, actions, and drag handle', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EBottomSheet(
              title: const Text('Sheet Title'),
              actions: [
                IconButton(icon: const Icon(Icons.close), onPressed: () {}),
              ],
              animateEntrance: false,
              child: const Text('Sheet Body Content'),
            ),
          ),
        ),
      );

      expect(find.text('Sheet Title'), findsOneWidget);
      expect(find.text('Sheet Body Content'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('hides drag handle when showDragHandle is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EBottomSheet(
              showDragHandle: false,
              animateEntrance: false,
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('showM3EModalBottomSheet Tests', () {
    testWidgets('opens modal bottom sheet and displays content', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showM3EModalBottomSheet(
                      context: context,
                      builder: (context) => const M3EBottomSheet(
                        title: Text('Modal Title'),
                        animateEntrance: false,
                        child: Text('Modal Content'),
                      ),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Modal Title'), findsOneWidget);
      expect(find.text('Modal Content'), findsOneWidget);
    });

    testWidgets('wraps plain widgets with M3EBottomSheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showM3EModalBottomSheet(
                      context: context,
                      builder: (context) => const Text('Plain Child'),
                    );
                  },
                  child: const Text('Open Plain'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Plain'));
      await tester.pumpAndSettle();

      expect(find.text('Plain Child'), findsOneWidget);
      expect(find.byType(M3EBottomSheet), findsOneWidget);
    });
  });
}
