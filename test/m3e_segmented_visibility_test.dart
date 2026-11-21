import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3ESegmentedColumn isVisible', () {
    testWidgets('a collapsed child adds no gap between its neighbours', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            gap: 6,
            padding: EdgeInsets.zero,
            children: [_cell('A'), _cell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final baseline = _verticalSeam(tester, 'A', 'C');

      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            gap: 6,
            padding: EdgeInsets.zero,
            isVisible: (index) => index != 1,
            children: [_cell('A'), const SizedBox.shrink(), _cell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_verticalSeam(tester, 'A', 'C'), baseline);
      expect(baseline, 6);
    });

    testWidgets('a hidden trailing child does not steal the last position', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            isVisible: (index) => index != 2,
            children: [_cell('A'), _cell('B'), const SizedBox.shrink()],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final items = _items(tester);
      expect(items[0].position, M3ESegmentedItemPosition.first);
      expect(items[1].position, M3ESegmentedItemPosition.last);
      expect(items[2].position, M3ESegmentedItemPosition.middle);
      expect(items[2].isVisible, isFalse);
    });

    testWidgets('a hidden leading child does not steal the first position', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            isVisible: (index) => index != 0,
            children: [const SizedBox.shrink(), _cell('A'), _cell('B')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final items = _items(tester);
      expect(items[0].position, M3ESegmentedItemPosition.middle);
      expect(items[0].isVisible, isFalse);
      expect(items[1].position, M3ESegmentedItemPosition.first);
      expect(items[2].position, M3ESegmentedItemPosition.last);
    });

    testWidgets('a single visible child is positioned as single', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            isVisible: (index) => index == 1,
            children: [
              const SizedBox.shrink(),
              _cell('A'),
              const SizedBox.shrink(),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_items(tester)[1].position, M3ESegmentedItemPosition.single);
    });

    testWidgets('a hidden child keeps its surface and is not disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            onTap: (_) {},
            isVisible: (index) => index != 1,
            children: [_cell('A'), _cell('B'), _cell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final items = _items(tester);
      expect(items[1].isVisible, isFalse);
      // Hiding is not disabling: a row that is animating itself out must not
      // flash the disabled surface for the length of the animation.
      expect(items[1].enabled, isTrue);
      expect(_surface(tester, 1), _surface(tester, 0));
    });

    testWidgets('isVisible and isEnabled stay independent', (tester) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            onTap: (_) {},
            isEnabled: (index) => index != 2,
            isVisible: (index) => index != 1,
            children: [_cell('A'), _cell('B'), _cell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final items = _items(tester);
      expect(items[0].isVisible, isTrue);
      expect(items[0].enabled, isTrue);
      expect(items[1].isVisible, isFalse);
      expect(items[1].enabled, isTrue);
      expect(items[2].isVisible, isTrue);
      expect(items[2].enabled, isFalse);
      // Hidden index 1 is excluded, so A and C are first and last.
      expect(items[0].position, M3ESegmentedItemPosition.first);
      expect(items[2].position, M3ESegmentedItemPosition.last);
    });

    testWidgets('callbacks keep reporting the raw child index', (tester) async {
      final taps = <int>[];

      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            isVisible: (index) => index != 0,
            onTap: taps.add,
            semanticLabelBuilder: (index) => 'label-$index',
            children: [const SizedBox.shrink(), _cell('A'), _cell('B')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('B')));
      await tester.pumpAndSettle();

      expect(taps, [2]);
      // The hidden child is never announced, the visible one still is.
      expect(_semanticsWithLabel('label-0'), findsNothing);
      expect(_semanticsWithLabel('label-2'), findsOneWidget);
    });

    testWidgets('selection reports the raw child index', (tester) async {
      final selections = <Set<int>>[];

      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            selectionMode: M3ESelectionMode.multiple,
            isVisible: (index) => index != 1,
            onSelectionChanged: selections.add,
            children: [_cell('A'), const SizedBox.shrink(), _cell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('C')));
      await tester.pumpAndSettle();

      expect(selections.last, {2});
    });

    testWidgets('a null isVisible reproduces the positional behaviour', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(children: [_cell('A'), _cell('B'), _cell('C')]),
        ),
      );
      await tester.pumpAndSettle();

      final items = _items(tester);
      expect(items[0].position, M3ESegmentedItemPosition.first);
      expect(items[1].position, M3ESegmentedItemPosition.middle);
      expect(items[2].position, M3ESegmentedItemPosition.last);
      expect(items.every((item) => item.isVisible), isTrue);
      expect(items.every((item) => item.isLast == null), isTrue);
    });
  });

  group('M3ESegmentedItem isVisible', () {
    testWidgets('a hidden item leaves no phantom block behind', (tester) async {
      // The container's default inner padding (12) plus its gap would leave a
      // 26px block even for a child that paints nothing.
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            isVisible: (index) => index != 1,
            children: [_cell('A'), const SizedBox.shrink()],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final group = tester.getRect(find.byType(M3ESegmentedColumn));
      final a = tester.getRect(find.byKey(const ValueKey('A')));
      expect(group.height, a.height + 24);
    });

    testWidgets('a hidden item is not focusable', (tester) async {
      final taps = <int>[];
      await tester.pumpWidget(
        _app(
          M3ESegmentedColumn(
            onTap: taps.add,
            isVisible: (index) => index != 1,
            children: [_cell('A'), _cell('B'), _cell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(taps, [0]);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(taps, [0, 2]);
    });
  });

  group('M3ESegmentedRow isVisible', () {
    testWidgets('a collapsed child adds no gap between its neighbours', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedRow(
            gap: 6,
            padding: EdgeInsets.zero,
            equalWidth: false,
            children: [_wideCell('A'), _wideCell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final baseline = _horizontalSeam(tester, 'A', 'C');

      await tester.pumpWidget(
        _app(
          M3ESegmentedRow(
            gap: 6,
            padding: EdgeInsets.zero,
            equalWidth: false,
            isVisible: (index) => index != 1,
            children: [_wideCell('A'), const SizedBox.shrink(), _wideCell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_horizontalSeam(tester, 'A', 'C'), baseline);
      expect(baseline, 6);
    });

    testWidgets('a hidden trailing child does not steal the last position', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedRow(
            equalWidth: false,
            isVisible: (index) => index != 2,
            children: [_wideCell('A'), _wideCell('B'), const SizedBox.shrink()],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final items = _items(tester);
      expect(items[0].position, M3ESegmentedItemPosition.first);
      expect(items[1].position, M3ESegmentedItemPosition.last);
      expect(items[1].axis, Axis.horizontal);
    });

    testWidgets('a hidden child takes no share of an equal-width row', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          M3ESegmentedRow(
            gap: 6,
            padding: EdgeInsets.zero,
            isVisible: (index) => index != 1,
            children: [_wideCell('A'), const SizedBox.shrink(), _wideCell('C')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Without excluding the hidden child from flex distribution it would keep
      // an Expanded slot and leave a blank stretch a third of the row wide.
      expect(_horizontalSeam(tester, 'A', 'C'), 6);

      final row = tester.getRect(find.byType(M3ESegmentedRow));
      final a = tester.getRect(find.byKey(const ValueKey('A')));
      final c = tester.getRect(find.byKey(const ValueKey('C')));
      // The two visible cells plus the single gap between them fill the row
      // exactly, so the hidden child left no blank share behind.
      expect(a.width + 6 + c.width, row.width);
      expect(a.left, row.left);
      expect(c.right, row.right);
    });
  });
}

Widget _cell(String label) =>
    SizedBox(key: ValueKey(label), height: 40, child: Text(label));

Widget _wideCell(String label) =>
    SizedBox(key: ValueKey(label), width: 60, height: 40, child: Text(label));

Widget _app(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

List<M3ESegmentedItem> _items(WidgetTester tester) =>
    tester.widgetList<M3ESegmentedItem>(find.byType(M3ESegmentedItem)).toList();

Finder _semanticsWithLabel(String label) => find.byWidgetPredicate(
  (widget) => widget is Semantics && widget.properties.label == label,
);

Color? _surface(WidgetTester tester, int index) {
  final container = find
      .descendant(
        of: find.byType(M3ESegmentedItem).at(index),
        matching: find.byType(Container),
      )
      .first;
  final decoration = tester.widget<Container>(container).decoration;
  return decoration is BoxDecoration ? decoration.color : null;
}

double _verticalSeam(WidgetTester tester, String before, String after) {
  final first = tester.getRect(find.byKey(ValueKey(before)));
  final second = tester.getRect(find.byKey(ValueKey(after)));
  return second.top - first.bottom;
}

double _horizontalSeam(WidgetTester tester, String before, String after) {
  final first = tester.getRect(find.byKey(ValueKey(before)));
  final second = tester.getRect(find.byKey(ValueKey(after)));
  return second.left - first.right;
}
