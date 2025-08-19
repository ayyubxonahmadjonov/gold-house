import 'dart:convert';

import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/datasources/remote/http_inspector.dart';
import 'package:gold_house/data/models/http_result.dart';
import 'package:http/http.dart' as http;



class ApiService {
  ApiService._();
  static const String _baseUrl = "https://backkk.stroybazan1.uz/";

  static Map<String, String> _header() {
     final token = SharedPreferencesService.instance.getString("access");
   
   if(token != null){
      return {"Content-Type": "application/json", "Authorization": "Bearer $token"};
      
  
  }else{
    return {"Content-Type": "application/json"};
  }
  }

  //=====LOGIN=====
  static Future<HttpResult> login(String phone_number, ) async {
    var body = {"phone_number": phone_number,};

    return await _post("api/api/login/phone/", body: body);
  }
  static Future<HttpResult> loginVerify(String phone_number,  String verification_code) async {
    var body = {"phone_number": phone_number, "verification_code": verification_code};

    return await _post("api/api/login/phone/verify/", body: body);
  }

  static Future<HttpResult> registr(
    String phone_number,
  ) async {
    var body = {
      "phone_number": phone_number,
    };

    return await _post("api/api/register/", body: body);
  }
static Future<HttpResult> getAllCities() async {
    return await _get("api/api/cities/");
  }
  static Future<HttpResult> verify_otp(
    String phone_number,
    String otp_code,
    String otp_type,
  ) async {
    var body = {
      "phone_number": phone_number,
      "otp_code": otp_code,
      "otp_type": otp_type,
    };

    return await _post("api/api/verify-otp/", body: body);
  }

static Future<HttpResult> getProductsbyBranchId(String branch_id) async {
    return await _get("api/api/products/?branch=$branch_id",);
  }
  static Future<HttpResult> resetPasswordbyPhoneNumber(
    String phone_number,
  ) async {
    var body = {"phone_number": phone_number};

    return await _post("api/api/password-reset/", body: body);
  }
static Future<HttpResult> getBanners() async {
    return await _get("api/api/banners/");
  }
  static Future<HttpResult> setNewPassword(
    String reset_token,
    String new_password,
    String confirm_password,
  ) async {
    var body = {
      "reset_token": reset_token,
      "new_password": new_password,
      "confirm_password": confirm_password,
    };

    return await _post("api/api/password-reset/set-password/", body: body);
  }


  static Future<bool> refreshAccessToken() async {
     dynamic refreshToken = await SharedPreferencesService.instance.getString("refresh");

    Uri url = Uri.parse('$_baseUrl/api/api/token/refresh/');
    try {
      var response = await http
          .post(url, body: {"refresh": refreshToken})
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        print('result is succes in refreshAccessToken');
        final decoded = jsonDecode(response.body);
        final newAccess = decoded["access"];
        final newRefresh = decoded["refresh"] ?? "refreshToken";
        SharedPreferencesService.instance.saveString("access", newAccess);
        SharedPreferencesService.instance.saveString("refresh", newRefresh);



        return true;
      } else {
        /// Tokenlarni o'chiramiz


        /// SplashScreen ga redirect qilamiz
  

        return false;
      }
    } catch (e) {
      /// Tokenlarni o'chiramiz
      // await SharedPreferencesHelper().remove("access");
      // await SharedPreferencesHelper().remove("refresh");
      // await SharedPreferencesHelper().remove("user");

      /// SplashScreen ga redirect qilamiz
   

      return false;
    }
  }

  //=====GET ALL COURSES =====

  static Future<HttpResult> _post(
    String path, {
    Object? body,
    bool? isSecondHeader = false,
  }) async {
    Uri url = Uri.parse('$_baseUrl$path');
    try {
      http.Response response = await http
          .post(
            url,
            body: jsonEncode(body),
            headers:  _header(),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 401) {
        final isRefreshed = await refreshAccessToken();
        if (isRefreshed) {
          return await _post(path, body: body, isSecondHeader: isSecondHeader);
        }
      }

      HttpInspector.onResponse(response);

      var decoded = jsonDecode(response.body);
      return HttpResult(
        statusCode: response.statusCode,
        isSuccess: response.statusCode == 200 || response.statusCode == 201,
        result: decoded,
        path: path,
      );
    } catch (err) {
      return HttpResult(statusCode: -1, result: err, path: path);
    }
  }

static Future<HttpResult> _get(String path, {Map<String, dynamic>? query}) async {
  try {
    final url = Uri.parse('$_baseUrl$path');
    final response = await http
        .get(url, headers: _header())
        .timeout(const Duration(seconds: 30));


    if (response.statusCode == 401) {
      print('result is 401 in _get');
      final isRefreshed = await refreshAccessToken();
      if (isRefreshed) {
        return await _get(path, query: query);
      }
    }

    HttpInspector.onResponse(response);

    var decoded = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return HttpResult(statusCode: 200, isSuccess: true, result: decoded);
    }
    return HttpResult(
      statusCode: response.statusCode,
      result: decoded.toString(),
      path: path,
      method: 'GET',
    );
  } catch (err) {
    return HttpResult(statusCode: -1, result: err, path: path, method: 'GET');
  }
}

  static Future<HttpResult> _patch(String path, {Object? body}) async {
    Uri url = Uri.parse('$_baseUrl$path');

    try {
      http.Response response = await http
          .patch(url, body: jsonEncode(body), headers: _header())
          .timeout(const Duration(seconds: 30));
      HttpInspector.onResponse(response);
      var decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return HttpResult(
          statusCode: 200,
          isSuccess: true,
          result: decoded,
          method: 'PATCH',
          path: path,
        );
      }
      if (response.statusCode == 401) {
        // Unauthorized().onLogoutPresssed();
      }
      return HttpResult(
        statusCode: response.statusCode,
        result: decoded['message'].toString(),
        method: 'PATCH',
        path: path,
      );
    } catch (err) {
      return HttpResult(
        statusCode: -1,
        result: err,
        method: 'PATCH',
        path: path,
      );
    }
  }
}

class AppStrings2 {
  static const String INVALID_RESPONSE = 'Неверный ответ';
  static const String SOCKET_EXCEPTION = 'Нет соединения с интернетом';
  static const String FORMAT_ERROR = 'Неверный формат';
  static const String UNKNOWN_ERROR = 'Неизвестная ошибка';
  static const String TIMEOUT_EXCEPTION = 'Исключение тайм-аута';
  static const String HTTP_ERROR = 'HTTP-ошибка';
}
