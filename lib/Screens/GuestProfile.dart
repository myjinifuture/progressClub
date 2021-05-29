import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CardShareComponent.dart';

class GuestProfile extends StatefulWidget {
  @override
  _GuestProfileState createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  //loading var
  bool isLoading = false;
  List list = new List();
  bool isEditable = false;
  bool isPersonalLoading = false;

  TextEditingController edtName = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtCmpName = new TextEditingController();
  int memberId = 0;
  String memberImg = "";

  File _imageOffer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemberDetailsFromServer();
  }

  showHHMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  getMemberDetailsFromServer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);
      //String type = prefs.getString(Session.memType);

      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetMemberProfile(MemberId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list = data;
              setData(list);
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

  setData(List list) async {
    setState(() {
      //personal Info
      memberImg = list[0]["Image"].toString();
      memberId = list[0]["Id"];
      edtName.text = list[0]["Name"];
      edtEmail.text = list[0]["Email"];
      //Business Info
      edtCmpName.text = list[0]["CompanyName"];
      isLoading = false;
    });
  }

  //send Personal Info to server
  sendPersonalInfo() async {
    if (edtName.text != "" && edtCmpName.text != "" && edtEmail.text != "") {
      try {
        //check Internet Connection
        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isPersonalLoading = true;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String memberId = prefs.getString(Session.MemberId);
          var now = new DateTime.now();

          var data = {
            'Id': memberId,
            'Name': edtName.text,
            'Company': edtCmpName.text,
            'Email': edtEmail.text,
          };

          Services.sendGuestDetails(data).then((data) async {
            setState(() {
              isPersonalLoading = false;
            });
            if (data.Data != "0" && data != "") {
              //signUpDone("Assignment Task Update Successfully.");
              await prefs.setString(Session.Name, edtName.text);
              await prefs.setString(Session.CompanyName, edtCmpName.text);
              await prefs.setString(Session.Email, edtEmail.text);
              showHHMsg("Data Updated Successfully");
              setState(() {
                isEditable = !isEditable;
              });
            } else {
              setState(() {
                isPersonalLoading = false;
              });
            }
          }, onError: (e) {
            setState(() {
              isPersonalLoading = false;
            });
            showMsg("Try Again.");
          });
        } else {
          setState(() {
            isPersonalLoading = false;
          });
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Enter Details.");
    }
  }

  List CardIddata = [];
  List Updatedata = [];
  var cardid = "";

  getCardId() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.GetCardIdLogin(
            "login", prefs.getString(cnst.Session.Mobile));
        res.then((data) async {
          print(data);
          if (data != null && data.length > 0) {
            setState(() {
              CardIddata = data;
              cardid = CardIddata[0]["cardid"];
              isLoading = false;
            });
            if (cardid == "" || cardid == null) {
              print("if part");
              SaveOffer();
              checkLogin();
            } else {
              print("else part");
              checkLogin();
            }
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  UpdateCardId(String cardid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.UpdateCardId("updatemember", cardid, "2944");
        res.then((data) async {
          print(data);
          if (data != null && data.length > 0) {
            setState(() {
              Updatedata = data;
              print("Updatedata");
              print(Updatedata);
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  File _image;
  TextEditingController txtRegCode = new TextEditingController();
  List data;
  String ShareMsg = "";
  String Name, MemberType;

  checkLogin() async {
    if (CardIddata[0]["mobile"] != "" && CardIddata[0]["mobile"] != null) {
      if (CardIddata[0]["mobile"].length == 10) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            //pr.show();
            Services.MemberLogin1(CardIddata[0]["mobile"]).then((data) async {
              if (data != null || data == []) {
                Name = prefs.getString(Session.Name);
                MemberType = prefs.getString(Session.Type);
                cardid = data[0].Id;
                ShareMsg = data[0].ShareMsg;
                print("cardid latest");
                print(cardid);
                print("ShareMsg");
                print(ShareMsg);
                UpdateCardId(cardid);
              }
            }, onError: (e) {
              //pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            //pr.hide();
            showMsg("Something wen wrong");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please enter Valid Mobile Number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  String ExpDate = "";

  SaveOffer() async {
    if (CardIddata[0]["person"] != '' &&
        CardIddata[0]["mobile"] != '' &&
        CardIddata[0]["companyname"] != '') {
      String img = cnst.Session.SignImage;
      String referCode = CardIddata[0]["person"].substring(0, 3).toUpperCase();

      if (_image != null) {
        List<int> imageBytes = await _image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
      }

      var data = {
        'type': 'signup',
        'name': CardIddata[0]["person"],
        'mobile': CardIddata[0]["mobile"],
        'imagecode': "",
        'company': CardIddata[0]["companyname"],
        'email': CardIddata[0]["officeemail"],
        'myreferCode': referCode,
        'regreferCode': txtRegCode.text,
      };
      Future res = Services.MemberSignUp(data);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  bool checkValidity() {
    if (ExpDate.trim() != null && ExpDate.trim() != "") {
      final f = new DateFormat('dd MMM yyyy');
      DateTime validTillDate = f.parse(ExpDate);
      print(validTillDate);
      DateTime currentDate = new DateTime.now();
      print(currentDate);
      if (validTillDate.isAfter(currentDate)) {
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  bool IsActivePayment = false;
  int ontap = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'My Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? LoadinComponent()
            : list.length > 0 && list != null
                ? SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            //Make Design
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _profileImagePopup(context);
                                        },
                                        child: AvatarGlow(
                                          startDelay:
                                              Duration(milliseconds: 1000),
                                          glowColor:
                                              cnst.appPrimaryMaterialColor,
                                          endRadius: 80.0,
                                          duration:
                                              Duration(milliseconds: 2000),
                                          repeat: true,
                                          showTwoGlows: true,
                                          repeatPauseDuration:
                                              Duration(milliseconds: 100),
                                          child: Material(
                                            elevation: 8.0,
                                            shape: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[100],
                                              child: ClipOval(
                                                child: memberImg == "" &&
                                                        memberImg == "null"
                                                    ? Image.asset(
                                                        'images/icon_user.png',
                                                        height: 120,
                                                        width: 120,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : _imageOffer == null
                                                        ? FadeInImage
                                                            .assetNetwork(
                                                            placeholder:
                                                                'images/icon_user.png',
                                                            image: memberImg
                                                                    .contains(
                                                                        "http")
                                                                ? memberImg
                                                                : "http://pmc.studyfield.com/" +
                                                                    memberImg,
                                                            height: 120,
                                                            width: 120,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.file(
                                                            File(_imageOffer
                                                                .path),
                                                            height: 120,
                                                            width: 120,
                                                            fit: BoxFit.fill,
                                                          ),
                                              ),
                                              radius: 50.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _profileImagePopup(context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: 100, top: 100),
                                            child: Image.asset(
                                              'images/plus.png',
                                              width: 25,
                                              height: 25,
                                            )),
                                      )
                                    ],
                                  ),
                                  Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 3,
                                    child: Container(
                                      //padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 20, bottom: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.account_circle,
                                                        color: cnst
                                                            .appPrimaryMaterialColor,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          'Personal Info',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (isEditable) {
                                                          sendPersonalInfo();
                                                        } else {
                                                          isEditable = true;
                                                        }
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.edit,
                                                          size: 20,
                                                          color: cnst
                                                              .appPrimaryMaterialColor,
                                                        ),
                                                        Text(
                                                          isEditable
                                                              ? "Update"
                                                              : 'Edit',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                            ),
                                            TextFormField(
                                              controller: edtName,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Name:",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Name"),
                                              enabled: isEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            TextFormField(
                                              controller: edtEmail,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Email",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Email"),
                                              enabled: isEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            TextFormField(
                                              controller: edtCmpName,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Company Name",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Company Name"),
                                              enabled: isEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: RaisedButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        elevation: 5,
                                                        textColor: Colors.white,
                                                        color:
                                                            Colors.deepPurple,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.share,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Share",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14)),
                                                            ),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          getCardId();
                                                          bool val =
                                                              checkValidity();
                                                          Navigator.of(context)
                                                              .push(
                                                            PageRouteBuilder(
                                                              opaque: false,
                                                              pageBuilder: (BuildContext
                                                                          context,
                                                                      _,
                                                                      __) =>
                                                                  CardShareComponent(
                                                                memberId:
                                                                    cardid,
                                                                memberName:
                                                                    Name,
                                                                isRegular: val,
                                                                memberType:
                                                                    MemberType,
                                                                shareMsg:
                                                                    ShareMsg,
                                                                IsActivePayment:
                                                                    IsActivePayment,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    30.0))),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: RaisedButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        elevation: 5,
                                                        textColor: Colors.white,
                                                        color:
                                                            Colors.deepPurple,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.preview,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Preview",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14)),
                                                            ),
                                                          ],
                                                        ),
                                                        onPressed: () async {
                                                          ontap += 1;
                                                          if (ontap == 1) {
                                                            getCardId();
                                                          }
                                                          String profileUrl = cnst
                                                              .profileUrl
                                                              .replaceAll(
                                                                  "#id",
                                                                  cardid == null
                                                                      ? memberId
                                                                      : cardid);
                                                          if (await canLaunch(
                                                              profileUrl)) {
                                                            await launch(
                                                                profileUrl);
                                                          } else {
                                                            throw 'Could not launch $profileUrl';
                                                          }
                                                        },
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    30.0))),
                                                  ),
                                                ],
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
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: isPersonalLoading
                              ? LoadinComponent()
                              : Container(),
                        )
                      ],
                    ),
                  )
                : NoDataComponent(),
      ),
    );
  }

  sendUserProfileImg() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        String filename = "";
        File compressedFile;

        if (_imageOffer != null) {
          var file = _imageOffer.path.split('/');
          filename = "user.png";

          if (file != null && file.length > 0)
            filename = file[file.length - 1].toString();

          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(_imageOffer.path);
          compressedFile = await FlutterNativeImage.compressImage(
              _imageOffer.path,
              quality: 80,
              targetWidth: 600,
              targetHeight:
                  (properties.height * 600 / properties.width).round());
        }

        /*FormData formData = new FormData.from(
          {
            "Id": memberId,
            "Image": _imageOffer != null
                ? new UploadFileInfo(compressedFile, filename.toString())
                : null
          },
        );*/
        FormData formData = new FormData.fromMap({
          "Id": memberId,
          "Image": _imageOffer != null
              ? await MultipartFile.fromFile(compressedFile.path,
                  filename: filename.toString())
              : null
        });
        Services.UploadMemberImage(formData).then((data) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (data.Data != "" && data.Data != "0" && data.Data != "") {
            await prefs.setString(Session.Photo, data.Data);
            showHHMsg("Profile Updated Successfully.");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _profileImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null)
                        setState(() {
                          _imageOffer = image;
                        });
                      Navigator.pop(context);
                      sendUserProfileImg();
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null)
                        setState(() {
                          _imageOffer = image;
                        });
                      Navigator.pop(context);
                      sendUserProfileImg();
                    }),
              ],
            ),
          );
        });
  }
}
