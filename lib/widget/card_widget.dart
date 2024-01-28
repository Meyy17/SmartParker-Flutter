import 'package:flutter/material.dart';
import 'package:smart_parker/environtment.dart';
import 'package:smart_parker/theme.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

Widget outlineCard(
    {required BuildContext context,
    required Widget content,
    required double radius}) {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: GetTheme().greyOutline(context), width: 1.5),
        borderRadius: BorderRadius.circular(radius)),
    child: content,
  );
}

Widget listTileCustoms({
  required BuildContext context,
  required String title,
  Color? color,
  required IconData iconLeading,
  required IconData iconTrailing,
}) {
  return Card(
    elevation: 0,
    margin: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: GetTheme().greyOutline(context), width: 1.5),
        borderRadius: BorderRadius.circular(15.0)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: color ?? GetTheme().primaryColor(context),
                borderRadius: BorderRadius.circular(5)),
            child: Icon(
              iconLeading,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: GetSizeScreen().paddingScreen,
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: fontStyleSubtitleSemiBoldDefaultColor(context),
            ),
          ),
          SizedBox(
            width: GetSizeScreen().paddingScreen,
          ),
          Icon(
            iconTrailing,
            size: 20,
            color: color ?? GetTheme().primaryColor(context),
          ),
        ],
      ),
    ),
  );
}
