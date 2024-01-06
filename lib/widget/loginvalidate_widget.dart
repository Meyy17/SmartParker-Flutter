import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/main/auth/login_screen.dart';
import 'package:smart_parker/main/auth/register_screen.dart';
import 'package:smart_parker/widget/button_widget.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

Widget loginValidate(
    {required BuildContext context,
    required bool hPadding,
    required bool vPadding}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: hPadding ? GetSizeScreen().paddingScreen : 0,
        vertical: vPadding ? GetSizeScreen().paddingScreen : 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [InkWell(onTap: () {}, child: Icon(Icons.help))],
        ),
        Column(
          children: [
            SvgPicture.asset("${Environtment().locationSvgImage}log-icon.svg"),
            SizedBox(
              height: GetSizeScreen().paddingScreen,
            ),
            Text(
              "Ups, Sebelumnya kamu belum melakukan login. Login atau daftarkan akunmu  terlabih dahulu. Dengan login kamu bisa booking tempat parkir loh.",
              textAlign: TextAlign.center,
              style: fontStyleParagraftDefaultColor(context),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: buttonPrimary(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    context: context,
                    radius: 10,
                    content: "Masuk")),
            SizedBox(
              width: GetSizeScreen().paddingScreen,
            ),
            Expanded(
                child: buttonOutlined(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ));
                    },
                    context: context,
                    radius: 10,
                    content: "Daftar")),
          ],
        )
      ],
    ),
  );
}
