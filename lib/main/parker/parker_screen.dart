// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parker/controller/auth/auth_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/money_helper.dart';
import 'package:smart_parker/main/parker/assigment_screen.dart';
import 'package:smart_parker/main/parker/employeeHandle/lemploye_screen.dart';
import 'package:smart_parker/main/parker/parking_list.dart';
import 'package:smart_parker/main/parker/riwayat_screen.dart';
import 'package:smart_parker/main/parker/scan_setup.dart';
import 'package:smart_parker/main/users/parking/parking_screen.dart';
import 'package:smart_parker/main/users/profile/profile_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/user_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class ParkerScreen extends StatefulWidget {
  const ParkerScreen({super.key});

  @override
  State<ParkerScreen> createState() => _ParkerScreenState();
}

class _ParkerScreenState extends State<ParkerScreen> {
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

  SessionResponse session = SessionResponse();
  bool isLoadProfile = true;
  Future<void> getSession() async {
    session = await Middleware().checkSession();
  }

  UserModel usersData = UserModel();
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

  void startActivity() async {
    await getCurrentDate();

    // getCurrentLocation();

    await getSession();
    if (session.isLog == true) {
      getProfile();
    } else {
      isLoadProfile = false;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "$greeting ${usersData.uNAME ?? ""}",
          style: fontStyleTitleAppbar(context),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileUserScreen(),
                  ));
            },
            child: ClipRRect(
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
                              text:
                                  usersData.uNAME?.substring(0, 1) ?? "unknown")
                          : "${Environtment().baseURLServer}/${usersData.uIMG}",
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      loadingBuilder: (context, child, loadingProgress) {
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
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "${Environtment().locationPngImage}error-image.png",
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: GetSizeScreen().paddingScreen),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        "Kelola tempat parkirmu hanya dengan aplikasi ini.",
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
              SizedBox(
                height: GetSizeScreen().paddingScreen,
              ),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 20, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: GetTheme().primaryColor(context),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pendapatanmu : ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: fontStyleParagraftWhiteColor(context),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                MoneyHelper.convertToIdrWithSymbol(
                                    count: usersData.uBALANCE ?? 0,
                                    decimalDigit: 2),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: fontStyleTitleH3WhiteColor(context),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  startActivity();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                      SizedBox(
                        width: GetSizeScreen().width(context) * 0.15,
                        child: SvgPicture.asset(
                            "${Environtment().locationSvgImage}balance.svg"),
                      ),
                    ],
                  )),
              SizedBox(
                height: GetSizeScreen().paddingScreen,
              ),
              GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListEmployee(),
                          ));
                    },
                    child: outlineCard(
                        content: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                decoration: BoxDecoration(
                                    color: GetTheme().cardColorGrey(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.emoji_people_sharp,
                                  color: GetTheme().fontColor(context),
                                  size: 32,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Karyawan",
                                    style:
                                        fontStyleTitleH3DefaultColor(context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: GetTheme().fontColor(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        radius: 10,
                        context: context),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListParking(
                              isPending: false,
                              onTapNavigateTo: (param) =>
                                  RiwayatPrking(idParking: param),
                            ),
                          ));
                    },
                    child: outlineCard(
                        content: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                decoration: BoxDecoration(
                                    color: GetTheme().cardColorGrey(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.history,
                                  color: GetTheme().fontColor(context),
                                  size: 32,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Riwayat",
                                    style:
                                        fontStyleTitleH3DefaultColor(context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: GetTheme().fontColor(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        radius: 10,
                        context: context),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListParking(
                              isPending: false,
                              onTapNavigateTo: (param) =>
                                  ParkingScreen(idParking: param),
                            ),
                          ));
                    },
                    child: outlineCard(
                        content: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                decoration: BoxDecoration(
                                    color: GetTheme().cardColorGrey(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.local_parking,
                                  color: GetTheme().fontColor(context),
                                  size: 32,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kelola Parkir",
                                    style:
                                        fontStyleTitleH3DefaultColor(context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: GetTheme().fontColor(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        radius: 10,
                        context: context),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanSetup(),
                          ));
                    },
                    child: outlineCard(
                        content: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                decoration: BoxDecoration(
                                    color: GetTheme().cardColorGrey(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.local_parking,
                                  color: GetTheme().fontColor(context),
                                  size: 32,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Mulai Bertugas",
                                    style:
                                        fontStyleTitleH3DefaultColor(context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: GetTheme().fontColor(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        radius: 10,
                        context: context),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListParking(
                              isPending: true,
                              onTapNavigateTo: (param) =>
                                  ParkingScreen(idParking: param),
                            ),
                          ));
                    },
                    child: outlineCard(
                        content: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                decoration: BoxDecoration(
                                    color: GetTheme().cardColorGrey(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.local_parking,
                                  color: GetTheme().fontColor(context),
                                  size: 32,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pengajuan Lahan",
                                    style:
                                        fontStyleTitleH3DefaultColor(context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: GetTheme().fontColor(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        radius: 10,
                        context: context),
                  ),
                  InkWell(
                    onTap: () {},
                    child: outlineCard(
                        content: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    GetSizeScreen().paddingScreen),
                                decoration: BoxDecoration(
                                    color: GetTheme().cardColorGrey(context),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.local_parking,
                                  color: GetTheme().fontColor(context),
                                  size: 32,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cash Out",
                                    style:
                                        fontStyleTitleH3DefaultColor(context),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: GetTheme().fontColor(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        radius: 10,
                        context: context),
                  ),
                ],
              ),
              SizedBox(
                height: GetSizeScreen().paddingScreen,
              )
            ],
          ),
        ),
      ),
    );
  }
}
