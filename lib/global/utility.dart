import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences? userPref;

  static String? adminEmail;
  static String? adminPhone;

  static String? tokenID;
  static String uri = "https://fcm.googleapis.com/fcm/send";
  static String contentType = "application/json; charset=UTF-8";
  static String serverID =
      "key=AAAAdGWcORk:APA91bFpIB13oQep9uKfpop5-LcEMUJT8wAWLlaJoVuV2GJDeiwqhu84nHI82bYryWl7fyrdGLiQFmzvrLq6-LymaJsXPGMWiWp3ccTByHCrp-s9mkeIPhON0AEvvTo0WQAQEKqjaXeu";

  static String formatNumber(int number) {
    if (number >= 20000000) {
      double result = number / 10000000;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)} Cr";
    } else if (number >= 100000) {
      double result = number / 100000;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)} Lac";
    } else if (number >= 1000) {
      double result = number / 1000;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)} K";
    } else {
      return number.toString();
    }
  }
}
