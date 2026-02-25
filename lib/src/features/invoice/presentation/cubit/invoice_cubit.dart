import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/invoice.dart';
import '../../domain/usecases/delete_invoice.dart';
import '../../domain/usecases/get_invoices.dart';
import '../../domain/usecases/save_invoice.dart';
import 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  final GetInvoices _getInvoices;
  final SaveInvoice _saveInvoice;
  final DeleteInvoice _deleteInvoice;

  InvoiceCubit({
    required GetInvoices getInvoices,
    required SaveInvoice saveInvoice,
    required DeleteInvoice deleteInvoice,
  }) : _getInvoices = getInvoices,
       _saveInvoice = saveInvoice,
       _deleteInvoice = deleteInvoice,
       super(const InvoiceInitial());

  Future<void> loadInvoices() async {
    emit(const InvoiceLoading());
    try {
      final invoices = await _getInvoices();
      emit(InvoiceLoaded(invoices));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _saveInvoice(invoice);
      // Reload to reflect persisted state
      await loadInvoices();
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await _saveInvoice(invoice);
      await loadInvoices();
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> removeInvoice(String id) async {
    try {
      await _deleteInvoice(id);
      await loadInvoices();
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}
