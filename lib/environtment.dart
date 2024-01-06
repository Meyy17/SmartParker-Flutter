//Size
import 'package:flutter/cupertino.dart';

class GetSizeScreen {
  double width(context) {
    return MediaQuery.of(context).size.width;
  }

  double height(context) {
    return MediaQuery.of(context).size.height;
  }

  double paddingScreen = 20;
}

class Environtment {
  String locationPngImage = "assets/png/";
  String locationSvgImage = "assets/svg/";
  String baseURLServer = "https://e0fd-103-28-113-244.ngrok-free.app";
}
