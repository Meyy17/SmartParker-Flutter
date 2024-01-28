import 'package:smart_parker/models/parking_model.dart';

class AddFavoriteModel {
  String? message;
  bool? payload;

  AddFavoriteModel({this.message, this.payload});

  AddFavoriteModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    payload = json['payload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['payload'] = payload;
    return data;
  }
}


class FavoriteModelList {
  List<FavoriteModel>? payload;

  FavoriteModelList({this.payload});

  FavoriteModelList.fromJson(Map<String, dynamic> json) {
    if (json['payload'] != null) {
      payload = <FavoriteModel>[];
      json['payload'].forEach((v) {
        payload!.add(FavoriteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payload != null) {
      data['payload'] = payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavoriteModel {
  int? id;
  int? uID;
  String? dVCID;
  int? pKGHEADID;
  String? createdAt;
  String? updatedAt;
  PayloadParkingLocation? parkingHeader;

  FavoriteModel(
      {this.id,
      this.uID,
      this.dVCID,
      this.pKGHEADID,
      this.createdAt,
      this.updatedAt,
      this.parkingHeader});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    dVCID = json['DVC_ID'];
    pKGHEADID = json['PKG_HEAD_ID'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    parkingHeader = json['ParkingHeader'] != null
        ? PayloadParkingLocation.fromJson(json['ParkingHeader'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['U_ID'] = uID;
    data['DVC_ID'] = dVCID;
    data['PKG_HEAD_ID'] = pKGHEADID;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (parkingHeader != null) {
      data['ParkingHeader'] = parkingHeader!.toJson();
    }
    return data;
  }
}
