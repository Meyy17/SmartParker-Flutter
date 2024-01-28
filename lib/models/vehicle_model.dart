class VehicleUserListModel {
  List<VehicleUserDetailModel>? list;

  VehicleUserListModel({this.list});

  VehicleUserListModel.fromJson(Map<String, dynamic> json) {
    if (json['payload'] != null) {
      list = <VehicleUserDetailModel>[];
      json['payload'].forEach((v) {
        list!.add(VehicleUserDetailModel.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['payload'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleUserDetailModel {
  int? id;
  int? uID;
  String? lICENSEPLATE;
  String? vHCNAME;
  String? vHCTYPE;
  String? createdAt;
  String? updatedAt;

  VehicleUserDetailModel(
      {this.id,
      this.uID,
      this.lICENSEPLATE,
      this.vHCNAME,
      this.vHCTYPE,
      this.createdAt,
      this.updatedAt});

  VehicleUserDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    lICENSEPLATE = json['LICENSE_PLATE'];
    vHCNAME = json['VHC_NAME'];
    vHCTYPE = json['VHC_TYPE'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['U_ID'] = uID;
    data['LICENSE_PLATE'] = lICENSEPLATE;
    data['VHC_NAME'] = vHCNAME;
    data['VHC_TYPE'] = vHCTYPE;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
