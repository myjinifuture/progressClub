import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/AskComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class Ask extends StatefulWidget {
  @override
  _AskState createState() => _AskState();
}

class _AskState extends State<Ask> {
  //loading var
  bool isLoading = false;
  List list = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAskFromServer();
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

  getAskFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetAsk();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              list = data;
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
            : list.length != 0 && list != null
                ? ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AskComponents(list[index]);
                    })
                : Container(
                    child: Center(
                        child: Text('No Data Found.',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 20))),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child:  IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/MyAskScreenFromDashboard');
            // Navigator.pushNamed(context, "/MyAskScreen");
          },
          icon: Icon(
            Icons.add_circle_outline,
            size: 32,
          ),
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
