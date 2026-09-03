import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('M3EDismissibleCard pressedScale tests', () {
    test('M3EDismissibleCardStyle pressedScale copyWith and equality', () {
      const style1 = M3EDismissibleCardStyle(
        pressedScale: 0.95,
        pressedMotion: M3EMotion.expressiveSpatialFast,
      );
      expect(style1.pressedScale, equals(0.95));
      expect(style1.pressedMotion, equals(M3EMotion.expressiveSpatialFast));

      final style2 = style1.copyWith(pressedScale: 0.98);
      expect(style2.pressedScale, equals(0.98));
    });

    testWidgets('M3EDismissibleCardColumn scales content on pointer down', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: M3EDismissibleCardColumn(
                itemCount: 2,
                style: const M3EDismissibleCardStyle(pressedScale: 0.9),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 80,
                    child: Text('Dismissible Card $index'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Dismissible Card 0'), findsOneWidget);
      expect(find.text('Dismissible Card 1'), findsOneWidget);

      // Press down card 0
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Dismissible Card 0')),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      // Card 0 transform should be scaling down (< 1.0)
      final transforms0 = tester.widgetList<Transform>(
        find.ancestor(
          of: find.text('Dismissible Card 0'),
          matching: find.byType(Transform),
        ),
      );
      expect(
        transforms0.any((t) => t.transform.getMaxScaleOnAxis() < 1.0),
        isTrue,
      );

      // Card 1 transform should remain at 1.0 (unpressed)
      final transforms1 = tester.widgetList<Transform>(
        find.ancestor(
          of: find.text('Dismissible Card 1'),
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

      // After release and settle, Card 0 transform should be back to 1.0
      final transforms0After = tester.widgetList<Transform>(
        find.ancestor(
          of: find.text('Dismissible Card 0'),
          matching: find.byType(Transform),
        ),
      );
      expect(
        transforms0After.every((t) => t.transform.getMaxScaleOnAxis() >= 1.0),
        isTrue,
      );
    });
  });
}
