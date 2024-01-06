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
        payload!.add(new Payload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['u_id'] = this.uId;
    data['street'] = this.street;
    data['subLocality'] = this.subLocality;
    data['subAdministrativeArea'] = this.subAdministrativeArea;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['slot'] = this.slot;
    data['fee'] = this.fee;
    data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
