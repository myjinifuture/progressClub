import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GuestWebViewPayment.dart';

class GuestEventRegistration extends StatefulWidget {
  var eventData, memberId;
  GuestEventRegistration({this.eventData, this.memberId});
  @override
  _GuestEventRegistrationState createState() => _GuestEventRegistrationState();
}

class _GuestEventRegistrationState extends State<GuestEventRegistration> {
  String memberId, memberName, memberMobile, memberEmail, qrCodeString;

  getlocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      memberName = prefs.getString(Session.Name);
      memberEmail = prefs.getString(Session.Email);
      // memberMobile = prefs.getString(Session.Mobile);

      //print(memberName);
    });
  }

  String dateData;
  List<String> date;
  String month;

  @override
  funDate() {
    dateData = " ${widget.eventData["EventDate"]}";
    date = dateData.split('/');
    print("-------------------->${date}");
    funMonth("${date[1]}");
  }

  funMonth(String mon) {
    if (mon == "01") {
      month = "Jan";
    } else if (mon == "02") {
      month = "Feb";
    } else if (mon == "03") {
      month = "March";
    } else if (mon == "04") {
      month = "April";
    } else if (mon == "05") {
      month = "May";
    } else if (mon == "06") {
      month = "June";
    } else if (mon == "07") {
      month = "July";
    } else if (mon == "08") {
      month = "Aug";
    } else if (mon == "09") {
      month = "Sept";
    } else if (mon == "10") {
      month = "Oct";
    } else if (mon == "11") {
      month = "Nov";
    } else if (mon == "12") {
      month = "Dec";
    } else {
      month = "";
    }
  }

  // qrCodeFun() {
  //   setState(() {
  //     qrCodeString = '''
  // {
  // "EventId": ${widget.eventData["Id"]},
  // "MemberId":${memberId},
  // "EventName":${widget.eventData["EventName"]}
  // "MobileNo":${widget.eventData["MobileNo"]}
  // }
  // ''';
  //
  //     // qrCodeString = widget.eventData["Id"] +
  //     //     "," +
  //     //     memberId +
  //     //     "," +
  //     //     widget.eventData["EventName"] +
  //     //     "," +
  //     //     widget.eventData["MobileNo"];
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    getlocaldata();
    funDate();
    //qrCodeFun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: appPrimaryMaterialColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    // borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset("images/logo.jpg",
                            width: 130.0, height: 130.0, fit: BoxFit.contain),
                      ),
                      Text(
                        "${widget.eventData["EventName"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${month} ${date[0]}, ${date[2].toString().substring(0, 4)} , ${widget.eventData["EventStartTime"].toString().substring(0, 5)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text(
                          "${memberName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      memberEmail == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "${memberEmail}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: appPrimaryMaterialColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Event Fee",
                          style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "₹ ${widget.eventData["EventFee"]}",
                        style: TextStyle(
                          color: appPrimaryMaterialColor,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 15, right: 15),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Text(
                          "Event Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 15, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 6.0, bottom: 10),
                              child: Text(
                                " On  ${month} ${date[0]}, ${date[2].toString().substring(0, 4)} ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: appPrimaryMaterialColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 10.0),
                              child: Text(
                                "Event Time",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: appPrimaryMaterialColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Start Time",
                                      style: TextStyle(
                                          color: appPrimaryMaterialColor[500],
                                          fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        // "12.00 pm",
                                        "${widget.eventData["EventStartTime"].toString().substring(0, 5)}",
                                        style: TextStyle(
                                            color: appPrimaryMaterialColor,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "End Time",
                                        style: TextStyle(
                                            color: appPrimaryMaterialColor[500],
                                            fontSize: 14),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Text(
                                          //"4:00 pm",
                                          "${widget.eventData["EventEndTime"].toString().substring(0, 5)}",
                                          style: TextStyle(
                                              color: appPrimaryMaterialColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   child: Text(
                      //     "Purchased By",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       color: appPrimaryMaterialColor,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 5.0),
                      //   child: Text(
                      //     "${memberName} On  ${month} ${date[0]}, ${date[2].toString().substring(0, 4)} ",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       color: appPrimaryMaterialColor,
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Event Venue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                        child: Text(
                          "${widget.eventData["EventVenue"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appPrimaryMaterialColor,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Center(
                              child: Container(
                                height: 40,
                                width: 150,
                                child: FlatButton(
                                    color: appPrimaryMaterialColor,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new GuestWebViewPayment(
                                                    //searchData: txtSearch.text,
                                                    data: widget.eventData,
                                                  )));
                                    },
                                    child: Text(
                                      "Pay Now",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: 100,
              //   width: MediaQuery.of(context).size.width,
              //   color: appPrimaryMaterialColor,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(left: 8.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 "${memberName}",
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 20),
              //               ),
              //               Text(
              //                 "${widget.eventData["MobileNo"]}",
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 20),
              //               ),
              //               // Text(
              //               //   "apirt@1234gmail.com",
              //               //   style:
              //               //       TextStyle(color: Colors.white, fontSize: 15),
              //               // ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(right: 8.0),
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(50),
              //             child: Image.asset("images/logo.jpg",
              //                 //width: 200.0, height: 200.0,
              //                 fit: BoxFit.contain),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width - 20,
              //     height: MediaQuery.of(context).size.height - 210,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       color: Colors.white,
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding:
              //               const EdgeInsets.only(top: 20.0, left: 8, right: 8),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Expanded(
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(top: 20.0),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         "${widget.eventData["EventName"]}",
              //                         style: TextStyle(
              //                             color: appPrimaryMaterialColor,
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 18),
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.only(top: 8.0),
              //                         child: Text(
              //                           "Event Fee",
              //                           style: TextStyle(
              //                               color: appPrimaryMaterialColor[500],
              //                               fontSize: 14),
              //                         ),
              //                       ),
              //                       Text(
              //                         "₹ ${widget.eventData["EventFee"]}",
              //                         style: TextStyle(
              //                             color: appPrimaryMaterialColor,
              //                             fontSize: 16),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //               // Container(
              //               //   decoration: BoxDecoration(
              //               //     border: Border.all(
              //               //       color: appPrimaryMaterialColor,
              //               //       width: 3,
              //               //     ),
              //               //     borderRadius: BorderRadius.circular(12),
              //               //   ),
              //               //   child: QrImage(
              //               //     data: "rinki",
              //               //     version: QrVersions.auto,
              //               //     size: 150.0,
              //               //   ),
              //               // ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Divider(),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 8.0, right: 15),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "Event Date",
              //                       style: TextStyle(
              //                           color: appPrimaryMaterialColor[500],
              //                           fontSize: 14),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 6.0),
              //                       child: Text(
              //                         //"12 Jan 2020",
              //                         "${widget.eventData["EventDate"]}",
              //                         style: TextStyle(
              //                             color: appPrimaryMaterialColor,
              //                             fontSize: 16),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "Start Time",
              //                       style: TextStyle(
              //                           color: appPrimaryMaterialColor[500],
              //                           fontSize: 14),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 6.0),
              //                       child: Text(
              //                         // "12.00 pm",
              //                         "${widget.eventData["EventStartTime"].toString().substring(0, 5)}",
              //                         style: TextStyle(
              //                             color: appPrimaryMaterialColor,
              //                             fontSize: 16),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "End Time",
              //                       style: TextStyle(
              //                           color: appPrimaryMaterialColor[500],
              //                           fontSize: 14),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 6.0),
              //                       child: Text(
              //                         //"4:00 pm",
              //                         "${widget.eventData["EventEndTime"].toString().substring(0, 5)}",
              //                         style: TextStyle(
              //                             color: appPrimaryMaterialColor,
              //                             fontSize: 16),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Divider(),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 8.0, right: 10),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 "Event Venue",
              //                 style: TextStyle(
              //                     color: appPrimaryMaterialColor[500],
              //                     fontSize: 14),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.only(
              //                     top: 10.0, left: 10, right: 10),
              //                 child: Center(
              //                   child: Text(
              //                     // "310-311 Avadh Utopia , Marigold , GroundFloor , Opp airport , Dumas Road , Surat , Gujrat-39455o,India",
              //                     "${widget.eventData["EventVenue"]}",
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                         color: appPrimaryMaterialColor,
              //                         fontSize: 15),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Divider(),
              //         ),
              //         Align(
              //           alignment: Alignment.bottomCenter,
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 30.0),
              //             child: Center(
              //               child: Container(
              //                 height: 40,
              //                 width: 150,
              //                 child: FlatButton(
              //                     color: appPrimaryMaterialColor,
              //                     onPressed: () {
              //                       Navigator.push(
              //                           context,
              //                           MaterialPageRoute(
              //                               builder: (BuildContext context) =>
              //                                   new GuestWebViewPayment(
              //                                     //searchData: txtSearch.text,
              //                                     data: widget.eventData,
              //                                   )));
              //                     },
              //                     child: Text(
              //                       "Pay Now",
              //                       style: TextStyle(
              //                           color: Colors.white, fontSize: 18),
              //                     )),
              //               ),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
