import 'package:equatable/equatable.dart';

import '../../../../core/sync/sync_status.dart';

class Invoice extends Equatable {
  /// Local UUID (always present).
  final String id;

  /// Remote ID from Supabase (null until first sync).
  final String? remoteId;

  final String customerName;
  final double amount;
  final DateTime issueDate;

  /// Timestamp of last local modification.
  final DateTime updatedAt;

  /// Current sync state.
  final SyncStatus syncStatus;

  const Invoice({
    required this.id,
    this.remoteId,
    required this.customerName,
    required this.amount,
    required this.issueDate,
    required this.updatedAt,
    this.syncStatus = SyncStatus.pendingCreate,
  });

  /// Creates a copy with modified fields.
  Invoice copyWith({
    String? id,
    String? remoteId,
    String? customerName,
    double? amount,
    DateTime? issueDate,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Invoice(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      customerName: customerName ?? this.customerName,
      amount: amount ?? this.amount,
      issueDate: issueDate ?? this.issueDate,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    remoteId,
    customerName,
    amount,
    issueDate,
    updatedAt,
    syncStatus,
  ];
}
