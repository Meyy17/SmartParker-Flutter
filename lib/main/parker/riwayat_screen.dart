import 'package:flutter/material.dart';
import 'package:smart_parker/controller/orderController/ordercontroller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/order_model.dart';
import 'package:smart_parker/models/transaction_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class RiwayatPrking extends StatefulWidget {
  const RiwayatPrking({super.key, required this.idParking});
  final int idParking;

  @override
  State<RiwayatPrking> createState() => _RiwayatPrkingState();
}

class _RiwayatPrkingState extends State<RiwayatPrking> {
  bool isError = false;
  bool isLoad = true;
  SessionResponse session = SessionResponse();
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  OrderModelNew data = OrderModelNew();

  void startActivity() async {
    await getSession();
    var res = await OrderController().getOrderRiwayat(
        tokenSession: session.token ?? "",
        idParking: widget.idParking.toString());
    if (res.error == null) {
      setState(() {
        data = res.data as OrderModelNew;
        isLoad = false;
      });
    }
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Riwayat Transaksi"),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: data.payload!.length > 0
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        DataTable(
                            horizontalMargin: 0,
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                  label: Expanded(
                                child: Text('Tanggal',
                                    style:
                                        fontStyleTitleH3DefaultColor(context)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Text('Mulai - Selesai',
                                    style:
                                        fontStyleTitleH3DefaultColor(context)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Text('Total',
                                    style:
                                        fontStyleTitleH3DefaultColor(context)),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Text('Status',
                                    style:
                                        fontStyleTitleH3DefaultColor(context)),
                              )),
                            ],
                            rows: List.generate(
                                data.payload!.length,
                                (index) => DataRow(cells: [
                                      DataCell(Expanded(
                                          child: Text(
                                              data.payload![index].createdAt ??
                                                  "-",
                                              style:
                                                  fontStyleSubtitleDefaultColor(
                                                      context)))),
                                      DataCell(Expanded(
                                          child: Text(
                                              "${data.payload![index].dATESTART ?? "-"} - ${data.payload![index].dATEEND ?? "-"}",
                                              style:
                                                  fontStyleSubtitleDefaultColor(
                                                      context)))),
                                      DataCell(Expanded(
                                          child: Text(
                                              MoneyHelper
                                                  .convertToIdrWithSymbol(
                                                      count: data
                                                          .payload![index]
                                                          .aMOUNT,
                                                      decimalDigit: 2),
                                              style:
                                                  fontStyleSubtitleDefaultColor(
                                                      context)))),
                                      DataCell(Expanded(
                                          child: Text(
                                              data.payload![index].sTATUS ??
                                                  "-",
                                              style:
                                                  fontStyleSubtitleDefaultColor(
                                                      context)))),
                                    ])))
                      ],
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum ada riwayat...",
                          ),
                        ],
                      ),
                    )),
    );
  }
}
