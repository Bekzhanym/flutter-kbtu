import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../errors/api_exception.dart';
import '../storage/secure_store.dart';

export 'package:http/http.dart' show Client;

class ApiClient {
  ApiClient(this._client, this._store, {this.host = AppConstants.apiHost});

  final http.Client _client;
  final SecureStore _store;
  final String host;

  Future<Map<String, String>> _headers({bool json = false}) async => {
    'Accept': 'application/json',
    if (json) 'Content-Type': 'application/json',
    if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
  };

  Uri uri(String path, [Map<String, String>? query]) =>
      Uri.https(host, path, query);

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final headers = await _headers();
    final r = await _send(
      () => _client.get(uri(path, query), headers: headers),
    );
    _check(r, 200);
    return _decode(r);
  }

  Future<dynamic> post(String path, Object body, {int expect = 201}) async {
    final headers = await _headers(json: true);
    final r = await _send(
      () => _client.post(uri(path), headers: headers, body: jsonEncode(body)),
    );
    _check(r, expect);
    return _decode(r);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final r = await call().timeout(AppConstants.requestTimeout);
      if (kDebugMode) {
        log(
          '${r.request?.method} ${r.request?.url.path} → ${r.statusCode}',
          name: 'api',
        );
      }
      return r;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response r, int expect) {
    final s = r.statusCode;
    if (s == 401) throw const UnauthorizedException();
    if (s == 404) throw const NotFoundException();
    if (s >= 500) throw ServerException(s);
    if (s != expect) {
      throw BadResponseException('${r.request?.url.path}: status $s');
    }
  }

  dynamic _decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException('${r.request?.url.path}: ${e.message}');
    }
  }
}
