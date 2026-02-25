import 'sync_status.dart';

/// Abstract contract for synchronizing local data with a remote backend.
///
/// Implementations can target Supabase, Firebase, REST APIs, etc.
abstract class SyncService {
  /// Pushes all pending local changes to the remote backend.
  ///
  /// Returns the number of records successfully synced.
  Future<int> pushPendingChanges();

  /// Pulls latest changes from the remote backend and merges into local storage.
  ///
  /// Returns the number of records updated locally.
  Future<int> pullRemoteChanges();

  /// Performs a full bidirectional sync (push then pull).
  Future<void> syncAll();

  /// Returns true if there are any records with pending sync status.
  Future<bool> hasPendingChanges();

  /// Returns the timestamp of the last successful sync, or null if never synced.
  Future<DateTime?> lastSyncTime();
}

/// Marker mixin for entities that support sync.
mixin Syncable {
  String get id;
  String? get remoteId;
  SyncStatus get syncStatus;
  DateTime get updatedAt;
}
