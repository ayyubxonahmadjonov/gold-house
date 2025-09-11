import 'dart:convert';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/datasources/remote/http_inspector.dart';
import 'package:gold_house/data/models/http_result.dart';
import 'package:gold_house/main.dart';
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
static Future<HttpResult> getProductbyId(String product_id) async {
    return await _get("api/api/products/$product_id/",);
  }
static Future<HttpResult> getCategories() async {
    return await _get("api/api/categories/");
  }
static Future<HttpResult> getBanners() async {
    return await _get("api/api/banners/");
  }
static Future<HttpResult> getRegions (){
return _get("api/api/regions/");
}
static Future<HttpResult> createCreditforUser(String phone_number,String passportId,String birth_date,String pinfl){
return _post("pay/api/goldhouse/create/", body: {
  "pinfl": pinfl,
  "birth_date": birth_date,
  "pass_data": passportId,
  "phone": phone_number,
});
}
static Future<HttpResult> getUserAgreements() {
return _get("api/api/user-agreements/");
}
  static Future<HttpResult> getBranches (){
return _get("api/branches/");
}
  static Future<HttpResult> getUserData(String id) async {
    return  _get("api/api/users/$id/");  
  }
  static Future<bool> refreshAccessToken() async {
     dynamic refreshToken = await SharedPreferencesService.instance.getString("refresh");
    Uri url = Uri.parse('$_baseUrl/api/api/token/refresh/');
    try {
      var response = await http
          .post(url, body: {"refresh": refreshToken})
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final newAccess = decoded["access"];
        SharedPreferencesService.instance.saveString("access", newAccess);
        return true;

      } else {

        await SharedPreferencesService.instance.remove("access");
        await SharedPreferencesService.instance.remove("refresh");
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => SignUpScreen()),
          (route) => false,
        );

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
static Future<HttpResult> getMyOrders(

  ) async {
  final result = await _get("api/api/orders/my/",);
  if(result.isSuccess){
    return result;
  }
  return result;
  }
 static Future<HttpResult> createOrder(
  List<int> productId,
  List<int> variantId,
  List<int> quantity,
  String deliveryAddress,
  String paymentMethod,
  bool useCashback,
  int branchId,
  int part,
  String status,
  String deliveryMethod,
) async {
  
  List<Map<String, dynamic>> cartItems = [];
  for (int i = 0; i < productId.length; i++) {
    cartItems.add({
      "product_id": productId[i],
      "variant_id": variantId[i],
      "quantity": quantity[i],
    });
  }

  return await _post("api/api/order/create/", body: {
    "cart_items": cartItems,
    "delivery_address": deliveryAddress,
    "payment_method": paymentMethod,
    "use_cashback": useCashback,
    "branch_id": branchId,
    "part": part,
    "status": status,
    "delivery_method": deliveryMethod,
  });
}
static Future<http.Response> updatePayment(int orderId, String paymentMethod) async {
  final url = Uri.parse("${_baseUrl}pay/api/orders/$orderId/payment/");


  final response = await http.put(
    url,
  headers: _header(),
    body: jsonEncode({"payment_method": paymentMethod}),
  );

  return response;
}
static Future<http.Response> updateUser(String firstname, String lastname, String userid) async {
  final url = Uri.parse("${_baseUrl}api/api/users/$userid/update/");


  final response = await http.put(
    url,
  headers: _header(),
    body: jsonEncode({
  "first_name": firstname,
  "last_name": lastname
}),
  );

  return response;
}
  static Future<HttpResult> _post(
    String path, {
    Object? body,

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
          return await _post(path, body: body,);
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

  static Future<HttpResult> _get(String path) async {
    Uri url;
    url = Uri.parse('$_baseUrl$path');
    try {
      http.Response response = await http
          .get(url, headers: _header())
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 401) {
        final isRefreshed = await refreshAccessToken();
        if (isRefreshed) {
          return await _get(path);
        }
      }

      HttpInspector.onResponse(response);

      var decoded = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return HttpResult(statusCode: 200, isSuccess: true, result: decoded);
      } else {}
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
