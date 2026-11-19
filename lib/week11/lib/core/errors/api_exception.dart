sealed class ApiException implements Exception {
  const ApiException();
}

final class NoConnectionException extends ApiException {
  const NoConnectionException();
}

final class ServerException extends ApiException {
  const ServerException(this.status);
  final int status;
}

final class NotFoundException extends ApiException {
  const NotFoundException();
}

final class UnauthorizedException extends ApiException {
  const UnauthorizedException();
}

final class BadResponseException extends ApiException {
  const BadResponseException([this.detail]);
  final String? detail;

  @override
  String toString() => 'BadResponseException($detail)';
}
