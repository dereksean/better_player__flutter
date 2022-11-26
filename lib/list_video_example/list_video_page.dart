import 'package:better_player/better_player.dart';
import 'package:better_player_example/list_video_example/image_item.dart';
import 'package:better_player_example/list_video_example/model.dart';
import 'package:better_player_example/list_video_example/video_item.dart';
import 'package:flutter/material.dart';

class ListPlayerPage extends StatefulWidget {
  const ListPlayerPage({Key? key}) : super(key: key);

  @override
  State<ListPlayerPage> createState() => _ListPlayerPageState();
}

class _ListPlayerPageState extends State<ListPlayerPage> {
  List<Model> list = [];

  late BetterPlayerController betterPlayerController;
  String videoPath = "";

  bool sourceChecked = false;

  int selectedVideoIndex = -1 ;

  @override
  void initState() {

    // betterPlayerController = BetterPlayerController(BetterPlayerConfiguration());
    super.initState();
    setUpList();

    _setupController("https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4");
    // _setupController("");
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
          itemCount: list.length,
          itemBuilder: (context, index) =>
           list[index].type == "image"
                ? ImageItem(
                    imageUrl: list[index].imageUrl,
                    description: list[index].description)
                : GestureDetector(
                    child: VideoItem(
                        canBuild: selectedVideoIndex == index ? true : false,
                        betterPlayerController: betterPlayerController,
                        description: list[index].description,
                        videoUrl: list[index].videoUrl),
                    onTap: () {
                      // if(selectedVideoIndex==-1||(betterPlayerController.isVideoInitialized()??false) ) {

                      setState(() {
                        selectedVideoIndex = index;
                        _freeController();
                        _setupController(list[index].videoUrl);
                      });
                      // }
                    },
          ),


      // ),
    )));
  }

  void _freeController() {
    if (betterPlayerController != null && betterPlayerController.isVideoInitialized() == true) {
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

    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
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

  // Future<void> _checkVideoAlreadySaved() async {
  //   bool alreadySavedInDevice =
  //       await MediaSaver().isVideoAlreadySavedInDevice("videoUrl");
  //
  //   String path = "";
  //   if (alreadySavedInDevice) {
  //     path = await MediaSaver().getVideoDevicePath("videoUrl");
  //   }
  //
  //   setState(() {
  //     videoPath = path;
  //     sourceChecked = true;
  //   });
  //   _setupController("videoUrl");
  // }
  //
  // Future<void> saveVideoInGallery() async {
  //   bool isVideoAlreadySavedInDevice =
  //       await MediaSaver().isVideoAlreadySavedInDevice("videoUrl");
  //
  //   if (!isVideoAlreadySavedInDevice) {
  //     // save Image to device
  //     if (!mounted) return;
  //     bool savedSuccessfully =
  //         await MediaSaver().saveVideoInDevice("videoUrl", context);
  //     if (savedSuccessfully) {
  //       if (!mounted) return;
  //       GlobalSnackBar.show(context, "video downloaded");
  //     }
  //   } else {
  //     if (!mounted) return;
  //     GlobalSnackBar.show(context, "video already downloaded");
  //   }
  // }

  void setUpList() {
    list.add(Model("image", "https://images.template.net/wp-content/uploads/2016/04/27043339/Nature-Wallpaper1.jpg", "", "this is an image" ,""));
    list.add(Model("video", "", "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4", "this is an video" ,""));
    list.add(Model("image", "https://www.superiorwallpapers.com/images/lthumbs/2015-11/11290_Golden-leaves-in-this-beautiful-season-Autumn.jpg", "", "this is an image" ,""));
    list.add((Model("video", "", "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_2MB.mp4", "this is an video" ,"")));
    list.add(Model("image", "https://fileinfo.com/img/ss/xl/jpeg_43.png", "", "this is an image" ,""));
    list.add(Model("video", "", "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4", "this is an video",""));
  }
}
