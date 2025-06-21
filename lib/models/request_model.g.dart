// GENERATED CODE - MANUAL ADAPTER

import 'package:hive/hive.dart';
import 'request_model.dart';

class RequestModelAdapter extends TypeAdapter<RequestModel> {
  @override
  final int typeId = 0;

  @override
  RequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return RequestModel(
      id: fields[0] as String,
      name: fields[1] as String,
      url: fields[2] as String,
      method: fields[3] as String,
      headers: (fields[4] as Map?)?.cast<String, String>(),
      body: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RequestModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.method)
      ..writeByte(4)
      ..write(obj.headers)
      ..writeByte(5)
      ..write(obj.body);
  }
}
