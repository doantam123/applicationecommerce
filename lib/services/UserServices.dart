import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/helper/TokenParser.dart';
import 'package:applicationecommerce/services/FileServices.dart';
import 'package:applicationecommerce/services/HttpClientFactory.dart';
import 'package:applicationecommerce/view_models/Users/ChangePasswordVM.dart';
import 'package:applicationecommerce/view_models/Users/LoginResponse.dart';
import 'package:applicationecommerce/view_models/Users/LoginVM.dart';
import 'package:applicationecommerce/view_models/Users/RegisterRequest.dart';
import 'package:applicationecommerce/view_models/Users/ResetPasswordVM.dart';
import 'package:applicationecommerce/view_models/Users/UserEditVM.dart';
import 'package:applicationecommerce/view_models/Users/UserVM.dart';
import 'package:applicationecommerce/view_models/commons/ApiResult.dart';
import 'package:http/http.dart';

class UserServices {
  static String? JWT;
  static Map<String, dynamic> PayloadMap = {};
  static String? RefreshToken;
  static DateTime? RefreshTokenExpire;
  final String baseRoute = AppConfigs.URL_UserRouteAPI;
  final HttpClientFactory _httpClientFactory = HttpClientFactory();
  final String _userAccountFilename = "/Data.txt";

  UserServices();

  String? get deviceToken => null;

  static String getUserID() {
    return PayloadMap["UserID"];
  }

