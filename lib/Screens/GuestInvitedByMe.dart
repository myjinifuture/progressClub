import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Component/GuestInvitedByMeComponents.dart';

class GuestInvitedByMe extends StatefulWidget {
  @override
  _GuestInvitedByMeState createState() => _GuestInvitedByMeState();
}

class _GuestInvitedByMeState extends State<GuestInvitedByMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Title(),
        ),
        /*body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return GuestInvitedByMeComponents();
        },
      ),*/
        body: Column(
          children: <Widget>[
            /*for (int i = 0; i < 4; i++) ...[GuestInvitedByMeComponents()]*/
          ],
        ));
  }
}

class Title extends StatelessWidget {
  const Title({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("My Guest Invites");
  }
}
