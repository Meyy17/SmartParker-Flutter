// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_parker/controller/auth/auth_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/auth_helper.dart';
import 'package:smart_parker/helper/string_helper.dart';
import 'package:smart_parker/main/auth/verify_screen.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/auth_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/snackbar_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoadHud = false;

  Future<void> loginHandle(
      {required String email, required String password}) async {
    setState(() {
      isLoadHud = true;
    });
    var responseLogin =
        await AuthController().loginAccount(email: email, password: password);
    if (responseLogin.error == null) {
      AuthHelper()
          .loginSuccessAction(responseLogin: responseLogin, context: context);
    } else if (responseLogin.error == "Email belum diverifikasi") {
      setState(() {
        isLoadHud = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifikasiEmail(
              email: email,
            ),
          ));
    } else {
      setState(() {
        isLoadHud = false;
      });
      failedSnackbar(
          context: context,
          title: "Gagal untuk masuk",
          message: responseLogin.error.toString());
    }
  }

  bool hidePassword = true;

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
                      subtitle: "Masukan akunmu terlebih dahulu untuk masuk"),
                  SizedBox(
                    height: GetSizeScreen().height(context) * 0.05,
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
                      child: Icon(hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
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
                    height: GetSizeScreen().height(context) * 0.35,
                  ),
                  SizedBox(
                    width: GetSizeScreen().width(context),
                    child: buttonPrimary(
                        context: context,
                        radius: 10,
                        ontap: () {
                          if (formKey.currentState!.validate()) {
                            loginHandle(
                                email: emailCtrl.text,
                                password: passwordCtrl.text);
                          }
                        },
                        content: "Login"),
                  ),
                  SizedBox(
                    width: GetSizeScreen().width(context),
                    child: buttonGoogle(
                        context: context,
                        radius: 10,
                        ontap: () {
                          AuthController().showAccountPicker(context);
                        },
                        content: "Login dengan google"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
