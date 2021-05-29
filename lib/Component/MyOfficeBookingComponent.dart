import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOfficeBookingComponent extends StatefulWidget {
  var BookingList;
  Function onchange;

  MyOfficeBookingComponent(this.BookingList, this.onchange);

  @override
  _MyOfficeBookingComponentState createState() =>
      _MyOfficeBookingComponentState();
}

class _MyOfficeBookingComponentState extends State<MyOfficeBookingComponent> {
  bool isLoading = false;

  String setDate(String date) {
    String final_date = "";
    var dateFormat = date.split("-");

    var month;
    switch (int.parse(dateFormat[1])) {
      case 0:
        month = "January";
        break;
      case 1:
        month = "February";
        break;
      case 2:
        month = "March";
        break;
      case 3:
        month = "April";
        break;
      case 4:
        month = "May";
        break;
      case 5:
        month = "June";
        break;
      case 6:
        month = "July";
        break;
      case 7:
        month = "August";
        break;
      case 8:
        month = "September";
        break;
      case 9:
        month = "October";
        break;
      case 10:
        month = "November";
        break;
      case 11:
        month = "December";
        break;
    }
    return "${dateFormat[2].substring(0, 2)} ${month},${dateFormat[0]}";
  }

  _confirmation(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Progress Club"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                _DeleteMyBooking();
              },
            ),
          ],
        );
      },
    );
  }

  _DeleteMyBooking() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        print("Id: ${widget.BookingList["Id"]}");
        Services.DeleteMyBooking(widget.BookingList["Id"]).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != 0) {
            Navigator.pop(context);
            widget.onchange();
            Fluttertoast.showToast(
                msg: "Deleted Succsecfully !!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);
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
      setState(() {
        isLoading = false;
      });
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
    print("da: ${widget.BookingList}");
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: cnst.appcolor)),
          side: BorderSide(width: 0.50, color: cnst.appPrimaryMaterialColor),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  /*ClipOval(
                    child: widget.data["Image"] != null &&
                        widget.data["Image"] != ""
                        ? FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image:
                      widget.data["Image"].toString().contains("http")
                          ? widget.data["Image"]
                          : "http://pmc.studyfield.com/" +
                          widget.data["Image"],
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'images/icon_user.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),*/

                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /* Text('${widget.BookingList["Name"]}',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 18)),*/
                        Row(
                          children: <Widget>[
                            Text('Timing - '),
                            Container(
                              decoration: BoxDecoration(
                                  color: cnst.appPrimaryMaterialColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 4, top: 4),
                                child: Text(
                                  '${widget.BookingList["FromTime"]} To ${widget.BookingList["ToTime"]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                          'Status - ${widget.BookingList["Status"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 12),
                        ),
                        Text(
                          'Date - ${setDate(widget.BookingList["Date"])}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 12),
                        ),
                        // : Container(),
                        Text(
                          'Booking Purpose -'
                          ' ${widget.BookingList["Purpose"]}',
                        ),
                      ],
                    ),
                  )),
                  widget.BookingList["Status"] != "Approved"
                      ? GestureDetector(
                          onTap: () {
                            _confirmation("Are you sure you want to Delete?");
                          },
                          child: Icon(
                            Icons.delete_forever,
                            size: 32,
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
