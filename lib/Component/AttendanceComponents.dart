import 'package:flutter/material.dart';

class AttendanceComponents extends StatefulWidget {
  var attendance;

  AttendanceComponents(this.attendance);

  @override
  _AttendanceComponentsState createState() => _AttendanceComponentsState();
}

class _AttendanceComponentsState extends State<AttendanceComponents> {
  String day="",month="",year="";
  String setData(){
    var dobAy;
    if (widget.attendance["Date"] != "" || widget.attendance["Date"] != null) {
      dobAy = widget.attendance["Date"].toString().split("/");
    }

    setState(() {
      day=dobAy[1].toString();
      month=dobAy[0].toString();
      year=dobAy[2].toString().substring(0,4);
    });

    return "${day}-${month}-${year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width / 4.5,
              child: Text("${setData()}")),
          Expanded(
            child: Container(
                child: Text("${widget.attendance["MeetingName"]}",
                    softWrap: true,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
          ),
          Container(
              width: MediaQuery.of(context).size.width / 5,
              child: Text("${widget.attendance["Status"]}",
                  style: TextStyle(
                      color: widget.attendance["Status"] == "Present"
                          ? Colors.green
                          : widget.attendance["Status"] == "Absent"
                              ? Colors.red
                              : Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))),
        ],
      ),
    );
  }
}
