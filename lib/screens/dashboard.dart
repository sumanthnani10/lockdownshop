import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lockdownshop/screens/registration.dart';
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
  String sname, skname, num, email, simg, skimg, stype;
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
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      uid = user.uid;
      Firestore.instance.collection("Shops").document(uid).get().then((snap) {
        if (snap.data == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Registration(
                    uid: uid,
                    mobile: user.phoneNumber,
                  )));
        } else {
          setState(() {
            uid = user.uid;
            sname = snap.data["Shop-Details"]["Shop-Name"];
            stype = snap.data["Shop-Details"]["Shop-Type"];
            simg = snap.data["Shop-Details"]["Shop-Image"];
            skname = snap.data["Keeper-Details"]["Keeper-Name"];
            skimg = snap.data["Keeper-Details"]["Keeper-Image"];
            email = snap.data["Keeper-Details"]["Email"];
            num = snap.data["Keeper-Details"]["Mobile"];
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
      drawer: Drawer(
          child: Column(
            children: <Widget>[
              if (sname != null)
                SafeArea(
                    child: new Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 2.5 / 5,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: FadeInImage(
                                  image: NetworkImage(simg),
                                  placeholder:
                                  AssetImage(
                                      'assets/images/shopPlaceholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 1.25,
                                    sigmaY: 1.25),
                                child: Container(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 4,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 4,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 0.5),
                                            color: Colors.white,
                                            image: new DecorationImage(
                                                image: NetworkImage(skimg),
                                                fit: BoxFit.cover)),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Container(
                                            width: (MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                3 /
                                                4) -
                                                64,
                                            child: new Text(
                                              sname,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          new Text(
                                            skname,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        new Text(
                                          num,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Text(
                                          email,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              if (sname == null)
                new SafeArea(
                  child: new Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[new LinearProgressIndicator()],
                    ),
                  ),
                )
            ],
          )),
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
