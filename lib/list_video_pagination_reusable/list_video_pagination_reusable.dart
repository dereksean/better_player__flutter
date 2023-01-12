
import 'package:VRssage/list_video_pagination_reusable/reusable_video_list_controller.dart';
import 'package:VRssage/list_video_pagination_reusable/reusable_video_list_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../list_video_main_example/video_list_data.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../model/videos_model.dart';

class ListVideoPaginationReusablePage extends StatefulWidget {
  const ListVideoPaginationReusablePage({Key? key}) : super(key: key);

  @override
  State<ListVideoPaginationReusablePage> createState() => _ListVideoPaginationReusablePageState();
}

class _ListVideoPaginationReusablePageState extends State<ListVideoPaginationReusablePage> {


  // pagination
  final _baseUrl = "https://jsonplaceholder.typicode.com/posts";
  int _page = 2;
  final int _limit = 10;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  List<Videos> _totalPosts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter <
            300 // this line of clause is for appear progressbar after reach the end of list
    ) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      await Future.delayed(Duration(seconds: 2));
      _page += 1;
      // call data
      try {
        List<Videos> nextPageList = [];
        if (_totalPosts.length < 50) {
          // total amount 50
          nextPageList = getVideos();
        }

        if (nextPageList.isNotEmpty) {
          setState(() {
            _totalPosts.addAll(nextPageList);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if1(kDebugMode) {
          print("Something went wrong");
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    await Future.delayed(Duration(seconds: 2));
    // call data
    try {
      setState(() {
        _totalPosts = getVideos();
      });
    } catch (err) {
      if (kDebugMode) {
        print("Something went wrong");
      }
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _scrollController;

  ReusableVideoListController videoListController = ReusableVideoListController();
  var value = 0;
  final ScrollController _reusableScrollController = ScrollController();
  int lastMilli = DateTime.now().millisecondsSinceEpoch;
  bool _canBuildVideo = true;


  @override
  void dispose() {
    videoListController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: buildCustomAppbar(context, size),
        // body: SingleChildScrollView(
        body: Column(
          children: [
            buildMainList(size),
          ],
        ),

    );
  }

  PreferredSize buildCustomAppbar(BuildContext context, Size size) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
      ),
    );
  }




  Widget buildMainList(Size size) {
    return Expanded(
      child: _isFirstLoadRunning
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final now = DateTime.now();
              final timeDiff = now.millisecondsSinceEpoch - lastMilli;
              if (notification is ScrollUpdateNotification) {
                final pixelsPerMilli =
                    notification.scrollDelta! / timeDiff;
                if (pixelsPerMilli.abs() > 1) {
                  _canBuildVideo = false;
                } else {
                  _canBuildVideo = true;
                }
                lastMilli = DateTime.now().millisecondsSinceEpoch;
              }

              if (notification is ScrollEndNotification) {
                _canBuildVideo = true;
                lastMilli = DateTime.now().millisecondsSinceEpoch;
              }

              return true;
            },
            child: ListView.builder(
              itemCount: _totalPosts.length,
              shrinkWrap: true,
              controller: _scrollController,
              itemBuilder: (context, index) {
                VideoListData videoListData = VideoListData(
                    _totalPosts[index].videoId.toString(),
                    _totalPosts[index].videoUrl.toString());
                return ReusableVideoListWidget(
                    videoListData: videoListData,
                    videoListController: videoListController,
                    canBuildVideo: _checkCanBuildVideo,
                    index: index);
              },
            ),
          ),
        ),

        if(_isLoadMoreRunning == true)
          const Padding(
            padding: EdgeInsets.only(top: 10 ,bottom: 40),
            child: Center(child: CircularProgressIndicator(),),
          ),

      ]),
    );

  }

  List<Videos> getVideos() {
    List<Videos> list = [];
    // list.add(HomeModel(
    //     "title1",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title2",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title3",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title4",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title5",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title6",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title7",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title8",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title9",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
    //     "Video"));
    // list.add(HomeModel(
    //     "title10",
    //     "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4",
    //     "Video"));

    return list;
  }

  //String jsonString = videoModelFromJson.toString();




  // List<Videos> getList2() {
  //   List<Videos> list = [];
  //   Map<String, dynamic> jsonObject = jsonDecode(jsonString);
  //   List<Map<String, dynamic>> videos = jsonObject['videos'];
  //
  //   for (Map<String, dynamic> video in videos) {
  //     print('ID: ${video['id']}, Name: ${video['name']}');
  //   }
  //   return list;
  // }

  bool _checkCanBuildVideo() {
    return _canBuildVideo;
  }



}



class HomeModel {
  String title;
  String videoUrl;
  String type;

  HomeModel(this.title, this.videoUrl, this.type);
}

class StoryModel {
  String title;

  StoryModel(this.title);
}

