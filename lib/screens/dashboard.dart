import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lockdownshop/screens/registration.dart';
import 'package:lockdownshop/services/authservice.dart';
import 'package:lockdownshop/stages/delivery.dart';
import 'package:lockdownshop/stages/packing.dart';
import 'package:lockdownshop/stages/requests.dart';
import 'package:lockdownshop/stages/waiting.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  String uid;
  int tabIndex = 0;
  List<Widget> screens;
  Color appBarColour = Colors.blue;
  TabController controller;

  Color appBarTextColour = Colors.black;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    controller.addListener(() {
      tabChanged();
    });

    screens = [
      new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 200,
              child: new LinearProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.black12,
              )),
        ],
      )),
      new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 200,
              child: new LinearProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.black12,
              )),
        ],
      )),
      new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 200,
              child: new LinearProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.black12,
              )),
        ],
      )),
      new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 200,
              child: new LinearProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.black12,
              )),
        ],
      )),
    ];
    print("init");
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      uid = user.uid;
      print(uid);
      Firestore.instance.collection("Shops").document(uid).get().then((snap) {
        if (snap.data == null) {
          print("User Details Not Found.");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Registration(
                        uid: uid,
                        mobile: user.phoneNumber,
                      )));
        } else {
          setState(() {
            screens = [
              Requests(
                uid: uid,
              ),
              Waiting(
                uid: uid,
              ),
              Packing(
                uid: uid,
              ),
              Delivery(
                uid: uid,
              ),
            ];
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
            child: Column(
          children: <Widget>[
            RaisedButton.icon(
                onPressed: () {
                  AuthService().signOut();
                },
                icon: Icon(Icons.remove_circle_outline),
                label: Text("Sign out"))
          ],
        )),
      ),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
        centerTitle: true,
        backgroundColor: appBarColour,
        title: Text(
          'LockDown Shop',
          style: TextStyle(fontFamily: 'Logo', color: appBarTextColour),
        ),
        bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: controller,
            tabs: [
              Tab(
                child: Text(
                  "Requests",
                  style: TextStyle(fontSize: 12, color: appBarTextColour),
                ),
              ),
              Tab(
                child: Text(
                  "Waiting",
                  style: TextStyle(fontSize: 12, color: appBarTextColour),
                ),
              ),
              Tab(
                child: Text(
                  "Packing",
                  style: TextStyle(fontSize: 12, color: appBarTextColour),
                ),
              ),
              Tab(
                child: Text(
                  "Delivery",
                  style: TextStyle(fontSize: 12, color: appBarTextColour),
                ),
              ),
            ]),
      ),
      body: Container(
        color: Colors.white,
        child: Card(
          margin: const EdgeInsets.only(left: 0.5, right: 0.5, top: 24),
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          elevation: 3,
          color: appBarColour,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: appBarColour,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: TabBarView(controller: controller, children: screens),
          ),
        ),
      ),
    );
  }

  void tabChanged() {
    print(123456);
    setState(() {
      if (controller.index == 0) {
        appBarColour = Colors.blue;
        appBarTextColour = Colors.black;
      } else if (controller.index == 1) {
        appBarColour = Colors.amber;
        appBarTextColour = Colors.white;
      } else if (controller.index == 2) {
        appBarColour = Colors.greenAccent;
        appBarTextColour = Colors.black;
      } else if (controller.index == 3) {
        appBarColour = Colors.green;
        appBarTextColour = Colors.white;
      }
    });
  }
}
