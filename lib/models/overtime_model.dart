class OverTimeModel {
  int? status;
  String? message;
  Payload? payload;

  OverTimeModel({this.status, this.message, this.payload});

  OverTimeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}

class Payload {
  int? id;
  int? uID;
  int? aMOUNT;
  int? iDTRXPKG;
  int? iNTERVAL;
  String? dENDA;
  String? sTATUS;
  String? createdAt;
  String? updatedAt;
  TrxData? trxData;

  Payload(
      {this.id,
      this.uID,
      this.aMOUNT,
      this.iDTRXPKG,
      this.iNTERVAL,
      this.dENDA,
      this.sTATUS,
      this.createdAt,
      this.updatedAt,
      this.trxData});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    aMOUNT = json['AMOUNT'];
    iDTRXPKG = json['ID_TRX_PKG'];
    iNTERVAL = json['INTERVAL'];
    dENDA = json['DENDA'];
    sTATUS = json['STATUS'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    trxData =
        json['TrxData'] != null ? new TrxData.fromJson(json['TrxData']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['U_ID'] = this.uID;
    data['AMOUNT'] = this.aMOUNT;
    data['ID_TRX_PKG'] = this.iDTRXPKG;
    data['INTERVAL'] = this.iNTERVAL;
    data['DENDA'] = this.dENDA;
    data['STATUS'] = this.sTATUS;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.trxData != null) {
      data['TrxData'] = this.trxData!.toJson();
    }
    return data;
  }
}

class TrxData {
  int? id;
  int? uID;
  int? eMPLOYEEID;
  String? uRLXENDIT;
  String? tRXID;
  int? aMOUNT;
  int? fEE;
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

  TrxData(
      {this.id,
      this.uID,
      this.eMPLOYEEID,
      this.uRLXENDIT,
      this.tRXID,
      this.aMOUNT,
      this.fEE,
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

  TrxData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    eMPLOYEEID = json['EMPLOYEE_ID'];
    uRLXENDIT = json['URL_XENDIT'];
    tRXID = json['TRX_ID'];
    aMOUNT = json['AMOUNT'];
    fEE = json['FEE'];
    lICENSEPLATE = json['LICENSE_PLATE'];
    pARKINGID = json['PARKING_ID'];
    dATESTART = json['DATE_START'];
    dATEEND = json['DATE_END'];
    dATEUSERIN = json['DATE_USER_IN'];
    dATEUSEROUT = json['DATE_USER_OUT'];
    iNFO = json['INFO'];
    sTATUS = json['STATUS'];
    tYPE = json['TYPE'];
    pAY = json['PAY'];
    uPDATESLOTSTART = json['UPDATE_SLOT_START'];
    uPDATESLOTEND = json['UPDATE_SLOT_END'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['U_ID'] = this.uID;
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['URL_XENDIT'] = this.uRLXENDIT;
    data['TRX_ID'] = this.tRXID;
    data['AMOUNT'] = this.aMOUNT;
    data['FEE'] = this.fEE;
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
