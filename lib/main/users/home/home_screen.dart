import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart' as geocoding_location;
import 'package:location/location.dart' as device_location;
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/icon/home_screen_user_icon_icons.dart';
import 'package:smart_parker/main/users/maps/allmap_screen.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

import '../../../widget/snackbar_widget.dart';
import '../maps/map_screen.dart';

class HomeScreenUsers extends StatefulWidget {
  const HomeScreenUsers({super.key});

  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers> {
  String username = "Meyssa Aqila Adikara";
  String locationName = "Sedang memuat lokasi saat ini...";
  String imageProfileUrl =
      "https://pxbar.com/wp-content/uploads/2023/09/cute-korean-girl-hd-wallpaper.jpg";

  device_location.Location location = device_location.Location();
  late device_location.LocationData currentLocation;

  Future<void> getCurrentLocation() async {
    setState(() {
      locationName = "Sedang memuat lokasi saat ini...";
    });
    if (await Permission.location.isGranted) {
      try {
        var userLocation = await location.getLocation();
        setState(() {
          currentLocation = userLocation;
          getCityName();
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        failedSnackbar(context, "Gagal memuat lokasi",
            "Maaf terjadi kesalahan dalam mengambil lokasi, silahkan coba lagi");
      }
    } else {
      await Permission.location.request();
    }
  }

  Future<void> getCityName() async {
    try {
      List<geocoding_location.Placemark> placemarks =
          await geocoding_location.placemarkFromCoordinates(
        currentLocation.latitude ?? 0,
        currentLocation.longitude ?? 0,
      );

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
        setState(() {
          failedSnackbar(
              context, "Gagal memuat lokasi", "Maaf lokasi tidak diketahui");
          locationName = "Lokasi tidak diketahui...";
        });
      }
    } catch (e) {
      failedSnackbar(context, "Gagal memuat lokasi",
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

  @override
  void initState() {
    getCurrentDate();
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            "$greeting, $username",
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
                                      color: GetTheme().primaryColor(context)),
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
                                      color: GetTheme().primaryColor(context)),
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
                    child: Image.network(
                      imageProfileUrl,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
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
                    color: GetTheme().cardColorGrey(context),
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
                    Container(
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
                  color: GetTheme().cardColorGrey(context),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TyperAnimatedText(
                          'Mau kemana hari ini?',
                          textStyle: fontStyleParagraftDefaultColor(context),
                        ),
                        TyperAnimatedText(
                          'Plaza Mall',
                          textStyle: fontStyleParagraftDefaultColor(context),
                        ),
                        TyperAnimatedText(
                          'Citraland mall',
                          textStyle: fontStyleParagraftDefaultColor(context),
                        ),
                        TyperAnimatedText(
                          'Masjid agung',
                          textStyle: fontStyleParagraftDefaultColor(context),
                        ),
                      ],
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapWidget(
                                  trackingByStreet: false, filterFree: false),
                            ));
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
                                "${Environtment().locationSvgImage}vehicle-car-parking.svg"),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Tracking Tempat Parkir",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyleParagraftBoldDefaultColor(context),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllMapWidget(),
                            ));
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
                            "Kelola kendaraan saya",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyleParagraftBoldDefaultColor(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
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
                          "Order & Booking Saya",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: fontStyleParagraftBoldDefaultColor(context),
                        ),
                      ],
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
                height: 20,
              ),
              Container(
                width: GetSizeScreen().width(context),
                height: 136,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: GetTheme().primaryColor(context),
                    borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        // Text("$locationPngImage/iconBannerBookPark.png")
                      ],
                    )),
                    // Image.asset("$locationPngImage/iconBannerBookPark.png")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
