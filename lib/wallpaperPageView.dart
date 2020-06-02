import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class WallpaperPageView extends StatefulWidget {
  WallpaperPageView({this.pageNum, this.imageSrc});
  final List<String> imageSrc;
  final int pageNum;
  @override
  _WallpaperPageViewState createState() => _WallpaperPageViewState();
}

class _WallpaperPageViewState extends State<WallpaperPageView> {
  PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: widget.pageNum);
  }

  @override
  Widget build(BuildContext context) {
    String imageLink;
    return Scaffold(
//      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {},
        label: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.save,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () async {
                var request = await HttpClient().getUrl(Uri.parse(imageLink));
                var response = await request.close();
                Uint8List bytes =
                    await consolidateHttpClientResponseBytes(response);
                await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
              },
              icon: Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
//        itemCount: 100,
        itemBuilder: (context, int index) {
          imageLink = widget.imageSrc[index % widget.imageSrc.length];
          return Image.network(
            widget.imageSrc[index % widget.imageSrc.length],
            fit: BoxFit.cover,
          );
//          return Container(
//            color: Colors.blue[(index * 100) % 1000],
//          );
        },
      ),
    );
  }
}
