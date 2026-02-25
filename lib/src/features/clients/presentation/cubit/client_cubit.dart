import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final ClientRepository _repository;

  ClientCubit(this._repository) : super(const ClientInitial());

  Future<void> loadClients() async {
    emit(const ClientLoading());
    try {
      final clients = await _repository.getClients();
      emit(ClientLoaded(clients));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> addClient(Client client) async {
    try {
      await _repository.saveClient(client);
      await loadClients();
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> updateClient(Client client) async {
    try {
      await _repository.saveClient(client);
      await loadClients();
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      await _repository.deleteClient(id);
      await loadClients();
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}
