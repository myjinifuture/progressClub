import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:progressclubsurat_new/Component/TestimonialComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';

class MemberDetails extends StatefulWidget {
  @override
  _MemberDetailsState createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtDOB = new TextEditingController();
  TextEditingController edtAge = new TextEditingController();
  TextEditingController edtGender = new TextEditingController();
  TextEditingController edtAnniversary = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();

  //business info
  TextEditingController edtCmpName = new TextEditingController();
  TextEditingController edtBusinessAbout = new TextEditingController();
  TextEditingController edtBusinessAddress = new TextEditingController();
  TextEditingController edtkeywords = new TextEditingController();
  TextEditingController edtWebsite = new TextEditingController(); //vinchu
  TextEditingController edtEmail = new TextEditingController(); //vinchu

  //business info
  TextEditingController edtTestimonial = new TextEditingController();
  TextEditingController edtAchievement = new TextEditingController();
  TextEditingController edtBusinessCategory = new TextEditingController();
  TextEditingController edtExperienceOfWork = new TextEditingController();
  TextEditingController edtAskForPeople = new TextEditingController();
  TextEditingController edtIntroducer = new TextEditingController();

  //loading var
  bool isLoading = true;
  bool isPersonalLoading = false;
  bool isBusinessLoading = false;
  bool isMoreInfoLoading = false;
  List list = new List();
  List testimoniallist = new List();
  bool isEditable = false;
  bool isBusinessEditable = false;
  bool isMoreEditable = false;

  int memberId = 0;
  String memberImg = "";

  String dob = "", anniversary = "";

  ProgressDialog pr;

  String ViewMemberId = "", MemberId = "", ProfessionName = "";

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    getLocalData();
    super.initState();
    getMemberDetailsFromServer();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ViewMember = prefs.getString(Session.memId);
    String Member = prefs.getString(Session.MemberId);
    setState(() {
      ViewMemberId = ViewMember;
      MemberId = Member;
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

  showHHMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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
      String MemberId = prefs.getString(Session.memId);
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
              getTestimonialDataFromServer();
              setData(list);
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
      showMsg("No Internet Connection.");
    }
  }

