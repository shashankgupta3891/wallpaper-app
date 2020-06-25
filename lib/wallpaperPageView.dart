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
import 'package:progress_dialog/progress_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WallpaperPageView extends StatefulWidget {
  WallpaperPageView(
      {this.pageNum, this.imageSrc, this.isLikedWallpaper = false});
  final List<dynamic> imageSrc;
  final int pageNum;
  final bool isLikedWallpaper;
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
    if (widget.isLikedWallpaper) {
      imageLink = widget.imageSrc[widget.pageNum % widget.imageSrc.length];
    } else {
      imageLink = widget.imageSrc[widget.pageNum % widget.imageSrc.length]
          ['featuredImage']['sourceUrl'];
    }

    heartIcon = LikedImages.images.contains(imageLink);
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
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
                _settingModalBottomSheet(context, pr);
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
                    LikedImages.images.add(imageLink);
                  } else {
                    LikedImages.images.remove(imageLink);
                  }
                  heartIcon = !heartIcon;
                });
              },
              icon: Icon(
                heartIcon
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
              ),
              color: heartIcon ? Colors.pinkAccent : Colors.black,
              splashColor: !heartIcon ? Colors.pinkAccent[100] : null,
            ),
            IconButton(
              onPressed: () async {
                await pr.show();
                var request = await HttpClient().getUrl(Uri.parse(imageLink));
                var response = await request.close();
                Uint8List bytes =
                    await consolidateHttpClientResponseBytes(response);
                await Share.file(
                    'Image Share', 'WallpaperApp.jpg', bytes, 'image/jpg');
                await pr.hide();
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
            if (widget.isLikedWallpaper) {
              imageLink = widget.imageSrc[pageNumber % widget.imageSrc.length];
            } else {
              imageLink = widget.imageSrc[pageNumber % widget.imageSrc.length]
                  ['featuredImage']['sourceUrl'];
            }
            setState(() {
              heartIcon = LikedImages.images.contains(imageLink);
            });
          },
          physics: BouncingScrollPhysics(),
          controller: _pageController,
//        itemCount: 100,
          itemBuilder: (context, int index) {
//          imageLink = widget.imageSrc[index % widget.imageSrc.length];
            return Image.network(
              widget.isLikedWallpaper
                  ? widget.imageSrc[index % widget.imageSrc.length]
                  : widget.imageSrc[index % widget.imageSrc.length]
                      ['featuredImage']['sourceUrl'],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, ProgressDialog pr) {
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
                await pr.show();
                var file = await DefaultCacheManager().getSingleFile(imageLink);

                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location,
                );
                await pr.hide();

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Lock Screen'),
              onTap: () async {
                int location = WallpaperManager
                    .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
                await pr.show();
                var file = await DefaultCacheManager().getSingleFile(imageLink);

                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location,
                );
                await pr.hide();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Both'),
              onTap: () async {
                int location = WallpaperManager.HOME_SCREEN;
                int location2 = WallpaperManager
                    .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
                await pr.show();
                var file = await DefaultCacheManager().getSingleFile(imageLink);

                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location,
                );
                result = await WallpaperManager.setWallpaperFromFile(
                  file.path,
                  location2,
                );
                await pr.hide();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
