import 'dart:io';

import 'package:VRssage/list_video_main_example/video_list_page.dart';
import 'package:VRssage/list_video_pagination_reusable/list_video_pagination_reusable.dart';
import 'package:VRssage/list_video_reusable/reusable_video_list_page.dart';
import 'package:VRssage/services/api_service.dart';
import 'package:VRssage/single_video_example/better_player_page.dart';
import 'package:VRssage/slider/slider_page.dart';
import 'package:VRssage/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'list_video_example/list_video_page.dart';
import 'list_video_example/video_playlist.dart';
import 'media_saver.dart';
import 'model/videos_model.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  List<Videos>? _videos = [];
  List<String> _videoUrls = [];
  List<Future<String>> savedVideolist = [];

  String videoPath = "";

  bool sourceChecked = false;

  // A flag to track whether the files are currently being downloaded.
  bool _isDownloading = false;
  bool ActiveConnection = false;
  String T = "";
  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 2),
  //       () => 'Data Loaded',
  // );

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Make sure you are connected to the internet, restart the app and try again.";
      });
    }
  }

  // Future<List> test() async {
  //   var videoName = videoPath.substring(videoPath.lastIndexOf('/') + 1);
  //   var dir = await getApplicationDocumentsDirectory();
  //   String path= "${dir.path}/$videoName";
  //
  //   for (int i = 0; i < _videoUrls.length; i++) {
  //     savedVideolist.add(path);
  //
  //   }
  //   // dataSourceList.add(
  //   //   BetterPlayerDataSource(
  //   //     BetterPlayerDataSourceType.file,
  //   //     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  //   //   ),
  //   // );
  //   return savedVideolist;
  // }

  @override
  void initState() {
    super.initState();
    _ifLoaded();


  }

  _ifLoaded() async {
    if (await Permission.storage
        .request()
        .isGranted) {
      await CheckUserConnection();
      await _getData();

    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: _isDownloading
  //         ? Center(
  //       child: CircularProgressIndicator(),
  //     )
  //         : Text('Files are done downloading'),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('lib/assets/images/vrssage_banner_trans.png', fit: BoxFit.contain,height: 50),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

         FutureBuilder(

        future: Future.wait(savedVideolist), // function that returns a Future
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done && ActiveConnection == false) {
                  List<Widget> children;
                  if (ActiveConnection == false){
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: CheckUserConnection().toString() == "true"
                            ? Text('Error: $T')
                            : Text('Error: $T'),
                      ),


                    ];
                  // } else
                  //   if (_isDownloading) {
                  //   children = <Widget>[
                  //       ElevatedButton(
                  //       onPressed: () {
                  //       Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //       builder: (context) =>  const PlayListPlayerPage(),
                  //       ),
                  //       );
                  //       },
                  //     child: const Text('Go to My Videos'),
                  //
                  //     ),
                  //   ];
                  } else {
                    children = const <Widget>[

                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Downloading videos please be patient...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: children,
                    ),
                  );
                } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Downloading videos please be patient...'),
                    ),
                    CircularProgressIndicator(),
                  ],
                );}
              },
            )
            // FutureBuilder(
            //   future: Future.wait(savedVideolist), // function that returns a Future
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done && _isDownloading == true) {
            //       return ElevatedButton(
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) =>  const PlayListPlayerPage(),
            //             ),
            //           );
            //         },
            //         child: const Text('Go to My Videos'),
            //
            //       );
            //     } else {
            //       return Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text('Files are downloading...'),
            //           CircularProgressIndicator(),
            //         ],
            //       );
            //
            //     }
            //   },
            // )






          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const PlayListPlayerPage(),
          ),
        );
      },
      child: const Text('Go to My Videos'),

    );
  }


  Future<void> createFolders({required String type}) async {
    // await CreateFolder().betterExampleFolderExistence();
    // await CreateFolder().imageFolderExistence();
    // await CreateFolder().videoFolderExistence();

    type == "single"
        ? Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoPlayerPage()),
    )
        : type == "slider"
        ? Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SliderPage()),
    )
        : Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListPlayerPage()),
    );
  }

  Future<void> _getData() async {



    await ApiService().authorizeUser();
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _videos = (await ApiService().getVideos());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    //List<Videos> videos = ApiService().videos;

    for (var videoUrl in _videos!) {

      //_saveAssetVideoToFile(videoUrl.videoUrl.toString());
      await _checkVideoAlreadySaved(videoUrl.videoUrl.toString());


    }
    await saveVideo();
    await allVideosSaved();


  }

  Future<List> saveVideo() async {

      for (int i = 0; i <  _videos!.length; i++) {
        //saveVideoInGallery(videoUrl.videoUrl.toString());
        savedVideolist.add(saveVideoInGallery(_videos![i].videoUrl.toString()));
      }
      _isDownloading = true;


    return savedVideolist;
  }

  Future<void> allVideosSaved() async {
    await Future.wait(savedVideolist);
    //_isDownloading = true;
    if (_isDownloading = true && savedVideolist.isNotEmpty) {
      routeToVideoPlayer();
    }
  }

  void routeToVideoPlayer() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PlayListPlayerPage()),
    );
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

    //test();
    return _videoUrls;


    // setState(() {
    //   videoPath = path;
    //   sourceChecked = true;
    // });
    //_setupController("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4");
  }

  Future<String> saveVideoInGallery(String videoUrl) async {
    var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);

    bool isVideoAlreadySavedInDevice =
    await MediaSaver().isVideoAlreadySavedInDevice(videoUrl);

    if (!isVideoAlreadySavedInDevice) {

      // save Image to device
      if (!mounted) return "Not mounted!";
      bool _isDownloading =
      await MediaSaver().saveVideoInDevice(videoUrl, context);
      //_isDownloading = true;


      if (_isDownloading) {
        if (!mounted) return "Not mounted!";
        GlobalSnackBar.show(context, videoName + " downloaded");
        //_isDownloading = false;


      }


      //   else {
      // if (!mounted) return;
      // GlobalSnackBar.show(context, "video already downloaded");
      // }
    }
    //savedVideolist.add(videoUrl);
    return "done";

  }

  @override
  void dispose() {
    // if (betterPlayerController.isPlaying() == true) betterPlayerController.pause();
    // betterPlayerController.removeEventsListener((p0) => null);
    // betterPlayerController.videoPlayerController == null;
    // _isDisposing = true;
    //if (betterPlayerController.videoPlayerController != null) {




    //betterPlayerController.videoPlayerController = null;
    //print("Disposed controller from Framework.");
    //}
    super.dispose();

  }

}
