import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

//star lib
import 'package:smooth_star_rating/smooth_star_rating.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackScreen> {
  double rating = 0.0;

  String memberId = "";

  //loading var
  bool isLoading = false;

  List list = new List();
  TextEditingController edtDesc = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
    });
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

  signUpDone(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
                //Navigator.pushReplacementNamed(context, '/Login');
              },
            ),
          ],
        );
      },
    );
  }

  sendFeedback() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var data = {
          'MemberId': memberId,
          'Description': edtDesc.text.trim(),
          'Rating': rating.toStringAsFixed(2).toString(),
        };
        Services.sendFeedback(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data == "1") {
            setState(() {
              rating = 0;
              edtDesc.text = "";
            });
            signUpDone("Feedback Send Successfully");
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
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
        backgroundColor: cnst.appPrimaryMaterialColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'Feedback',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.3,
              color: cnst.appPrimaryMaterialColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        'Send us Your Feedback !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 25, right: 25),
                      child: Text(
                        "Do you Have Any Suggestion or Found Some Bug?\nlet us know in the Below",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 25),
              padding: EdgeInsets.only(left: 10),
              color: cnst.appPrimaryMaterialColor,
              height: 50,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/Dashboard');
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 25,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),*/
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  //side: BorderSide(color: cnst.appcolor)),
                  side: BorderSide(width: 0.50, color: Colors.grey[500]),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4.4,
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  //color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'How was your experience ?',
                            style: TextStyle(
                                fontSize: 16,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '(Select a star amount )',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  rating = v;
                                  setState(() {});
                                },
                                starCount: 5,
                                rating: rating,
                                size: 40.0,
                                color: Colors.amber,
                                //borderColor: Colors.green,
                                spacing: 0.0),
                          ],
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          controller: edtDesc,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              hintText: "Describe Your Experience here..",
                              hintStyle: TextStyle(fontSize: 13)),
                          maxLines: 4,
                          minLines: 2,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                          top: 25,
                        ),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 20,
                          onPressed: () {
                            if (isLoading == false) {
                              print(rating.toStringAsFixed(2));
                              sendFeedback();
                            }
                          },
                          child: Text(
                            "Submit Feedback",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: isLoading ? LoadinComponent() : Container(),
            )
          ],
        )),
      ),
    );
  }
}
