import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_trip/model/travel_model.dart';

const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031010211161114530&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

var params = {
  "districtId": -1,
  "groupChannelCode": "tourphoto_global1",
  "type": null,
  "lat": 34.2317081,
  "lon": 108.928918,
  "locatedDistrictId": 7,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {
    "cid": "09031010211161114530",
    "ctok": "",
    "cver": "1.0",
    "lang": "01",
    "sid": "8888",
    "syscode": "09",
    "auth": null,
    "extension": [
      {"name": "protocal", "value": "https"}
    ]
  },
  "contentType": "json"
};

///旅拍类别接口
class TravelDao {
  static Future<TravelModel> fetch(
    String url,
    String groupChannelCode,
    int pageIndex,
    int pageSize,
  ) async {
    Map paramsMap = params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    params['groupChannelCode'] = groupChannelCode;

    final response = await http.post(url, body: jsonEncode(params));

    if (response.statusCode == 200) {
      Utf8Decoder utf8codec = Utf8Decoder();
      var result = json.decode((utf8codec.convert(response.bodyBytes)));
      return TravelModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}
