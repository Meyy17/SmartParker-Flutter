// ignore_for_file: must_be_immutable, library_prefixes, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:smart_parker/controller/userController/favorite_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/device_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/main/parker/create_parking.dart';
import 'package:smart_parker/main/users/requestFlow/request_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/favorite_model.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key, required this.idParking});
  final int idParking;

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  bool isLoadParking = true;
  bool isLoadRating = true;
  bool isFavorite = false;

  String? isErrorGetParking;
  PayloadParkingLocation parkingData = PayloadParkingLocation();
  SessionResponse session = SessionResponse();
  MapController mapController = MapController();
  //Socket
  IO.Socket? socket;
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  void update() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CreateParking(isEdit: true, dataParkingOld: parkingData),
        ));
    startActivity();
  }

  void delete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Perhatian",
          style: fontStyleTitleH3DefaultColor(context),
        ),
        content: Text(
          "Apakah anda yakin untuk menghapus lokasi parkir ini?",
          style: fontStyleSubtitleDefaultColor(context),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tidak")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteLocation(parkingData.id.toString());
              },
              child: const Text("Ya"))
        ],
      ),
    );
  }

  void order() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Pilih pembayaran",
          style: fontStyleTitleH3DefaultColor(context),
        ),
        content: IntrinsicHeight(
          child: Column(
            children: [
              ListTile(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestScreen(
                            parkingData: parkingData,
                            isTransfer: true,
                          ),
                        ));
                    startActivity();
                  },
                  title: Text(
                    " - Transfer (Support Booking)",
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  )),
              ListTile(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestScreen(
                            parkingData: parkingData,
                            isTransfer: false,
                          ),
                        ));
                    startActivity();
                  },
                  title: Text(
                    " - Tunai",
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToFavorite(int headerParkingId) async {
    String idDevice = await DeviceHelper().getDeviceId();
    var res = await FavoriteUserController().create(
        dvcId: idDevice,
        tokenSession: session.isLog == true ? session.token : null,
        headerParking: headerParkingId);
    if (res.error == null) {
      AddFavoriteModel responseAddFav = AddFavoriteModel();
      setState(() {
        responseAddFav = res.data as AddFavoriteModel;
        isFavorite = responseAddFav.payload ?? false;
      });
      successSnackbar(
          context: context,
          title: "Berhasil",
          message: responseAddFav.message ?? "Berhasil melakukan action");
    } else {
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: res.error ??
              "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
    }
  }

  Future<void> deleteLocation(String headerParkingId) async {
    setState(() {
      isLoadParking = true;
    });
    var res = await TrackLocationController()
        .deleteLocation(tokenSession: session.token ?? "", id: headerParkingId);
    if (res.error == null) {
      Navigator.pop(context);
      successSnackbar(
          context: context,
          title: "Berhasil",
          message: "Berhasil menghapus lokasi parkir");
    } else {
      setState(() {
        isLoadParking = false;
      });
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: res.error ??
              "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
    }
  }

  Future<void> validateFav(int headerParkingId) async {
    String idDevice = await DeviceHelper().getDeviceId();
    var res = await FavoriteUserController().validate(
        dvcId: idDevice,
        tokenSession: session.isLog == true ? session.token : null,
        headerParking: headerParkingId);
    if (res.error == null) {
      setState(() {
        isFavorite = res.data as bool;
      });
    } else {
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: res.error ??
              "Kesalahan tidak diketahui, harap coba kembali atau hubungi bantuan jika masalah berkelanjutan");
    }
  }

  bool isOpen = false;

  Future<void> getParking() async {
    var res = await TrackLocationController()
        .getDetailParking(idParking: widget.idParking);
    if (res.error == null) {
      setState(() {
        isLoadParking = false;
        parkingData = res.data as PayloadParkingLocation;

        DateTime now = DateTime.now();
        DateTime waktuDariString = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parkingData.pKGOPENTIME!.split(":")[0]),
            int.parse(parkingData.pKGOPENTIME!.split(":")[1]),
            int.parse(parkingData.pKGOPENTIME!.split(":")[2]));
        DateTime waktuDariStringClose = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parkingData.pKGCLOSETIME!.split(":")[0]),
            int.parse(parkingData.pKGCLOSETIME!.split(":")[1]),
            int.parse(parkingData.pKGCLOSETIME!.split(":")[2]));

        isOpen = waktuDariString.isBefore(DateTime.now()) &&
            waktuDariStringClose.isAfter(DateTime.now());

        socket!.on('track-${widget.idParking}', (data) {
          if (data is Map<String, dynamic>) {
            if (data.containsKey("motorTotal") &&
                data.containsKey("motorAvaliable") &&
                data.containsKey("carTotal") &&
                data.containsKey("carAvaliable")) {
              int motorTotal = data["motorTotal"];
              int motorAvaliable = data["motorAvaliable"];
              int carTotal = data["carTotal"];
              int carAvaliable = data["carAvaliable"];
              setState(() {
                parkingData.countAvaliableCar = carAvaliable;
                parkingData.countTotalCar = carTotal;
                parkingData.countAvaliableMotor = motorAvaliable;
                parkingData.countTotalMotor = motorTotal;
              });
            }
          }
        });
      });
    } else {
      setState(() {
        isErrorGetParking = res.error;
        isLoadParking = false;
      });
    }
  }

  void startActivity() async {
    connectSocket();

    await getSession();
    getParking();
    validateFav(widget.idParking);
  }

  Future<void> connectSocket() async {
    socket = IO.io(Environtment().baseURLServer, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.connect();
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  @override
  void dispose() {
    socket!.off('track-${widget.idParking}');
    socket!.disconnect();
    socket!.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarDefault(
            context: context,
            title:
                isLoadParking ? "Loading..." : parkingData.pKGNAME.toString()),
        body: isErrorGetParking != null
            ? Center(
                child: Column(
                  children: [
                    const Text("Terjadi kesalahan"),
                    Text(isErrorGetParking ?? "")
                  ],
                ),
              )
            : isLoadParking
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: GetSizeScreen().paddingScreen,
                          vertical: GetSizeScreen().paddingScreen),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "${Environtment().baseURLServer}/${parkingData.pKGBANNERBASE64.toString()}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: GetSizeScreen().height(context) * 0.2,
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
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: FlutterMap(
                                                mapController: mapController,
                                                options: MapOptions(
                                                  initialCenter: LatLng(
                                                      double.parse(parkingData
                                                              .lATITUDE ??
                                                          "0"),
                                                      double.parse(parkingData
                                                              .lONGITUDE ??
                                                          "0")),
                                                  initialZoom: 16.0,
                                                ),
                                                children: [
                                                  TileLayer(
                                                    urlTemplate:
                                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                    userAgentPackageName:
                                                        'com.example.app',
                                                  ),
                                                  MarkerLayer(markers: [
                                                    Marker(
                                                      point: LatLng(
                                                          double.parse(parkingData
                                                                  .lATITUDE ??
                                                              "0"),
                                                          double.parse(parkingData
                                                                  .lONGITUDE ??
                                                              "0")),
                                                      child: const Icon(
                                                        HomeScreenUserIcon
                                                            .location,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ])
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              child: Text(
                                            parkingData.pKGSTREET ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: fontStyleTitleH3DefaultColor(
                                                context),
                                          )),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                visible: session.asUser == true,
                                                child: InkWell(
                                                    onTap: () {
                                                      addToFavorite(
                                                          parkingData.id ?? 0);
                                                    },
                                                    child: Icon(
                                                      Icons.save,
                                                      color: isFavorite
                                                          ? GetTheme()
                                                              .primaryColor(
                                                                  context)
                                                          : GetTheme()
                                                              .unselectedWidget(
                                                                  context),
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(),
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
                                          parkingData.pKGNAME ?? "-",
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
                                          parkingData.pKGSTREET ?? "",
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
                                            color:
                                                parkingData.countAvaliableCar! >
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
                                          "${parkingData.countAvaliableCar} Tersedia / ${parkingData.countTotalCar} Slot parkir mobil",
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
                                            color: parkingData
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
                                          "${parkingData.countAvaliableMotor} Tersedia / ${parkingData.countTotalMotor} Slot parkir motor",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Row(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.center,
                                    //   children: [
                                    //     Container(
                                    //       padding: const EdgeInsets.all(3),
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(5),
                                    //         color: GetTheme()
                                    //             .cardColorGreyDark(context),
                                    //       ),
                                    //       child: Icon(
                                    //         Icons.lock_clock,
                                    //         color:
                                    //             GetTheme().fontColor(context),
                                    //       ),
                                    //     ),
                                    //     const SizedBox(
                                    //       width: 10,
                                    //     ),
                                    //     Expanded(
                                    //         child: Text(
                                    //       "Buka : 07:00 - 22:00",
                                    //       style:
                                    //           fontStyleSubtitleSemiBoldDefaultColor(
                                    //               context),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //     ))
                                    //   ],
                                    // ),
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
                                          parkingData.fEE! > 0
                                              ? "${MoneyHelper.convertToIdrWithSymbol(count: parkingData.fEE, decimalDigit: 2)} /15 Menit"
                                              : "Gratis",
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
                                            Icons.event_available,
                                            color:
                                                parkingData.sTATUS == "ACTIVE"
                                                    ? isOpen
                                                        ? Colors.green
                                                        : Colors.red
                                                    : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          parkingData.sTATUS == "PENDING"
                                              ? "Dalam pengajuan"
                                              : parkingData.sTATUS == "ACTIVE"
                                                  ? isOpen
                                                      ? "${parkingData.pKGOPENTIME} - ${parkingData.pKGCLOSETIME}"
                                                      : "${parkingData.pKGOPENTIME} - ${parkingData.pKGCLOSETIME}"
                                                  : "Tutup",
                                          style:
                                              fontStyleSubtitleSemiBoldDefaultColor(
                                                  context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: isOpen == false,
                                      child: Text(
                                          "Note : Untuk saat ini hanya tersedia untuk booking"),
                                    ),
                                    Visibility(
                                        visible: session.isLog == true,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            session.asUser == true
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 30,
                                                          child:
                                                              buttonPrimaryWithColor(
                                                                  context:
                                                                      context,
                                                                  radius: 5,
                                                                  ontap: parkingData
                                                                              .sTATUS ==
                                                                          "ACTIVE"
                                                                      ? () {
                                                                          order();
                                                                        }
                                                                      : null,
                                                                  content:
                                                                      "Order & Booking"),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 30,
                                                          child: buttonPrimary(
                                                              context: context,
                                                              radius: 5,
                                                              ontap: () {
                                                                delete();
                                                              },
                                                              content: parkingData
                                                                          .sTATUS ==
                                                                      "PENDING"
                                                                  ? "Batalkan"
                                                                  : "Hapus"),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 30,
                                                          child:
                                                              buttonPrimaryWithColor(
                                                                  context:
                                                                      context,
                                                                  radius: 5,
                                                                  ontap: () {
                                                                    update();
                                                                  },
                                                                  content:
                                                                      "Edit"),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    //For Update V2
                                    // Text(
                                    //   "Review & Rating",
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style:
                                    //       fontStyleTitleH3DefaultColor(context),
                                    // ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    // ListView.separated(
                                    //   shrinkWrap: true,
                                    //   physics:
                                    //       const NeverScrollableScrollPhysics(),
                                    //   itemCount: 5,
                                    //   separatorBuilder:
                                    //       (BuildContext context, int index) {
                                    //     return const SizedBox(
                                    //       height: 5,
                                    //     );
                                    //   },
                                    //   itemBuilder:
                                    //       (BuildContext context, int index) {
                                    //     return Row(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         ClipRRect(
                                    //           borderRadius:
                                    //               BorderRadius.circular(100),
                                    //           child: isLoadRating
                                    //               ? Shimmer.fromColors(
                                    //                   baseColor:
                                    //                       Colors.grey[200]!,
                                    //                   highlightColor:
                                    //                       Colors.white,
                                    //                   child: Container(
                                    //                     width: 40,
                                    //                     height: 40,
                                    //                     color: Colors.black,
                                    //                   ))
                                    //               : Image.network(
                                    //                   "${Environtment().baseURLServer}/img/users-profile/aqil.png",
                                    //                   fit: BoxFit.cover,
                                    //                   width: 40,
                                    //                   height: 40,
                                    //                   loadingBuilder: (context,
                                    //                       child,
                                    //                       loadingProgress) {
                                    //                     if (loadingProgress ==
                                    //                         null) {
                                    //                       return child;
                                    //                     } else {
                                    //                       return Shimmer
                                    //                           .fromColors(
                                    //                               baseColor:
                                    //                                   Colors.grey[
                                    //                                       200]!,
                                    //                               highlightColor:
                                    //                                   Colors
                                    //                                       .white,
                                    //                               child:
                                    //                                   Container(
                                    //                                 width: 40,
                                    //                                 height: 40,
                                    //                                 color: Colors
                                    //                                     .black,
                                    //                               ));
                                    //                     }
                                    //                   },
                                    //                   errorBuilder: (context,
                                    //                           error,
                                    //                           stackTrace) =>
                                    //                       Image.asset(
                                    //                     "${Environtment().locationPngImage}error-image.png",
                                    //                     fit: BoxFit.cover,
                                    //                     width: 40,
                                    //                     height: 40,
                                    //                   ),
                                    //                 ),
                                    //         ),
                                    //         const SizedBox(
                                    //           width: 10,
                                    //         ),
                                    //         Expanded(
                                    //           child: Column(
                                    //             crossAxisAlignment:
                                    //                 CrossAxisAlignment.start,
                                    //             children: [
                                    //               Text(
                                    //                 "AJAX SAIFUL",
                                    //                 style:
                                    //                     fontStyleTitleH3DefaultColor(
                                    //                         context),
                                    //               ),
                                    //               Text(
                                    //                 "Jelek Bangett anjayyy masa pas disana gw ketemu gayyyy gwww takuuttttt sumpahh ga recomended",
                                    //                 style:
                                    //                     fontStyleSubtitleDefaultColor(
                                    //                         context),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ));
  }
}
