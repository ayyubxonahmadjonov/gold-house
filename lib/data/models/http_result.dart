import 'dart:async';
import 'dart:io';

import 'package:gold_house/data/datasources/remote/api_service.dart';


class HttpResult {
  bool isSuccess;
  int statusCode;
  dynamic result;
  String path;
  String method;
  HttpResult({
    required this.statusCode,
    required this.result,
    this.isSuccess = false,
    this.path = '/',
    this.method = 'POST',
  }) {
    if (isSuccess) return;
    if (result is SocketException) return;
    if (result is TimeoutException) return;
    if (path.contains('/seen_news')) return;
    if (statusCode == 1000) return;

    String error;
    if (result is HttpException) {
      error = AppStrings2.HTTP_ERROR;
    } else if (result is FormatException) {
      error = AppStrings2.FORMAT_ERROR;
    } else {
      error = result.toString();
    }

    // Via this function, errors that occur with the API are saved.
    // LogHelper.addLog(
    //   error,
    //   path: path.replaceAll('&', ''),
    //   file: 'http_result',
    //   method: method,
    //   statusCode: statusCode,
    // );
  }

  // Simple way to get a data
  dynamic getData() {
    if (isSuccess) {
      return result;
    }

    if (result is SocketException) {
      return AppStrings2.SOCKET_EXCEPTION;
    } else if (result is TimeoutException) {
      return AppStrings2.TIMEOUT_EXCEPTION;
    } else if (result is HttpException) {
      return AppStrings2.HTTP_ERROR;
    } else if (result is FormatException) {
      return AppStrings2.FORMAT_ERROR;
    } else {
      return AppStrings2.UNKNOWN_ERROR;
    }
  }
}
