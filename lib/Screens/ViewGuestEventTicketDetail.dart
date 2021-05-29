import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewGuestEventTicketDetail extends StatefulWidget {
  var eventData;

  ViewGuestEventTicketDetail({this.eventData});

  @override
  _ViewGuestEventTicketDetailState createState() =>
      _ViewGuestEventTicketDetailState();
}

class _ViewGuestEventTicketDetailState
    extends State<ViewGuestEventTicketDetail> {
  String memberId, memberName, memberMobile, memberEmail, qrCodeString;

  getlocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
      memberName = prefs.getString(Session.Name);
      memberEmail = prefs.getString(Session.Email);
      // memberMobile = prefs.getString(Session.Mobile);

      //print(memberName);
      qrCodeFun();
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

  qrCodeFun() {
    setState(() {
      qrCodeString = '''
  {
  "EventId": ${widget.eventData["Id"]},  
  "MemberId":${memberId},
  "EventName":${widget.eventData["EventName"]}
  "MobileNo":${widget.eventData["MobileNo"]}
  }
  ''';

      // qrCodeString = widget.eventData["Id"] +
      //     "," +
      //     memberId +
      //     "," +
      //     widget.eventData["EventName"] +
      //     "," +
      //     widget.eventData["MobileNo"];
    });
  }

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
        body: SingleChildScrollView(
          child: Padding(
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
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: QrImage(
                        data: qrCodeString,
                        version: QrVersions.auto,
                        size: 170.0,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 25.0),
                  //   child: Text(
                  //     "Order ID",
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
                  //     "1234567754324556",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: appPrimaryMaterialColor,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0),
                  //   child: Text(
                  //     "Ticket ID",
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
                  //     "1234567754324556",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: appPrimaryMaterialColor,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Purchased By",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appPrimaryMaterialColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "${memberName} On  ${month} ${date[0]}, ${date[2].toString().substring(0, 4)} ",
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
                ],
              ),
            ),
          ),
        ));
  }
}
