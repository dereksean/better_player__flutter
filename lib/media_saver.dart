import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Constants.dart';

class MediaSaver{



  /*************************************************** image operations *****************************************************/

  Future<bool> isImageAlreadySavedInDevice(String profilePicUrl) async {
    var imageName = profilePicUrl.substring(profilePicUrl.lastIndexOf('/') + 1);
    final path= Constants.IMAGE_PATH+"/"+ imageName;

    // bool directoryExists = await Directory(path).exists();
    bool fileExists = await File(path).exists();
    if(fileExists) {
      return true;
    }
    return false;
  }



  Future<bool> saveImageInDevice(String profilePicUrl, BuildContext context) async{
    var imageName = profilePicUrl.substring(profilePicUrl.lastIndexOf('/') + 1);
    final path= Constants.IMAGE_PATH+"/"+ imageName;
    try{
      await Dio().download(profilePicUrl, path);
      await GallerySaver.saveImage(profilePicUrl);
      return true;
    }catch(e){
       return false;
    }
  }


  Future<bool> deleteImageFile(String url) async {

    var imageName = url.substring(url.lastIndexOf('/') + 1);
    final path= Constants.IMAGE_PATH+"/"+ imageName;

    File file = File(path);

    try {
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      return false;
      // Error in getting access to the file.
    }
  }


  /*************************************************** video operations *****************************************************/


  Future<bool> isVideoAlreadySavedInDevice(String videoUrl) async {
    var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
    final path= Constants.VIDEO_PATH+"/"+ videoName;

    // bool directoryExists = await Directory(path).exists();
    bool fileExists = await File(path).exists();
    if(fileExists) {
      return true;
    }
    return false;
  }

  Future<bool> saveVideoInDevice(String videoUrl, BuildContext context) async{
    var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
    final path= Constants.VIDEO_PATH+"/"+ videoName;
    try{
      await Dio().download(videoUrl, path);
      await GallerySaver.saveVideo(videoUrl);
      return true;
    }catch(e){
      return false;
    }
  }


  Future<bool> deleteVideoFile(String videoUrl) async {

    var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
    final path= Constants.VIDEO_PATH+"/"+ videoName;

    File file = File(path);

    try {
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      return false;
      // Error in getting access to the file.
    }
  }









  // final path= Directory(Constants.IMAGE_PATH);

  Future<String> getVideoDevicePath(String videoUrl) async {
    var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
    final path= Constants.VIDEO_PATH+"/"+ videoName;

    final directory= Directory(Constants.VIDEO_PATH);

    bool fileExists = await File(path).exists();

    bool ss = fileExists;
    try{
      return path;
      // return "${directory.path}/$videoName";
    }catch (e){
      return "";

      // "${directory.path}/testvideo.mp4"
    }
  }



  // Future<String> getVideoDevicePath(String videoUrl) async {
  //   var videoName = videoUrl.substring(videoUrl.lastIndexOf('/') + 1);
  //   final directory = Directory(Constants.VIDEO_PATH);
  //   return "${directory.path}/$videoName";
  // }



    // final directory = await getApplicationDocumentsDirectory();
    // return "${directory.path}/$fileName";



}