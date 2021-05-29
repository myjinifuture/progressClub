import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/offlinedatabase/db_handler.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as constant;

class Visitorlist extends StatefulWidget {
  @override
  _VisitorlistState createState() => _VisitorlistState();
}

class _VisitorlistState extends State<Visitorlist> {
  DBHelper dbHelper;
  Future<List<Visitorclass>> visitor;
  List visitordata = [];

  bool isLoading = false;

  @override
  void initState() {
    refresh();
  }

  refresh() async {
    dbHelper = new DBHelper();
    Future res = dbHelper.getVisitors();
    res.then((data) async {
      if (data != null && data.length > 0) {
        setState(() {
          visitordata = data;
        });
        print(data[0].id);
      } else {}
    }, onError: (e) {

    });
  }

  syncData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        List finalData = [];
        for (int i = 0; i < visitordata.length; i++) {
          var data = {
            "id": visitordata[i].id,
            "name": visitordata[i].name,
            "mobileNumber": visitordata[i].mobileNumber,
            "memberId": visitordata[i].memberId,
          };
          finalData.add(data);
        }
        print(finalData);
        Services.SyncVisitorData(finalData).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data == "1") {
            dbHelper.delete();
            refresh();
            Fluttertoast.showToast(
                msg: "Data Sync Successfully !",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
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

  Widget _Visitorlist(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width / 7,
                child: Text('${visitordata[index].id.toString()}',
                    textAlign: TextAlign.center)),
            Expanded(
                child: Text('${visitordata[index].name}',
                    textAlign: TextAlign.center)),
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text('${visitordata[index].mobileNumber}',
                    textAlign: TextAlign.center))
          ],
        ),
        Divider(
          color: Colors.grey[300],
          indent: 12,
          endIndent: 12,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visitor list"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.sync),
              onPressed: () {
                syncData();
              })
        ],
      ),
      body: isLoading
          ? LoadinComponent()
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 7,
                          child: Text(
                            "Id",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          child: Text("Name",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text("Mobile No",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black54,
                  endIndent: 12,
                  indent: 12,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: _Visitorlist,
                    itemCount: visitordata.length,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        height: 55,
        alignment: Alignment.center,
        color: Colors.grey[200],
        child: Text(
          'Total:  ' + '${visitordata.length}',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
      ),
    );
  }
}
