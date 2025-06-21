import 'package:hive/hive.dart';

part 'request_model.g.dart';

@HiveType(typeId: 0)
class RequestModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String url;

  @HiveField(3)
  String method;

  @HiveField(4)
  Map<String, String> headers;

  @HiveField(5)
  String body;

  RequestModel({
    required this.id,
    required this.name,
    required this.url,
    required this.method,
    Map<String, String>? headers,
    this.body = '',
  }) : headers = headers ?? {};
}
