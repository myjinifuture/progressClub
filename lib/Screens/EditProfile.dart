import 'package:flutter/material.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:avatar_glow/avatar_glow.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/MemberProfile');
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Make Custom App Bar
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.only(left: 10),
                  //color: Colors.black,
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/MemberProfile');
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: cnst.appPrimaryMaterialColor,
                            size: 25,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 17),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width - 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          color: cnst.appPrimaryMaterialColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Update',
                                      style: TextStyle(
                                          color: cnst.appPrimaryMaterialColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //Make Design
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[
                      /*ClipOval(
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/9/9c/Hrithik_at_Rado_launch.jpg',
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                      ),*/

                      Stack(
                        children: <Widget>[
                          AvatarGlow(
                            startDelay: Duration(milliseconds: 1000),
                            glowColor: cnst.appPrimaryMaterialColor,
                            endRadius: 80.0,
                            duration: Duration(milliseconds: 2000),
                            repeat: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                child: ClipOval(
                                  child: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/9/9c/Hrithik_at_Rado_launch.jpg',
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                radius: 50.0,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 100, top: 100),
                              child: Image.asset(
                                'images/plus.png',
                                width: 25,
                                height: 25,
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          'Denish Ubhal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: cnst.appPrimaryMaterialColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        'IT Futurz',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 50),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 20, bottom: 20),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    'images/icn_earth.png',
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: "Denish.com"),
                                        scrollPadding: EdgeInsets.all(0),
                                        decoration: InputDecoration(
                                            labelText: "Website",
                                            labelStyle: TextStyle(
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                            hintText: "Website"),
                                        //enabled: false,
                                        minLines: 1,
                                        maxLines: 2,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.mail,
                                    size: 30,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: "Denish@gmail.com"),
                                        scrollPadding: EdgeInsets.all(0),
                                        decoration: InputDecoration(
                                            labelText: "Email",
                                            labelStyle: TextStyle(
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                            hintText: "Email"),
                                        //enabled: false,
                                        minLines: 1,
                                        maxLines: 2,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: "86 Ramnagar"),
                                        scrollPadding: EdgeInsets.all(0),
                                        decoration: InputDecoration(
                                            labelText: "Address",
                                            labelStyle: TextStyle(
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                            hintText: "Address"),
                                        //enabled: false,
                                        minLines: 1,
                                        maxLines: 4,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
