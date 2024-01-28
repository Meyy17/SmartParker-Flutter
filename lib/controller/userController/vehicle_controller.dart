import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:smart_parker/models/vehicle_model.dart';

import '../../environtment.dart';
import '../../models/apiresponse_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class VehicleUserController {
  Future<ApiResponse> create(
      {required String vhcTYPE,
      required String vhcName,
      required String tokenSession,
      required String licensePlate}) async {
    if (vhcTYPE != "MOTORCYCLE" || vhcTYPE != "CAR") {
      vhcTYPE == "Mobil" ? vhcTYPE = "CAR" : vhcTYPE = "MOTORCYCLE";
    }
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse("${Environtment().baseURLServer}/api/user/vehicle/create"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          },
          body: {
            'LICENSE_PLATE': licensePlate,
            'VHC_NAME': vhcName,
            'VHC_TYPE': vhcTYPE,
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

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

  Future<ApiResponse> getVehicleUser({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse("${Environtment().baseURLServer}/api/user/vehicle"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              VehicleUserListModel.fromJson(jsonDecode(response.body));
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

  Future<ApiResponse> deleteVehicleUser(
      {required String tokenSession, required int idVehicle}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.delete(
          Uri.parse(
              "${Environtment().baseURLServer}/api/user/vehicle/delete/$idVehicle"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
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
