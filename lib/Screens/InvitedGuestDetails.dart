import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvitedGuestDetails extends StatefulWidget {
  @override
  _InvitedGuestDetailsState createState() => _InvitedGuestDetailsState();
}

class _InvitedGuestDetailsState extends State<InvitedGuestDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Guest-Meeting Detail"),
        ),
        body: Column(children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 5),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage("images/icon_user.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(new Radius.circular(75.0)),
              ),
            ),
          ),
          Text("Sagar Patel",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.phone, size: 30),
              SizedBox(width: 75),
              Image.asset(
                "images/whatsapp.png",
                height: 40,
                width: 40,
              )
            ],
          ),
          SizedBox(height: 25),
          /* for (int i = 0; i < 3; i++) ...[Meeting(i: i)]*/
        ]));
  }
}

class Meeting extends StatelessWidget {
  const Meeting({
    Key key,
    @required this.i,
  }) : super(key: key);

  final int i;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Meeting ${i + 1}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 3),
              child: Text("21 February, 2020", style: TextStyle(fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 3),
              child:
                  Text("Testing Progress Club", style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
