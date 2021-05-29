import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:intl/intl.dart';

class DailyProgressComponents extends StatefulWidget {
  var DailyProgress;
  double PreviusEffectiveness;

  DailyProgressComponents(this.DailyProgress, this.PreviusEffectiveness);

  @override
  _DailyProgressComponentsState createState() =>
      _DailyProgressComponentsState();
}

class _DailyProgressComponentsState extends State<DailyProgressComponents> {
  @override
  void initState() {
    print(widget.PreviusEffectiveness.toString());
    print(widget.DailyProgress["Effectiveness"].toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
      },
      child: Container(
        //padding: EdgeInsets.only(left: 8, right: 8),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      //height: 80,
                      //color: Colors.red,
                      //width: MediaQuery.of(context).size.width / 5,
                      width: 85,
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
                                  '${widget.DailyProgress["Date"].toString().substring(8, 10)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
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
                                  '${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.DailyProgress["Date"].toString().substring(0, 10)).toString()))},${widget.DailyProgress["Date"].substring(0, 4)}',
                                  style: TextStyle(
                                      fontSize: 13,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  color: Colors.blueAccent,
                                  //width: MediaQuery.of(context).size.width / 3.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Sale',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          '${cnst.Inr_Rupee} ${widget.DailyProgress["TodaySale"]}',
                                          style: TextStyle(
                                              color:
                                                  cnst.appPrimaryMaterialColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                *//*Container(
                                  color: Colors.green,
                                  //width: MediaQuery.of(context).size.width / 3,
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        'Effectiveness',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              '${widget.DailyProgress["Effectiveness"]}',
                                              style: TextStyle(
                                                  color: cnst
                                                      .appPrimaryMaterialColor,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            widget.PreviusEffectiveness >
                                                    widget.DailyProgress[
                                                        "Effectiveness"]
                                                ? Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.red,
                                                    size: 25,
                                                  )
                                                : Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.green,
                                                    size: 25,
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*//*
                              ],
                            ),*/
                            Container(
                              //width: MediaQuery.of(context).size.width / 3.5,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Sale',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      '${cnst.Inr_Rupee} ${widget.DailyProgress["TodaySale"]}',
                                      style: TextStyle(
                                          color:
                                          cnst.appPrimaryMaterialColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              'DailyTaskSheet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                widget.DailyProgress["DailyTaskSheet"]
                                            .toString() ==
                                        "true"
                                    ? 'Yes'
                                    : 'No',
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Effectiveness',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${widget.DailyProgress["Effectiveness"]}',
                                  style: TextStyle(
                                      color: cnst
                                          .appPrimaryMaterialColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                widget.PreviusEffectiveness >
                                    widget.DailyProgress[
                                    "Effectiveness"]
                                    ? Icon(
                                  Icons.arrow_downward,
                                  color: Colors.red,
                                  size: 25,
                                )
                                    : Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                  size: 25,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
