import 'package:dio/dio.dart';

String dioErrorHandler(Response response) {
  final statusCode = response.statusCode;
  final statusMessage = response.statusMessage;

  final String errorMessage =
      'Request failed\n\nStatus code: $statusCode\nReason: $statusMessage';

  print("ERROR MESSAGE DIO ERROR HANDLER $errorMessage");

  return errorMessage;
}
