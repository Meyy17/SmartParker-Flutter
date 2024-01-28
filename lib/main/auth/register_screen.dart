// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smart_parker/controller/auth/auth_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/auth_helper.dart';
import 'package:smart_parker/helper/string_helper.dart';
import 'package:smart_parker/main/auth/login_screen.dart';
import 'package:smart_parker/main/auth/verify_screen.dart';
import 'package:smart_parker/models/register_model.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/auth_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> registerHandle(
      {required String name,
      required String email,
      required String password}) async {
    var responseRegister = await AuthController()
        .registerAccount(email: email, password: password, name: name);

    if (responseRegister.error == null) {
      RegisterModel registerResult = RegisterModel();
      registerResult = responseRegister.data as RegisterModel;

      var responseLogin = await AuthController().loginAccount(
          email: registerResult.payload!.uMAIL ?? email, password: password);
      if (responseLogin.error == null) {
        AuthHelper()
            .loginSuccessAction(responseLogin: responseLogin, context: context);
      } else if (responseLogin.error == "Email belum diverifikasi") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifikasiEmail(
                email: registerResult.payload!.uMAIL ?? email,
              ),
            ));

        successSnackbar(
            context: context,
            title: "Berhasil Mendaftar",
            message:
                "akun ${registerResult.payload!.uMAIL} berhasil didaftarkan, Silahkan verifikasi terlebih dahulu akun anda");
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
        successSnackbar(
            context: context,
            title: "Berhasil Mendaftar",
            message:
                "akun ${registerResult.payload!.uMAIL} berhasil didaftarkan, Silahkan masuk terlebih dahulu dengan akun yang anda daftarkan");
      }
    } else {
      failedSnackbar(
          context: context,
          title: "Terjadi kesalahan",
          message: responseRegister.error.toString());
    }
  }

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: GetTheme().fontColor(context),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: GetSizeScreen().paddingScreen),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerAuth(
                    context: context,
                    subtitle: "Buat akunmu terlebih dahulu untuk masuk"),
                SizedBox(
                  height: GetSizeScreen().height(context) * 0.05,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "Nama",
                  inputType: TextInputType.text,
                  controller: nameCtrl,
                  validator: (p0) {
                    if (p0 == "" || p0 == null || p0.isEmpty) {
                      return 'Mohon masukkan nama anda';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "Email",
                  inputType: TextInputType.emailAddress,
                  controller: emailCtrl,
                  validator: (p0) {
                    if (p0 == "" || p0 == null || p0.isEmpty) {
                      return 'Mohon masukkan email anda';
                    } else if (isValidEmail(p0) == false) {
                      return "Email tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "Password",
                  controller: passwordCtrl,
                  inputType: TextInputType.visiblePassword,
                  isHide: hidePassword,
                  rightWidget: InkWell(
                    onTap: () {
                      setState(() {
                        hidePassword
                            ? hidePassword = false
                            : hidePassword = true;
                      });
                    },
                    child: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  validator: (p0) {
                    if (p0 == "" || p0 == null || p0.isEmpty) {
                      return 'Mohon masukkan password anda';
                    } else if (p0.length < 8) {
                      return 'Password minimal 8 digit';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: GetSizeScreen().height(context) * 0.32,
                ),
                SizedBox(
                  width: GetSizeScreen().width(context),
                  child: buttonPrimary(
                      context: context,
                      radius: 10,
                      ontap: () {
                        if (formKey.currentState!.validate()) {
                          registerHandle(
                              name: nameCtrl.text,
                              email: emailCtrl.text,
                              password: passwordCtrl.text);
                        }
                      },
                      content: "Daftar"),
                ),
                SizedBox(
                  width: GetSizeScreen().width(context),
                  child: buttonGoogle(
                      context: context,
                      radius: 10,
                      ontap: () {
                        AuthController().showAccountPicker(context);
                      },
                      content: "Daftar dengan google"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
