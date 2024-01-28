// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smart_parker/database/sPref/auth_preference.dart';
import 'package:smart_parker/main/parker/officer/officer_screen.dart';
import 'package:smart_parker/main/parker/parker_screen.dart';
import 'package:smart_parker/main/users/user_screen.dart';
import 'package:smart_parker/models/login_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

class AuthHelper {
  AuthPreferences saveAuth = AuthPreferences();

  Future<void> loginSuccessAction(
      {required var responseLogin, required BuildContext context}) async {
    LoginModel loginResult = responseLogin.data as LoginModel;
    String secondaryRoleView = loginResult.payload!.user!.uROLE ?? "";
    bool isLogAsUser = true;
    Widget? navigateTo;

    switch (loginResult.payload!.user!.uROLE) {
      case "PARKER":
        navigateTo = const ParkerScreen();
        secondaryRoleView = "Penyedia Parkir";
        break;
      case "EMPLOYEE":
        navigateTo = const OfficerScreen();
        secondaryRoleView = "Petugas Parkir";
        break;
      default:
        navigateTo = const UserScreen();
        break;
    }

    if (loginResult.payload!.user!.uROLE != "USER") {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  "Ingin Masuk Sebagai ?",
                  style: fontStyleTitleH3DefaultColor(context),
                ),
                content: IntrinsicHeight(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.person,
                          color: GetTheme().fontColor(context),
                        ),
                        title: Text(
                          "Pengguna",
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          isLogAsUser = false;
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.local_parking_rounded,
                          color: GetTheme().fontColor(context),
                        ),
                        title: Text(
                          secondaryRoleView,
                          style: fontStyleSubtitleSemiBoldDefaultColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    }

    //Role Validation
    if (isLogAsUser == true) {
      navigateTo = const UserScreen();
    }
    await saveAuth.setTokenSession(loginResult.payload!.user!.token ?? "");
    await saveAuth.setRoleAsUser(isLogAsUser);

    //Navigate after validate
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => navigateTo ?? const UserScreen(),
        ),
        (route) => false);
    //Show Snackbar(Optional)
    successSnackbar(
        context: context,
        title: loginResult.message.toString(),
        message:
            "Berhasil masuk dengan akun ${loginResult.payload!.user!.uMAIL}");
  }

  Future<void> clearToken() async {
    saveAuth.clearTokenSession();
  }
}
