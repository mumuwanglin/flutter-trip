
import 'dart:convert';

import 'package:flutter_trip/model/home_model.dart';
import 'package:http/http.dart' as http;

class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get("http://www.devio.org/io/flutter_app/json/home_page.json");
    if(response.statusCode == 200){
      Utf8Decoder utf8codec = Utf8Decoder();
      var result = json.decode((utf8codec.convert(response.bodyBytes)));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}