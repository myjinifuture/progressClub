import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

import '../Common/Services.dart';

class OTP extends StatefulWidget {
  String mobileNo, newuser;
  Function onSuccess;

  OTP({this.mobileNo, this.onSuccess, this.newuser});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController controller = TextEditingController();
  var rndnumber = "";
  bool isLoading = false;
  ProgressDialog pr;
  String fcmToken = "";
  String error;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isCodeSent = false;
  String _verificationId;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _onVerifyCode();
  }

  // PinDecoration _pinDecoration = UnderlineDecoration(
  //     color: Colors.grey,
  //     enteredColor: cnst.appPrimaryMaterialColor1,
  //     hintText: '000000');


  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((value) {
        if (value.user != null) {
          widget.onSuccess();
        } else {
          Fluttertoast.showToast(msg: "Error validating OTP, try again");
        }
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Try again in sometime");
      });
    };
    final PhoneVerificationFailed verificationFailed =
        ( authException) {
      Fluttertoast.showToast(msg: authException.message);
      setState(() {
        isCodeSent = false;
        error = authException.message;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNo}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: controller.text);
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then(( value) {
      if (value.user != null) {
        widget.onSuccess();
      } else {
        Fluttertoast.showToast(msg: "Error validating OTP, try again");
      }
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Something went wrong");
    });
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pick n Delivere - Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Verification",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Enter the code we sent to your Mobile Number",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PinInputTextField(
                pinLength: 6,
                //decoration: _pinDecoration,
                controller: controller,
                autoFocus: true,
                textInputAction: TextInputAction.done,
                onSubmit: (pin) {
                  if (pin.length == 6) {
                    _onFormSubmitted();
                  } else {
                    Fluttertoast.showToast(msg: "Invalid OTP");
                  }
                },
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.only(top: 20),
                height: 45,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [
                        cnst.appPrimaryMaterialColor,
                        cnst.appPrimaryMaterialColor
                      ],
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  //color: cnst.appPrimaryMaterialColor1,
                  minWidth: MediaQuery.of(context).size.width - 20,
                  onPressed: () {
                    if (controller.text.length == 6) {
                      _onFormSubmitted();
                    }
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Didn't get Code? ",
                    style:
                        TextStyle(fontSize: 17, color: Colors.grey.shade600)),
                InkWell(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "OTP Sending",
                        textColor: Colors.white,
                        backgroundColor: Colors.green);
                    _onVerifyCode();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("RESEND CODE",
                          style: TextStyle(
                              fontSize: 15,
                              color: cnst.appprimarycolors[500],
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
