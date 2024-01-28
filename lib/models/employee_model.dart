class EmployeeModel {
  int? status;
  String? message;
  List<Payload>? payload;

  EmployeeModel({this.status, this.message, this.payload});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
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
  int? eMPLOYEUID;
  int? pARKINGID;
  String? sTATUS;
  String? createdAt;
  String? updatedAt;
  EmployeeDetail? employeeDetail;
  ParkingDetail? parkingDetail;
  List<EmployeeParkingHandle>? employeeParkingHandle;

  Payload(
      {this.id,
      this.uID,
      this.eMPLOYEUID,
      this.pARKINGID,
      this.sTATUS,
      this.createdAt,
      this.updatedAt,
      this.employeeDetail,
      this.parkingDetail,
      this.employeeParkingHandle});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    eMPLOYEUID = json['EMPLOYE_U_ID'];
    pARKINGID = json['PARKING_ID'];
    sTATUS = json['STATUS'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    employeeDetail = json['EmployeeDetail'] != null
        ? new EmployeeDetail.fromJson(json['EmployeeDetail'])
        : null;
    parkingDetail = json['ParkingDetail'] != null
        ? new ParkingDetail.fromJson(json['ParkingDetail'])
        : null;
    if (json['EmployeeParkingHandle'] != null) {
      employeeParkingHandle = <EmployeeParkingHandle>[];
      json['EmployeeParkingHandle'].forEach((v) {
        employeeParkingHandle!.add(new EmployeeParkingHandle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['U_ID'] = this.uID;
    data['EMPLOYE_U_ID'] = this.eMPLOYEUID;
    data['PARKING_ID'] = this.pARKINGID;
    data['STATUS'] = this.sTATUS;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.employeeDetail != null) {
      data['EmployeeDetail'] = this.employeeDetail!.toJson();
    }
    if (this.parkingDetail != null) {
      data['ParkingDetail'] = this.parkingDetail!.toJson();
    }
    if (this.employeeParkingHandle != null) {
      data['EmployeeParkingHandle'] =
          this.employeeParkingHandle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeDetail {
  int? id;
  String? uMAIL;
  String? uIMG;
  String? uNAME;
  int? uBALANCE;
  String? uROLE;
  String? uVERIFYSTATUS;
  String? createdAt;
  String? updatedAt;

  EmployeeDetail(
      {this.id,
      this.uMAIL,
      this.uIMG,
      this.uNAME,
      this.uBALANCE,
      this.uROLE,
      this.uVERIFYSTATUS,
      this.createdAt,
      this.updatedAt});

  EmployeeDetail.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['U_MAIL'] = this.uMAIL;
    data['U_IMG'] = this.uIMG;
    data['U_NAME'] = this.uNAME;
    data['U_BALANCE'] = this.uBALANCE;
    data['U_ROLE'] = this.uROLE;
    data['U_VERIFY_STATUS'] = this.uVERIFYSTATUS;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ParkingDetail {
  int? id;
  String? pKGNAME;
  int? uID;
  String? pKGSTREET;
  String? pKGOPENTIME;
  String? pKGCLOSETIME;
  String? pKGBANNERBASE64;
  Null? lANDCERTIFICATE;
  String? pKGSUBLOCALITY;
  String? pKGSUBADMINISTRATIVEAREA;
  String? pKGPOSTALCODE;
  String? lATITUDE;
  String? lONGITUDE;
  int? fEE;
  int? tOTALSLOTMOTORCYCLE;
  int? tOTALUSEDMOTORCYCLE;
  int? tOTALSLOTCAR;
  int? tOTALUSEDCAR;
  String? sTATUS;
  String? createdAt;
  String? updatedAt;

  ParkingDetail(
      {this.id,
      this.pKGNAME,
      this.uID,
      this.pKGSTREET,
      this.pKGOPENTIME,
      this.pKGCLOSETIME,
      this.pKGBANNERBASE64,
      this.lANDCERTIFICATE,
      this.pKGSUBLOCALITY,
      this.pKGSUBADMINISTRATIVEAREA,
      this.pKGPOSTALCODE,
      this.lATITUDE,
      this.lONGITUDE,
      this.fEE,
      this.tOTALSLOTMOTORCYCLE,
      this.tOTALUSEDMOTORCYCLE,
      this.tOTALSLOTCAR,
      this.tOTALUSEDCAR,
      this.sTATUS,
      this.createdAt,
      this.updatedAt});

  ParkingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pKGNAME = json['PKG_NAME'];
    uID = json['U_ID'];
    pKGSTREET = json['PKG_STREET'];
    pKGOPENTIME = json['PKG_OPEN_TIME'];
    pKGCLOSETIME = json['PKG_CLOSE_TIME'];
    pKGBANNERBASE64 = json['PKG_BANNER_BASE64'];
    lANDCERTIFICATE = json['LAND_CERTIFICATE'];
    pKGSUBLOCALITY = json['PKG_SUBLOCALITY'];
    pKGSUBADMINISTRATIVEAREA = json['PKG_SUB_ADMINISTRATIVE_AREA'];
    pKGPOSTALCODE = json['PKG_POSTAL_CODE'];
    lATITUDE = json['LATITUDE'];
    lONGITUDE = json['LONGITUDE'];
    fEE = json['FEE'];
    tOTALSLOTMOTORCYCLE = json['TOTAL_SLOT_MOTORCYCLE'];
    tOTALUSEDMOTORCYCLE = json['TOTAL_USED_MOTORCYCLE'];
    tOTALSLOTCAR = json['TOTAL_SLOT_CAR'];
    tOTALUSEDCAR = json['TOTAL_USED_CAR'];
    sTATUS = json['STATUS'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['PKG_NAME'] = this.pKGNAME;
    data['U_ID'] = this.uID;
    data['PKG_STREET'] = this.pKGSTREET;
    data['PKG_OPEN_TIME'] = this.pKGOPENTIME;
    data['PKG_CLOSE_TIME'] = this.pKGCLOSETIME;
    data['PKG_BANNER_BASE64'] = this.pKGBANNERBASE64;
    data['LAND_CERTIFICATE'] = this.lANDCERTIFICATE;
    data['PKG_SUBLOCALITY'] = this.pKGSUBLOCALITY;
    data['PKG_SUB_ADMINISTRATIVE_AREA'] = this.pKGSUBADMINISTRATIVEAREA;
    data['PKG_POSTAL_CODE'] = this.pKGPOSTALCODE;
    data['LATITUDE'] = this.lATITUDE;
    data['LONGITUDE'] = this.lONGITUDE;
    data['FEE'] = this.fEE;
    data['TOTAL_SLOT_MOTORCYCLE'] = this.tOTALSLOTMOTORCYCLE;
    data['TOTAL_USED_MOTORCYCLE'] = this.tOTALUSEDMOTORCYCLE;
    data['TOTAL_SLOT_CAR'] = this.tOTALSLOTCAR;
    data['TOTAL_USED_CAR'] = this.tOTALUSEDCAR;
    data['STATUS'] = this.sTATUS;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class EmployeeParkingHandle {
  int? id;
  int? uID;
  int? eMPLOYEEID;
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

  EmployeeParkingHandle(
      {this.id,
      this.uID,
      this.eMPLOYEEID,
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

  EmployeeParkingHandle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uID = json['U_ID'];
    eMPLOYEEID = json['EMPLOYEE_ID'];
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
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
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
