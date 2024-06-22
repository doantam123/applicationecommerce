import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/view_models/SaleCampaigns/SaleCampaignVM.dart';
import 'package:applicationecommerce/view_models/commons/ApiResult.dart';
import 'package:applicationecommerce/view_models/commons/PaginatedList.dart';
import 'package:http/http.dart';

import 'HttpClientFactory.dart';
import 'UserServices.dart';

class SaleCampaignServices {
  final String baseRoute = AppConfigs.URL_SaleCampaignsRouteAPI;
  final HttpClientFactory _httpClientFactory = HttpClientFactory();

  Future<ApiResult<PaginatedList<SaleCampaignVM>>> getAllValid() async {
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    final String url = "$baseRoute/valid";
    Response? response;
    try {
      log("GET: $url");
      response = await ioClient.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${UserServices.JWT!}'
        },
      );
    } catch (e) {
      return ApiResult<PaginatedList<SaleCampaignVM>>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var result =
          ApiResult<PaginatedList<SaleCampaignVM>>.fromJson(json, (foodJson) {
        return PaginatedList<SaleCampaignVM>.fromJson(
            foodJson as Map<String, dynamic>, (value) {
          return SaleCampaignVM.fromJson(value as Map<String, dynamic>);
        });
      });

      if (result.isSuccessed == true) {
        print("Fetched SaleCampaignVM list: ");
        print(result.payLoad!.items);
        return ApiResult.succesedApiResult(result.payLoad);
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }

  Future<ApiResult<SaleCampaignVM>> getByID(int id) async {
    IOClientWrapper ioClient = _httpClientFactory.createIOClientWrapper();
    final String url = "$baseRoute/$id";
    Response? response;
    try {
      log("GET: $url");
      response = await ioClient.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ${UserServices.JWT!}'
        },
      );
    } catch (e) {
      return ApiResult<SaleCampaignVM>.failedApiResult(
          "Could not connect to server. Check your connection!");
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var json = jsonDecode(response.body);
      var result = ApiResult<SaleCampaignVM>.fromJson(json, (foodJson) {
        return SaleCampaignVM.fromJson(foodJson as Map<String, dynamic>);
      });

      if (result.isSuccessed == true) {
        print("Fetched SaleCampaign: ");
        print(result.payLoad);
        return ApiResult.succesedApiResult(result.payLoad);
      } else {
        return ApiResult.failedApiResult(result.errorMessage);
      }
    }

    return ApiResult.failedApiResult("Some thing went wrong!");
  }
}
