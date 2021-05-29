import 'dart:io';

import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';

//Componnets Dart File
import 'package:progressclubsurat_new/Component/MultipleEventListComponents.dart';
import 'package:progressclubsurat_new/Component/MultipleEventListMeetingComponents.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';

class MultipleEventList extends StatefulWidget {
  final String date, chapterId, memberId, meetingId;

  const MultipleEventList(
      {Key key, this.date, this.chapterId, this.memberId, this.meetingId})
      : super(key: key);

  @override
  _MultipleEventListState createState() => _MultipleEventListState();
}

class _MultipleEventListState extends State<MultipleEventList> {
  bool isLoading = false;
  List listMeeting = new List();
  List listEvent = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.date);
    getMeetingFromServer();
    getEventFromServer();
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

  getMeetingFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetMeetingListByDate(
            widget.chapterId == "null" || widget.chapterId == ""
                ? "0"
                : widget.chapterId,
            widget.date);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              listMeeting = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          showMsg("Try Again.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }

  getEventFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetEventByDate(
            widget.chapterId == "null" ? "0" : widget.chapterId, widget.date);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              listEvent = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          showMsg("Try Again.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/Dashboard');
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Meetings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    'Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            title: Text(
              'Schedule List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/Dashboard');
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    //Make ListView
                    isLoading
                        ? Container(
                            height: MediaQuery.of(context).size.height - 135,
                            width: MediaQuery.of(context).size.width,
                            child: LoadinComponent(),
                          )
                        : listMeeting.length > 0
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.3,
                                margin: EdgeInsets.only(top: 10),
                                //height: MediaQuery.of(context).size.height - 75,
                                width: MediaQuery.of(context).size.width,
                                child: Swiper(
                                  itemHeight: 500,
                                  autoplay: false,
                                  loop: false,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MultipleEventListMeetingComponents(
                                        data: listMeeting[index],
                                        memberId: widget.memberId,
                                        MeetingId: widget.meetingId != null
                                            ? widget.meetingId
                                            : listMeeting[index]["Id"]
                                                .toString(),
                                        TitleLabel: "Event");
                                  },
                                  itemCount: listMeeting.length,
                                  pagination: new SwiperPagination(
                                      builder: DotSwiperPaginationBuilder(
                                          color: Colors.grey[300],
                                          activeColor:
                                              cnst.appPrimaryMaterialColor)),
                                  //control: new SwiperControl(),
                                  viewportFraction: 0.85,
                                  scale: 0.9,
                                ),
                              )
                            : NoDataComponent()
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Make ListView
                      isLoading
                          ? Container(
                              height: MediaQuery.of(context).size.height - 135,
                              width: MediaQuery.of(context).size.width,
                              child: LoadinComponent(),
                            )
                          : listEvent.length > 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  margin: EdgeInsets.only(top: 10),
                                  //height: MediaQuery.of(context).size.height - 75,
                                  width: MediaQuery.of(context).size.width,
                                  child: Swiper(
                                    itemHeight: 500,
                                    autoplay: false,
                                    loop: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return MultipleEventListMeetingComponents(
                                          data: listEvent[index],
                                          memberId: widget.memberId,
                                          MeetingId: widget.meetingId != null
                                              ? widget.meetingId
                                              : listEvent[index]["Id"]
                                                  .toString(),
                                          TitleLabel: "Event");
                                    },
                                    itemCount: listEvent.length,
                                    pagination: new SwiperPagination(
                                      builder: DotSwiperPaginationBuilder(
                                          color: Colors.grey[300],
                                          activeColor:
                                              cnst.appPrimaryMaterialColor),
                                    ),
                                    viewportFraction: 0.85,
                                    scale: 0.9,
                                  ),
                                )
                              : NoDataComponent()
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
