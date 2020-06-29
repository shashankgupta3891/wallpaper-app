import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wallpaperPageView.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'homeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dart:convert';

import '../Model/likedImages.dart';

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        label: Text(
          "Liked",
          style: TextStyle(color: Colors.black),
        ),
        icon: Icon(
          Icons.favorite,
          color: Colors.pinkAccent,
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
                title: Text("hello"),
                floating: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                  color: Colors.grey,
                )),
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
                          tag: '$index',
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
