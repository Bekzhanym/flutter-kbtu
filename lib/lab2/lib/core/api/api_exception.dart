sealed class ApiException implements Exception {
  const ApiException();
}

final class NoConnectionException extends ApiException {
  const NoConnectionException();
}

final class UnauthorizedException extends ApiException {
  const UnauthorizedException();
}

final class NotFoundException extends ApiException {
  const NotFoundException();
}

final class ClientErrorException extends ApiException {
  const ClientErrorException(this.status, [this.detail]);
  final int status;
  final String? detail;

  @override
  String toString() => 'ClientErrorException($status, $detail)';
}

final class ServerException extends ApiException {
  const ServerException(this.status);
  final int status;

  @override
  String toString() => 'ServerException($status)';
}

final class BadResponseException extends ApiException {
  const BadResponseException([this.detail]);
  final String? detail;

  @override
  String toString() => 'BadResponseException($detail)';
}
