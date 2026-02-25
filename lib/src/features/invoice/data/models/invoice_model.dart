import 'package:hive/hive.dart';

import '../../../../core/sync/sync_status.dart';
import '../../domain/entities/invoice.dart';

class InvoiceModel {
  String id;
  String? remoteId;
  String customerName;
  double amount;
  DateTime issueDate;
  DateTime updatedAt;
  int syncStatusIndex; // stored as int for Hive

  InvoiceModel({
    required this.id,
    this.remoteId,
    required this.customerName,
    required this.amount,
    required this.issueDate,
    required this.updatedAt,
    required this.syncStatusIndex,
  });

  factory InvoiceModel.fromEntity(Invoice invoice) => InvoiceModel(
    id: invoice.id,
    remoteId: invoice.remoteId,
    customerName: invoice.customerName,
    amount: invoice.amount,
    issueDate: invoice.issueDate,
    updatedAt: invoice.updatedAt,
    syncStatusIndex: invoice.syncStatus.index,
  );

  Invoice toEntity() => Invoice(
    id: id,
    remoteId: remoteId,
    customerName: customerName,
    amount: amount,
    issueDate: issueDate,
    updatedAt: updatedAt,
    syncStatus: SyncStatus.values[syncStatusIndex],
  );

  /// Converts model to JSON for Supabase (placeholder).
  Map<String, dynamic> toJson() => {
    'id': remoteId, // use remoteId when syncing
    'local_id': id,
    'customer_name': customerName,
    'amount': amount,
    'issue_date': issueDate.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Creates model from Supabase JSON response (placeholder).
  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    id: json['local_id'] as String? ?? json['id'] as String,
    remoteId: json['id'] as String?,
    customerName: json['customer_name'] as String,
    amount: (json['amount'] as num).toDouble(),
    issueDate: DateTime.parse(json['issue_date'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    syncStatusIndex: SyncStatus.synced.index,
  );
}

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 1;

  @override
  InvoiceModel read(BinaryReader reader) {
    final id = reader.readString();
    final remoteId = reader.readString();
    final customerName = reader.readString();
    final amount = reader.readDouble();
    final issueDate = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final syncStatusIndex = reader.readInt();

    return InvoiceModel(
      id: id,
      remoteId: remoteId.isEmpty ? null : remoteId,
      customerName: customerName,
      amount: amount,
      issueDate: issueDate,
      updatedAt: updatedAt,
      syncStatusIndex: syncStatusIndex,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.remoteId ?? '');
    writer.writeString(obj.customerName);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.issueDate.millisecondsSinceEpoch);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.syncStatusIndex);
  }
}
