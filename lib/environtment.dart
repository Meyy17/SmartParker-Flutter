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
  String locationJsonAsset = "assets/json/";
  int timeOutDuration = 15;
  String baseURLServer = "https://frankly-novel-amoeba.ngrok-free.app";
  double latitudeDev = -6.840444;
  double longitudeDev = 110.818541;
}
