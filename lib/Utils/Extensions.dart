import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const USER_INFO = "USER_INFO";
const Role_Permission_data = "Role_Permission_data";
const CURRENT_LOCALE = "CURRENT_LOCALE";

const BASE_URL = "http://192.168.0.33:5000/";
const IMG_BASE_URL = "http://192.168.0.33:5000/";

// const BASE_URL = "https://tm.mmcgbl.ae/api/";
// const IMG_BASE_URL = "https://tm.mmcgbl.ae/api/";

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

Map<String, String> getHeader(String key) => {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Key": key
    };

// void GetShowSnackbar(IconData iconData, String msg, Color color) {
//   Get.rawSnackbar(
//     icon: Icon(
//       iconData,
//       color: Colors.white,
//     ),
//     messageText: Text(
//       msg,
//       style: TextStyle(
//           fontSize: 11.0, color: Colors.white, fontWeight: FontWeight.normal),
//     ),
//     snackPosition: SnackPosition.BOTTOM,
//     borderRadius: 10,
//     margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//     duration: Duration(seconds: 3),
//     animationDuration: Duration(seconds: 1),
//     backgroundColor: color,
//   );
// }

String FormattedAmount(double amount) {
  return NumberFormat('#,##,000.00').format(amount);
}

String convertISODateString(String isoDate) {
  // Parse the ISO date string to a DateTime object
  final dateTime = DateTime.parse(isoDate);

  // Define the desired date format
  final desiredFormat = DateFormat('hh:mm a');
  // Format the DateTime object to the desired format
  final formattedDate = desiredFormat.format(dateTime);
  // Return the formatted date as a string
  return formattedDate;
}

String convertISODate(String isoDate) {
  try {
    // Parse the ISO date string to a DateTime object
    final dateTime = DateTime.parse(isoDate);

    // Define the desired date format
    final desiredFormat = DateFormat('dd MMM,yyyy');

    // Format the DateTime object to the desired format
    final formattedDate = desiredFormat.format(dateTime);

    // Return the formatted date as a string
    return formattedDate;
  } catch (e) {
    return "----";
  }
}

// String formatTimeAgo(String isoDate) {
//   // Parse the ISO date string to a DateTime object
//   final dateTime = DateTime.parse(isoDate);
//
//   // Calculate the relative time using the timeago package
//   final relativeTime = timeago.format(dateTime, locale: 'en_short');
//
//   // Return the relative time as a string
//   return relativeTime;
// }

String covertTimeToText(String? dataDate) {
  String? convTime;
  String prefix = "";

  try {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateTime pasTime = dateFormat.parse(dataDate!);
    DateTime nowTime = DateTime.now();
    Duration dateDiff = nowTime.difference(pasTime);
    int second = dateDiff.inSeconds;
    int minute = dateDiff.inMinutes;
    int hour = dateDiff.inHours;
    int day = dateDiff.inDays;

    if (second < 60) {
      convTime = "$second s ";
    } else if (minute < 60) {
      convTime = "$minute m ";
    } else if (hour < 24) {
      convTime = "$hour hr";
    } else if (day >= 7) {
      if (day > 360) {
        convTime = "${(day / 360).floor()} y ";
      } else if (day > 30) {
        convTime = "${(day / 30).floor()} mon ";
      } else {
        convTime = "${(day / 7).floor()} w ";
      }
    } else if (day < 7) {
      convTime = "$day d";
    }
  } catch (e) {
    print(e);
    return "--";
  }

  return convTime == "0 s " ? "Now" : convTime!;
}
