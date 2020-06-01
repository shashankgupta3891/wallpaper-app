import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wallpaperPageView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<String> str = [
      "https://images.pexels.com/photos/4389409/pexels-photo-4389409.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/3540104/pexels-photo-3540104.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/3922221/pexels-photo-3922221.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
      "https://images.pexels.com/photos/3563888/pexels-photo-3563888.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/3290068/pexels-photo-3290068.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/3157693/pexels-photo-3157693.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/4207892/pexels-photo-4207892.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/4142982/pexels-photo-4142982.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/3876435/pexels-photo-3876435.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      "https://images.pexels.com/photos/2397645/pexels-photo-2397645.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    ];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {},
        label: Text(
          "Invite",
          style: TextStyle(color: Colors.black),
        ),
        icon: Icon(
          Icons.share,
          color: Colors.black,
        ),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
//          SliverAppBar(
////            pinned: true,
//            backgroundColor: Colors.white,
//            title: Text("hellp"),
//            floating: true,
//            expandedHeight: 200,
//            flexibleSpace: FlexibleSpaceBar(
//                background: Container(
//              color: Colors.grey,
//            )),
//          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WallpaperPageView(
                          pageNum: index,
                          imageSrc: str,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.grey[(index * 100) % 1000],
                      child: Image.network(
                        str[index % str.length],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
