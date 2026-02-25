import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const String routePath = '/profile';
  static const String routeName = 'profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile coming soon')),
    );
  }
}
