import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

/// Mix this into any screen whose data can silently go stale without the
/// farmer doing anything to cause it: the phone regaining a signal after a
/// stretch offline, or the app being backgrounded and resumed later (its
/// cached weather may have crossed WeatherService.freshnessWindow, or a
/// photo/sky update from a different screen may have changed what this
/// screen should now show).
///
/// Screens using this should already have a reload method (however it's
/// named — `_load`, `_refresh`, etc) that accepts a `showSpinner` parameter,
/// so a background refresh triggered by this mixin doesn't blank out a
/// screen the farmer is currently looking at.
///
/// Usage:
/// ```dart
/// class _HomeScreenState extends State<HomeScreen>
///     with WidgetsBindingObserver, LiveRefreshState<HomeScreen> {
///   @override
///   void initState() {
///     super.initState();
///     _load();
///     initLiveRefresh();
///   }
///
///   @override
///   void dispose() {
///     disposeLiveRefresh();
///     super.dispose();
///   }
///
///   @override
///   void didChangeAppLifecycleState(AppLifecycleState state) {
///     handleAppLifecycleState(state);
///   }
///
///   @override
///   Future<void> onLiveRefresh() => _load(showSpinner: false);
/// }
/// ```
///
/// NOTE: the consuming State must itself mix in `WidgetsBindingObserver`
/// (before this mixin, in the `with` clause) and forward
/// `didChangeAppLifecycleState` to [handleAppLifecycleState], as shown
/// above — this mixin deliberately doesn't declare that override itself,
/// so it isn't forced to stub out every unrelated WidgetsBindingObserver
/// callback just to satisfy the interface.
mixin LiveRefreshState<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasOffline = false;
  DateTime? _lastLiveRefresh;

  /// Minimum gap between automatic refreshes. A flaky connection bouncing
  /// between "none" and "wifi" a few times in a row shouldn't hammer the
  /// network/DB on every bounce. Manual pull-to-refresh (where a screen has
  /// it) is unaffected by this — it always runs immediately.
  Duration get liveRefreshCooldown => const Duration(seconds: 10);

  /// Called when connectivity returns after being lost, or the app resumes
  /// from the background. Implementations should reload without a
  /// full-screen spinner — this fires without the farmer asking for it.
  Future<void> onLiveRefresh();

  void initLiveRefresh() {
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
  }

  void disposeLiveRefresh() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    _connectivitySub?.cancel();
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final isOffline = results.every((r) => r == ConnectivityResult.none);
    if (_wasOffline && !isOffline) {
      _maybeRefresh();
    }
    _wasOffline = isOffline;
  }

  /// Called by the consuming State's own `didChangeAppLifecycleState`
  /// override (see usage above) — this mixin doesn't declare that override
  /// itself so it doesn't have to be `on WidgetsBindingObserver` and stub
  /// out every unrelated observer callback.
  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeRefresh();
    }
  }

  void _maybeRefresh() {
    final now = DateTime.now();
    if (_lastLiveRefresh != null &&
        now.difference(_lastLiveRefresh!) < liveRefreshCooldown) {
      return;
    }
    _lastLiveRefresh = now;
    if (mounted) onLiveRefresh();
  }
}
