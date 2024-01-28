class TRXMODEL {
  int? status;
  String? message;
  List<Payload>? payload;

  TRXMODEL({this.status, this.message, this.payload});

  TRXMODEL.fromJson(Map<String, dynamic> json) {
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
  int? uID;
  int? tRXHEADID;
  String? lICENSEPLATE;
  int? pARKINGID;
  String? dATESTART;
  String? dATEEND;
  String? dATEUSERIN;
  String? dATEUSEROUT;
  String? iNFO;
  String? sTATUS;
  String? tYPE;
  String? uPDATESLOTSTART;
  String? uPDATESLOTEND;
  String? createdAt;
  String? updatedAt;

  Payload(
      {this.id,
      this.uID,
      this.tRXHEADID,
      this.lICENSEPLATE,
      this.pARKINGID,
      this.dATESTART,
      this.dATEEND,
      this.dATEUSERIN,
      this.dATEUSEROUT,
      this.iNFO,
      this.sTATUS,
      this.tYPE,
      this.uPDATESLOTSTART,
      this.uPDATESLOTEND,
      this.createdAt,
      this.updatedAt});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    tRXHEADID = json['TRX_HEAD_ID'];
    lICENSEPLATE = json['LICENSE_PLATE'];
    pARKINGID = json['PARKING_ID'];
    dATESTART = json['DATE_START'];
    dATEEND = json['DATE_END'];
    dATEUSERIN = json['DATE_USER_IN'];
    dATEUSEROUT = json['DATE_USER_OUT'];
    iNFO = json['INFO'];
    sTATUS = json['STATUS'];
    tYPE = json['TYPE'];
    uPDATESLOTSTART = json['UPDATE_SLOT_START'];
    uPDATESLOTEND = json['UPDATE_SLOT_END'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['U_ID'] = this.uID;
    data['TRX_HEAD_ID'] = this.tRXHEADID;
    data['LICENSE_PLATE'] = this.lICENSEPLATE;
    data['PARKING_ID'] = this.pARKINGID;
    data['DATE_START'] = this.dATESTART;
    data['DATE_END'] = this.dATEEND;
    data['DATE_USER_IN'] = this.dATEUSERIN;
    data['DATE_USER_OUT'] = this.dATEUSEROUT;
    data['INFO'] = this.iNFO;
    data['STATUS'] = this.sTATUS;
    data['TYPE'] = this.tYPE;
    data['UPDATE_SLOT_START'] = this.uPDATESLOTSTART;
    data['UPDATE_SLOT_END'] = this.uPDATESLOTEND;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
