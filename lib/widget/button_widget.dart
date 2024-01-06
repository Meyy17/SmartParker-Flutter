import 'package:flutter/material.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

Widget buttonPrimary(
    {required BuildContext context,
    required double radius,
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
      style: fontStyleTitleH3DefaultColor(context),
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
