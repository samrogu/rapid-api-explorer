import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/environment_model.dart';

final environmentsBoxProvider = Provider<Box<EnvironmentModel>>((ref) {
  return Hive.box<EnvironmentModel>('environments');
});

class EnvironmentListNotifier extends StateNotifier<List<EnvironmentModel>> {
  final Box<EnvironmentModel> box;
  EnvironmentListNotifier(this.box) : super(box.values.toList());

  void add(EnvironmentModel env) {
    box.put(env.id, env);
    state = box.values.toList();
  }

  void remove(String id) {
    box.delete(id);
    state = box.values.toList();
  }

  void updateEnv(EnvironmentModel env) {
    box.put(env.id, env);
    state = box.values.toList();
  }
}

final environmentListProvider =
    StateNotifierProvider<EnvironmentListNotifier, List<EnvironmentModel>>((ref) {
  final box = ref.watch(environmentsBoxProvider);
  return EnvironmentListNotifier(box);
});

final activeEnvironmentProvider =
    StateProvider<EnvironmentModel?>((ref) => null);
