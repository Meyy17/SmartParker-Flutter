// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_parker/controller/orderController/ordercontroller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/order_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/loginvalidate_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/tabbar_widget.dart';

class BillUserScreen extends StatefulWidget {
  const BillUserScreen({Key? key, required this.initialIndex})
      : super(key: key);
  final int initialIndex;

  @override
  State<BillUserScreen> createState() => _BillUserScreenState();
}

class _BillUserScreenState extends State<BillUserScreen> {
  double persentaseDenda = 0.2;
  DateTime now = DateTime.now();
  bool isError = false;
  bool isLoad = true;
  SessionResponse session = SessionResponse();
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  OrderModelNew dataOvertime = OrderModelNew();

  void startActivity() async {
    await getSession();
    var res = await OrderController()
        .getOrderOvertime(tokenSession: session.token ?? "");
    if (res.error == null) {
      setState(() {
        dataOvertime = res.data as OrderModelNew;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarDefault(context: context, title: "Tagihan pengguna"),
        body: isLoad
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : session.isLog ?? true
                ? DefaultTabController(
                    length: 2,
                    initialIndex: widget.initialIndex,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: GetSizeScreen().paddingScreen),
                      child: Column(
                        children: [
                          tabbarPrimary(context: context, tabs: [
                            Text(
                              "Belum bayar",
                              style: fontStyleSubtitleSemiBoldNonColor(context),
                            ),
                            Text(
                              "Terbayar",
                              style: fontStyleSubtitleSemiBoldNonColor(context),
                            )
                          ]),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                RefreshIndicator(
                                  onRefresh: () => getSession(),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: dataOvertime.payload!.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 5,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String dateEnd = dataOvertime
                                          .payload![index].dATEEND
                                          .toString();

                                      int intervals =
                                          calculate15MinuteIntervals(dateEnd);

                                      int resultOld = intervals *
                                          int.parse(dataOvertime
                                              .payload![index].fee
                                              .toString());

                                      double result =
                                          resultOld + resultOld * persentaseDenda;

                                      // int totalBill = (intervals * dataOvertime
                                      //         .payload![index].fee).toInt() + additionalFee.toInt();

                                      return outlineCard(
                                          context: context,
                                          content: ListTile(
                                            title: Text(
                                              "Ovetime ${dataOvertime.payload![index].iNFO}",
                                              style:
                                                  fontStyleTitleH3DefaultColor(
                                                      context),
                                            ),
                                            subtitle: Text(
                                              "${formatDateToHourMinute(dataOvertime.payload![index].dATEEND.toString())} -> ${formatDateToHourMinute(now.toString())}\n ${MoneyHelper.convertToIdrWithSymbol(count: result, decimalDigit: 2)} $intervals",
                                              style:
                                                  fontStyleSubtitleDefaultColor(
                                                      context),
                                            ),
                                          ),
                                          radius: 10);
                                    },
                                  ),
                                ),
                                // Tab 2 (Selesai)
                                RefreshIndicator(
                                  onRefresh: () => getSession(),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text("Selesai: index $index");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : loginValidate(
                    context: context, hPadding: true, vPadding: false));
  }
}

int calculate15MinuteIntervals(String dateEnd) {
  DateTime endDateTime = DateTime.parse(dateEnd);

  DateTime now = DateTime.now();

  Duration difference = now.difference(endDateTime);

  int intervals = (difference.inMinutes / 15).ceil();

  return intervals;
}

String formatDateToHourMinute(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('HH:mm').format(dateTime);
  return formattedDate;
}
