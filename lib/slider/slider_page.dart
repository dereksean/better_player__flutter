import 'package:better_player/better_player.dart';
import 'package:better_player_example/slider/pager_model.dart';
import 'package:better_player_example/slider/video_player_item.dart';
import 'package:better_player_example/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderPage extends StatefulWidget {

  const SliderPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  final controller = PageController();

  late BetterPlayerController betterPlayerController;
  String videoPath = "";
  String videoUrl = "";
  bool isVideoAlreadySavedInDevice = false;

  List<PagerModel> pagerList = [];

  @override
  void initState() {
    super.initState();

    videoUrl = "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4";
    createPagerList();

    _setupController(videoUrl ,0);
  }

  @override
  void dispose() {
    controller.dispose();
    _freeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var fontFamily = "IRANSansXFaNum";

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 270,
                              color: Colors.white,
                              child: PageView(
                                controller: controller,
                                onPageChanged: (index) {
                                  setState(() {
                                    _freeController();
                                    if(pagerList[index].type == "Video"){
                                      _setupController(pagerList[index].videoUrl , index);
                                    }


                                  });
                                },
                                children: _widgetList(size),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Center(
                              child: SmoothPageIndicator(
                                  controller: controller,
                                  count: pagerList.length,
                                  effect: WormEffect(
                                      spacing: 6,
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      // radius: 5,
                                      dotColor: Colors.white,
                                      activeDotColor: Colors.teal.shade700),
                                  onDotClicked: (index) => controller
                                      .animateToPage(index,
                                      duration:
                                      const Duration(milliseconds: 500),
                                      curve: Curves.easeIn)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (await Permission.storage.request().isGranted) {
                              // showDescriptionDialog();
                            } else {
                              GlobalSnackBar.show(
                                  context,"need permission");
                            }
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.only(right: 10, top: 10),
                              width: size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                // borderRadius: const BorderRadius.only(
                                //     bottomLeft: Radius.circular(6),
                                //     bottomRight: Radius.circular(6)),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.transparent,
                                      ])),
                              child: Text(
                                "description",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: fontFamily),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              String url =
                                  "https://www.instagram.com/mosayeb.masoumi/";
                              // MediaRepository().openUserInstagram(url);
                            },
                            child: Container(
                              color: Colors.red,
                              width: 25,
                              height: 25,
                            )),
                        GestureDetector(
                          child: Container(
                            width: 20,
                            height: 20,
                            color: Colors.grey,
                          ),
                          onTap: () async {
                            if (await Permission.storage.request().isGranted) {
                              // showDescriptionDialog();
                              // post to server
                            } else {
                              GlobalSnackBar.show(
                                  context, "permission needed");
                            }
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: 25,
                            height: 25,
                            color: Colors.grey,
                          ),
                          onTap: () async {
                            if (await Permission.storage.request().isGranted) {
                              // showDeleteDialog();
                              // post to server
                            } else {
                              GlobalSnackBar.show(
                                  context, "permission needed");
                            }
                          },
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }








  void createPagerList() {
    pagerList.add(PagerModel(
        "Image",
        "https://images.template.net/wp-content/uploads/2016/04/27043339/Nature-Wallpaper1.jpg",
        ""));
    pagerList.add(PagerModel(
        "Video",
        "https://www.superiorwallpapers.com/images/lthumbs/2015-11/11290_Golden-leaves-in-this-beautiful-season-Autumn.jpg",
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4"));
    pagerList.add(
        PagerModel("Image", "https://fileinfo.com/img/ss/xl/jpeg_43.png", ""));
    pagerList.add(PagerModel(
        "Video",
        "https://www.superiorwallpapers.com/images/lthumbs/2015-11/11290_Golden-leaves-in-this-beautiful-season-Autumn.jpg",
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/av1/720/Big_Buck_Bunny_720_10s_2MB.mp4"));
    pagerList.add(PagerModel(
        "Image",
        "https://images.template.net/wp-content/uploads/2016/04/27043339/Nature-Wallpaper1.jpg",
        ""));
    pagerList.add(PagerModel(
        "Video",
        "https://fileinfo.com/img/ss/xl/jpeg_43.png",
        "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4"));
    pagerList.add(PagerModel(
        "Image",
        "https://www.superiorwallpapers.com/images/lthumbs/2015-11/11290_Golden-leaves-in-this-beautiful-season-Autumn.jpg",
        ""));
  }

  List<Widget> _widgetList(Size size) {
    List<Widget> listings = [];
    int i = 0;
    for (i = 0; i < pagerList.length; i++) {
      listings.add(pagerList[i].type == "Image"
          ? SizedBox(
          width: size.width,
          height: 270,
          child: imageWidget(pagerList[i], size))
          : SizedBox(
          width: size.width,
          height: 270,
          child: GestureDetector(
            child: VideoPlayerItem(
              betterPlayerController: betterPlayerController,
            ),

            onTap: (){
              setState(() {
                // selectedVideoIndex = index;
                _freeController();
                _setupController(pagerList[i].videoUrl , i);
              });
            },

          )));
    }
    return listings;
  }

  Widget imageWidget(PagerModel item, Size size) {
    return CachedNetworkImage(
      imageUrl: item.imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            )),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(
          width: size.width,
          height: 270,
          child: const Center(child: Icon(Icons.error))),
    );
  }

  void _freeController() {
    if (betterPlayerController.isVideoInitialized() == true) {
      betterPlayerController.pause();
      betterPlayerController.dispose();
    }
  }

  void _setupController(String videoUrl, int index) {
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      // aspectRatio: 16 / 9,
        aspectRatio: 1,
        fit: BoxFit.fill,
        autoDispose: false,
        autoPlay: false,
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

    BetterPlayerDataSource? betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, videoUrl,
        placeholder: _buildVideoPlaceholder(pagerList[index].imageUrl),
        // placeholder: Container(color: Colors.red,),
        cacheConfiguration:
        const BetterPlayerCacheConfiguration(useCache: true));



    // check if video already downloaded  play video from path or else play from network
    // BetterPlayerDataSource? _betterPlayerDataSource = videoPath == ""
    //     ? BetterPlayerDataSource(BetterPlayerDataSourceType.network, videoUrl,
    //     // placeholder: _buildVideoPlaceholder(videoModelItem.cover),
    //     cacheConfiguration:
    //     const BetterPlayerCacheConfiguration(useCache: true))
    //     : BetterPlayerDataSource(BetterPlayerDataSourceType.file, videoPath,
    //     placeholder: _buildVideoPlaceholder(videoModelItem.cover),
    //     cacheConfiguration:
    //     const BetterPlayerCacheConfiguration(useCache: true));

    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    betterPlayerController.setupDataSource(betterPlayerDataSource);
  }


  Widget _buildVideoPlaceholder(String cover) {
    return Image.network(cover, fit: BoxFit.cover);
  }
}
