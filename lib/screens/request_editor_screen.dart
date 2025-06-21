import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_highlight/flutter_highlight.dart';
import '../models/request_model.dart';
import '../providers/request_providers.dart';
import '../services/http_service.dart';

class RequestEditorScreen extends ConsumerStatefulWidget {
  final RequestModel? request;
  const RequestEditorScreen({Key? key, this.request}) : super(key: key);

  @override
  ConsumerState<RequestEditorScreen> createState() => _RequestEditorScreenState();
}

class _RequestEditorScreenState extends ConsumerState<RequestEditorScreen> {
  final _urlController = TextEditingController();
  final _bodyController = TextEditingController();
  String _method = 'GET';
  final List<MapEntry<TextEditingController, TextEditingController>> _headers = [];

  Response<dynamic>? _response;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.request != null) {
      final r = widget.request!;
      _urlController.text = r.url;
      _bodyController.text = r.body;
      _method = r.method;
      r.headers.forEach((key, value) {
        _headers.add(MapEntry(TextEditingController(text: key), TextEditingController(text: value)));
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _bodyController.dispose();
    for (var pair in _headers) {
      pair.key.dispose();
      pair.value.dispose();
    }
    super.dispose();
  }

  void _send() async {
    setState(() { _loading = true; });
    final http = ref.read(httpServiceProvider);
    final headers = {for (var pair in _headers) pair.key.text: pair.value.text};
    final options = RequestOptions(
      path: _urlController.text,
      method: _method,
      headers: headers,
      data: _bodyController.text.isNotEmpty ? _bodyController.text : null,
    );
    try {
      final resp = await http.sendRequest(options);
      setState(() => _response = resp);
    } catch (e) {
      setState(() => _response = Response(requestOptions: options, statusCode: 500, statusMessage: e.toString()));
    } finally {
      setState(() { _loading = false; });
    }
  }

  void _saveRequest() {
    final id = widget.request?.id ?? const Uuid().v4();
    final req = RequestModel(
      id: id,
      name: widget.request?.name ?? 'Request $id',
      url: _urlController.text,
      method: _method,
      headers: {for (var pair in _headers) pair.key.text: pair.value.text},
      body: _bodyController.text,
    );
    if (widget.request == null) {
      ref.read(requestListProvider.notifier).add(req);
    } else {
      ref.read(requestListProvider.notifier).updateReq(req);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.request?.name ?? 'Nuevo Request'),
        actions: [
          IconButton(onPressed: _saveRequest, icon: Icon(Icons.save)),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: 'URL'),
                ),
                DropdownButton<String>(
                  value: _method,
                  items: ['GET','POST','PUT','DELETE','PATCH']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _method = v!),
                ),
                const SizedBox(height: 8),
                Text('Headers'),
                Column(
                  children: [
                    for (var pair in _headers)
                      Row(
                        children: [
                          Expanded(child: TextField(controller: pair.key, decoration: const InputDecoration(hintText: 'Key'))),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(controller: pair.value, decoration: const InputDecoration(hintText: 'Value'))),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () { setState(() { _headers.remove(pair); }); }),
                        ],
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() { _headers.add(MapEntry(TextEditingController(), TextEditingController())); });
                      },
                      child: const Text('Agregar Header'),
                    ),
                  ],
                ),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: 'Body (JSON)'),
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _send,
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _response == null ? const Center(child: Text('Sin respuesta')) : _buildResponse(),
          ),
        ],
      ),
    );
  }

  Widget _buildResponse() {
    final resp = _response!;
    final headers = resp.headers.map.map((k, v) => MapEntry(k, v.join(',')));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status: ${resp.statusCode}'),
          const SizedBox(height: 4),
          Text('Headers:'),
          for (var entry in headers.entries) Text('${entry.key}: ${entry.value}'),
          const Divider(),
          const Text('Body:'),
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            child: HighlightView(
              resp.data.toString(),
              language: 'json',
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}
