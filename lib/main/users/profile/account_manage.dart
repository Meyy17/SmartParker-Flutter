// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parker/controller/auth/auth_controller.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/helper/image_helper.dart';
import 'package:smart_parker/helper/middleware_helper.dart';
import 'package:smart_parker/helper/string_helper.dart';
import 'package:smart_parker/models/apiresponse_model.dart';
import 'package:smart_parker/models/user_model.dart';
import 'package:smart_parker/widget/appbar_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';
import 'package:smart_parker/widget/textfield_widget.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({super.key});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  bool isError = false;
  bool isLoad = true;
  bool isLoadHud = false;
  UserModel usersData = UserModel();
  SessionResponse session = SessionResponse();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool hideNewPassword = true;
  bool hidePassword = true;

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

  void startActivity() async {
    await getSession();
    if (session.isLog == true) {
      await getProfile();
    }
    setState(() {
      nameCtrl.text = usersData.uNAME ?? "";
      emailCtrl.text = usersData.uMAIL ?? "";
      isLoad = false;
    });
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
    return Scaffold(
      appBar: appbarDefault(context: context, title: "Pengaturan akun"),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(GetSizeScreen().paddingScreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: isLoad
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.black,
                          ))
                      : Image.network(
                          usersData.uIMG == null || usersData.uIMG == ""
                              ? ImageHelper().textPlaceholder(
                                  text: usersData.uNAME?.substring(0, 1) ??
                                      "unknown")
                              : "${Environtment().baseURLServer}/${usersData.uIMG}",
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.black,
                                  ));
                            }
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            "${Environtment().locationPngImage}error-image.png",
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        ),
                ),
                SizedBox(
                  height: GetSizeScreen().paddingScreen,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Nama Kamu",
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "Masukkan nama anda",
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
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Email",
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "masukkan email anda",
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
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Password Baru",
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "opsional",
                  controller: newPasswordCtrl,
                  inputType: TextInputType.visiblePassword,
                  isHide: hideNewPassword,
                  rightWidget: InkWell(
                    onTap: () {
                      setState(() {
                        hideNewPassword
                            ? hideNewPassword = false
                            : hideNewPassword = true;
                      });
                    },
                    child: Icon(hideNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  validator: (p0) {
                    if (p0 != "" || p0 != null || p0!.isNotEmpty) {
                      if (p0!.length < 8) {
                        return 'Password baru minimal 8 digit';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Password Sekarang",
                    style: fontStyleSubtitleSemiBoldDefaultColor(context),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                inputFieldPrimary(
                  context: context,
                  hintText: "masukkan password anda",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
