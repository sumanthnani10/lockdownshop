import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class Requests extends StatefulWidget {
  final String uid;

  Requests({@required this.uid});

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests>
    with AutomaticKeepAliveClientMixin {
  static int length = 0;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Shops")
          .document("${widget.uid}")
          .collection("S1")
          .orderBy("Time")
          .snapshots(),
      builder: (context, snapshot) {
        print(widget.uid);
        if (snapshot.connectionState == ConnectionState.waiting) {
          print(1);
          return new Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 200,
                  child: new LinearProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.yellow),
                    backgroundColor: Colors.black12,
                  )),
            ],
          ));
        } else {
          if (snapshot.data.documents.length == 0) {
            print(2);
            return new Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Text("No Requests")],
            ));
          } else {
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => buildRequestsList(
                    context, snapshot.data.documents[index], index));
          }
        }
      },
    );
  }

  buildRequestsList(BuildContext context, snapshot, index) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: new Card(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black)),
        elevation: 4,
        child: new Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: new Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[200],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      snapshot["Prod-Count"].toString(),
                      style: new TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      snapshot["Prod-Count"] == 1 ? "Item" : "Items",
                      style: new TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            new Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    new ReCase(
                            snapshot['Customer-Name'].toString().toLowerCase())
                        .titleCase,
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            new Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      border: Border(
                        left: BorderSide(color: Colors.black),
                      )),
                  child: new FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Billing(
                                    snapshot: snapshot,
                                  )));
                    },
                    splashColor: Colors.blue[200],
                    child: new Text('Bill It'),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Billing extends StatefulWidget {
  final snapshot;
  Billing({@required this.snapshot});

  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  final formKey = GlobalKey<FormState>();
  List<double> prices = new List<double>();
  double total = 0;
  bool uploading = false;
  Map<String, dynamic> snap;
  final FocusScopeNode formNode = FocusScopeNode();

  @override
  // ignore: must_call_super
  void initState() {
    snap = widget.snapshot.data;
  }

  @override
  Widget build(BuildContext context) {
    prices.length = snap["Prod-Count"];
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            new ReCase(snap['Customer-Name'].toString().toLowerCase())
                .titleCase),
        actions: <Widget>[
          new FlatButton.icon(
              onPressed: () {
                if (!uploading) {
                  if (formKey.currentState.validate()) {
                    setState(() {
                      uploading = true;
                      snap["Total"] = total;
                      uploadData();
                    });
                  }
                }
              },
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: new Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: new Text(
                    "Total: Rs." + total.toString(),
                    style: new TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Form(
                key: formKey,
                child: new FocusScope(
                  node: formNode,
                  child: new ListView.builder(
                      itemCount: snap["Prod-Count"],
                      itemBuilder: (context, index) =>
                          getBills(index, snap["Prod-Count"])),
                ),
              ),
            ),
          ),
          if (uploading)
            new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new SizedBox(
                    height: 8,
                  ),
                  new Text("Billing.......")
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    formNode.dispose();
    super.dispose();
  }

  getBills(int index, int len) {
    if (index != len - 1) {
      return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: new TextFormField(
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value != "")
                  prices[index] = double.parse(value);
                else
                  prices[index] = 0;
                total = 0;
                for (int i = 0; i < prices.length; i++) {
                  if (prices[i] != null) {
                    total += prices[i];
                  }
                }
              });
            },
            onEditingComplete: formNode.nextFocus,
            minLines: 1,
            autofocus: true,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter Price of " +
                    snap["Prod-" + (index + 1).toString()];
              } else {
                snap["Prod-" + (index + 1).toString() + "-Price"] = value;
                return null;
              }
            },
            decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.blue,
                    fontFamily: "Logo",
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
                prefixText: snap["Prod-" + (index + 1).toString()] + " :",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                labelText: (index + 1).toString() +
                    ": " +
                    snap["Prod-" + (index + 1).toString()],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue)),
                fillColor: Colors.white),
          ));
    } else {
      return new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: new TextFormField(
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value != "")
                  prices[index] = double.parse(value);
                else
                  prices[index] = 0;
                total = 0;
                for (int i = 0; i < prices.length; i++) {
                  if (prices[i] != null) {
                    total += prices[i];
                  }
                }
              });
            },
            minLines: 1,
            autofocus: true,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter Price of " +
                    snap["Prod-" + (index + 1).toString()];
              } else {
                snap["Prod-" + (index + 1).toString() + "-Price"] = value;
                return null;
              }
            },
            decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.blue,
                    fontFamily: "Logo",
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
                prefixText: snap["Prod-" + (index + 1).toString()] + " :",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                labelText: (index + 1).toString() +
                    ": " +
                    snap["Prod-" + (index + 1).toString()],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue)),
                fillColor: Colors.white),
          ));
    }
  }

  Future<void> uploadData() async {
    await Firestore.instance
        .collection('Shops')
        .document(snap["Shop-Id"])
        .collection('S2')
        .document(snap["Order-Id"])
        .setData(snap);
    await Firestore.instance
        .collection('Shops')
        .document(snap["Shop-Id"])
        .collection('S1')
        .document(snap["Order-Id"])
        .delete();
    await Firestore.instance
        .collection("Customers")
        .document(snap["Customer-Id"])
        .updateData({"Order-Details.Stage": "S2"});
    Navigator.pop(context);
  }
}
