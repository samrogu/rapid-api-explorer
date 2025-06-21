import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/request_model.dart';

final requestsBoxProvider = Provider<Box<RequestModel>>((ref) {
  return Hive.box<RequestModel>('requests');
});

class RequestListNotifier extends StateNotifier<List<RequestModel>> {
  final Box<RequestModel> box;
  RequestListNotifier(this.box) : super(box.values.toList());

  void add(RequestModel req) {
    box.put(req.id, req);
    state = box.values.toList();
  }

  void remove(String id) {
    box.delete(id);
    state = box.values.toList();
  }

  void updateReq(RequestModel req) {
    box.put(req.id, req);
    state = box.values.toList();
  }
}

final requestListProvider =
    StateNotifierProvider<RequestListNotifier, List<RequestModel>>((ref) {
  final box = ref.watch(requestsBoxProvider);
  return RequestListNotifier(box);
});
