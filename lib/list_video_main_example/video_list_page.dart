import 'dart:math';

import 'package:better_player_example/constants.dart';
import 'package:better_player_example/list_video_main_example/video_list_data.dart';
import 'package:flutter/material.dart';

import '../model/videos_model.dart';
import '../services/apiResponse.dart';
import '../services/api_service.dart';
import 'video_list_widget.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {

  late List<Videos>? _videos = [];
  //final _random = new Random();
  //ApiResponse apiResponse = ApiResponse(videoList: []);
  //final List<Videos> _videos = [
  //   "https://dermill.com/vrssagelocal/videos/Jellyfish_1080_10s_5MB.mkv",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4",
  //   "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
  //
  // ];
  List<Videos> dataList = [];
  var value = -1;

  @override
  void initState() {

    //_setupData();
    super.initState();
    _getData();
  }

  void _setupData() {

    //ApiResponse apiResponse = ApiResponse(videoList: []);
    //for (int index = 0; index < 10; index++) {
      //var randomVideoUrl = _videos[_random.nextInt(_videos.length)];
      //dataList.add(Videos("Video $index", randomVideoUrl));
      _videos?.add(_videos![0]);
    //}
  }

  void _getData() async {
    await ApiService().authorizeUser();
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _videos = (await ApiService().getVideos());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    List<Videos> videos = ApiService().videos;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video in list")),
      body: Container(
        color: Colors.grey,
        child: Column(children: [
          TextButton(
            child: Text("Update page state"),
            onPressed: () {
              setState(() {
                value++;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _videos?.length,
              itemBuilder: (context, index) {
                Videos videos = _videos![index];
                return VideoListWidget(
                  videos: videos,
                );
              },
            ),
          )
        ]),
      ),
    );
  }

}