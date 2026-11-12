import 'package:flutter/foundation.dart';

import '../models/student.dart';

class NoConnectionException implements Exception {}

class FakeApi {
  FakeApi({this.empty = false});
  final bool empty;
  int calls = 0;

  static int _saveCalls = 0;

  @visibleForTesting
  static void resetSaves() => _saveCalls = 0;

  Future<List<Student>> fetchStudents() async {
    calls++;
    debugPrint('fetchStudents #$calls');
    await Future<void>.delayed(const Duration(seconds: 2));
    if (calls % 3 == 0) throw NoConnectionException();
    return empty ? const [] : seedStudents;
  }

  Future<void> save(int value) async {
    _saveCalls++;
    await Future<void>.delayed(const Duration(seconds: 1));
    if (_saveCalls % 2 == 0) throw StateError('server rejected $value');
  }
}
