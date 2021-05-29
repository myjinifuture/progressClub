import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestInvitedByMeComponents extends StatefulWidget {
  @override
  _GuestInvitedByMeComponentsState createState() =>
      _GuestInvitedByMeComponentsState();
}

class _GuestInvitedByMeComponentsState
    extends State<GuestInvitedByMeComponents> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/InvitedGuestDetails');
      },
      child: Card(
          elevation: 2,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, bottom: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: AssetImage("images/icon_user.png"),
                            fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.all(new Radius.circular(75.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Sagar Patel",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(81, 92, 111, 1))),
                          Text("8469577989",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700])),
                          Text("3 Meetings",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.green[700],
                      ),
                      onPressed: () {
                        launch("tel:+918469577989");
                      }),
                ],
              ),
            ],
          )),
    );
  }
}
