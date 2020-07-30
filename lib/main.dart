import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/demoHomeScreen1.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'adUnit/adUnitId.dart';

import 'screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox('likedImg');
  Admob.initialize(getAppId());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'http://geetdemo.16mb.com/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink as Link,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vestige Post',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GraphQLProvider(
        client: client,
        child: CacheProvider(child: HomeScreen()),
      ),
    );
  }
}
