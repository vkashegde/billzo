import '../entities/invoice.dart';

abstract class InvoiceRepository {
  Future<List<Invoice>> getInvoices();
  Future<Invoice?> getInvoiceById(String id);
  Future<void> saveInvoice(Invoice invoice);
  Future<void> deleteInvoice(String id);
  Future<List<Invoice>> getPendingSyncInvoices();
}
