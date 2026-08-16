// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_core/m3e_core.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<String?> hapticCalls = [];

  setUp(() {
    hapticCalls.clear();
    // Intercept native haptic method channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('m3e_haptics/haptics'), (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'vibrate') {
            final arguments = methodCall.arguments as Map;
            final type = arguments['type'] as String;
            // Map AOSP-aligned event types to HapticFeedbackType strings.
            // dragTexture → light feel; tickCrossing → medium; bookendLower / bookendUpper → heavy
            final String mappedType = switch (type) {
              'dragTexture' => 'HapticFeedbackType.lightImpact',
              'bookendLower' => 'HapticFeedbackType.heavyImpact',
              'tickCrossing' => 'HapticFeedbackType.mediumImpact',
              'bookendUpper' => 'HapticFeedbackType.heavyImpact',
              // Legacy single-word types kept for backward compatibility
              'light' => 'HapticFeedbackType.lightImpact',
              'medium' => 'HapticFeedbackType.mediumImpact',
              'heavy' => 'HapticFeedbackType.heavyImpact',
              _ => 'HapticFeedbackType.mediumImpact',
            };
            hapticCalls.add(mappedType);
          }
          return null;
        });

    // Intercept platform channel calls for haptic feedback
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'HapticFeedback.vibrate') {
            hapticCalls.add(methodCall.arguments as String?);
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('m3e_haptics/haptics'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('M3EHapticTracker unit tests', () {
    test('does not play haptics when baseHaptic is none', () {
      final tracker = M3EHapticTracker(baseHaptic: M3EHapticFeedback.none);
      tracker.start(0.5, Offset.zero);
      tracker.update(0.6, const Offset(10, 0));
      expect(hapticCalls, isEmpty);
    });

    test('plays continuous drag haptics based on progress delta', () {
      final tracker = M3EHapticTracker(
        baseHaptic: M3EHapticFeedback.light,
        config: const M3EHapticConfig(
          enableContinuousDrag: true,
          deltaProgressForDragThreshold: 0.1,
          vibrateOnLowerBookend: false,
          vibrateOnUpperBookend: false,
        ),
      );
      tracker.start(0.0, Offset.zero);

      // Move progress by 0.05 (less than 0.1 threshold) -> no haptic
      tracker.update(0.05, const Offset(5, 0));
      expect(hapticCalls, isEmpty);

      // Move progress to 0.12 (total delta 0.12 >= 0.1) -> triggers haptic
      // Now maps to 'dragTexture' → lightImpact in mock
      tracker.update(0.12, const Offset(12, 0));
      expect(hapticCalls, hasLength(1));
      expect(hapticCalls.first, equals('HapticFeedbackType.lightImpact'));
    });

    test('triggers bookend haptics at edge thresholds', () {
      final tracker = M3EHapticTracker(
        baseHaptic: M3EHapticFeedback.light,
        config: const M3EHapticConfig(
          enableContinuousDrag: false,
          vibrateOnLowerBookend: true,
          lowerBookendThreshold: 0.05,
          vibrateOnUpperBookend: true,
          upperBookendThreshold: 0.95,
        ),
      );

      // Start at 0.5 (middle)
      tracker.start(0.5, const Offset(50, 0));

      // Move to 0.02 (below lowerBookendThreshold 0.05) -> triggers lower bookend
      // 'bookendLower' → heavyImpact in mock (firm, matching bookendUpper)
      tracker.update(0.02, const Offset(2, 0));
      expect(hapticCalls, hasLength(1));
      expect(hapticCalls.last, equals('HapticFeedbackType.heavyImpact'));

      // Move to 0.01 (still below threshold) -> should not trigger again (prevent repeating)
      tracker.update(0.01, const Offset(1, 0));
      expect(hapticCalls, hasLength(1));

      // Move back to 0.5 (leaves threshold)
      tracker.update(0.5, const Offset(50, 0));

      // Move to 0.98 (above upperBookendThreshold 0.95) -> triggers upper bookend
      // 'bookendUpper' → heavyImpact in mock (firm, AOSP upperBookendScale=1.0)
      tracker.update(0.98, const Offset(98, 0));
      expect(hapticCalls, hasLength(2));
      expect(hapticCalls.last, equals('HapticFeedbackType.heavyImpact'));
    });

    test('velocity changes amplitude for drag texture (AOSP-aligned)', () async {
      // In the new AOSP model, velocity scaling changes the vibration AMPLITUDE
      // sent to the native layer, not the haptic type. The event type remains
      // 'dragTexture' regardless of velocity.
      final tracker = M3EHapticTracker(
        baseHaptic: M3EHapticFeedback.light,
        config: const M3EHapticConfig(
          enableContinuousDrag: true,
          deltaProgressForDragThreshold: 0.01,
          additionalVelocityMaxBump: 0.25,
          maxVelocityToScale: 100.0,
          vibrateOnLowerBookend: false,
          vibrateOnUpperBookend: false,
        ),
      );

      // Low velocity movement -> dragTexture (lightImpact in mock)
      tracker.start(0.1, const Offset(10, 0));
      await Future.delayed(const Duration(milliseconds: 150));
      tracker.update(0.2, const Offset(11, 0)); // dx=1, dt~0.15s => ~6 px/sec
      expect(hapticCalls, isNotEmpty);
      expect(hapticCalls.last, equals('HapticFeedbackType.lightImpact'));

      hapticCalls.clear();

      // High velocity movement -> still 'dragTexture' type (amplitude is higher but same type)
      tracker.start(0.2, const Offset(11, 0));
      await Future.delayed(const Duration(milliseconds: 5));
      tracker.update(
        0.5,
        const Offset(500, 0),
      ); // dx=489, dt~5ms => ~97800 px/sec
      expect(hapticCalls, isNotEmpty);
      // Type is still 'dragTexture' → lightImpact; only amplitude differs (not visible in mock)
      expect(hapticCalls.last, equals('HapticFeedbackType.lightImpact'));
    });
  });

  group('M3ESlider haptic widget tests', () {
    testWidgets('discrete slider triggers tick crossing haptics', (
      tester,
    ) async {
      double value = 0.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: M3ESlider(
                  value: value,
                  min: 0.0,
                  max: 1.0,
                  divisions: 5,
                  decoration: const M3ESliderDecoration(
                    haptic: M3EHapticFeedback.light,
                  ),
                  onChanged: (val) {
                    value = val;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Drag the slider using tester.drag to trigger drag start/update/end
      await tester.drag(find.byType(M3ESlider), const Offset(80, 0));
      await tester.pumpAndSettle();

      expect(hapticCalls, isNotEmpty);
    });

    testWidgets('continuous slider triggers drag interval haptics', (
      tester,
    ) async {
      double value = 0.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: M3ESlider(
                  value: value,
                  min: 0.0,
                  max: 1.0,
                  decoration: const M3ESliderDecoration(
                    haptic: M3EHapticFeedback.light,
                    hapticConfig: M3EHapticConfig(
                      enableContinuousDrag: true,
                      deltaProgressForDragThreshold: 0.05,
                      vibrateOnLowerBookend: false,
                      vibrateOnUpperBookend: false,
                    ),
                  ),
                  onChanged: (val) {
                    value = val;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(M3ESlider), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(hapticCalls, isNotEmpty);
    });
  });

  group('M3ERangeSlider haptic widget tests', () {
    testWidgets('continuous range slider triggers drag haptics', (
      tester,
    ) async {
      RangeValues values = const RangeValues(0.2, 0.8);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: M3ERangeSlider(
                  value: values,
                  min: 0.0,
                  max: 1.0,
                  decoration: const M3ESliderDecoration(
                    haptic: M3EHapticFeedback.light,
                    hapticConfig: M3EHapticConfig(
                      enableContinuousDrag: true,
                      deltaProgressForDragThreshold: 0.05,
                      vibrateOnLowerBookend: false,
                      vibrateOnUpperBookend: false,
                    ),
                  ),
                  onChanged: (val) {
                    values = val;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      final rangeSlider = find.byType(M3ERangeSlider);
      final topLeft = tester.getTopLeft(rangeSlider);
      final size = tester.getSize(rangeSlider);

      // The end thumb is at 0.8 progress.
      // Width is size.width (200.0). Margin is thumbRadius (10.0).
      const margin = 10.0;
      final usableWidth = size.width - 2 * margin;
      final endThumbX = topLeft.dx + margin + usableWidth * 0.8;
      final centerY = topLeft.dy + size.height / 2;

      final startPosition = Offset(endThumbX, centerY);
      await tester.dragFrom(startPosition, const Offset(-50, 0));
      await tester.pumpAndSettle();

      expect(hapticCalls, isNotEmpty);
    });
  });
}
