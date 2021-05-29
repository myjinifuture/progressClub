import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Screens/InvitedGuestDetails.dart';
import 'package:progressclubsurat_new/Screens/WebViewPayment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MultipleEventListMeetingComponents extends StatefulWidget {
  var data;
  bool checkvaluee = false;
  String memberId, TitleLabel, MeetingId;
  String _valuess;

  MultipleEventListMeetingComponents(
      {this.data, this.memberId, this.TitleLabel, this.MeetingId});

  @override
  _MultipleEventListMeetingComponentsState createState() =>
      _MultipleEventListMeetingComponentsState();
}

class _MultipleEventListMeetingComponentsState
    extends State<MultipleEventListMeetingComponents> {
  String _valuess;
  bool isLoading = false,
      isLoadingNotComming = false,
      isLoadingSubstitute = false;
  String memberType = "", chapterId = "";

  showMsg(String title, String msg) {
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

  String setTime(String date, String tm) {
    return new DateFormat.jm().format(DateTime.parse("$date $tm")).toString();
  }

  RegisterForMeeting(String regType) async {
    print('Call');
    try {
      print(
          "${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}");
      //print("${new DateFormat("yyyy-MM-dd").parse("${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}")}");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var data = {
          'Id': 0,
          'MemberId': widget.memberId,
          'MeetingId': widget.MeetingId,
          'Date': DateTime.now().toString().substring(0, 10),
          'SubstituteName': "",
          'SubstituteMobile': "",
          'Reg_Type': regType,
        };

        Services.AddMeetingConformation(data).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
              widget.data["Reg_Type"] = "$regType";
            });
            Fluttertoast.showToast(msg: "Register Successfully");
            Navigator.pushReplacementNamed(context, '/Dashboard');
            //showMsg("Progress Club", data.Message);
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Progress Club", data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Error", "Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("Progress Club", "No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Progress Club", "No Internet Connection.");
    }
  }

  RegisterForMeetingNotComming(String regType) async {
    print('Call');
    try {
      print(
          "${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}");
      //print("${new DateFormat("yyyy-MM-dd").parse("${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}")}");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoadingNotComming = true;
        });
        var data = {
          'Id': 0,
          'MemberId': widget.memberId,
          'MeetingId': widget.data["Id"],
          'Date': DateTime.now().toString().substring(0, 10),
          'SubstituteName': "",
          'SubstituteMobile': "",
          'Reg_Type': regType,
        };
        Services.AddMeetingConformation(data).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoadingNotComming = false;
              widget.data["Reg_Type"] = "$regType";
            });
            showMsg("Progress Club", data.Message);
          } else {
            setState(() {
              isLoadingNotComming = false;
            });
            showMsg("Progress Club", data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoadingNotComming = false;
          });
          showMsg("Error", "Try Again.");
        });
      } else {
        setState(() {
          isLoadingNotComming = false;
        });
        showMsg("Progress Club", "No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Progress Club", "No Internet Connection.");
    }
  }

  showEventDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            MyDialog(widget.memberId.toString(), widget.data["Id"].toString(),
                (action) {
              if (action == "done") {
                //get List Code
                //getTestimonialDataFromServer();
                setState(() {
                  widget.data["Reg_Type"] = "substitute";
                });
              }
            }));
  }

  @override
  void initState() {
    _valuess = "${widget.data["Title"]}";
    print(_valuess.contains("Common"));
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberType = prefs.getString(Session.Type);
      chapterId = prefs.getString(Session.ChapterId);
    });
  }

  _launchURL(String url) async {
    //const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "${widget.data["Title"]}",
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '${widget.data["ChapterName"]}',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '${widget.data["LongDescription"]}',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.50),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.TitleLabel} Date & Time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: cnst.appPrimaryMaterialColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From : ',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.data["Start_Date"].substring(8, 10)}-'
                          "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.data["Start_Date"].substring(0, 10)).toString()))}-${widget.data["Start_Date"].substring(0, 4)}",
                          //' ${widget.data["Start_Date"].toString().substring(0, 10)}',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'To : ',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.data["End_Date"].substring(8, 10)}-'
                          "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.data["End_Date"].substring(0, 10)).toString()))}-${widget.data["End_Date"].substring(0, 4)}",
                          //' ${widget.data["End_Date"].toString().substring(0, 10)}',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Start At ${setTime(widget.data["Start_Date"].toString().substring(0, 10), widget.data["Time"])}',
                          //'Start At ${widget.data["Time"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Venue At :',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                '${widget.data["Venue"]}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Registration Charges : ${cnst.Inr_Rupee} ${widget.data["Charges"]}/-',
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            widget.data["GoggleLink"].toString() != "null" &&
                    widget.data["GoggleLink"].toString().toLowerCase() !=
                        "null" &&
                    widget.data["GoggleLink"].toString().toLowerCase() != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: Colors.blueAccent,
                          minWidth: MediaQuery.of(context).size.width - 10,
                          onPressed: () {
                            _launchURL(widget.data["GoggleLink"].toString());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam,
                                  color: Colors.white, size: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Join",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
             new   DateFormat("yyyy-MM-dd")
                            .parse(
                                "${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}")
                            .compareTo(new DateFormat("yyyy-MM-dd").parse(
                                "${widget.data["CurrentDate"].toString().substring(0, 10)}")) >
                        0 ||
                    new DateFormat("yyyy-MM-dd")
                            .parse(
                                "${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}")
                            .compareTo(new DateFormat("yyyy-MM-dd").parse(
                                "${widget.data["CurrentDate"].toString().substring(0, 10)}")) ==
                        0
                ? memberType.toLowerCase() == "guest" && _valuess.toLowerCase().contains("common")  != true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      margin: EdgeInsets.only(top: 10),
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        color: widget.data["Reg_Type"]
                                                    .toString()
                                                    .toLowerCase() ==
                                                "coming"
                                            ? Colors.green
                                            : cnst.appPrimaryMaterialColor,
                                        minWidth:
                                            MediaQuery.of(context).size.width -
                                                10,
                                        onPressed: () {
                                          print(
                                              'eeeeeeeeeeeeeeeeeee+${widget.data}');
                                          //RegisterForMeeting("coming");
                                          if (widget.data["Reg_Type"] ==
                                                  "coming" &&
                                              widget.data["PaymentRefNo"]
                                                      .toString() !=
                                                  "" &&
                                              widget.data["PaymentRefNo"]
                                                      .toString() !=
                                                  "null") {
                                            // RegisterForMeeting('comming');
                                          } else {
                                            if (widget.data["Charges"] == "0") {
                                              RegisterForMeeting('comming');
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebViewPayment(
                                                              widget.data)));
                                            }
                                            //RegisterForMeeting("coming");
                                          }
                                        },
                                        child: setUpButtonChild(),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.data["Reg_Type"] == "coming" &&
                                        widget.data["PaymentRefNo"]
                                                .toString() !=
                                            "" &&
                                        widget.data["PaymentRefNo"]
                                                .toString() !=
                                            "null"
                                    ? Container()
                                    : Row(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            margin: EdgeInsets.only(top: 10),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0)),
                                              color: widget.data["Reg_Type"]
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "not coming"
                                                  ? Colors.green
                                                  : cnst
                                                      .appPrimaryMaterialColor,
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  10,
                                              onPressed: () {
                                                RegisterForMeetingNotComming(
                                                    "not coming");
                                              },
                                              child:
                                                  setUpButtonChildNotComing(),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            )
                          ],
                        ),
                      )
                    : chapterId.toString() ==
                            widget.data["Chapter_ID"].toString()
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          margin: EdgeInsets.only(top: 10),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            color: widget.data["Reg_Type"]
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "coming"
                                                ? Colors.green
                                                : cnst.appPrimaryMaterialColor,
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                10,
                                            onPressed: () {
                                              RegisterForMeeting("coming");
                                            },
                                            child: setUpButtonChild(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          margin: EdgeInsets.only(top: 10),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            color: widget.data["Reg_Type"]
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "not coming"
                                                ? Colors.green
                                                : cnst.appPrimaryMaterialColor,
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                10,
                                            onPressed: () {
                                              RegisterForMeetingNotComming(
                                                  "not coming");
                                            },
                                            child: setUpButtonChildNotComing(),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                )
                              ],
                            ),
                          )
                        : Container()
                : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Note : Last date of Registration.\n${widget.data["LastDateOfRegistration"].toString().substring(0, 10)}',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Coming",
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget setUpButtonChildNotComing() {
    if (isLoadingNotComming == false) {
      return new Text(
        "Not Coming",
        style: TextStyle(
            color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget setUpButtonChildSubstitute() {
    if (isLoadingSubstitute == false) {
      return new Text(
        "Substitute",
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}

class MyDialog extends StatefulWidget {
  var memberId, meetingId;
  final Function onChange;

  MyDialog(this.memberId, this.meetingId, this.onChange);

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  double rating = 0.0;
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobileNo = new TextEditingController();

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);
  bool isLoading = false;
  ProgressDialog pr;

  showMsg(String title, String msg) {
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

  RegisterForMeetingNotComming(String regType) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        var data = {
          'Id': 0,
          'MemberId': widget.memberId,
          'MeetingId': widget.meetingId,
          'Date': DateTime.now().toString().substring(0, 10),
          'SubstituteName': edtName.text,
          'SubstituteMobile': edtMobileNo.text,
          'Reg_Type': regType,
        };
        Services.AddMeetingConformation(data).then((data) async {
          if (data.Data == "1") {
            pr.hide();
            Navigator.pop(context);
            showMsg("Progress Club", data.Message);
            widget.onChange("done");
          } else {
            pr.hide();
            showMsg("Progress Club", data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Error", "Try Again.");
        });
      } else {
        pr.hide();
        showMsg("Progress Club", "No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Progress Club", "No Internet Connection.");
    }
  }

  @override
  void initState() {
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      //this right here
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter Substitute Detail",
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: TextFormField(
                controller: edtName,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    hintText: "Enter Substitute Name",
                    hintStyle: TextStyle(fontSize: 13)),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: edtMobileNo,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    hintText: "Enter Substitute Mobile Number.",
                    hintStyle: TextStyle(fontSize: 13)),
                keyboardType: TextInputType.number,
                maxLength: 10,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 10,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 10,
                          onPressed: () {
                            if (edtName.text != "") {
                              if (edtMobileNo != "") {
                                if (edtMobileNo.text.length == 10) {
                                  RegisterForMeetingNotComming("substitute");
                                } else {
                                  showMsg("Progress Club",
                                      "Please Enter Valid Mobile Number.");
                                }
                              } else {
                                showMsg("Progress Club",
                                    "Please Enter Substitute Mobile Number");
                              }
                            } else {
                              showMsg("Progress Club",
                                  "Please Enter Substitute Name");
                            }
                          },
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
