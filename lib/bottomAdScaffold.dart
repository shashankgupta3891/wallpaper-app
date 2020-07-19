import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'adUnit/adUnitId.dart';
import 'wallpaperPageView.dart';

class BottomAdScaffold extends StatelessWidget {
  final List<dynamic> imageSrc;
  final int pageNum;
  final bool isLikedWallpaper;

  BottomAdScaffold({this.imageSrc, this.pageNum, this.isLikedWallpaper});

  final double bottomBannerAdSize = 60;
  final AdmobBannerSize bannerSize = AdmobBannerSize.BANNER;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height - bottomBannerAdSize,
            width: MediaQuery.of(context).size.width,
            child: WallpaperPageView(
              isLikedWallpaper: isLikedWallpaper,
              pageNum: pageNum,
              imageSrc: imageSrc,
            ),
          ),
          SizedBox(
            height: bottomBannerAdSize,
            width: MediaQuery.of(context).size.width,
            child: AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: bannerSize,
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
//          handleEvent(event, args, 'Banner');
              },
            ),
          )
        ],
      ),
    );
    ;
  }
}
