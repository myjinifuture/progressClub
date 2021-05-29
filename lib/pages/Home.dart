import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Component/GuestEventComponent.dart';
import 'package:progressclubsurat_new/Screens/CardShareComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/GuestEventListComponent.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Screens/MultipleEventList.dart';
import 'package:progressclubsurat_new/offlinedatabase/db_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  bool flag;
  bool noPopUpData;

  Home({this.flag, this.noPopUpData});

  @override
  _HomeState createState() => _HomeState();
}

final Map<DateTime, List> _holidays = {
  /*DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],*/
};

class _HomeState extends State<Home> with TickerProviderStateMixin {
  DashboardCountClass _dashboardCount =
      new DashboardCountClass(visitors: '0', calls: '0', share: '0');

  DateTime _selectedDay;
  Map<DateTime, List> _events;
  List _guestEvent = [];
  List _guestEvent1 = [];
  List<dynamic> pcDigitalList = [];
  Map<DateTime, List> _visibleEvents;

  List chapter = new List();
  List settings = new List();
  List userScanList = new List();
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;
  String barcode = "", currentDay = "";
  var currentMoth = "", curentYear = "";

  TextEditingController _MobileNumberInput = TextEditingController();

  //loading var
  bool isLoading = true;

  String memberName = "",
      memberCmpName = "",
      memberPhoto = "",
      memberId = "",
      memberType = "",
      memberMobile = "",
      chapterId = "",
      stateName = "",
      cityName = "",
      chapterName = "All";
  String ExpDate = "";

  int soundId;
  int _currentIndex = 0;
  DBHelper dbHelper;

  //Soundpool pool = Soundpool(streamType: StreamType.notification);
  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String fcmToken = "";

  List<ChapterClass> _chapterCategory = new List();
  ChapterClass __chapterCategoryClass;
  ChapterClass __chapterCategoryClassNew;

  String sdate = "", edate = "";
  ProgressDialog pr;

  String MemberId = "";
  String Name = "";
  String Company = "";
  String Photo = "";
  String CoverPhoto = "";
  String ReferCode = "";
  String MemberType = "";
  String ShareMsg = "";
  bool IsActivePayment = false;

  @override
  void initState() {
    print('--------------------------------------${widget.flag}');
    dbHelper = DBHelper();
    super.initState();
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    getProffesionFromServer();
    getLocalData();
    _controller.forward();
    getSettings();
  }

  getProffesionFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetChapterData();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              __chapterCategoryClassNew =
                  new ChapterClass(ChapterId: 0, ChapterName: "All");
              _chapterCategory = data;
              getData();
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
      log("outside");
      if (data != null && data.ERROR_STATUS == false && data.RECORDS == true) {
        log("inside true");
        Fluttertoast.showToast(
          msg: "Data Saved ",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        log("inside false");
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

  getSettings() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetUserSettings();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              settings = data;
              isLoading = false;
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

  AddMemberByMobileNumber() async {
    if (_MobileNumberInput.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          Services.AddvisitorByMobilenumber(_MobileNumberInput.text, memberId)
              .then((data) async {
            pr.hide();
            if (data.Data == "1") {
              var res = data.Message.split(",");
              ShowVisitordailog(res[0], res[1]);
            } else {
              showMsg(data.Message);
            }
          }, onError: (e) {
            setState(() {
              pr.hide();
            });
            showMsg("Try Again.");
          });
        } else {
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Enter The Number");
    }
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      chapterId = prefs.getString(Session.ChapterId);
      memberName = prefs.getString(Session.Name);
      memberCmpName = prefs.getString(Session.CompanyName);
      memberPhoto = prefs.getString(Session.Photo);
      memberType = prefs.getString(Session.Type);
      memberMobile = prefs.getString(Session.Mobile);
      cityName = prefs.getString(Session.cityname);
      stateName = prefs.getString(Session.statename);
      //print(memberName);
    });
    getGuestDashboardData(memberId);
    print("Calling");
    getGuestEventData(memberMobile);
    var now = new DateTime.now();
    String year = now.year.toString();
    String month = '';
    if (now.month.toString().length > 1)
      month = now.month.toString();
    else
      month = '0' + now.month.toString();

    var parsedDate = DateTime.parse("${year}-${month}-01 00:00:00.000");

    // Find the last day of the month.
    var lastDayDateTime = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 0)
        : new DateTime(now.year + 1, 1, 0);

