import 'dart:convert';

import 'constant.dart';
import 'package:http/http.dart' as http;

class Network {
  final String getURL;
  final String domain;
  final String postURL;
  final Map<String, dynamic> param;

  Network({this.getURL, this.domain = prodDomain, this.postURL, this.param});

  Future<Map<String, dynamic>> get getMethod async {
    try {
      final src = domain + getURL;
      http.Response response = await http.get(src);

      if (response.statusCode != 200) throw 'Please check again';

      final result = json.decode(response.body);

      return result;
    } catch (e) {
      throw e;
    }
  }
}
