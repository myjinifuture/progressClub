import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/TaskList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentsComponents extends StatefulWidget {
  var list;

  AssignmentsComponents(this.list);

  @override
  _AssignmentsComponentsState createState() => _AssignmentsComponentsState();
}

class _AssignmentsComponentsState extends State<AssignmentsComponents> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskList(
                    list: widget.list,
                    meetingId: widget.list["Id"].toString())));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(width: 0.50, color: cnst.appPrimaryMaterialColor),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 160,
                      child: Text('${widget.list["Title"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                    Text(
                      '${widget.list["Start_Date"].substring(8, 10)}-'
                      "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.list["Start_Date"].substring(0, 10)).toString()))}-${widget.list["Start_Date"].substring(0, 4)}",
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Divider(
                    color: Colors.grey,
                    height: 3,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  padding: EdgeInsets.only(top: 5),
                  //color: Colors.cyan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${widget.list["Total"]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Completed',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${widget.list["Completed"]}',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Pending',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${widget.list["Pending"]}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
