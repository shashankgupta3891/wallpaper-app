import 'package:flutter/cupertino.dart';

import 'constants.dart';

class SliverCustomAppBarDelegate extends SliverPersistentHeaderDelegate {
//  SliverCustomAppBarDelegate(this._tabBar);

//  final TabBar _tabBar;
//
  @override
  double get minExtent => 10;

  @override
  double get maxExtent => 10;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
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
