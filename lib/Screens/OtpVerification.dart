import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpVerification extends StatefulWidget {
  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  var isLoading = false;
  int otpCode;
  TextEditingController edtVerificationCode = new TextEditingController();

  String memberId = "", memberMobile = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  showInternetMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    memberId = prefs.getString(Session.MemberId);
    String memberName = prefs.getString(Session.Name);
    memberMobile = prefs.getString(Session.Mobile);
    sendOtpCode(memberMobile);
  }

  sendOtpCode(String mobileNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var rng = new Random();
        int code = rng.nextInt(9999 - 1000) + 1000;
        setState(() {
          isLoading = true;
        });
        Future res = Services.sendOtpCode(mobileNo, code.toString());
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data == "1") {
            setState(() {
              otpCode = code;
            });
            Fluttertoast.showToast(
                msg: "Otp Send ${data.Message}",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call");
          //showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  VerificationStatusUpdate() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.CodeVerification(memberId);
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data == "1") {
            await prefs.setString(Session.VerificationStatus, "1");
            Navigator.pushReplacementNamed(context, '/Dashboard');
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call");
          //showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
          Navigator.pushReplacementNamed(context, '/Login');
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.9,
                color: cnst.appPrimaryMaterialColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Verify Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "you'll get a code via SMS ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
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
                    top: MediaQuery.of(context).size.height / 2.65,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    //color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                            controller: edtVerificationCode,
                            scrollPadding: EdgeInsets.all(0),
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                prefixIcon: Icon(
                                  Icons.verified_user,
                                  color: Colors.green,
                                ),
                                hintText: "OTP"),
                            maxLength: 4,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 10),
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
                              //if (isLoading == false) this.SaveOffer();
                              //Navigator.pushReplacementNamed(context, '/Dashboard');
                              /*Navigator.pushReplacementNamed(
                                      context, '/Dashboard');*/
                              if (!isLoading) {
                                if (otpCode.toString() ==
                                    edtVerificationCode.text) {
                                  //Navigator.pushReplacementNamed(context, '/Dashboard');
                                  VerificationStatusUpdate();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Invalid code",
                                      backgroundColor: Colors.red,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              }
                            },
                            child: Text(
                              "VERIFY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacementNamed(context, '/SignUp');
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  Text(
                                    "Didn't Receive the Verification Code ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (!isLoading) {
                                        sendOtpCode(memberMobile);
                                      }
                                    },
                                    child: Text(
                                      'RESEND CODE',
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: cnst.appPrimaryMaterialColor),
                                    ),
                                  ),
                                ],
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
              ),
            ],
          )),
        ),
      ),
    );
  }
}
