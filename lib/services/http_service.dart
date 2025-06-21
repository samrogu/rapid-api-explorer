import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/environment_model.dart';
import '../providers/environment_providers.dart';

final httpServiceProvider = Provider<HttpService>((ref) {
  return HttpService(ref);
});

class HttpService {
  final Ref ref;
  final Dio dio = Dio();

  HttpService(this.ref) {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final env = ref.read(activeEnvironmentProvider).maybeWhen(
            data: (env) => env,
            orElse: () => null,
          );
      if (env != null) {
        options.path = _interpolate(options.path, env.variables);
        options.headers = options.headers.map((k, v) => MapEntry(k, _interpolate('$v', env.variables)));
        if (options.data is String) {
          options.data = _interpolate(options.data, env.variables);
        }
      }
      handler.next(options);
    }));
  }

  Future<Response> sendRequest(RequestOptions options) {
    return dio.fetch(options);
  }

  String _interpolate(String input, Map<String, String> vars) {
    var result = input;
    vars.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value);
    });
    return result;
  }
}
