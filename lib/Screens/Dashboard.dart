import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_version/get_version.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/AdminDashboardComponent.dart';
import 'package:progressclubsurat_new/Screens/ScanVisitorList.dart';
import 'package:progressclubsurat_new/Screens/SellRent.dart';
import 'package:progressclubsurat_new/Screens/WebViewEventForm.dart';
import 'package:progressclubsurat_new/offlinedatabase/db_handler.dart';
import 'package:progressclubsurat_new/pages/Ask.dart';
import 'package:progressclubsurat_new/pages/AssignmentsPage.dart';
import 'package:progressclubsurat_new/pages/Home.dart';
import 'package:progressclubsurat_new/pages/NotificationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:developer';

import 'AnimatedBottomBar.dart';

bool adminSwitchShow = true;
bool adminOptionsPressed = false;
bool isAdmin = true;
bool isLoading = true;
const String memberType = "";
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  AnimationController _controller;
  String barcode = "", currentDay = "";
  var currentMoth = "", curentYear = "";

  List _eventList = [];

  //loading var
  bool flag = false;
  bool noPopUpData = false;
  bool popUpResponded = false;

  String memberName = "",
      memberCmpName = "",
      memberPhoto = "",
      memberId = "",
      memberType = "",
      chapterId = "";
  String businessAbout, website;
  int soundId;
  int _currentIndex = 0;

  List list = new List(); //vinchu

  DBHelper dbHelper;
  Future<List<Visitorclass>> visitor;

  //Soundpool pool = Soundpool(streamType: StreamType.notification);
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String fcmToken = "";
  List<BarItem> barItems = [];

  TextEditingController edtSale = new TextEditingController();

  Dialog EventDialog;
  String appVersion = "";
  StreamSubscription iosSubscription;
  ProgressDialog pr;
  bool isLeaderHome = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    setPack();
    getMemberWebsite();
    getLocalData();
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print("FFFFFFFF" + data.toString());
        saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }

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
  }

  getEventData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetLastEvent();
        res.then((data) async {
          // log("-------------- SECOND call ------ ${data}");
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              _eventList = data;
            });
            showEventPopUp();
          } else {
            setState(() {
              isLoading = false;
              noPopUpData = true;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  void dispose() {
    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      var tokendata = token.split(':');
      setState(() {
        fcmToken = token;
        sendFCMTokan();
      });
      print("FCM Token : $fcmToken");
    });
  }

  setPack() async {
    try {
      appVersion = await GetVersion.projectVersion;
    } on PlatformException {
      appVersion = 'Failed to get project version.';
    }
    setState(() {
      appVersion = appVersion;
    });
  }

  confirmLogout(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Progress Club"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(cnst.Session.MemberId);
    prefs.remove(cnst.Session.ChapterId);
    prefs.remove(cnst.Session.memId);
    prefs.remove(cnst.Session.Photo);
    prefs.remove(cnst.Session.CompanyName);
    prefs.remove(cnst.Session.memId);
    Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
  }

  showEventPopUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberType = prefs.getString(Session.Type);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            //title: new Text("Progress Club"),
            content: Container(
                height: 390,
                child: Column(
                  children: <Widget>[
                    /*Align(
                      alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                      Icons.cancel,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                        )),*/
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            'Progress Club',
                            style: TextStyle(fontSize: 25),
                          )),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  popUpResponded = true;
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                    Text("New Event : ${_eventList[0]["Title"]}"),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    _eventList[0]["Image"] != "" &&
                            _eventList[0]["Image"] != null
                        ? FadeInImage.assetNetwork(
                            placeholder: 'images/placeholder.png',
                            image: "http://pmc.studyfield.com/" +
                                _eventList[0]["Image"],
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          )
                        : Container(),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(0.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () {
                          if (_eventList[0]["ScreenName"] == 'Web View') {
                            String Formurl = _eventList[0]["Url"].toString();
                            Formurl =
                                Formurl.replaceAll('#memberId#', '$memberId');
                            Formurl = Formurl.replaceAll(
                                '#eventId#', '${_eventList[0]["Id"]}');
                            print("Event Url = ${Formurl}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewEventForm(
                                    url: Formurl,
                                    title: "${_eventList[0]["Title"]}"),
                              ),
                            );
                          } else if (memberType == "Guest") {
                            Navigator.of(context).pop();
                            setState(() {
                              popUpResponded = true;
                              flag = true;
                            });
                          } else {
                            Navigator.pushNamed(context, '/EventGuest');
                          }
                        },
                        child: Text(
                          "${_eventList[0]["ButtonText"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            /*actions: <Widget>[
              new FlatButton(
                child: new Text("Close",style: TextStyle(fontSize: 14,color: cnst.appPrimaryMaterialColor,fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Invite Guest",style: TextStyle(fontSize: 14,color: cnst.appPrimaryMaterialColor,fontWeight: FontWeight.w600),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/EventGuest');
                },
              ),
            ],*/
          ),
        );
      },
    );
  }

  //==========vinchu===========

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
            website = data["website"].toString();
            businessAbout = data["About"].toString();
            // print('========mmmm====${website}');
            // print('========mmmm====${businessAbout}');
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

  getProfileCompletionPercentage() async {
    //vinchu
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(Session.MemberId);

      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetMemberProfile(MemberId);
        res.then((data) async {
          // log("-------------- first call ------ ${data}");
          getEventData();

          if (data != null && data.length > 0) {
            setState(() {
              list = data;
            });
            print("sssssssssssssssss" + list[0].toString());
            double proPer = 0.0;
            if (website != "") {
              proPer = proPer + 5.0;
            }
            if (businessAbout != "") {
              proPer = proPer + 5.0;
            }
            list[0].forEach((key, value) {
              if ((key == "Name") ||
                  (key == "DateOfBirth") ||
                  (key == "Gender") ||
                  (key == "Age") ||
                  (key == "Anniversery") ||
                  (key == "ResidenceAddress") ||
                  (key == "SpouseName") ||
                  (key == "WDOB") ||
                  (key == "NoOfChildren") ||
                  (key == "CompanyName") ||
                  (key == "ProffesionId") ||
                  (key == "OfficeAddress") ||
                  (key == "Keyword") ||
                  (key == "Email") ||
                  (key == "Achivement") ||
                  (key == "ExpOfWork") ||
                  (key == "AskForPeople") ||
                  (key == "Introducer")) {
                if (value != null && value != '') {
                  proPer = proPer + 5.0;
                }
              }
            });
            showProfileCompletionPopUp(proPer.roundToDouble());
            print("nnnnnnnnnnnnnnnnnnnnnnnnn" + proPer.toString());
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
          // return proPer;
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

  showProfileCompletionPopUp(double proPer) {
    //vinchu
    if (proPer != 100.0) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // backgroundColor: Colors.redAccent,
              title: Text('Progress Club'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      "Please Complete Your Profile",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 8.0,
                      animation: true,
                      percent: (proPer / 100),
                      center: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'images/icon_user.png',
                          height: 85,
                          width: 85,
                        ),
                      ),
                      footer: Text(
                        "${proPer.toString()}%",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.deepPurple),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.deepPurple[400],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RaisedButton(
                            color: Colors.red[400],
                            // splashColor: Colors.redAccent,
                            child: FittedBox(
                              child: Text(
                                'Complete Later',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                  // color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: RaisedButton(
                            color: Colors.green[400],
                            // splashColor: Colors.greenAccent,
                            child: FittedBox(
                              child: Text(
                                'Complete Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                  // color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              saveAndNavigator();
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
    }
  }

  //send fcm token
  sendFCMTokan() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(fcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  /*getSound() async {
    int sound = await rootBundle
        .load("sounds/beep_smooth.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });

    setState(() {
      soundId = sound;
    });
  }*/

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      chapterId = prefs.getString(Session.ChapterId);
      memberName = prefs.getString(Session.Name);
      memberCmpName = prefs.getString(Session.CompanyName);
      memberPhoto = prefs.getString(Session.Photo);
      memberType = prefs.getString(Session.Type);

      if (memberType.toLowerCase() != "guest") {
        getProfileCompletionPercentage();
        barItems = [
          BarItem(
              text: "Home",
              iconData: Icons.home,
              color: cnst.appPrimaryMaterialColor),
          // BarItem(
          //     text: "Business",
          //     iconData: Icons.assignment,
          //     color: Colors.yellow.shade900),
          BarItem(
              text: "Property",
              iconData: Icons.assignment,
              color: Colors.yellow.shade900),
          BarItem(
              text: "Ask", iconData: Icons.announcement, color: Colors.teal),
          BarItem(
              text: "Notification",
              iconData: Icons.notifications_active,
              color: Colors.deepOrange.shade600),
        ];
      } else {
        getEventData();
        barItems = [
          BarItem(
              text: "Home",
              iconData: Icons.home,
              color: cnst.appPrimaryMaterialColor),
          BarItem(
              text: "Notification",
              iconData: Icons.notifications_active,
              color: Colors.deepOrange.shade600),
        ];
      }
      //print(memberName);
    });
  }

  List<Widget> _children = [
    Home(),
    SellRent(index: 1),
    Ask(),
    NotificationPage(),
  ];

  // final List<Widget> _children1 = [
  //   Home(),
  //   NotificationPage(),
  // ];

  //================= by rinki
  ShowVisitorScandailog(String id, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 30,
                    child: new RawMaterialButton(
                      fillColor: Colors.redAccent,
                      child: new Text("X",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //Navigator.pushReplacementNamed(context, '/Login');
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Text(
                memberName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cnst.appPrimaryMaterialColor),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Text(
                "Scanning Done",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                    child: Icon(
                  Icons.verified,
                  color: Colors.green,
                  size: 30,
                )),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            RawMaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              fillColor: cnst.appPrimaryMaterialColor,
              child: new Text("Scan Again",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                scanVisitor();
              },
            ),
          ],
        );
      },
    );
  }

  getUserScan(String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future res = Services.Scanner(
            eventId,
            prefs.getString(cnst.Session.MemberId),
            prefs.getString(cnst.Session.ChapterId),
            prefs.getString(cnst.Session.Name),
            prefs.getString(cnst.Session.Mobile))
        .then((data) {
      setState(() {
        isLoading = false;
      });
      // log("outside");
      if (data != null && data.ERROR_STATUS == false && data.RECORDS == true) {
        // log("inside true");
        Fluttertoast.showToast(
          msg: "Data Saved ",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        // log("inside false");
        Fluttertoast.showToast(
            msg: "Data Not Saved " + data.MESSAGE,
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG);
      }
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Data Not Saved      " + e.toString(),
          backgroundColor: Colors.red);
    });
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      if (qrtext != null) {
        if (qrtext.length == 2) {
          setState(() {
            print(qrtext[0].toString());
            print(qrtext.toString());
            //AddVisitorAttendance(qrtext[0].toString(), qrtext[1].toString(),qrtext[2].toString());
            // dbHelper.add(Visitorclass(int.parse(qrtext[0]), qrtext[1].toString(),
            //     qrtext[2].toString(), memberId));
            //showMsg("Visitor added "+qrtext[1].toString());
            // ShowVisitordailog(qrtext[0], qrtext[1]);
            getUserScan(qrtext[0]);
            ShowVisitorScandailog(qrtext[0], qrtext[1]);

            this.barcode = barcode;
          });
          setState(() => this.barcode = barcode);
        } else {
          setState(() {
            print(qrtext);
            print(qrtext[1].toString());
            String eventId = qrtext[0].toString();
            String Type = qrtext[2].toString();
            if (memberType.toLowerCase() == Type.toLowerCase()) {
              sendEventAttendance(eventId);
            } else {
              if (memberType.toLowerCase() == "guest") {
                showMsg("Please Register first from Registration Counter.");
              } else {
                showMsg("This Barcode only valid for Guest.");
              }
            }
            this.barcode = barcode;
          });
          setState(() => this.barcode = barcode);
        }

        // setState(() {
        //   print(qrtext);
        //   print(qrtext[1].toString());
        //   String eventId = qrtext[0].toString();
        //   String Type = qrtext[2].toString();
        //   if (memberType.toLowerCase() == Type.toLowerCase()) {
        //     sendEventAttendance(eventId);
        //   } else {
        //     if (memberType.toLowerCase() == "guest") {
        //       showMsg("Please Register first from Registration Counter.");
        //     } else {
        //       showMsg("This Barcode only valid for Guest.");
        //     }
        //   }
        //   this.barcode = barcode;
        //  });
        setState(() => this.barcode = barcode);
      } else {
        showMsg("Try Again.");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Progress Club"),
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
          content: new Text(
            msg,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
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

  ShowVisitordailog(String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                id,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.red),
              ),
              Divider(
                color: Colors.grey,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RawMaterialButton(
              fillColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: new Text("Scan Again",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                scanVisitor();
                //Navigator.pushReplacementNamed(context, '/Login');
              },
            ),
            new FlatButton(
              child: Icon(
                Icons.clear,
              ),
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

  sendEventAttendance(String eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          'MemberId': memberId,
          'EventId': eventId,
        };
        Services.sendEventAttendance(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data == "1") {
            //signUpDone("Attendance Send Successfully");
            signUpDone(
                "${memberName} Your Attendance has been taken please show this message to Welcome Team.");
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

  saveAndNavigator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.memId, memberId);
    if (memberType.toLowerCase() == "guest") {
      Navigator.pushNamed(context, '/GuestProfile');
    } else {
      Navigator.pushNamed(context, '/MemberProfile');
    }
  }

  getLocalDataFrom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberName = prefs.getString(Session.Name);
      memberCmpName = prefs.getString(Session.CompanyName);
      memberPhoto = prefs.getString(Session.Photo);
      //print(memberName);
    });
  }

  String getName() {
    getLocalDataFrom();
    return memberName;
  }

  showEventDialog() async {
    showDialog(context: context, builder: (BuildContext context) => MyDialog());
  }

  Future scanVisitor() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      if (qrtext != null) {
        setState(() {
          print(qrtext[0].toString());
          //AddVisitorAttendance(qrtext[0].toString(), qrtext[1].toString(),qrtext[2].toString());
          dbHelper.add(Visitorclass(int.parse(qrtext[0]), qrtext[1].toString(),
              qrtext[2].toString(), memberId));
          //showMsg("Visitor added "+qrtext[1].toString());
          ShowVisitordailog(qrtext[0], qrtext[1]);
          this.barcode = barcode;
        });
        setState(() => this.barcode = barcode);
      } else {
        showMsg("Try Again.");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  AddVisitorAttendance(String id, String name, String mobile) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Services.ScanVisitor(id, memberId).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            signUpDone("${id} \n ${name}");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children1 = [
      Home(
        flag: flag,
        noPopUpData: noPopUpData,
      ),
      NotificationPage(),
    ];
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Container(
          //color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              saveAndNavigator();
            },
            child: Row(
              children: <Widget>[
                AvatarGlow(
                  glowColor: Colors.white,
                  endRadius: 27.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 100.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: ClipOval(
                        child: memberPhoto != null
                            ? FadeInImage.assetNetwork(
                                placeholder: 'images/icon_user.png',
                                image: memberPhoto.contains("http")
                                    ? memberPhoto
                                    : "http://pmc.studyfield.com/" +
                                        memberPhoto,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'images/icon_user.png',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                      radius: 20.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${getName()}",
                          style: TextStyle(fontSize: 14),
                          maxLines: 1,
                        ),
                        Text(
                          '$memberCmpName',
                          style: TextStyle(fontSize: 12),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/ScanEventGuest');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.verified, size: 25),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.sync, size: 25),
            ),
          ),
          GestureDetector(
            onTap: () {
              showEventDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: EdgeInsets.all(7),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                //child: Icon(Icons.info, color: cnst.appPrimaryMaterialColor, size: 35)),
                child: Image.asset(
                  'images/line_chart.png',
                  height: 23,
                  width: 23,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              scan();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                'images/icon_scanner.png',
                height: 40,
                width: 40,
              ),
            ),
          ),
        ],
      ),
      //images/line_chart.png
      drawer: new Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: memberType.toLowerCase() == "guest"
                  ? ListView(
                      children: <Widget>[
                        new ListTile(
                            leading: Icon(Icons.directions,
                                color: cnst.appPrimaryMaterialColor),
                            title: new Text("Member Directory"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/Directory');
                            }),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.library_books,
                              color: cnst.appPrimaryMaterialColor, size: 25),

//                            Image.asset(
//                              'images/facetoface.png',
//                              color: cnst.appPrimaryMaterialColor,
//                              height: 30,
//                              width: 25,
//                            ),
                          title: new Text("Library"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/BookScreen');
                            //Navigator.pushReplacementNamed(context, '/Download');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                            leading: Icon(Icons.assignment,
                                color: cnst.appPrimaryMaterialColor),
                            title: new Text("Event"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/EventList');
                              //Navigator.pushReplacementNamed(context, '/EventList');
                            }),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                            leading: Icon(Icons.notifications,
                                color: cnst.appPrimaryMaterialColor),
                            title: new Text("Notification"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, '/NotificationScreen');
                            }),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                            leading: Icon(Icons.feedback,
                                color: cnst.appPrimaryMaterialColor),
                            title: new Text("Feedback"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/FeedbackScreen');
                            }),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          //leading: Icon(Icons.show_chart, color: cnst.appPrimaryMaterialColor),
                          leading: Image.asset(
                            'images/aboutus.png',
                            height: 24,
                            width: 24,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          title: new Text("About Us"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/AboutUs');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                            leading: Icon(Icons.exit_to_app,
                                color: cnst.appPrimaryMaterialColor),
                            title: new Text("Logout"),
                            onTap: () {
                              confirmLogout("Are you Sure to logout?");
                            }),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                      ],
                    )
                  : ListView(
                      children: <Widget>[
                        new ListTile(
                            leading: Icon(Icons.directions,
                                color: cnst.appPrimaryMaterialColor),
                            title: new Text("Member Directory"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/Directory');
                            }),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Image.asset(
                            'images/verified_user.png',
                            color: cnst.appPrimaryMaterialColor,
                            height: 23,
                            width: 23,
                          ),
                          title: new Text("Attendance"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/Attendance');
                            //Navigator.pushReplacementNamed(context, '/Download');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Image.asset(
                            'images/facetoface.png',
                            color: cnst.appPrimaryMaterialColor,
                            height: 30,
                            width: 25,
                          ),
                          title: new Text("Face To Face"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/FaceToFace');
                            //Navigator.pushReplacementNamed(context, '/Download');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.library_books,
                              color: cnst.appPrimaryMaterialColor, size: 25),

//                            Image.asset(
//                              'images/facetoface.png',
//                              color: cnst.appPrimaryMaterialColor,
//                              height: 30,
//                              width: 25,
//                            ),
                          title: new Text("Library"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/BookScreen');
                            //Navigator.pushReplacementNamed(context, '/Download');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.menu_book,
                              color: cnst.appPrimaryMaterialColor, size: 25),

//                            Image.asset(
//                              'images/facetoface.png',
//                              color: cnst.appPrimaryMaterialColor,
//                              height: 30,
//                              width: 25,
//                            ),
                          title: new Text("Idea Book"),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            bool val = prefs.getBool("new");
                            if (val == null) {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/IdeaBookScreen');
                              prefs.setBool("new", false);
                            } else {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, '/IdeaBookComponent');
                            }
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.home,
                              color: cnst.appPrimaryMaterialColor, size: 25),

