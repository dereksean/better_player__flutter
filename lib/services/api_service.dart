import 'dart:convert';
import 'dart:developer';

import 'package:better_player_example/services/apiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:better_player_example/constants.dart';
import 'package:better_player_example/model/videos_model.dart';
import '../services/apiResponse.dart';

class ApiService {
  static String videoList = videosToJson.toString();
  Future<String?> authorizeUser() async {
    try {
      var headers = {
        'Authorization': '',
        'Content-Type': 'application/json',

      };


      var request = http.Request('POST', Uri.parse('https://vrssage.azurewebsites.net/api/v1/video/authenticate'));
      request.body = json.encode({
        "username": "test1",
        "password": "password1"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

// Check the status code of the response to see if the request was successful
      if (response.statusCode == 200) {
        // Do something with the JSON response
        userToken = (await response.stream.bytesToString());
        //print(response.stream.bytesToString());
        return userToken;
      }
      else {
        // End the function and throw an exception
        throw Exception('Unable to fetch data');
      }



      // } else {
      //   // If the request was not successful, print the error code and message
      //   print('Request failed with status: ${response.statusCode}');
      //   print('Error message: ${response.reasonPhrase}');
      // }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  List<Videos> videos = [];
  Future<List<Videos>?> getVideos() async {
    try {
      var headers = {
        'Authorization': 'Bearer  $userToken',
      };


      //var url = Uri.parse(Constants.baseUrl + Constants.videoListEndpoint);
      var request = http.Request(
          'GET', Uri.parse(Constants.baseUrl + Constants.videoListEndpoint));

      request.body = '''''';
      //var response = await http.get(url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //List<Videos> _model = videoModelFromJson(request.body);
        String videosToJson = await response.stream.bytesToString();
        // This is the function that generates the list from the JSON data
        List<dynamic> jsonList  = json.decode(videosToJson);
        // Generate the list of items
        //List<Videos> videos = [];
        for (var json in jsonList) {
          videos.add(Videos.fromJson(json));
        }
        var test = ApiResponse.fromJson(jsonList).videoList;
        //List<Videos> videos = ApiResponse.fromJson(jsonList).videoList;
        //print(videos);
        return test;
      }
    } catch (e) {
      log(e.toString());
    }
    return videos;



  }
}