import 'dart:io';

import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';

//Components Dart File
import 'package:progressclubsurat_new/Component/GalleryComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';

class EventGallery extends StatefulWidget {
  final int EventId;

  const EventGallery({Key key, this.EventId}) : super(key: key);

  @override
  _EventGalleryState createState() => _EventGalleryState();
}

class _EventGalleryState extends State<EventGallery> {
  int eventid;
  bool isLoading = false;
  List list = new List();

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
  void initState() {
    // TODO: implement initState
    super.initState();

    getEventGallery();
  }

  getEventGallery() async {
    try {
      setState(() {
        eventid = widget.EventId;
      });
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetEventGalleryById(eventid);
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
          'Event Gallery',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? LoadinComponent()
            : list.length != 0 && list != null
                ? GridView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: list.length,
                    shrinkWrap: true,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return GalleryComponents(list[index]);
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
