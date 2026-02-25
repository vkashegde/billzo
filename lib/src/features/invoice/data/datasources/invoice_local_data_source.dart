import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/sync/sync_status.dart';
import '../models/invoice_model.dart';

const String kInvoiceBoxName = 'invoices_box';

abstract class InvoiceLocalDataSource {
  Future<List<InvoiceModel>> getInvoices();
  Future<InvoiceModel?> getInvoiceById(String id);
  Future<void> saveInvoice(InvoiceModel invoice);
  Future<void> deleteInvoice(String id);
  Future<List<InvoiceModel>> getPendingSyncInvoices();
  Future<void> markAsSynced(String id, String remoteId);
}

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  final Box<InvoiceModel> _box;

  InvoiceLocalDataSourceImpl(this._box);

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    // Exclude soft-deleted (pendingDelete) from normal queries
    return _box.values
        .where((m) => m.syncStatusIndex != SyncStatus.pendingDelete.index)
        .toList();
  }

  @override
  Future<InvoiceModel?> getInvoiceById(String id) async {
    try {
      return _box.values.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveInvoice(InvoiceModel invoice) async {
    // Use id as key for easy lookup/update
    await _box.put(invoice.id, invoice);
  }

  @override
  Future<void> deleteInvoice(String id) async {
    final existing = await getInvoiceById(id);
    if (existing == null) return;

    if (existing.remoteId != null) {
      // Has been synced before: mark for remote deletion
      existing.syncStatusIndex = SyncStatus.pendingDelete.index;
      existing.updatedAt = DateTime.now();
      await _box.put(id, existing);
    } else {
      // Never synced: just remove locally
      await _box.delete(id);
    }
  }

  @override
  Future<List<InvoiceModel>> getPendingSyncInvoices() async {
    return _box.values
        .where((m) => m.syncStatusIndex != SyncStatus.synced.index)
        .toList();
  }

  @override
  Future<void> markAsSynced(String id, String remoteId) async {
    final existing = await getInvoiceById(id);
    if (existing == null) return;

    existing.remoteId = remoteId;
    existing.syncStatusIndex = SyncStatus.synced.index;
    await _box.put(id, existing);
  }
}
