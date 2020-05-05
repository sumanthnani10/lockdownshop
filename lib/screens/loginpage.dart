import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool show = true;

  String phoneNumber;
  String verificationId, otp;
  TextEditingController otpc = new TextEditingController();
  TextEditingController phonec = new TextEditingController();

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('LockDown Shop')),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FadeInImage(
                      image: AssetImage('assets/images/small.png'),
                      width: 500,
                      placeholder: AssetImage('assets/images/small.png'),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Text(
                      "LockDown Shop",
                      style: TextStyle(
                          fontFamily: 'Logo',
                          fontWeight: FontWeight.bold,
                          fontSize: 36),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                    child: Column(
                      children: <Widget>[
                        if (show)
                          RaisedButton.icon(
                              onPressed: () {
                                setState(() {
                                  show = false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black12)),
                              color: Colors.white,
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Sign In with Phone",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                              icon: Icon(
                                Icons.phone,
                                size: 36,
                                color: Colors.green,
                              )),
                        if (!show && !codeSent)
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: phonec,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: "Phone Number"),
                                  maxLength: 10,
                                  onChanged: (val) {
                                    this.phoneNumber = val;
                                  },
                                ),
                                RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        side:
                                            BorderSide(color: Colors.black12)),
                                    color: Colors.green,
                                    onPressed: () {
                                      verifyPhone(phoneNumber);
                                    },
                                    icon: Icon(
                                      Icons.message,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Text(
                                        "Send OTP",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        this.show = true;
                                      });
                                    },
                                    child: Text(
                                      "Back",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.indigo,
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            ),
                          ),
                        if (!show && codeSent)
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: otpc,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: "OTP"),
                                  maxLength: 6,
                                  onChanged: (val) {
                                    this.otp = val;
                                  },
                                ),
                                RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        side:
                                            BorderSide(color: Colors.black12)),
                                    color: Colors.green,
                                    onPressed: () {
                                      AuthCredential credential =
                                          PhoneAuthProvider.getCredential(
                                              verificationId: verificationId,
                                              smsCode: otp);
                                      FirebaseAuth.instance
                                          .signInWithCredential(credential)
                                          .catchError((error) {
                                        print(123456789);
                                        showAlertDialog(context);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Text(
                                        "Verify",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        this.codeSent = false;
                                      });
                                    },
                                    child: Text(
                                      "Change Number",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.indigo,
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> verifyPhone(pno) async {
    final PhoneVerificationCompleted verified = (AuthCredential ac) {
      FirebaseAuth.instance.signInWithCredential(ac).catchError((error) {
        showAlertDialog(context);
      });
    };

    final PhoneVerificationFailed verifailed = (AuthException ae) {
      print('${ae.message},12345678');
    };

    final PhoneCodeSent codeSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeOut = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + pno,
        timeout: const Duration(seconds: 10),
        verificationCompleted: verified,
        verificationFailed: verifailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoTimeOut);
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(16),
      title: Text("Wrong OTP"),
      content: Text("OTP you have entered is wrong.Please Try Again."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
