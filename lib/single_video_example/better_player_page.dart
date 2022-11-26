
import 'package:better_player/better_player.dart';
import 'package:better_player_example/create_folder.dart';
import 'package:better_player_example/media_saver.dart';
import 'package:better_player_example/snackbar.dart';
import 'package:better_player_example/video_item.dart';
// import 'package:chewie_player/create_folder.dart';
// import 'package:chewie_player/media_saver.dart';
// import 'package:chewie_player/snackbar.dart';
// import 'package:chewie_player/video_item.dart';
import 'package:flutter/material.dart';
class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {


  late BetterPlayerController betterPlayerController;
  String videoUrl = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4";
  String videoPath = "" ;
  bool sourceChecked = false;
  @override
  void initState() {

    _checkVideoAlreadySaved();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //
    return Scaffold(
      body: Container(

        child: Column(
          children: [
            Center(

              child: sourceChecked
                  ? Center(
                  child: VideoItem(
                    betterPlayerController: betterPlayerController,
                  ))
                  : Container(),
              ),

            ElevatedButton(onPressed: (){
                 saveVideoInGallery();
            }, child: Text("save movie ion gallery"))
          ],
        ),
        ),

    );



    // String url = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4";
    // return Scaffold(
    //   body: sourceChecked ? Center(
    //     child: videoPath =="" ? AspectRatio(
    //       aspectRatio: 16 / 9,
    //       child: BetterPlayer.network(
    //         url ,
    //         betterPlayerConfiguration: BetterPlayerConfiguration(aspectRatio: 16 / 9,),),
    //     ):AspectRatio(
    //     aspectRatio: 16 / 9,
    //     child: BetterPlayer.file(
    //       videoPath ,
    //       betterPlayerConfiguration: BetterPlayerConfiguration(aspectRatio: 16 / 9,),),
    //   ),
    //   ):Container()
    // );
  }


  void _freeController() {
    if (betterPlayerController != null) {
      betterPlayerController.pause();
      betterPlayerController.dispose();
    }
  }

  void _setupController(String url) {
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoDispose: false,
        autoPlay: true,
        showPlaceholderUntilPlay: true,



        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
            controlBarColor: Colors.black.withAlpha(600),
            controlBarHeight: 30,
            overflowModalColor: Colors.yellow,
            overflowModalTextColor: Colors.white,
            overflowMenuIconsColor: Colors.white,
            enableSkips: false,
            // playIcon: const AssetImage("assets/images/play_icon.png"),
            enablePlayPause: false));




    // // check if video already downloaded  play video from path or else play from network
    BetterPlayerDataSource? _betterPlayerDataSource = videoPath == ""
        ? BetterPlayerDataSource(BetterPlayerDataSourceType.network, videoUrl,
            // placeholder: _buildVideoPlaceholder(videoModelItem.cover),
            cacheConfiguration:
                const BetterPlayerCacheConfiguration(useCache: true))
        : BetterPlayerDataSource(BetterPlayerDataSourceType.file, videoPath,
            // placeholder: _buildVideoPlaceholder(videoModelItem.cover),
            cacheConfiguration:
                const BetterPlayerCacheConfiguration(useCache: true));




    betterPlayerController =
        BetterPlayerController(betterPlayerConfiguration);
    betterPlayerController.setupDataSource(_betterPlayerDataSource);
  }

  Widget _buildVideoPlaceholder(String cover) {
    return Image.network(cover, fit: BoxFit.cover);
  }

  @override
  void dispose() {
    _freeController();
    super.dispose();
  }






  Future<void> _checkVideoAlreadySaved() async {
    await CreateFolder().betterExampleFolderExistence();
    await CreateFolder().videoFolderExistence();
    bool alreadySavedInDevice = await MediaSaver().isVideoAlreadySavedInDevice(videoUrl);

    String path ="";
    if (alreadySavedInDevice) {
      path = await MediaSaver().getVideoDevicePath(videoUrl);
    }

    setState(() {
      videoPath = path;
      // videoPath = "/storage/emulated/0/tazkereh/video/e6f3a0c1-3f13-45b8-a524-bef59edc4daf.mp4";
      // videoPath = "/storage/emulated/0/BetterExample/Video/Big_Buck_Bunny_720_10s_1MB.mp4";

      sourceChecked = true;
    });
    _setupController(videoUrl);

  }

  Future<void> saveVideoInGallery() async {

    bool isVideoAlreadySavedInDevice = await MediaSaver().isVideoAlreadySavedInDevice(videoUrl);

    if (!isVideoAlreadySavedInDevice) {
      // save Image to device
      if (!mounted) return;
      bool savedSuccessfully = await MediaSaver().saveVideoInDevice(videoUrl, context);
      if (savedSuccessfully) {
        if (!mounted) return;
        GlobalSnackBar.show(context, "video downloaded");
      }
    } else {
      if (!mounted) return;
      GlobalSnackBar.show(context, "video already downloaded");
    }
  }

}
