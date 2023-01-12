import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:VRssage/constants.dart';
import 'package:VRssage/model/videos_model.dart';

class ApiResponse{
final List<Videos> videoList;

ApiResponse({required this.videoList});

factory ApiResponse.fromJson(List<dynamic> parsedJson) {
List<Videos> list = <Videos>[];
list = parsedJson.map((i) => Videos.fromJson(i)).toList();

return ApiResponse(videoList: list);
}
}
