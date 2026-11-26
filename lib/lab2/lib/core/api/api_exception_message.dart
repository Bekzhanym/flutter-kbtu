import 'package:trip_planner/core/api/api_exception.dart';

extension ApiExceptionMessage on ApiException {
  String get message => switch (this) {
    NoConnectionException() => 'No connection. Check the network.',
    UnauthorizedException() => 'You are signed out or the key is wrong.',
    NotFoundException() => 'Not found.',
    ClientErrorException(:final status) => 'The request was refused ($status).',
    ServerException(:final status) => 'Server error ($status). Try again.',
    BadResponseException() => 'The server sent data we could not read.',
  };
}
