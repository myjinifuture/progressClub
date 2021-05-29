import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NitificationComponents.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  //loading var
  bool isLoading = false;
  List list = new List();

  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    super.initState();
    getDailyProgressFromServer();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  getDailyProgressFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetNotificationFromServer();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              list = data;
            });
          } else {
            //showMsg("Try Again.");
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: isLoading
          ? LoadinComponent()
          : list.length != 0 && list != null
              ? ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NitificationComponents(list[index]);
                  },
                )
              : Container(
                  child: Center(
                    child: Text(
                      'No Data Found.',
                      style: TextStyle(
                          color: cnst.appPrimaryMaterialColor, fontSize: 20),
                    ),
                  ),
                ),
    );
    /*return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List>(
        future: Services.getAssigment(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData && snapshot.data.length>0
              ? ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return NitificationComponents();
            },
          )
              : NoDataComponent()
              : LoadinComponent();
        },
      ),
    );*/
  }
}
