// ignore_for_file: dead_code, use_build_context_synchronously

import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_parker/controller/orderController/ordercontroller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/date_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/helper/time_helper.dart';
import 'package:smart_parker/main/parker/overtime_screen.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/scan_model.dart';
import 'package:smart_parker/models/scanupdate_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class Assigment extends StatefulWidget {
  const Assigment({super.key, required this.parkingId});
  final int parkingId;

  @override
  State<Assigment> createState() => _AssigmentState();
}

class _AssigmentState extends State<Assigment> {
  String id = "0";

  bool isEmpty = true;

  bool isError = false;
  bool isLoad = true;
  SessionResponse session = SessionResponse();
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  DateTime now = DateTime.now();

  TextEditingController plate = TextEditingController();
  TextEditingController status = TextEditingController();

  ScanModel data = ScanModel();

  Future<void> _scanBarcode(bool isOrder) async {
    setState(() {
      now = DateTime.now();
      String minuteNowEdit = now.minute.toString().padLeft(2, '0');
      String hourNowEdit = now.hour.toString().padLeft(2, '0');
      formattedNow =
          "${DateFormat('yyyy-MM-dd').format(now)} ${hourNowEdit}:${minuteNowEdit}:00";
      isLoad = true;
      isEmpty = true;
    });
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        id = result.rawContent;
        get();
      });
    } catch (e) {}
  }

  Future<void> get() async {
    setState(() {
      error = "";
    });
    var res =
        await OrderController().scan(tokenSession: session.token ?? "", id: id);
    if (res.error == null) {
      setState(() {
        data = res.data as ScanModel;

        plate.text = data.payload!.lICENSEPLATE ?? "";
        status.text = data.payload!.sTATUS == "ONGOING"
            ? "Pembayaran selesai"
            : "Menunggu pembayaran";
        isLoad = false;
        isEmpty = false;
      });
    } else {
      setState(() {
        isLoad = false;
        error = res.error ?? "Error tidak diketahui";
      });
    }

    print(res.error);
  }

  String error = "";
  String formattedNow = "";

  Future<void> update() async {
    formattedNow =
        "${DateFormat('yyyy-MM-dd').format(now)} ${now.hour}:${now.minute}:00";
    setState(() {
      isLoad = true;
      isEmpty = true;
    });
    ScanUpdateModel scan = ScanUpdateModel();
    var res = await OrderController()
        .scanUpdate(tokenSession: session.token ?? "", id: id);
    if (res.error == null) {
      setState(() {
        scan = res.data as ScanUpdateModel;
      });
      if (scan.payload == true) {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OverTimeScreen(
                idOrder: id,
              ),
            ));
      }
      setState(() {
        data = ScanModel();
        plate.clear();
        status.clear();
        isLoad = false;
      });
    } else {
      setState(() {
        isLoad = false;
        error = res.error ?? "Error tidak diketahui";
      });
    }
  }

  void startActivity() async {
    await getSession();
    await _scanBarcode(true);
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Penugasan"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _scanBarcode(true);
          setState(() {
            isLoad = false;
          });
        },
        child: Icon(Icons.local_parking),
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != ""
              ? HomeWidget().error(
                  context: context,
                  error: error ??
                      "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan",
                  refresh: startActivity)
              : isEmpty
                  ? Center(child: Text("Klik scan untuk memulai"))
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: GetSizeScreen().paddingScreen),
                      child: Column(
                        children: [
                          outlineCard(
                            radius: 10,
                            context: context,
                            content: Padding(
                              padding:
                                  EdgeInsets.all(GetSizeScreen().paddingScreen),
                              child: Column(
                                children: [
                                  Text(
                                    "Detail Order Pengguna",
                                    style:
                                        fontStyleTitleH2DefaultColor(context),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    title: Text(
                                      "Rician Transaksi",
                                      style: fontStyleParagraftBoldDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      data.payload!.dATEUSERIN != null
                                          ? "Keluar"
                                          : "Masuk",
                                      style: TextStyle(
                                          color:
                                              data.payload!.dATEUSERIN != null
                                                  ? Colors.red
                                                  : Colors.green),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "ID Transaksi",
                                      style: fontStyleParagraftDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      data.payload!.tRXID ?? "-",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Nomor Polisi",
                                      style: fontStyleParagraftDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      data.payload!.lICENSEPLATE ?? "-",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Tanggal",
                                      style: fontStyleParagraftDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      DateHelper().formatDateToId(
                                          date: data.payload!.dATESTART ?? "-"),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Jam Mulai",
                                      style: fontStyleParagraftDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      data.payload!.dATESTART == null
                                          ? "Menunggu Pembayaran Berhasil"
                                          : TimeHelper().datetimeFormatToHAndM(
                                              data.payload!.dATESTART ?? "-"),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Jam Selesai",
                                      style: fontStyleParagraftDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      TimeHelper().datetimeFormatToHAndM(
                                          data.payload!.dATEEND ?? "-"),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Total Biaya",
                                      style: fontStyleParagraftBoldDefaultColor(
                                          context),
                                    ),
                                    trailing: Text(
                                      MoneyHelper.convertToIdrWithSymbol(
                                          count: data.payload!.aMOUNT ?? 0,
                                          decimalDigit: 2),
                                      style: TextStyle(
                                          color:
                                              data.payload!.sTATUS == "WAITINGP"
                                                  ? Colors.red
                                                  : Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 5,
                          ),
                          SizedBox(
                            width: GetSizeScreen().width(context),
                            child: buttonPrimaryWithColor(
                                context: context,
                                radius: 10,
                                ontap:
                                    data.payload!.pARKINGID! == widget.parkingId
                                        ? formattedNow.compareTo(
                                                    data.payload!.dATESTART!) >=
                                                0
                                            ? () {
                                                update();
                                              }
                                            : null
                                        : null,
                                content: data.payload!.pARKINGID! ==
                                        widget.parkingId
                                    ? formattedNow.compareTo(
                                                data.payload!.dATESTART!) >=
                                            0
                                        ? "Lanjutkan"
                                        : "Waktu tidak valid"
                                    : "Anda tidak memiliki akses order ini"),
                          ),
                          Spacer()
                        ],
                      )),
    );
  }
}
