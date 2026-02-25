import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to monitor network connectivity status.
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  /// Stream of connectivity changes.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  /// Returns true if currently connected to the internet.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    // Connected if any result is not "none"
    return results.any((r) => r != ConnectivityResult.none);
  }
}
