import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PostProperty.dart';

class MyProperty extends StatefulWidget {
  String googlemap, carpetarea, dropdownpriority, editadditional, unitofcarpet;

  MyProperty(
      {this.googlemap,
      this.carpetarea,
      this.dropdownpriority,
      this.editadditional,
      this.unitofcarpet});

  @override
  _MyPropertyState createState() => _MyPropertyState();
}

class _MyPropertyState extends State<MyProperty> with TickerProviderStateMixin{
  TabController _tabController;
  int selectedTab = 0;
  bool isLoading = true;
  List SellData = [], RentData = [];
  String memberId = "";
  int ontap=0;


  @override
  void initState() {
    super.initState();
    _getRegionalTeam();
  }


  _getRegionalTeam() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      memberId = prefs.getString(Session.MemberId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.MyProperty("myproperty", "Sell", memberId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              SellData = data;
              print("sell data ");
              print(SellData);
            });
            _getGoldCrorepatiMemebers();
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Chapter Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went wrong");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getGoldCrorepatiMemebers() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      memberId = prefs.getString(Session.MemberId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.MyProperty1("myproperty", "Rent", memberId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              RentData = data;
              isLoading = false;
              print("inside rent data");
              print(RentData);
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Chapter Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went wrong");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isedit = true;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Waiting...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("My Property"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  TabBar(
                    controller: _tabController,
                    indicatorColor: cnst.appPrimaryMaterialColor,
                    unselectedLabelColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.188),
                    onTap: (index) {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    tabs: [
                      Tab(
                        child: Text(
                          'SELL',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'RENT',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView.builder(
                            itemCount: SellData.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8),
                                child: GestureDetector(
                                  child:AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds : 500),
                                    child: SlideAnimation(
                                      horizontalOffset: 50,
                                      child: FadeInAnimation(
                                        child: Card(
                                                elevation: 8,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      10),
                                                ),
                                                child: ExpansionTile(
                                                  title:
                                                  Row(
                                                    children: [
                                                      // Text(
                                                      //   "Nature : ",
                                                      //   style: TextStyle(
                                                      //     color: Colors.black,
                                                      //     fontWeight: FontWeight.bold,
                                                      //     fontSize: 15,
                                                      //   ),
                                                      // ),
                                                      Text(
                                                        "${SellData[index]['Nature']}",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  children: <Widget>[
                                                    ExpansionTile(
                                                      title: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left: 1.0),
                                                                child: Text(
                                                                  "Area : ",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left : 20.0),
                                                                child: Text(
                                                                  "${SellData[index]['Area']}",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                          ),
                                                         SizedBox(
                                                           height: 10,
                                                         ),
                                                         Row(
                                                           children: [
                                                             Padding(
                                                               padding: const EdgeInsets
                                                                   .only(
                                                                   right: 1.0),
                                                               child: Text(
                                                                 "Type : ",
                                                                 style: TextStyle(
                                                                   color: Colors
                                                                       .black,
                                                                   fontWeight: FontWeight
                                                                       .bold,
                                                                   fontSize: 15,
                                                                 ),
                                                               ),
                                                             ),
                                                             Padding(
                                                               padding: const EdgeInsets.only(left : 20.0),
                                                               child: Text(
                                                                 "${SellData[index]['Ptype']}",
                                                                 style: TextStyle(
                                                                   color: Colors
                                                                       .deepPurpleAccent,
                                                                   fontWeight: FontWeight
                                                                       .bold,
                                                                   fontSize: 15,
                                                                 ),
                                                               ),
                                                             ),
                                                           ],
                                                         ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                         Row(
                                                           children: [
                                                             Text(
                                                               "Price : ",
                                                               style: TextStyle(
                                                                 color: Colors.black,
                                                                 fontWeight: FontWeight
                                                                     .bold,
                                                                 fontSize: 15,
                                                               ),
                                                             ),
                                                             Padding(
                                                               padding: const EdgeInsets.only(left : 20.0),
                                                               child: Text(
                                                                 "${SellData[index]['Price'] +
                                                                     " ₹"}",
                                                                 style: TextStyle(
                                                                   color: Colors
                                                                       .deepPurpleAccent,
                                                                   fontWeight: FontWeight
                                                                       .bold,
                                                                   fontSize: 15,
                                                                 ),
                                                               ),
                                                             ),
                                                           ],
                                                         ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right:8.0),
                                                                child: Text(
                                                                  "Address : ",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "${SellData[index]['Address']}",
                                                                overflow: TextOverflow
                                                                    .visible,
                                                                style: TextStyle(
                                                                  color:
                                                                  Colors
                                                                      .deepPurpleAccent,
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left : 34.0),
                                                                child: Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (
                                                                                context) =>
                                                                                PostProperty(
                                                                                  selected: true,
                                                                                  Data: SellData,
                                                                                  index: index,
                                                                                  currentindex: 0,
                                                                                ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Icon(
                                                                        Icons.edit,
                                                                      ),
                                                                    ),
                                                                    Text("Edit",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: (){
                                      PreviewData(index,SellData);
                                      },
                                                                    child: Icon(
                                                                      Icons.preview,
                                                                    ),
                                                                  ),
                                                                  Text("Preview",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                      // children: <Widget>[
                                                      //   ListTile(
                                                      //     title: Text('data'),
                                                      //   )
                                                      // ],
                                                    ),
                                                    // ListTile(
                                                    //   title: Text(
                                                    //       'data'
                                                    //   ),
                                                    // )
                                                  ],
                                                )
                                            ),
                                      ),
                                    ),
                                  ),
    ),    //angle: animation.value,
                              );
                            }),
                    ListView.builder(
                        itemCount: RentData.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8, right: 8),
                            child: GestureDetector(
                              child:AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds : 500),
                                child: SlideAnimation(
                                  horizontalOffset: 50,
                                  child: FadeInAnimation(
                                    child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        child: ExpansionTile(
                                          title:
                                          Row(
                                            children: [
                                              // Text(
                                              //   "Nature : ",
                                              //   style: TextStyle(
                                              //     color: Colors.black,
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 15,
                                              //   ),
                                              // ),
                                              Text(
                                                "${RentData[index]['Nature']}",
                                                style: TextStyle(
                                                  color: Colors
                                                      .deepPurpleAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: <Widget>[
                                            ExpansionTile(
                                              title: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left: 1.0),
                                                        child: Text(
                                                          "Area : ",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left : 20.0),
                                                        child: Text(
                                                          "${RentData[index]['Area']}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right: 1.0),
                                                        child: Text(
                                                          "Type : ",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left : 20.0),
                                                        child: Text(
                                                          "${RentData[index]['Ptype']}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Price : ",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left : 20.0),
                                                        child: Text(
                                                          "${RentData[index]['Price'] +
                                                              " ₹"}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(right:8.0),
                                                        child: Text(
                                                          "Address : ",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "${RentData[index]['Address']}",
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: TextStyle(
                                                          color:
                                                          Colors
                                                              .deepPurpleAccent,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left : 34.0),
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        PostProperty(
                                                                          selected: true,
                                                                          Data: RentData,
                                                                          index: index,
                                                                          currentindex: 0,
                                                                        ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                              ),
                                                            ),
                                                            Text("Edit",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){
                                                              PreviewData(index,SellData);
                                                            },
                                                            child: Icon(
                                                              Icons.preview,
                                                            ),
                                                          ),
                                                          Text("Preview",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                              // children: <Widget>[
                                              //   ListTile(
                                              //     title: Text('data'),
                                              //   )
                                              // ],
                                            ),
                                            // ListTile(
                                            //   title: Text(
                                            //       'data'
                                            //   ),
                                            // )
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),    //angle: animation.value,
                          );
                        }),
                    ]),
                  ),
                ],
              )),
        ));
  }

  PreviewData(int index,List SellData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("My Property Data"),
          content: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Nature : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['Nature']}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Type : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['Ptype']}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Area : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['Area']}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Carpet Area : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['AreaValue'] + " " + SellData[index]['Unit']}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Price : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['Price'] +
                          " ₹"}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Priority : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['Intensity']}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets
                        .only(
                        left: 1.0),
                    child: Text(
                      "Google Map : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left : 20.0),
                    child: Text(
                      "${SellData[index]['GoogleMap']}",
                      style: TextStyle(
                        color: Colors
                            .deepPurpleAccent,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Text(
                      "Address : ",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight: FontWeight
                            .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${SellData[index]['Address']}",
                    overflow: TextOverflow
                        .visible,
                    style: TextStyle(
                      color:
                      Colors
                          .deepPurpleAccent,
                      fontWeight: FontWeight
                          .bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
