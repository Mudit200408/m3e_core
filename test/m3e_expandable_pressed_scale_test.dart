import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('M3EExpandable pressedScale tests', () {
    test('M3EExpandableStyle pressedScale copyWith and equality', () {
      const style1 = M3EExpandableStyle(
        pressedScale: 0.95,
        pressedMotion: M3EMotion.expressiveSpatialFast,
      );
      const style2 = M3EExpandableStyle(
        pressedScale: 0.95,
        pressedMotion: M3EMotion.expressiveSpatialFast,
      );
      expect(style1, equals(style2));
      expect(style1.hashCode, equals(style2.hashCode));

      final style3 = style1.copyWith(pressedScale: 0.90);
      expect(style3.pressedScale, equals(0.90));
      expect(style1 == style3, isFalse);
    });

    testWidgets(
      'M3EExpandableCardColumn scales header content on pointer down',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: M3EExpandableCardColumn(
                  data: const [
                    M3EExpandableData(
                      title: 'Expandable Title 0',
                      body: Text('Body 0'),
                    ),
                    M3EExpandableData(
                      title: 'Expandable Title 1',
                      body: Text('Body 1'),
                    ),
                  ],
                  style: const M3EExpandableStyle(pressedScale: 0.9),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Expandable Title 0'), findsOneWidget);
        expect(find.text('Expandable Title 1'), findsOneWidget);

        // Press down on header 0
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Expandable Title 0')),
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Header 0 should scale down (< 1.0)
        final transforms0 = tester.widgetList<Transform>(
          find.ancestor(
            of: find.text('Expandable Title 0'),
            matching: find.byType(Transform),
          ),
        );
        expect(
          transforms0.any((t) => t.transform.getMaxScaleOnAxis() < 1.0),
          isTrue,
        );

        // Header 1 should remain at 1.0
        final transforms1 = tester.widgetList<Transform>(
          find.ancestor(
            of: find.text('Expandable Title 1'),
            matching: find.byType(Transform),
          ),
        );
        expect(
          transforms1.every((t) => t.transform.getMaxScaleOnAxis() >= 1.0),
          isTrue,
        );

        // Release
        await gesture.up();
        await tester.pumpAndSettle();

        final transforms0After = tester.widgetList<Transform>(
          find.ancestor(
            of: find.text('Expandable Title 0'),
            matching: find.byType(Transform),
          ),
        );
        expect(
          transforms0After.every((t) => t.transform.getMaxScaleOnAxis() >= 1.0),
          isTrue,
        );
      },
    );
  });
}
