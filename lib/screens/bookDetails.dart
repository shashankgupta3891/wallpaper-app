import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BookDetails extends StatelessWidget {
  String content;
  String title;
  String affiliateUrl;
  String imageUrl;

  BookDetails({this.content, this.affiliateUrl, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          color: Colors.black,
//        ),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Image.network(imageUrl),
                      Divider(
                        thickness: 1,
                      ),
                      Container(
                        child: HtmlWidget(content),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: double.maxFinite,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(8),
                color: Colors.yellow,
                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: () async {
                  await launch(
                      'https://www.amazon.in/Rich-Dad-Poor-Middle-Updates/dp/1612680194/ref=as_li_ss_tl?crid=3P8JHFCTBERJN&dchild=1&keywords=rich+dad+and+poor+dad&qid=1594363850&sprefix=Rich,aps,415&sr=8-1&linkCode=ll1&tag=bigstore055-21&linkId=0538a87daac8c5c5a2043dd0ff59fef7');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
