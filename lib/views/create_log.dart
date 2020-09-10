// import 'dart:html';

import 'dart:io';

import 'package:TraveLog/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateLog extends StatefulWidget {
  CreateLog({Key key}) : super(key: key);

  @override
  _CreateLogState createState() => _CreateLogState();
}

class _CreateLogState extends State<CreateLog> {
  String place, title, desc;
  bool _isLoading = false;

  CrudMethods crudMethods = new CrudMethods();

  File selectedImg;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      selectedImg = File(pickedFile.path);
    });
  }

  uploadLog() async {
    if (selectedImg != null) {
      setState(() {
        _isLoading = true;
      });
      Firebase.initializeApp();
      // Uploading image to firebase
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("logImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImg);

      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("This is url: $downloadUrl");

      Map<String, String> logMap = {
        "imgUrl": downloadUrl,
        "place": place,
        "title": title,
        "description": desc
      };

      crudMethods.addData(logMap).then((result) {
        Navigator.pop(context);
      });
    } else {
      // print()
    }
  }

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
              style: TextStyle(color: Colors.blueAccent[100], fontSize: 25),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadLog();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage("assets/abstract space.jpg"),
              //       fit: BoxFit.cover),
              // ),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage("asset`s/abstract space.jpg"),
              //       fit: BoxFit.cover),
              // ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: selectedImg != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black54,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Opacity(
                          opacity: 1,
                          child: TextField(
                            // autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Place",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                fillColor: Colors.grey),
                            onChanged: (value) {
                              place = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          // autofocus: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              fillColor: Colors.grey),
                          onChanged: (value) {
                            title = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          minLines: 10,
                          maxLines: null,
                          // autofocus: true,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              fillColor: Colors.grey),
                          onChanged: (value) {
                            desc = value;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
