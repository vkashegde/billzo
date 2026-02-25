import '../../domain/entities/client.dart';

sealed class ClientState {
  const ClientState();
}

class ClientInitial extends ClientState {
  const ClientInitial();
}

class ClientLoading extends ClientState {
  const ClientLoading();
}

class ClientLoaded extends ClientState {
  final List<Client> clients;

  const ClientLoaded(this.clients);
}

class ClientError extends ClientState {
  final String message;

  const ClientError(this.message);
}
