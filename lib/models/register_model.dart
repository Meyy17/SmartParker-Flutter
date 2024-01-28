// ignore_for_file: prefer_collection_literals

class RegisterModel {
  int? status;
  String? message;
  Payload? payload;

  RegisterModel({this.status, this.message, this.payload});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    return data;
  }
}

class Payload {
  String? uMAIL;

  Payload({this.uMAIL});

  Payload.fromJson(Map<String, dynamic> json) {
    uMAIL = json['U_MAIL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['U_MAIL'] = uMAIL;
    return data;
  }
}
