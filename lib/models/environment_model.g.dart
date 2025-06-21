// GENERATED CODE - MANUAL ADAPTER

import 'package:hive/hive.dart';
import 'environment_model.dart';

class EnvironmentModelAdapter extends TypeAdapter<EnvironmentModel> {
  @override
  final int typeId = 1;

  @override
  EnvironmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return EnvironmentModel(
      id: fields[0] as String,
      name: fields[1] as String,
      variables: (fields[2] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EnvironmentModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.variables);
  }
}
