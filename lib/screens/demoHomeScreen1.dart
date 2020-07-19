import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperapp/Components/drawer.dart';
import '../Components/DemohomeScreenGrid1.dart';
import '../Components/productsScreenGrid.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'likedImageScreen.dart';

class DemoHomeScreen1 extends StatefulWidget {
  @override
  _DemoHomeScreen1State createState() => _DemoHomeScreen1State();
}

List<String> _tabs = ["hello", "Hwy", "jasjfa"];

class _DemoHomeScreen1State extends State<DemoHomeScreen1> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> events) {},
      onMessage: (Map<String, dynamic> events) {},
      onResume: (Map<String, dynamic> events) {},
    );

    firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );
    firebaseMessaging.getToken().then((msg) => {print(msg)});
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
                    MaterialPageRoute(builder: (context) => DemoHomeScreen1()),
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
              DemoHomeScreenGrid1(),
              GridScreenByTagId(),
              GridScreenByTagId(),
            ],
          ),
        ),
      ),
    );
  }
}
