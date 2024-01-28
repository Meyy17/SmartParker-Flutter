import 'package:flutter/material.dart';
import 'package:smart_parker/database/sPref/auth_preference.dart';
import 'package:smart_parker/main/auth/login_screen.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';

class Middleware {
  AuthPreferences saveAuth = AuthPreferences();

//Cek sesi, bisa dipanggil di halaman awal yang butuh validasi sesi
  Future<SessionResponse> checkSession() async {
    SessionResponse response = SessionResponse();
    String authToken = await saveAuth.getTokenSession();
    response.asUser = await saveAuth.getRoleAsUser();
    if (authToken != "") {
      response.isLog = true;
    } else {
      response.isLog = false;
    }
    response.token = authToken;
    return response;
  }
  //V2
  // Future<SessionResponse> checkSession() async {
  //   SessionResponse response = SessionResponse();
  //   String authToken = await saveAuth.getTokenSession();
  //   if (authToken != "") {
  //     var res = await AuthController().checkSession(tokenSession: authToken);
  //     if (res.error == null) {
  //       response.isLog = true;
  //     } else if (res.unauthorized == true) {
  //       response.isLog = false;
  //       saveAuth.clearTokenSession();
  //     } else {
  //       response.error = res.error;
  //       response.isLog = true;
  //     }
  //   } else {
  //     response.isLog = false;
  //   }
  //   response.token = authToken;
  //   return response;
  // }

//Setiap req api yang membutuhkan token wajib memanggil ini
  Future<bool> responseUnauthorizedCheck(
      {required ApiResponse response, required BuildContext context}) async {
    if (response.unauthorized == true) {
      saveAuth.clearTokenSession();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
      failedSnackbar(
          context: context,
          title: "Unauthorized",
          message: response.error.toString());
      return true;
    } else {
      return false;
    }
  }
}
