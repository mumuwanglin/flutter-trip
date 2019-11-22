import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_trip/model/search_model.dart';

class SearchDao {
  static Future<SearchModel> fetch(String url, String keyword) async {
    final response = await http.get(url);
    if(response.statusCode == 200){
      Utf8Decoder utf8codec = Utf8Decoder();
      var result = json.decode((utf8codec.convert(response.bodyBytes)));
      // 输入内容和服务度返回内容一致渲染
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = keyword;
      return model;
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}