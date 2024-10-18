class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class NetworkException extends AuthException {
  NetworkException(String message) : super(message);
}

class ServerException extends AuthException {
  ServerException(String message) : super(message);
}
