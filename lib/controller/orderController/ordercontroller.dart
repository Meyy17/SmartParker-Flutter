import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:smart_parker/models/assigment_model.dart';
import 'package:smart_parker/models/order_model.dart';
import 'package:smart_parker/models/overtime_model.dart';
import 'package:smart_parker/models/scan_model.dart';
import 'package:smart_parker/models/scanupdate_model.dart';
import 'package:smart_parker/models/transaction_model.dart';

import '../../environtment.dart';
import '../../models/apiresponse_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class OrderController {
  Future<ApiResponse> create(
      {required String idParking,
      required String endDate,
      required String startDate,
      required String payment,
      required String tokenSession,
      required String vhcId}) async {
    // if (vhcTYPE != "MOTORCYCLE" || vhcTYPE != "CAR") {
    //   vhcTYPE == "Mobil" ? vhcTYPE = "CAR" : vhcTYPE = "MOTORCYCLE";
    // }
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/order"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          },
          body: {
            'idParking': idParking,
            'endDate': endDate,
            'startDate': startDate,
            'vhcId': vhcId,
            'payment': payment,
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

  Future<ApiResponse> getOrderOvertime({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/overtime/user"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = OrderModelNew.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> getOrderOnGoing({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/order/user"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      // print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = OrderModelNew.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> getOrderDone({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/order/user/done"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      // print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = OrderModelNew.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> getOrderRiwayat(
      {required String tokenSession, required String idParking}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/order/parker/history/$idParking"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = OrderModelNew.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> scan(
      {required String tokenSession, required String id}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/scan/get/$id"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = ScanModel.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> overtime(
      {required String tokenSession, required String id}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/overtime/$id"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = OverTimeModel.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> scanUpdate(
      {required String tokenSession, required String id}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/scan/update/$id"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              ScanUpdateModel.fromJson(jsonDecode(response.body));
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
      print(err);
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

  Future<ApiResponse> scanSetup(
      {required String tokenSession,
      required String latitude,
      required String longitude}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/scan/setup"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenSession'
          },
          body: {
            'latitude': latitude,
            'longitude': longitude
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      print("body NEww :" + response.body);

      switch (response.statusCode) {
        case 200:
          apiresponse.data = PenugasanModel.fromJson(jsonDecode(response.body));
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
      print(err);
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