  getTestimonialDataFromServer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.memId);
      //String type = prefs.getString(Session.memType);

      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetTestimonial(MemberId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              testimoniallist = data;
              //setData(list);
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

      /* edtDOB.text =
          list[0]["DateOfBirth"] == "" || list[0]["DateOfBirth"] == null
              ? ""
              : list[0]["DateOfBirth"].toString().substring(0, 10);*/

      edtDOB.text = list[0]["DateOfBirth"] == "" ||
              list[0]["DateOfBirth"] == null
          ? ""
          : "${list[0]["DateOfBirth"].substring(8, 10)}-${(list[0]["DateOfBirth"].substring(5, 7)).toString()}-${list[0]["DateOfBirth"].substring(0, 4)}";
      //: list[0]["DateOfBirth"].toString().substring(0, 10);

      edtGender.text = list[0]["Gender"];
      edtAge.text = list[0]["Age"].toString();

      /*edtAnniversary.text =
          list[0]["Anniversery"] == "" || list[0]["Anniversery"] == null
              ? ""
              : list[0]["Anniversery"].toString();*/

      // var dobAy;
      // if (list[0]["Anniversery"] != "" || list[0]["Anniversery"] != null) {
      //   dobAy = list[0]["Anniversery"].toString().split("-");
      // }
      // edtAnniversary.text =
      //     list[0]["Anniversery"] == "" || list[0]["Anniversery"] == null
      //         ? ""
      //         : "${dobAy[2]}-${dobAy[1].toString()}-${dobAy[0]}";

      edtAddress.text = list[0]["ResidenceAddress"];

      //Business Info
      edtCmpName.text = list[0]["CompanyName"];
      edtBusinessAddress.text = list[0]["OfficeAddress"];
      edtBusinessAbout.text = list[0]["BussinessAbout"];
      edtkeywords.text = list[0]["Keyword"];
      edtWebsite.text = "";
      edtEmail.text = "";

      //Business Info
      edtTestimonial.text = list[0]["Testimonial"];
      edtAchievement.text = list[0]["Achivement"];
      edtExperienceOfWork.text = list[0]["ExpOfWork"];
      edtAskForPeople.text = list[0]["AskForPeople"];
      edtIntroducer.text = list[0]["Introducer"];

      edtBusinessCategory.text =
          list[0]["Profession"] == "" || list[0]["Profession"] == null
              ? ""
              : list[0]["Profession"].toString();

      var dobAy;
      if (list[0]["Anniversery"] != "" || list[0]["Anniversery"] != null) {
        dobAy = list[0]["Anniversery"].toString().split("-");
      }
      edtAnniversary.text =
          list[0]["Anniversery"] == "" || list[0]["Anniversery"] == null
              ? ""
              : "${dobAy[2]}-${dobAy[1].toString()}-${dobAy[0]}";

      isLoading = false;
    });
  }

  //send Personal Info to server
  sendPersonalInfo() async {
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
          'DateOfBirth': edtDOB.text,
          'Age': edtAge.text,
          'Gender': edtGender.text,
          'Anniversery': edtAnniversary.text,
          'ResidenceAddress': edtAddress.text,
        };

        Services.sendMemberDetails(data).then((data) async {
          setState(() {
            isPersonalLoading = false;
          });
          if (data.Data != "0" && data != "") {
            //signUpDone("Assignment Task Update Successfully.");
            await prefs.setString(Session.Name, edtName.text);
            await prefs.setString(Session.CompanyName, edtCmpName.text);
            showHHMsg("Data Updated Successfully");
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
  }

  //send Business Info to server
  sendBusinessInfo() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isBusinessLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String memberId = prefs.getString(Session.MemberId);
        var now = new DateTime.now();

        var data = {
          'Id': memberId,
          'CompanyName': edtCmpName.text,
          'BussinessAbout': edtBusinessAbout.text,
          'OfficeAddress': edtBusinessAddress.text,
        };

        Services.sendBusinessMemberDetails(data).then((data) async {
          setState(() {
            isBusinessLoading = false;
          });
          if (data.Data != "0" && data != "") {
            //signUpDone("Assignment Task Update Successfully.");
            await prefs.setString(Session.Name, edtName.text);
            await prefs.setString(Session.CompanyName, edtCmpName.text);
            showHHMsg("Data Updated Successfully");
          } else {
            setState(() {
              isBusinessLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isBusinessLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        setState(() {
          isBusinessLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  //send Business Info to server
  sendMoreInfoInfo() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isMoreInfoLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String memberId = prefs.getString(Session.MemberId);
        var now = new DateTime.now();

        var data = {
          'Id': memberId,
          'Testimonial': edtTestimonial.text,
          'Achivement': edtAchievement.text,
          'ExpOfWork': edtExperienceOfWork.text.toString(),
          'AskForPeople': edtAskForPeople.text,
          'Introducer': edtIntroducer.text,
        };

        Services.sendMoreInfoMemberDetails(data).then((data) async {
          setState(() {
            isMoreInfoLoading = false;
          });
          if (data.Data != "0" && data != "") {
            //signUpDone("Assignment Task Update Successfully.");
            await prefs.setString(Session.Name, edtName.text);
            await prefs.setString(Session.CompanyName, edtCmpName.text);
            showHHMsg("Data Updated Successfully");
          } else {
            setState(() {
              isMoreInfoLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isMoreInfoLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        setState(() {
          isMoreInfoLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  /*_launchURL(String mobileNo) async {
    var url = 'tel:${mobileNo}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

  showEventDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(list[0]["Id"], (action) {
              if (action == "listref") {
                //get List Code
                getTestimonialDataFromServer();
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: Colors.white,
        buttonColor: Colors.deepPurple,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Personal',
                  ),
                ),
                Tab(
                  child: Text('Business'),
                ),
                Tab(
                  child: Text('More Info'),
                ),
              ],
            ),
            title: Text(
              'Member Detail',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            actions: <Widget>[
              ViewMemberId == MemberId
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        //scan();
                        showEventDialog();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              width: 90,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 3, right: 3, top: 2, bottom: 2),
                                child: Text(
                                  "Give\nTestimonial",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ))),
                    ),
            ],
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
          body: TabBarView(
            children: [
              Container(
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
                                          AvatarGlow(
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
                                                backgroundColor:
                                                    Colors.grey[100],
                                                child: ClipOval(
                                                  child: memberImg == "" &&
                                                          memberImg == "null"
                                                      ? Image.asset(
                                                          'images/icon_user.png',
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : FadeInImage
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
                                                        ),
                                                ),
                                                radius: 50.0,
                                              ),
                                            ),
                                          ),
                                          Card(
                                            margin: EdgeInsets.all(10),
                                            elevation: 3,
                                            child: Container(
                                              //padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 20,
                                                    bottom: 20),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .account_circle,
                                                                color: cnst
                                                                    .appPrimaryMaterialColor,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  'Personal Info',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          19,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                    ),
                                                    TextFormField(
                                                      controller: edtName,
                                                      scrollPadding:
                                                          EdgeInsets.all(0),
                                                      decoration: InputDecoration(
                                                          labelText: "Name:",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText: "Name"),
                                                      enabled: isEditable,
                                                      minLines: 1,
                                                      maxLines: 4,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          child: TextFormField(
                                                            controller: edtDOB,
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "Birth Date:",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                hintText:
                                                                    "Birth Date"),
                                                            enabled: false,
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                          //height: 40,
                                                          width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              90),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          //color: Colors.black,
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2) -
                                                              30,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              TextFormField(
                                                                controller:
                                                                    edtGender,
                                                                scrollPadding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                decoration: InputDecoration(
                                                                    labelText:
                                                                        "Gender:",
                                                                    labelStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                                    hintText:
                                                                        "Gender"),
                                                                enabled:
                                                                    isEditable,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .multiline,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          //color: Colors.black,
                                                          width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2) -
                                                              25,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              TextFormField(
                                                                controller:
                                                                    edtAge,
                                                                scrollPadding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                decoration: InputDecoration(
                                                                    labelText:
                                                                        "Age:",
                                                                    labelStyle: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                                    hintText:
                                                                        "Age"),
                                                                enabled:
                                                                    isEditable,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .phone,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          child: TextFormField(
                                                            controller:
                                                                edtAnniversary,
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "Anniversary:",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                hintText:
                                                                    "Anniversary"),
                                                            enabled: false,
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                          //height: 40,
                                                          width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              90),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        ),
                                                      ],
                                                    ),
                                                    TextFormField(
                                                      controller: edtAddress,
                                                      scrollPadding:
                                                          EdgeInsets.all(0),
                                                      decoration: InputDecoration(
                                                          labelText: "Address",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText: "Address"),
                                                      // enabled: isEditable,
                                                      minLines: 1,
                                                      maxLines: 4,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
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
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? LoadinComponent()
                    : SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                //Make Design
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Card(
                                        margin: EdgeInsets.all(10),
                                        elevation: 3,
                                        child: Container(
                                          //padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 20,
                                                bottom: 20),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.business,
                                                            color: cnst
                                                                .appPrimaryMaterialColor,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              'Business Info',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                                TextFormField(
                                                  controller: edtCmpName,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText: "Company",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText: "Company"),
                                                  enabled: isBusinessEditable,
                                                  minLines: 1,
                                                  maxLines: 4,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                TextFormField(
                                                  controller:
                                                      edtBusinessCategory,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Business Category:",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText:
                                                          "Business Category"),
                                                  enabled: isBusinessEditable,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                TextFormField(
                                                  controller:
                                                      edtBusinessAddress,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText: "Address",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText: "Address"),
                                                  enabled: isBusinessEditable,
                                                  minLines: 1,
                                                  maxLines: 4,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                TextFormField(
                                                  controller: edtBusinessAbout,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "About Business",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText:
                                                          "About Business"),
                                                  enabled: isBusinessEditable,
                                                  minLines: 1,
                                                  maxLines: 4,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                TextFormField(
                                                  controller: edtkeywords,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText: "Keywords",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText: "Keywords"),
                                                  enabled: isBusinessEditable,
                                                  minLines: 1,
                                                  maxLines: 6,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                TextFormField(
                                                  //vinchu
                                                  controller: edtWebsite,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText: "Website",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText: "Website"),
                                                  enabled: isBusinessEditable,
                                                  minLines: 1,
                                                  maxLines: 3,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                TextFormField(
                                                  //vinchu
                                                  controller: edtEmail,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText: "Email",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText: "Email"),
                                                  enabled: isBusinessEditable,
                                                  minLines: 1,
                                                  maxLines: 3,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
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
                              child: isBusinessLoading
                                  ? LoadinComponent()
                                  : Container(),
                            )
                          ],
                        ),
                      ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? LoadinComponent()
                    : SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: <Widget>[
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
                                                        Icons.info,
                                                        color: cnst
                                                            .appPrimaryMaterialColor,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          'More Info',
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
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                            ),
                                            /*TextFormField(
                                              controller: edtTestimonial,
                                              scrollPadding:
                                                  EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Testimonial",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Testimonial"),
                                              enabled: isMoreEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),*/
                                            TextFormField(
                                              controller: edtAchievement,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Achievement",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Achievement"),
                                              enabled: isMoreEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            TextFormField(
                                              controller: edtExperienceOfWork,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Experience Of Work",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText:
                                                      "Experience Of Work"),
                                              enabled: isMoreEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            TextFormField(
                                              controller: edtAskForPeople,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Ask For People",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Ask For People"),
                                              enabled: isMoreEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            TextFormField(
                                              controller: edtIntroducer,
                                              scrollPadding: EdgeInsets.all(0),
                                              decoration: InputDecoration(
                                                  labelText: "Introducer",
                                                  labelStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  hintText: "Introducer"),
                                              enabled: isMoreEditable,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star_half,
                                          size: 15,
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                        Text(
                                          "Testimonial",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 170,
                                    child: testimoniallist.length > 0
                                        ? ListView.builder(
                                            padding: EdgeInsets.only(top: 5),
                                            itemCount: testimoniallist.length,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return TestimonialComponent(
                                                  testimoniallist[index],
                                                  (action) {
                                                if (action == "show") {
                                                  pr.show();
                                                } else {
                                                  pr.hide();
                                                }
                                              });
                                            })
                                        : Center(
                                            child: Container(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.6),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              child: Text(
                                                  "No Testimonial Available",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: isMoreInfoLoading
                                  ? LoadinComponent()
                                  : Container(),
                            )
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  var id;
  final Function onChange;

  MyDialog(this.id, this.onChange);

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  double rating = 0.0;
  TextEditingController edtDesc = new TextEditingController();
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);
  bool isLoading = false;

  ProgressDialog pr;

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  sendTestimonial() async {
    if (edtDesc.text != "" && rating != 0.0) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String MemberId = prefs.getString(Session.MemberId);

          pr.show();
          var data = {
            'Id': "0",
            'MemberId': widget.id,
            'AddByMemberId': MemberId,
            'Rating': rating.toStringAsFixed(2).toString(),
            'Description': edtDesc.text.trim(),
            'Date': date
          };
          Services.sendTestimonial(data).then((data) async {
            pr.hide();
            if (data.Data != "0") {
              Navigator.pop(context);
              showMsg("Testimonial Send Successfully");
              widget.onChange("listref");
            } else {
              pr.hide();
              showMsg(data.Message);
            }
          }, onError: (e) {
            pr.hide();
            showMsg("Try Again.");
          });
        } else {
          pr.hide();
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Filled All values.");
    }
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
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      //this right here
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Give Your Testimonial",
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    hintText: "Describe Your Experience here..",
                    hintStyle: TextStyle(fontSize: 13)),
                maxLines: 4,
                minLines: 2,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 10,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 10,
                          onPressed: () {
                            sendTestimonial();
                          },
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
