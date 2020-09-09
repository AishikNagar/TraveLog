import 'package:TraveLog/services/crud.dart';
import 'package:TraveLog/views/create_log.dart';
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

  Stream logsStream;

  Widget LogsList() {
    return Container(
      child: logsStream != null
          ? Column(
              children: <Widget>[
                StreamBuilder(
                  stream: logsStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return ListView.builder(
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
    crudMethods.getData().then((result) {
      setState(() {
        logsStream = result;
      });
    });
    super.initState();
    Firebase.initializeApp();
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
              style: TextStyle(color: Colors.deepPurple[100], fontSize: 25),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: LogsList(),
      //  Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage("assets/abstract space.jpg"),
      //         fit: BoxFit.cover),
      //   ),
      // ),
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
              child: Icon(Icons.add),
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
// class LogsTile extends StatelessWidget {

//   String imgUrl, place, title;

//   LogsTile({@required this.imgUrl,this.title,this.place})
//   const LogsTile({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 150,
//       child: Stack(children: <Widget>[
//         ClipRRect(child: Image.network(imgUrl),borderRadius: BorderRadius.circular(8)),
//         Container(
//           height: 150,
//           decoration: BoxDecoration(color: Colors.black45.withOpacity(0.3),borderRadius: BorderRadius.circular(8)),

//         ),
//         Container(child: Column(children: <Widget>[
//           Text(place),
//           Text(title)
//         ],),)
//       ],),
//     );
//   }
// }
