import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../m3e_floating_toolbar_theme.dart';

class FabLayoutParentData extends ContainerBoxParentData<RenderBox> {}

double _lerpD(double a, double b, double t) {
  return a + (b - a) * t;
}

class M3EHorizontalFabLayout extends MultiChildRenderObjectWidget {
  final double progress;
  final M3EFloatingToolbarHorizontalFabPosition fabPosition;
  final bool isRtl;

  M3EHorizontalFabLayout({
    super.key,
    required this.progress,
    required this.fabPosition,
    required this.isRtl,
    required Widget toolbar,
    required Widget fab,
  }) : super(children: [toolbar, fab]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderHorizontalFabLayout(
      progress: progress,
      fabPosition: fabPosition,
      isRtl: isRtl,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderHorizontalFabLayout renderObject,
  ) {
    renderObject
      ..progress = progress
      ..fabPosition = fabPosition
      ..isRtl = isRtl;
  }
}

class RenderHorizontalFabLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FabLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FabLayoutParentData> {
  RenderHorizontalFabLayout({
    required double progress,
    required M3EFloatingToolbarHorizontalFabPosition fabPosition,
    required bool isRtl,
  }) : _progress = progress,
       _fabPosition = fabPosition,
       _isRtl = isRtl;

  double _progress;
  M3EFloatingToolbarHorizontalFabPosition _fabPosition;
  bool _isRtl;

  set progress(double value) {
    if (value == _progress) return;
    _progress = value;
    markNeedsLayout();
  }

  set fabPosition(M3EFloatingToolbarHorizontalFabPosition value) {
    if (value == _fabPosition) return;
    _fabPosition = value;
    markNeedsLayout();
  }

  set isRtl(bool value) {
    if (value == _isRtl) return;
    _isRtl = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FabLayoutParentData) {
      child.parentData = FabLayoutParentData();
    }
  }

