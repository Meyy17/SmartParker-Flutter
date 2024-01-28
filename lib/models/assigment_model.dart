import 'package:smart_parker/models/parking_model.dart';

class PenugasanModel {
  int? status;
  bool? message;
  PayloadParkingLocation? payload;

  PenugasanModel({this.status, this.message, this.payload});

  PenugasanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payload = json['payload'] != null
        ? new PayloadParkingLocation.fromJson(json['payload'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}