  static String getUsername() {
    return PayloadMap[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
  }

  Future<ApiResult<Map<String, dynamic>>> getUserAccountFromCache() async {
    try {
      final FileServices fileServices = FileServices();
      String cachePath = await fileServices.cachePath;
      String fullFilePath = cachePath + _userAccountFilename;
      File file = File(fullFilePath);
      String fileContent = await file.readAsString();
      dynamic json = jsonDecode(fileContent);
      log("loaded user from cache: $json");
      return ApiResult.succesedApiResult(json);
    } catch (e) {
      log("Failed to read useraccount form cache $e");
      return ApiResult.failedApiResult(
          "Failed to read useraccount form cache $e");
    }
  }

  Future<ApiResult<void>> saveUserAccountToCache(
      String username, String password) async {
    try {
      final FileServices fileServices = FileServices();
      String cachePath = await fileServices.cachePath;
      String fullFilePath = cachePath + _userAccountFilename;

      Map<String, String> map = <String, String>{};
      map["username"] = username;
      map["password"] = password;
      var json = jsonEncode(map);

      File file = File(fullFilePath);
      await file.writeAsString(json, mode: FileMode.write);

      log("Saved user to cache: $json");
      return ApiResult.succesedApiResult(json);
    } catch (e) {
      log("Failed to save useraccount to cache $e");
      return ApiResult.failedApiResult(
          "Failed to save useraccount to cache $e");
    }
  }

  Future<ApiResult<void>> removeUserAccountFromCache() async {
    try {
      final FileServices fileServices = FileServices();
      String cachePath = await fileServices.cachePath;
      String fullFilePath = cachePath + _userAccountFilename;

      File file = File(fullFilePath);
      await file.delete();
      return ApiResult.succesedApiResult(true);
    } catch (e) {
      log("Failed to delete useraccount from cache $e");
      return ApiResult.failedApiResult(
          "Failed to delete useraccount from cache$e");
    }
  }

  Future<ApiResult<bool>> logout() async {
    JWT = "";
    PayloadMap = {};
    var rs = await removeUserAccountFromCache();
    if (rs.isSuccessed == true) {
      return ApiResult.succesedApiResult(true);
    }
    return ApiResult.failedApiResult(rs.errorMessage!);
  }

  Future<ApiResult<bool>> login(LoginVM loginVM) async {
    saveUserAccountToCache(loginVM.username!, loginVM.password!);
    loginVM.deviceToken = deviceToken;
    log("LoginVM ${jsonEncode(loginVM.toJson())}");
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    Response? response;
    try {
      response = await ioClient.post(Uri.parse('$baseRoute/Login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(loginVM));
    } catch (e) {
      return ApiResult<bool>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<LoginResponse>.fromJson(
          json, (a) => LoginResponse.fromJson(a as Map<String, dynamic>));
      if (result.isSuccessed == true) {
        log("Signin succesed!");
        log("Login response: ${result.payLoad!.toJson()}");
        JWT = result.payLoad!.accessToken;
        RefreshToken = result.payLoad!.refreshToken;
        RefreshTokenExpire = result.payLoad!.refreshTokenExpire;
        PayloadMap = parseJWT(result.payLoad!.accessToken);
        print(PayloadMap);
        return ApiResult.succesedApiResult(true);
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  Future<ApiResult<bool>> register(RegisterRequest request) async {
    //saveUserAccountToCache(loginVM.username!, loginVM.password!);

    log("RegisterRequest ${jsonEncode(request.toJson())}");
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    Response? response;
    try {
      response = await ioClient.post(Uri.parse('$baseRoute/Register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(request));
    } catch (e) {
      return ApiResult<bool>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<String>.fromJson(json, (a) => a.toString());
      if (result.isSuccessed == true) {
        log("User created !");
        //log("JWT: " + result.payLoad!);
        //JWT = result.payLoad;
        // PayloadMap = parseJWT(result.payLoad!);
        //print(PayloadMap);
        return ApiResult.succesedApiResult(true);
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  Future<ApiResult<bool>> resetPassword(ResetPasswordVM request) async {
    //saveUserAccountToCache(loginVM.username!, loginVM.password!);

    log("ChangePasswordVM ${jsonEncode(request.toJson())}");
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    Response? response;
    try {
      response = await ioClient.post(Uri.parse('$baseRoute/reset_password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(request));
    } catch (e) {
      return ApiResult<bool>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<String>.fromJson(json, (a) => a.toString());
      if (result.isSuccessed == true) {
        log("User created !");
        //log("JWT: " + result.payLoad!);
        //JWT = result.payLoad;
        // PayloadMap = parseJWT(result.payLoad!);
        //print(PayloadMap);
        return ApiResult.succesedApiResult(true);
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  Future<ApiResult<bool>> changePassword(
      String oldPassword, String newPassword) async {
    //saveUserAccountToCache(loginVM.username!, loginVM.password!);
    ChangePasswordVM changePasswordVM =
        ChangePasswordVM(UserServices.getUsername(), newPassword, oldPassword);

    log("ChangePasswordVM ${jsonEncode(changePasswordVM.toJson())}");
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    Response? response;
    try {
      response = await ioClient.post(Uri.parse('$baseRoute/password'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${UserServices.JWT!}'
          },
          body: jsonEncode(changePasswordVM));
    } catch (e) {
      return ApiResult<bool>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<String>.fromJson(json, (a) => a.toString());
      if (result.isSuccessed == true) {
        log("User created !");
        //log("JWT: " + result.payLoad!);
        //JWT = result.payLoad;
        // PayloadMap = parseJWT(result.payLoad!);
        //print(PayloadMap);
        return ApiResult.succesedApiResult(true);
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  Future<ApiResult<UserEditVM>> changeName(String newName) async {
    //saveUserAccountToCache(loginVM.username!, loginVM.password!);
    var user = await getUser();
    if (user.isSuccessed == false) {
      return ApiResult<UserEditVM>.failedApiResult(user.errorMessage);
    }

    var userEditVM = UserEditVM(user.payLoad!.id, user.payLoad!.username,
        newName, user.payLoad!.dateOfBirth, user.payLoad!.email);

    log("userEditVM ${jsonEncode(userEditVM.toJson())}");
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    Response? response;
    try {
      var url = '$baseRoute/${user.payLoad!.id}';
      print("PUT: $url");
      response = await ioClient.put(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${UserServices.JWT!}'
          },
          body: jsonEncode(userEditVM));
    } catch (e) {
      return ApiResult<UserEditVM>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<UserEditVM>.fromJson(
          json, (a) => UserEditVM.fromJson(a as Map<String, dynamic>));
      if (result.isSuccessed == true) {
        log("User edited !");

        return result;
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  Future<ApiResult<UserVM>> getUser() async {
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    Response? response;
    String userID = UserServices.getUserID();

    try {
      var url = Uri.parse('$baseRoute/$userID');
      log("GET: $url");
      response = await ioClient.get(
        url,
        headers: <String, String>{'Authorization': 'Bearer ${JWT!}'},
      );
    } catch (e) {
      return ApiResult<UserVM>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<UserVM>.fromJson(
          json, (a) => UserVM.fromJson(a as Map<String, dynamic>));
      if (result.isSuccessed == true) {
        log("Fetched UserVM: ${result.payLoad!.toJson()}");
        return ApiResult.succesedApiResult(result.payLoad);
      } else {
        log("Error when fetch userVM: ${result.errorMessage!}");
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }
    log("Request error: ${response.reasonPhrase}");
    log("Response body: ${response.body}");
    return ApiResult.failedApiResult("Some thing went wrong!");
  }
}
