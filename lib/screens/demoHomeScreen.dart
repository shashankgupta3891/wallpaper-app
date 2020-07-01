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
import '../constants.dart';

import 'homeScreen.dart';

import 'likedImageScreen.dart';

class DemoHomeScreen extends StatefulWidget {
  @override
  _DemoHomeScreenState createState() => _DemoHomeScreenState();
}

List<String> _tabs = ["hello", "Hwy", "jasjfa"];

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> events) {
        return showModalBottomSheet(
            context: context,
            builder: (context) {
              return SnackBar(
                duration: Duration(seconds: 3),
                content: Text('jellp1'),
              );
            });
      },
      onMessage: (Map<String, dynamic> events) {
        print(events);
        return;
      },
      onResume: (Map<String, dynamic> events) {
        return showModalBottomSheet(
            context: context,
            builder: (context) {
              return SnackBar(
                duration: Duration(seconds: 3),
                content: Text('jellp3'),
              );
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
                  title: Text("Demo"),
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
    );
  }
}

class SliverCustomAppBarDelegate extends SliverPersistentHeaderDelegate {
//  SliverCustomAppBarDelegate(this._tabBar);

//  final TabBar _tabBar;
//
  @override
  double get minExtent => 10;

  @override
  double get maxExtent => 20;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        gradient: CustomAppBarColor.appBarGradient,
//        color: Color(0xff34495e),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverCustomAppBarDelegate oldDelegate) {
    return false;
  }
}
