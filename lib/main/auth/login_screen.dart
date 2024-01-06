import 'package:flutter/material.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/string_helper.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/auth_widget.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
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
                    child: const Icon(Icons.visibility),
                  ),
                  validator: (p0) {
                    if (p0 == "" || p0 == null || p0.isEmpty) {
                      return 'Mohon masukkan password anda';
                    } else if (p0.length < 8) {
                      return 'Password minimal 8 digit';
                    } else if (containsNumber(p0) == false) {
                      return 'Password membutuhkan huruf, angka, simbol\nContoh: Sm@rtparker#24';
                    } else if (containsSymbol(p0) == false) {
                      return 'Password membutuhkan huruf, angka, simbol\nContoh: Sm@rtparker#24';
                    } else if (containsLetter(p0) == false) {
                      return 'Password membutuhkan huruf, angka, simbol\nContoh: Sm@rtparker#24';
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
                        if (formKey.currentState!.validate()) {}
                      },
                      content: "Login"),
                ),
                SizedBox(
                  width: GetSizeScreen().width(context),
                  child: buttonPrimary(
                      context: context,
                      radius: 10,
                      ontap: () {},
                      content: "Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
