import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wallpaperPageView.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bookDetails.dart';

class BookSectionScreen extends StatefulWidget {
  BookSectionScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BookSectionScreenState createState() => _BookSectionScreenState();
}

class _BookSectionScreenState extends State<BookSectionScreen> {
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
      body: ValueListenableBuilder(
        valueListenable: likedImg.listenable(),
        builder: (context, box, _) {
          imageList = box.values.toList();
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.brown,
                floating: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Books"),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black]),
                    ),
                    child: Image.network(
                      'https://images.pexels.com/photos/5834/nature-grass-leaf-green.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue,
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                            'https://images.pexels.com/photos/694740/pexels-photo-694740.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Books are the Best Investment',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
//                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Recommended Books',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
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
                            builder: (context) => BookDetails(),
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
