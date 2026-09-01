// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:material_ui/material_ui.dart';
import 'package:m3e_core/m3e_core.dart';
import '../models/loading_models.dart';

class LoadingPreviewArea extends StatelessWidget {
  const LoadingPreviewArea({
    super.key,
    required this.variant,
    required this.shapes,
    required this.determinate,
    required this.progress,
    required this.indicatorSize,
    required this.customIndicatorColor,
    required this.indicatorColor,
    required this.semanticsLabel,
    required this.semanticsValue,
    required this.containerWidth,
    required this.containerHeight,
    required this.padding,
    required this.fullRadius,
    required this.radius,
    required this.customContainerColor,
    required this.containerColor,
    required this.pullController,
    required this.customPullIcon,
    required this.customPullBuilder,
    required this.triggerDistance,
    required this.indicatorHeight,
    required this.spring,
    required this.haptic,
    required this.dragResistance,
    required this.maxDragMultiplier,
    required this.edgeOffset,
    required this.pullSize,
    required this.pullPadding,
    required this.elevation,
    required this.pullRadius,
    required this.onRefresh,
    required this.onError,
  });

  final LoadingVariant variant;
  final Set<Shapes> shapes;
  final bool determinate;
  final double progress;
  final double indicatorSize;
  final bool customIndicatorColor;
  final Color indicatorColor;
  final String semanticsLabel;
  final String semanticsValue;
  final double containerWidth;
  final double containerHeight;
  final double padding;
  final bool fullRadius;
  final double radius;
  final bool customContainerColor;
  final Color containerColor;
  final M3EPullToRefreshController pullController;
  final bool customPullIcon;
  final bool customPullBuilder;
  final double triggerDistance;
  final double indicatorHeight;
  final M3EMotion spring;
  final M3EHapticFeedback haptic;
  final double dragResistance;
  final double maxDragMultiplier;
  final double edgeOffset;
  final double pullSize;
  final double pullPadding;
  final double elevation;
  final double pullRadius;
  final Future<void> Function() onRefresh;
  final void Function(Object error, StackTrace? stack) onError;

  @override
  Widget build(BuildContext context) {
    if (variant == LoadingVariant.pullToRefresh) {
      final list = ListView.builder(
        key: const PageStorageKey('loading_pull_list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: 12,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('Refreshable item ${index + 1}'),
            subtitle: const Text('Pull down from the top edge'),
          ),
        ),
      );
      return SizedBox(
        height: 440,
        child: M3EPullToRefreshIndicator(
          key: const ValueKey('pull_to_refresh_preview'),
          controller: pullController,
          shapes: shapes.toList(),
          indicatorIcon: customPullIcon
              ? const M3ECircularWavyProgressIndicator(strokeWidth: 3)
              : null,
          indicatorBuilder: customPullBuilder
              ? (context, progress, isRefreshing) => Icon(
                  isRefreshing ? Icons.sync_rounded : Icons.refresh_rounded,
                  color: customIndicatorColor
                      ? indicatorColor
                      : Theme.of(context).colorScheme.primary,
                )
              : null,
          triggerDistance: triggerDistance,
          indicatorHeight: indicatorHeight,
          springMotion: spring,
          hapticFeedback: haptic,
          dragResistance: dragResistance,
          maxDragMultiplier: maxDragMultiplier,
          edgeOffset: edgeOffset,
          style: M3EPullToRefreshStyle(
            containerColor: customContainerColor ? containerColor : null,
            indicatorColor: customIndicatorColor ? indicatorColor : null,
            size: pullSize,
            padding: EdgeInsets.all(pullPadding),
            elevation: elevation,
            borderRadius: BorderRadius.circular(pullRadius),
            triggerDistance: triggerDistance,
            indicatorHeight: indicatorHeight,
            springMotion: spring,
            hapticFeedback: haptic,
            dragResistance: dragResistance,
            maxDragMultiplier: maxDragMultiplier,
          ),
          onRefresh: onRefresh,
          onError: onError,
          child: list,
        ),
      );
    }

    final indicator = M3ELoadingIndicator(
      key: const ValueKey('loading_indicator_preview'),
      shapes: shapes.toList(),
      value: determinate ? progress : null,
      constraints: BoxConstraints.tightFor(
        width: indicatorSize,
        height: indicatorSize,
      ),
      color: customIndicatorColor ? indicatorColor : null,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
    if (variant == LoadingVariant.indicator) return indicator;

    return M3EContainedLoadingIndicator(
      key: const ValueKey('contained_loading_preview'),
      shapes: shapes.toList(),
      width: containerWidth,
      height: containerHeight,
      padding: EdgeInsets.all(padding),
      borderRadius: fullRadius ? null : BorderRadius.circular(radius),
      progress: determinate ? progress : null,
      containerColor: customContainerColor ? containerColor : null,
      indicatorColor: customIndicatorColor ? indicatorColor : null,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
  }
}
