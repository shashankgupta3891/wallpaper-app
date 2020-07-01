import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wallpaperPageView.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LikedImageScreen extends StatefulWidget {
  LikedImageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LikedImageScreenState createState() => _LikedImageScreenState();
}

class _LikedImageScreenState extends State<LikedImageScreen> {
  final Box likedImg = Hive.box('likedImg');

  List imageList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(likedImg.values.toList());
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          likedImg.deleteAll(likedImg.keys.toList());
        },
        label: Text(
          "Delete All",
          style: TextStyle(color: Colors.black),
        ),
        icon: Icon(
          Icons.cancel,
          color: Colors.redAccent,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: likedImg.listenable(),
        builder: (context, box, _) {
          imageList = box.values.toList();
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                title: Text("Liked Poster"),
                floating: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.pinkAccent,
                    child: Image.network(
                      'https://images.pexels.com/photos/2045600/pexels-photo-2045600.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    String image = imageList[index]['img'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WallpaperPageView(
                              pageNum: index,
                              imageSrc: imageList,
                              isLikedWallpaper: true,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Hero(
                          tag: 'l$index',
                          child: Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.grey[(index * 100) % 1000],
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: imageList.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
