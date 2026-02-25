import 'package:equatable/equatable.dart';

import '../../../../core/sync/sync_status.dart';

class Client extends Equatable {
  /// Local UUID.
  final String id;

  /// Remote ID from Supabase (null until synced).
  final String? remoteId;

  /// Client/Company name.
  final String name;

  /// Email address.
  final String email;

  /// Location (e.g., "New York, NY").
  final String? location;

  /// Phone number.
  final String? phone;

  /// Avatar URL or null for initials-based avatar.
  final String? avatarUrl;

  /// Total number of invoices for this client.
  final int totalInvoices;

  /// Total amount billed to this client.
  final double totalBilled;

  /// Timestamp of last modification.
  final DateTime updatedAt;

  /// Current sync state.
  final SyncStatus syncStatus;

  const Client({
    required this.id,
    this.remoteId,
    required this.name,
    required this.email,
    this.location,
    this.phone,
    this.avatarUrl,
    this.totalInvoices = 0,
    this.totalBilled = 0,
    required this.updatedAt,
    this.syncStatus = SyncStatus.pendingCreate,
  });

  /// Get initials for avatar (e.g., "AC" for "Acme Corp").
  String get initials {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  Client copyWith({
    String? id,
    String? remoteId,
    String? name,
    String? email,
    String? location,
    String? phone,
    String? avatarUrl,
    int? totalInvoices,
    double? totalBilled,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Client(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalInvoices: totalInvoices ?? this.totalInvoices,
      totalBilled: totalBilled ?? this.totalBilled,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    remoteId,
    name,
    email,
    location,
    phone,
    avatarUrl,
    totalInvoices,
    totalBilled,
    updatedAt,
    syncStatus,
  ];
}
