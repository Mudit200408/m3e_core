import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EExpandableItem tests', () {
    testWidgets(
      'renders, expands, and collapses with bouncy animation without overflow',
      (tester) async {
        bool isExpanded = true;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return M3EExpandableItem(
                    index: 0,
                    totalCount: 1,
                    isExpanded: isExpanded,
                    onToggle: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    headerBuilder: (context, index, progress) =>
                        const Text('Expandable Header'),
                    bodyBuilder: (context, index, progress) =>
                        const Text('Expandable Body Content'),
                    decoration: const M3EExpandableStyle(),
                    expandMotion: M3EMotion.expressiveSpatialFast,
                    collapseMotion: M3EMotion.expressiveSpatialFast,
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Expandable Header'), findsOneWidget);
        expect(find.text('Expandable Body Content'), findsOneWidget);

        // Trigger collapse
        await tester.tap(find.text('Expandable Header'));
        // Step through intermediate spring frames to verify zero overflow exceptions
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 16));
          expect(tester.takeException(), isNull);
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Expandable Header'), findsOneWidget);
      },
    );

    testWidgets(
      'M3EExpandableCardColumn handles collapse and toggle smoothly',
      (tester) async {
        final data = [
          const M3EExpandableData(
            title: 'Section 1',
            subtitle: 'Subtitle 1',
            body: Text('Body 1'),
          ),
          const M3EExpandableData(
            title: 'Section 2',
            subtitle: 'Subtitle 2',
            body: Text('Body 2'),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: M3EExpandableCardColumn(
                data: data,
                initiallyExpanded: const {0},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Section 1'), findsOneWidget);
        expect(find.text('Body 1'), findsOneWidget);

        // Tap to collapse section 1
        await tester.tap(find.text('Section 1'));
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 16));
          expect(tester.takeException(), isNull);
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  });
}
