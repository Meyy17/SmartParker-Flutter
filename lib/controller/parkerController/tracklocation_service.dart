import 'dart:convert';

import 'package:smart_parker/models/tracklocation_model.dart';

import '../../environtment.dart';
import '../../models/apiresponse_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class TrackLocationController {
  Future<ApiResponse> trackLocationParkingByLatLong(
      {required bool filterFree,
      required String latitude,
      required String longtitude}) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parker/location/parker-latlong"),
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'longitude': longtitude,
            'latitude': latitude,
          });

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              TrackLocationModel.fromJson(jsonDecode(response.body));
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      apiresponse.error = serverError;
    }

    return apiresponse;
  }

  Future<ApiResponse> gatAllLocationParking({
    required bool filterFree,
  }) async {
    ApiResponse apiresponse = ApiResponse();
    try {
      final response = await http.post(
          Uri.parse(
              "${Environtment().baseURLServer}/api/parker/location/parker-all"),
          headers: {
            'Accept': 'application/json',
          },
          body: {
            'filterFree': "$filterFree",
          });

      switch (response.statusCode) {
        case 200:
          apiresponse.data =
              TrackLocationModel.fromJson(jsonDecode(response.body));
          break;
        case 400:
          apiresponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiresponse.error = somethingWentWrong;
          break;
      }
    } catch (err) {
      apiresponse.error = serverError;
    }

    return apiresponse;
  }
}
