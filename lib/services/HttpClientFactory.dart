import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/helper/TokenParser.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:applicationecommerce/view_models/Users/LoginResponse.dart';
import 'package:applicationecommerce/view_models/Users/RefreshTokenRequest.dart';
import 'package:applicationecommerce/view_models/commons/ApiResult.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class HttpClientFactory {
  IOClientWrapper createIOClientWrapper() {
    // ..badCertificateCallback =
    //     ((X509Certificate cert, String host, int port) {
    //   return true;
    // });
    try {
      var client = IOClientWrapper();
      return client;
    } catch (e) {
      print(e.toString());
    }
    return IOClientWrapper();
  }
}

class IOClientWrapper {
  late final IOClient _ioClient;

  Future<ApiResult<LoginResponse>> refreshToken() async {
    if (UserServices.RefreshToken == null ||
        UserServices.RefreshTokenExpire == null ||
        UserServices.RefreshTokenExpire!.compareTo(DateTime.now().toUtc()) <
            0) {
      return ApiResult.failedApiResult("Invalid token");
    }
    RefreshTokenRequest refreshTokenRequest =
        RefreshTokenRequest(UserServices.JWT!, UserServices.RefreshToken!);

    log("RefreshTokenRequest ${jsonEncode(refreshTokenRequest.toJson())}");

    Response? response;
    try {
      response = await _ioClient.post(
          Uri.parse('${AppConfigs.URL_UserRouteAPI}/RefreshToken'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(refreshTokenRequest));
    } catch (e) {
      return ApiResult<LoginResponse>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<LoginResponse>.fromJson(
          json, (a) => LoginResponse.fromJson(a as Map<String, dynamic>));
      if (result.isSuccessed == true) {
        log("Refresh token succesed!");
        log("Login response: ${result.payLoad!.toJson()}");
        UserServices.JWT = result.payLoad!.accessToken;
        UserServices.RefreshToken = result.payLoad!.refreshToken;
        UserServices.RefreshTokenExpire = result.payLoad!.refreshTokenExpire;
        UserServices.PayloadMap = parseJWT(result.payLoad!.accessToken);
        print(UserServices.PayloadMap);
        return result;
      } else {
        return result;
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  IOClientWrapper() {
    HttpClient httpClient = HttpClient();
    _ioClient = IOClient(httpClient);
  }

  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    var response = await _ioClient.get(url, headers: headers);
    if (response.statusCode == HttpStatus.unauthorized) {
      var result = await refreshToken();
      if (result.isSuccessed) {
        headers!.update('Authorization', (value) {
          return 'Bearer ${UserServices.JWT!}';
        });
        return await _ioClient.get(url, headers: headers);
      }
    }
    return response;
  }

  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var response = await _ioClient.post(url,
        headers: headers, body: body, encoding: encoding);
    if (response.statusCode == HttpStatus.unauthorized) {
      var result = await refreshToken();
      if (result.isSuccessed) {
        headers!.update('Authorization', (value) {
          return 'Bearer ${UserServices.JWT!}';
        });
        return await _ioClient.get(url, headers: headers);
      }
    }
    return response;
  }

  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var response = await _ioClient.put(url,
        headers: headers, body: body, encoding: encoding);
    if (response.statusCode == HttpStatus.unauthorized) {
      var result = await refreshToken();
      if (result.isSuccessed) {
        headers!.update('Authorization', (value) {
          return 'Bearer ${UserServices.JWT!}';
        });
        return await _ioClient.get(url, headers: headers);
      }
    }
    return response;
  }

  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var response = await _ioClient.delete(url,
        headers: headers, body: body, encoding: encoding);
    if (response.statusCode == HttpStatus.unauthorized) {
      var result = await refreshToken();
      if (result.isSuccessed) {
        headers!.update('Authorization', (value) {
          return 'Bearer ${UserServices.JWT!}';
        });
        return await _ioClient.get(url, headers: headers);
      }
    }
    return response;
  }
}
