import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaperapp/Components/drawer.dart';
import 'package:wallpaperapp/GraphQL/tabQueryWidget.dart';
import '../Components/CustomScrollGrid/productsScreenGrid.dart';
import '../Components/CustomScrollGrid/homeScreenGrid.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../constants.dart';

import 'likedImageScreen.dart';

import 'inviteScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<String> _tabs = ["All", "Food", "Nature", "Office", "Patterns"];
enum HomePopupButtons { rateUs, likedPoster, invite, suggestion }

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<AnimatorWidgetState> _key;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  bool isLoaded;

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "Do you really want to exit the App?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              'Yes',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
          RaisedButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              'No',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }

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
    try {
      Timer.periodic(Duration(seconds: 7), (timer) {
        _key.currentState.forward();
      });
    } catch (e) {
      print(e);
    }
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
        ? WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
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
                    ],
                  )),
              body: TabsQueryWidget(
                builder: (BuildContext context, resultData, _) {
                  List _tabs = resultData;
                  print("hello123 ${_tabs.length}");

                  return DefaultTabController(
                    length: _tabs.length + 1, // This is the number of tabs.
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: SliverAppBar(
                              elevation: 10,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  decoration: BoxDecoration(
                                    gradient: CustomAppBarColor.appBarGradient,
                                  ),
                                ),
                              ),
                              pinned: true,
                              floating: true,
                              centerTitle: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/customIcon.png',
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'Wallpaper App',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ],
                              ),
                              leading: PopupMenuButton<HomePopupButtons>(
                                onSelected: (HomePopupButtons result) {
                                  if (result == HomePopupButtons.likedPoster) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LikedImageScreen()),
                                    );
                                  } else if (result ==
                                      HomePopupButtons.invite) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InviteScreen()));
                                  } else if (result ==
                                      HomePopupButtons.rateUs) {
                                  } else if (result ==
                                      HomePopupButtons.suggestion) {}
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<HomePopupButtons>>[
                                  PopupMenuItem<HomePopupButtons>(
                                    value: HomePopupButtons.rateUs,
                                    child: Text('Rate us'),
                                  ),
                                  PopupMenuItem<HomePopupButtons>(
                                    value: HomePopupButtons.likedPoster,
                                    child: Text('Liked Wallpapers'),
                                  ),
                                  PopupMenuItem<HomePopupButtons>(
                                    value: HomePopupButtons.invite,
                                    child: Text('Invite'),
                                  ),
                                  PopupMenuItem<HomePopupButtons>(
                                    value: HomePopupButtons.suggestion,
                                    child: Text('Suggestion'),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                RubberBand(
                                  key: _key,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InviteScreen()));
                                    },
                                    icon: Icon(Icons.share),
                                    color: Colors.yellowAccent,
                                  ),
                                )
                              ],
                              forceElevated: innerBoxIsScrolled,
                              bottom: TabBar(
                                isScrollable: true,
                                labelColor: Colors.black,
                                unselectedLabelColor:
                                    CustomAppBarColor.unselectedLabelColor,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BubbleTabIndicator(
                                  indicatorHeight: 25.0,
                                  indicatorColor:
                                      CustomAppBarColor.indicatorColor,
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                                tabs: <Tab>[
                                  Tab(
                                    text: "All",
                                  ),
                                  ..._tabs
                                      .map((e) => Tab(
                                            text: e['name'],
                                          ))
                                      .toList()
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
                          ..._tabs
                              .map((e) => GridScreenByTagId(
                                    tagId: e['id'],
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : splashScreen(context);
  }

  Scaffold splashScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Wallpaper App",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Image.asset(
                'assets/customIcon.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
