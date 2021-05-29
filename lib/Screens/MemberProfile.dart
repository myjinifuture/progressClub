import 'dart:io';
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/AttendanceComponents.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:progressclubsurat_new/Component/TestimonialComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'dart:developer';

class MemberProfile extends StatefulWidget {
  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtDOB = new TextEditingController();
  TextEditingController edtAge = new TextEditingController();
  TextEditingController edtGender = new TextEditingController();
  TextEditingController edtAnniversary = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtSpouseName = new TextEditingController();
  TextEditingController edtSpouseDob = new TextEditingController();
  TextEditingController edtNoOfChild = new TextEditingController();

  //business info
  TextEditingController edtCmpName = new TextEditingController();
  TextEditingController edtBusinessCategory = new TextEditingController();
  TextEditingController edtBusinessAbout = new TextEditingController();
  TextEditingController edtBusinessAddress = new TextEditingController();
  TextEditingController edtkeywords = new TextEditingController();
  TextEditingController edtWebsite = new TextEditingController(); //vinchu
  TextEditingController edtEmail = new TextEditingController(); //vinchu

  //business info
  TextEditingController edtTestimonial = new TextEditingController();
  TextEditingController edtAchievement = new TextEditingController();
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
  File _imageOffer;
  int memberId = 0;
  String memberImg = "", ProfessionId = "", ProfessionName = "";

  String selectGender = "Gender";

  double rating = 0.0;

  //get location
  //var location = new Location();

  Map<String, double> userLocation;

  String dob = "", spouseDob = "", anniversary = "";

  static List<BusinessCategoryClass> _businessCategory = [];

  BusinessCategoryClass _businessCategoryClass = new BusinessCategoryClass();

  ProgressDialog pr;

  List<ProfessionClass> _profession = new List();
  ProfessionClass __professionClass;

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
    getMemberDetailsFromServer();
    setState(() {
      _businessCategoryClass.businessId = '1';
      _businessCategoryClass.businessId = '1';
      _businessCategoryClass.businessId = 'IT';
      _businessCategory.add(_businessCategoryClass);
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
              setData(list);
              getMemberWebsite();
              getTestimonialDataFromServer();
              getProffesionFromServer();
            });
            print('==================list${list}');
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
      setState(() {
        isLoading = false;
      });
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

  getProffesionFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetProffesion();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              _profession = data;
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
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  setData(List list) async {
    setState(() {
      //personal Info
      memberImg = list[0]["Image"].toString();
      memberId = list[0]["Id"];
      edtName.text = list[0]["Name"];
      edtDOB.text = list[0]["DateOfBirth"] == "" ||
              list[0]["DateOfBirth"] == null
          ? ""
          : "${list[0]["DateOfBirth"].substring(8, 10)}-${(list[0]["DateOfBirth"].substring(5, 7)).toString()}-${list[0]["DateOfBirth"].substring(0, 4)}";
      //: list[0]["DateOfBirth"].toString().substring(0, 10);

      if (list[0]["DateOfBirth"] != "" || list[0]["DateOfBirth"] != null) {
        dob = list[0]["DateOfBirth"].toString().substring(0, 10);
      }

      edtGender.text = list[0]["Gender"].toString();

      if (list[0]["Gender"].toString().toLowerCase() == "male" ||
          list[0]["Gender"].toString().toLowerCase() == "female") {
        selectGender = list[0]["Gender"];
      } else
        edtGender.text = "";

      if (list[0]["Age"] != null) {
        edtAge.text = list[0]["Age"].toString();
      } else
        edtAge.text = "";
      // var dobAy;
      // if (list[0]["Anniversery"] != "" || list[0]["Anniversery"] != null) {
      //   dobAy = list[0]["Anniversery"].toString().split("-");
      // }
      //
      // edtAnniversary.text =
      //     list[0]["Anniversery"] == "" || list[0]["Anniversery"] == null
      //         ? ""
      //         : "${dobAy[2]}-${dobAy[1].toString()}-${dobAy[0]}";
      // //: list[0]["Anniversery"].toString();
      // if (list[0]["Anniversery"] != "" || list[0]["Anniversery"] != null) {
      //   anniversary = list[0]["Anniversery"].toString();
      // }

      edtAddress.text = list[0]["ResidenceAddress"];
      //Business Info
      edtCmpName.text = list[0]["CompanyName"];
      edtBusinessAddress.text = list[0]["OfficeAddress"];
      // edtBusinessAbout.text = list[0]["BussinessAbout"];
      edtkeywords.text = list[0]["Keyword"];
      edtEmail.text = list[0]["Email"];

      //Business Info
      edtTestimonial.text = list[0]["Testimonial"];
      edtAchievement.text = list[0]["Achivement"];
      edtExperienceOfWork.text = list[0]["ExpOfWork"];
      edtAskForPeople.text = list[0]["AskForPeople"];
      edtIntroducer.text = list[0]["Introducer"];

      var dobAy;
      if (list[0]["Anniversery"] != "" || list[0]["Anniversery"] != null) {
        dobAy = list[0]["Anniversery"].toString().split("-");
      }

      edtAnniversary.text =
          list[0]["Anniversery"] == "" || list[0]["Anniversery"] == null
              ? ""
              : "${dobAy[2]}-${dobAy[1].toString()}-${dobAy[0]}";
      //: list[0]["Anniversery"].toString();
      if (list[0]["Anniversery"] != "" || list[0]["Anniversery"] != null) {
        anniversary = list[0]["Anniversery"].toString();
      }

      isLoading = false;

      ProfessionId =
          list[0]["ProffesionId"] == "" || list[0]["ProffesionId"] == null
              ? ""
              : list[0]["ProffesionId"].toString();
      ProfessionName =
          list[0]["Profession"] == "" || list[0]["Profession"] == null
              ? ""
              : list[0]["Profession"].toString();

      edtBusinessCategory.text =
          list[0]["Profession"] == "" || list[0]["Profession"] == null
              ? ""
              : list[0]["Profession"].toString();

      edtSpouseName.text = list[0]["SpouseName"];
      edtNoOfChild.text = list[0]["NoOfChildren"].toString();

      edtSpouseDob.text = list[0]["WDOB"] == "" || list[0]["WDOB"] == null
          ? ""
          : "${list[0]["WDOB"].substring(8, 10)}-${(list[0]["WDOB"].substring(5, 7)).toString()}-${list[0]["WDOB"].substring(0, 4)}";
      //: list[0]["WDOB"].toString().substring(0, 10);

      if (list[0]["WDOB"] != "" || list[0]["WDOB"] != null) {
        spouseDob = list[0]["WDOB"].toString().substring(0, 10);
      }

      /*var spousedob;
      if (list[0]["WDOB"] != "" || list[0]["WDOB"] != null) {
        spousedob = list[0]["WDOB"].toString().split("-");
      }

      edtSpouseDob.text = list[0]["WDOB"] == "" || list[0]["WDOB"] == null
          ? ""
          : "${spousedob[2]}-${spousedob[1].toString()}-${spousedob[0]}";
      if (list[0]["WDOB"] != "" || list[0]["WDOB"] != null) {
        spouseDob = list[0]["WDOB"].toString().substring(0, 10);
      }*/
    });
  }

