import 'package:better_player/better_player.dart';
import 'package:better_player_example/list_video_example/image_item.dart';
import 'package:better_player_example/list_video_example/model.dart';
import 'package:better_player_example/list_video_example/video_item.dart';
import 'package:flutter/material.dart';
import 'package:better_player_example/model/videos_model.dart';
import 'package:better_player_example/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../media_saver.dart';
import '../services/apiResponse.dart';
import '../snackbar.dart';

class ListPlayerPage extends StatefulWidget {
  const ListPlayerPage({Key? key}) : super(key: key);

  @override
  State<ListPlayerPage> createState() => _ListPlayerPageState();
}

class _ListPlayerPageState extends State<ListPlayerPage> with AutomaticKeepAliveClientMixin<ListPlayerPage>  {
  //List<Model> list = [];
   List<Videos>? _videos = [];
  late BetterPlayerController betterPlayerController;
   //late BetterPlayerConfiguration betterPlayerConfiguration;
   bool _isDisposing = false;
  String videoPath = "";

  bool sourceChecked = false;

  int selectedVideoIndex = -1 ;
  var value = 0;

  @override
  void initState() {

    // betterPlayerController = BetterPlayerController(BetterPlayerConfiguration());
    super.initState();
    _getData();

    //setUpList();

    _checkVideoAlreadySaved();
    saveVideoInGallery();
    //_setupController("https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4");
     _setupController("");

    //_setupData();
    onVisibilityChanged(100);
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
       print("Disposed controller from Framework.");
     }
     super.dispose();

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
    Size size = MediaQuery.of(context).size;



    return Scaffold(
        body: Container(

      padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      height: size.height,
      width: size.width,

      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _videos?.length,
          itemBuilder: (context, index) =>
           // list[index].type == "image"
           //      ? ImageItem(
           //          imageUrl: list[index].imageUrl,
           //          description: list[index].description)
                 GestureDetector(
                    child: VideoItem(
                        canBuild: selectedVideoIndex == index ? true : false,
                        betterPlayerController: betterPlayerController,
                        description: _videos![index].videoTitle.toString(),
                        videoUrl: _videos![index].videoUrl.toString()),
                    onTap: () {
                      // if(selectedVideoIndex==-1||(betterPlayerController.isVideoInitialized()??false) ) {

                      setState(() {

                        value++;
                        selectedVideoIndex = index;


                        _setupController(_videos![index].videoUrl.toString());
                        //_freeController();

                      });

                      betterPlayerController.videoPlayerController!.addListener(checkVideo);
                      checkVideo();

                      // }
                    },
          ),


      // ),
    )));
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

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(

            // aspectRatio: 16 / 9,
            aspectRatio: 1,
            fit: BoxFit.fill,
            handleLifecycle: true,
            autoDispose: true,
            autoPlay: true,
            fullScreenByDefault: true,

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
                enablePlayPause: true));

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

    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    betterPlayerController.setupDataSource(_betterPlayerDataSource);
  }

  Widget _buildVideoPlaceholder(String cover) {
    return Image.network(cover, fit: BoxFit.cover);
  }

  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    // if(betterPlayerController.videoPlayerController?.value.position == const Duration(seconds: 0, minutes: 0, hours: 0)) {
    //
    //   //print('video Started');
    // }



    if(betterPlayerController.videoPlayerController?.value.position == betterPlayerController.videoPlayerController?.value.duration) {
      betterPlayerController.exitFullScreen();
      //print('video Ended');
    }

    if(betterPlayerController.betterPlayerConfiguration.autoDispose == true && (betterPlayerController.isVideoInitialized()??false)) {
      //betterPlayerController.videoPlayerController = null;
      print('Flammed');
    }

  }




Future<void> _checkVideoAlreadySaved() async {
    bool alreadySavedInDevice =
        await MediaSaver().isVideoAlreadySavedInDevice("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4");

    String path = "/storage/self/primary/Download";
    if (alreadySavedInDevice) {
      path = await MediaSaver().getVideoDevicePath("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4");
    }

    // setState(() {
    //   videoPath = path;
    //   sourceChecked = true;
    // });
    //_setupController("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4");
  }

  Future<void> saveVideoInGallery() async {
    bool isVideoAlreadySavedInDevice =
        await MediaSaver().isVideoAlreadySavedInDevice("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4");

    if (!isVideoAlreadySavedInDevice) {
      // save Image to device
      if (!mounted) return;
      bool savedSuccessfully =
          await MediaSaver().saveVideoInDevice("https://vrssagestorage.blob.core.windows.net/fileupload/desert.mp4", context);
      if (savedSuccessfully) {
        if (!mounted) return;
        GlobalSnackBar.show(context, "video downloaded");
      }
    } else {
      if (!mounted) return;
      GlobalSnackBar.show(context, "video already downloaded");
    }
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
  bool get wantKeepAlive => true;

  }

