class ScanUpdateModel {
  int? status;
  String? message;
  bool? payload;

  ScanUpdateModel({this.status, this.message, this.payload});

  ScanUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payload = json['payload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['payload'] = payload;
    return data;
  }
}
