import '../entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClients();
  Future<Client?> getClientById(String id);
  Future<void> saveClient(Client client);
  Future<void> deleteClient(String id);
}
