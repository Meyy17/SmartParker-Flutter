class TrackLocationModel {
  int? status;
  String? message;
  List<Payload>? payload;

  TrackLocationModel({this.status, this.message, this.payload});

  TrackLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <Payload>[];
      json['payload'].forEach((v) {
        payload!.add(Payload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  int? id;
  String? name;
  int? uId;
  String? street;
  String? subLocality;
  String? subAdministrativeArea;
  String? latitude;
  String? longtitude;
  int? slot;
  int? fee;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;

  Payload(
      {this.id,
      this.name,
      this.uId,
      this.street,
      this.subLocality,
      this.subAdministrativeArea,
      this.latitude,
      this.longtitude,
      this.slot,
      this.fee,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uId = json['u_id'];
    street = json['street'];
    subLocality = json['subLocality'];
    subAdministrativeArea = json['subAdministrativeArea'];
    latitude = json['latitude'];
    longtitude = json['longtitude'];
    slot = json['slot'];
    fee = json['fee'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['u_id'] = uId;
    data['street'] = street;
    data['subLocality'] = subLocality;
    data['subAdministrativeArea'] = subAdministrativeArea;
    data['latitude'] = latitude;
    data['longtitude'] = longtitude;
    data['slot'] = slot;
    data['fee'] = fee;
    data['type'] = type;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
