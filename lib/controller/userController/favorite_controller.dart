import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:smart_parker/models/favorite_model.dart';

import '../../environtment.dart';
import '../../models/apiresponse_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class FavoriteUserController {
  Future<ApiResponse> getList(
      {String? tokenSession, required String dvcId}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse("${Environtment().baseURLServer}/api/user/favorite/$dvcId"),
          headers: {
            'Accept': 'application/json',
            'Authorization': tokenSession ?? ""
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              FavoriteModelList.fromJson(jsonDecode(response.body));
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> create(
      {String? tokenSession,
      required String dvcId,
      required int headerParking}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse("${Environtment().baseURLServer}/api/user/favorite/create"),
          headers: {
            'Accept': 'application/json',
            'Authorization': tokenSession ?? ""
          },
          body: {
            'DVC_ID': dvcId,
            'PKG_HEAD_ID': "$headerParking",
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              AddFavoriteModel.fromJson(jsonDecode(response.body));
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> validate(
      {String? tokenSession,
      required String dvcId,
      required int headerParking}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/user/favorite/validate"),
          headers: {
            'Accept': 'application/json',
            'Authorization': tokenSession ?? ""
          },
          body: {
            'DVC_ID': dvcId,
            'PKG_HEAD_ID': "$headerParking",
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data = jsonDecode(response.body)['payload'];
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }

  Future<ApiResponse> delete({required int idFavorite}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.delete(
          Uri.parse(
              "${Environtment().baseURLServer}/api/user/favorite/delete/$idFavorite"),
          headers: {
            'Accept': 'application/json'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      // print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiresponse.error = unauthorizedMessage;
          apiresponse.unauthorized = true;
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      if (err is TimeoutException) {
        apiresponse.error = timeoutException;
      } else if (err is SocketException) {
        apiresponse.error = socketException;
      } else {
        apiresponse.error = serverError;
      }
    }

    return apiresponse;
  }
}
