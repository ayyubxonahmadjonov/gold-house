import 'package:http/http.dart' as http;

class AppHttpResponse {
  final int id = 0;
  String? _url;
  String? _path;
  String? _method;
  String? _body;
  int _statusCode = 0;
  int _size = 0;
  DateTime _time = DateTime.now();
  Map<String, String>? _headers;

  int get getId => id;

  String? get url => _url;

  String? get path => _path;

  String? get method => _method;

  String? get body => _body;

  int get statusCode => _statusCode;

  int get size => _size;

  DateTime get time => _time;

  Map<String, String>? get getHeaders => _headers;

  AppHttpResponse.fromResponse(http.Response response) {
    http.BaseRequest? request = response.request;
    Uri? url = request?.url;
    _url = url?.authority;
    _path = url?.path;
    _body = response.body;
    _method = request?.method;
    _size = response.contentLength ?? 0;
    _statusCode = response.statusCode;
    _headers = request?.headers;
    _time = DateTime.now();
  }
}
