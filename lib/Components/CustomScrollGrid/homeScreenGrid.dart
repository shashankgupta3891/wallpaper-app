import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../wallpaperPageView.dart';
import '../appBarCurvePart.dart';

class HomeScreenGrid extends StatefulWidget {
  @override
  _HomeScreenGridState createState() => _HomeScreenGridState();
}

class _HomeScreenGridState extends State<HomeScreenGrid> {
  final String query = r"""query MyQuery($First: Int!, $EndCursor: String!) {
  posts(first: $First, after: $EndCursor) {
    pageInfo {
      endCursor
      hasNextPage
    }
    nodes {
      featuredImage {
        node {
          sourceUrl
          mediaItemUrl
        }
      }
      title(format: RENDERED)
      id
    }
  }
}
""";

  ScrollController scrollController;

  VoidCallback loadMore;

  bool isContentAvailable = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              (scrollController.position.maxScrollExtent - 300) ||
          scrollController.position.pixels ==
              (scrollController.position.maxScrollExtent)) {
        loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(query),
        variables: {"First": 8, "EndCursor": ""},
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.data != null) {
          List resultList = result.data['posts']['nodes'];
          String fetchMoreCursor =
              result.data['posts']['pageInfo']['endCursor'];
          print(result.data);

          print(result.data['posts']['pageInfo']['hasNextPage']);

          isContentAvailable = result.data['posts']['pageInfo']['hasNextPage'];

          FetchMoreOptions opts = FetchMoreOptions(
            variables: {"First": 8, 'EndCursor': fetchMoreCursor},
            updateQuery: (previousResultData, fetchMoreResultData) {
              final List<dynamic> repos = [
                ...previousResultData['posts']['nodes'] as List<dynamic>,
                ...fetchMoreResultData['posts']['nodes'] as List<dynamic>
              ];
              fetchMoreResultData['posts']['nodes'] = repos;
              isLoading = false;
              return fetchMoreResultData;
            },
          );

          loadMore = () async {
            if (result.data['posts']['pageInfo']['hasNextPage'] && !isLoading) {
              isLoading = true;

              fetchMore(opts);
              await Future.delayed(Duration(seconds: 5));
              isLoading = false;
            }
          };

          return Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                controller: scrollController,
//                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber
                    // above.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPersistentHeader(
                    delegate: SliverCustomAppBarDelegate(),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.green,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.whatsapp,
                                size: 40,
                                color: Colors.white,
                              ),
                              Text(
                                "Share on Whatsapp",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.67,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        print(
                            "${scrollController.position.pixels}, ${scrollController.position.maxScrollExtent}");
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
                                      ['featuredImage']['node']['sourceUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: resultList.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
//                        color: Colors.green,
                        child: Column(
                          children: <Widget>[
                            // SizedBox(
                            //   height: 60,
                            //   width: MediaQuery.of(context).size.width,
                            //   child: AdmobBanner(
                            //     adUnitId: getBannerAdUnitId(),
                            //     adSize: bannerSize,
                            //     listener: (AdmobAdEvent event,
                            //         Map<String, dynamic> args) {},
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: isContentAvailable
                        ? LinearProgressIndicator()
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ),
                ],
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
