import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class TaskComponents extends StatefulWidget {
  @override
  _TaskComponentsState createState() => _TaskComponentsState();
}

class _TaskComponentsState extends State<TaskComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: cnst.appcolor)),
          side: BorderSide(width: 0.10, color: cnst.appPrimaryMaterialColor),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Creating a proposal',
                style: TextStyle(
                    fontSize: 18, color: cnst.appPrimaryMaterialColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/2.7,
                          margin: EdgeInsets.only(top: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: Colors.green,
                            minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              //if (isLoading == false) this.SaveOffer();
                              //Navigator.pushReplacementNamed(context, '/Dashboard');
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/2.7,
                          margin: EdgeInsets.only(top: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: Colors.red,
                            minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              //if (isLoading == false) this.SaveOffer();
                              //Navigator.pushReplacementNamed(context, '/Dashboard');
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
