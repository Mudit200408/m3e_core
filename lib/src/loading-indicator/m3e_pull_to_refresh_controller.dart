import 'package:flutter/foundation.dart';

/// Controller for programmatically observing and managing the state of a
/// [M3EPullToRefreshIndicator].
///
/// Exposes [distanceFraction], [isRefreshing], [isAnimating], and allows
/// programmatically opening the header and triggering a refresh via [refresh].
class M3EPullToRefreshController extends ChangeNotifier {
  double _distanceFraction = 0.0;
  bool _isRefreshing = false;
  bool _isAnimating = false;

  /// Distance percentage towards the refresh threshold.
  ///
  /// `0.0` indicates idle at top, `1.0` indicates at positional threshold,
  /// `> 1.0` indicates drag overshoot.
  double get distanceFraction => _distanceFraction;

  /// Whether a refresh operation is currently executing.
  bool get isRefreshing => _isRefreshing;

  /// Whether the indicator is currently performing a spring animation.
  bool get isAnimating => _isAnimating;

  /// Callback registered by the attached [M3EPullToRefreshIndicator].
  Future<void> Function()? _refreshCallback;

  /// Attaches a callback to handle programmatic [refresh] triggers.
  void attach(Future<void> Function() refreshCallback) {
    _refreshCallback = refreshCallback;
  }

  /// Detaches the registered refresh callback.
  void detach() {
    _refreshCallback = null;
  }

  /// Programmatically triggers the pull-to-refresh operation.
  ///
  /// Opens the indicator header to [indicatorHeight] and executes [onRefresh].
  Future<void> refresh() async {
    if (_isRefreshing) return;
    if (_refreshCallback != null) {
      await _refreshCallback!();
    }
  }

  /// Internal update method called by [M3EPullToRefreshIndicator].
  void updateState({
    required double distanceFraction,
    required bool isRefreshing,
    required bool isAnimating,
  }) {
    if (_distanceFraction == distanceFraction &&
        _isRefreshing == isRefreshing &&
        _isAnimating == isAnimating) {
      return;
    }
    _distanceFraction = distanceFraction;
    _isRefreshing = isRefreshing;
    _isAnimating = isAnimating;
    notifyListeners();
  }
}
