import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flare_flutter/cache.dart';
import 'package:flare_flutter/cache_asset.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_cache_asset.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare_render_box.dart';
import 'package:flare_flutter/flare_testing.dart';
//import 'package:flare_flutter/trim_path.dart';

import 'Dashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.Session.MemberId);
      String veri = prefs.getString(cnst.Session.VerificationStatus);

      String memberType = prefs.getString(cnst.Session.Type);
      if (MemberId != null && MemberId != "" && veri == "1")
        Navigator.pushReplacementNamed(context, '/Dashboard');
      /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(memberType: memberType)),
        );*/
      else {
        Navigator.pushReplacementNamed(context, '/Login');
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/logo.jpg",
                  width: 200.0, height: 200.0, fit: BoxFit.contain),

              // Container(
              //     height: 150,
              //     width: 150,
              //     child:

              // FlareActor(
              //   "assets/ProgressClub.flr",
              //   alignment: Alignment.center,
              //   fit: BoxFit.contain,
              //   animation: "pcgrow",
              // ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 0.0),
                child: Text(
                  'Progress Club',
                  style: TextStyle(
                      color: cnst.secondaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700
                      //fontSize: 18.0,
                      ),
                ),
              )
            ],
          ),
        ));
  }
}
