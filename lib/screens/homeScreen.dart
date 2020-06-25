import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperapp/Components/drawer.dart';
import '../Model/likedImages.dart';
import '../wallpaperPageView.dart';
import '../wallpaperPageView.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../Components/homeScreenGrid.dart';
import '../Components/productsScreenGrid.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'likedImageScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<String> _tabs = ["hello", "Hwy", "jasjfa"];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  FontAwesomeIcons.solidHeart,
                  color: Colors.pinkAccent,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.book,
                  color: Colors.blueAccent,
//                  size: 24,
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
