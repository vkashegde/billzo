import 'package:flutter/material.dart';

class ClientsPage extends StatelessWidget {
  static const String routePath = '/clients';
  static const String routeName = 'clients';

  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: const Center(child: Text('Clients coming soon')),
    );
  }
}
