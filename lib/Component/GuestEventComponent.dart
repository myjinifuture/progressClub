import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Screens/GuestEventRegistration.dart';
import 'package:progressclubsurat_new/Screens/ViewGuestEventTicketDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/MultipleEventList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestEventComponent extends StatefulWidget {
  var EventData;

  GuestEventComponent({this.EventData});

  @override
  _GuestEventComponentState createState() => _GuestEventComponentState();
}

class _GuestEventComponentState extends State<GuestEventComponent> {
  String memberId;
  String dateData;
  List<String> date;
  String month, url;

  @override
  funDate() {
    dateData = " ${widget.EventData["EventDate"]}";
    date = dateData.split('/');
    print("-------------------->${date}");
    funMonth("${date[1]}");
    url = "${widget.EventData["GPSLocation"]}";
  }

  funMonth(String mon) {
    if (mon == "01") {
      month = "Jan";
    } else if (mon == "02") {
      month = "Feb";
    } else if (mon == "03") {
      month = "March";
    } else if (mon == "04") {
      month = "April";
    } else if (mon == "05") {
      month = "May";
    } else if (mon == "06") {
      month = "June";
    } else if (mon == "07") {
      month = "July";
    } else if (mon == "08") {
      month = "Aug";
    } else if (mon == "09") {
      month = "Sept";
    } else if (mon == "10") {
      month = "Oct";
    } else if (mon == "11") {
      month = "Nov";
    } else if (mon == "12") {
      month = "Dec";
    } else {
      month = "";
    }
  }

  getlocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      log("memberid`==${memberId}");
      //print(memberName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocaldata();
    funDate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //height: 80,
              //color: Colors.red,
              width: MediaQuery.of(context).size.width / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(7),
                            topLeft: Radius.circular(7)),
                        color: appPrimaryMaterialColor),
                    //height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          // '${widget.EventData["startdate"].toString().substring(8, 10)}',
                          " ${date[0]}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 7, bottom: 7, left: 5, right: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                        color: Colors.white),
                    // color: Colors.black,
                    //height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          //'${new DateFormat.MMM().format(DateTime.parse(DateFormat("dd-MM-yyyy").parse(widget.EventData["EventDate"].toString().substring(3, 6)).toString()))},${widget.EventData["EventDate"].substring(4, 6)}',
                          // "Feb,2021",
                          //"${widget.EventData["EventDate"]}",
                          "${month}" + " ${date[2].toString().substring(0, 4)}",
                          style: TextStyle(
                              fontSize: 11,
                              color: cnst.appPrimaryMaterialColor,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.EventData["EventName"]}",
                    //"Event Name",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                    "StartTime : ${widget.EventData["EventStartTime"].toString().substring(0, 5)}",

                    // "StartTime : 12 am",
                    style: TextStyle(fontSize: 14)),
                Text(
                    "EndTime   : ${widget.EventData["EventEndTime"].toString().substring(0, 5)}",

                    // "EndTime   : 12 am",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             new ViewGuestEventTicketDetail(
                    //               //searchData: txtSearch.text,
                    //               eventData: widget.EventData,
                    //             )));
                    launch(url);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: cnst.appPrimaryMaterialColor),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Text(
                              //"${widget.EventData["PCName"]}",

                              "Venue",
                              style: TextStyle(fontSize: 13)),
                          Icon(
                            Icons.location_on,
                            color: appPrimaryMaterialColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: "${widget.EventData["Status"]}" == "False"
                      ? InkWell(
                          onTap: () {
                            RegisterForGuestEvent();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: cnst.appPrimaryMaterialColor),
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Register",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new ViewGuestEventTicketDetail(
                                          //searchData: txtSearch.text,
                                          eventData: widget.EventData,
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: cnst.appPrimaryMaterialColor),
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 18.0, top: 4, right: 18, bottom: 4),
                              child: Text(
                                "View",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        )),
            ],
          )
          //Text("${widget.EventData["EventList"][0]["name"]}")
        ],
      ),
    );
  }

  RegisterForGuestEvent() async {
    print('Call');
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.AddGuestEventRegistrationConfirmation(
                MemberId, widget.EventData["Id"].toString())
            .then((data) async {
          if (data.Data == "1" && data.IsSuccess == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new GuestEventRegistration(
                          eventData: widget.EventData,
                          memberId: memberId,
                        )));
          } else {
            showMsg("Progress Club ", title: data.Message);
          }
        }, onError: (e) {
          showMsg("Error", title: "Try Again.");
        });
      } else {
        showMsg("Progress Club", title: "No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Progress Club", title: "No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'Progress Club'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("$title"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
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
