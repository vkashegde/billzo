import 'package:hive/hive.dart';

import '../../../../core/sync/sync_status.dart';
import '../../domain/entities/invoice.dart';
import 'line_item_model.dart';

class InvoiceModel {
  String id;
  String? remoteId;
  String invoiceNumber;
  String? clientId;
  String clientName;
  List<LineItemModel> lineItems;
  DateTime issueDate;
  DateTime? dueDate;
  String? notes;
  double taxPercent;
  double discountAmount;
  int statusIndex;
  DateTime updatedAt;
  int syncStatusIndex;

  InvoiceModel({
    required this.id,
    this.remoteId,
    required this.invoiceNumber,
    this.clientId,
    required this.clientName,
    required this.lineItems,
    required this.issueDate,
    this.dueDate,
    this.notes,
    required this.taxPercent,
    required this.discountAmount,
    required this.statusIndex,
    required this.updatedAt,
    required this.syncStatusIndex,
  });

  factory InvoiceModel.fromEntity(Invoice invoice) => InvoiceModel(
    id: invoice.id,
    remoteId: invoice.remoteId,
    invoiceNumber: invoice.invoiceNumber,
    clientId: invoice.clientId,
    clientName: invoice.clientName,
    lineItems: invoice.lineItems
        .map((e) => LineItemModel.fromEntity(e))
        .toList(),
    issueDate: invoice.issueDate,
    dueDate: invoice.dueDate,
    notes: invoice.notes,
    taxPercent: invoice.taxPercent,
    discountAmount: invoice.discountAmount,
    statusIndex: invoice.status.index,
    updatedAt: invoice.updatedAt,
    syncStatusIndex: invoice.syncStatus.index,
  );

  Invoice toEntity() => Invoice(
    id: id,
    remoteId: remoteId,
    invoiceNumber: invoiceNumber,
    clientId: clientId,
    clientName: clientName,
    lineItems: lineItems.map((e) => e.toEntity()).toList(),
    issueDate: issueDate,
    dueDate: dueDate,
    notes: notes,
    taxPercent: taxPercent,
    discountAmount: discountAmount,
    status: InvoiceStatus.values[statusIndex],
    updatedAt: updatedAt,
    syncStatus: SyncStatus.values[syncStatusIndex],
  );

  Map<String, dynamic> toJson() => {
    'id': remoteId,
    'local_id': id,
    'invoice_number': invoiceNumber,
    'client_id': clientId,
    'client_name': clientName,
    'line_items': lineItems.map((e) => e.toJson()).toList(),
    'issue_date': issueDate.toIso8601String(),
    'due_date': dueDate?.toIso8601String(),
    'notes': notes,
    'tax_percent': taxPercent,
    'discount_amount': discountAmount,
    'status': InvoiceStatus.values[statusIndex].name,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    id: json['local_id'] as String? ?? json['id'] as String,
    remoteId: json['id'] as String?,
    invoiceNumber: json['invoice_number'] as String,
    clientId: json['client_id'] as String?,
    clientName: json['client_name'] as String,
    lineItems: (json['line_items'] as List)
        .map((e) => LineItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    issueDate: DateTime.parse(json['issue_date'] as String),
    dueDate: json['due_date'] != null
        ? DateTime.parse(json['due_date'] as String)
        : null,
    notes: json['notes'] as String?,
    taxPercent: (json['tax_percent'] as num).toDouble(),
    discountAmount: (json['discount_amount'] as num).toDouble(),
    statusIndex: InvoiceStatus.values.indexWhere(
      (e) => e.name == json['status'],
    ),
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
    final invoiceNumber = reader.readString();
    final clientId = reader.readString();
    final clientName = reader.readString();

    final lineItemsLength = reader.readInt();
    final lineItems = <LineItemModel>[];
    for (var i = 0; i < lineItemsLength; i++) {
      lineItems.add(
        LineItemModel(
          id: reader.readString(),
          description: reader.readString(),
          quantity: reader.readInt(),
          unitPrice: reader.readDouble(),
        ),
      );
    }

    final issueDate = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dueDateMillis = reader.readInt();
    final dueDate = dueDateMillis != 0
        ? DateTime.fromMillisecondsSinceEpoch(dueDateMillis)
        : null;
    final notes = reader.readString();
    final taxPercent = reader.readDouble();
    final discountAmount = reader.readDouble();
    final statusIndex = reader.readInt();
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final syncStatusIndex = reader.readInt();

    return InvoiceModel(
      id: id,
      remoteId: remoteId.isEmpty ? null : remoteId,
      invoiceNumber: invoiceNumber,
      clientId: clientId.isEmpty ? null : clientId,
      clientName: clientName,
      lineItems: lineItems,
      issueDate: issueDate,
      dueDate: dueDate,
      notes: notes.isEmpty ? null : notes,
      taxPercent: taxPercent,
      discountAmount: discountAmount,
      statusIndex: statusIndex,
      updatedAt: updatedAt,
      syncStatusIndex: syncStatusIndex,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.remoteId ?? '');
    writer.writeString(obj.invoiceNumber);
    writer.writeString(obj.clientId ?? '');
    writer.writeString(obj.clientName);

    writer.writeInt(obj.lineItems.length);
    for (final item in obj.lineItems) {
      writer.writeString(item.id);
      writer.writeString(item.description);
      writer.writeInt(item.quantity);
      writer.writeDouble(item.unitPrice);
    }

    writer.writeInt(obj.issueDate.millisecondsSinceEpoch);
    writer.writeInt(obj.dueDate?.millisecondsSinceEpoch ?? 0);
    writer.writeString(obj.notes ?? '');
    writer.writeDouble(obj.taxPercent);
    writer.writeDouble(obj.discountAmount);
    writer.writeInt(obj.statusIndex);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.syncStatusIndex);
  }
}
