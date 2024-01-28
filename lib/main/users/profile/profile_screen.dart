// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parker/controller/auth/auth_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/auth_helper.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/main/users/profile/account_manage.dart';
import 'package:smart_parker/main/users/vehicle/vehicle_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/user_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/card_widget.dart';
import 'package:smart_parker/widget/loginvalidate_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  bool isError = false;
  bool isLoad = true;
  bool isLoadHud = false;

  UserModel usersData = UserModel();
  SessionResponse session = SessionResponse();

  Future<void> getSession() async {
    var sessionRes = await Middleware().checkSession();
    setState(() {
      session = sessionRes;
    });
  }

  Future<void> getProfile() async {
    var res =
        await AuthController().getUserInfo(tokenSession: session.token ?? "");
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      if (res.error == null) {
        setState(() {
          isError = false;
          usersData = res.data as UserModel;
        });
      } else {
        setState(() {
          isError = true;
          usersData = UserModel(
            uNAME: "Terjadi Kesalahan",
            uMAIL: res.error,
          );
        });
      }
    }
  }

  Future<void> logoutAction() async {
    Navigator.pop(context);
    setState(() {
      isLoadHud = true;
    });

    var res = await AuthController()
        .logout(tokenSession: session.token.toString(), tokenDevice: "-");
    bool isUnauthorized = await Middleware()
        .responseUnauthorizedCheck(context: context, response: res);
    if (!isUnauthorized) {
      setState(() {
        isLoadHud = false;
      });

      bool isUnauthorized = await Middleware()
          .responseUnauthorizedCheck(context: context, response: res);
      if (!isUnauthorized) {
        if (res.error == null) {
          await AuthHelper().clearToken();

          successSnackbar(
              context: context, title: "Berhasil keluar", message: "");
          refreshActivity();
        } else {
          failedSnackbar(
              context: context,
              title: "Terjadi kesalahan",
              message: res.error.toString());

          refreshActivity();
        }
      }
    }
  }

  void startActivity() async {
    await getSession();
    if (session.isLog == true) {
      await getProfile();
    }
    setState(() {
      isLoad = false;
    });
  }

  Future<void> refreshActivity() async {
    setState(() {
      isError = false;
      isLoad = true;
    });
    startActivity();
  }

  @override
  void initState() {
    startActivity();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoadHud,
      color: Colors.black,
      blur: 0.8,
      progressIndicator: CircularProgressIndicator(
        color: GetTheme().primaryColor(context),
      ),
      child: Scaffold(
          appBar: appbarDefault(context: context, title: "Profile"),
          body: session.isLog ?? true
              ? Padding(
                  padding: EdgeInsets.all(GetSizeScreen().paddingScreen),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: isLoad
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.black,
                                    ))
                                : Image.network(
                                    usersData.uIMG == null ||
                                            usersData.uIMG == ""
                                        ? ImageHelper().textPlaceholder(
                                            text: usersData.uNAME
                                                    ?.substring(0, 1) ??
                                                "unknown")
                                        : "${Environtment().baseURLServer}/${usersData.uIMG}",
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
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
                          SizedBox(
                            width: GetSizeScreen().paddingScreen,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      isLoad
                                          ? "Loading..."
                                          : usersData.uNAME ?? "unknown user",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          fontStyleTitleH1DefaultColor(context),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isError,
                                    child: InkWell(
                                        onTap: () {
                                          refreshActivity();
                                        },
                                        child: const Icon(Icons.refresh)),
                                  )
                                ],
                              ),
                              Text(
                                isLoad ? "Loading..." : usersData.uMAIL ?? "-",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: fontStyleParagraftDefaultColor(context),
                              )
                            ],
                          )),
                        ],
                      ),
                      SizedBox(
                        height: GetSizeScreen().paddingScreen,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManageAccount(),
                              ));
                        },
                        child: listTileCustoms(
                            context: context,
                            title: "Pengaturan akun",
                            iconLeading: Icons.person,
                            iconTrailing: Icons.arrow_forward_rounded),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: session.asUser == true,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VehicleScreen(),
                                    ));
                              },
                              child: listTileCustoms(
                                  context: context,
                                  title: "Kelola kendaraan saya",
                                  iconLeading: Icons.car_repair,
                                  iconTrailing: Icons.arrow_forward_rounded),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: session.asUser == true,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VehicleScreen(),
                                    ));
                              },
                              child: listTileCustoms(
                                  context: context,
                                  title: "Menjadi penyedia layanan parkir",
                                  iconLeading: Icons.switch_account,
                                  iconTrailing: Icons.arrow_forward_rounded),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),

                      //For Update V2
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const ChatListScreen(),
                      //         ));
                      //   },
                      //   child: listTileCustoms(
                      //       context: context,
                      //       title: "Chat & Layanan Bantuan",
                      //       iconLeading: Icons.lock,
                      //       iconTrailing: Icons.arrow_forward_rounded),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),

                      //For Update V2
                      // InkWell(
                      //   onTap: () {},
                      //   child: listTileCustoms(
                      //       context: context,
                      //       title: "Bantuan",
                      //       iconLeading: Icons.lock,
                      //       iconTrailing: Icons.arrow_forward_rounded),
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Perhatian",
                                  style: fontStyleTitleH1DefaultColor(context)),
                              content: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      child: Lottie.asset(
                                          "${Environtment().locationJsonAsset}signOut-anim.json",
                                          repeat: false,
                                          fit: BoxFit.cover),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Apa anda yakin untuk keluar dari akun ${usersData.uMAIL}?",
                                      style: fontStyleParagraftBoldDefaultColor(
                                          context),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Tidak")),
                                TextButton(
                                    onPressed: () {
                                      logoutAction();
                                    },
                                    child: const Text("Ya")),
                              ],
                            ),
                          );
                        },
                        child: listTileCustoms(
                            context: context,
                            title: "Keluar",
                            color: GetTheme().errorColor(context),
                            iconLeading: Icons.logout,
                            iconTrailing: Icons.arrow_forward_rounded),
                      ),
                    ],
                  ))
              : loginValidate(
                  context: context, hPadding: true, vPadding: false)),
    );
  }
}
