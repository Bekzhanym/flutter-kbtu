import 'package:trip_planner/core/json/json_path_exception.dart';

extension JsonRead on Map<String, dynamic> {
  T req<T extends Object>(String key) {
    final v = this[key];
    if (v is T) return v;
    throw JsonPathException(key, 'expected $T, got ${_type(v)}');
  }

  T? opt<T extends Object>(String key) {
    final v = this[key];
    if (v == null) return null;
    if (v is T) return v;
    throw JsonPathException(key, 'expected $T or null, got ${_type(v)}');
  }

  double dbl(String key) => req<num>(key).toDouble();
  int integer(String key) => req<num>(key).toInt();

  DateTime date(String key) {
    final s = req<String>(key);
    return DateTime.tryParse(s) ??
        (throw JsonPathException(key, '"$s" is not a date'));
  }

  T obj<T>(String key, T Function(Map<String, dynamic> json) parse) {
    final m = req<Map<String, dynamic>>(key);
    return _under(key, () => parse(m));
  }

  T? optObj<T>(String key, T Function(Map<String, dynamic> json) parse) {
    final m = opt<Map<String, dynamic>>(key);
    return m == null ? null : _under(key, () => parse(m));
  }

  List<T> list<T>(String key, T Function(Object? item) parse) {
    final raw = req<List<dynamic>>(key);
    return _under(key, () {
      return [
        for (var i = 0; i < raw.length; i++)
          _under('[$i]', () => parse(raw[i])),
      ];
    });
  }

  List<String> strings(String key) => list(key, (e) {
    if (e is String) return e;
    throw JsonPathException('', 'expected String, got ${_type(e)}');
  });
}

Map<String, dynamic> asObject(Object? e) {
  if (e is Map<String, dynamic>) return e;
  throw JsonPathException('', 'expected an object, got ${_type(e)}');
}

R _under<R>(String parent, R Function() read) {
  try {
    return read();
  } on JsonPathException catch (e) {
    throw e.under(parent);
  }
}

String _type(Object? v) => v == null ? 'null' : '${v.runtimeType}';
