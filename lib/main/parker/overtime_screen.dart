import 'package:flutter/material.dart';
import 'package:smart_parker/controller/orderController/ordercontroller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/date_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/helper/time_helper.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/overtime_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class OverTimeScreen extends StatefulWidget {
  const OverTimeScreen({super.key, required this.idOrder});
  final String idOrder;

  @override
  State<OverTimeScreen> createState() => _OverTimeScreenState();
}

class _OverTimeScreenState extends State<OverTimeScreen> {
  bool isEmpty = true;

  bool isError = false;
  bool isLoad = true;
  SessionResponse session = SessionResponse();
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  DateTime now = DateTime.now();

  OverTimeModel data = OverTimeModel();

  Future<void> get() async {
    setState(() {
      error = "";
    });
    var res = await OrderController()
        .overtime(tokenSession: session.token ?? "", id: widget.idOrder);
    if (res.error == null) {
      setState(() {
        data = res.data as OverTimeModel;

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

  // Future<void> update() async {
  //   formattedNow =
  //       "${DateFormat('yyyy-MM-dd').format(now)} ${now.hour}:${now.minute}:00";
  //   setState(() {
  //     isLoad = true;
  //     isEmpty = true;
  //   });
  //   ScanUpdateModel scan = ScanUpdateModel();
  //   var res = await OrderController()
  //       .scanUpdate(tokenSession: session.token ?? "", id: id);
  //   if (res.error == null) {
  //     setState(() {
  //       scan = res.data as ScanUpdateModel;
  //     });
  //     if (scan.payload == true) {
  //       await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OverTimeScreen(
  //               idOrder: id,
  //             ),
  //           ));
  //     }
  //     setState(() {
  //       data = ScanModel();
  //       plate.clear();
  //       status.clear();
  //       isLoad = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoad = false;
  //       error = res.error ?? "Error tidak diketahui";
  //     });
  //   }
  // }

  void startActivity() async {
    await getSession();
    await get();
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
      appBar: appbarDefault(context: context, title: "Overtime"),
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
                  ? Center(child: Text("Tidak ada data"))
                  : SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: GetSizeScreen().paddingScreen),
                          child: Column(
                            children: [
                              outlineCard(
                                radius: 10,
                                context: context,
                                content: Padding(
                                  padding: EdgeInsets.all(
                                      GetSizeScreen().paddingScreen),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Rician Tagihan Kelebihan Waktu",
                                        style: fontStyleTitleH2DefaultColor(
                                            context),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        title: Text(
                                          "Rician Transaksi",
                                          style:
                                              fontStyleParagraftBoldDefaultColor(
                                                  context),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "ID Transaksi",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          data.payload!.trxData!.tRXID ?? "-",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Nomor Polisi",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          data.payload!.trxData!.lICENSEPLATE ??
                                              "-",
                                          style: const TextStyle(
                                              color: Colors.black),
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
                                              date: data.payload!.trxData!
                                                      .dATESTART ??
                                                  "-"),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Jam Mulai",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          data.payload!.trxData!.dATESTART ==
                                                  null
                                              ? "Menunggu Pembayaran Berhasil"
                                              : TimeHelper()
                                                  .datetimeFormatToHAndM(data
                                                          .payload!
                                                          .trxData!
                                                          .dATESTART ??
                                                      "-"),
                                          style: const TextStyle(
                                              color: Colors.black),
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
                                              data.payload!.trxData!.dATEEND ??
                                                  "-"),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Total Biaya",
                                          style:
                                              fontStyleParagraftBoldDefaultColor(
                                                  context),
                                        ),
                                        trailing: Text(
                                          MoneyHelper.convertToIdrWithSymbol(
                                              count: data.payload!.aMOUNT ?? 0,
                                              decimalDigit: 2),
                                          style: TextStyle(
                                              color: data.payload!.sTATUS ==
                                                      "WAITINGP"
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        title: Text(
                                          "Kelebihan Waktu",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          "${TimeHelper().datetimeFormatToHAndM(data.payload!.trxData!.dATESTART ?? "-")} - ${TimeHelper().datetimeFormatToHAndM(data.payload!.trxData!.dATEEND ?? "-")}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Total waktu kelebihan",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          "${data.payload!.iNTERVAL} x 15 menit",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Total harga kelebihan",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          "${data.payload!.iNTERVAL} x ${MoneyHelper.convertToIdrWithSymbol(count: data.payload!.trxData!.fEE, decimalDigit: 2)}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        title: Text(
                                          "Denda",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          "${data.payload!.dENDA}%",
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          "Total",
                                          style: fontStyleParagraftDefaultColor(
                                              context),
                                        ),
                                        trailing: Text(
                                          "${MoneyHelper.convertToIdrWithSymbol(count: data.payload!.aMOUNT, decimalDigit: 2)}",
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: GetSizeScreen().width(context),
                                child: buttonPrimaryWithColor(
                                    context: context,
                                    radius: 10,
                                    ontap: data.payload!.sTATUS! == "ONGOING"
                                        ? () {
                                            // update();
                                          }
                                        : null,
                                    content: "Lanjutkan"),
                              ),
                            ],
                          )),
                    ),
    );
  }
}
