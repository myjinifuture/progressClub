import 'dart:io';

import 'package:flutter/material.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';

class MultipleEventListComponents extends StatefulWidget {
  var data;
  String memberId;
  MultipleEventListComponents(this.data,this.memberId);

  @override
  _MultipleEventListComponentsState createState() =>
      _MultipleEventListComponentsState();
}

class _MultipleEventListComponentsState
    extends State<MultipleEventListComponents> {

  bool isLoading = false;
  showMsg(String title,String msg) {
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

  RegisterForEvent() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var data = {
          'Id': 0,
          'MemberId': widget.memberId,
          'EventId': widget.data["Id"],
          'Date': DateTime.now().toString().substring(0,10),
        };
        Services.AddEventConformation(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          showMsg("Progress Club", data.Message);
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Error","Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("Progress Club","No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Progress Club","No Internet Connection.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${widget.data["EventName"]}",
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('${widget.data["LongDesc"]}',
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
                Text(
                  'Training Date & Time',
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Date :',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' ${widget.data["EventDate"].toString().substring(0,10)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
              ],
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
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(top: 10),
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width - 10,
                        onPressed: () {
                          RegisterForEvent();
                        },
                        child: setUpButtonChild(),
                      ),
                    ),
                  ],
                ),
                /*Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 3.3,
                      margin: EdgeInsets.only(top: 10),
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width - 10,
                        onPressed: () {
                          //if (isLoading == false) this.SaveOffer();
                          //Navigator.pushReplacementNamed(context, '/Dashboard');
                        },
                        child: Text(
                          "Register & Pay",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Register Now",
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}
