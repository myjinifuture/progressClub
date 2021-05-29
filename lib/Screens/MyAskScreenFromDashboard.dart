import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAskScreenFromDashboard extends StatefulWidget {
  @override
  _MyAskScreenFromDashboardState createState() => _MyAskScreenFromDashboardState();
}

class _MyAskScreenFromDashboardState extends State<MyAskScreenFromDashboard> {
  DateTime _date1;
  DateTime _date2;
  String _dateError1,_dateError2;
  ProgressDialog pr;

  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDescription = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  Future<Null> _selectaskDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date1 && picked != "null") {
      print("Date Selected -->>${_date1.toString()}");
      setState(() {
        _date1 = picked;
        _dateError1 = null;
      });
    }
  }

  Future<Null> _selectcloseDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date2 && picked != "null") {
      print("Date Selected -->>${_date2.toString()}");
      setState(() {
        _date2 = picked;
        _dateError2 = null;
      });
    }
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" && date != null && date != "null") {
      tempDate = date.toString().split("-");

      if (tempDate[2]
          .toString()
          .length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1]
          .toString()
          .length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
          "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(        valueColor: AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColor),),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    /*if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
            print("FFFFFFFF" + data.toString());
            saveDeviceToken();
          });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }*/
    // TODO: implement initState
    super.initState();
  }



  _addMyTask() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          'Id': "0",
          'Title': txtTitle.text,
          'Description': txtDescription.text,
          'FromDate': _date1.toString(),
          'ToDate': _date2.toString(),
          'MemberId': prefs.getString(Session.MemberId),
        };
        Services.AddMyTask(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data != "") {
            Fluttertoast.showToast(
                msg: "Task Added Successfully",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);

           //Navigator.pushReplacementNamed(context, "/AskList");
            Navigator.pop(context);
          } else {
            pr.hide();
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        pr.hide();
        showMsg("No Internet Connection.");
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
            Navigator.pop(context);
            //Navigator.pushReplacementNamed(context, '/AskList');
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'My Ask',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),

      ),
      body: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          //Navigator.pushReplacementNamed(context, '/AskList');
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Title",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.trim() == "") {
                              return 'Please Enter Title';
                            }
                            return null;
                          },
                          controller: txtTitle,
                          decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              contentPadding:
                              EdgeInsets.only(top: 5, left: 10, bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.black)),
                              hintText: 'Enter Name',
                              hintStyle:
                              TextStyle(color: Colors
                                  .grey, fontSize: 15)),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ask Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectaskDate(context);
                          },
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 50,
                            padding: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: _date1 == null
                                        ? Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          8.0),
                                      child: Text(
                                        " Ask Date",
                                        style: TextStyle(
                                            color: Colors
                                                .grey,
                                            fontSize: 15),
                                      ),
                                    )
                                        : Text(
                                        "  ${setDate(_date1.toString())}")),
                                GestureDetector(
                                    onTap: () {
                                      _selectaskDate(context);
                                    },
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: cnst
                                          .appPrimaryMaterialColor,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _dateError1 == null
                              ? Container()
                              : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _dateError1 ?? "",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "close Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectcloseDate(context);
                          },
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 50,
                            padding: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: _date2 == null
                                        ? Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          8.0),
                                      child: Text(
                                        " Close Date",
                                        style: TextStyle(
                                            color: Colors
                                                .grey,
                                            fontSize: 15),
                                      ),
                                    )
                                        : Text(
                                        "  ${setDate(_date2.toString())}")),
                                GestureDetector(
                                    onTap: () {
                                      _selectcloseDate(context);
                                    },
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: cnst
                                          .appPrimaryMaterialColor,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _dateError2 == null
                              ? Container()
                              : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _dateError2 ?? "",
                              style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ask Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.trim() == "") {
                              return 'Please Enter Description';
                            }
                            return null;
                          },
                          controller: txtDescription,
                          maxLines: 5,
                          decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              contentPadding:
                              EdgeInsets.only(top: 5, left: 10, bottom: 5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0, color: Colors.black)),
                              hintText: 'Enter Description',
                              hintStyle:
                              TextStyle(color: Colors
                                  .grey, fontSize: 15)),
                        ),


                      ],
                    ),

                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.only(top: 30),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width - 20,
                        onPressed: () {
                          bool isValidate = true;
                          setState(() {
                            if (_date1 == null) {
                              isValidate = false;
                              _dateError1 = "Please Select Ask Date";
                            }
                            if (_date2 == null) {
                              isValidate = false;
                              _dateError2 = "Please Select Close Date";
                            }
                          });
                          if (_formkey.currentState.validate()) {
                            if (isValidate) {
                              _addMyTask();
                            }
                          }
                        },
                        child: Text(
                          "Post Ask",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
