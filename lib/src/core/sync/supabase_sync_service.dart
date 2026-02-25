import 'package:hive_flutter/hive_flutter.dart';

import 'sync_service.dart';

const String kLastSyncTimeKey = 'last_sync_time';
const String kSyncMetaBoxName = 'sync_meta';

/// Placeholder Supabase sync implementation.
///
/// When Supabase is integrated, this class will:
/// 1. Read all local records with pendingCreate/pendingUpdate/pendingDelete.
/// 2. Batch upsert/delete to Supabase.
/// 3. Update local records with remoteId and mark as synced.
/// 4. Pull server changes since lastSyncTime and merge locally.
class SupabaseSyncService implements SyncService {
  final Box<dynamic> _metaBox;

  // TODO: Inject Supabase client when ready
  // final SupabaseClient _supabase;

  SupabaseSyncService(this._metaBox);

  @override
  Future<int> pushPendingChanges() async {
    // TODO: Implement when Supabase is connected
    // 1. Query local Hive boxes for records where syncStatus != synced
    // 2. For pendingCreate: insert to Supabase, get remoteId, update local
    // 3. For pendingUpdate: upsert to Supabase by remoteId
    // 4. For pendingDelete: delete from Supabase by remoteId, remove local
    return 0;
  }

  @override
  Future<int> pullRemoteChanges() async {
    // TODO: Implement when Supabase is connected
    // 1. Query Supabase for records updated since lastSyncTime
    // 2. Upsert into local Hive boxes, matching by remoteId
    // 3. Handle conflict resolution (server wins by default)
    return 0;
  }

  @override
  Future<void> syncAll() async {
    await pushPendingChanges();
    await pullRemoteChanges();
    await _metaBox.put(kLastSyncTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<bool> hasPendingChanges() async {
    // TODO: Check all syncable boxes for non-synced records
    return false;
  }

  @override
  Future<DateTime?> lastSyncTime() async {
    final millis = _metaBox.get(kLastSyncTimeKey) as int?;
    return millis != null ? DateTime.fromMillisecondsSinceEpoch(millis) : null;
  }
}
