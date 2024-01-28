import 'package:intl/intl.dart';

class DateHelper {
  String formatDateToId({required String date}) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {
          month = "Januari";
        }
        break;
      case '02':
        {
          month = "Februari";
        }
        break;
      case '03':
        {
          month = "Maret";
        }
        break;
      case '04':
        {
          month = "April";
        }
        break;
      case '05':
        {
          month = "Mei";
        }
        break;
      case '06':
        {
          month = "Juni";
        }
        break;
      case '07':
        {
          month = "Juli";
        }
        break;
      case '08':
        {
          month = "Agustus";
        }
        break;
      case '09':
        {
          month = "September";
        }
        break;
      case '10':
        {
          month = "Oktober";
        }
        break;
      case '11':
        {
          month = "November";
        }
        break;
      case '12':
        {
          month = "Desember";
        }
        break;
    }
    return "$d $month $Y";
  }

  String formatDateToIdOnlyMonthAndYears({required String date}) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

    var m = DateFormat('MM').format(dateTime);
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {
          month = "Januari";
        }
        break;
      case '02':
        {
          month = "Februari";
        }
        break;
      case '03':
        {
          month = "Maret";
        }
        break;
      case '04':
        {
          month = "April";
        }
        break;
      case '05':
        {
          month = "Mei";
        }
        break;
      case '06':
        {
          month = "Juni";
        }
        break;
      case '07':
        {
          month = "Juli";
        }
        break;
      case '08':
        {
          month = "Agustus";
        }
        break;
      case '09':
        {
          month = "September";
        }
        break;
      case '10':
        {
          month = "Oktober";
        }
        break;
      case '11':
        {
          month = "November";
        }
        break;
      case '12':
        {
          month = "Desember";
        }
        break;
    }
    return "$month $Y";
  }

  String formatDateToSlash({required String date}) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);

    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var y = DateFormat('yyyy').format(dateTime).toString();

    return "$d/$m/$y";
  }

  String formatDateEnglish(String dateR) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(dateR);
    int month = date.month;

    String day = date.day.toString();
    String Y = date.year.toString();
    String monthFormated = "";

    switch (month) {
      case 1:
        monthFormated = "Jan";
        break;
      case 2:
        monthFormated = "Feb";
        break;
      case 3:
        monthFormated = "Mar";
        break;
      case 4:
        monthFormated = "Apr";
        break;
      case 5:
        monthFormated = "May";
        break;
      case 6:
        monthFormated = "Jun";
        break;
      case 7:
        monthFormated = "Jul";
        break;
      case 8:
        monthFormated = "Aug";
        break;
      case 9:
        monthFormated = "Sep";
        break;
      case 10:
        monthFormated = "Oct";
        break;
      case 11:
        monthFormated = "Nov";
        break;
      case 12:
        monthFormated = "Dec";
        break;
      default:
        monthFormated = "-";
    }

    return "$day $monthFormated $Y";
  }
}
