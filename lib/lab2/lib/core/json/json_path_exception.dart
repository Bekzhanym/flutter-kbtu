class JsonPathException implements Exception {
  const JsonPathException(this.path, this.detail);

  final String path;
  final String detail;

  JsonPathException under(String parent) {
    if (path.isEmpty) return JsonPathException(parent, detail);
    final sep = path.startsWith('[') ? '' : '.';
    return JsonPathException('$parent$sep$path', detail);
  }

  @override
  String toString() => '$path: $detail';
}
