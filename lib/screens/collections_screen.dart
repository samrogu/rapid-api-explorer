import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/request_model.dart';
import '../providers/request_providers.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Colecciones')),
      body: ListView(
        children: requests
            .map((r) => ListTile(
                  title: Text(r.name),
                  subtitle: Text('${r.method} ${r.url}'),
                  onTap: () {
                    context.push('/request', extra: r);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(requestListProvider.notifier).remove(r.id);
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
