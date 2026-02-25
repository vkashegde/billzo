import 'dart:async';

import '../network/connectivity_service.dart';
import 'sync_service.dart';

/// Manages automatic and manual synchronization.
///
/// - Triggers sync when connectivity is restored.
/// - Schedules daily background sync.
/// - Exposes manual sync trigger for user-initiated sync.
class SyncManager {
  final SyncService _syncService;
  final ConnectivityService _connectivityService;

  StreamSubscription<bool>? _connectivitySub;
  Timer? _dailySyncTimer;

  bool _isSyncing = false;

  SyncManager({
    required SyncService syncService,
    required ConnectivityService connectivityService,
  }) : _syncService = syncService,
       _connectivityService = connectivityService;

  /// Starts listening for connectivity changes and schedules daily sync.
  void init() {
    _connectivitySub = _connectivityService.onConnectivityChanged.listen((
      connected,
    ) {
      if (connected && !_isSyncing) {
        _performSync();
      }
    });

    // Schedule daily sync (every 24 hours from app start)
    _dailySyncTimer = Timer.periodic(const Duration(hours: 24), (_) {
      _performSync();
    });
  }

  /// Manually triggers a full sync. Returns true if sync was successful.
  Future<bool> manualSync() async {
    return _performSync();
  }

  Future<bool> _performSync() async {
    if (_isSyncing) return false;

    final isOnline = await _connectivityService.isConnected;
    if (!isOnline) return false;

    _isSyncing = true;
    try {
      await _syncService.syncAll();
      return true;
    } catch (e) {
      // TODO: Log sync error
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Checks if there are pending local changes to sync.
  Future<bool> hasPendingChanges() => _syncService.hasPendingChanges();

  /// Returns the last successful sync timestamp.
  Future<DateTime?> lastSyncTime() => _syncService.lastSyncTime();

  /// Cleans up resources.
  void dispose() {
    _connectivitySub?.cancel();
    _dailySyncTimer?.cancel();
  }
}
