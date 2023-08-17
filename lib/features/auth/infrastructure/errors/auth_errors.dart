class WrongCredentials implements Exception {}

class InvalidToke implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomErrorMessage implements Exception {
  final String message;
  final int errorCode;

  CustomErrorMessage(this.message, this.errorCode);
}
