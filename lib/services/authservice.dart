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

  static void setp(int i, String uid) {
    p = i;
    updatept(uid);
  }

  static void sett(int i, String uid) {
    t = i;
    updatept(uid);
  }

  static void updatept(String uid) {
    if (t == 0) {
      if (p == 0) {
        pt = 0;
        Firestore.instance
            .collection("Shops")
            .document(uid)
            .updateData({"Token": 0});
      } else {
        pt = p;
      }
    } else {
      pt = t;
    }
    Firestore.instance
        .collection("Shops")
        .document(uid)
        .updateData({"Pres-Token": pt});
  }
}
