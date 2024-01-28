// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_parker/controller/orderController/orderController.dart';
import 'package:smart_parker/controller/userController/vehicle_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/main/users/order/order_screen.dart';
import 'package:smart_parker/main/users/requestFlow/webview_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/models/vehicle_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen(
      {super.key, required this.isTransfer, required this.parkingData});
  final bool isTransfer;
  final PayloadParkingLocation parkingData;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  VehicleUserDetailModel? vehicleSelected;
  String selectedValue = 'Tunai'; //Tunai
  String hourValueStart = '00'; //Tunai
  String minuteValueStart = '00'; //Tunai
  String hourValueEnd = '00'; //Tunai
  String minuteValueEnd = '00'; //Tunai
  TextEditingController cost = TextEditingController();

  int calculateCost() {
    // Convert start and end time to minutes
    int startTimeInMinutes =
        int.parse(hourValueStart) * 60 + int.parse(minuteValueStart);
    int endTimeInMinutes =
        int.parse(hourValueEnd) * 60 + int.parse(minuteValueEnd);

    // Calculate the total time in minutes
    int totalTimeInMinutes = endTimeInMinutes - startTimeInMinutes;

    // Calculate the cost based on the cost per 15 minutes
    int costPer15Minutes = widget.parkingData.fEE ?? 0;
    int numberOf15MinutesBlocks = (totalTimeInMinutes / 15).ceil();

    // Calculate the total cost
    int totalCost = costPer15Minutes * numberOf15MinutesBlocks;

    return totalCost.toInt();
  }

  void setCost() {
    setState(() {
      cost.text = "0";
      int costValue = calculateCost();
      if (costValue.isNegative) {
        // Lakukan sesuatu jika nilainya negatif

        cost.text = MoneyHelper.convertToIdrWithSymbol(
            count: costValue, decimalDigit: 2);
      } else {
        cost.text = MoneyHelper.convertToIdrWithSymbol(
            count: costValue, decimalDigit: 2);
        // Lakukan sesuatu jika nilainya non-negatif
        // print('Nilai non-negatif');
      }
    });
  }

  void vehiclePicker() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          height: GetSizeScreen().height(context) * 0.85,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: IntrinsicHeight(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: vhcData.list!.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var data = vhcData.list![index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        vehicleSelected = data;
                      });
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 80,
                      child: outlineCard(
                          radius: 10,
                          context: context,
                          content: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // ClipRRect(
                                //   borderRadius:
                                //       BorderRadius.circular(5),
                                //   child: Image.network(
                                //     "https://static.wikia.nocookie.net/p__/images/c/c2/Tayo_the_little_bus_-_render.webp/revision/latest?cb=20230823040314&path-prefix=protagonist",
                                //     fit: BoxFit.cover,
                                //     width: 60,
                                //     height: 60,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data.vHCNAME ?? "-",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: fontStyleTitleH3DefaultColor(
                                                context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data.lICENSEPLATE ?? "-",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          fontStyleSubtitleSemiBoldDefaultColor(
                                              context),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data.vHCTYPE ?? "-",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              fontStyleParagraftBoldDefaultColor(
                                                  context),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                              ],
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  //VEHICLE
  bool isLoad = true;
  String? error;
  SessionResponse session = SessionResponse();
  VehicleUserListModel vhcData = VehicleUserListModel();

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> getVehicle() async {
    var res = await VehicleUserController().getVehicleUser(
      tokenSession: session.token ?? "",
    );
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          vhcData = res.data as VehicleUserListModel;
          error = null;
        });
      } else {
        setState(() {
          error = res.error;
        });
      }
    }
  }

  Future<void> startActivity() async {
    DateTime now = DateTime.now();
    int roundedMinutes = ((now.minute / 15).floor() * 15) - 1;
    int roundedMinutes2 = ((now.minute / 15).floor() * 15);

    if (roundedMinutes <= 0) {
      roundedMinutes = 59; // Change 0 to 59
    }

    DateTime roundedTime =
        DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
    DateTime roundedTime2 =
        DateTime(now.year, now.month, now.day, now.hour, roundedMinutes2);

    setState(() {
      isLoad = true;
      error = null;
      hourValueStart = roundedTime2.hour.toString().padLeft(2, '0');
      minuteValueStart = roundedTime2.minute.toString().padLeft(2, '0');
      hourValueEnd = roundedTime.hour.toString().padLeft(2, '0');
      minuteValueEnd = roundedTime.minute.toString().padLeft(2, '0');
      print(roundedTime2);
    });
    cost.text = MoneyHelper.convertToIdrWithSymbol(count: 0, decimalDigit: 2);
    await getSession();
    if (session.isLog == true) {
      await getVehicle();
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  void order(payment) async {
    setState(() {
      isLoad = true;
    });
    DateTime now = DateTime.now();
    int roundedMinute = ((now.minute / 15).floor() * 15);
    String minuteNowEdit = roundedMinute.toString().padLeft(2, '0');
    String hourNowEdit = now.hour.toString().padLeft(2, '0');
    String formattedNow =
        "${DateFormat('yyyy-MM-dd').format(now)} ${hourNowEdit}:$minuteNowEdit:00";
    String startDate =
        "${DateFormat('yyyy-MM-dd').format(now)} $hourValueStart:$minuteValueStart:00";
    String endDate =
        "${DateFormat('yyyy-MM-dd').format(now)} $hourValueEnd:$minuteValueEnd:00";
    String openTime = widget.parkingData.pKGOPENTIME!;
    String closeTime = widget.parkingData.pKGCLOSETIME!;

    DateTime waktuDariString = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(openTime.split(":")[0]),
        int.parse(openTime.split(":")[1]),
        int.parse(openTime.split(":")[2]));
    DateTime waktuMulai = DateTime(now.year, now.month, now.day,
        int.parse(hourValueStart), int.parse(minuteValueStart), 00);
    DateTime waktuSelesai = DateTime(now.year, now.month, now.day,
        int.parse(hourValueEnd), int.parse(minuteValueEnd), 00);
    DateTime waktuDariStringClose = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(closeTime.split(":")[0]),
        int.parse(closeTime.split(":")[1]),
        int.parse(closeTime.split(":")[2]));

    if (startDate.compareTo(formattedNow) >= 0) {
      if (waktuMulai.compareTo(waktuDariString) >= 0) {
        if (waktuDariStringClose.compareTo(waktuSelesai) >= 0) {
          dynamic res = await OrderController().create(
              idParking: widget.parkingData.id.toString(),
              endDate: endDate,
              startDate: startDate,
              payment: payment,
              tokenSession: session.token ?? "",
              vhcId: vehicleSelected!.id.toString());
          if (res.error == null) {
            setState(() {
              isLoad = false;
            });
            if (res.data!["type"] == "URL") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentGatewayWebView(urlWebsite: res.data!["url"]),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const OrderUserScreen(initialIndex: 0),
                  ));
            }
          } else {
            setState(() {
              isLoad = false;
            });
            failedSnackbar(
                context: context,
                title: "Terjadi kesalahan",
                message: res.error);
          }
        } else {
          setState(() {
            isLoad = false;
          });
          failedSnackbar(
              context: context,
              title: "Terjadi kesalahan",
              message: "waktu selesai melebihi jam tutup operasional.");
        }
      } else {
        setState(() {
          isLoad = false;
        });
        failedSnackbar(
            context: context,
            title: "Terjadi kesalahan",
            message: "waktu mulai lebih kecil daripada jam buka operasional.");
      }
    } else {
      // print('startDate tidak lebih besar daripada tanggal dan waktu saat ini.');
      setState(() {
        isLoad = false;
      });
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message:
              "waktu mulai tidak boleh kecil daripada tanggal dan waktu saat ini.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(
          context: context, title: widget.isTransfer ? "Transfer" : "Tunai"),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: GetSizeScreen().paddingScreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih kendaraan anda",
                      style: fontStyleTitleH3DefaultColor(context),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () => vehiclePicker(),
                      child: SizedBox(
                        height: 80,
                        child: outlineCard(
                            radius: 10,
                            context: context,
                            content: Padding(
                              padding: const EdgeInsets.all(10),
                              child: vehicleSelected == null
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                        "Tekan untuk memilih kendaraan anda",
                                        style:
                                            fontStyleSubtitleSemiBoldDefaultColor(
                                                context),
                                      )))
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              vehicleSelected!.vHCNAME ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  fontStyleTitleH3DefaultColor(
                                                      context),
                                            ),
                                            Text(
                                              vehicleSelected!.lICENSEPLATE ??
                                                  "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  fontStyleSubtitleSemiBoldDefaultColor(
                                                      context),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  vehicleSelected!.vHCTYPE ??
                                                      "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      fontStyleParagraftBoldDefaultColor(
                                                          context),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                      ],
                                    ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: GetSizeScreen().paddingScreen,
                    ),
                    // Visibility(
                    //   visible: widget.isTransfer == false,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Pilih metode pembayaran",
                    //         style: fontStyleTitleH3DefaultColor(context),
                    //       ),
                    //       DropdownButton<String>(
                    //         isExpanded: true,
                    //         style:
                    //             fontStyleSubtitleSemiBoldDefaultColor(context),
                    //         value: selectedValue,
                    //         onChanged: (newValue) {
                    //           setState(() {
                    //             selectedValue = newValue!;
                    //           });
                    //           setCost();
                    //         },
                    //         items: <String>[
                    //           'Tunai',
                    //           'Bayar Nanti',
                    //         ].map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(value),
                    //           );
                    //         }).toList(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: GetSizeScreen().paddingScreen,
                    ),
                    widget.isTransfer
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Waktu Mulai : ",
                                      style: fontStyleSubtitleDefaultColor(
                                          context),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context),
                                            value: hourValueStart,
                                            onChanged: (newValue) {
                                              setState(() {
                                                hourValueStart = newValue!;
                                              });
                                              setCost();
                                            },
                                            items: <String>[
                                              '00',
                                              '01',
                                              '02',
                                              '03',
                                              '04',
                                              '05',
                                              '06',
                                              '07',
                                              '08',
                                              '09',
                                              '10',
                                              '11',
                                              '12',
                                              '13',
                                              '14',
                                              '15',
                                              '16',
                                              '17',
                                              '18',
                                              '19',
                                              '20',
                                              '21',
                                              '22',
                                              '23',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: GetSizeScreen().paddingScreen,
                                        ),
                                        Text(":",
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context)),
                                        SizedBox(
                                          width: GetSizeScreen().paddingScreen,
                                        ),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context),
                                            value: minuteValueStart,
                                            onChanged: (newValue) {
                                              setState(() {
                                                minuteValueStart = newValue!;
                                              });
                                              setCost();
                                            },
                                            items: <String>[
                                              '00',
                                              '15',
                                              '30',
                                              '45',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: GetSizeScreen().paddingScreen,
                              ),
                              Text("|",
                                  style: fontStyleSubtitleSemiBoldDefaultColor(
                                      context)),
                              SizedBox(
                                width: GetSizeScreen().paddingScreen,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Waktu Selesai : ",
                                      style: fontStyleSubtitleDefaultColor(
                                          context),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context),
                                            value: hourValueEnd,
                                            onChanged: (newValue) {
                                              setState(() {
                                                hourValueEnd = newValue!;
                                              });
                                              setCost();
                                            },
                                            items: <String>[
                                              '00',
                                              '01',
                                              '02',
                                              '03',
                                              '04',
                                              '05',
                                              '06',
                                              '07',
                                              '08',
                                              '09',
                                              '10',
                                              '11',
                                              '12',
                                              '13',
                                              '14',
                                              '15',
                                              '16',
                                              '17',
                                              '18',
                                              '19',
                                              '20',
                                              '21',
                                              '22',
                                              '23',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: GetSizeScreen().paddingScreen,
                                        ),
                                        Text(":",
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context)),
                                        SizedBox(
                                          width: GetSizeScreen().paddingScreen,
                                        ),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            style:
                                                fontStyleSubtitleSemiBoldDefaultColor(
                                                    context),
                                            value: minuteValueEnd,
                                            onChanged: (newValue) {
                                              setState(() {
                                                minuteValueEnd = newValue!;
                                              });
                                              setCost();
                                            },
                                            items: <String>[
                                              '59',
                                              '14',
                                              '29',
                                              '44',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Waktu Selesai : ",
                                style: fontStyleSubtitleDefaultColor(context),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      style:
                                          fontStyleSubtitleSemiBoldDefaultColor(
                                              context),
                                      value: hourValueEnd,
                                      onChanged: (newValue) {
                                        setState(() {
                                          hourValueEnd = newValue!;
                                        });
                                        setCost();
                                      },
                                      items: <String>[
                                        '00',
                                        '01',
                                        '02',
                                        '03',
                                        '04',
                                        '05',
                                        '06',
                                        '07',
                                        '08',
                                        '09',
                                        '10',
                                        '11',
                                        '12',
                                        '13',
                                        '14',
                                        '15',
                                        '16',
                                        '17',
                                        '18',
                                        '19',
                                        '20',
                                        '21',
                                        '22',
                                        '23',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: GetSizeScreen().paddingScreen,
                                  ),
                                  Text(":",
                                      style:
                                          fontStyleSubtitleSemiBoldDefaultColor(
                                              context)),
                                  SizedBox(
                                    width: GetSizeScreen().paddingScreen,
                                  ),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      style:
                                          fontStyleSubtitleSemiBoldDefaultColor(
                                              context),
                                      value: minuteValueEnd,
                                      onChanged: (newValue) {
                                        setState(() {
                                          minuteValueEnd = newValue!;
                                        });
                                        setCost();
                                      },
                                      items: <String>[
                                        '59',
                                        '14',
                                        '29',
                                        '44',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(
                      height: GetSizeScreen().paddingScreen,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isTransfer
                              ? "Total Biaya"
                              : "Perkiraan biaya (dihitung dari waktu sekarang)",
                          style: fontStyleTitleH3DefaultColor(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        inputFieldPrimary(
                            context: context, controller: cost, active: false),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: GetSizeScreen().height(context) * 0.3,
                        ),
                        SizedBox(
                          width: GetSizeScreen().width(context),
                          child: buttonPrimaryWithColor(
                              context: context,
                              radius: 10,
                              ontap: vehicleSelected == null
                                  ? null
                                  : () {
                                      order(widget.isTransfer
                                          ? "XENDIT"
                                          : 'CASH');
                                    },
                              content: "Lanjutkan Ke Pembayaran"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
