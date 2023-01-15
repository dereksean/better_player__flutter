import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

import '../Constants.dart';

class VideoListItem extends StatefulWidget {
  final String videoUrl;

   VideoListItem(this.videoUrl);

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    buck();
    // <--- Here
  }

  Widget _buildVideoPlaceholder() {
    return Image.network(Constants.catImageUrl, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(
      controller: _betterPlayerController,
    );
  }


  void buck() {
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            autoDispose: true,
            autoPlay: false,
            looping: false,
            startAt: Duration(seconds: 1),
            fit: BoxFit.cover,
            fullScreenByDefault: false,
            showPlaceholderUntilPlay: true,
            handleLifecycle: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                controlBarColor: Colors.black.withAlpha(600),
                controlsHideTime: const Duration(seconds: 5),
                controlBarHeight: 30,
                overflowModalColor: Colors.yellow,
                overflowModalTextColor: Colors.white,
                overflowMenuIconsColor: Colors.white,
                enableFullscreen: true,
                enableSkips: false,
                // playIcon: const AssetImage("assets/images/play_icon.png"),
                enablePlayPause: true)
        ),
        betterPlayerDataSource: BetterPlayerDataSource.file(widget.videoUrl,
          // placeholder: Container(
          //   color: Colors.transparent,
          //   child: Center(
          //     child: _buildVideoPlaceholder(),
          //
          //     // Icon(
          //     //   Icons.play_circle,
          //     //   color: Colors.red,
          //     //   size: 60,
          //     // )
          //   ),
          // ),
        ));

    _betterPlayerController.play();
    _betterPlayerController.pause();
    _betterPlayerController.videoPlayerController!.addListener(
        checkVideo);
  }



  void checkVideo(){
    // // Implement your calls inside these conditions' bodies :
    // Future.delayed(Duration.zero, () {
    //   if (_betterPlayerController.videoPlayerController?.value.position ==
    //       const Duration(seconds: 1, minutes: 0, hours: 0)) {
    //     _betterPlayerController.enterFullScreen();
    //     print('video Started');
    //   }
    // });

    Future.delayed(Duration.zero, () {
    if (_betterPlayerController.videoPlayerController?.value.isPlaying == true && _betterPlayerController.isFullScreen == false ) {
      // Enter fullscreen mode when the video starts playing
      _betterPlayerController.enterFullScreen();
    }
    });

    if(_betterPlayerController.videoPlayerController?.value.position == _betterPlayerController.videoPlayerController?.value.duration || _betterPlayerController.videoPlayerController?.value.isPlaying == false) {
      _betterPlayerController.exitFullScreen();


      print('video Ended');
    }

    // if(betterPlayerController.betterPlayerConfiguration.autoDispose == true && (betterPlayerController.isVideoInitialized()??false)) {
    //   //betterPlayerController.videoPlayerController = null;
    //   print('Flammed');
    // }


  }

  @override
  void dispose() {
    _betterPlayerController.videoPlayerController!.removeListener(checkVideo);
    _betterPlayerController.videoPlayerController!.dispose();
    _betterPlayerController.dispose();
    super.dispose();
  }


}