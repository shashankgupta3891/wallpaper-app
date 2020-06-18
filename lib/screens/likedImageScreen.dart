import 'package:flutter/material.dart';
import '../Model/likedImages.dart';
import '../wallpaperPageView.dart';

class LikedImageScreen extends StatefulWidget {
  @override
  _LikedImageScreenState createState() => _LikedImageScreenState();
}

class _LikedImageScreenState extends State<LikedImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey[(index * 100) % 1000],
                      child: Image.network(
                        likedImagesLinks[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              childCount: likedImagesLinks.length,
            ),
          ),
        ],
      ),
    );
  }
}
