import 'dart:math';

import 'package:VRssage/constants.dart';
import 'package:VRssage/list_video_main_example/video_list_data.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../media_saver.dart';
import '../model/videos_model.dart';
import '../services/apiResponse.dart';
import '../services/api_service.dart';
import 'video_list_widget.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  String videoPath = "";

  bool sourceChecked = false;
  late List<Videos>? _videos = [];
  List<String> _videoUrls = [];

  final _random = new Random();
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
  List<VideoListData> dataList = [];
  var value = -1;

  @override
  void initState() {

    //_setupData();
    super.initState();
    _getData();

  }

  void _setupData() {

    //ApiResponse apiResponse = ApiResponse(videoList: []);
    for (int index = 0; index < _videoUrls.length; index++) {
      var videopath = _videoUrls![index].toString();
      dataList.add(VideoListData(_videos![index].videoTitle.toString(), videopath));
      //_videos?.add(_videos![0]);

    }
  }

  void _getData() async {



    await ApiService().authorizeUser();
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _videos = await (ApiService().getVideos());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    List<Videos> videos = ApiService().videos;
    _videos = _videos;
    for (var videoUrl in _videos!) {

      //_saveAssetVideoToFile(videoUrl.videoUrl.toString());
      await _checkVideoAlreadySaved(videoUrl.videoUrl.toString());


    }
    _setupData();

    //saveVideo();

  }

  Future<List<String>> _checkVideoAlreadySaved(String videoUrl) async {
    bool alreadySavedInDevice =
    await MediaSaver().isVideoAlreadySavedInDevice(videoUrl);
    var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
    var dir = await getApplicationDocumentsDirectory();
    String path= "${dir.path}/$videoName";
    if (alreadySavedInDevice) {
      path = await MediaSaver().getVideoDevicePath(videoUrl);
      videoPath = path;
      sourceChecked = true;
      _videoUrls?.add(videoPath);
      //_setupFilePathList();
      return _videoUrls;
    }
    _videoUrls?.add(videoUrl);

    return _videoUrls;


    // setState(() {
    //   videoPath = path;
    //   sourceChecked = true;
    // });
    //_setupController("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('lib/assets/images/vrssage_banner_trans.png', fit: BoxFit.contain,height: 50),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(children: [
          // TextButton(
          //   child: Text("Update page state"),
          //   onPressed: () {
          //     setState(() {
          //       value++;
          //     });
          //   },
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                VideoListData videoListData = dataList[index];
                return VideoListWidget(
                  videoListData: videoListData,
                );
              },
            ),
          )
        ]),
      ),
    );
  }

}