import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_data_source.dart';
import '../models/invoice_model.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDataSource _localDataSource;

  InvoiceRepositoryImpl(this._localDataSource);

  @override
  Future<List<Invoice>> getInvoices() async {
    final models = await _localDataSource.getInvoices();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Invoice?> getInvoiceById(String id) async {
    final model = await _localDataSource.getInvoiceById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveInvoice(Invoice invoice) async {
    final model = InvoiceModel.fromEntity(invoice);
    await _localDataSource.saveInvoice(model);
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await _localDataSource.deleteInvoice(id);
  }

  @override
  Future<List<Invoice>> getPendingSyncInvoices() async {
    final models = await _localDataSource.getPendingSyncInvoices();
    return models.map((m) => m.toEntity()).toList();
  }
}