  getMemberWebsite() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String mobileNo;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        mobileNo = prefs.getString(Session.Mobile);
        Future res = Services.MemberLogin(mobileNo);
        res.then((data) async {
          if (data != null && data.length > 0) {
            edtWebsite.text = data["website"].toString();
            edtBusinessAbout.text = data["About"].toString();
          } else {}
        }, onError: (e) {
          showMsg(
              "Something went wrong to fetch website details. Please try agian.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (ex) {
      showMsg(ex.message);
    }
  }

  //send Personal Info to server
  sendPersonalInfo() async {
    if (edtName.text != "") {
      if (edtDOB.text != "") {
        if (selectGender != "Gender") {
          if (edtAddress.text != "") {
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
                  'DateOfBirth': dob,
                  'Age': edtAge.text,
                  'Gender': selectGender,
                  'Anniversery': anniversary,
                  'ResidenceAddress': edtAddress.text,
                  'SpouseName': edtSpouseName.text,
                  'WDOB': spouseDob,
                  'NoOfChildren': edtNoOfChild.text,
                };
                print(data.toString());
                Services.sendMemberDetails(data).then((data) async {
                  setState(() {
                    isPersonalLoading = false;
                  });
                  if (data.Data != "0" && data != "") {
                    //signUpDone("Assignment Task Update Successfully.");
                    await prefs.setString(Session.Name, edtName.text);
                    await prefs.setString(Session.CompanyName, edtCmpName.text);
                    setState(() {
                      isEditable = !isEditable;
                      edtGender.text = selectGender;
                    });
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
          } else {
            showMsg("Please Enter Address");
          }
        } else {
          showMsg("Please Select Gender.");
        }
      } else {
        showMsg("Please Select Birth Date");
      }
    } else {
      showMsg("Please Enter Name.");
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
        var data = {
          'Id': memberId,
          'CompanyName': edtCmpName.text,
          'ProffesionId':
              __professionClass == null ? "" : __professionClass.Id.toString(),
          'BussinessxAbout': edtBusinessAbout.text,
          'OfficeAddress': edtBusinessAddress.text,
          'Keyword': edtkeywords.text,
          // 'Website': edtWebsite.text,
          // 'Email': edtEmail.text,
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
            setState(() {
              isBusinessEditable = !isBusinessEditable;
              edtBusinessCategory.text =
                  __professionClass == null ? "" : __professionClass.Profession;
            });
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

  //=====================by yash

  sendBusinessWebAndEmail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isBusinessLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);
        String deviceType = '';
        String about = edtBusinessAbout.text;
        String website = edtWebsite.text;

        String email = edtEmail.text;
        if (Platform.isAndroid == true) {
          setState(() {
            deviceType = 'Android';
          });
        } else {
          setState(() {
            deviceType = 'Apple';
          });
        }
        Future res = Services.sendBusinessWebAndEmail(
            website, email, memberId, about, deviceType);
        print('======ss========ss======${res}');
        res.then((data) async {
          setState(() {
            isBusinessLoading = false;
          });
          print("=======ss=====${data}");
          if (data == "1") {
            // showHHMsg("Data Updated Successfully");
          } else {
            setState(() {
              isBusinessLoading = false;
            });
            showMsg("No Internet Connection.");
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

  //send More Info to server
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
          //'Testimonial': edtTestimonial.text,
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
            setState(() {
              isMoreEditable = !isMoreEditable;
            });
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

  setAge() async {
    var qrtext = edtDOB.text.toString().split("-");
    String year = qrtext[2].toString();
    String month = qrtext[1].toString();
    String day = qrtext[0].toString();
    if (qrtext[1].length == 1) {
      month = "0" + month;
    }
    if (day.length == 1) {
      day = "0" + day;
    }
    DateTime dob = DateTime.parse('${year}-$month-$day');
    Duration dur = DateTime.now().difference(dob);
    String differenceInYears = (dur.inDays / 365).floor().toString();
    print(differenceInYears + ' years');
    setState(() {
      edtAge.text = differenceInYears.toString();
    });
  }

  getUserLocation() async {
    //call this async method from whereever you need
    try {
      setState(() {
        isLoading = true;
      });
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((val) {
        if (val != null) {
          final coordinates = new Coordinates(val.latitude, val.longitude);
          Geocoder.local
              .findAddressesFromCoordinates(coordinates)
              .then((addresses) {
            if (addresses != null) {
              var first = addresses.first;
              print("Address : ${first.featureName} : ${first.addressLine}");

              /*txtAddress.text =
                       first
                           .addressLine
                           .toString();*/
              setState(() {
                edtAddress.text = first.addressLine.toString();
              });
            }
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  getUserLocationSecond() async {
    //call this async method from whereever you need
    try {
      setState(() {
        isLoading = true;
      });
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((val) {
        if (val != null) {
          final coordinates = new Coordinates(val.latitude, val.longitude);
          Geocoder.local
              .findAddressesFromCoordinates(coordinates)
              .then((addresses) {
            if (addresses != null) {
              var first = addresses.first;
              print("Address : ${first.featureName} : ${first.addressLine}");

              /*txtAddress.text =
                       first
                           .addressLine
                           .toString();*/
              setState(() {
                edtBusinessAddress.text = first.addressLine.toString();
              });
            }
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      setState(() {
        isLoading = false;
      });
    }
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
              isScrollable: true,
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
                /*Tab(
                  child: Text('Attendance'),
                ),*/
              ],
            ),
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
                                          Stack(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  _profileImagePopup(context);
                                                },
                                                child: AvatarGlow(
                                                  startDelay: Duration(
                                                      milliseconds: 1000),
                                                  glowColor: cnst
                                                      .appPrimaryMaterialColor,
                                                  endRadius: 80.0,
                                                  duration: Duration(
                                                      milliseconds: 2000),
                                                  repeat: true,
                                                  showTwoGlows: true,
                                                  repeatPauseDuration: Duration(
                                                      milliseconds: 100),
                                                  child: Material(
                                                    elevation: 8.0,
                                                    shape: CircleBorder(),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey[100],
                                                      child: ClipOval(
                                                        child: memberImg ==
                                                                    "" &&
                                                                memberImg ==
                                                                    "null"
                                                            ? Image.asset(
                                                                'images/icon_user.png',
                                                                height: 120,
                                                                width: 120,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : _imageOffer ==
                                                                    null
                                                                ? FadeInImage
                                                                    .assetNetwork(
                                                                    placeholder:
                                                                        'images/icon_user.png',
                                                                    image: memberImg.contains(
                                                                            "http")
                                                                        ? memberImg
                                                                        : "http://pmc.studyfield.com/" +
                                                                            memberImg,
                                                                    height: 120,
                                                                    width: 120,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : Image.file(
                                                                    File(_imageOffer
                                                                        .path),
                                                                    height: 120,
                                                                    width: 120,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                      ),
                                                      radius: 50.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 100, top: 100),
                                                  child: Image.asset(
                                                    'images/plus.png',
                                                    width: 25,
                                                    height: 25,
                                                  ))
                                            ],
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
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (isEditable) {
                                                                  sendPersonalInfo();
                                                                } else {
                                                                  isEditable =
                                                                      true;
                                                                }
                                                              });
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
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
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black),
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
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (isEditable) {
                                                                DatePicker
                                                                    .showDatePicker(
                                                                  context,
                                                                  dateFormat:
                                                                      'yyyy-MMMM-dd',
                                                                  initialDateTime:
                                                                      DateTime
                                                                          .now(),
                                                                  locale:
                                                                      DateTimePickerLocale
                                                                          .en_us,
                                                                  onCancel: () =>
                                                                      print(
                                                                          'onCancel'),
                                                                  onChange: (dateTime,
                                                                      List<int>
                                                                          index) {},
                                                                  onConfirm: (dateTime,
                                                                      List<int>
                                                                          index) {
                                                                    print(
                                                                        "d: ${dateTime}");
                                                                    var date = dateTime
                                                                        .toString()
                                                                        .split(
                                                                            " ");
                                                                    var Date = date[
                                                                            0]
                                                                        .split(
                                                                            "-");
                                                                    dob = Date[0]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[1]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[2]
                                                                            .toString();
                                                                    edtDOB
                                                                        .text = Date[2]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[1]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[0]
                                                                            .toString();
                                                                    setAge();
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child: Icon(Icons
                                                                .calendar_today)),
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
                                                                  1.8) -
                                                              30,
                                                          child: !isEditable
                                                              ? TextFormField(
                                                                  controller:
                                                                      edtGender,
                                                                  scrollPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          "Gender:",
                                                                      labelStyle: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
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
                                                                )
                                                              : DropdownButton(
                                                                  hint: Text(
                                                                      'Gender'),
                                                                  // Not necessary for Option 1
                                                                  value:
                                                                      selectGender,
                                                                  onChanged:
                                                                      (newValue) {
                                                                    setState(
                                                                        () {
                                                                      selectGender =
                                                                          newValue;
                                                                    });
                                                                  },
                                                                  items: <
                                                                      String>[
                                                                    'Gender',
                                                                    'Male',
                                                                    'Female'
                                                                  ].map<
                                                                      DropdownMenuItem<
                                                                          String>>((String
                                                                      value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value),
                                                                    );
                                                                  }).toList(),
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
                                                                  2.3) -
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
                                                                enabled: false,
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
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (isEditable) {
                                                                DatePicker
                                                                    .showDatePicker(
                                                                  context,
                                                                  dateFormat:
                                                                      'yyyy-MMMM-dd',
                                                                  initialDateTime:
                                                                      DateTime
                                                                          .now(),
                                                                  locale:
                                                                      DateTimePickerLocale
                                                                          .en_us,
                                                                  onCancel: () =>
                                                                      print(
                                                                          'onCancel'),
                                                                  onChange: (dateTime,
                                                                      List<int>
                                                                          index) {},
                                                                  onConfirm: (dateTime,
                                                                      List<int>
                                                                          index) {
                                                                    print(
                                                                        "d: ${dateTime}");
                                                                    var date = dateTime
                                                                        .toString()
                                                                        .split(
                                                                            " ");
                                                                    var Date = date[
                                                                            0]
                                                                        .split(
                                                                            "-");
                                                                    anniversary = Date[0]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[1]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[2]
                                                                            .toString();
                                                                    edtAnniversary
                                                                        .text = Date[2]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[1]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[0]
                                                                            .toString();
                                                                  },
                                                                );
//                                                                  showTitleActions:
//                                                                      true,
//                                                                  locale: 'en',
//                                                                  minYear: DateTime
//                                                                              .now()
//                                                                          .year -
//                                                                      70,
//                                                                  maxYear: DateTime
//                                                                          .now()
//                                                                      .year,
//                                                                  initialYear:
//                                                                      DateTime.now()
//                                                                          .year,
//                                                                  initialMonth:
//                                                                      DateTime.now()
//                                                                          .month,
//                                                                  initialDate:
//                                                                      DateTime.now()
//                                                                          .day,
//                                                                  cancel: Text(
//                                                                      'cancel'),
//                                                                  confirm: Text(
//                                                                      'confirm'),
//                                                                  dateFormat:
//                                                                      'dd-mmm-yyyy',
//                                                                  onChanged: (year,
//                                                                      month,
//                                                                      date) {},
//                                                                  onConfirm:
//                                                                      (year,
//                                                                          month,
//                                                                          date) {
//                                                                    //date=date.toString().length==1?date.toString():date.toString();
//                                                                    String dd = date.toString().length ==
//                                                                            1
//                                                                        ? "0" +
//                                                                            date
//                                                                                .toString()
//                                                                        : date
//                                                                            .toString();
//                                                                    String mm = month.toString().length ==
//                                                                            1
//                                                                        ? "0" +
//                                                                            month
//                                                                                .toString()
//                                                                        : month
//                                                                            .toString();
//
//                                                                    anniversary = year
//                                                                            .toString() +
//                                                                        '-' +
//                                                                        mm.toString() +
//                                                                        '-' +
//                                                                        dd.toString();
//                                                                    edtAnniversary
//                                                                        .text = dd
//                                                                            .toString() +
//                                                                        '-' +
//                                                                        mm.toString() +
//                                                                        '-' +
//                                                                        year.toString();
//                                                                  },
//                                                                );
                                                              }
                                                            },
                                                            child: Icon(Icons
                                                                .calendar_today)),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          child: TextFormField(
                                                            controller:
                                                                edtAddress,
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "Home Address",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                hintText:
                                                                    "Home Address"),
                                                            enabled: isEditable,
                                                            minLines: 1,
                                                            maxLines: 4,
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
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
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (isEditable) {
                                                                //_getLocation();
                                                                getUserLocation();
                                                              }
                                                            },
                                                            child: Image.asset(
                                                                'images/google24.png')),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        ),
                                                      ],
                                                    ),
                                                    TextFormField(
                                                      controller: edtSpouseName,
                                                      scrollPadding:
                                                          EdgeInsets.all(0),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              "Spouse Name",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText:
                                                              "Spouse Name"),
                                                      enabled: isEditable,
                                                      minLines: 1,
                                                      maxLines: 2,
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
                                                            controller:
                                                                edtSpouseDob,
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "Spouse Birthdate",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                hintText:
                                                                    "Spouse Birthdate"),
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
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (isEditable) {
                                                                DatePicker
                                                                    .showDatePicker(
                                                                  context,
                                                                  dateFormat:
                                                                      'yyyy-MMMM-dd',
                                                                  initialDateTime:
                                                                      DateTime
                                                                          .now(),
                                                                  locale:
                                                                      DateTimePickerLocale
                                                                          .en_us,
                                                                  onCancel: () =>
                                                                      print(
                                                                          'onCancel'),
                                                                  onChange: (dateTime,
                                                                      List<int>
                                                                          index) {},
                                                                  onConfirm: (dateTime,
                                                                      List<int>
                                                                          index) {
                                                                    print(
                                                                        "d: ${dateTime}");
                                                                    var date = dateTime
                                                                        .toString()
                                                                        .split(
                                                                            " ");
                                                                    var Date = date[
                                                                            0]
                                                                        .split(
                                                                            "-");
                                                                    spouseDob = Date[0]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[1]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[2]
                                                                            .toString();
                                                                    edtSpouseDob
                                                                        .text = Date[2]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[1]
                                                                            .toString() +
                                                                        '-' +
                                                                        Date[0]
                                                                            .toString();
                                                                    setAge();
                                                                  },
                                                                );
//
//                                                                  showTitleActions:
//                                                                      true,
//                                                                  locale: 'en',
//                                                                  minYear: DateTime
//                                                                              .now()
//                                                                          .year -
//                                                                      70,
//                                                                  maxYear: DateTime
//                                                                          .now()
//                                                                      .year,
//                                                                  initialYear:
//                                                                      DateTime.now()
//                                                                              .year -
//                                                                          20,
//                                                                  initialMonth:
//                                                                      DateTime.now()
//                                                                          .month,
//                                                                  initialDate:
//                                                                      DateTime.now()
//                                                                          .day,
//                                                                  cancel: Text(
//                                                                      'cancel'),
//                                                                  confirm: Text(
//                                                                      'confirm'),
//                                                                  dateFormat:
//                                                                      'dd-mmm-yyyy',
//                                                                  onChanged: (year,
//                                                                      month,
//                                                                      date) {},
//                                                                  onConfirm:
//                                                                      (year,
//                                                                          month,
//                                                                          date) {
//                                                                    spouseDob = year
//                                                                            .toString() +
//                                                                        '-' +
//                                                                        month
//                                                                            .toString() +
//                                                                        '-' +
//                                                                        date.toString();
//                                                                    edtSpouseDob
//                                                                        .text = date
//                                                                            .toString() +
//                                                                        '-' +
//                                                                        month
//                                                                            .toString() +
//                                                                        '-' +
//                                                                        year.toString();
//                                                                    setAge();
//                                                                  },
//                                                                );
                                                              }
                                                            },
                                                            child: Icon(Icons
                                                                .calendar_today)),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        ),
                                                      ],
                                                    ),
                                                    TextFormField(
                                                      controller: edtNoOfChild,
                                                      scrollPadding:
                                                          EdgeInsets.all(0),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              "No Of Child",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText:
                                                              "No Of Child"),
                                                      enabled: isEditable,
                                                      keyboardType:
                                                          TextInputType.number,
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
                                                                Icons.business,
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
                                                                  'Business Info',
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
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (isBusinessEditable) {
                                                                  sendBusinessInfo();
                                                                  sendBusinessWebAndEmail();
                                                                } else {
                                                                  isBusinessEditable =
                                                                      true;
                                                                }
                                                              });
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons.edit,
                                                                  size: 20,
                                                                  color: cnst
                                                                      .appPrimaryMaterialColor,
                                                                ),
                                                                Text(
                                                                  isBusinessEditable
                                                                      ? "Update"
                                                                      : 'Edit',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black),
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
                                                      controller: edtCmpName,
                                                      scrollPadding:
                                                          EdgeInsets.all(0),
                                                      decoration: InputDecoration(
                                                          labelText: "Company",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText: "Company"),
                                                      enabled:
                                                          isBusinessEditable,
                                                      minLines: 1,
                                                      maxLines: 4,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                    /*TextFormField(
                                                      controller:
                                                          edtBusinessAddress,
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
                                                      enabled:
                                                          isBusinessEditable,
                                                      minLines: 1,
                                                      maxLines: 4,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),*/
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 6)),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 6)),
                                                    !isBusinessEditable
                                                        ? TextFormField(
                                                            controller:
                                                                edtBusinessCategory,
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "Business Category:",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                hintText:
                                                                    "Business Category"),
                                                            enabled:
                                                                isBusinessEditable,
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          )
                                                        : InputDecorator(
                                                            decoration:
                                                                new InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              //labelText: "",
                                                              fillColor:
                                                                  Colors.white,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child: DropdownButton<
                                                                    ProfessionClass>(
                                                                  //isDense: true,
                                                                  hint: new Text(
                                                                      "Select Business Category"),
                                                                  value:
                                                                      __professionClass,
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      __professionClass =
                                                                          val;
                                                                      print(val
                                                                          .Id);
                                                                    });
                                                                  },
                                                                  items: _profession.map(
                                                                      (ProfessionClass
                                                                          reasonClass) {
                                                                    return new DropdownMenuItem<
                                                                        ProfessionClass>(
                                                                      value:
                                                                          reasonClass,
                                                                      child:
                                                                          new Text(
                                                                        reasonClass
                                                                            .Profession,
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        style: new TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          child: TextFormField(
                                                            controller:
                                                                edtBusinessAddress,
                                                            scrollPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            decoration: InputDecoration(
                                                                labelText:
                                                                    "Address",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                                hintText:
                                                                    "Address"),
                                                            enabled:
                                                                isBusinessEditable,
                                                            minLines: 1,
                                                            maxLines: 4,
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
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
                                                        GestureDetector(
                                                            onTap: () {
                                                              if (isBusinessEditable) {
                                                                //getUserLocation();
                                                                getUserLocationSecond();
                                                              }
                                                            },
                                                            child: Image.asset(
                                                                'images/google24.png')),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                        ),
                                                      ],
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          edtBusinessAbout,
                                                      scrollPadding:
                                                          EdgeInsets.all(0),
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              "About Business",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText:
                                                              "About Business"),
                                                      enabled:
                                                          isBusinessEditable,
                                                      minLines: 1,
                                                      maxLines: 4,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText: "Keywords"),
                                                      enabled:
                                                          isBusinessEditable,
                                                      minLines: 1,
                                                      maxLines: 6,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText: "Website"),
                                                      enabled:
                                                          isBusinessEditable,
                                                      minLines: 1,
                                                      maxLines: 3,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
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
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          hintText: "Email"),
                                                      enabled:
                                                          isBusinessEditable,
                                                      minLines: 1,
                                                      maxLines: 3,
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
                                  child: isBusinessLoading
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
                    : list.length > 0 && list != null
                        ? SingleChildScrollView(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
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
                                                            Icons.info,
                                                            color: cnst
                                                                .appPrimaryMaterialColor,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              'More Info',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (isMoreEditable) {
                                                              sendMoreInfoInfo();
                                                            } else {
                                                              isMoreEditable =
                                                                  true;
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
                                                              isMoreEditable
                                                                  ? "Update"
                                                                  : 'Edit',
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
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                                /*TextFormField(
                                                  controller:
                                                      edtTestimonial,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Testimonial",
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                      hintText:
                                                          "Testimonial"),
                                                  enabled: isMoreEditable,
                                                  minLines: 1,
                                                  maxLines: 4,
                                                  keyboardType:
                                                      TextInputType
                                                          .multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),*/
                                                TextFormField(
                                                  controller: edtAchievement,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
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
                                                  controller:
                                                      edtExperienceOfWork,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
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
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Ask For People",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText:
                                                          "Ask For People"),
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
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
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
                                              color:
                                                  cnst.appPrimaryMaterialColor,
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
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                itemCount:
                                                    testimoniallist.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
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
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.6),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
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
                          )
                        : NoDataComponent(),
              ),
              /*Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    size: 15,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  Text(
                                    "Date",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: cnst.appPrimaryMaterialColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                          Expanded(
                            child: Container(
                                child: Text(
                              "Title",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: cnst.appPrimaryMaterialColor,
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Container(
                          child: FutureBuilder<List>(
                            future: Services.getAttenddance(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.done
                                  ? snapshot.hasData
                                      ? ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return AttendanceComponents(
                                                snapshot.data[index]);
                                          },
                                        )
                                      : NoDataComponent()
                                  : LoadinComponent();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
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
        print('file value:${_imageOffer.path}');
        Services.UploadMemberImage(formData).then((data) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (data != "" && data != "0") {
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
                      if (image != null) {
                        setState(() {
                          _imageOffer = image;
                        });
                        Navigator.pop(context);
                        sendUserProfileImg();
                      }
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          _imageOffer = image;
                        });
                        Navigator.pop(context);
                        sendUserProfileImg();
                      }
                    }),
              ],
            ),
          );
        });
  }
}
