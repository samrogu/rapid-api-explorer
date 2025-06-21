import 'package:hive_flutter/hive_flutter.dart';

import '../models/environment_model.dart';
import '../models/request_model.dart';

class HiveStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RequestModelAdapter());
    Hive.registerAdapter(EnvironmentModelAdapter());

    await Hive.openBox<RequestModel>('requests');
    await Hive.openBox<EnvironmentModel>('environments');
  }
}
