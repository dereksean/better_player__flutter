// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

String userToken = '';
String videosToJson(List<Videos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Videos {


  List<Videos> videoModelFromJson(String str) => List<Videos>.from(json.decode(str).map((x) => Videos.fromJson(x)));

  int? videoId;
  String? videoCk;
  String? videoTitle;
  String? videoDescription;
  String? videoUrl;
  int? videoTier;
  int? organizationId;
  DateTime? dateCreated;
  bool? isActive;
  String? fileName;
  dynamic file;
  Duration? lastPosition;
  bool? wasPlaying = false;

  Videos({
     this.videoId,
     this.videoCk,
     this.videoTitle,
     this.videoDescription,
     this.videoUrl,
     this.videoTier,
     this.organizationId,
     this.dateCreated,
     this.isActive,
     this.fileName,
    this.file,
  });



  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
    videoId: json["videoId"],
    videoCk: json["videoCk"],
    videoTitle: json["videoTitle"],
    videoDescription: json["videoDescription"],
    videoUrl: json["videoUrl"],
    videoTier: json["videoTier"],
    organizationId: json["organizationId"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    isActive: json["isActive"],
    fileName: json["fileName"],
    file: json["file"],
  );
  }



  Map<String, dynamic> toJson() => {
    "videoId": videoId,
    "videoCk": videoCk,
    "videoTitle": videoTitle,
    "videoDescription": videoDescription,
    "videoUrl": videoUrl,
    "videoTier": videoTier,
    "organizationId": organizationId,
    "dateCreated": dateCreated?.toIso8601String(),
    "isActive": isActive,
    "fileName": fileName,
    "file": file,
  };
}
