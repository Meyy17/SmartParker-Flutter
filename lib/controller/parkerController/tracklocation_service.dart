import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:smart_parker/models/employee_model.dart';
import 'package:smart_parker/models/parking_model.dart';

import '../../environtment.dart';
import '../../models/apiresponse_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class TrackLocationController {
  Future<ApiResponse> trackLocationParkingByLatLong(
      {required bool filterFree,
      required String latitude,
      required double distance,
      required String longtitude}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/latlong"),
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'longitude': longtitude,
            'latitude': latitude,
            'filterFree': filterFree.toString().toUpperCase(),
            'distance': distance.toString(),
          }).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              ParkingLocationModel.fromJson(jsonDecode(response.body));
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

  Future<ApiResponse> getDetailParking({required int idParking}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
        Uri.parse(
            "${Environtment().baseURLServer}/api/parking/location/detail/$idParking"),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data = PayloadParkingLocation.fromJson(
              jsonDecode(response.body)["payload"]);
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

  Future<ApiResponse> getByAuth(
      {required String tokenSession, required bool ispending}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
        Uri.parse(ispending
            ? "${Environtment().baseURLServer}/api/parking/location/list/pending/auth"
            : "${Environtment().baseURLServer}/api/parking/location/list/auth"),
        headers: {'Accept': 'application/json', 'Authorization': tokenSession},
      ).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              ParkingLocationModel.fromJson(jsonDecode(response.body));
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

  Future<ApiResponse> getEmployee({required String tokenSession}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.get(
        Uri.parse("${Environtment().baseURLServer}/api/parker/employee"),
        headers: {'Accept': 'application/json', 'Authorization': tokenSession},
      ).timeout(Duration(seconds: Environtment().timeOutDuration));

      switch (response.statusCode) {
        case 200:
          apiresponse.data = EmployeeModel.fromJson(jsonDecode(response.body));
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

  Future<ApiResponse> createEmployee(
      {required String tokenSession,
      required String mail,
      required String parkingId}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parker/employee/create"),
          headers: {
            'Accept': 'application/json',
            'Authorization': tokenSession
          },
          body: {
            'MAIL': mail,
            'PARKING_ID': parkingId
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

  Future<ApiResponse> deleteEmployee(
      {required String tokenSession, required String id}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.delete(
        Uri.parse(
            "${Environtment().baseURLServer}/api/parker/employee/delete/$id"),
        headers: {'Accept': 'application/json', 'Authorization': tokenSession},
      ).timeout(Duration(seconds: Environtment().timeOutDuration));

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

  Future<ApiResponse> deleteLocation(
      {required String tokenSession, required String id}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.delete(
        Uri.parse(
            "${Environtment().baseURLServer}/api/parking/location/delete/$id"),
        headers: {'Accept': 'application/json', 'Authorization': tokenSession},
      ).timeout(Duration(seconds: Environtment().timeOutDuration));

      print(response.body);

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

  Future<ApiResponse> createLocation({
    required String tokenSession,
    required String lATITUDE,
    required String lONGITUDE,
    required String lANDCERTIFICATE,
    required String name,
    required String banner,
    required String street,
    required String fee,
    required String close,
    required String open,
    required String slotCar,
    required String slotMotor,
  }) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/create"),
          headers: {
            'Accept': 'application/json',
            'Authorization': tokenSession
          },
          body: {
            'LATITUDE': lATITUDE,
            'LONGITUDE': lONGITUDE,
            'LAND_CERTIFICATE': lANDCERTIFICATE,
            'PKG_NAME': name,
            'PKG_BANNER_BASE64': banner,
            'PKG_STREET': street,
            'FEE': fee,
            'PKG_CLOSE_TIME': close,
            'PKG_OPEN_TIME': open,
            'TOTAL_SLOT_CAR': slotCar,
            'TOTAL_SLOT_MOTORCYCLE': slotMotor,
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
  Future<ApiResponse> updateLocation({
    required String tokenSession,
    required String lATITUDE,
    required String lONGITUDE,
    required String id,
    required String name,
    required String banner,
    required String street,
    required String fee,
    required String close,
    required String open,
    required String slotCar,
    required String slotMotor,
  }) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parking/location/update/$id"),
          headers: {
            'Accept': 'application/json',
            'Authorization': tokenSession
          },
          body: {
            'LATITUDE': lATITUDE,
            'LONGITUDE': lONGITUDE,
            'PKG_NAME': name,
            'PKG_BANNER_BASE64': banner,
            'PKG_STREET': street,
            'FEE': fee,
            'PKG_CLOSE_TIME': close,
            'PKG_OPEN_TIME': open,
            'TOTAL_SLOT_CAR': slotCar,
            'TOTAL_SLOT_MOTORCYCLE': slotMotor,
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
}
