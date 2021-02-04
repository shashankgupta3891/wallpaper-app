import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:share/share.dart';

class InviteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
//        title: Text("Hello"),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
//        decoration: BoxDecoration(
//            gradient: LinearGradient(colors: <Color>[
//          Color(0xff074CA4),
//          Color(0xff1AB5E6),
//        ])),
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: AutoSizeText(
                  "Invite Your Network",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Container(
              child: Image.asset(
                'assets/invite.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            AutoSizeText(
              'Increase your network efficiency and grow you business',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.maxFinite,
              child: RaisedButton.icon(
                elevation: 5,
                color: Color(0xffFFD700),
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () {
                  Share.share(
                      'Hey Friend, Try this wonderful app\n\nhttps://interntojob.com/index.php/work-from-home-jobs-at-amazon/1069/');
                },
                icon: Icon(
                  Icons.share,
                  size: 35,
                ),
                label: Text(
                  "INVITE NOW",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
