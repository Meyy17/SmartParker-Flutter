// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class DevicePreferences {
  static const newDeviceStatus = "NewDeviceStatus";

  setNewDeviceStatus(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(newDeviceStatus, value);
  }

  Future<bool> getNewDeviceStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(newDeviceStatus) ?? false;
  }
}
