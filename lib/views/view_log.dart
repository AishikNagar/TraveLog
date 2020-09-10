import 'dart:io';

import 'package:TraveLog/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewLog extends StatefulWidget {
  ViewLog({Key key}) : super(key: key);

  @override
  _ViewLogState createState() => _ViewLogState();
}

class _ViewLogState extends State<ViewLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Trave", style: TextStyle(fontSize: 25)),
            Text(
              "Log",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ],
        ),
        // flexibleSpace: Image(
        //   image: AssetImage('assets/travel.jpg'),
        //   fit: BoxFit.cover,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(60),
          ),
        ),
        backgroundColor: Colors.blueAccent[100],

        elevation: 3.0,
      ),
    );
  }
}

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Trave", style: TextStyle(fontSize: 25)),
          Text(
            "Log",
            style: TextStyle(color: Colors.blueAccent[100], fontSize: 25),
          )
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.file_upload)),
        )
      ],
    ),
  );
}
