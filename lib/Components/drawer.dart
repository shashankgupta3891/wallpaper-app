import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: CircleAvatar(
              backgroundColor: Colors.white70,
              child: Icon(
                Icons.people_outline,
                size: 70,
                color: Colors.black,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              image: DecorationImage(
                image: Image.network(
                  "https://images.pexels.com/photos/1742370/pexels-photo-1742370.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                ).image,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          ListTile(
            title: Text("Books"),
            trailing: Icon(
              Icons.book,
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            title: Text("Liked"),
            trailing: Icon(
              Icons.favorite,
              color: Colors.pinkAccent,
            ),
          ),
          ListTile(
            title: Text("Invite"),
            trailing: Icon(
              Icons.share,
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text("Suggestion"),
            trailing: Icon(
              Icons.comment,
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text("More Apps"),
            trailing: Icon(
              Icons.apps,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
