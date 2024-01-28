import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

Widget buttonGoogle(
    {required BuildContext context,
    required double radius,
    required Function()? ontap,
    required String content}) {
  return OutlinedButton(
    onPressed: ontap,
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: GetTheme().greyOutline(context),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("${Environtment().locationSvgImage}google-flat.svg"),
        SizedBox(
          width: GetSizeScreen().paddingScreen,
        ),
        Text(
          content,
          style: fontStyleTitleH3DefaultColor(context),
        ),
      ],
    ),
  );
}

Widget buttonPrimary(
    {required BuildContext context,
    required double radius,
    bool? small,
    required Function()? ontap,
    required String content}) {
  return ElevatedButton(
    onPressed: ontap,
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // <-- Radius
        ),
        elevation: 0,
        backgroundColor: GetTheme().cardColorGreyDark(context)),
    child: Text(
      content,
      style: small == true
          ? fontStyleSubtitleSemiBoldDefaultColor(context)
          : fontStyleTitleH3DefaultColor(context),
    ),
  );
}

Widget buttonPrimaryWithColor(
    {required BuildContext context,
    required double radius,
    bool? small,
    required Function()? ontap,
    required String content}) {
  return ElevatedButton(
    onPressed: ontap,
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
        backgroundColor: GetTheme().primaryColor(context)),
    child: Text(
      content,
      style: small == true
          ? fontStyleSubtitleSemiBoldWhiteColor(context)
          : fontStyleTitleH3WhiteColor(context),
    ),
  );
}

Widget buttonOutlined(
    {required BuildContext context,
    required double radius,
    required Function()? ontap,
    required String content}) {
  return OutlinedButton(
    onPressed: ontap,
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: GetTheme().greyOutline(context),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      elevation: 0,
    ),
    child: Text(
      content,
      style: fontStyleTitleH3DefaultColor(context),
    ),
  );
}
