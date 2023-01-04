import 'package:better_player_example/list_video_main_example/video_list_page.dart';
import 'package:better_player_example/list_video_pagination_reusable/list_video_pagination_reusable.dart';
import 'package:better_player_example/list_video_reusable/reusable_video_list_page.dart';
import 'package:better_player_example/services/api_service.dart';
import 'package:better_player_example/single_video_example/better_player_page.dart';
import 'package:better_player_example/slider/slider_page.dart';
import 'package:better_player_example/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'list_video_example/list_video_page.dart';
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

  String videoPath = "";

  bool sourceChecked = false;

  // A flag to track whether the files are currently being downloaded.
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _ifLoaded();


  }

  _ifLoaded() async {
    if (await Permission.storage
        .request()
        .isGranted) {
      _getData();
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
        title: Image.asset('lib/assets/images/vrssagelogomain.png', fit: BoxFit.contain,height: 50),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            FutureBuilder(
              future: saveVideoInGallery(videoPath), // function that returns a Future
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListPlayerPage(),
                        ),
                      );
                    },
                    child: const Text('Go to My Videos'),

                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Files are downloading...'),
                      CircularProgressIndicator(),
                    ],
                  );

                }
              },
            )






          ],
        ),
      ),
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

  void _getData() async {



    await ApiService().authorizeUser();
    //Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    _videos = (await ApiService().getVideos());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    List<Videos> videos = ApiService().videos;

    for (var videoUrl in _videos!) {

      //_saveAssetVideoToFile(videoUrl.videoUrl.toString());
      _checkVideoAlreadySaved(videoUrl.videoUrl.toString());


    }
    saveVideo();

  }

  void saveVideo()  {

    for (var videoUrl in _videos!) {
      saveVideoInGallery(videoUrl.videoUrl.toString());
    }
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
      _isDownloading = true;


        if (savedSuccessfully) {
        if (!mounted) return;
        GlobalSnackBar.show(context, "videos downloaded");
        _isDownloading = false;


      }
      setState(() {

    });
    //   else {
    // if (!mounted) return;
    // GlobalSnackBar.show(context, "video already downloaded");
    // }
  }

}}
