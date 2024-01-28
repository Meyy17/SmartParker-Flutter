// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart' as geocoding_location;
import 'package:intl/intl.dart';
import 'package:location/location.dart' as device_location;
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parker/controller/auth/auth_controller.dart';
import 'package:smart_parker/controller/parkerController/tracklocation_service.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/main/users/home/home_widget.dart';
import 'package:smart_parker/main/users/order/order_screen.dart';
import 'package:smart_parker/main/users/parking/parking_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/parking_model.dart';
import 'package:smart_parker/models/user_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../widget/snackbar_widget.dart';
import '../maps/map_screen.dart';

class HomeScreenUsers extends StatefulWidget {
  const HomeScreenUsers({super.key});

  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers> {
  bool emptyPayload = true;
  bool isLoadProfile = true;
  bool isLoadParking = true;
  bool isLoadFreeParking = true;
  String? isErrorGetParking;
  String? isErrorGetFreeParking;
  UserModel usersData = UserModel();
  String locationName = "Sedang memuat lokasi saat ini...";
  List<AnimatedText> recomendationList = [
    TyperAnimatedText('Mau kemana hari ini?',
        textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xff4B4B4B))),
  ];

  ParkingLocationModel parkingData = ParkingLocationModel();
  ParkingLocationModel freeParkingData = ParkingLocationModel();

  device_location.Location location = device_location.Location();
  late device_location.LocationData currentLocation;
  SessionResponse session = SessionResponse();

  //Socket
  IO.Socket? socket;

  Future<void> getParking() async {
    //Mode DEV
    var res = await TrackLocationController().trackLocationParkingByLatLong(
        distance: 150,
        latitude: currentLocation.latitude.toString(),
        longtitude: currentLocation.longitude.toString(),
        filterFree: false);
    if (res.error == null) {
      setState(() {
        isLoadParking = false;
        parkingData = res.data as ParkingLocationModel;
        if (parkingData.payload!.isNotEmpty) {
          setState(() {
            emptyPayload = false;
          });
        }
        for (PayloadParkingLocation payload in parkingData.payload!) {
          socket!.on('track-${payload.id}', (data) {
            if (data is Map<String, dynamic>) {
              if (data.containsKey("motorTotal") &&
                  data.containsKey("motorAvaliable") &&
                  data.containsKey("carTotal") &&
                  data.containsKey("carAvaliable")) {
                int motorTotal = data["motorTotal"];
                int motorAvaliable = data["motorAvaliable"];
                int carTotal = data["carTotal"];
                int carAvaliable = data["carAvaliable"];
                updateParkingData(
                    idToUpdate: payload.id ?? 0,
                    motorCountAvaliable: motorAvaliable,
                    motorCountTotal: motorTotal,
                    carCountAvaliable: carAvaliable,
                    carCountTotal: carTotal);
              }
            }
          });
        }
        if (recomendationList.length < 5) {
          for (PayloadParkingLocation payload in parkingData.payload!) {
            if (recomendationList.length < 5) {
              if (payload.pKGNAME != null || payload.pKGNAME != "") {
                AnimatedText text = TyperAnimatedText(payload.pKGNAME ?? "",
                    textStyle: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4B4B4B)));

                recomendationList.add(text);
              }
            }
          }
        }
      });
    } else {
      setState(() {
        isErrorGetParking = res.error;
        isLoadParking = false;
      });
    }
  }

  Future<void> getFreeParking() async {
    //Mode DEV
    var res = await TrackLocationController().trackLocationParkingByLatLong(
        distance: 150,
        latitude: currentLocation.latitude.toString(),
        longtitude: currentLocation.longitude.toString(),
        filterFree: true);
    if (res.error == null) {
      setState(() {
        isLoadFreeParking = false;
        freeParkingData = res.data as ParkingLocationModel;
        if (recomendationList.length < 5) {
          for (PayloadParkingLocation payload in freeParkingData.payload!) {
            if (recomendationList.length < 5) {
              if (payload.pKGNAME != null || payload.pKGNAME != "") {
                AnimatedText text = TyperAnimatedText(payload.pKGNAME ?? "",
                    textStyle: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4B4B4B)));

                recomendationList.add(text);
              }
            }
          }
        }
      });
    } else {
      setState(() {
        isErrorGetFreeParking = res.error;
        isLoadFreeParking = false;
      });
    }
  }

  Future<void> getCurrentLocation() async {
    if (!mounted) return;
    // setState(() {
    //   locationName = "Sedang memuat lokasi saat ini...";

    //   //Masih belum fix sepenihnya
    //   if (recomendationList.length > 1) {
    //     // Buat salinan elemen pada indeks 0
    //     var firstElement = recomendationList[0];

    //     // Bersihkan list
    //     recomendationList.clear();

    //     // Tambahkan kembali elemen pada indeks 0
    //     recomendationList.add(firstElement);
    //   }
    // });
    if (await Permission.location.isGranted) {
      try {
        setState(() {
          if (emptyPayload != true) {
            for (PayloadParkingLocation payload in parkingData.payload!) {
              socket!.off('track-${payload.id}');
            }
          }
          emptyPayload = true;
          isLoadFreeParking = true;
          isLoadParking = true;
          isErrorGetFreeParking = null;
          isErrorGetParking = null;

          //Getapi parkir disini
        });

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
        getCityName();
        await connectSocket();
        getParking();
        getFreeParking();
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

  Future<void> getCityName() async {
    if (!mounted) return;
    try {
      List<geocoding_location.Placemark> placemarks =
          await geocoding_location.placemarkFromCoordinates(
        currentLocation.latitude ?? 0,
        currentLocation.longitude ?? 0,
      );

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        setState(() {
          // ignore: unnecessary_null_comparison
          if (placemarks[0] != null) {
            locationName =
                "${placemarks[0].name} - ${placemarks[0].locality} - ${placemarks[0].subAdministrativeArea}";
          } else {
            locationName = "Lokasi tidak diketahui...";
          }
        });
      } else {
        if (!mounted) return;
        setState(() {
          failedSnackbar(
              context: context,
              title: "Gagal memuat lokasi",
              message: "Maaf lokasi tidak diketahui");
          locationName = "Lokasi tidak diketahui...";
        });
      }
    } catch (e) {
      if (!mounted) return;
      failedSnackbar(
          context: context,
          title: "Gagal memuat lokasi",
          message:
              "Maaf terjadi kesalahan dalam mengambil lokasi, silahkan coba lagi");
      setState(() {
        locationName = "Lokasi tidak diketahui...";
      });
    }
  }

//Greeting
  int hoursnow = 0;
  String greeting = "Hai";
  String datenow = "0000-00-00";

  getCurrentDate() {
    var date = DateTime.now();
    var dateParse = DateTime.parse(date.toString());
    var formattedhours = "${dateParse.hour}";

    setState(() {
      hoursnow = int.parse(formattedhours);
      datenow = dateParse.toString();
    });

    if (hoursnow >= 5 && hoursnow < 11) {
      setState(() {
        greeting = "Selamat Pagi";
      });
    } else if (hoursnow >= 11 && hoursnow < 15) {
      setState(() {
        greeting = "Selamat Siang";
      });
    } else if (hoursnow >= 15 && hoursnow < 18) {
      setState(() {
        greeting = "Selamat Sore";
      });
    } else if (hoursnow >= 18 && hoursnow <= 24) {
      setState(() {
        greeting = "Selamat Malam";
      });
    } else if (hoursnow >= 0 && hoursnow < 5) {
      setState(() {
        greeting = "Selamat Malam";
      });
    }
  }

  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  Future<void> getProfile() async {
    var res =
        await AuthController().getUserInfo(tokenSession: session.token ?? "");
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          usersData = res.data as UserModel;
          isLoadProfile = false;
        });
      } else {
        setState(() {
          usersData = UserModel(
            uNAME: null,
            uMAIL: res.error,
          );
          isLoadProfile = false;
        });
      }
    }
  }

  Future<void> refreshActivity() async {
    setState(() {
      isLoadProfile = true;
      usersData = UserModel();
      locationName = "Sedang memuat lokasi saat ini...";
      // hoursnow = 0;
      // greeting = "Hai";
      // datenow = "0000-00-00";

      location = device_location.Location();
      session = SessionResponse();
      startActivity();
    });
  }

  Future<void> connectSocket() async {
    // print("dipanggil");
    socket = IO.io(Environtment().baseURLServer, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.connect();

    // socket!.on('track', (data) {
    //   print("Data : " + data);
    // });
  }

  void startActivity() async {
    await getCurrentDate();

    getCurrentLocation();

    await getSession();
    if (session.isLog == true) {
      getProfile();
    } else {
      isLoadProfile = false;
    }
  }

  void updateParkingData({
    required int idToUpdate,
    required int motorCountAvaliable,
    required int motorCountTotal,
    required int carCountAvaliable,
    required int carCountTotal,
  }) {
    freeParkingData.payload!.map((parking) {
      if (parking.id == idToUpdate && mounted) {
        setState(() {
          parking.countAvaliableCar = carCountAvaliable;
          parking.countTotalCar = carCountTotal;
          parking.countTotalMotor = motorCountTotal;
          parking.countAvaliableMotor = motorCountAvaliable;
        });
      }
      return parking;
    }).toList();

    parkingData.payload!.map((parking) {
      if (parking.id == idToUpdate && mounted) {
        setState(() {
          parking.countAvaliableCar = carCountAvaliable;
          parking.countTotalCar = carCountTotal;
          parking.countTotalMotor = motorCountTotal;
          parking.countAvaliableMotor = motorCountAvaliable;
        });
      }
      return parking;
    }).toList();
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  @override
  void dispose() {
    if (emptyPayload != true) {
      for (PayloadParkingLocation payload in parkingData.payload!) {
        socket!.off('track-${payload.id}');
      }
    }
    location.onLocationChanged.listen(null).cancel();
    socket!.disconnect();
    socket!.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => refreshActivity(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$greeting ${usersData.uNAME ?? ""}",
                              overflow: TextOverflow.ellipsis,
                              style: fontStyleTitleH2DefaultColor(context),
                            ),
                            InkWell(
                                onTap: () {
                                  getCurrentLocation();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(HomeScreenUserIcon.location,
                                        size: 12,
                                        color:
                                            GetTheme().primaryColor(context)),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        locationName,
                                        overflow: TextOverflow.ellipsis,
                                        style: fontStyleParagraftDefaultColor(
                                            context),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Icon(HomeScreenUserIcon.refresh,
                                        size: 12,
                                        color:
                                            GetTheme().primaryColor(context)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                )),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: isLoadProfile
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[200]!,
                              highlightColor: Colors.white,
                              child: Container(
                                width: 40,
                                height: 40,
                                color: Colors.black,
                              ))
                          : Image.network(
                              usersData.uIMG == null || usersData.uIMG == ""
                                  ? ImageHelper().textPlaceholder(
                                      text: usersData.uNAME?.substring(0, 1) ??
                                          "unknown")
                                  : "${Environtment().baseURLServer}/${usersData.uIMG}",
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.black,
                                      ));
                                }
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "${Environtment().locationPngImage}error-image.png",
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                      color: GetTheme().backgroundGrey(context),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Yuk cari lokasi tujuanmu biar kami bantu rekomendasiin tempat parkir buat kamu.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: fontStyleParagraftDefaultColor(context),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: GetSizeScreen().width(context) * 0.3,
                        child: SvgPicture.asset(
                            "${Environtment().locationSvgImage}img - head.svg"),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: GetSizeScreen().width(context),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                  decoration: BoxDecoration(
                    color: GetTheme().backgroundGrey(context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: recomendationList),
                      ),
                      Icon(
                        HomeScreenUserIcon.search,
                        size: 20,
                        color: GetTheme().primaryColor(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MapWidget(filterFree: false),
                              ));
                          setState(() {
                            refreshActivity();
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: GetTheme().primaryColor(context),
                                  borderRadius: BorderRadius.circular(10)),
                              child: SvgPicture.asset(
                                  "${Environtment().locationSvgImage}icon-park-outline_parking.svg"),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Tracking Tempat Parkir",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  fontStyleParagraftBoldDefaultColor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MapWidget(filterFree: true),
                              ));
                          setState(() {
                            refreshActivity();
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: GetTheme().primaryColor(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SvgPicture.asset(
                                    "${Environtment().locationSvgImage}vehicle-car-parking.svg")),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Tracking Tempat Parkir Gratis",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  fontStyleParagraftBoldDefaultColor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderUserScreen(initialIndex: 0),
                              ));
                          setState(() {
                            refreshActivity();
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: GetTheme().primaryColor(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SvgPicture.asset(
                                    "${Environtment().locationSvgImage}lets-icons_order.svg")),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Order & Booking Saya",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  fontStyleParagraftBoldDefaultColor(context),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tempat parkir disekitarmu",
                      overflow: TextOverflow.ellipsis,
                      style: fontStyleTitleH3DefaultColor(context),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoadParking
                    ? HomeWidget().shimmerCardParking(context)
                    : isErrorGetParking == null
                        ? ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: parkingData.payload!.length > 5
                                ? 5
                                : parkingData.payload!.length,
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              var data = parkingData.payload![index];
                              DateTime now = DateTime.now();
                              bool isOpen = false;
                              DateTime waktuDariString = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data.pKGOPENTIME!.split(":")[0]),
                                  int.parse(data.pKGOPENTIME!.split(":")[1]),
                                  int.parse(data.pKGOPENTIME!.split(":")[2]));
                              DateTime waktuDariStringClose = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data.pKGCLOSETIME!.split(":")[0]),
                                  int.parse(data.pKGCLOSETIME!.split(":")[1]),
                                  int.parse(data.pKGCLOSETIME!.split(":")[2]));

                              isOpen = waktuDariString
                                      .isBefore(DateTime.now()) &&
                                  waktuDariStringClose.isAfter(DateTime.now());

                              return HomeWidget().parkingCard(
                                  isOpen: isOpen,
                                  ontap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ParkingScreen(
                                              idParking: data.id ?? 0),
                                        ));
                                    setState(() {
                                      refreshActivity();
                                    });
                                  },
                                  context: context,
                                  image: data.pKGBANNERBASE64,
                                  fee: data.fEE ?? 0,
                                  name: data.pKGNAME,
                                  carCountAvaliable: data.countAvaliableCar,
                                  carCountTotal: data.countTotalCar,
                                  motorCountAvaliable: data.countAvaliableMotor,
                                  motorCountTotal: data.countTotalMotor);
                            },
                          )
                        : HomeWidget().error(
                            error: isErrorGetParking ?? "",
                            context: context,
                            refresh: () {
                              setState(() {
                                isLoadParking = true;
                                isErrorGetParking = null;
                                getParking();
                              });
                            }),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tempat parkir gratis disekitarmu",
                      overflow: TextOverflow.ellipsis,
                      style: fontStyleTitleH3DefaultColor(context),
                    ),
                    SizedBox(
                      height: 20,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Lihat Lainnya",
                          style: fontStyleParagraftBoldDefaultColor(context),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoadFreeParking
                    ? HomeWidget().shimmerCardParking(context)
                    : isErrorGetFreeParking == null
                        ? ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: freeParkingData.payload!.length > 5
                                ? 5
                                : freeParkingData.payload!.length,
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              var data = freeParkingData.payload![index];
                              DateTime now = DateTime.now();
                              bool isOpen = false;
                              DateTime waktuDariString = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data.pKGOPENTIME!.split(":")[0]),
                                  int.parse(data.pKGOPENTIME!.split(":")[1]),
                                  int.parse(data.pKGOPENTIME!.split(":")[2]));
                              DateTime waktuDariStringClose = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  int.parse(data.pKGCLOSETIME!.split(":")[0]),
                                  int.parse(data.pKGCLOSETIME!.split(":")[1]),
                                  int.parse(data.pKGCLOSETIME!.split(":")[2]));

                              isOpen = waktuDariString
                                      .isBefore(DateTime.now()) &&
                                  waktuDariStringClose.isAfter(DateTime.now());
                              return HomeWidget().parkingCard(
                                  isOpen: isOpen,
                                  ontap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ParkingScreen(
                                              idParking: data.id ?? 0),
                                        ));
                                    setState(() {
                                      refreshActivity();
                                    });
                                  },
                                  context: context,
                                  image: data.pKGBANNERBASE64,
                                  name: data.pKGNAME,
                                  fee: data.fEE ?? 0,
                                  carCountAvaliable: data.countAvaliableCar,
                                  carCountTotal: data.countTotalCar,
                                  motorCountAvaliable: data.countAvaliableMotor,
                                  motorCountTotal: data.countTotalMotor);
                            },
                          )
                        : HomeWidget().error(
                            error: isErrorGetFreeParking ?? "",
                            context: context,
                            refresh: () {
                              setState(() {
                                isLoadFreeParking = true;
                                isErrorGetFreeParking = null;
                                getFreeParking();
                              });
                            }),
                const SizedBox(
                  height: 20,
                ),
                //For Update V2
                // Container(
                //   width: GetSizeScreen().width(context),
                //   height: 136,
                //   padding: const EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //       color: GetTheme().primaryColor(context),
                //       borderRadius: BorderRadius.circular(20)),
                //   child: const Row(
                //     children: [
                //       Expanded(
                //           child: Column(
                //         children: [
                //           // Text("$locationPngImage/iconBannerBookPark.png")
                //         ],
                //       )),
                //       // Image.asset("$locationPngImage/iconBannerBookPark.png")
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
