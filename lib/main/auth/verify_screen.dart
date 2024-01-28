import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';

class VerifikasiEmail extends StatefulWidget {
  const VerifikasiEmail({super.key, required this.email});
  final String email;

  @override
  State<VerifikasiEmail> createState() => _VerifikasiEmailState();
}

class _VerifikasiEmailState extends State<VerifikasiEmail> {
  // AuthPreferences authLocalDB = AuthPreferences();
  // LoginModel userDataFromLogin = LoginModel();
  bool isLoad = false;
  // void sendVerifyEmail() async {
  //   var res = await AuthServices().sendVerifyEmail(email: widget.email);
  //   if (res.error == null) {
  //     setState(() {
  //       isLoad = false;
  //     });
  //     final snackBar = SnackBar(
  //       elevation: 0,
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.transparent,
  //       content: AwesomeSnackbarContent(
  //         title: 'On Snap!',
  //         message: res.data.toString(),
  //         contentType: ContentType.success,
  //       ),
  //     );

  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(snackBar);
  //   } else {
  //     setState(() {
  //       isLoad = false;
  //     });
  //     final snackBar = SnackBar(
  //       elevation: 0,
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.transparent,
  //       content: AwesomeSnackbarContent(
  //         title: 'On Snap!',
  //         message: res.error.toString(),
  //         contentType: ContentType.failure,
  //       ),
  //     );

  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(snackBar);
  //   }
  // }

  // Timer? timer;

  // checkEmailVerified() async {
  //   var res = await AuthServices().checkVerifyEmail(email: widget.email);

  //   if (res.error == null) {
  //     final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  //     final token = await _fcm.getToken();
  //     var resLogin = await AuthServices().login(
  //         email: widget.email,
  //         password: widget.password,
  //         tokenDvc: token.toString());

  //     if (resLogin.error == null) {
  //       setState(() {
  //         userDataFromLogin = resLogin.data as LoginModel;

  //         authLocalDB.setToken(userDataFromLogin.data!.user!.token ?? "");
  //         authLocalDB.setId(userDataFromLogin.data!.user!.id ?? 0);

  //         if (authLocalDB.getToken() != null) {
  //           Navigator.pushAndRemoveUntil(
  //               context,
  //               PageTransition(
  //                   type: PageTransitionType.fade,
  //                   child: userDataFromLogin.data!.user!.role.toString() ==
  //                           "mentor"
  //                       ? const HomeMenuMentor()
  //                       : const Navigation()),
  //               (route) => false);
  //           timer?.cancel();
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // timer =
    //     Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  @override
  void dispose() {
    // timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // circleIconsWthBG(context: context, size: 105),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome back to zendmind",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: GetTheme().themeColor),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: GetSizeScreen().width(context),
                    child: buttonPrimaryWithColor(
                        radius: 10,
                        context: context,
                        content: "Kirim Verifikasi Email",
                        ontap: () {
                          setState(() {
                            // isLoad = true;
                          });
                          // sendVerifyEmail();
                        }),
                  ),
                  const Spacer(),
                ],
              ),
            )),
    );
  }
}
