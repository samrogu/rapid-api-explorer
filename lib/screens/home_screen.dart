import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/environment_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeEnv = ref.watch(activeEnvironmentProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Rapid API Explorer'),
        actions: [
          if (activeEnv != null) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(child: Text(activeEnv.name)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu')),
            ListTile(
              title: Text('Colecciones'),
              onTap: () => context.push('/collections'),
            ),
            ListTile(
              title: Text('Entornos'),
              onTap: () => context.push('/environments'),
            ),
            ListTile(
              title: Text('Nuevo Request'),
              onTap: () => context.push('/request'),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Selecciona o crea una petición')),    );
  }
}
