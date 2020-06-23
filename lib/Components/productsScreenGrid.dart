import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../wallpaperPageView.dart';

class ProductsScreenGrid extends StatefulWidget {
  @override
  _ProductsScreenGridState createState() => _ProductsScreenGridState();
}

class _ProductsScreenGridState extends State<ProductsScreenGrid> {
  final String query = r"""query MyQuery ($First: Int!, $EndCursor: String!){
  tag(id: "cG9zdF90YWc6MTk3") {
    posts(first: $First, after: $EndCursor) {
      nodes {
        featuredImage {
          sourceUrl(size: _2048X2048)
          mediaItemUrl
        }
        title(format: RENDERED)
      }
      pageInfo {
        endCursor
        hasNextPage
      }
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
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              (scrollController.position.maxScrollExtent - 300) ||
          scrollController.position.pixels ==
              (scrollController.position.maxScrollExtent)) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 150,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 3));
      },
      child: Query(
        options: QueryOptions(
            documentNode: gql(query), variables: {"First": 8, "EndCursor": ""}),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.data != null) {
            List resultList = result.data['tag']['posts']['nodes'];
            String fetchMoreCursor =
                result.data['tag']['posts']['pageInfo']['endCursor'];
            print(result.data);

            print(result.data['tag']['posts']['pageInfo']['hasNextPage']);

            isContentAvailable =
                result.data['tag']['posts']['pageInfo']['hasNextPage'];

            FetchMoreOptions opts = FetchMoreOptions(
              variables: {"First": 8, 'EndCursor': fetchMoreCursor},
              updateQuery: (previousResultData, fetchMoreResultData) {
                final List<dynamic> repos = [
                  ...previousResultData['tag']['posts']['nodes']
                      as List<dynamic>,
                  ...fetchMoreResultData['tag']['posts']['nodes']
                      as List<dynamic>
                ];

                fetchMoreResultData['tag']['posts']['nodes'] = repos;
                return fetchMoreResultData;
              },
            );

            loadMore = () async {
              if (result.data['tag']['posts']['pageInfo']['hasNextPage'] &&
                  !isLoading) {
                isLoading = true;
                fetchMore(opts);

                await Future.delayed(Duration(seconds: 2));
                isLoading = false;
              }
            };

            return Builder(
              builder: (BuildContext context) {
                return CustomScrollView(
                  controller: scrollController,
                  physics: ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
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
                                        ['featuredImage']['sourceUrl'],
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
                      child: FlatButton(
                        onPressed: () {
                          fetchMore(opts);
                        },
                        child: Text("Hellp"),
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
      ),
    );
  }
}