  @override
  void performLayout() {
    final RenderBox? toolbarChild = firstChild;
    final RenderBox? fabChild = childAfter(firstChild!);
    if (toolbarChild == null || fabChild == null) {
      size = constraints.smallest;
      return;
    }

    const double containerSize = M3EFloatingToolbarDefaults.containerSize;
    const double gap = M3EFloatingToolbarDefaults.toolbarToFabGap;
    const double fabBaseline = M3EFloatingToolbarDefaults.fabBaselineSize;
    const double fabMedium = M3EFloatingToolbarDefaults.fabMediumSize;
    const double totalHeight = M3EFloatingToolbarDefaults.fabVariantTotalHeight;

    final BoxConstraints toolbarConstraints = BoxConstraints(
      minWidth: 0.0,
      maxWidth: constraints.hasBoundedWidth
          ? constraints.maxWidth - fabBaseline - gap
          : double.infinity,
      minHeight: containerSize,
      maxHeight: containerSize,
    );
    toolbarChild.layout(toolbarConstraints, parentUsesSize: true);
    final double naturalWidth = toolbarChild.size.width;

    final double fabSize = _lerpD(fabMedium, fabBaseline, _progress);
    final double totalWidth = naturalWidth + gap + fabBaseline;

    final BoxConstraints fabConstraints = BoxConstraints.tight(
      Size(fabSize, fabSize),
    );
    fabChild.layout(fabConstraints, parentUsesSize: true);

    size = constraints.constrain(Size(totalWidth, totalHeight));

    final bool isEnd =
        _fabPosition == M3EFloatingToolbarHorizontalFabPosition.end;
    final bool isEndEffective = _isRtl ? !isEnd : isEnd;

    final double clampedProgress = _progress.clamp(0.0, 1.2);
    final double toolbarWidth = naturalWidth * clampedProgress;

    final double fabX = isEndEffective ? (totalWidth - fabSize) : 0.0;
    final double fabY = (totalHeight - fabSize) / 2;

    final double toolbarX = isEndEffective
        ? (naturalWidth - toolbarWidth)
        : (totalWidth - naturalWidth);
    const double toolbarY = (totalHeight - containerSize) / 2;

    final toolbarParentData = toolbarChild.parentData as FabLayoutParentData;
    toolbarParentData.offset = Offset(toolbarX, toolbarY);

    final fabParentData = fabChild.parentData as FabLayoutParentData;
    fabParentData.offset = Offset(fabX, fabY);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? toolbarChild = firstChild;
    if (toolbarChild != null) {
      final parentData = toolbarChild.parentData as FabLayoutParentData;
      final double clampedProgress = _progress.clamp(0.0, 1.0);
      final bool isEnd =
          _fabPosition == M3EFloatingToolbarHorizontalFabPosition.end;
      final bool isEndEffective = _isRtl ? !isEnd : isEnd;
      final double naturalWidth = toolbarChild.size.width;
      final double opacityFactor = const Interval(
        0.5,
        1.0,
        curve: Curves.easeIn,
      ).transform(clampedProgress);

      context.pushOpacity(offset, (opacityFactor * 255).round(), (
        context,
        offset,
      ) {
        if (clampedProgress >= 0.99) {
          context.paintChild(toolbarChild, offset + parentData.offset);
        } else {
          const double margin = 48.0;
          final Rect clipRect;
          if (isEndEffective) {
            final double left = naturalWidth * (1.0 - clampedProgress);
            clipRect = Rect.fromLTRB(
              left,
              -margin,
              naturalWidth + margin,
              toolbarChild.size.height + margin,
            );
          } else {
            final double right = naturalWidth * clampedProgress;
            clipRect = Rect.fromLTRB(
              -margin,
              -margin,
              right,
              toolbarChild.size.height + margin,
            );
          }

          context.pushClipRect(
            needsCompositing,
            offset + parentData.offset,
            clipRect,
            (context, offset) {
              context.paintChild(toolbarChild, offset);
            },
          );
        }
      });
    }

    final RenderBox? fabChild = childAfter(firstChild!);
    if (fabChild != null) {
      final fabParentData = fabChild.parentData as FabLayoutParentData;
      context.paintChild(fabChild, fabParentData.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? fabChild = childAfter(firstChild!);
    if (fabChild != null) {
      final fabParentData = fabChild.parentData as FabLayoutParentData;
      if (fabChild.hitTest(result, position: position - fabParentData.offset)) {
        return true;
      }
    }
    if (_progress > 0.0) {
      final RenderBox? toolbarChild = firstChild;
      if (toolbarChild != null) {
        final toolbarParentData =
            toolbarChild.parentData as FabLayoutParentData;
        if (toolbarChild.hitTest(
          result,
          position: position - toolbarParentData.offset,
        )) {
          return true;
        }
      }
    }
    return false;
  }
}

class M3EVerticalFabLayout extends MultiChildRenderObjectWidget {
  final double progress;
  final M3EFloatingToolbarVerticalFabPosition fabPosition;

  M3EVerticalFabLayout({
    super.key,
    required this.progress,
    required this.fabPosition,
    required Widget toolbar,
    required Widget fab,
  }) : super(children: [toolbar, fab]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderVerticalFabLayout(
      progress: progress,
      fabPosition: fabPosition,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderVerticalFabLayout renderObject,
  ) {
    renderObject
      ..progress = progress
      ..fabPosition = fabPosition;
  }
}

class RenderVerticalFabLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FabLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FabLayoutParentData> {
  RenderVerticalFabLayout({
    required double progress,
    required M3EFloatingToolbarVerticalFabPosition fabPosition,
  }) : _progress = progress,
       _fabPosition = fabPosition;

  double _progress;
  M3EFloatingToolbarVerticalFabPosition _fabPosition;

  set progress(double value) {
    if (value == _progress) return;
    _progress = value;
    markNeedsLayout();
  }

  set fabPosition(M3EFloatingToolbarVerticalFabPosition value) {
    if (value == _fabPosition) return;
    _fabPosition = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FabLayoutParentData) {
      child.parentData = FabLayoutParentData();
    }
  }

  @override
  void performLayout() {
    final RenderBox? toolbarChild = firstChild;
    final RenderBox? fabChild = childAfter(firstChild!);
    if (toolbarChild == null || fabChild == null) {
      size = constraints.smallest;
      return;
    }

    const double containerSize = M3EFloatingToolbarDefaults.containerSize;
    const double gap = M3EFloatingToolbarDefaults.toolbarToFabGap;
    const double fabBaseline = M3EFloatingToolbarDefaults.fabBaselineSize;
    const double fabMedium = M3EFloatingToolbarDefaults.fabMediumSize;
    const double totalWidth = M3EFloatingToolbarDefaults.fabVariantTotalWidth;

    final BoxConstraints toolbarConstraints = BoxConstraints(
      minWidth: containerSize,
      maxWidth: containerSize,
      minHeight: 0.0,
      maxHeight: constraints.hasBoundedHeight
          ? constraints.maxHeight - fabBaseline - gap
          : double.infinity,
    );
    toolbarChild.layout(toolbarConstraints, parentUsesSize: true);
    final double naturalHeight = toolbarChild.size.height;

    final double fabSize = _lerpD(fabMedium, fabBaseline, _progress);
    final double totalHeight = naturalHeight + gap + fabBaseline;

    final BoxConstraints fabConstraints = BoxConstraints.tight(
      Size(fabSize, fabSize),
    );
    fabChild.layout(fabConstraints, parentUsesSize: true);

    size = constraints.constrain(Size(totalWidth, totalHeight));

    final bool isBottom =
        _fabPosition == M3EFloatingToolbarVerticalFabPosition.bottom;

    final double clampedProgress = _progress.clamp(0.0, 1.2);
    final double toolbarHeight = naturalHeight * clampedProgress;

    final double fabX = (totalWidth - fabSize) / 2;
    final double fabY = isBottom ? (totalHeight - fabSize) : 0.0;

    final double toolbarY = isBottom
        ? (naturalHeight - toolbarHeight)
        : (totalHeight - naturalHeight);
    const double toolbarX = (totalWidth - containerSize) / 2;

    final toolbarParentData = toolbarChild.parentData as FabLayoutParentData;
    toolbarParentData.offset = Offset(toolbarX, toolbarY);

    final fabParentData = fabChild.parentData as FabLayoutParentData;
    fabParentData.offset = Offset(fabX, fabY);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? toolbarChild = firstChild;
    if (toolbarChild != null) {
      final parentData = toolbarChild.parentData as FabLayoutParentData;
      final double clampedProgress = _progress.clamp(0.0, 1.0);
      final bool isBottom =
          _fabPosition == M3EFloatingToolbarVerticalFabPosition.bottom;
      final double naturalHeight = toolbarChild.size.height;
      final double opacityFactor = const Interval(
        0.5,
        1.0,
        curve: Curves.easeIn,
      ).transform(clampedProgress);

      context.pushOpacity(offset, (opacityFactor * 255).round(), (
        context,
        offset,
      ) {
        if (clampedProgress >= 0.99) {
          context.paintChild(toolbarChild, offset + parentData.offset);
        } else {
          const double margin = 48.0;
          final Rect clipRect;
          if (isBottom) {
            final double top = naturalHeight * (1.0 - clampedProgress);
            clipRect = Rect.fromLTRB(
              -margin,
              top,
              toolbarChild.size.width + margin,
              naturalHeight + margin,
            );
          } else {
            final double bottom = naturalHeight * clampedProgress;
            clipRect = Rect.fromLTRB(
              -margin,
              -margin,
              toolbarChild.size.width + margin,
              bottom,
            );
          }

          context.pushClipRect(
            needsCompositing,
            offset + parentData.offset,
            clipRect,
            (context, offset) {
              context.paintChild(toolbarChild, offset);
            },
          );
        }
      });
    }

    final RenderBox? fabChild = childAfter(firstChild!);
    if (fabChild != null) {
      final fabParentData = fabChild.parentData as FabLayoutParentData;
      context.paintChild(fabChild, fabParentData.offset + offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final RenderBox? fabChild = childAfter(firstChild!);
    if (fabChild != null) {
      final fabParentData = fabChild.parentData as FabLayoutParentData;
      if (fabChild.hitTest(result, position: position - fabParentData.offset)) {
        return true;
      }
    }
    if (_progress > 0.0) {
      final RenderBox? toolbarChild = firstChild;
      if (toolbarChild != null) {
        final toolbarParentData =
            toolbarChild.parentData as FabLayoutParentData;
        if (toolbarChild.hitTest(
          result,
          position: position - toolbarParentData.offset,
        )) {
          return true;
        }
      }
    }
    return false;
  }
}
