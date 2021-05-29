import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/MyOfficeBookingComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';

class MyOfficeBooking extends StatefulWidget {
  @override
  _MyOfficeBookingState createState() => _MyOfficeBookingState();
}

class _MyOfficeBookingState extends State<MyOfficeBooking> {
  bool isLoading = false;
  List BookingList = new List();

  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    super.initState();
    _GetMyOfficeBooking();
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

  _GetMyOfficeBooking() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetMyOfficeBooking();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              BookingList = data;
            });
            print("BookingList--> " + BookingList.length.toString());
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'My Booking',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height / 1.25,
                      width: MediaQuery.of(context).size.width,
                      child: LoadinComponent(),
                    )
                  : BookingList.length > 0
                      ? Container(
                          height: MediaQuery.of(context).size.height / 1.25,
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: BookingList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MyOfficeBookingComponent(
                                  BookingList[index],(){
                                _GetMyOfficeBooking();
                              });
                            },
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height / 1.25,
                          width: MediaQuery.of(context).size.width,
                          child: NoDataComponent(),
                        ),
              /*Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0),
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0)),
                    color: cnst.appPrimaryMaterialColor,
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Text(
                      "Request Booking",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),*/
            ],
          )),
    );
  }
}
