import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lockdownshop/screens/dashboard.dart';
import 'package:lockdownshop/screens/loginpage.dart';

class AuthService {
  static int p = 0,
      t = 0,
      pt;

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return DashBoard();
        } else {
          return LoginPage();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  static void updatept(String uid) async {
    Firestore.instance
        .collection("Shops")
        .document(uid)
        .collection('S4')
        .orderBy('Time')
        .limit(1)
        .snapshots()
        .listen((data) {
      if (data.documents.length > 0) {
        t = data.documents[0]["Token"];
        pt = t;
        Firestore.instance
            .collection("Shops")
            .document(uid)
            .updateData({"Pres-Token": t});
        print("set t ${t}");
      } else {
        t = 0;
        Firestore.instance
            .collection("Shops")
            .document(uid)
            .collection('S3')
            .orderBy('Time')
            .limit(1)
            .snapshots()
            .listen((data) {
          if (data.documents.length > 0) {
            p = data.documents[0]["Token"];
            pt = p;
            Firestore.instance
                .collection("Shops")
                .document(uid)
                .updateData({"Pres-Token": p});
            print("set p ${p}");
          } else {
            p = 0;
            pt = 0;
            Firestore.instance
                .collection("Shops")
                .document(uid)
                .updateData({"Token": 0, "Pres-Token": 0});
            print("set 0");
          }
        });
      }
    });

    print(t.toString() + p.toString() + pt.toString());
  }
}
