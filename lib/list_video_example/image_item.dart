import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageItem extends StatefulWidget {
  String imageUrl;
  String description;

  ImageItem({Key? key, required this.imageUrl, required this.description})
      : super(key: key);

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 250,
      width: size.width,
      child: Center(
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: 250,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                )),
              ),
              placeholder: (context, url) => SizedBox(
                  height: 250,
                  width: size.width,
                  child: const Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => SizedBox(
                  height: 250,
                  width: size.width,
                  child: const Center(child: Icon(Icons.error))),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(right: 10, top: 10),
                width: size.width,
                height: 40,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Colors.black,
                      Colors.transparent,
                    ])),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     padding: const EdgeInsets.only(right: 10, top: 10),
            //     width: size.width,
            //     height: 40,
            //     decoration: const BoxDecoration(
            //
            //         gradient: LinearGradient(
            //             begin: Alignment.bottomCenter,
            //             end: Alignment.topCenter,
            //             colors: [
            //               Colors.black,
            //               Colors.transparent,
            //             ])),
            //     child: Text(
            //       widget.description,
            //       textAlign: TextAlign.end,
            //       style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 17,),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
    //
    //
  }
}
