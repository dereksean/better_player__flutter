import 'package:better_player/better_player.dart';
import 'package:better_player_example/list_video_main_example/video_list_data.dart';
import 'package:flutter/material.dart';

import '../model/videos_model.dart';

class VideoListWidget extends StatefulWidget {
  final Videos? videos;

  const VideoListWidget({Key? key, this.videos}) : super(key: key);

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  Videos? get videos => widget.videos;
  BetterPlayerConfiguration? betterPlayerConfiguration;
  BetterPlayerListVideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller = BetterPlayerListVideoPlayerController();
    betterPlayerConfiguration = BetterPlayerConfiguration(autoPlay: false);
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              videos!.videoTitle.toString(),
              style: const TextStyle(fontSize: 50),
            ),
          ),
          AspectRatio(
              aspectRatio: 1,
              child:BetterPlayerListVideoPlayer(
                BetterPlayerDataSource(
                  BetterPlayerDataSourceType.network,
                  videos!.videoUrl.toString(),
                  // notificationConfiguration:
                  // BetterPlayerNotificationConfiguration(
                  //     showNotification: false,
                  //     title: videoListData!.videoTitle,
                  //     author: "Test"),
                  bufferingConfiguration: const BetterPlayerBufferingConfiguration(
                      minBufferMs: 2000,
                      maxBufferMs: 10000,
                      bufferForPlaybackMs: 1000,
                      bufferForPlaybackAfterRebufferMs: 2000),
                ),
                configuration: const BetterPlayerConfiguration(
                    showPlaceholderUntilPlay: true,
                    autoPlay: false, aspectRatio: 1, handleLifecycle: true),
                //key: Key(videoListData.hashCode.toString()),
                // playFraction: 0.8,
                //playFraction: 0.9,
                betterPlayerListVideoPlayerController: controller,
              )),
          // const Padding(
          //   padding: EdgeInsets.all(8),
          //   child: Text(
          //       "Horror: In Steven Spielberg's Jaws, a shark terrorizes a beach "
          //           "town. Plainspoken sheriff Roy Scheider, hippie shark "
          //           "researcher Richard Dreyfuss, and a squirrely boat captain "
          //           "set out to find the beast, but will they escape with their "
          //           "lives? 70's special effects, legendary score, and trademark "
          //           "humor set this classic apart."),
          // ),
          // Center(
          //   child: Wrap(children: [
          //     ElevatedButton(
          //       child: Text("Play"),
          //       onPressed: () {
          //         controller!.play();
          //       },
          //     ),
          //     const SizedBox(width: 8),
          //     ElevatedButton(
          //       child: Text("Pause"),
          //       onPressed: () {
          //         controller!.pause();
          //       },
          //     ),
          //     const SizedBox(width: 8),
          //     ElevatedButton(
          //       child: Text("Set max volume"),
          //       onPressed: () {
          //         controller!.setVolume(100);
          //       },
          //     ),
          //   ]),
          // ),
        ],
      ),
    );
  }
}