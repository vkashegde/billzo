import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class GetInvoices {
  final InvoiceRepository _repository;

  GetInvoices(this._repository);

  Future<List<Invoice>> call() {
    return _repository.getInvoices();
  }
}
