import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:hive/hive.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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

  String id;

  List<dynamic> imageSrc;

  Box likedImg;

  String blurCode;

  // double bottomBannerAdSize = 60;

  @override
  void initState() {
    super.initState();

    likedImg = Hive.box('likedImg');

    imageSrc = [
      ...widget.imageSrc
    ]; // Copy Data from widget.imageSrc to imageSrc

    _pageController = PageController(initialPage: widget.pageNum);
    if (widget.isLikedWallpaper) {
      id = imageSrc[widget.pageNum % imageSrc.length]['id'];
      blurCode = imageSrc[widget.pageNum % imageSrc.length]['blurStr'];
      imageLink = imageSrc[widget.pageNum % imageSrc.length]['img'];
    } else {
      id = imageSrc[widget.pageNum % imageSrc.length]['id'];
      imageLink = imageSrc[widget.pageNum % imageSrc.length]['featuredImage']
          ['node']['sourceUrl'];
    }

    heartIcon = likedImg.containsKey(id);
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    return Scaffold(
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
                    likedImg.put(
                      id,
                      {
                        'id': id,
                        'img': imageLink,
                        'blueStr': 'JANllQ0000?w00yE'
                      },
                    );
                  } else {
                    print(likedImg.get(id));
                    likedImg.delete(id);

                    print(likedImg.get(id));

                    print(id);
                    print(likedImg.keys);
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
        tag: widget.isLikedWallpaper
            ? 'l${widget.pageNum}'
            : '${widget.pageNum}',
        child: PageView.builder(
          onPageChanged: (pageNumber) {
            //Calling InterstitialAd

            if (widget.isLikedWallpaper) {
              id = imageSrc[pageNumber % imageSrc.length]['id'];
              blurCode = imageSrc[pageNumber % imageSrc.length]['blurStr'];
              imageLink = imageSrc[pageNumber % imageSrc.length]['img'];
            } else {
              id = imageSrc[pageNumber % imageSrc.length]['id'];
              imageLink = imageSrc[pageNumber % imageSrc.length]
                  ['featuredImage']['node']['sourceUrl'];
            }
            setState(() {
              heartIcon = likedImg.containsKey(id);
            });
          },
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: imageSrc.length,
          itemBuilder: (context, int index) {
//          imageLink = widget.imageSrc[index % widget.imageSrc.length];
            return Image.network(
              widget.isLikedWallpaper
                  ? imageSrc[index % imageSrc.length]['img']
                  : imageSrc[index % imageSrc.length]['featuredImage']['node']
                      ['sourceUrl'],
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
