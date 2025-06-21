import 'package:hive/hive.dart';

part 'environment_model.g.dart';

@HiveType(typeId: 1)
class EnvironmentModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Map<String, String> variables;

  EnvironmentModel({
    required this.id,
    required this.name,
    Map<String, String>? variables,
  }) : variables = variables ?? {};
}
