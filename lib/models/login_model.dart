// ignore_for_file: prefer_collection_literals

class LoginModel {
  int? status;
  String? message;
  Payload? payload;

  LoginModel({this.status, this.message, this.payload});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  User? user;

  Payload({this.user});

  Payload.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? uMAIL;
  String? uROLE;
  int? id;
  String? uVERIFYSTATUS;
  String? token;

  User({this.uMAIL, this.uROLE, this.id, this.uVERIFYSTATUS, this.token});

  User.fromJson(Map<String, dynamic> json) {
    uMAIL = json['U_MAIL'];
    uROLE = json['U_ROLE'];
    id = json['id'];
    uVERIFYSTATUS = json['U_VERIFY_STATUS'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['U_MAIL'] = uMAIL;
    data['U_ROLE'] = uROLE;
    data['id'] = id;
    data['U_VERIFY_STATUS'] = uVERIFYSTATUS;
    data['token'] = token;
    return data;
  }
}
