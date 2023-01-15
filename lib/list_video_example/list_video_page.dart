import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:VRssage/list_video_example/image_item.dart';
import 'package:VRssage/list_video_example/model.dart';
import 'package:VRssage/list_video_example/video_item.dart';
import 'package:VRssage/list_video_example/video_playlist.dart';
import 'package:VRssage/list_video_example/videolist_widget.dart';
import 'package:dio/dio.dart';
//import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:VRssage/model/videos_model.dart';
import 'package:VRssage/services/api_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Constants.dart';
import '../media_saver.dart';
import '../services/apiResponse.dart';
import '../snackbar.dart';

class ListPlayerPage extends StatefulWidget {
  const ListPlayerPage({Key? key}) : super(key: key);

  @override
  State<ListPlayerPage> createState() => _ListPlayerPageState();
}

class _ListPlayerPageState extends State<ListPlayerPage>  with AutomaticKeepAliveClientMixin {
  //List<Model> list = [];
  List<Videos>? _videos = [];
  List<String> _videoUrls = [];
  late BetterPlayerController betterPlayerController;
  List dataSourceList = <BetterPlayerDataSource>[]; //List of data sources
  List videoItems = <VideoItem>[];//List of video Items

  // // Create a BetterPlayerController for each video URL
  // late List<BetterPlayerDataSource> betterPlayerController = _videoUrls
  //     .map((url) {
  //    return BetterPlayerDataSource.file(url);}).toList();


  //late BetterPlayerConfiguration betterPlayerConfiguration;
  bool _isDisposing = false;
  String videoPath = "";

  bool sourceChecked = false;

