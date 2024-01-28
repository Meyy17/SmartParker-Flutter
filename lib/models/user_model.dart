class UserModel {
  int? id;
  String? uMAIL;
  String? uIMG;
  String? uNAME;
  int? uBALANCE;
  String? uROLE;
  String? uVERIFYSTATUS;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.id,
      this.uMAIL,
      this.uIMG,
      this.uNAME,
      this.uBALANCE,
      this.uROLE,
      this.uVERIFYSTATUS,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uMAIL = json['U_MAIL'];
    uIMG = json['U_IMG'];
    uNAME = json['U_NAME'];
    uBALANCE = json['U_BALANCE'];
    uROLE = json['U_ROLE'];
    uVERIFYSTATUS = json['U_VERIFY_STATUS'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['U_MAIL'] = uMAIL;
    data['U_IMG'] = uIMG;
    data['U_NAME'] = uNAME;
    data['U_BALANCE'] = uBALANCE;
    data['U_ROLE'] = uROLE;
    data['U_VERIFY_STATUS'] = uVERIFYSTATUS;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
