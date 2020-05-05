import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';

class Registration extends StatefulWidget {
  final String uid, mobile;

  Registration({@required this.uid, @required this.mobile});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Color bg = Colors.lightBlue;
  File shopImg, shopkeeperImg, aadhaarImg;
  GoogleMapController map;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController listCont;
  CircularProgressIndicator progressIndicator;

  bool submit = false;

  Marker shopMarker;

  String shopName,
      shopType,
      shopAddress,
      shopImage,
      shopkeeperName,
      shopkeeperEmail,
      shopkeeperImage,
      aadhaarImage,
      aadhaarNumber;

  Position position;
  LatLng shopLocation;
  TextEditingController addressEditor = new TextEditingController();
  TextEditingController snEditor = new TextEditingController();
  TextEditingController stEditor = new TextEditingController();
  TextEditingController sknEditor = new TextEditingController();
  TextEditingController skeEditor = new TextEditingController();
  TextEditingController adEditor = new TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    shopLocation = null;
    listCont = new ScrollController();
    shopMarker = Marker(
        markerId: MarkerId("Shop"),
        position: new LatLng(17.406622914697873, 78.48532670898436),
        draggable: true,
        onDragEnd: (newPos) {
          moveCamera(newPos);
        });
  }

  Future<void> getCurrentLocation() async {
    if (shopLocation != null) {
      moveToLocation(shopLocation);
    } else {
      print(await Geolocator().checkGeolocationPermissionStatus());
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      shopLocation = new LatLng(position.latitude, position.longitude);
      moveToLocation(new LatLng(position.latitude, position.longitude));
    }
  }

  moveCamera(LatLng latLng) async {
    map.animateCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(target: latLng, zoom: 15)));
    print("1234567890");
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    shopAddress = placemark.elementAt(0).name +
        ',' +
        placemark.elementAt(0).subLocality +
        ',' +
        placemark.elementAt(0).subAdministrativeArea +
        ',' +
        placemark.elementAt(0).locality +
        ',' +
        placemark.elementAt(0).administrativeArea;
    addressEditor.text = shopAddress;
  }

  moveToLocation(LatLng latLng) async {
    map.moveCamera(CameraUpdate.newCameraPosition(
        new CameraPosition(target: latLng, zoom: 15)));
    shopMarker = Marker(
        position: new LatLng(latLng.latitude, latLng.longitude),
        markerId: shopMarker.markerId,
        draggable: true,
        onDragEnd: (newPos) {
          moveCamera(newPos);
        });
    print(latLng.toString() + shopMarker.position.toString());
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    shopAddress = placemark.elementAt(0).name +
        ',' +
        placemark.elementAt(0).subLocality +
        ',' +
        placemark.elementAt(0).subAdministrativeArea +
        ',' +
        placemark.elementAt(0).locality +
        ',' +
        placemark.elementAt(0).administrativeArea;
    addressEditor.text = shopAddress;
  }

  @override
  Widget build(BuildContext context) {
    progressIndicator = new CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(bg),
    );
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: bg,
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "LockDown Shop",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Logo',
                            fontSize: 36),
                      ),
                    )),
                if (submit)
                  Expanded(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 0),
                                color: Colors.black26,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Details",
                                style: TextStyle(fontSize: 32),
                              ),
                              Stack(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "Shop Name:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(shopName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "Shop Type:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(shopType,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Shop Address:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(shopAddress,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 32,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Shopkeeper Name:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(shopkeeperName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Shopkeeper Email:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(shopkeeperEmail,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Shopkeeper Mobile:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(widget.mobile,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 32,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Aadhaar Number:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(aadhaarNumber,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        140,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        progressIndicator,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Text("Uploading Data"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Please Wait..."),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      )),
                if (!submit)
                  Expanded(
                    flex: 10,
                    child: ListView(
                      controller: listCont,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 16),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                    color: Colors.black26,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Shop Details",
                                      style: TextStyle(
                                          fontSize: 24,
                                          decorationThickness: 1.5),
                                    ),
                                  ),
                                  new Form(
                                      key: formKey1,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 4),
                                        child: Column(
                                          children: <Widget>[
                                            new TextFormField(
                                              controller: snEditor,
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              validator: (sname) {
                                                if (sname.isEmpty) {
                                                  return "Please enter your Shop Name.";
                                                } else {
                                                  shopName = sname;
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                  labelText: 'Shop Name',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide: BorderSide(
                                                          color: Colors.blue)),
                                                  fillColor: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            new TextFormField(
                                              controller: stEditor,
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              validator: (stype) {
                                                if (stype.isEmpty) {
                                                  return "Please enter your Shop Type.";
                                                } else {
                                                  shopType = stype;
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                  labelText: 'Shop Type',
                                                  helperText:
                                                      "Eg: Pharmacy, Kirana and General, Drinking Water",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(8),
                                                      borderSide:
                                                          new BorderSide(
                                                              color:
                                                                  Colors.blue)),
                                                  fillColor: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            RaisedButton.icon(
                                              onPressed: () {
                                                selectImage(1);
                                              },
                                              icon: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    left: 8.0),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              label: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    right: 8.0),
                                                child: Text(
                                                  "Shop Image",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4))),
                                            ),
                                            if (shopImg != null)
                                              Container(
                                                  height: 242,
                                                  child: Image.file(shopImg,
                                                      height: 242)),
                                            if (shopImg == null)
                                              SizedBox(
                                                height: 242,
                                              )
                                          ],
                                        ),
                                      )),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            if (formKey1.currentState
                                                .validate()) {
                                              if (shopImg != null) {
                                                listCont.animateTo(
                                                    (MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            20) *
                                                        1,
                                                    duration: new Duration(
                                                        milliseconds: 1500),
                                                    curve: Curves.ease);
                                                setState(() {
                                                  bg = Colors.amber;
                                                });
                                              } else {
                                                showAlertDialog(
                                                    context,
                                                    "Shop Image",
                                                    "Select an Image for your Shop.");
                                              }
                                            }
                                          },
                                          child: Text(
                                            "Next >",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        new GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 16),
                            child: Container(
                                width: MediaQuery.of(context).size.width - 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: Offset(0, 0),
                                      color: Colors.black26,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Shop Location",
                                        style: TextStyle(
                                            fontSize: 24,
                                            decorationThickness: 1.5),
                                      ),
                                    ),
                                    new Form(
                                        key: formKey2,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 0, 16, 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              FlatButton.icon(
                                                  color: Colors.white,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(8),
                                                      side: new BorderSide(
                                                          color: Colors.black,
                                                          width: 0.5)),
                                                  onPressed: () async {
                                                    Prediction p =
                                                        await PlacesAutocomplete
                                                            .show(
                                                                context:
                                                                    context,
                                                                apiKey:
                                                                    "AIzaSyD3Mp-nbpxvDIUmjL9MWCDil6AypsFcCVQ",
                                                                mode: Mode.overlay,
                                                                // Mode.fullscreen
                                                                language: "en",
                                                                components: [
                                                          new Component(
                                                              Component.country,
                                                              "in")
                                                        ]);
                                                    locselect(
                                                        p, homeScaffoldKey);
                                                  },
                                                  icon: Icon(Icons.search),
                                                  label: Text(
                                                      "Search Your Location")),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0),
                                                height: 300,
                                                child: GoogleMap(
                                                  key: UniqueKey(),
                                                  mapType: MapType.normal,
                                                  markers: {shopMarker},
                                                  buildingsEnabled: true,
                                                  rotateGesturesEnabled: true,
                                                  zoomGesturesEnabled: true,
                                                  myLocationEnabled: true,
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                          target: LatLng(
                                                              17.406622914697873,
                                                              78.48532670898436),
                                                          zoom: 10.9),
                                                  onLongPress: (lloc) {
                                                    setState(() {
                                                      shopLocation = lloc;
                                                    });
                                                  },
                                                  onTap: (a) {
                                                    moveCamera(
                                                        shopMarker.position);
                                                  },
                                                  onMapCreated:
                                                      (GoogleMapController c) {
                                                    map = c;
                                                    getCurrentLocation();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              new TextFormField(
                                                maxLines: 4,
                                                controller: addressEditor,
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (sadd) {
                                                  if (sadd.isEmpty) {
                                                    return "Please enter your shop name.";
                                                  } else {
                                                    shopAddress = sadd;
                                                    return null;
                                                  }
                                                },
                                                onChanged: (value) {
                                                  shopAddress = value;
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 16,
                                                            horizontal: 16),
                                                    labelText: 'Shop Address',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(8),
                                                        borderSide:
                                                            new BorderSide(
                                                                color: Colors
                                                                    .amber)),
                                                    fillColor: Colors.white),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              if (formKey2.currentState
                                                  .validate()) {
                                                setState(() {
                                                  bg = Colors.blue;
                                                });
                                                listCont.animateTo(
                                                    (MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            20) *
                                                        0,
                                                    duration: new Duration(
                                                        milliseconds: 1500),
                                                    curve: Curves.ease);
                                              }
                                            },
                                            child: Text(
                                              "< Previous",
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 16),
                                            )),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                bg = Colors.orange;
                                              });
                                              listCont.animateTo(
                                                  (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          18) *
                                                      2,
                                                  duration: new Duration(
                                                      milliseconds: 1500),
                                                  curve: Curves.ease);
                                            },
                                            child: Text(
                                              "Next >",
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 16),
                                            ))
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ),
                        new GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 16),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                    color: Colors.black26,
                                  )
                                ],
                              ),
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      "Shopkeeper Details",
                                      style: new TextStyle(
                                          fontSize: 24,
                                          decorationThickness: 1.5),
                                    ),
                                  ),
                                  new Form(
                                      key: formKey3,
                                      child: new Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 4),
                                        child: Column(
                                          children: <Widget>[
                                            new TextFormField(
                                              controller: sknEditor,
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              validator: (skname) {
                                                if (skname.isEmpty) {
                                                  return "Please enter Shopkeeper Name.";
                                                } else {
                                                  shopkeeperName = skname;
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                  labelText: 'Shopkeeper Name',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.orange)),
                                                  fillColor: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            new TextFormField(
                                              controller: skeEditor,
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              validator: (skemail) {
                                                if (skemail.isEmpty) {
                                                  return "Please enter your Shop Type.";
                                                } else {
                                                  shopkeeperEmail = skemail;
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                  labelText: 'Shopkeeper Email',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(8),
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors
                                                                  .orange)),
                                                  fillColor: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            RaisedButton.icon(
                                              onPressed: () {
                                                selectImage(2);
                                              },
                                              icon: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    left: 8.0),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              label: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    right: 8.0),
                                                child: Text(
                                                  "Shopkeeper Image",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4))),
                                            ),
                                            if (shopkeeperImg != null)
                                              Container(
                                                  height: 242,
                                                  child: Image.file(
                                                      shopkeeperImg,
                                                      height: 242)),
                                            if (shopkeeperImg == null)
                                              Container(height: 242),
                                          ],
                                        ),
                                      )),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              bg = Colors.amber;
                                            });
                                            listCont.animateTo(
                                                (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        20) *
                                                    1,
                                                duration: new Duration(
                                                    milliseconds: 1500),
                                                curve: Curves.ease);
                                          },
                                          child: Text(
                                            "< Previous",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 16),
                                          )),
                                      FlatButton(
                                          onPressed: () {
                                            if (formKey3.currentState
                                                .validate()) {
                                              setState(() {
                                                bg = Colors.green;
                                              });
                                              listCont.animateTo(
                                                  (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          20) *
                                                      3,
                                                  duration: new Duration(
                                                      milliseconds: 1500),
                                                  curve: Curves.ease);
                                            }
                                          },
                                          child: Text(
                                            "Next >",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 16),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        new GestureDetector(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 4, 16),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0),
                                    color: Colors.black26,
                                  )
                                ],
                              ),
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      "Aadhaar Details",
                                      style: new TextStyle(
                                          fontSize: 24,
                                          decorationThickness: 1.5),
                                    ),
                                  ),
                                  new Form(
                                      key: formKey4,
                                      child: new Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 4),
                                        child: Column(
                                          children: <Widget>[
                                            new TextFormField(
                                              controller: adEditor,
                                              maxLines: 1,
                                              maxLength: 12,
                                              keyboardType: TextInputType.text,
                                              validator: (adnum) {
                                                if (adnum.isEmpty) {
                                                  return "Please enter Shopkeeper Name.";
                                                } else if (adnum.length != 12) {
                                                  return 'Aadhaar number must be 12 digits.';
                                                } else {
                                                  aadhaarNumber = adnum;
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                  labelText: 'Aadhaar Number',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide: BorderSide(
                                                          color: Colors.green)),
                                                  fillColor: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            RaisedButton.icon(
                                              onPressed: () {
                                                selectImage(3);
                                              },
                                              icon: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    left: 8.0),
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              label: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    right: 8.0),
                                                child: Text(
                                                  "Aadhaar Image",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4))),
                                            ),
                                            if (aadhaarImg != null)
                                              Container(
                                                  height: 242,
                                                  child: Image.file(aadhaarImg,
                                                      height: 242)),
                                            if (aadhaarImg == null)
                                              Container(height: 242),
                                          ],
                                        ),
                                      )),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              bg = Colors.orange;
                                            });
                                            listCont.animateTo(
                                                (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        18) *
                                                    2,
                                                duration: new Duration(
                                                    milliseconds: 1500),
                                                curve: Curves.ease);
                                          },
                                          child: Text(
                                            "< Previous",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16),
                                          )),
                                      FlatButton(
                                          onPressed: () {
                                            if (formKey4.currentState
                                                .validate()) {
                                              if (aadhaarImg != null) {
                                                setState(() {
                                                  submit = true;
                                                  uploadData();
                                                });
                                                print(
                                                    "$shopName\n$shopType\n$shopkeeperName\n$shopkeeperEmail\n$aadhaarNumber\n");
                                              }
                                            }
                                          },
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadData() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/${widget.uid}');
    StorageTaskSnapshot snapshot;
    StorageUploadTask simg =
        storageReference.child('Shop-Image').putFile(shopImg);
    snapshot = await simg.onComplete;
    shopImage = await snapshot.ref.getDownloadURL();
    setState(() {
      bg = Colors.orange;
    });
    StorageUploadTask skimg =
        storageReference.child('Keeper-Image').putFile(shopkeeperImg);
    snapshot = await skimg.onComplete;
    shopkeeperImage = await snapshot.ref.getDownloadURL();
    setState(() {
      bg = Colors.amber;
    });
    StorageUploadTask aimg =
        storageReference.child('Aadhaar-Card').putFile(aadhaarImg);
    snapshot = await aimg.onComplete;
    aadhaarImage = await snapshot.ref.getDownloadURL();
    setState(() {
      bg = Colors.blue;
    });
    await Firestore.instance.collection("Shops").document(widget.uid).setData({
      'Shop-Details': {
        'Shop-Name': shopName,
        'Shop-Type': shopType,
        'Address': shopAddress,
        'Shop-Image': shopImage,
        'Verified': 'Not Verified'
      },
      'Keeper-Details': {
        'Keeper-Name': shopkeeperName,
        'Email': shopkeeperEmail,
        'Mobile': widget.mobile,
        'Keeper-Image': shopkeeperImage
      },
      'Aadhaar': {
        'Aadhaar-Front': aadhaarImage,
        'Aadhaar-Number': aadhaarImage
      },
      'Location': {
        'Lat': shopLocation.latitude,
        'Long': shopLocation.longitude
      },
      "Token": 0,
      "Pres-Token": 0
    });
    await Firestore.instance
        .collection("Locations")
        .document(widget.uid)
        .setData(
            {'Lat': shopLocation.latitude, 'Long': shopLocation.longitude});
    Navigator.pop(context);
  }

  Future<Null> locselect(
      Prediction p, GlobalKey<ScaffoldState> homeScaffoldKey) async {
    if (p != null) {
      PlacesDetailsResponse detailsResponse = await GoogleMapsPlaces(
              apiKey: "AIzaSyD3Mp-nbpxvDIUmjL9MWCDil6AypsFcCVQ")
          .getDetailsByPlaceId(p.placeId);
      shopLocation = new LatLng(detailsResponse.result.geometry.location.lat,
          detailsResponse.result.geometry.location.lng);
      setState(() {
        shopAddress = p.description;
        addressEditor.text = shopAddress;
      });
      moveToLocation(new LatLng(detailsResponse.result.geometry.location.lat,
          detailsResponse.result.geometry.location.lng));
    }
  }

  selectImage(int i) async {
    if (i == 1) {
      shopImg = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    if (i == 2) {
      shopkeeperImg = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    if (i == 3) {
      aadhaarImg = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {});
  }

  showAlertDialog(BuildContext context, String title, String content) {
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
      title: Text(title),
      content: Text(content),
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
