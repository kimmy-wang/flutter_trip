import 'dart:async';
import 'dart:convert';
import 'package:flutter_trip/models/travel_model.dart';
import 'package:http/http.dart' as http;

var params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};

class TravelDao {
  static Future<TravelModel> fetch(
      String url, String groupChannelCode, int pageIndex, int pageSize) async {
    params['groupChannelCode'] = groupChannelCode;
    Map pagePara = params['pagePara'];
    pagePara['pageIndex'] = pageIndex;
    pagePara['pageSize'] = pageSize;
    final response = await http.post(url, body: jsonEncode(params));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json.');
    }
  }
}
