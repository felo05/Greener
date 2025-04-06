import 'dart:io';

import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
            'Connection timeout with the server.');
      case DioExceptionType.sendTimeout:
        return const ServerFailure('Connection timeout with the server.');
      case DioExceptionType.connectionError:
        return const ServerFailure('Send timeout with the server.');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
            'Receive timeout with the server.');
      case DioExceptionType.badResponse:
        final response = dioError.response;
        final statusCode = response?.statusCode;
        return (statusCode != null) ?
        ServerFailure._fromResponse(
            statusCode, response?.data) :

        const ServerFailure('Received invalid response from the server.');

      case DioExceptionType.cancel:
        return const ServerFailure('Request to the server was canceled.');
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return const ServerFailure('No internet connection.');
        }
        return const ServerFailure('An unexpected error occurred. Please try again!');
      default:
        return const ServerFailure('Oops! An error occurred. Please try again.');
    }
  }

  factory ServerFailure._fromResponse(int? statusCode, dynamic response) {
    if (response is Map<String, dynamic> ) {
      final message = response['message'];
      if (message != null) {
        return ServerFailure(message.toString());
      }
    }

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return const ServerFailure(
            'Authentication or authorization error. Please try again.');
      case 404:
        return const ServerFailure('The requested resource was not found.');
      case 500:
        return const ServerFailure('Internal server error. Please try again later.');
      default:
        return const ServerFailure('Unexpected server error. Please try again.');
    }
  }
}