  int selectedVideoIndex = -1 ;
  var value = 0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    // betterPlayerController = BetterPlayerController(BetterPlayerConfiguration());
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {

      _ifLoaded();
    });


  }

  _ifLoaded() async {
  if (await Permission.storage.request().isGranted) {
    _getData();
    //buck();
    //setUpList();



    //_setupController("https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4");
    _setupController(videoPath);


    //_setupData();
    //onVisibilityChanged(100);
  }}


  // void buck() async {// for android Directory
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //
  //   var result = await FilesystemPicker.open(allowedExtensions: [".png", ".jpg", ".mp4"],
  //       context: context,rootDirectory: appDocDir);
  //   if (result != null) {
  //     File file = File(result);
  //     print(file.parent.path);// the path where the file is saved
  //     videoPath = file.parent.path;
  //
  //   }}

  Future<List> createDataSet() async {

    for (int i = 0; i < _videoUrls.length; i++) {
      dataSourceList.add(BetterPlayerDataSource.file(_videoUrls[i]));
    }
    // dataSourceList.add(
    //   BetterPlayerDataSource(
    //     BetterPlayerDataSourceType.file,
    //     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    //   ),
    // );
    return dataSourceList;
  }

  Future<List> createDataSet2() async {

    for (int i = 0; i < _videoUrls.length; i++) {
      videoItems.add(VideoItem(
          betterPlayerController: betterPlayerController,
          videoUrl: _videoUrls[i]));

    }
    // dataSourceList.add(
    //   BetterPlayerDataSource(
    //     BetterPlayerDataSourceType.file,
    //     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    //   ),
    // );
    return videoItems;
  }





  @override
  void dispose() {
    // if (betterPlayerController.isPlaying() == true) betterPlayerController.pause();
    // betterPlayerController.removeEventsListener((p0) => null);
    // betterPlayerController.videoPlayerController == null;
    // _isDisposing = true;
    if (betterPlayerController.videoPlayerController != null) {
      betterPlayerController!.dispose(forceDispose: true);
      //betterPlayerController.videoPlayerController = null;
      //print("Disposed controller from Framework.");
    }
    super.dispose();

  }



  void _getData() async {



    await ApiService().authorizeUser();
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _videos = (await ApiService().getVideos());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    List<Videos> videos = ApiService().videos;

    for (var videoUrl in _videos!) {

      //_saveAssetVideoToFile(videoUrl.videoUrl.toString());
      await _checkVideoAlreadySaved(videoUrl.videoUrl.toString());


    }
    await createDataSet();
    await createDataSet2();
    //saveVideo();

  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery
  //       .of(context)
  //       .size;
  //
  //
  //   // return Scaffold(
  //   //     body: Container(
  //   //
  //   //         padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
  //   //         height: size.height,
  //   //         width: size.width,
  //
  //   return  Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       appBar: AppBar(
  //         backgroundColor: Colors.black,
  //         title: Image.asset('lib/assets/images/vrssagelogomain.png', fit: BoxFit.contain,height: 50),
  //       ),
  //       body: ListView.builder(
  //         itemCount: videoItems.length,
  //         itemBuilder: (context, index) {
  //           return ListTile(
  //             title: Text(videoItems[index].description),
  //             subtitle: Text(videoItems[index].description),
  //             leading: Image.network(videoItems[index].thumbnailUrl),
  //             trailing: IconButton(
  //               icon: Icon(Icons.play_arrow),
  //               onPressed: () {
  //                 // play the video
  //
  //                 setState(() {
  //                                               value++;
  //                                               selectedVideoIndex = index;
  //
  //                                               _setupController(_videoUrls![index].toString());
  //                                               //_freeController();
  //
  //                                             });
  //               },
  //             ),
  //           );
  //         },
  //       ));
  // }

  // @override
  //
  // Widget build(BuildContext context) {
  //   //var test = createDataSet();
  //   return AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: BetterPlayerPlaylist(
  //         betterPlayerConfiguration: BetterPlayerConfiguration(autoPlay: true, autoDispose: true),
  //         betterPlayerPlaylistConfiguration: const BetterPlayerPlaylistConfiguration(
  //           loopVideos: true,
  //           autoPlay: true,
  //           nextVideoDelay: Duration(seconds: 1),
  //         ),
  //         betterPlayerDataSourceList: dataSourceList as List<BetterPlayerDataSource>),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery
  //       .of(context)
  //       .size;
  //
  //
  //   // return Scaffold(
  //   //     body: Container(
  //   //
  //   //         padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
  //   //         height: size.height,
  //   //         width: size.width,
  //
  //   return  Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       appBar: AppBar(
  //         backgroundColor: Colors.black,
  //         title: Image.asset('lib/assets/images/vrssagelogomain.png', fit: BoxFit.contain,height: 50),
  //       ),
  //       body: ListView.builder(
  //           padding: const EdgeInsets.only(top: 10.0),
  //           shrinkWrap: true,
  //           itemCount: videoItems?.length,
  //           itemBuilder: (context, index) {
  //
  //             return SizedBox(
  //               height: 250,
  //               width: size.width,
  //               child: AspectRatio(
  //                 // aspectRatio: 16 / 9,
  //                 // aspectRatio: 360 / 243,
  //                   aspectRatio: 1,
  //                   child: BetterPlayer(
  //                     controller: betterPlayerController,
  //                   )),
  //             );}));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;


    // return Scaffold(
    //     body: Container(
    //
    //         padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
    //         height: size.height,
    //         width: size.width,

    return  Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset('lib/assets/images/vrssage_banner_trans.png', fit: BoxFit.contain,height: 50),
          actions: <Widget>[
            TextButton(
              onPressed: () {Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const PlayListPlayerPage()),
    (Route<dynamic> route) => false);},
              // {Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>  const PlayListPlayerPage(),
              //   ),
              // );},
              child: Text("Play All Videos", style: TextStyle(color: Colors.white)),

            ),
          ],
        ),
        body: ListView.builder(
            padding: const EdgeInsets.only(top: 10.0),
            shrinkWrap: true,
            itemCount: videoItems?.length,
            itemBuilder: (context, index) {

              return Card(
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _videos![index].videoTitle.toString(),
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                        // list[index].type == "image"
                        //      ? ImageItem(
                        //          imageUrl: list[index].imageUrl,
                        //          description: list[index].description)
                        GestureDetector(
                        child: VideoListItem(_videoUrls[index]),

                        //   child: VideoItem(
                        //       canBuild: selectedVideoIndex == index ? true : false,
                        //       betterPlayerController: betterPlayerController,
                        //       description: _videos![index].videoTitle.toString(),
                        //       videoUrl: _videoUrls![index].toString(),
                        //       thumbnailUrl: _videos![index].videoTitle.toString()),
                        //   onTap: () {
                        //     // if(selectedVideoIndex==-1||(betterPlayerController.isVideoInitialized()??false) ) {
                        //
                        //     setState(() {
                        //       value++;
                        //       selectedVideoIndex = index;
                        //
                        //       // for(var videos in videoItems)
                        //       //   {
                        //       //     videos[index].betterPlayerController;
                        //       //   }
                        //       _setupController(_videoUrls![index].toString());
                        //       //_freeController();
                        //       betterPlayerController.videoPlayerController!.addListener(
                        //           checkVideo);
                        //       checkVideo();
                        //     });
                        //
                        //
                        //
                        //
                        //     // }
                        //   },
                        ),


                        // ),
                      ]));}));
  }

