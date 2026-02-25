import 'package:hive/hive.dart';

import '../../../../core/sync/sync_status.dart';
import '../../domain/entities/client.dart';

class ClientModel {
  String id;
  String? remoteId;
  String name;
  String email;
  String? location;
  String? phone;
  String? avatarUrl;
  int totalInvoices;
  double totalBilled;
  DateTime updatedAt;
  int syncStatusIndex;

  ClientModel({
    required this.id,
    this.remoteId,
    required this.name,
    required this.email,
    this.location,
    this.phone,
    this.avatarUrl,
    required this.totalInvoices,
    required this.totalBilled,
    required this.updatedAt,
    required this.syncStatusIndex,
  });

  factory ClientModel.fromEntity(Client client) => ClientModel(
    id: client.id,
    remoteId: client.remoteId,
    name: client.name,
    email: client.email,
    location: client.location,
    phone: client.phone,
    avatarUrl: client.avatarUrl,
    totalInvoices: client.totalInvoices,
    totalBilled: client.totalBilled,
    updatedAt: client.updatedAt,
    syncStatusIndex: client.syncStatus.index,
  );

  Client toEntity() => Client(
    id: id,
    remoteId: remoteId,
    name: name,
    email: email,
    location: location,
    phone: phone,
    avatarUrl: avatarUrl,
    totalInvoices: totalInvoices,
    totalBilled: totalBilled,
    updatedAt: updatedAt,
    syncStatus: SyncStatus.values[syncStatusIndex],
  );

  Map<String, dynamic> toJson() => {
    'id': remoteId,
    'local_id': id,
    'name': name,
    'email': email,
    'location': location,
    'phone': phone,
    'avatar_url': avatarUrl,
    'total_invoices': totalInvoices,
    'total_billed': totalBilled,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json['local_id'] as String? ?? json['id'] as String,
    remoteId: json['id'] as String?,
    name: json['name'] as String,
    email: json['email'] as String,
    location: json['location'] as String?,
    phone: json['phone'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    totalInvoices: json['total_invoices'] as int? ?? 0,
    totalBilled: (json['total_billed'] as num?)?.toDouble() ?? 0,
    updatedAt: DateTime.parse(json['updated_at'] as String),
    syncStatusIndex: SyncStatus.synced.index,
  );
}

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = 3;

  @override
  ClientModel read(BinaryReader reader) {
    return ClientModel(
      id: reader.readString(),
      remoteId: reader.readString().isEmpty ? null : reader.readString(),
      name: reader.readString(),
      email: reader.readString(),
      location: reader.readString().isEmpty ? null : reader.readString(),
      phone: reader.readString().isEmpty ? null : reader.readString(),
      avatarUrl: reader.readString().isEmpty ? null : reader.readString(),
      totalInvoices: reader.readInt(),
      totalBilled: reader.readDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      syncStatusIndex: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.remoteId ?? '');
    writer.writeString(obj.name);
    writer.writeString(obj.email);
    writer.writeString(obj.location ?? '');
    writer.writeString(obj.phone ?? '');
    writer.writeString(obj.avatarUrl ?? '');
    writer.writeInt(obj.totalInvoices);
    writer.writeDouble(obj.totalBilled);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.syncStatusIndex);
  }
}
