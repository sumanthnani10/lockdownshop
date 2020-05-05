import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class Delivery extends StatefulWidget {
  final String uid;

  Delivery({@required this.uid});

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("Shops")
          .document("${widget.uid}")
          .collection("S4")
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
          print(snapshot.data.documents);
          if (snapshot.data.documents.length == 0) {
            print(2);
            return new Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[new Text("No Delivery Queue")],
            ));
          } else {
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => buildDeliveryList(
                    context, snapshot.data.documents[index], index));
          }
        }
      },
    );
  }

  buildDeliveryList(BuildContext context, snapshot, index) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: new Card(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black)),
        elevation: 4,
        child: new FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Bill4(
                          snapshot: snapshot,
                        )));
          },
          child: new Row(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.green[400],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Token",
                        style: new TextStyle(fontSize: 14),
                      ),
                      new Text(
                        snapshot["Token"].toString(),
                        style: new TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              new Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          new ReCase(snapshot['Customer-Name']
                                  .toString()
                                  .toLowerCase())
                              .titleCase,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20),
                        ),
                        new Text(
                          snapshot["Prod-Count"].toString() +
                              (snapshot["Prod-Count"] == 1
                                  ? " Item"
                                  : " Items"),
                        ),
                        new SizedBox(
                          height: 2,
                        ),
                        new Text(
                          "Total: " + snapshot["Total"].toString(),
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {
                    print(snapshot.data);
                    moveDelivery(snapshot.data);
                  },
                  child: Column(children: <Widget>[
                    new Icon(
                      Icons.chevron_right,
                      color: Colors.green,
                      size: 36,
                    ),
                    new Text(
                      "Delivered",
                      style:
                          TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> moveDelivery(snap) async {
    print(snap);
    await Firestore.instance
        .collection("Customers")
        .document(snap["Customer-Id"])
        .updateData({"Order-Details": FieldValue.delete()});
    await Firestore.instance
        .collection('Shops')
        .document(snap["Shop-Id"])
        .collection('S4')
        .document(snap["Order-Id"])
        .delete();
  }
}

class Bill4 extends StatefulWidget {
  final snapshot;

  Bill4({@required this.snapshot});

  @override
  _Bill4State createState() => _Bill4State();
}

class _Bill4State extends State<Bill4> {
  Map<String, dynamic> snap;

  @override
  // ignore: must_call_super
  void initState() {
    snap = widget.snapshot.data;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text(
            new ReCase(snap['Customer-Name'].toString().toLowerCase())
                .titleCase),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: new Text(
                    "Total: Rs." + snap['Total'].toString(),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: new ListView.builder(
            itemCount: snap["Prod-Count"],
            itemBuilder: (context, index) => getBills(index)),
      ),
    );
  }

  getBills(int index) {
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: new Card(
          elevation: 2,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.green)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: new Row(
              children: <Widget>[
                new Expanded(
                    flex: 1,
                    child: new Text(
                      '${index + 1}.',
                      style: new TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w200),
                    )),
                new Expanded(
                  flex: 4,
                  child: new Text(
                    '${snap['Prod-' + (index + 1).toString()]}',
                    textAlign: TextAlign.start,
                    style: new TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Text(
                    '${snap['Prod-' + (index + 1).toString() + '-Price']}',
                    textAlign: TextAlign.end,
                    style: new TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
