import 'package:better_player/better_player.dart';
import 'package:better_player/src/core/better_player_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatefulWidget {
  bool canBuild;
  BetterPlayerController betterPlayerController;
  String description;
  String videoUrl;

  VideoItem(
      {Key? key,
      required this.canBuild,
      required this.betterPlayerController,
      required this.description,
      required this.videoUrl})
      : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var a = 0;
    return Container(
      // padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      height: 250,
      width: size.width,
      child: Stack(
        children: [

          widget.canBuild
              ? Container(
            height: 250,
            width: size.width,
                child: AspectRatio(
                    // aspectRatio: 16 / 9,
                    // aspectRatio: 360 / 243,
                    aspectRatio: 1,
                    child: BetterPlayer(
                      controller: widget.betterPlayerController,
                    )),
              )
              : Container(
                  height: 250,
                  width: size.width,
                  color: Colors.green,
                  child: const Center(
                      child: Icon(
                    Icons.play_circle,
                    color: Colors.red,
                        size: 60,
                  )),
                ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     padding: const EdgeInsets.only(right: 10, top: 10),
          //     width: size.width,
          //     height: 40,
          //     decoration: const BoxDecoration(
          //         gradient: LinearGradient(
          //             begin: Alignment.bottomCenter,
          //             end: Alignment.topCenter,
          //             colors: [
          //           Colors.black,
          //           Colors.transparent,
          //         ])),
          //     child: Text(
          //       widget.description,
          //       textAlign: TextAlign.end,
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 17,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }



}
