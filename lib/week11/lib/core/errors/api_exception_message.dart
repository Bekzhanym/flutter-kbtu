import 'api_exception.dart';

extension ApiExceptionMessage on ApiException {
  String get message => switch (this) {
    NoConnectionException() => 'No connection. Check the network.',
    ServerException(:final status) => 'Server error ($status). Try again.',
    NotFoundException() => 'Not found.',
    UnauthorizedException() => 'You are not allowed to do this.',
    BadResponseException() => 'The server sent data we could not read.',
  };
}
