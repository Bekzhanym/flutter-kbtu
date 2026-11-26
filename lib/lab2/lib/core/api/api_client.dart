import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/core/api/api_exception.dart';

export 'package:http/http.dart' show Client;

class ApiClient {
  ApiClient(
    this._client, {
    required this.host,
    this.basePath = '',
    this.fixedQuery = const {},
    this.timeout = defaultTimeout,
  });

  static const Duration defaultTimeout = Duration(seconds: 10);

  final http.Client _client;
  final String host;
  final String basePath;
  final Map<String, String> fixedQuery;
  final Duration timeout;

  Map<String, String> get _headers => const {'Accept': 'application/json'};

  Map<String, String> get _jsonHeaders => const {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Uri uri(String path, [Map<String, String>? query]) {
    final q = {...fixedQuery, ...?query};
    return Uri.https(host, '$basePath$path', q.isEmpty ? null : q);
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final r = await _send(
      'GET',
      () => _client.get(uri(path, query), headers: _headers),
    );
    _check(r, const {200});
    return _decode(r);
  }

  Future<dynamic> post(String path, Object body) async {
    final r = await _send(
      'POST',
      () => _client.post(
        uri(path),
        headers: _jsonHeaders,
        body: jsonEncode(body),
      ),
    );
    _check(r, const {201});
    return _decode(r);
  }

  Future<dynamic> put(String path, Object body) async {
    final r = await _send(
      'PUT',
      () =>
          _client.put(uri(path), headers: _jsonHeaders, body: jsonEncode(body)),
    );
    _check(r, const {200});
    return _decode(r);
  }

  Future<void> delete(String path) async {
    final r = await _send(
      'DELETE',
      () => _client.delete(uri(path), headers: _headers),
    );
    _check(r, const {200, 204});
  }

  Future<http.Response> _send(
    String method,
    Future<http.Response> Function() call,
  ) async {
    final watch = Stopwatch()..start();
    try {
      final r = await call().timeout(timeout);
      _log(method, r.request?.url.path, r.statusCode, watch);
      return r;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void _log(String method, String? path, int status, Stopwatch watch) {
    if (!kDebugMode) return;
    log(
      '$method $path → $status (${watch.elapsedMilliseconds} ms)',
      name: 'api',
    );
  }

  void _check(http.Response r, Set<int> expect) {
    final s = r.statusCode;
    if (expect.contains(s)) return;
    if (s == 401) throw const UnauthorizedException();
    if (s == 404) throw const NotFoundException();
    if (s >= 400 && s < 500) throw ClientErrorException(s, _serverMessage(r));
    if (s >= 500) throw ServerException(s);
    throw BadResponseException('${r.request?.url.path}: status $s');
  }

  String? _serverMessage(http.Response r) {
    try {
      final body = jsonDecode(utf8.decode(r.bodyBytes));
      if (body case {'errors': [{'message': final String m}, ...]}) return m;
      if (body is String) return body;
      return null;
    } on FormatException {
      return null;
    }
  }

  dynamic _decode(http.Response r) {
    if (r.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } on FormatException catch (e) {
      throw BadResponseException('${r.request?.url.path}: ${e.message}');
    }
  }
}
