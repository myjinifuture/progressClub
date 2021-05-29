import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List giveData =new List();
  bool isLoading = false;

  @override
  void initState() {
    _getGive();
  }

  _getGive() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetCMSPages();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              giveData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Myask Call $e");
          showMsg("Something went wrong.Please try agian.");
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
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
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
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'About Us',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? LoadinComponent()
          : giveData.length>0
              ? Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: giveData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                giveData[index]["Title"],
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                giveData[index]["Description"],
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ));
                    },
                  ),
                )
              : NoDataComponent(),
    );
  }
}
