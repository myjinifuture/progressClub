import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/AttendanceComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'Attendance',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width / 4.5,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          Text(
                            "Date",
                            style: TextStyle(
                                fontSize: 17,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                  Expanded(
                    child: Container(
                        child: Text(
                      "Title",
                      style: TextStyle(
                          fontSize: 17,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    )),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder<List>(
                    future: Services.getAttenddance(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? snapshot.hasData
                              ? ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AttendanceComponents(
                                        snapshot.data[index]);
                                  },
                                )
                              : NoDataComponent()
                          : LoadinComponent();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
