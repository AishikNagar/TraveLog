import 'package:TraveLog/services/crud.dart';
import 'package:TraveLog/views/create_log.dart';
import 'package:TraveLog/views/view_log.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase.initializeApp();
  CrudMethods crudMethods = new CrudMethods();
  ScrollController _controller = new ScrollController();

  Stream logsStream;

  Widget LogsList() {
    return Container(
      child: logsStream != null
          ? ListView(
              children: <Widget>[
                StreamBuilder(
                  stream: logsStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        controller: _controller,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          Map getDocs = ds.data();
                          return LogsTile(
                            place: getDocs["place"].toString(),
                            title: getDocs["title"].toString(),
                            description: getDocs["desc"].toString(),
                            imgUrl: getDocs['imgUrl'].toString(),
                          );
                        });
                  },
                )
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print('completed');
      crudMethods.getData().then((result) {
        setState(() {
          logsStream = result;
        });
      });
    });
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
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(200.0),
      //   child: AppBar(
      //     automaticallyImplyLeading: false,
      //     title: Text('TraveLog'),
      //     centerTitle: true,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(
      //         bottom: Radius.circular(30),
      //       ),
      //     ),
      //   ),
      // ),
      body: LogsList(),
      // body: Container(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateLog()));
              },
              backgroundColor: Colors.blueAccent[100],
              child: Icon(
                Icons.add,

                // color: Colors.blueAccent[100],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LogsTile extends StatelessWidget {
  String imgUrl, title, description, place;
  LogsTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.description,
      @required this.place});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6)),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewLog())), // handle your onTap here
              // child: Container(height: 200, width: 200),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(place),
                SizedBox(
                  height: 4,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
