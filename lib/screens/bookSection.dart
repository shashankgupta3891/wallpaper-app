import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../wallpaperPageView.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bookDetails.dart';
import '../Components/DemohomeScreenGrid1.dart';

class BookSectionScreen extends StatefulWidget {
  BookSectionScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BookSectionScreenState createState() => _BookSectionScreenState();
}

class _BookSectionScreenState extends State<BookSectionScreen> {
  final String query = r"""query MyQuery ($First: Int!, $EndCursor: String!){
  posts(first: $First, after: $EndCursor) {
    nodes {
      featuredImage {
        sourceUrl(size: _2048X2048)
        mediaItemUrl
      }
      title(format: RENDERED)
      content(format: RENDERED)
      excerpt(format: RAW)
      id
    }
    pageInfo {
      endCursor
      hasNextPage
    }
  }
}

""";

//  final Box likedImg = Hive.box('likedImg');
  ScrollController scrollController;
  VoidCallback loadMore;

  bool isContentAvailable = true;

  bool isLoading = false;

  List imageList;
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
//    print(likedImg.values.toList());
    final HttpLink httpLink = HttpLink(
      uri: 'https://interntojob.com/graphql/',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink as Link,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: Scaffold(
          body: Query(
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

                isContentAvailable =
                    result.data['posts']['pageInfo']['hasNextPage'];

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
                  if (result.data['posts']['pageInfo']['hasNextPage'] &&
                      !isLoading) {
                    isLoading = true;

                    fetchMore(opts);
                    await Future.delayed(Duration(seconds: 3));
                    isLoading = false;
                  }
                };

                return Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      controller: scrollController,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              String image = resultList[index]['featuredImage']
                                  ['sourceUrl'];
                              String title = resultList[index]['title'];
                              String content = resultList[index]['content'];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookDetails(
                                        imageUrl: image,
                                        title: title,
                                        content: content,
                                        affiliateUrl:
                                            'https://www.amazon.in/Rich-Dad-Poor-Middle-Updates/dp/1612680194/ref=as_li_ss_tl?crid=3P8JHFCTBERJN&dchild=1&keywords=rich+dad+and+poor+dad&qid=1594363850&sprefix=Rich,aps,415&sr=8-1&linkCode=ll1&tag=bigstore055-21&linkId=0538a87daac8c5c5a2043dd0ff59fef7',
                                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                            childCount: resultList.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: isContentAvailable
                              ? LinearProgressIndicator()
                              : Container(
                                  child: AlertDialog(
                                    title: Text("Nomoredata"),
                                  ),
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
        ),
      ),
    );
  }
}
