import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class SaveInvoice {
  final InvoiceRepository _repository;

  SaveInvoice(this._repository);

  Future<void> call(Invoice invoice) {
    return _repository.saveInvoice(invoice);
  }
}
