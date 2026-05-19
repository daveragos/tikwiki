import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tikwiki/core/error/app_error.dart';

final class AppErrorParser {
  const AppErrorParser._();

  /// Single entry point: pass any caught error + stack trace,
  /// get back a typed [AppError].
  static AppError parse(Object error, StackTrace stackTrace) {
    if (error is SocketException) {
      return const NetworkError();
    }

    if (error is FirebaseAuthException) {
      return _parseFirebaseAuthException(error);
    }

    if (error is DioException) {
      return _parseDioException(error);
    }

    return GenericError(stackTrace: stackTrace, cause: error);
  }

  static AppError _parseFirebaseAuthException(FirebaseAuthException error) {
    final message = switch (error.code) {
      'invalid-email' => 'The email address is badly formatted.',
      'user-disabled' => 'This user account has been disabled.',
      'user-not-found' => 'No user found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'The password provided is too weak.',
      'operation-not-allowed' => 'This authentication method is not enabled.',
      'invalid-credential' =>
        'Invalid credentials. Please verify your email and password.',
      'channel-error' =>
        'Authentication channel error. Please fill in all fields.',
      _ => error.message ?? 'An unexpected authentication error occurred.',
    };

    return AuthError(message: message, code: error.code);
  }

  static AppError _parseDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkError();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final data = error.response?.data;
        final message = _extractMessage(data) ?? _fallbackForCode(statusCode);
        return ServerError(statusCode: statusCode, message: message);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return GenericError(stackTrace: error.stackTrace, cause: error);
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }

      final error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    return null;
  }

  static String _fallbackForCode(int code) => switch (code) {
    400 => 'Bad request.',
    401 => 'Session expired. Please log in again.',
    403 => 'You do not have permission to do that.',
    404 => 'Resource not found.',
    429 => 'Too many requests. Please slow down.',
    >= 500 => 'Server error. Please try again later.',
    _ => 'An unexpected error occurred.',
  };
}
