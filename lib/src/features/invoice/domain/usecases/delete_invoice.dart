import '../repositories/invoice_repository.dart';

class DeleteInvoice {
  final InvoiceRepository _repository;

  DeleteInvoice(this._repository);

  Future<void> call(String id) {
    return _repository.deleteInvoice(id);
  }
}