    sdate = DateTime(now.year, 1, 1).toString().substring(0, 10);
    edate = DateTime(now.year + 1, 12, 31).toString().substring(0, 10);
    print("s data: ${sdate}");
    print("e data: ${edate}");
  }

  getData() {
    if (chapterId == "" || chapterId == "null" || chapterId == null) {
      setState(() {
        _chapterCategory.insert(0, __chapterCategoryClassNew);
      });
    }
    for (int i = 0; i < _chapterCategory.length; i++) {
      if (chapterId.toString() == _chapterCategory[i].ChapterId.toString()) {
        chapterName = _chapterCategory[i].ChapterName.toString();
      }
    }
    print('aaaaaa${chapterId}');
    getDashboardData(chapterId == "" ? "0" : chapterId, sdate, edate);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
    if (events.length > 0) {
      String selectedDate = day.toString().substring(0, 10);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultipleEventList(
            date: selectedDate,
            chapterId: chapterId,
            memberId: memberId,
          ),
        ),
      );
    }
    /*ifx (events.length == 1) {
      showEventDialog(_selectedEvents);
    } else if (events.length > 1) {
      Navigator.pushNamed(context, '/MultipleEventList');
    }*/
  }

  Future scanVisitor() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      if (qrtext != null) {
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

  ShowVisitordailog(String id, String name) {
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
            RawMaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              fillColor: Colors.green,
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
            RawMaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              fillColor: Colors.green,
              child: new Text("Search",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _addvisitorMobilenumberinput(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 40,
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
            ),
          ],
        );
      },
    );
  }

