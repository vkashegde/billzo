import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/sync/sync_status.dart';
import '../models/client_model.dart';

const String kClientBoxName = 'clients_box';

abstract class ClientLocalDataSource {
  Future<List<ClientModel>> getClients();
  Future<ClientModel?> getClientById(String id);
  Future<void> saveClient(ClientModel client);
  Future<void> deleteClient(String id);
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final Box<ClientModel> _box;

  ClientLocalDataSourceImpl(this._box);

  @override
  Future<List<ClientModel>> getClients() async {
    return _box.values
        .where((m) => m.syncStatusIndex != SyncStatus.pendingDelete.index)
        .toList();
  }

  @override
  Future<ClientModel?> getClientById(String id) async {
    try {
      return _box.values.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveClient(ClientModel client) async {
    await _box.put(client.id, client);
  }

  @override
  Future<void> deleteClient(String id) async {
    final existing = await getClientById(id);
    if (existing == null) return;

    if (existing.remoteId != null) {
      existing.syncStatusIndex = SyncStatus.pendingDelete.index;
      existing.updatedAt = DateTime.now();
      await _box.put(id, existing);
    } else {
      await _box.delete(id);
    }
  }
}
