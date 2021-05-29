import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:progressclubsurat_new/Screens/EditGuestData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EventGuest extends StatefulWidget {
  @override
  _EventGuestState createState() => _EventGuestState();
}

class _EventGuestState extends State<EventGuest> {
  List<eventClass> _eventList = [];
  List<eventClass> _allowedEventList = [];
  eventClass _eventClass;

  bool isLoading = false, isSearching = false;
  List _allVisitorList = new List();
  List _searchList = new List();
  String Invitemsg = "";
  String memberId = "";
  TextEditingController searchText = new TextEditingController();

  ProgressDialog pr;

  @override
  void initState() {
    getEventData();
    getVisitorData("0");
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
    });
  }

  getEventData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetGeneralEvents();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              _eventList = data;
            });
            for (int i = 0; i < _eventList.length; i++) {
              if (_eventList[i].status == true) {
                _allowedEventList.add(_eventList[i]);
              }
            }
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getEventMessage(eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.ShrinkURL(eventId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();

            var shortLink = data;
            var msg = "";
            for (int i = 0; i < _eventList.length; i++) {
              if (_eventList[i].eventId == eventId)
                msg = _eventList[i].InviteMsg;
            }

            if (msg.length > 0 && msg.contains('#link#')) {
              msg = msg.replaceAll('#link#', shortLink);
            }

            setState(() {
              Invitemsg = msg;
            });
          } else {
            pr.hide();
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          pr.hide();
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getVisitorData(eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // pr.show();
        // Future res = Services.GetEventVisitor(eventId);
        Services.GetEventVisitor(eventId).then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              _allVisitorList = data;
            });
          } else {
            pr.hide();
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          pr.hide();
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _addVisitorToEvent(index) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          'Id': 0,
          'VisitorId': _allVisitorList[index]["Id"],
          'EventId': _eventClass.eventId,
        };

        Services.AddVisitorToEvent(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data == "1") {
            setState(() {
              _allVisitorList[index]["status"] = "Invited";
            });
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91${mobile}");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", Invitemsg);

    if (Platform.isIOS) {
      launch(urlwithmsg, forceSafariVC: false);
    } else {
      launch(urlwithmsg);
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
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteGuest(String Id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.DeleteGuest(Id).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });
            getVisitorData(_eventClass.eventId);
          } else {
            isLoading = false;
            showHHMsg("Complaint Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Progress Club"),
          content: new Text("Are You Sure You Want To Delete this Guest ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteGuest(Id);
              },
            ),
          ],
        );
      },
    );
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            // Navigator.pop(context);
            Navigator.pushReplacementNamed(context, "/Dashboard");
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'Guest Invite',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/AddGuest");
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                        border: Border.all(color: cnst.appPrimaryMaterialColor),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 3, right: 3, top: 2, bottom: 2),
                      child: Text(
                        "Add\nGuest",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: cnst.appPrimaryMaterialColor),
                      ),
                    ))),
          ),
        ],
      ),
      body: isLoading
          ? LoadinComponent()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: InputDecorator(
                      decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          )),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<eventClass>(
                        hint: _eventList.length > 0
                            ? Text("Select Event")
                            : Text("No Event Found"),
                        value: _eventClass,
                        onChanged: (val) {
                          setState(() {
                            _eventClass = val;
                            isSearching = false;
                            searchText.text = "";
                            print(val.eventName);
                            getEventMessage(val.eventId);
                            getVisitorData(val.eventId);
                          });
                        },
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff5946a8)),
                        items: _allowedEventList.map((eventClass events) {
                          return new DropdownMenuItem<eventClass>(
                            value: events,
                            child: Text(
                              events.eventName,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 70,
                    child: TextFormField(
                      controller: searchText,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          suffixIcon: Icon(
                            Icons.search,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          hintText: "Search Guest Name / City"),
                      onChanged: (val) {
                        searchOperation(val);
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  _eventClass != null
                      ? _allVisitorList.length > 0
                          ? isSearching
                              ? _searchList.length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount: _searchList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            elevation: 2,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 6.0,
                                                              bottom: 1.0),
                                                      child: Container(
                                                        width: 46,
                                                        height: 46,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: new DecorationImage(
                                                              image: AssetImage(
                                                                  "images/icon_user.png"),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  new Radius
                                                                          .circular(
                                                                      75.0)),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 6,
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    "${_searchList[index]["Name"]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color.fromRGBO(
                                                                            81,
                                                                            92,
                                                                            111,
                                                                            1))),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    "${_searchList[index]["MobileNo"]}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey[700])),
                                                              ],
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            3)),
                                                            Text(
                                                              "${_searchList[index]["status"]}",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: _searchList[index]["status"]
                                                                              .toString()
                                                                              .toLowerCase() ==
                                                                          "pending"
                                                                      ? Colors
                                                                          .red
                                                                      : _searchList[index]["status"].toString().toLowerCase() ==
                                                                              "invited"
                                                                          ? Colors
                                                                              .orange
                                                                          : Colors
                                                                              .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.call,
                                                          color:
                                                              Colors.green[700],
                                                        ),
                                                        onPressed: () {
                                                          launch("tel:" +
                                                              _searchList[index]
                                                                  ['MobileNo']);
                                                          if (_searchList[index]
                                                                      ["status"]
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              "pending") {
                                                            _addVisitorToEvent(
                                                                index);
                                                          }
                                                        }),
                                                    Platform.isIOS
                                                        ? Container()
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 7.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _openWhatsapp(
                                                                    "${_searchList[index]["MobileNo"]}");
                                                                if (_searchList[index]
                                                                            [
                                                                            "status"]
                                                                        .toString()
                                                                        .toLowerCase() ==
                                                                    "pending") {
                                                                  _addVisitorToEvent(
                                                                      index);
                                                                }
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'images/whatsapp.png',
                                                                height: 36,
                                                                width: 36,
                                                              ),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            _searchList[index][
                                                                            "status"]
                                                                        .toString()
                                                                        .toLowerCase() !=
                                                                    "registered"
                                                                ? _showConfirmDialog(
                                                                    _searchList[
                                                                                index]
                                                                            [
                                                                            "Id"]
                                                                        .toString())
                                                                : Fluttertoast.showToast(
                                                                    msg:
                                                                        "Registered Member Can't Delete",
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .BOTTOM,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT);
                                                          },
                                                          child: Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .red[400])),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 60.0),
                                                  child: Align(
                                                    child: Text(
                                                      "${_allVisitorList[index]["City"]}",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : NoDataComponent()
                              : Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: _allVisitorList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        elevation: 2,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 6.0,
                                                          bottom: 1.0),
                                                  child: Container(
                                                    width: 46,
                                                    height: 46,
                                                    decoration: BoxDecoration(
                                                      image: new DecorationImage(
                                                          image: AssetImage(
                                                              "images/icon_user.png"),
                                                          fit: BoxFit.cover),
                                                      borderRadius: BorderRadius
                                                          .all(new Radius
                                                              .circular(75.0)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 6,
                                                        top: 5,
                                                        bottom: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "${_allVisitorList[index]["Name"]}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            81,
                                                                            92,
                                                                            111,
                                                                            1))),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "${_allVisitorList[index]["MobileNo"]}",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .grey[700],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 3)),
                                                        Text(
                                                          // "${_allVisitorList[index]["status"]}",
                                                          '',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: _allVisitorList[index]
                                                                              [
                                                                              "status"]
                                                                          .toString()
                                                                          .toLowerCase() ==
                                                                      "pending"
                                                                  ? Colors.red
                                                                  : _allVisitorList[index]["status"]
                                                                              .toString()
                                                                              .toLowerCase() ==
                                                                          "invited"
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.call,
                                                      color: Colors.green[700],
                                                    ),
                                                    onPressed: () {
                                                      launch("tel:" +
                                                          _allVisitorList[index]
                                                              ['MobileNo']);
                                                      if (_allVisitorList[index]
                                                                  ["status"]
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "pending") {
                                                        _addVisitorToEvent(
                                                            index);
                                                      }
                                                    }),
                                                Platform.isIOS
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 7.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _openWhatsapp(
                                                                "${_allVisitorList[index]["MobileNo"]}");
                                                            if (_allVisitorList[
                                                                            index]
                                                                        [
                                                                        "status"]
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "pending") {
                                                              _addVisitorToEvent(
                                                                  index);
                                                            }
                                                          },
                                                          child: Image.asset(
                                                            'images/whatsapp.png',
                                                            height: 36,
                                                            width: 36,
                                                          ),
                                                        ),
                                                      ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _allVisitorList[index][
                                                                        "status"]
                                                                    .toString()
                                                                    .toLowerCase() !=
                                                                "registered"
                                                            ? _showConfirmDialog(
                                                                _allVisitorList[
                                                                            index][
                                                                        "Id"]
                                                                    .toString())
                                                            : Fluttertoast.showToast(
                                                                msg:
                                                                    "Registered Member Can't Delete",
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT);
                                                      },
                                                      child: Icon(Icons.delete,
                                                          color:
                                                              Colors.red[400])),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 60.0),
                                              child: Align(
                                                child: Text(
                                                  "${_allVisitorList[index]["City"]}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                alignment: Alignment.topLeft,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                          : NoDataComponent()
                      : _allVisitorList.length > 0
                          ? isSearching
                              ? _searchList.length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount: _searchList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                              elevation: 2,
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0,
                                                                left: 10.0,
                                                                bottom: 1.0),
                                                        child: Container(
                                                          width: 46,
                                                          height: 46,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: new DecorationImage(
                                                                image: AssetImage(
                                                                    "images/icon_user.png"),
                                                                fit: BoxFit
                                                                    .cover),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    new Radius
                                                                            .circular(
                                                                        75.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      "${_searchList[index]["Name"]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color: Color.fromRGBO(
                                                                              81,
                                                                              92,
                                                                              111,
                                                                              1))),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      "${_searchList[index]["MobileNo"]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey[700])),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.call,
                                                            color: Colors
                                                                .green[700],
                                                          ),
                                                          onPressed: () {
                                                            launch("tel:" +
                                                                _searchList[
                                                                        index][
                                                                    'MobileNo']);
                                                          }),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 60.0),
                                                    child: Align(
                                                      child: Text(
                                                        "${_allVisitorList[index]["City"]}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        },
                                      ),
                                    )
                                  : NoDataComponent()
                              : Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: _allVisitorList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        elevation: 2,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 10.0,
                                                          bottom: 1.0),
                                                  child: Container(
                                                    width: 46,
                                                    height: 46,
                                                    decoration: BoxDecoration(
                                                      image: new DecorationImage(
                                                          image: AssetImage(
                                                              "images/icon_user.png"),
                                                          fit: BoxFit.cover),
                                                      borderRadius: BorderRadius
                                                          .all(new Radius
                                                              .circular(75.0)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 6,
                                                        top: 5,
                                                        bottom: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "${_allVisitorList[index]["Name"]}",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color
                                                                    .fromRGBO(
                                                                  81,
                                                                  92,
                                                                  111,
                                                                  1,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "${_allVisitorList[index]["MobileNo"]}",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .grey[700],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.call,
                                                    color: Colors.green[700],
                                                  ),
                                                  onPressed: () {
                                                    launch("tel:" +
                                                        _allVisitorList[index]
                                                            ['MobileNo']);
                                                  },
                                                ),
                                                PopupMenuButton(
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      value: 1,
                                                      child: Text("Edit"),
                                                    ),
                                                    PopupMenuItem(
                                                        value: 2,
                                                        child: Text("Delete")),
                                                  ],
                                                  icon: Icon(Icons.more_vert),
                                                  onSelected: (value) {
                                                    print(_allVisitorList[index]
                                                        ["Id"]);
                                                    if (value == 1) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditGuestData(
                                                                  name: _allVisitorList[
                                                                          index]
                                                                      ["Name"],
                                                                  mobile: _allVisitorList[
                                                                          index]
                                                                      [
                                                                      "MobileNo"],
                                                                  id: _allVisitorList[
                                                                              index]
                                                                          ["Id"]
                                                                      .toString(),
                                                                  memberId:
                                                                      memberId,
                                                                  city: _allVisitorList[
                                                                              index]
                                                                          [
                                                                          "City"]
                                                                      .toString(),
                                                                )),
                                                      );
                                                    } else {}
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 60.0),
                                              child: Align(
                                                child: Text(
                                                  "${_allVisitorList[index]["City"]}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                alignment: Alignment.topLeft,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                          : NoDataComponent(),
                ],
              ),
            ),
    );
  }

  void searchOperation(String searchText) {
    _searchList.clear();
    setState(() {
      isSearching = true;
    });
    if (searchText != "") {
      for (int i = 0; i < _allVisitorList.length; i++) {
        String name = _allVisitorList[i]["Name"];
        String cmpName = _allVisitorList[i]["MobileNo"];
        String cmpcity = _allVisitorList[i]["City"];
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            cmpName.toLowerCase().contains(searchText.toLowerCase()) ||
            cmpcity.toLowerCase().contains(searchText.toLowerCase())) {
          _searchList.add(_allVisitorList[i]);
        }
      }
    } else
      setState(() {
        isSearching = false;
      });
    setState(() {});
  }
}
