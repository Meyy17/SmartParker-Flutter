import 'package:intl/intl.dart';

class TimeHelper {
  String timeFormatToHAndM(time) {
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '${hour}:${minute}';
  }

  String datetimeFormatToHAndM(Datetime) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(Datetime);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '${hour}:${minute}';
  }

  DateTime formatToDatetime({required String date, required String time}) {
    String storedDateTimeStr = "${date} ${time}";

    DateTime storedDateTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(storedDateTimeStr);
    return storedDateTime;
  }
}
