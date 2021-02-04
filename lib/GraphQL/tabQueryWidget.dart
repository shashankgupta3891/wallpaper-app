import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef TabWidgetBuilder<T> = Widget Function(
    BuildContext context, List value, Widget child);

class TabsQueryWidget extends StatelessWidget {
  final String query = r"""query MyQuery {
    tags {
      nodes {
        name
        id
      }
    }
  }
  """;

  final TabWidgetBuilder builder;

  const TabsQueryWidget({Key key, this.builder, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(query),
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.data != null) {
          return builder(context, result.data['tags']['nodes'], child);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
