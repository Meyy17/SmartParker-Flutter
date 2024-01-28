// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parker/controller/orderController/ordercontroller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/main/parker/assigment_screen.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/assigment_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:location/location.dart' as device_location;
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class ScanSetup extends StatefulWidget {
  const ScanSetup({super.key});

  @override
  State<ScanSetup> createState() => _ScanSetupState();
}

class _ScanSetupState extends State<ScanSetup> {
  bool isLoad = true;
  String? error;
  String selectedValue = "Mobil";
  MapController mapController = MapController();
  TextEditingController plateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SessionResponse session = SessionResponse();
  PenugasanModel data = PenugasanModel();
  device_location.Location location = device_location.Location();
  late device_location.LocationData currentLocation;
  double latDestination = -6.989820;
  double longDestination = 110.422315;

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> get() async {
    var res = await OrderController().scanSetup(
        tokenSession: session.token ?? "",
        latitude: currentLocation.latitude.toString(),
        longitude: currentLocation.longitude.toString());
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          data = res.data as PenugasanModel;
          latDestination = double.parse(data.payload!.lATITUDE ?? "0");
          longDestination = double.parse(data.payload!.lONGITUDE ?? "0");
          error = null;
        });
      } else {
        setState(() {
          error = res.error;
        });
      }
    }
  }

  Future<void> getCurrentLocation() async {
    if (!mounted) return;

    if (await Permission.location.isGranted) {
      try {
        if (!mounted) return;
        var userLocation = await location.getLocation();
        setState(() {
          currentLocation = userLocation;

          //DEVELOPMENT DISINI
          // currentLocation = device_location.LocationData.fromMap({
          //   "latitude": Environtment().latitudeDev,
          //   "longitude": Environtment().longitudeDev,
          // });
        });
      } catch (e) {
        if (!mounted) return;
        failedSnackbar(
            context: context,
            title: "Gagal memuat lokasi",
            message:
                "Maaf terjadi kesalahan dalam mengambil lokasi, silahkan coba lagi dan pastikan gps dalam kondisi aktif");
      }
    } else {
      await Permission.location.request();
    }
  }

  Future<void> startActivity() async {
    setState(() {
      isLoad = true;
      error = null;
    });
    await getSession();
    await getCurrentLocation();
    if (session.isLog == true) {
      await get();
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
      appBar: appbarDefault(context: context, title: "Mulai Bertugas"),
      body: isLoad
          ? const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Mencari lokasi parkir penugasan anda")
                ],
              ),
            )
          : error != null
              ? HomeWidget().error(
                  context: context, error: error ?? "-", refresh: startActivity)
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: GetSizeScreen().width(context),
                              height: GetSizeScreen().height(context) * 0.2,
                              child: FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  initialCenter: LatLng(
                                      currentLocation.latitude ?? 0,
                                      currentLocation.longitude ?? 0),
                                  initialZoom: 16.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  MarkerLayer(markers: [
                                    Marker(
                                      point: LatLng(
                                          currentLocation.latitude ?? 0,
                                          currentLocation.longitude ?? 0),
                                      child: const Icon(
                                        HomeScreenUserIcon.location,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Marker(
                                      point: LatLng(
                                          latDestination, longDestination),
                                      child: const Icon(
                                        HomeScreenUserIcon.location,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: GetSizeScreen().paddingScreen,
                          ),
                          outlineCard(
                              context: context,
                              radius: 10,
                              content: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Penugasan terdekat dari lokasimu :",
                                      style:
                                          fontStyleSubtitleSemiBoldDefaultColor(
                                              context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: GetTheme()
                                                .cardColorGreyDark(context),
                                          ),
                                          child: Icon(
                                            HomeScreenUserIcon.location,
                                            color:
                                                GetTheme().fontColor(context),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          data.payload!.pKGNAME ?? "-",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: GetTheme()
                                                .cardColorGreyDark(context),
                                          ),
                                          child: Icon(
                                            HomeScreenUserIcon.location,
                                            color:
                                                GetTheme().fontColor(context),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          data.payload!.pKGSTREET ?? "",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: GetTheme()
                                                .cardColorGreyDark(context),
                                          ),
                                          child: Icon(
                                            Icons.car_repair,
                                            color: data.payload!
                                                        .countAvaliableCar! >
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "${data.payload!.countAvaliableCar} Tersedia / ${data.payload!.countTotalCar} Slot parkir mobil",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: GetTheme()
                                                .cardColorGreyDark(context),
                                          ),
                                          child: Icon(
                                            Icons.motorcycle,
                                            color: data.payload!
                                                        .countAvaliableMotor! >
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "${data.payload!.countAvaliableMotor} Tersedia / ${data.payload!.countTotalMotor} Slot parkir motor",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: GetTheme()
                                                .cardColorGreyDark(context),
                                          ),
                                          child: Icon(
                                            Icons.money,
                                            color:
                                                GetTheme().fontColor(context),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          data.payload!.fEE! > 0
                                              ? "${MoneyHelper.convertToIdrWithSymbol(count: data.payload!.fEE, decimalDigit: 2)} /15 Menit"
                                              : "Gratis",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: buttonPrimaryWithColor(
                            context: context,
                            radius: 10,
                            ontap: data.message == true
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Assigment(
                                              parkingId: data.payload!.id ?? 0),
                                        ));
                                  }
                                : null,
                            content: data.message == true
                                ? "Lanjutkan"
                                : "Lokasi Diluar Jangkauan"),
                      )
                    ],
                  ),
                ),
    );
  }
}
