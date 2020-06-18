import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'Model/likedImages.dart';

class WallpaperPageView extends StatefulWidget {
  WallpaperPageView({this.pageNum, this.imageSrc});
  final List<dynamic> imageSrc;
  final int pageNum;
  @override
  _WallpaperPageViewState createState() => _WallpaperPageViewState();
}

class _WallpaperPageViewState extends State<WallpaperPageView> {
  PageController _pageController;
  String imageLink;
  String result;
  bool isLoading = false;
  bool heartIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: widget.pageNum);
    imageLink = widget.imageSrc[widget.pageNum % widget.imageSrc.length]
        ['featuredImage']['sourceUrl'];
    heartIcon = likedImagesLinks.contains(imageLink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {},
        label: Row(
          children: <Widget>[
            IconButton(
              onPressed: () async {
                _settingModalBottomSheet(context);
              },
              icon: Icon(
                Icons.wallpaper,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!heartIcon) {
                    likedImagesLinks.add(imageLink);
                  } else {
                    likedImagesLinks.remove(imageLink);
                  }
                  heartIcon = !heartIcon;
                });
              },
              icon: Icon(
                heartIcon ? Icons.favorite : Icons.favorite_border,
              ),
              color: heartIcon ? Colors.pinkAccent : Colors.black,
              splashColor: !heartIcon ? Colors.pinkAccent[100] : null,
            ),
            IconButton(
              onPressed: () async {
                var request = await HttpClient().getUrl(Uri.parse(imageLink));
                var response = await request.close();
                Uint8List bytes =
                    await consolidateHttpClientResponseBytes(response);
                await Share.file(
                    'Image Share', 'WallpaperApp.jpg', bytes, 'image/jpg');
              },
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Hero(
        tag: '${widget.pageNum}',
        child: PageView.builder(
          onPageChanged: (pageNumber) {
            imageLink = widget.imageSrc[pageNumber % widget.imageSrc.length]
                ['featuredImage']['sourceUrl'];
            setState(() {
              heartIcon = likedImagesLinks.contains(imageLink);
            });
          },
          physics: BouncingScrollPhysics(),
          controller: _pageController,
//        itemCount: 100,
          itemBuilder: (context, int index) {
//          imageLink = widget.imageSrc[index % widget.imageSrc.length];
            return Image.network(
              widget.imageSrc[index % widget.imageSrc.length]['featuredImage']
                  ['sourceUrl'],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              title: Text('Home Screen'),
              onTap: () async {
                int location = WallpaperManager
                    .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;

                var file = await DefaultCacheManager().getSingleFile(imageLink);

                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location,
                );

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Lock Screen'),
              onTap: () async {
                int location = WallpaperManager
                    .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;

                var file = await DefaultCacheManager().getSingleFile(imageLink);

                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location,
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Both'),
              onTap: () async {
                int location = WallpaperManager.HOME_SCREEN;
                int location2 = WallpaperManager
                    .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;

                var file = await DefaultCacheManager().getSingleFile(imageLink);

                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location,
                );
                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location2,
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
