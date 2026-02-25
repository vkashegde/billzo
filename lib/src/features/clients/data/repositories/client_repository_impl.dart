import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_local_data_source.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDataSource _localDataSource;

  ClientRepositoryImpl(this._localDataSource);

  @override
  Future<List<Client>> getClients() async {
    final models = await _localDataSource.getClients();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Client?> getClientById(String id) async {
    final model = await _localDataSource.getClientById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveClient(Client client) async {
    final model = ClientModel.fromEntity(client);
    await _localDataSource.saveClient(model);
  }

  @override
  Future<void> deleteClient(String id) async {
    await _localDataSource.deleteClient(id);
  }
}
