import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController edtMobile = new TextEditingController();

  //loading var
  bool isLoading = false;
  String OtpStatus;
  ProgressDialog pr;
  StreamSubscription iosSubscription;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String fcmToken = "";

  @override
  void initState() {
    _getOtpStatus();
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
    /*if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
            print("FFFFFFFF" + data.toString());
            saveDeviceToken();
          });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }*/
    // TODO: implement initState
    super.initState();
  }

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      var tokendata = token.split(':');
      setState(() {
        fcmToken = token;
        //sendFCMTokan();
      });
      print("FCM Token : $fcmToken");
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

  _getOtpStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.VerifyOTP().then((data) async {
          if (data.Data == "0" && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
              OtpStatus = data.Data;
            });
            print(OtpStatus);
          } else {
            setState(() {
              isLoading = false;
            });
            // Fluttertoast.showToast(msg: "$OtpStatus");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          //Fluttertoast.showToast(msg:"$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        Fluttertoast.showToast(msg: "No Internet Connection");
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "Something Went Wrong");
    }
  }

  checkLogin() async {
    if (edtMobile.text != "" && edtMobile.text != null) {
      if (edtMobile.text.length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            /*setState(() {
              isLoading = true;
            });*/
            pr.show();
            Future res = Services.MemberLogin(edtMobile.text);
            res.then((data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (data != null && data.length > 0) {
                /*setState(() {
                  isLoading = false;
                });*/
                print(data);
                pr.hide();
                await prefs.setString(Session.MemberId, data["Id"].toString());
                await prefs.setString(
                    Session.Mobile, data["MobileNo"].toString());
                await prefs.setString(Session.Name, data["Name"].toString());
                await prefs.setString(
                    Session.CompanyName, data["CompanyName"].toString());
                await prefs.setString(Session.Email, data["Email"].toString());
                await prefs.setString(Session.Photo, data["Photo"].toString());
                await prefs.setString(Session.Type, data["Type"].toString());
                await prefs.setString(
                    Session.cityname, data["cityname"].toString());
                await prefs.setString(
                    Session.statename, data["statename"].toString());
                await prefs.setString(Session.VerificationStatus,
                    data["VerificationStatus"].toString());
                await prefs.setString(
                    Session.ChapterId, data["ChapterId"].toString());

                /*if (data[0]["VerificationStatus"].toString() == "1") {
                  Navigator.pushReplacementNamed(context, '/Dashboard');
                } else {
                  Navigator.pushReplacementNamed(context, '/OtpVerification');
                }*/
/*                if(Platform.isIOS){
                  if(OtpStatus == "0"){*/
                Navigator.pushReplacementNamed(context, '/Dashboard');
                /* }
                  else {
                    Navigator.pushReplacementNamed(context, '/OtpVerification');
                  }
                }
                else{
                  Navigator.pushReplacementNamed(context, '/OtpVerification');
                }*/
              } else {
                pr.hide();
                showMsg("Invalid login Detail.");
              }
            }, onError: (e) {
              pr.hide();

              showMsg("Something went wrong. Please try agian.");
            });
          } else {
            pr.hide();
            showMsg("No Internet Connection.");
          }
        } on SocketException catch (ex) {
          // showMsg("No Internet Connection.");
          showMsg(ex.message);
        }
      } else {
        showMsg("Please Enter Valid Mobile No.");
      }
    } else {
      showMsg("Please Enter Mobile No.");
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Image.asset("images/logo.jpg",
                            width: 200.0, height: 200.0, fit: BoxFit.contain),
                      ),
                      Container(
                        height: 75,
                        child: TextFormField(
                          controller: edtMobile,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: cnst.appPrimaryMaterialColor,
                              ),
                              hintText: "Mobile No"),
                          // maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        height: 45,
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
                            //Navigator.pushReplacementNamed(context, '/OtpVerification');
                            if (isLoading == false) {
                              checkLogin();
                            }
                          },
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/SignUp');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Guest ?',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: cnst.appPrimaryMaterialColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeFInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/ForgotPassword');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: cnst.appPrimaryMaterialColor),
                              ),
                            ],
                          ),
                        ),
                      )*/
                    ],
                  ),
                ],
              ),
              //isLoading ? LoadinComponent() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
