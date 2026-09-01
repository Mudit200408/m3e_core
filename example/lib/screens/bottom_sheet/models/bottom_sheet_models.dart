// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:m3e_core/m3e_core.dart';
import '../../../shared/shared.dart';

/// Playground configuration state for [M3EBottomSheet].
class BottomSheetPlaygroundState {
  const BottomSheetPlaygroundState({
    this.borderRadius = 28.0,
    this.showDragHandle = true,
    this.dragHandleWidth = 32.0,
    this.dragHandleHeight = 4.0,
    this.dragHandlePaddingV = 16.0,
    this.elevation = 0.0,
    this.motionPreset = M3EExampleMotionPreset.expressiveSpatialDefault,
    this.motionStiffness = 700.0,
    this.motionDamping = 0.75,
    this.isDismissible = true,
    this.enableDrag = true,
    this.useSafeArea = true,
    this.isScrollControlled = true,
    this.hasTitle = true,
    this.hasActions = true,
    this.selectedColorIndex = 0,
    this.animateEntrance = true,
  });

  final double borderRadius;
  final bool showDragHandle;
  final double dragHandleWidth;
  final double dragHandleHeight;
  final double dragHandlePaddingV;
  final double elevation;
  final M3EExampleMotionPreset motionPreset;
  final double motionStiffness;
  final double motionDamping;
  final bool isDismissible;
  final bool enableDrag;
  final bool useSafeArea;
  final bool isScrollControlled;
  final bool hasTitle;
  final bool hasActions;
  final int selectedColorIndex;
  final bool animateEntrance;

  M3EMotion get motion =>
      motionPreset.resolve(stiffness: motionStiffness, damping: motionDamping);

  BottomSheetPlaygroundState copyWith({
    double? borderRadius,
    bool? showDragHandle,
    double? dragHandleWidth,
    double? dragHandleHeight,
    double? dragHandlePaddingV,
    double? elevation,
    M3EExampleMotionPreset? motionPreset,
    double? motionStiffness,
    double? motionDamping,
    bool? isDismissible,
    bool? enableDrag,
    bool? useSafeArea,
    bool? isScrollControlled,
    bool? hasTitle,
    bool? hasActions,
    int? selectedColorIndex,
    bool? animateEntrance,
  }) {
    return BottomSheetPlaygroundState(
      borderRadius: borderRadius ?? this.borderRadius,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      dragHandleWidth: dragHandleWidth ?? this.dragHandleWidth,
      dragHandleHeight: dragHandleHeight ?? this.dragHandleHeight,
      dragHandlePaddingV: dragHandlePaddingV ?? this.dragHandlePaddingV,
      elevation: elevation ?? this.elevation,
      motionPreset: motionPreset ?? this.motionPreset,
      motionStiffness: motionStiffness ?? this.motionStiffness,
      motionDamping: motionDamping ?? this.motionDamping,
      isDismissible: isDismissible ?? this.isDismissible,
      enableDrag: enableDrag ?? this.enableDrag,
      useSafeArea: useSafeArea ?? this.useSafeArea,
      isScrollControlled: isScrollControlled ?? this.isScrollControlled,
      hasTitle: hasTitle ?? this.hasTitle,
      hasActions: hasActions ?? this.hasActions,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      animateEntrance: animateEntrance ?? this.animateEntrance,
    );
  }
}
