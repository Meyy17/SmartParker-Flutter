import 'package:flutter/material.dart';
import 'package:smart_parker/widget/stylefont_widget.dart';

PreferredSizeWidget appbarDefault({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    title: Text(
      title,
      style: fontStyleTitleAppbar(context),
    ),
  );
}
