import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/MultipleEventList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestEventListComponent extends StatefulWidget {
  var EventData;

  GuestEventListComponent({this.EventData});

  @override
  _GuestEventListComponentState createState() =>
      _GuestEventListComponentState();
}

class _GuestEventListComponentState extends State<GuestEventListComponent> {
  String memberId;

  getlocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);

      //print(memberName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocaldata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //height: 80,
              //color: Colors.red,
              width: MediaQuery.of(context).size.width / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(7),
                            topLeft: Radius.circular(7)),
                        color: cnst.appPrimaryMaterialColor),
                    //height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${widget.EventData["startdate"].toString().substring(8, 10)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 7, bottom: 7, left: 5, right: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                        color: Colors.white),
                    // color: Colors.black,
                    //height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.EventData["startdate"].toString().substring(0, 10)).toString()))},${widget.EventData["startdate"].substring(0, 4)}',
                          style: TextStyle(
                              fontSize: 11,
                              color: cnst.appPrimaryMaterialColor,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.EventData["Title"]}",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text("${widget.EventData["PCName"]}",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          widget.EventData["status"] == "Coming"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        if (widget.EventData["Link"] == "") {
                          Fluttertoast.showToast(
                              msg: "link is not Available",
                              textColor: Colors.white,
                              backgroundColor: Colors.redAccent);
                        } else {
                          launch("${widget.EventData["Link"]}");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.video_call,
                                  color: Colors.white, size: 18),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  "Join",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultipleEventList(
                              chapterId: "0",
                              date: widget.EventData["startdate"],
                              meetingId: widget.EventData["meetingId"],
                              memberId: memberId,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: cnst.appPrimaryMaterialColor),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      )),
                )
          //Text("${widget.EventData["EventList"][0]["name"]}")
        ],
      ),
    );
  }
}
