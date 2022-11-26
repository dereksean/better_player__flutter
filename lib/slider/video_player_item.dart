
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {

  BetterPlayerController betterPlayerController;
  VideoPlayerItem({Key? key, required this.betterPlayerController}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(

      height: 300,
      width: MediaQuery.of(context).size.width,
        child:AspectRatio(
            // aspectRatio: 16 / 9,
            aspectRatio: 1,
            child: BetterPlayer(
              controller: widget.betterPlayerController,
            ))
    );
  }
}
