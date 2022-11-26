import 'dart:io';

import 'package:better_player_example/Constants.dart';



class CreateFolder{


  Future<bool> betterExampleFolderExistence() async {
    final path= Directory(Constants.BETTER_PATH);
    if ((await path.exists())){
      print("exist");
      return true;
    }else{
      print("not exist");
      path.create();
      return true;
    }
  }

  Future<bool> imageFolderExistence() async {
    final path= Directory(Constants.IMAGE_PATH);
    if ((await path.exists())){
      print("exist");
      return true;
    }else{
      print("not exist");
      path.create();
      return true;
    }
  }

  Future<bool> videoFolderExistence() async {
    // final folderName="instaly/video";
    // final path= Directory("storage/emulated/0/$folderName");
    final path= Directory(Constants.VIDEO_PATH);
    if ((await path.exists())){
      print("exist");
      return true;
    }else{
      print("not exist");
      path.create();
      return true;
    }
  }


}
