import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallpaperapp/Components/drawer.dart';
import '../Model/likedImages.dart';
import '../wallpaperPageView.dart';
import '../wallpaperPageView.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../Components/homeScreenGrid.dart';
import '../Components/productsScreenGrid.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class LikedImageScreen extends StatefulWidget {
  @override
  _LikedImageScreenState createState() => _LikedImageScreenState();
}

List<String> _tabs = ["hello", "Hwy", "jasjfa"];

class _LikedImageScreenState extends State<LikedImageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {},
          label: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LikedImageScreen()),
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LikedImageScreen()),
                  );
                },
                icon: Icon(
                  Icons.book,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          )),
      body: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  elevation: 10,
//                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      "https://images.pexels.com/photos/192136/pexels-photo-192136.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                      fit: BoxFit.cover,
                    ),
                  ),
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.lightGreen,
                  title: Text("Hell"),
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: Colors.blueAccent,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: <Tab>[
                      Tab(
                        text: "All",
                      ),
                      Tab(
                        text: "Products",
                      ),
                      Tab(
                        text: "Motivation",
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              HomeScreenGrid(),
              ProductsScreenGrid(),
              ProductsScreenGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
