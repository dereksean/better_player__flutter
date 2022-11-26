
import 'package:better_player/better_player.dart';
import 'package:better_player/src/core/better_player_controller.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatefulWidget {

  BetterPlayerController betterPlayerController;
  VideoItem({Key? key, required this.betterPlayerController}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {

  BetterPlayerController get betterPlayerController => widget.betterPlayerController;

  @override
  Widget build(BuildContext context) {
    return Container(

        child:AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: betterPlayerController,
              //     controller: controller!,
            ))
    );
  }
}
