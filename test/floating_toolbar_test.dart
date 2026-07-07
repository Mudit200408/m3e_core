import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  group('M3EFloatingToolbar Theme and Defaults', () {
    test('Token defaults match specification', () {
      expect(M3EFloatingToolbarDefaults.containerSize, 64.0);
      expect(M3EFloatingToolbarDefaults.toolbarToFabGap, 8.0);
      expect(M3EFloatingToolbarDefaults.scrollDistanceThreshold, 40.0);
      expect(M3EFloatingToolbarDefaults.fabBaselineSize, 56.0);
      expect(M3EFloatingToolbarDefaults.fabMediumSize, 80.0);
      expect(M3EFloatingToolbarDefaults.expandedElevation, 0.0);
      expect(M3EFloatingToolbarDefaults.collapsedElevation, 0.0);
      expect(M3EFloatingToolbarDefaults.expandedElevationWithFab, 1.0);
      expect(M3EFloatingToolbarDefaults.collapsedElevationWithFab, 0.0);
      expect(M3EFloatingToolbarDefaults.containerShape, const StadiumBorder());
      expect(M3EFloatingToolbarDefaults.contentPadding, const EdgeInsets.all(8.0));
      expect(M3EFloatingToolbarDefaults.screenOffset, 16.0);
    });

    testWidgets('Colors resolve correctly from context', (WidgetTester tester) async {
      late M3EFloatingToolbarColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                colors = M3EFloatingToolbarDefaults.standardColors(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(colors.toolbarContainerColor, isNotNull);
      expect(colors.toolbarContentColor, isNotNull);
      expect(colors.fabContainerColor, isNotNull);
      expect(colors.fabContentColor, isNotNull);
    });
  });

  group('M3EFloatingToolbarState', () {
    test('Initial state values are correct', () {
      final state = M3EFloatingToolbarState.create();
      expect(state.offsetLimit, 0.0);
      expect(state.offset, 0.0);
      expect(state.contentOffset, 0.0);
      expect(state.collapsedFraction, 0.0);
    });

    test('Offset is correctly coerced and clamped', () {
      final state = M3EFloatingToolbarState.create();
      state.offsetLimit = -100.0;

      // Inside bounds
      state.offset = -40.0;
      expect(state.offset, -40.0);
      expect(state.collapsedFraction, 0.4);

      // Exceeds limit (below limit)
      state.offset = -150.0;
      expect(state.offset, -100.0);
      expect(state.collapsedFraction, 1.0);

      // Exceeds upper limit (above zero)
      state.offset = 50.0;
      expect(state.offset, 0.0);
      expect(state.collapsedFraction, 0.0);
    });
  });

  group('M3EFloatingToolbar Widgets Rendering', () {
    testWidgets('Horizontal Standard Toolbar shows and hides content based on expanded state',
        (WidgetTester tester) async {
      bool expanded = true;

      Widget buildToolbar() {
        return MaterialApp(
          home: Scaffold(
            body: M3EHorizontalFloatingToolbar(
              expanded: expanded,
              leadingContent: const Text('LEADING'),
              content: const Text('CENTER'),
              trailingContent: const Text('TRAILING'),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildToolbar());
      await tester.pumpAndSettle();

      // Expanded: leading, center and trailing are all present and visible
      expect(find.text('LEADING'), findsOneWidget);
      expect(find.text('CENTER'), findsOneWidget);
      expect(find.text('TRAILING'), findsOneWidget);

      // Transition to collapsed
      expanded = false;
      await tester.pumpWidget(buildToolbar());
      await tester.pumpAndSettle();

      // Collapsed: leading and trailing are hidden/zero size, center is still there
      expect(find.text('CENTER'), findsOneWidget);
      
      // When collapsed, the visible property in _AnimatedContentVisibility is false,

      // so it builds a SizedBox.shrink() and doesn't display the text.
      expect(find.text('LEADING'), findsNothing);
      expect(find.text('TRAILING'), findsNothing);
    });

    testWidgets('Vertical Standard Toolbar rendering', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EVerticalFloatingToolbar(
              expanded: true,
              leadingContent: Icon(Icons.add),
              content: Icon(Icons.star),
              trailingContent: Icon(Icons.delete),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('Standard Toolbars accept and apply custom motion', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3EHorizontalFloatingToolbar(
              expanded: true,
              decoration: M3EFloatingToolbarDecoration(
                motion: M3EMotion.custom(stiffness: 100, damping: 0.8),
              ),
              leadingContent: Text('LEADING'),
              content: Text('CENTER'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('LEADING'), findsOneWidget);
      expect(find.text('CENTER'), findsOneWidget);
    });

    testWidgets('Standard Toolbar accepts and applies custom shadow elevations from decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: M3EHorizontalFloatingToolbar(
              expanded: true,
              decoration: const M3EFloatingToolbarDecoration(
                expandedShadowElevation: 8.0,
                collapsedShadowElevation: 2.0,
              ),
              content: const Text('CONTENT'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final materialFinder = find.descendant(
        of: find.byType(M3EHorizontalFloatingToolbar),
        matching: find.byType(Material),
      );
      final Material materialWidget = tester.widget(materialFinder);
      expect(materialWidget.elevation, 8.0);
    });

    testWidgets('Horizontal FAB Toolbar morphing does not crash', (WidgetTester tester) async {
      bool expanded = true;

      Widget buildWidget() {
        return MaterialApp(
          home: Scaffold(
            body: M3EFabHorizontalFloatingToolbar(
              expanded: expanded,
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              content: const Row(
                children: [
                  Icon(Icons.star),
                  Icon(Icons.star),
                ],
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(2));

      // Collapse
      expanded = false;
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);

      // Expand again
      expanded = true;
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(2));
    });
  });

  group('M3EFloatingToolbarVerticalNestedScroll', () {
    testWidgets('Threshold-based scroll notifies collapse and expand', (WidgetTester tester) async {
      bool expanded = true;
      int collapseCount = 0;
      int expandCount = 0;

      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return M3EFloatingToolbarVerticalNestedScroll(
                    expanded: expanded,
                    expandScrollDistanceThreshold: 40.0,
                    collapseScrollDistanceThreshold: 40.0,
                    onCollapse: () {
                      setState(() {
                        collapseCount++;
                        expanded = false;
                      });
                    },
                    onExpand: () {
                      setState(() {
                        expandCount++;
                        expanded = true;
                      });
                    },
                    child: ListView.builder(
                      controller: controller,
                      itemCount: 50,
                      itemBuilder: (context, index) => SizedBox(
                        height: 50,
                        child: Text('Item $index'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );


      await tester.pumpAndSettle();

      // Drag up (scroll down) by 60px (exceeds collapse threshold 40.0)
      await tester.drag(find.byType(ListView), const Offset(0.0, -60.0));
      await tester.pumpAndSettle();

      expect(collapseCount, 1);
      expect(expandCount, 0);

      // Drag down (scroll up) by 60px (exceeds expand threshold 40.0)
      await tester.drag(find.byType(ListView), const Offset(0.0, 60.0));
      await tester.pumpAndSettle();

      expect(collapseCount, 1);
      expect(expandCount, 1);
    });
  });
}

