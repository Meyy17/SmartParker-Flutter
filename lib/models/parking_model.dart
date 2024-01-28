class ParkingLocationModel {
  int? status;
  String? message;
  List<PayloadParkingLocation>? payload;

  ParkingLocationModel({this.status, this.message, this.payload});

  ParkingLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <PayloadParkingLocation>[];
      json['payload'].forEach((v) {
        payload!.add(PayloadParkingLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayloadParkingLocation {
  int? id;
  String? pKGNAME;
  int? uID;
  String? pKGOPENTIME;
  String? pKGCLOSETIME;
  String? landCertificate;

  String? pKGSTREET;
  String? pKGBANNERBASE64;
  String? pKGSUBLOCALITY;
  String? pKGSUBADMINISTRATIVEAREA;
  String? pKGPOSTALCODE;
  String? lATITUDE;
  String? lONGITUDE;
  int? fEE;
  String? sTATUS;
  String? createdAt;
  String? updatedAt;
  int? countAvaliableMotor;
  int? countUsedMotor;
  int? countTotalMotor;
  int? countAvaliableCar;
  int? countUsedCar;
  int? countTotalCar;

  PayloadParkingLocation(
      {this.id,
      this.pKGNAME,
      this.landCertificate,
      this.uID,
      this.pKGSTREET,
      this.pKGBANNERBASE64,
      this.pKGSUBLOCALITY,
      this.pKGSUBADMINISTRATIVEAREA,
      this.pKGPOSTALCODE,
      this.lATITUDE,
      this.lONGITUDE,
      this.fEE,
      this.sTATUS,
      this.createdAt,
      this.updatedAt,
      this.countAvaliableMotor,
      this.countTotalMotor,
      this.countAvaliableCar,
      this.countTotalCar,
      this.countUsedCar,
      this.countUsedMotor});

  PayloadParkingLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pKGNAME = json['PKG_NAME'];
    uID = json['U_ID'];
    landCertificate = json['LAND_CERTIFICATE'];
    pKGSTREET = json['PKG_STREET'];
    pKGCLOSETIME = json['PKG_CLOSE_TIME'];
    pKGOPENTIME = json['PKG_OPEN_TIME'];
    pKGBANNERBASE64 = json['PKG_BANNER_BASE64'];
    pKGSUBLOCALITY = json['PKG_SUBLOCALITY'];
    pKGSUBADMINISTRATIVEAREA = json['PKG_SUB_ADMINISTRATIVE_AREA'];
    pKGPOSTALCODE = json['PKG_POSTAL_CODE'];
    lATITUDE = json['LATITUDE'];
    lONGITUDE = json['LONGITUDE'];
    fEE = json['FEE'];
    sTATUS = json['STATUS'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    countTotalMotor = json['TOTAL_SLOT_MOTORCYCLE'];
    countTotalCar = json['TOTAL_SLOT_CAR'];
    countUsedMotor = json['TOTAL_USED_MOTORCYCLE'];
    countUsedCar = json['TOTAL_USED_CAR'];
    countAvaliableCar = countTotalCar! - countUsedCar!;
    countAvaliableMotor = countTotalMotor! - countUsedMotor!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PKG_NAME'] = pKGNAME;
    data['U_ID'] = uID;
    data['PKG_STREET'] = pKGSTREET;
    data['PKG_BANNER_BASE64'] = pKGBANNERBASE64;
    data['PKG_SUBLOCALITY'] = pKGSUBLOCALITY;
    data['PKG_SUB_ADMINISTRATIVE_AREA'] = pKGSUBADMINISTRATIVEAREA;
    data['PKG_POSTAL_CODE'] = pKGPOSTALCODE;
    data['LATITUDE'] = lATITUDE;
    data['LONGITUDE'] = lONGITUDE;
    data['FEE'] = fEE;
    data['STATUS'] = sTATUS;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    data['countAvaliableMotor'] = countAvaliableMotor;
    data['countTotalMotor'] = countTotalMotor;
    data['countAvaliableCar'] = countAvaliableCar;
    data['countTotalCar'] = countTotalCar;
    return data;
  }
}

class ParkingDetail {
  int? id;
  int? pARKINGNUMBER;
  int? pKGHEADID;
  String? sTATUS;
  String? tYPE;
  String? createdAt;
  String? updatedAt;

  ParkingDetail(
      {this.id,
      this.pARKINGNUMBER,
      this.pKGHEADID,
      this.sTATUS,
      this.tYPE,
      this.createdAt,
      this.updatedAt});

  ParkingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pARKINGNUMBER = json['PARKING_NUMBER'];
    pKGHEADID = json['PKG_HEAD_ID'];
    sTATUS = json['STATUS'];
    tYPE = json['TYPE'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['PARKING_NUMBER'] = pARKINGNUMBER;
    data['PKG_HEAD_ID'] = pKGHEADID;
    data['STATUS'] = sTATUS;
    data['TYPE'] = tYPE;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
