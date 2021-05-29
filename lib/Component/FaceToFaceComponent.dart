import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceToFaceComponent extends StatefulWidget {
  var list;
  Function _onremove;

  FaceToFaceComponent(this.list, this._onremove);

  @override
  _FaceToFaceComponentState createState() => _FaceToFaceComponentState();
}

class _FaceToFaceComponentState extends State<FaceToFaceComponent> {
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

  _deleteMyAsk() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var data = {
          'Id': widget.list["Id"],
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

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" && date != null && date != "null") {
      tempDate = date.toString().split("/");

      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
              "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: cnst.appcolor)),
        side: BorderSide(width: 0.15, color: cnst.appPrimaryMaterialColor),
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
                widget.list["MemberImage"] != "" &&
                        widget.list["MemberImage"] != null
                    ? ClipOval(
                        child: FadeInImage.assetNetwork(
                            placeholder: "",
                            width: 55,
                            height: 55,
                            fit: BoxFit.fill,
                            image:
                                widget.list["MemberImage"]),
                      )
                    : ClipOval(
                        child: Image.asset(
                          "images/logo.jpg",
                          width: 55,
                          height: 55,
                          fit: BoxFit.fill,
                        ),
                      ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.list["MemberName"]}',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Text(
                          'Chapter: ',
                          style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 8),
                        child: Text(
                          '${widget.list["ChapterName"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Text(
                          'Date: ',
                          style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 8),
                        child: Text(
                          '${widget.list["MeetingDt"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(
                'Type: ',
                style: TextStyle(
                  color: cnst.appPrimaryMaterialColor,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Text(
                '${widget.list["Type"]}',
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(
                'Value Generated: ',
                style: TextStyle(
                  color: cnst.appPrimaryMaterialColor,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15, right: 15, top: 8),
              child: Text(
                '${widget.list["ValueTaken"]}',
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete,color: Colors.red,),
                  onPressed: (){
                    _showConfirmDialog();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
