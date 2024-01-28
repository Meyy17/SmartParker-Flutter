// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/parker/create_parking.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class ListParking extends StatefulWidget {
  const ListParking(
      {super.key, required this.onTapNavigateTo, required this.isPending});
  final Widget Function(dynamic param) onTapNavigateTo;
  final bool isPending;

  @override
  State<ListParking> createState() => _ListParkingState();
}

class _ListParkingState extends State<ListParking> {
  SessionResponse session = SessionResponse();
  ParkingLocationModel data = ParkingLocationModel();
  bool isLoad = true;
  String? error;

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> getParking() async {
    var res = await TrackLocationController().getByAuth(
      ispending: widget.isPending,
      tokenSession: session.token ?? "",
    );
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          data = res.data as ParkingLocationModel;
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
    setState(() {
      isLoad = true;
      error = null;
    });
    await getSession();
    if (session.isLog == true) {
      await getParking();
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
      appBar: appbarDefault(
          context: context,
          title: widget.isPending
              ? "Pengajuan parkir anda"
              : "List parkiran anda"),
      floatingActionButton: Visibility(
        visible: widget.isPending,
        child: InkWell(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateParking(
                    isEdit: false,
                    dataParkingOld: PayloadParkingLocation(),
                  ),
                ));
            startActivity();
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: GetTheme().primaryColor(context),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? HomeWidget().error(
                  context: context,
                  error: error ??
                      "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan",
                  refresh: startActivity)
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: GetSizeScreen().paddingScreen, vertical: 5),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: data.payload!.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => widget
                                    .onTapNavigateTo(data.payload![index].id!),
                              ));
                          startActivity();
                        },
                        child: outlineCard(
                            context: context,
                            content: Padding(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.5,
                                      child: Expanded(
                                        child: Image.network(
                                          data.payload![index]
                                                          .pKGBANNERBASE64 ==
                                                      null ||
                                                  data.payload![index]
                                                          .pKGBANNERBASE64 ==
                                                      ""
                                              ? ImageHelper().textPlaceholder(
                                                  text: data.payload![index]
                                                          .pKGNAME
                                                          ?.substring(0, 1) ??
                                                      "unknown")
                                              : "${Environtment().baseURLServer}/${data.payload![index].pKGBANNERBASE64}",
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Shimmer.fromColors(
                                                  baseColor: Colors.grey[200]!,
                                                  highlightColor: Colors.white,
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    color: Colors.black,
                                                  ));
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            "${Environtment().locationPngImage}error-image.png",
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                        child: Text(
                                      data.payload![index].pKGNAME ?? "",
                                      style:
                                          fontStyleTitleH3DefaultColor(context),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )),
                                  ],
                                )),
                            radius: 10),
                      ),
                    ),
                  ),
                ),
    );
  }
}