//                            Image.asset(
//                              'images/facetoface.png',
//                              color: cnst.appPrimaryMaterialColor,
//                              height: 30,
//                              width: 25,
//                            ),
                          title: new Text("Property"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/SellRent');
                            //Navigator.pushReplacementNamed(context, '/Download');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.file_download,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Download"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/Download');
                            //Navigator.pushReplacementNamed(context, '/Download');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.assignment,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Event"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/EventList');
                            //Navigator.pushReplacementNamed(context, '/EventList');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.person_pin,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Event Guest"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/EventGuest');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.group_add,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("My Invites"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/GuestInvitedByMe');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        //=================================================================
                        new ListTile(
                          leading: Image.asset(
                            'images/icon_scanner.png',
                            height: 25,
                            width: 25,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          title: new Text("Scan Visitor"),
                          onTap: () {
                            Navigator.pop(context);
                            scanVisitor();
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          //leading: Icon(Icons.show_chart, color: cnst.appPrimaryMaterialColor),
                          leading: Icon(Icons.people,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Visitor list"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/Visitorlist');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.assignment,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Assignments"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/Assignments');
                            //Navigator.pushReplacementNamed(context, '/Assignments');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.library_books,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Office Booking"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/OfficeBookingCalender');
                            //_logout();
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Image.asset(
                            'images/icon_ask.png',
                            color: cnst.appPrimaryMaterialColor,
                            height: 28,
                            width: 28,
                          ),
                          title: new Text("Ask"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/AskList');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.notifications,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Notification"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/NotificationScreen');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.feedback,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Feedback"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/FeedbackScreen');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          //leading: Icon(Icons.show_chart, color: cnst.appPrimaryMaterialColor),
                          leading: Image.asset(
                            'images/line_chart.png',
                            height: 24,
                            width: 24,
                          ),
                          title: new Text("Daily Progress"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/ShowDailyProgress');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          //leading: Icon(Icons.show_chart, color: cnst.appPrimaryMaterialColor),
                          leading: Image.asset(
                            'images/aboutus.png',
                            height: 24,
                            width: 24,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          title: new Text("About Us"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/AboutUs');
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        new ListTile(
                          leading: Icon(Icons.exit_to_app,
                              color: cnst.appPrimaryMaterialColor),
                          title: new Text("Logout"),
                          onTap: () {
                            confirmLogout("Are you Sure to logout?");
                          },
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                      ],
                    ),
            ),
            Container(
              // This align moves the children to the bottom
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                // This container holds all the children that will be aligned
                // on the bottom and should not scroll with the above ListView
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        title: Column(
                          children: <Widget>[
                            Text('App Version'),
                            Text('${appVersion}')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: WidgetFlipper(
        frontWidget: barItems.length == 4
            ? _children[_currentIndex]
            : (isLoading == false &&
                    popUpResponded == true &&
                    noPopUpData == false)
                ? _children1[_currentIndex]
                : (isLoading == false &&
                        popUpResponded == false &&
                        noPopUpData == true)
                    ? _children1[_currentIndex]
                    : Container(),
        backWidget: AdminDashboardComponent(),
      ),
      bottomNavigationBar: adminOptionsPressed == false
          ? AnimatedBottomBar(
              barItems: barItems,
              animationDuration: Duration(milliseconds: 350),
              onBarTab: (index) {
                setState(() {
                  index == 0 ? adminSwitchShow = true : adminSwitchShow = false;
                });
                setState(
                  () {
                    _currentIndex = index;
                  },
                );
                print('=============${index}');
              },
            )
          : null,
    );
  }
}

class WidgetFlipper extends StatefulWidget {
  WidgetFlipper({
    Key key,
    this.frontWidget,
    this.backWidget,
  }) : super(key: key);

  final Widget frontWidget;
  final Widget backWidget;

  @override
  _WidgetFlipperState createState() => _WidgetFlipperState();
}

class _WidgetFlipperState extends State<WidgetFlipper>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  bool isFrontVisible = true;
  String memberName = "",
      memberCmpName = "",
      memberPhoto = "",
      memberId = "",
      memberType = "",
      chapterId = "";
  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      chapterId = prefs.getString(Session.ChapterId);
      memberName = prefs.getString(Session.Name);
      memberCmpName = prefs.getString(Session.CompanyName);
      memberPhoto = prefs.getString(Session.Photo);
      memberType = prefs.getString(Session.Type);
      //print(memberName);
    });
  }


  @override
  void initState() {
    getLocalData();
    super.initState();
    print("heloooooooooooooooooooooooooooooooooooooooooooooooooo");
print(memberType);
    controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        AnimatedCard(
          animation: _backRotation,
          child: widget.backWidget,
        ),
        AnimatedCard(
          animation: _frontRotation,
          child: widget.frontWidget,
        ),
        _tapDetectionControls(),
      ],
    );

  }


  Widget _tapDetectionControls() {
    return  memberType.toLowerCase() == "null"  ?  Stack(
      fit: StackFit.expand,
      children: <Widget>[
        !isLoading
            ? isAdmin == true
                ? adminSwitchShow
                    ? Column(
                        children: [
                          adminOptionsPressed == true
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.263,
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  this._dismissKeyboard(context);
                                  setState(() {
                                    adminOptionsPressed = !adminOptionsPressed;

                                  });
                                  _leftRotation();
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.062,
                                  width:
                                      MediaQuery.of(context).size.width * 0.125,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border: Border.all(
                                      color: cnst.appPrimaryMaterialColor,
                                    ),
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        adminOptionsPressed == false
                                            ? 'Admin\nControls'
                                            : 'Dash\nControls',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 8.6,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.swap_horiz_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container()
                : Container()
            : Container(),
      ],
    )
        :Container();

  }

  void _leftRotation() {
    _toggleSide();
  }

  void _toggleSide() {
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }
}

class AnimatedCard extends StatelessWidget {
  AnimatedCard({
    this.child,
    this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController edtSale = new TextEditingController();
  TextEditingController edtEffectiness = new TextEditingController();
  int selectedRadio = 1;

  ProgressDialog pr;
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);

  setSelectRadio(int Radio) {
    setState(() {
      selectedRadio = Radio;
      print(Radio == 1 ? true : false);
    });
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

  //send More Info to server
  sendDailyProgress() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);

        var data = {
          'Id': "0",
          'MemberId': memberId,
          'DailyTaskSheet': selectedRadio == 1 ? true : false,
          'Effectiveness': edtEffectiness.text.toString(),
          'TodaySale': edtSale.text.toString(),
          'Date': date.toString()
        };
        Services.sendDailyProgress(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data != "") {
            Navigator.pop(context);
            showMsg("Data Updated Successfully");
          } else {
            pr.hide();
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
                  "Your Daily Progress",
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextFormField(
              controller: edtSale,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Today Sales",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Today Sales"),
              enabled: true,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtEffectiness,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Effectiveness %(0-100)",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Effectiveness %(0-100)"),
              onChanged: (data) {
                var val = int.parse(edtEffectiness.text);
                if (val > 101) {
                  edtEffectiness.text = "100";
                  Fluttertoast.showToast(
                      msg: "Enter Effectiveness Between 0 To 100.",
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_SHORT);
                }
              },
              enabled: true,
              keyboardType: TextInputType.number,
              maxLength: 3,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Daily task sheet:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setSelectRadio(value);
                      },
                      activeColor: cnst.appPrimaryMaterialColor,
                    ),
                    new Text(
                      'Yes',
                      style: new TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        onChanged: (value) {
                          setSelectRadio(value);
                        },
                        activeColor: cnst.appPrimaryMaterialColor),
                    new Text(
                      'No',
                      style: new TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
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
                            //Navigator.pop(context);
                            if (edtSale.text != "" && edtSale.text != null) {
                              if (edtEffectiness.text != "" &&
                                  edtEffectiness.text != null) {
                                sendDailyProgress();
                              } else {
                                showMsg("Enter Effectiveness");
                              }
                            } else {
                              showMsg("Enter Today Sales");
                            }
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
