import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/environment_model.dart';
import '../providers/environment_providers.dart';

class EnvironmentsScreen extends ConsumerStatefulWidget {
  const EnvironmentsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnvironmentsScreen> createState() => _EnvironmentsScreenState();
}

class _EnvironmentsScreenState extends ConsumerState<EnvironmentsScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final envs = ref.watch(environmentListProvider);
    final activeEnv = ref.watch(activeEnvironmentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Entornos')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del entorno'),
            ),
            ElevatedButton(
              onPressed: () {
                final env = EnvironmentModel(id: const Uuid().v4(), name: _nameController.text);
                ref.read(environmentListProvider.notifier).add(env);
                _nameController.clear();
              },
              child: const Text('Agregar'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: envs.map((e) => ListTile(
                      title: Text(e.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (activeEnv?.id == e.id) const Icon(Icons.check),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(environmentListProvider.notifier).remove(e.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        ref.read(activeEnvironmentProvider.notifier).state = e;
                      },
                    )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
