import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/FaceToFaceComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class GetFaceToFace extends StatefulWidget {
  @override
  _GetFaceToFaceState createState() => _GetFaceToFaceState();
}

class _GetFaceToFaceState extends State<GetFaceToFace> {
  ProgressDialog pr;
  bool isLoading = true;
  List list = [];

  @override
  void initState() {
    _getlist();
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



  _getlist() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        Future res = Services.GetFaceToFace(preferences.getString(cnst.Session.MemberId));
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list = data;
              isLoading = false;
            });
          } else {
            setState(() {
              list = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetAd Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
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
      body: Column(
        children: <Widget>[
         /* Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: 4,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        child: FaceToFaceComponent());
                  }),
            ),
          )*/

          isLoading
              ? Center(child: CircularProgressIndicator())
              : list.length > 0
              ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        child: FaceToFaceComponent(list[index],() {
                          setState(() {
                            list.removeAt(index);
                          });
                        }));
                  }),
            ),
          )
              : Center(
              child: Text(
                "No Data Found",
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w500),
              ))
        ],
      ),

    );
  }
}
