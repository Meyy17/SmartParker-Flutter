import 'package:flutter/material.dart';
import 'package:smart_parker/theme.dart';

Widget tabbarPrimary(
    {required BuildContext context, required List<Widget> tabs}) {
  return Container(
    padding: const EdgeInsets.all(5),
    // height: 64,
    decoration: BoxDecoration(
      border: Border.all(
        color: GetTheme().greyOutline(context),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TabBar(
      onTap: (value) {
        // setData(value);
      },
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: const EdgeInsets.symmetric(vertical: 5),
      indicator: BoxDecoration(
          color: GetTheme().primaryColor(context),
          borderRadius: BorderRadius.circular(5)),
      labelColor: Colors.white,
      unselectedLabelColor: GetTheme().fontColor(context),
      tabs: tabs,
    ),
  );
}
