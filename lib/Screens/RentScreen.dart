import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class RentScreen extends StatefulWidget {
  @override
  _RentScreenState createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  String dropdownType = 'Property Type';
  String dropdownCarpetArea = 'Sqft';
  String dropdownPriority = 'Priority';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: Colors.white,
        buttonColor: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Rent',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                    Icons.local_library,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[350],
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.grey,
//                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 70,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Sort &\n Filter",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 90,
                                  height: 35,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Budget",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color:
                                            cnst.appPrimaryMaterialColor),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 70,
                                  height: 35,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "BHK",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color:
                                            cnst.appPrimaryMaterialColor),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 80,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "Verified",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 80,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "Owner",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 100,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "Furnished",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 110,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "With Photos",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 80,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "For Family",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 100,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "For Bachelors",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 80,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "Exclusive",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 8.0, right: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.grey[400]),
                                  ),
                                  width: 100,
                                  height: 35,
                                  child: Center(
                                      child: Text(
                                        "Most Recent",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: cnst.appPrimaryMaterialColor),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 8.0, top: 5, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.grey,
//                            border: Border.all(color: Colors.grey[400]),
                          ),
                          width: 50,
                          child: Center(
                              child: Icon(
                                Icons.tune,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 7),
                    itemBuilder: (BuildContext Context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "PROGRESSCLUB EXCLUSIVE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.green),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        "https://img.staticmb.com/mbphoto/property/cropped_images/2020/Feb/22/Photo_h300_w450/48245597_1_PropertyImage372-0894901168542_300_450.jpg",
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 100,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        Text(
                                          "East Facing Property",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0,left: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("₹ 68 Lac",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: cnst
                                                            .appPrimaryMaterialColor,
                                                        fontSize: 15)),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:3.0),
                                                  child: Text(
                                                    "Rent",
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left:8.0,right: 8),
                                              child: Container(
                                                width: 1,
                                                height: 30,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  "₹ 1 Monthly",
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 13),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:3.0),
                                                  child: Text(
                                                    "Maintenance",
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                  top: 15,
                                                  bottom: 2),
                                              child: Text("3 BHK House",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[700])),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0,top: 10,
                                                  bottom: 2),
                                              child: Text("975 sqft",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: cnst
                                                          .appPrimaryMaterialColor)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Udhana, Surat ",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text("0.8 Km away",
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, right: 8, bottom: 8),
                                          child: Row(
                                            children: <Widget>[
                                              Text("3 Bath",
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 12)),
                                              Padding(
                                                padding: const EdgeInsets.only(left:5.0,right: 5),
                                                child: Icon(Icons.brightness_1,color: Colors.grey[300],size: 5,),
                                              ),
                                              Text("Semi-Furnished",
                                                  style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                    width:
                                    MediaQuery.of(context).size.width - 200,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
//                                      color: Colors.deepPurple,
                                      onPressed: () {

                                      },
                                      child: Text(
                                        "Search",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width:
                                    MediaQuery.of(context).size.width - 200,
                                    child: FlatButton(
                                      color: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
//                                      color: Colors.deepPurple,
                                      onPressed: () {},
                                      child: Row(
                                        children: <Widget>[
//                                          SizedBox(
//                                              child: Image.asset(
//                                                  "assets/whatsapp1.png")),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0,right: 5),
                                            child: Icon(Icons.call,color: Colors.white,
                                              size: 18,),
                                          ),
                                          Text(
                                            "Call Owner",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
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
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
