class OrderModelNew {
  int? status;
  String? message;
  List<Payload>? payload;

  OrderModelNew({this.status, this.message, this.payload});

  OrderModelNew.fromJson(Map<String, dynamic> json) {
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
  int? uID;
  int? eMPLOYEEID;
  String? tRXID;
  String? xenditUrl;
  int? aMOUNT;
  int? fee;
  String? lICENSEPLATE;
  int? pARKINGID;
  String? dATESTART;
  String? dATEEND;
  String? dATEUSERIN;
  String? dATEUSEROUT;
  String? iNFO;
  String? sTATUS;
  String? tYPE;
  String? pAY;
  String? uPDATESLOTSTART;
  String? uPDATESLOTEND;
  String? createdAt;
  String? updatedAt;

  Payload(
      {this.id,
      this.uID,
      this.eMPLOYEEID,
      this.tRXID,
      this.fee,
      this.aMOUNT,
      this.xenditUrl,
      this.lICENSEPLATE,
      this.pARKINGID,
      this.dATESTART,
      this.dATEEND,
      this.dATEUSERIN,
      this.dATEUSEROUT,
      this.iNFO,
      this.sTATUS,
      this.tYPE,
      this.pAY,
      this.uPDATESLOTSTART,
      this.uPDATESLOTEND,
      this.createdAt,
      this.updatedAt});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    eMPLOYEEID = json['EMPLOYEE_ID'];
    tRXID = json['TRX_ID'];
    aMOUNT = json['AMOUNT'];
    lICENSEPLATE = json['LICENSE_PLATE'];
    pARKINGID = json['PARKING_ID'];
    dATESTART = json['DATE_START'];
    dATEEND = json['DATE_END'];
    dATEUSERIN = json['DATE_USER_IN'];
    dATEUSEROUT = json['DATE_USER_OUT'];
    iNFO = json['INFO'];
    sTATUS = json['STATUS'];
    tYPE = json['TYPE'];
    xenditUrl = json['URL_XENDIT'];
    pAY = json['PAY'];
    uPDATESLOTSTART = json['UPDATE_SLOT_START'];
    uPDATESLOTEND = json['UPDATE_SLOT_END'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fee = aMOUNT;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['U_ID'] = this.uID;
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['TRX_ID'] = this.tRXID;
    data['AMOUNT'] = this.aMOUNT;
    data['LICENSE_PLATE'] = this.lICENSEPLATE;
    data['PARKING_ID'] = this.pARKINGID;
    data['DATE_START'] = this.dATESTART;
    data['DATE_END'] = this.dATEEND;
    data['DATE_USER_IN'] = this.dATEUSERIN;
    data['DATE_USER_OUT'] = this.dATEUSEROUT;
    data['INFO'] = this.iNFO;
    data['STATUS'] = this.sTATUS;
    data['TYPE'] = this.tYPE;
    data['PAY'] = this.pAY;
    data['UPDATE_SLOT_START'] = this.uPDATESLOTSTART;
    data['UPDATE_SLOT_END'] = this.uPDATESLOTEND;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
