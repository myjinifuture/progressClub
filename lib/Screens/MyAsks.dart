import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/AskComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/MyAskComponents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class MyAsks extends StatefulWidget {
  @override
  _MyAsksState createState() => _MyAsksState();
}

class _MyAsksState extends State<MyAsks> {
  bool isLoading = false;
  List myasklist = new List();
  ProgressDialog pr;

  @override
  void initState() {
    getMyAsk();
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
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

  getMyAsk() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.GetMyAsk(prefs.getString(cnst.Session.MemberId));
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              myasklist = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? LoadinComponent()
            : myasklist.length != 0 && myasklist != null
                ? ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: myasklist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MyAskComponents(myasklist[index],() {
                        setState(() {
                          myasklist.removeAt(index);
                        });
                      });
                    })
                : Container(
                    child: Center(
                        child: Text('No Data Found.',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 20))),
                  ),
      ),
    );
  }
}
