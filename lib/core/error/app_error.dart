sealed class AppError implements Exception {
  const AppError();

  String get userMessage;
}

final class NetworkError extends AppError {
  const NetworkError({
    this.message = 'No internet connection. Please check your network.',
  });

  final String message;

  @override
  String get userMessage => message;
}

final class ServerError extends AppError {
  const ServerError({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String get userMessage => message;
}

final class AuthError extends AppError {
  const AuthError({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String get userMessage => message;
}

final class ValidationError extends AppError {
  const ValidationError({required this.message});

  final String message;

  @override
  String get userMessage => message;
}

final class GenericError extends AppError {
  const GenericError({required this.stackTrace, this.cause});

  final StackTrace stackTrace;
  final Object? cause;

  @override
  String get userMessage => 'Something went wrong. Please try again.';
}
