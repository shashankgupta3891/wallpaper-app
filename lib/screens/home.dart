import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wallpaperPageView.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'likedImageScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String query = r"""query MyQuery {
  posts {
    nodes {
      featuredImage {
        sourceUrl(size: _2048X2048)
        mediaItemUrl
      }
      title(format: RENDERED)
    }
  }
}


""";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((token) => {print(token)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LikedImageScreen()),
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
      body: Query(
        options: QueryOptions(documentNode: gql(query)),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.data != null) {
            List resultList = result.data['posts']['nodes'];
            print(resultList[0]['featuredImage']['sourceUrl']);
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
                      return GestureDetector(
                        onTap: () {
                          print(result.data.toString());

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WallpaperPageView(
                                pageNum: index,
                                imageSrc: resultList,
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
                                resultList[index % resultList.length]
                                    ['featuredImage']['sourceUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
