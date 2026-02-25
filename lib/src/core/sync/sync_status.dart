/// Tracks the synchronization state of a local entity with the remote backend.
enum SyncStatus {
  /// Entity exists only locally and has never been synced.
  pendingCreate,

  /// Entity was updated locally since the last sync.
  pendingUpdate,

  /// Entity was deleted locally and deletion needs to sync.
  pendingDelete,

  /// Entity is fully synced with the remote backend.
  synced,
}