//=====================by rinki
  ShowVisitorScandailog(String id, String name) {
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
              Center(
                child: Text(
                  memberName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: cnst.appPrimaryMaterialColor),
                ),
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

  showEventDialog(List event) {
    Dialog EventDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "STAFF TRAINING",
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Progress Club 1',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'A training agenda is, basically, a series or outline of '
                'activities or training process.',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.50),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Training Date & Time',
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'From :',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' 24-Jan-2019',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'To :',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ' 24-Jan-2019',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'On 5 PM to 7 PM',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Venue At :',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Bhatar Community hall, Althan, Surat-395008',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Registration Charges : ${cnst.Inr_Rupee} 250/-',
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
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
                            //if (isLoading == false) this.SaveOffer();
                            //Navigator.pushReplacementNamed(context, '/Dashboard');
                          },
                          child: Text(
                            "Register",
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
                            //if (isLoading == false) this.SaveOffer();
                            //Navigator.pushReplacementNamed(context, '/Dashboard');
                          },
                          child: Text(
                            "Register & Pay",
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
    showDialog(
        context: context, builder: (BuildContext context) => EventDialog);
  }

  getDashboardData(String chapterId, String sdate, String edate) async {
    // print(chapterId);
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Chapter ID=============>${chapterId}');
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetDashboard(chapterId, sdate, edate);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
            });

            _events = {};
            for (int i = 0; i < data.length; i++) {
              _events.addAll({
                DateTime.parse(data[i]["Date"].toString()): data[i]["EventList"]
              });
            }
            _selectedEvents = _events[_selectedDay] ?? [];
            _visibleEvents = _events;
            _visibleHolidays = _holidays;

            _controller = AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 100),
            );
            _controller.forward();
          } else {
            setState(() {
              isLoading = false;
              _events.clear();
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on getDashboardData $e");
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

  getGuestDashboardData(String MemberId) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetGuestEventData(MemberId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              _guestEvent = data;
            });

            print(_guestEvent);

            for (int i = 0; i <= data.length; i++) {
              if (data[i]["PCName"] == "PC-DIGITAL") {
                setState(() {
                  pcDigitalList.add(data[i]);
                });
                log("===================${pcDigitalList}");
              }
            }
            ;
          } else {
            setState(() {
              isLoading = false;
              _events.clear();
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on getDashboardData $e");
          // showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getGuestEventData(String Mobile) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GuestEventData1(Mobile);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              _guestEvent1 = data;
            });
            print(_guestEvent1);
          } else {
            setState(() {
              isLoading = false;
              _events.clear();
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on getDashboardData $e");
          // showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
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

  _addvisitorMobilenumberinput(BuildContext context) async {
    setState(() {
      _MobileNumberInput.text = "";
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Search Visitor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cnst.appPrimaryMaterialColor),
                  ),
                )),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Mobile Number"),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: _MobileNumberInput,
                    decoration: InputDecoration(
                        counter: Text(""),
                        hintText: "Enter Visitor Mobile No",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide())),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: new RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new Text('Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: SizedBox(
                      width: 100,
                      child: new RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: new Text('Search',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        onPressed: () {
                          AddMemberByMobileNumber();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  // var data = {
  //   'Name': edtName.text.trim(),
  //   'MobileNo': edtMobileNo.text.trim(),
  //   'Email': edtEmail.text.trim(),
  //   'CompanyName': edtCmpName.text.trim(),
  //   'RefferBy': edtRefferBy.text.trim(),
  // };

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
            print("Session card id");
            print(cardid);
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

  checkLogin() async {
    if (CardIddata[0]["mobile"] != "" && CardIddata[0]["mobile"] != null) {
      if (CardIddata[0]["mobile"].length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            //pr.show();
            Services.MemberLogin1(CardIddata[0]["mobile"]).then((data) async {
              if (data != null || data == []) {
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

  int ontap = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (isLoading) {
      return LoadinComponent();
    } else {
      return memberType == "Guest"
          ? DefaultTabController(
              length: 2,
              initialIndex: (widget.noPopUpData == true && widget.flag == false)
                  ? 0
                  : (widget.flag == true && widget.noPopUpData == false)
                      ? 1
                      : 0,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize:
                      Size.fromHeight(60.0), // here the desired height

                  child: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'Meetings',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Events',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(children: <Widget>[
                  Column(
                    children: [
                      Expanded(
                        child:

                            // _guestEvent.length > 0
                            //     ?
                            cityName == "Surat"
                                ? _guestEvent.length > 0
                                    ? ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GuestEventListComponent(
                                              EventData: _guestEvent[index]);
                                        },
                                        itemCount: _guestEvent.length,
                                      )
                                    : Container(
                                        child: Center(
                                            child: Text("No Data Found")),
                                      )
                                : pcDigitalList.length > 0
                                    ? ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GuestEventListComponent(
                                              EventData: pcDigitalList[index]);
                                        },
                                        itemCount: pcDigitalList.length,
                                      )
                                    : Container(
                                        child: Center(
                                            child: Text("No Data Found")),
                                      ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: _guestEvent1.length > 0
                            ? ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return GuestEventComponent(
                                      EventData: _guestEvent1[index]);
                                },
                                itemCount: _guestEvent1.length,
                                // itemCount: 5,
                              )
                            : Container(
                                child: Center(child: Text("No Data Found")),
                              ),
                      ),
                    ],
                  ),
                ]),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ClipPath(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 37),
                          //height:MediaQuery.of(context).size.height/4.5,
                          height: height > 550.0
                              ? MediaQuery.of(context).size.height / 6.0
                              : MediaQuery.of(context).size.height / 5.30,
                          width: MediaQuery.of(context).size.width,
                          color: cnst.appPrimaryMaterialColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${date.substring(8, 10)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: height > 550.0 ? 31 : 14,
                                      ),
                                    ),
                                    Text(
                                      '${new DateFormat.EEEE().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(date.substring(0, 10)).toString()))}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 2,
                                margin: EdgeInsets.only(top: 0),
                                height: height > 550.0 ? 88 : 58,
                                color: Colors.grey[300].withOpacity(0.5),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(date.substring(0, 10)).toString()))},',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: height > 550.0 ? 28 : 8,
                                      ),
                                    ),
                                    Text(
                                      '${date.substring(0, 4)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: height > 550.0 ? 28 : 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        clipper: displayDateClipper(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // settings.length > 0
                          //     ? Row(
                          //         children: <Widget>[
                          //           settings[0]["ScanVisitor"].toString() !=
                          //                   ""
                          //               ? Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       left: 8, right: 8),
                          //                   child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.center,
                          //                     children: <Widget>[
                          //                       GestureDetector(
                          //                         onTap: () {
                          //                           scanVisitor();
                          //                         },
                          //                         child: Container(
                          //                             width: 50,
                          //                             height: 40,
                          //                             decoration: BoxDecoration(
                          //                                 borderRadius:
                          //                                     BorderRadius
                          //                                         .all(Radius
                          //                                             .circular(
                          //                                                 30)),
                          //                                 color:
                          //                                     cnst.appPrimaryMaterialColor[
                          //                                         100]),
                          //                             child: Center(
                          //                                 child: Image.asset(
                          //                               'images/icon_scanner.png',
                          //                               width: 32,
                          //                               height: 30,
                          //                               color: cnst
                          //                                   .appPrimaryMaterialColor,
                          //                             ))),
                          //                       ),
                          //                       Text(
                          //                         "Scan Visitor",
                          //                         style: TextStyle(
                          //                             fontSize: 10,
                          //                             fontWeight:
                          //                                 FontWeight.w600),
                          //                       )
                          //                     ],
                          //                   ),
                          //                 )
                          //               : Container(),
                          //           settings[0]["SearchVisitor"].toString() !=
                          //                   "0"
                          //               ? GestureDetector(
                          //                   onTap: () {
                          //                     _addvisitorMobilenumberinput(
                          //                         context);
                          //                   },
                          //                   child: Column(
                          //                     children: <Widget>[
                          //                       Container(
                          //                           width: 50,
                          //                           height: 42,
                          //                           decoration: BoxDecoration(
                          //                               borderRadius:
                          //                                   BorderRadius.all(
                          //                                       Radius
                          //                                           .circular(
                          //                                               30)),
                          //                               color:
                          //                                   cnst.appPrimaryMaterialColor[
                          //                                       100]),
                          //                           child: Center(
                          //                               child: Icon(
                          //                             Icons.search,
                          //                             size: 27,
                          //                             color: cnst
                          //                                 .appPrimaryMaterialColor,
                          //                           ))),
                          //                       Text(
                          //                         "Search Visitor",
                          //                         style: TextStyle(
                          //                             fontSize: 11,
                          //                             fontWeight:
                          //                                 FontWeight.w600),
                          //                       )
                          //                     ],
                          //                   ),
                          //                 )
                          //               : Container(),
                          //           // GestureDetector(
                          //           //   onTap: () {
                          //           //     Navigator.pushNamed(
                          //           //         context, '/AddInvitedGuest');
                          //           //     //add new guest
                          //           //   },
                          //           //   child: Padding(
                          //           //     padding: const EdgeInsets.only(left: 8),
                          //           //     child: Column(
                          //           //       children: <Widget>[
                          //           //         Container(
                          //           //             width: 37,
                          //           //             height: 28,
                          //           //             decoration: BoxDecoration(
                          //           //                 borderRadius: BorderRadius.all(
                          //           //                     Radius.circular(30)),
                          //           //                 color:
                          //           //                 cnst.appPrimaryMaterialColor[
                          //           //                 100]),
                          //           //             child: Center(
                          //           //                 child: Icon(
                          //           //                   Icons.person_add,
                          //           //                   size: 30,
                          //           //                   color: cnst.appPrimaryMaterialColor,
                          //           //                 ))),
                          //           //         Text(
                          //           //           "Add Guest",
                          //           //           style: TextStyle(
                          //           //               fontSize: 11,
                          //           //               fontWeight: FontWeight.w600),
                          //           //         )
                          //           //       ],
                          //           //     ),
                          //           //   ),
                          //           // )
                          //         ],
                          //       )
                          //     : Container(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, right: 20, bottom: 10),
                            child: Container(
                                height: 28,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Color(0xff5946a8),
                                      style: BorderStyle.solid,
                                      width: 1),
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<ChapterClass>(
                                  hint: Text("${chapterName}"),
                                  value: __chapterCategoryClass,
                                  onChanged: (val) {
                                    setState(() {
                                      __chapterCategoryClass = val;
                                      chapterId = val.ChapterId.toString();
                                      getDashboardData(
                                          val.ChapterId.toString() == "null"
                                              ? "0"
                                              : val.ChapterId.toString(),
                                          sdate,
                                          edate);

                                      print(val.ChapterId);
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 10, color: Color(0xff5946a8)),
                                  items: _chapterCategory
                                      .map((ChapterClass groupclass) {
                                    return new DropdownMenuItem<ChapterClass>(
                                      value: groupclass,
                                      child: Text(
                                        groupclass.ChapterName,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                ))),
                          ),
                        ],
                      ),
                      _buildTableCalendar(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width / 4,
                            //   child: RaisedButton(
                            //       padding:
                            //           EdgeInsets.symmetric(horizontal: 20),
                            //       elevation: 5,
                            //       textColor: Colors.white,
                            //       color: Colors.deepPurple,
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.center,
                            //         children: <Widget>[
                            //           Icon(
                            //             Icons.share,
                            //             color: Colors.white,
                            //             size: 16,
                            //           ),
                            //           Padding(
                            //             padding:
                            //                 const EdgeInsets.only(left: 10),
                            //             child: Text(
                            //               "Share",
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.w600,
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       onPressed: () {
                            //         getCardId();
                            //         bool val = checkValidity();
                            //         Navigator.of(context).push(
                            //           PageRouteBuilder(
                            //             opaque: false,
                            //             pageBuilder:
                            //                 (BuildContext context, _, __) =>
                            //                     CardShareComponent(
                            //               memberId: cardid,
                            //               memberName: Name,
                            //               isRegular: val,
                            //               memberType: MemberType,
                            //               shareMsg: ShareMsg,
                            //               IsActivePayment: IsActivePayment,
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //       shape: new RoundedRectangleBorder(
                            //           borderRadius:
                            //               new BorderRadius.circular(30.0))),
                            // ),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width / 3.5,
                            //   child: RaisedButton(
                            //       padding:
                            //           EdgeInsets.symmetric(horizontal: 20),
                            //       elevation: 5,
                            //       textColor: Colors.white,
                            //       color: Colors.deepPurple,
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.center,
                            //         children: <Widget>[
                            //           Icon(
                            //             Icons.preview,
                            //             color: Colors.white,
                            //             size: 16,
                            //           ),
                            //           Padding(
                            //             padding:
                            //                 const EdgeInsets.only(left: 10),
                            //             child: Text(
                            //               "Preview",
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.w600,
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       onPressed: () async {
                            //         ontap += 1;
                            //         if (ontap == 1) {
                            //           getCardId();
                            //         }
                            //         String profileUrl = cnst.profileUrl
                            //             .replaceAll(
                            //                 "#id",
                            //                 cardid == null
                            //                     ? memberId
                            //                     : cardid);
                            //         if (await canLaunch(profileUrl)) {
                            //           await launch(profileUrl);
                            //         } else {
                            //           throw 'Could not launch $profileUrl';
                            //         }
                            //       },
                            //       shape: new RoundedRectangleBorder(
                            //           borderRadius:
                            //               new BorderRadius.circular(30.0))),
                            // ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 39,
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  elevation: 5,
                                  textColor: Colors.white,
                                  color: Colors.deepPurple,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.preview,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Invite Guest",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    Navigator.pushReplacementNamed(
                                        context, "/AddGuest");
                                    // ontap += 1;
                                    // if (ontap == 1) {
                                    //   getCardId();
                                    // }
                                    // String profileUrl = cnst.profileUrl
                                    //     .replaceAll(
                                    //         "#id",
                                    //         cardid == null
                                    //             ? memberId
                                    //             : cardid);
                                    // if (await canLaunch(profileUrl)) {
                                    //   await launch(profileUrl);
                                    // } else {
                                    //   throw 'Could not launch $profileUrl';
                                    // }
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ),
                          ],
                        ),
                      ),
                      // _buildTableCalendarWithBuilders(),
                      //const SizedBox(height: 8.0),
                      //Expanded(child: _buildEventList()),
                    ],
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: isLoading ? LoadinComponent() : Container()),
                ],
              ),
            );
    }
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      print(first);
      print(last);

      /*getDashboardData(chapterId == "null" ? "0" : chapterId,
          first.toString().substring(0, 10), last.toString().substring(0, 10));

      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );*/
    });
  }

  Widget _buildTableCalendar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.520,
      child: SingleChildScrollView(
        child: TableCalendar(
          //rowHeight: 2,
          locale: 'en_US',
          events: _visibleEvents,
          //holidays: _visibleHolidays,
          initialCalendarFormat: CalendarFormat.month,
          formatAnimation: FormatAnimation.slide,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableGestures: AvailableGestures.all,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
            /*CalendarFormat.twoWeeks: '2 weeks',
            CalendarFormat.week: 'Week',*/
          },
          calendarStyle: CalendarStyle(
            selectedColor: cnst.appPrimaryMaterialColor,
            todayColor: cnst.appPrimaryMaterialColor[200],
            markersColor: Colors.deepOrange,
            //markersMaxAmount: 7,
          ),
          headerStyle: HeaderStyle(
            formatButtonTextStyle:
                TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration(
              color: cnst.appPrimaryMaterialColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
        ),
      ),
    );
  }
}

class displayDateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(0.0, size.height - 42);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 70);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
