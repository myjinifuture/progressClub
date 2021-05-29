import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingAssignmentComponents extends StatefulWidget {
  var list;
  String meetingId;
  Function onChange;
  PendingAssignmentComponents(this.list, this.meetingId,this.onChange);

  @override
  _PendingAssignmentComponentsState createState() =>
      _PendingAssignmentComponentsState();
}

class _PendingAssignmentComponentsState
    extends State<PendingAssignmentComponents> {
  //loading var
  bool isLoading = false;

  TextEditingController edtName = new TextEditingController();

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

  signUpDone(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  sendTaskFinish() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        widget.onChange("show");
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String memberId = prefs.getString(Session.MemberId);
        var now = new DateTime.now();

        var data = {
          'Id': "0",
          'MemberId': memberId,
          'AssignmentId': widget.list["Id"],
          'Date': "${new DateFormat("yyyy-MM-dd").format(now)}",
          'MeetingId': widget.meetingId,
          'Value1':
              widget.list["Type"].toString().trim() == "Text" ? "" : "true",
          'Value2': widget.list["Type"].toString().trim() == "Text"
              ? edtName.text.trim()
              : "null",
        };

        Services.updatePendingTask(data).then((data) async {
          /*setState(() {
            isLoading = false;
          });*/
          if (data.Data == "1") {
            widget.onChange("cancel");
            setState(() {
              widget.list["IsCompleted"] = true;
              signUpDone("Assignment Task Update Successfully.");
            });
          } else {
            /*setState(() {
              isLoading = false;
            });*/
            widget.onChange("cancel");
            showMsg(data.Message);
          }
        }, onError: (e) {
          /*setState(() {
            isLoading = false;
          });*/
          widget.onChange("cancel");
          showMsg("Try Again.");
        });
      } else {
        /*setState(() {
          isLoading = false;
        });*/
        widget.onChange("cancel");
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _showConfirmDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Progress Club"),
          content: new Text("Are You Sure You Want To Submit Assignment"),
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
                sendTaskFinish();
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
    return widget.list["IsCompleted"] == false
        ? Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                //side: BorderSide(color: cnst.appcolor)),
                side: BorderSide(
                    width: 0.50, color: cnst.appPrimaryMaterialColor),
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                '${widget.list["Title"]}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            !isLoading
                                ? Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: MaterialButton(
                                        minWidth: 70,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        color: cnst.appPrimaryMaterialColor,
                                        onPressed: () {
                                          //if (isLoading == false) this.SaveOffer();
                                          //Navigator.pushReplacementNamed(context, '/Dashboard');
                                          //Navigator.pushReplacementNamed(context, '/OtpVerification');
                                          //checkLogin();
                                          if (isLoading == false) {
                                            if (widget.list["Type"]
                                                        .toString()
                                                        .trim() ==
                                                    "Text" ||
                                                widget.list["Type"]
                                                        .toString()
                                                        .trim() ==
                                                    "Number") {
                                              if (edtName.text != "") {
                                                //showMsg("Wow Me"); Done
                                                _showConfirmDialog();
                                                //sendTaskFinish();
                                              } else {
                                                showMsg("Please Enter Text.");
                                              }
                                            } else {
                                              //showMsg("Wow");   Done
                                              _showConfirmDialog();
                                              //sendTaskFinish();
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  )
                                : Container(
                                    height: 35,
                                    width: 35,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                          ],
                        ),
                        widget.list["Type"].toString().trim() == "Text" ||
                                widget.list["Type"].toString().trim() ==
                                    "Number"
                            ? Container(
                                padding: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  controller: edtName,
                                  minLines: 1,
                                  maxLines: 4,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      hintText: "Input Here"),
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
