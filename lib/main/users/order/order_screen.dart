// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_parker/controller/orderController/ordercontroller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/users/requestFlow/webview_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/order_model.dart';
import 'package:smart_parker/models/transaction_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/loginvalidate_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/tabbar_widget.dart';

class OrderUserScreen extends StatefulWidget {
  const OrderUserScreen({Key? key, required this.initialIndex})
      : super(key: key);
  final int initialIndex;

  @override
  State<OrderUserScreen> createState() => _OrderUserScreenState();
}

class _OrderUserScreenState extends State<OrderUserScreen> {
  bool isError = false;
  bool isLoad = true;
  SessionResponse session = SessionResponse();
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  OrderModelNew data = OrderModelNew();
  OrderModelNew dataDone = OrderModelNew();

  void startActivity() async {
    await getSession();
    var res = await OrderController()
        .getOrderOnGoing(tokenSession: session.token ?? "");
    if (res.error == null) {
      setState(() {
        data = res.data as OrderModelNew;
      });
    }
    var resDone =
        await OrderController().getOrderDone(tokenSession: session.token ?? "");
    if (resDone.error == null) {
      setState(() {
        dataDone = resDone.data as OrderModelNew;
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
        appBar: appbarDefault(context: context, title: "Riwayat Order"),
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
                              "On Going",
                              style: fontStyleSubtitleSemiBoldNonColor(context),
                            ),
                            Text(
                              "Selesai",
                              style: fontStyleSubtitleSemiBoldNonColor(context),
                            )
                          ]),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                isLoad
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () => getSession(),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: data.payload!.length,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                            height: 5,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                data.payload![index].sTATUS ==
                                                        "WAITINGP"
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PaymentGatewayWebView(
                                                                  urlWebsite: data
                                                                          .payload![
                                                                              index]
                                                                          .xenditUrl ??
                                                                      ""),
                                                        ))
                                                    : showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                              content: SizedBox(
                                                                width: GetSizeScreen()
                                                                    .width(
                                                                        context),
                                                                height: GetSizeScreen()
                                                                    .width(
                                                                        context),
                                                                child:
                                                                    QrImageView(
                                                                  data:
                                                                      '${data.payload![index].id}',
                                                                  version:
                                                                      QrVersions
                                                                          .auto,
                                                                  size: 200.0,
                                                                ),
                                                              ),
                                                            ));
                                              },
                                              child: outlineCard(
                                                  context: context,
                                                  content: ListTile(
                                                    title: Text(
                                                      "${data.payload![index].iNFO}",
                                                      style:
                                                          fontStyleTitleH3DefaultColor(
                                                              context),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${data.payload![index].dATESTART ?? "Menunggu pembayaran tunai"} - ${data.payload![index].dATEEND}",
                                                          style:
                                                              fontStyleSubtitleDefaultColor(
                                                                  context),
                                                        ),
                                                        Text(
                                                          data.payload![index]
                                                                      .sTATUS ==
                                                                  "WAITINGP"
                                                              ? "Tekan untuk melakukan pembayaran"
                                                              : data.payload![index]
                                                                          .dATEUSERIN !=
                                                                      null
                                                                  ? "Tekan untuk Scan Keluar"
                                                                  : "Tekan untuk Scan Masuk",
                                                          style:
                                                              fontStyleSubtitleDefaultColor(
                                                                  context),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  radius: 10),
                                            );
                                          },
                                        ),
                                      ),
                                // Tab 2 (Selesai)
                                isLoad
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () => getSession(),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: dataDone.payload!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return outlineCard(
                                                context: context,
                                                content: ListTile(
                                                  title: Text(
                                                    "${dataDone.payload![index].iNFO}",
                                                    style:
                                                        fontStyleTitleH3DefaultColor(
                                                            context),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${dataDone.payload![index].dATESTART ?? "Pembayaran belum selesai"} - ${dataDone.payload![index].dATEEND}",
                                                        style:
                                                            fontStyleSubtitleDefaultColor(
                                                                context),
                                                      ),
                                                      Text(
                                                        "${dataDone.payload![index].sTATUS}",
                                                        style:
                                                            fontStyleSubtitleDefaultColor(
                                                                context),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                radius: 10);
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
