import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'http_response.dart';

class HttpInspector {
  const HttpInspector._();
  static onResponse(http.Response response) {
    if (kDebugMode) {}
  }

  static final _streamController = StreamController<List<AppHttpResponse>>();
  static final stream = _streamController.stream.asBroadcastStream();
  static final List<AppHttpResponse> _responses = [];
  static List<AppHttpResponse> get responses => _responses.reversed.toList();

  static Map<String, int> getresponseCount() {
    int success = 0;
    int failure = 0;

    for (var response in _responses) {
      if (response.statusCode == 200) {
        success++;
      } else {
        failure++;
      }
    }
    return {'total': success + failure, 'success': success, 'failure': failure};
  }
}

class HttpInfo {}
