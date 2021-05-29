import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Screens/MyAskEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAskComponents extends StatefulWidget {
  var myasklist;
  Function _onremove;

  MyAskComponents(this.myasklist, this._onremove);

  @override
  _MyAskComponentsState createState() => _MyAskComponentsState();
}

class _MyAskComponentsState extends State<MyAskComponents> {
  ProgressDialog pr;

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text("Rubric Group"),
          content: new Text("Are You Sure You Want To Remove This ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMyAsk();
              },
            ),
          ],
        );
      },
    );
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
            valueColor:
                AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColor),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    super.initState();
  }

  _deleteMyAsk() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var data = {
          'Id': widget.myasklist["Id"],
        };
        Services.DeleteMyAsks(data).then((data) async {
          if (data.Data != "0" && data.IsSuccess == true) {
            widget._onremove();

            Fluttertoast.showToast(
                msg: "Data Deleted Successfully",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);

            /*Navigator.pushNamedAndRemoveUntil(
                context, "/MyAsks", (Route<dynamic> route) => false);*/

            // Navigator.pop(context);
          } else {
            // showMsg(data.Message, title: "Error");

          }
        }, onError: (e) {
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
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
    return GestureDetector(
      onTap: () {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
      },
      child: Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              //side: BorderSide(color: cnst.appcolor)),
              side:
                  BorderSide(width: 0.15, color: cnst.appPrimaryMaterialColor),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'images/icon_ask.png',
                        height: 37,
                        width: 37,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.myasklist["Title"]}',
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                      IconButton(
                        onPressed: () {
                          //Navigator.pushNamed(context, "/MyAskEdit");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyAskEdit(widget.myasklist)));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showConfirmDialog();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  /*   Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ask From :',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.myasklist["Name"]}\n( ${widget.myasklist["ChapterName"]} )',
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),*/
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Ask Date :',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.myasklist["FromDate"].substring(8, 10)}-'
                                "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.myasklist["FromDate"].substring(0, 10)).toString()))}-${widget.myasklist["FromDate"].substring(0, 4)}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Close Date :',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.myasklist["ToDate"].substring(8, 10)}-'
                                "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.myasklist["ToDate"].substring(0, 10)).toString()))}-${widget.myasklist["ToDate"].substring(0, 4)}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ask :',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.myasklist["Description"]}',
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  /*Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Text('${widget.AskList["ChapterName"]}'),
                ),
                GestureDetector(
                  onTap: () {
                    String whatsAppLink = cnst.whatsAppLink;
                    String urlwithmobile = whatsAppLink.replaceAll(
                        "#mobile", "91${widget.AskList["MobileNo"]}");
                    String urlwithmsg = urlwithmobile.replaceAll("#msg", "Your Ask : ${widget.AskList["Description"]}\n");
                    SaveShare(urlwithmsg);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.green[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 7, right: 7),
                              child: Text(
                                'Message on Whatsapp',
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                            Image.asset(
                              'images/whatsapp.png',
                              height: 35,
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),*/
                ],
              ),
            ),
          )),
    );
  }
}