//   //******************************Getting data from an API******************************//
//   return Scaffold(
//   appBar: AppBar(
//   title: const Text('Video List'),
//   ),
//   body: _videos == null || _videos!.isEmpty
//   ? const Center(
//   child: CircularProgressIndicator(),
//   )
//       : ListView.builder(
//   itemCount: _videos!.length,
//   itemBuilder: (context, index) {
//   return Card(
//   child: Column(
//   children: [
//   Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//   Text(_videos![index].videoTitle),
//   Text(_videos![index].videoUrl),
//   ],
//   ),
//   const SizedBox(
//   height: 20.0,
//   ),
//   Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   children: [
//     Text(_videos![index].videoTitle),
//     Text(_videos![index].videoUrl),
//   ],
//   ),
//   ],
//   ),
//   );
//   },
//   ),
//   );
// }

  void _freeController() {
    if (betterPlayerController.isPlaying() == true) betterPlayerController.pause(); {
      betterPlayerController.betterPlayerConfiguration.autoDispose == true;
      betterPlayerController.pause();
      betterPlayerController.dispose();
    }
  }



  void _setupController(String videoUrl) {

    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration();
      // (
      //
      // aspectRatio: 16 / 9,
      //   //aspectRatio: 1,
      //   fit: BoxFit.fill,
      //   handleLifecycle: true,
      //   autoDispose: true,
      //   autoPlay: true,
      //   fullScreenByDefault: true,
      //
      //   showPlaceholderUntilPlay: false,
      //   looping: false,
      //   controlsConfiguration: BetterPlayerControlsConfiguration(
      //       controlBarColor: Colors.black.withAlpha(600),
      //       controlBarHeight: 30,
      //       overflowModalColor: Colors.yellow,
      //       overflowModalTextColor: Colors.white,
      //       overflowMenuIconsColor: Colors.white,
      //       enableSkips: false,
      //       // playIcon: const AssetImage("assets/images/play_icon.png"),
      //       enablePlayPause: true));

    // // check if video already downloaded  play video from path or else play from network
    // BetterPlayerDataSource? _betterPlayerDataSource = videoPath == ""
    //     ? BetterPlayerDataSource(BetterPlayerDataSourceType.network, videoUrl,
    //     // placeholder: _buildVideoPlaceholder(videoModelItem.cover),
    //     cacheConfiguration:
    //     const BetterPlayerCacheConfiguration(useCache: true))
    //     : BetterPlayerDataSource(BetterPlayerDataSourceType.file, videoUrl,
    //     placeholder: _buildVideoPlaceholder(),
    //     cacheConfiguration:
    //     const BetterPlayerCacheConfiguration(useCache: true));

    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    // betterPlayerController.videoPlayerController!.addListener(
    //     checkVideo);
    // checkVideo();
    //betterPlayerController.setupDataSource(_betterPlayerDataSource);
  }

  Widget _buildVideoPlaceholder() {
    return Image.network(Constants.catImageUrl, fit: BoxFit.cover);
  }

  void saveVideo()  {

    for (var videoUrl in _videos!) {
       saveVideoInGallery(videoUrl.videoUrl.toString());
    }
  }



  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(betterPlayerController.videoPlayerController?.value.position == const Duration(seconds: 1, minutes: 0, hours: 0)) {
      betterPlayerController.enterFullScreen();
      print('video Started');
    }



    if(betterPlayerController.videoPlayerController?.value.position == betterPlayerController.videoPlayerController?.value.duration) {
      betterPlayerController.exitFullScreen();
      print('video Ended');
    }

    // if(betterPlayerController.betterPlayerConfiguration.autoDispose == true && (betterPlayerController.isVideoInitialized()??false)) {
    //   //betterPlayerController.videoPlayerController = null;
    //   print('Flammed');
    // }


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

  Future<void> saveVideoInGallery(String videoUrl) async {
    bool isVideoAlreadySavedInDevice =
    await MediaSaver().isVideoAlreadySavedInDevice(videoUrl);

    if (!isVideoAlreadySavedInDevice) {
      // save Image to device
      if (!mounted) return;
      bool savedSuccessfully =
      await MediaSaver().saveVideoInDevice(videoUrl, context);
    //   if (savedSuccessfully) {
    //   if (!mounted) return;
    //   GlobalSnackBar.show(context, "video downloaded");
    // }
  }
  //   else {
  // if (!mounted) return;
  // GlobalSnackBar.show(context, "video already downloaded");
  // }
  }

  // ///Save video to file, so we can use it later
  // Future _saveAssetVideoToFile(String videoUrl) async {
  //   //var content = await rootBundle.load("/storage/self/primary/");
  //   var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
  //   final directory = await getApplicationDocumentsDirectory();
  //   var file = File("${directory.path}/$videoName");
  //   Uint8List bytes = file.readAsBytesSync();
  //   file.writeAsBytesSync(bytes.buffer.asUint8List());
  //   //_setupController(file.path);
  //   //return ByteData.view(bytes.buffer);
  //   //file.writeAsBytesSync(content.buffer.asUint8List());
  // }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return  File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  // void onVisibilityChanged(double visibleFraction) async {
  //   final bool? isPlaying = betterPlayerController!.isPlaying();
  //   final bool? initialized = betterPlayerController!.isVideoInitialized();
  //   if (visibleFraction >= 50) {
  //     if (initialized! && !isPlaying! && !_isDisposing) {
  //       betterPlayerController!.play();
  //     }
  //   } else {
  //     if (initialized! && isPlaying! && !_isDisposing) {
  //       betterPlayerController!.pause();
  //     }
  //   }
  // }



  // void setUpList() {
  //   list.add(Model("image", "https://images.template.net/wp-content/uploads/2016/04/27043339/Nature-Wallpaper1.jpg", "", "this is an image" ,""));
  //   list.add(Model("video", "", "https://dermill.com/vrssagelocal/videos/Jellyfish_1080_10s_5MB.mkv", "this is a test video!!" ,""));
  //  list.add(Model("image", "https://www.superiorwallpapers.com/images/lthumbs/2015-11/11290_Golden-leaves-in-this-beautiful-season-Autumn.jpg", "", "this is an image" ,""));
  //   list.add((Model("video", "", "https://www.dermill.com/vrssagelocal/videos/PromoShot.mp4", "this is an video" ,"")));
  //   list.add(Model("image", "https://fileinfo.com/img/ss/xl/jpeg_43.png", "", "this is an image" ,""));
  //   list.add(Model("video", "", "https://www.dermill.com/vrssagelocal/videos/testvideo1.mp4", "this is an video",""));
  // }

  void _setupData() {

    //ApiResponse apiResponse = ApiResponse(videoList: []);
    //for (int index = 0; index < 10; index++) {
    //var randomVideoUrl = _videos[_random.nextInt(_videos.length)];
    //dataList.add(Videos("Video $index", randomVideoUrl));
    _videos?.add(_videos![0]);
  }

  void _setupFilePathList() {

    //ApiResponse apiResponse = ApiResponse(videoList: []);
    //for (int index = 0; index < 10; index++) {
    //var randomVideoUrl = _videos[_random.nextInt(_videos.length)];
    //dataList.add(Videos("Video $index", randomVideoUrl));
    _videoUrls?.add(videoPath![0]);
  }

  void onVisibilityChanged(double fraction) {
    //print("Fraction is : $fraction");
    if (fraction == 0) {
      if (betterPlayerController.videoPlayerController != null) {
        betterPlayerController!.dispose();
        betterPlayerController.videoPlayerController = null;
        //simpleProvider.notify();
        print("Controller is disposed.");
      }
    } else {
      if (betterPlayerController.videoPlayerController == null) {
        initState();
        print("Controller is a new one.");
        //simpleProvider.notify();
      }
      /*
      if (fraction >= 0.8 && controller!.isVideoInitialized() != null && controller!.isVideoInitialized()!) {
        if (controller!.isPlaying() != null && controller!.isPlaying()!) {
          controller!.pause();
        }
        else {
          controller!.play();
        }
      }*/}}




  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


