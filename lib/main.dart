import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/request_model.dart';
import 'screens/collections_screen.dart';
import 'screens/environments_screen.dart';
import 'screens/home_screen.dart';
import 'screens/request_editor_screen.dart';
import 'storage/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();

  // Add sample data if boxes are empty
  final reqBox = Hive.box<RequestModel>('requests');
  if (reqBox.isEmpty) {
    reqBox.put(
      'sample',
      RequestModel(
        id: 'sample',
        name: 'Todo example',
        url: 'https://jsonplaceholder.typicode.com/todos/1',
        method: 'GET',
      ),
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/request',
          builder: (context, state) {
            final req = state.extra as RequestModel?;
            return RequestEditorScreen(request: req);
          },
        ),
        GoRoute(
          path: '/environments',
          builder: (context, state) => const EnvironmentsScreen(),
        ),
        GoRoute(
          path: '/collections',
          builder: (context, state) => const CollectionsScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Rapid API Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}
