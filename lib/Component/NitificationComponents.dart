import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class NitificationComponents extends StatefulWidget {
  var notification;
  NitificationComponents(this.notification);
  @override
  _NitificationComponentsState createState() => _NitificationComponentsState();
}

class _NitificationComponentsState extends State<NitificationComponents> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
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
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
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
                                  '${widget.notification["Date"].toString().substring(8, 10)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 7, bottom: 7, left: 5, right: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 0.5),
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
                                  '${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.notification["Date"].toString().substring(0,10)).toString()))},${widget.notification["Date"].substring(0, 4)}',
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
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.notification["Title"]}',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.notification["Description"]}',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
