import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperapp/Components/drawer.dart';
import '../Components/homeScreenGrid.dart';
import '../Components/productsScreenGrid.dart';
import '../Components/DemoHomeScreenGrid.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../constants.dart';

import 'homeScreen.dart';

import 'likedImageScreen.dart';

class DemoHomeScreen extends StatefulWidget {
  @override
  _DemoHomeScreenState createState() => _DemoHomeScreenState();
}

List<String> _tabs = ["hello", "Hwy", "jasjfa"];

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  GlobalKey<AnimatorWidgetState> _key;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  bool isLoaded;
  @override
  void initState() {
    isLoaded = false;
    super.initState();

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> events) {
        print(events);

        return showModalBottomSheet(
            context: context,
            builder: (context) {
              return;
            });
      },
      onMessage: (Map<String, dynamic> events) {
        print(events);
        return;
      },
      onResume: (Map<String, dynamic> events) {
        print(events);

        return showModalBottomSheet(
            context: context,
            builder: (context) {
              return;
            });
      },
    );

    firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );
    firebaseMessaging.getToken().then((msg) => {print(msg)});
    set();

    _key = GlobalKey<AnimatorWidgetState>();
    Timer.periodic(Duration(seconds: 3), (timer) {
      _key.currentState.forward();
    });
  }

  set() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Scaffold(
            backgroundColor: Colors.white,
            drawer: CustomDrawer(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {},
                label: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LikedImageScreen()),
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
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverAppBar(
                        elevation: 10,

//                  expandedHeight: 100,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: CustomAppBarColor.appBarGradient,
                            ),
                          ),
//                    background: Image.network(
//                      "https://images.pexels.com/photos/192136/pexels-photo-192136.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//                      fit: BoxFit.cover,
//                    ),
                        ),
                        pinned: true,
                        floating: true,
                        centerTitle: true,
                        title: Image.asset(
                          'assets/customIcon.png',
                          height: 50,
                        ),

                        actions: <Widget>[
                          RubberBand(
                              key: _key,
                              child: IconButton(
                                  onPressed: () {}, icon: Icon(Icons.share)))
                        ],
                        forceElevated: innerBoxIsScrolled,

                        bottom: TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor:
                              CustomAppBarColor.unselectedLabelColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BubbleTabIndicator(
                            indicatorHeight: 25.0,
                            indicatorColor: CustomAppBarColor.indicatorColor,
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
                    DemoHomeScreenGrid(),
                    ProductsScreenGrid(),
                    ProductsScreenGrid(),
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: Image.asset(
              'assets/customIcon.png',
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          );
  }
}
