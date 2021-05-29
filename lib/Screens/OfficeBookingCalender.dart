import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Screens/OfficeBookingDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class OfficeBookingCalender extends StatefulWidget {
  @override
  _OfficeBookingCalenderState createState() => _OfficeBookingCalenderState();
}

final Map<DateTime, List> _holidays = {
  /*DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],*/
};

class _OfficeBookingCalenderState extends State<OfficeBookingCalender>
    with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  int _currentIndex = 0;

  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;
  String barcode = "", currentDay = "";
  var currentMoth = "", curentYear = "";

  TextEditingController _MobileNumberInput = TextEditingController();

  static var now = new DateTime.now();
  var date = new DateFormat("yyyy-MM-dd").format(now);

  String sdate = "", edate = "";
  ProgressDialog pr;
  bool isLoading = false;

  String memberId = "";

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
    getLocalData();
    _controller.forward();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      //print(memberName);
    });

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

    sdate = parsedDate.add(Duration(days: -6)).toString().substring(0, 10);
    edate = lastDayDateTime.add(Duration(days: 6)).toString().substring(0, 10);

    getDashboardData(sdate, edate);
  }

  getDashboardData(String sdate, String edate) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetOfficeBookingCalender(sdate, edate);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              //list = data;
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
          'Office Booking',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: _buildTableCalendar(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0)),
                  color: cnst.appPrimaryMaterialColor,
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    Navigator.pushNamed(context, '/MyOfficeBooking');
                  },
                  child: Text(
                    "My Bookings",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      print(first);
      print(last);

      getDashboardData(
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
      );
    });
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
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
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onDaySelected: _onDaySelected,
    );
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
    String selectedDate = day.toString().substring(0, 10);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfficeBookingDetails(
          date: selectedDate,
          memberId: memberId,
        ),
      ),
    );

    /*ifx (events.length == 1) {
      showEventDialog(_selectedEvents);
    } else if (events.length > 1) {
      Navigator.pushNamed(context, '/MultipleEventList');
    }*/
  }
}
