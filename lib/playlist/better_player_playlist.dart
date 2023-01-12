import 'package:better_player/better_player.dart';
import 'package:better_player/src/configuration/better_player_configuration.dart';
import 'package:better_player/src/configuration/better_player_data_source.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:better_player/src/playlist/better_player_playlist_configuration.dart';
import 'package:better_player/src/playlist/better_player_playlist_controller.dart';


// Flutter imports:
import 'package:flutter/material.dart';

import '../list_video_example/list_video_page.dart';

///Special version of Better Player used to play videos in playlist.
class BetterPlayerPlaylist extends StatefulWidget {
  final List<BetterPlayerDataSource> betterPlayerDataSourceList;
  final BetterPlayerConfiguration betterPlayerConfiguration;
  final BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration;

  const BetterPlayerPlaylist({
    Key? key,
    required this.betterPlayerDataSourceList,
    required this.betterPlayerConfiguration,
    required this.betterPlayerPlaylistConfiguration,
  }) : super(key: key);

  @override
  BetterPlayerPlaylistState createState() => BetterPlayerPlaylistState();
}

///State of BetterPlayerPlaylist, used to access BetterPlayerPlaylistController.
class BetterPlayerPlaylistState extends State<BetterPlayerPlaylist> {
  BetterPlayerPlaylistController? _betterPlayerPlaylistController;

  BetterPlayerController? get _betterPlayerController =>
      _betterPlayerPlaylistController!.betterPlayerController;

  ///Get BetterPlayerPlaylistController
  BetterPlayerPlaylistController? get betterPlayerPlaylistController =>
      _betterPlayerPlaylistController;

  @override
  void initState() {
    _betterPlayerPlaylistController = BetterPlayerPlaylistController(
        widget.betterPlayerDataSourceList,
        betterPlayerConfiguration: widget.betterPlayerConfiguration,
        betterPlayerPlaylistConfiguration:
            widget.betterPlayerPlaylistConfiguration);
    _betterPlayerController?.addEventsListener((event){
      print("Better player event: ${event.betterPlayerEventType}");
checkVideo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(

      aspectRatio: _betterPlayerController!.getAspectRatio() ??
          BetterPlayerUtils.calculateAspectRatio(context),
      child: BetterPlayer(
        controller: _betterPlayerController!,
      ),
    );
  }

  void checkVideo(){
    Future.delayed(Duration.zero, () {
      // // Implement your calls inside these conditions' bodies :
      // if(_betterPlayerController?.videoPlayerController?.value.position == const Duration(seconds: 1, minutes: 0, hours: 0)) {
      //   //betterPlayerController.enterFullScreen();
      //   print('video Started');




      if(_betterPlayerController?.videoPlayerController?.value.position == _betterPlayerController?.videoPlayerController?.value.duration || _betterPlayerController?.videoPlayerController?.value.isPlaying == false) {
        //dispose();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ListPlayerPage()),
                (Route<dynamic> route) => false);
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>  const ListPlayerPage(),
        //   ),
        // );
        print('video Ended');

      // // navigate to the desired route
      // Navigator.pushNamed(context, const ListPlayerPage());
      // print('video Ended');
    }
    });
    // if(betterPlayerController.betterPlayerConfiguration.autoDispose == true && (betterPlayerController.isVideoInitialized()??false)) {
    //   //betterPlayerController.videoPlayerController = null;
    //   print('Flammed');
    // }


  }

  // @protected
  // @mustCallSuper
  // void deactivate() {
  //   // _betterPlayerController?.videoPlayerController?.dispose();
  //   // _betterPlayerPlaylistController!.dispose();
  //   super.deactivate();
  // }

  @override
  void dispose() {
    _betterPlayerController?.videoPlayerController?.dispose();
    _betterPlayerPlaylistController!.dispose();

    super.dispose();
  }
}
