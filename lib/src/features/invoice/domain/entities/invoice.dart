import 'package:equatable/equatable.dart';

import '../../../../core/sync/sync_status.dart';
import 'line_item.dart';

/// Invoice status for workflow tracking.
enum InvoiceStatus { draft, sent, paid, overdue, cancelled }

class Invoice extends Equatable {
  /// Local UUID (always present).
  final String id;

  /// Remote ID from Supabase (null until first sync).
  final String? remoteId;

  /// Invoice number (e.g., INV-9921).
  final String invoiceNumber;

  /// Client ID (references Client entity).
  final String? clientId;

  /// Client name (denormalized for display).
  final String clientName;

  /// Line items (products/services).
  final List<LineItem> lineItems;

  /// Invoice dates.
  final DateTime issueDate;
  final DateTime? dueDate;

  /// Additional notes/terms.
  final String? notes;

  /// Tax percentage (e.g., 10 for 10%).
  final double taxPercent;

  /// Discount amount (flat).
  final double discountAmount;

  /// Invoice workflow status.
  final InvoiceStatus status;

  /// Timestamp of last local modification.
  final DateTime updatedAt;

  /// Current sync state.
  final SyncStatus syncStatus;

  const Invoice({
    required this.id,
    this.remoteId,
    required this.invoiceNumber,
    this.clientId,
    required this.clientName,
    this.lineItems = const [],
    required this.issueDate,
    this.dueDate,
    this.notes,
    this.taxPercent = 0,
    this.discountAmount = 0,
    this.status = InvoiceStatus.draft,
    required this.updatedAt,
    this.syncStatus = SyncStatus.pendingCreate,
  });

  /// Subtotal before tax and discount.
  double get subtotal => lineItems.fold(0, (sum, item) => sum + item.total);

  /// Tax amount.
  double get taxAmount => subtotal * (taxPercent / 100);

  /// Total amount after tax and discount.
  double get totalAmount => subtotal + taxAmount - discountAmount;

  /// Creates a copy with modified fields.
  Invoice copyWith({
    String? id,
    String? remoteId,
    String? invoiceNumber,
    String? clientId,
    String? clientName,
    List<LineItem>? lineItems,
    DateTime? issueDate,
    DateTime? dueDate,
    String? notes,
    double? taxPercent,
    double? discountAmount,
    InvoiceStatus? status,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
  }) {
    return Invoice(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      lineItems: lineItems ?? this.lineItems,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      taxPercent: taxPercent ?? this.taxPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    remoteId,
    invoiceNumber,
    clientId,
    clientName,
    lineItems,
    issueDate,
    dueDate,
    notes,
    taxPercent,
    discountAmount,
    status,
    updatedAt,
    syncStatus,
  ];
}
