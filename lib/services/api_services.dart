import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:english_quiz/utils/constant_value.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Map<String, String> header(String clientID, String time, String checkSum) {
    return {
      "clientId": clientID,
      "time": time,
      "checkSum": checkSum,
    };
  }

  getAPI(String url, String extraURL) async {
    try {
      Uri uri = Uri.parse(url);
      //covert time to second
      DateTime now = DateTime.now();
      String time = (now.millisecondsSinceEpoch ~/ 1000).toString();
      String md5String = 'GET$extraURL$clientId$secret$time';
      String checkSum = crypto.md5.convert(utf8.encode(md5String)).toString();
      var response =
          await http.get(uri, headers: header(clientId, time, checkSum));
      int status = response.statusCode;
      if (status == 200) {
        String data = response.body;
        return data;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
