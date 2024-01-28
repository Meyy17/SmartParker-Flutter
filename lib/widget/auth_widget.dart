import 'package:flutter/material.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

Widget headerAuth({
  required BuildContext context,
  required String subtitle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Halo, Selamat Datang",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: fontStyleTitleH1DefaultColor(context),
      ),
      SizedBox(
        width: GetSizeScreen().width(context) * 0.6,
        child: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: fontStyleSubtitleDefaultColor(context),
        ),
      )
    ],
  );
}
