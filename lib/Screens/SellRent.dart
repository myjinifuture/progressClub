import 'dart:core';
import 'dart:io';

import 'package:custom_radio_button/radio_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/BedroomsComponent.dart';
import 'package:progressclubsurat_new/Component/PropertyTypeComponent.dart';
import 'package:progressclubsurat_new/Screens/SaleScreen.dart';

class SellRent extends StatefulWidget {
  String field;
  String isselected;
  int index;

  SellRent({this.field,this.index});

  @override
  _SellRentState createState() => _SellRentState();
}

//property type class
class Property {
  String pname;
  String picon;

  Property({this.pname, this.picon});
}

class _SellRentState extends State<SellRent> with TickerProviderStateMixin {
  TabController _tabController;
  String dropdownMin = '₹ Min';
  String dropdownMax = '₹ Max';

  bool isLoading = false;
  List<RadioModel> propertylistData = [];
  List<RadioModel> BedroomlistData = [];
  List sellrentArea = [];
  List propertyradio = [];
  List bedroom = [];
  List searchpropertylistdata = [];
  List<dynamic> propertytapped = [];
  List bedroomTapped = [];
  List<String> states = [];

  @override
  void dispose() {
    // TODO: implement dispose
    copyoffinalselection3 = null;
  }

  @override
  void initState() {
    super.initState();

    GetPropertyData();
    GetAreaData();
    GetBedroomData();
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
  }

  GetBedroomData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetPropertyData("Nature");
        res.then((data) async {
          if (data != "" && data.length > 0) {
            setState(() {
              isLoading = false;
              bedroom = data;
              print(bedroom.length);
              for(int i=0;i<bedroom.length;i++){
                String s1=bedroom[i]["FieldValue"].toString();
                BedroomlistData.add(new RadioModel(false,Icon(Icons.add),bedroom[i].toString(), Colors.purple));
              }
            });
          }
          else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  GetAreaData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetPropertyData("Area");
        res.then((data) async {
          if (data != "" && data.length > 0) {
            setState(() {
              isLoading = false;
              sellrentArea = data;
              for (int i = 0; i < sellrentArea.length; i++) {
                states.add(sellrentArea[i]['FieldValue']);
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  GetPropertyData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetPropertyData("PType");
        res.then((data) async {
          if (data != "" && data.length > 0) {
            setState(() {
              isLoading = false;
              propertyradio = data;
              print(propertyradio.length);
              for(int i=0;i<propertyradio.length;i++){
                String s1=propertyradio[i]["FieldValue"].toString();
               propertylistData.add(new RadioModel(false,Icon(Icons.add),propertyradio[i].toString(), Colors.purple));
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  List newsearchpropertydata = [];
  String copyofdropdownMin = "";
  String copyofdropdownMax = "";
  String fordropdownmin = "";
  String fordropdownmax=  "";
  String c = "";
  String removesignmin = "";
  String removesignmax = "";

  SearchProperty(List finaldata,List finalbeddata) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          searchdata = _typeAheadController.text;
          print("searchdata inside search property");
        });
        print(searchdata);
        copyofdropdownMin = dropdownMin;
        if (copyofdropdownMin == "₹ Min") {
          fordropdownmin = "0";
        }
        else{
          removesignmin = copyofdropdownMin.replaceAll("₹ ", "");
          fordropdownmin = removesignmin;
          print(fordropdownmin);
        }
        String removesignmin1= "";
        if(copyofdropdownMin.substring(copyofdropdownMin.length-3 , copyofdropdownMin.length)=="Lac"){
          removesignmin = copyofdropdownMin.replaceAll("₹ ", "");
          removesignmin1 = removesignmin.replaceRange(removesignmin.length-4 , removesignmin.length, "");
          print("after removing lac sign in min");
          fordropdownmin = removesignmin1;
          print(removesignmin1);
        }

        copyofdropdownMax = dropdownMax;
        if (copyofdropdownMax == "₹ Max") {
          fordropdownmax = "50000000";
        }
        else{
          removesignmax = copyofdropdownMax.replaceAll("₹ ", "");
          fordropdownmax = removesignmax;
          print(fordropdownmax);
        }

        String removesignmax1= "";
        if(copyofdropdownMax.substring(copyofdropdownMax.length-3 , copyofdropdownMax.length)=="Lac"){
          removesignmax = copyofdropdownMax.replaceAll("₹ ", "");
          removesignmax1 = removesignmax.replaceRange(removesignmax.length-4 , removesignmax.length, "");
          print("after removing lac sign in max");
          fordropdownmax = removesignmax1;
          print(removesignmax1);
        }

        String latestdata;
        if(finaldata.length!=0) {
          String df;
          String adddata = "";
          for (int i = 0; i < finaldata.length; i++) {
            df = finaldata[i];
            String addingvalues = df.replaceAll("FieldValue", "");
            copyoffinalselection = addingvalues.replaceAll("{", "");
            copyoffinalselection1 = copyoffinalselection.replaceAll("}", "");
            copyoffinalselection2 = copyoffinalselection1.replaceAll(": ", "");
            adddata += "'" + copyoffinalselection2 + "',";
          }

           latestdata = adddata.replaceRange(
              adddata.length - 1, adddata.length, "");
          print(latestdata);
        }
        else{
          latestdata = "";
        }

        String latestbeddata;
        if(finalbeddata.length!=0) {
          print("bedroom data length");
          print(finalbeddata.length);
          String df1;
          String adddata1 = "";
          for (int i = 0; i < finalbeddata.length; i++) {
            df1 = finalbeddata[i];
            String addingvalues = df1.replaceAll("FieldValue", "");
            copyoffinalselection3 = addingvalues.replaceAll("{", "");
            copyoffinalselection4 = copyoffinalselection3.replaceAll("}", "");
            copyoffinalselection5 = copyoffinalselection4.replaceAll(": ", "");
            adddata1 += "'" + copyoffinalselection5 + "',";
          }
           latestbeddata = adddata1.replaceRange(
              adddata1.length - 1, adddata1.length, "");
          print(latestbeddata);
        }
        else{
          latestbeddata="";
        }
        print(latestdata);
        print(latestbeddata);
        Future res = Services.SearchPropertyData(
            searchdata, latestdata, fordropdownmin, fordropdownmax, latestbeddata, "Sell");
        res.then((data) async {
          if (data != "" && data.length > 0) {
              isLoading = false;
              setState(() {
                searchpropertylistdata = data;
                newsearchpropertydata = searchpropertylistdata;
              });
              print("search new property data");
              print(newsearchpropertydata);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SaleScreen(
                            searchpropertylistdata:
                            newsearchpropertydata,
                          )));
          } else{
            showMsg("No Data Found");
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  SearchPropertyRent(List finaldata,List finalbeddata,{rentdata}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          searchdata = _typeAheadController.text;
          print("searchdata inside search property");
        });
        print(searchdata);
        copyofdropdownMin = dropdownMin;
        if (copyofdropdownMin == "₹ Min") {
          fordropdownmin = "0";
        }
        else{
          removesignmin = copyofdropdownMin.replaceAll("₹ ", "");
          fordropdownmin = removesignmin;
          print(fordropdownmin);
        }
        copyofdropdownMax = dropdownMax;
        if (copyofdropdownMax == "₹ Max") {
          fordropdownmax = "50000000";
        }
        else{
          removesignmax = copyofdropdownMax.replaceAll("₹ ", "");
          fordropdownmax = removesignmax;
          print(fordropdownmax);
        }

        String latestdata;
        if(finaldata.length!=0) {
          String df;
          String adddata = "";
          for (int i = 0; i < finaldata.length; i++) {
            df = finaldata[i];
            String addingvalues = df.replaceAll("FieldValue", "");
            copyoffinalselection = addingvalues.replaceAll("{", "");
            copyoffinalselection1 = copyoffinalselection.replaceAll("}", "");
            copyoffinalselection2 = copyoffinalselection1.replaceAll(": ", "");
            adddata += "'" + copyoffinalselection2 + "',";
          }

          latestdata = adddata.replaceRange(
              adddata.length - 1, adddata.length, "");
          print(latestdata);
        }
        else{
          latestdata = "";
        }

        String latestbeddata;
        if(finalbeddata.length!=0) {
          print("bedroom data length");
          print(finalbeddata.length);
          String df1;
          String adddata1 = "";
          for (int i = 0; i < finalbeddata.length; i++) {
            df1 = finalbeddata[i];
            String addingvalues = df1.replaceAll("FieldValue", "");
            copyoffinalselection3 = addingvalues.replaceAll("{", "");
            copyoffinalselection4 = copyoffinalselection3.replaceAll("}", "");
            copyoffinalselection5 = copyoffinalselection4.replaceAll(": ", "");
            adddata1 += "'" + copyoffinalselection5 + "',";
          }
          latestbeddata = adddata1.replaceRange(
              adddata1.length - 1, adddata1.length, "");
          print(latestbeddata);
        }
        else{
          latestbeddata="";
        }
        print(latestdata);
        print(latestbeddata);
        Future res = Services.SearchPropertyData(
            searchdata, latestdata, fordropdownmin, fordropdownmax, latestbeddata, "Rent");
        res.then((data) async {
          if (data != "" && data.length > 0) {
            isLoading = false;
            setState(() {
              searchpropertylistdata = data;
              newsearchpropertydata = searchpropertylistdata;
            });
            print("search new property data");
            print(newsearchpropertydata);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SaleScreen(
                          searchpropertylistdata:
                          newsearchpropertydata,
                        )));
          } else{
            showMsg("No Data Found");
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Progress Club"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _typeAheadController = TextEditingController();

  List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  bool ifselection = false;
  String searchdata = "";
  String whichistrue = "";
  String finalSelection = "";
  String copyoffinalselection = "";
  String copyoffinalselection1 = "";
  String copyoffinalselection2 = "";
  String copyoffinalselection3 = "";
  String copyoffinalselection4 = "";
  String copyoffinalselection5 = "";
  String copyoffinalselection6 = "";
  String copyoffinalselection7 = "";
  List finalselectionlist = [];
  List finalBedList = [];

  @override
  Widget build(BuildContext context) {
    newsearchpropertydata = searchpropertylistdata;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: Colors.white,
        buttonColor: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar:  widget.index==null ? AppBar(
          title: Text(
            'Filters',
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
        ) : null,
        body: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[400])),
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        unselectedLabelColor: cnst.appPrimaryMaterialColor,
                        labelColor: cnst.appPrimaryMaterialColor,
                        indicatorColor: cnst.appPrimaryMaterialColor,
                        labelPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.188),
                        tabs: [
                          Tab(
                            child: Text(
                              "SELL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "RENT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: TabBarView(
                      //contents
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          //sell code
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 10, right: 10),
                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Locality/Project/Landmark",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: cnst.appPrimaryMaterialColor),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 15.0),
                                //   child: Text(
                                //     "Search in a City,locality, project or Landmark",
                                //     style: TextStyle(
                                //       color: Colors.grey,
                                //     ),
                                //   ),
                                // ),
                                TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      decoration: InputDecoration(
                                          labelText:
                                              'Search in a City,locality, project or Landmark'),
                                      controller: this._typeAheadController,
                                          onTap: () {
                                        searchdata = _typeAheadController.text;
                                        print(searchdata);
                                          },
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await getSuggestions(pattern);
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this._typeAheadController.text =
                                          suggestion;
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 15),
                                  child: Divider(
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.my_location,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "Search Near Me",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, bottom: 10),
                                  child: Text(
                                    "Property Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                Container(
                                  height: 110,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: propertyradio.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top:8.0,right: 8),
                                          child: GestureDetector(
                                              onTap: () {
                                                if(propertylistData[index].isSelected==true){
                                                  setState(() {
                                                    propertylistData[index].isSelected = false;
                                                    whichistrue = propertylistData[index].text;
                                                    print("not selected");
                                                    print(whichistrue);
                                                  });
                                                }
                                                else {
                                                  setState(() {
                                                    propertylistData[index].isSelected = true;
                                                    whichistrue = propertylistData[index].text;
                                                    print("selected");
                                                    print(whichistrue);
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color: propertylistData[index].isSelected ? Colors.purple : Colors.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(color: Colors.grey[300]),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.home,size: 30, color: cnst.appPrimaryMaterialColor),
                                                      Text(
                                                        "${propertyradio[index]["FieldValue"]}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: !propertylistData[index].isSelected ? cnst.appPrimaryMaterialColor : Colors.white,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    "Budget",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 45,
                                        width: 160,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey[300])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                items: <String>[
                                                  '₹ Min',
                                                  '₹ 0',
                                                  '₹ 5000',
                                                  '₹ 10000',
                                                  '₹ 15000',
                                                  '₹ 20000',
                                                  '₹ 25000',
                                                  '₹ 30000',
                                                  '₹ 35000',
                                                  '₹ 40000',
                                                  '₹ 50000',
                                                  '₹ 60000',
                                                  '₹ 70000',
                                                  '₹ 85000',
                                                  '₹ 1 Lac',
                                                  '₹ 1.5 Lac',
                                                  '₹ 2 Lac',
                                                  '₹ 4 Lac',
                                                  '₹ 7 Lac',
                                                  '₹ 10 Lac',
                                                  '₹ 100 Lac',
                                                  '₹ 1000 Lac',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                                value: dropdownMin,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                onChanged: (String val) {
                                                  setState(() {
                                                    dropdownMin = val;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 45,
                                        width: 160,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey[300])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                items: <String>[
                                                  '₹ Max',
                                                  '₹ 0',
                                                  '₹ 5000',
                                                  '₹ 10000',
                                                  '₹ 15000',
                                                  '₹ 20000',
                                                  '₹ 25000',
                                                  '₹ 30000',
                                                  '₹ 35000',
                                                  '₹ 40000',
                                                  '₹ 50000',
                                                  '₹ 60000',
                                                  '₹ 70000',
                                                  '₹ 85000',
                                                  '₹ 1 Lac',
                                                  '₹ 1.5 Lac',
                                                  '₹ 2 Lac',
                                                  '₹ 4 Lac',
                                                  '₹ 7 Lac',
                                                  '₹ 10 Lac',
                                                  '₹ 100 Lac',
                                                  '₹ 1000 Lac',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                                value: dropdownMax,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                onChanged: (String val) {
                                                  setState(() {
                                                    dropdownMax = val;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, bottom: 10),
                                  child: Text(
                                    "BedRooms",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: bedroom.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top:8.0,right: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              if(BedroomlistData[index].isSelected==true){
                                                setState(() {
                                                  BedroomlistData[index].isSelected = false;
                                                  whichistrue = BedroomlistData[index].text;
                                                  print("not selected");
                                                  print(whichistrue);
                                                });
                                              }
                                              else {
                                                setState(() {
                                                  BedroomlistData[index].isSelected = true;
                                                  whichistrue = BedroomlistData[index].text;
                                                  print("selected");
                                                  print(whichistrue);
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: !BedroomlistData[index].isSelected ? Colors.white : Colors.purple,
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: Colors.grey[300]),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${bedroom[index]["FieldValue"]}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: !BedroomlistData[index].isSelected ? cnst.appPrimaryMaterialColor : Colors.white,),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Center(
                                    child: SizedBox(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      child: FlatButton(
                                        color: Colors.deepPurple,
                                        onPressed: () {
                                          for(int i=0;i<propertyradio.length;i++) {
                                            if(propertylistData[i].isSelected==true ){
                                              finalselectionlist.add(propertylistData[i].text);
                                            }
                                            else if (propertylistData[i].isSelected==true && finalselectionlist.contains("'" + BedroomlistData[i].text +"'" +",")){
                                              finalselectionlist.remove(propertylistData[i].text);
                                            }
                                             if (propertylistData[i].isSelected==false ){
                                              finalselectionlist.remove(propertylistData[i].text);
                                            }
                                          }

                                          for(int i=0;i<bedroom.length;i++) {
                                            if(BedroomlistData[i].isSelected==true ){
                                              finalBedList.add(BedroomlistData[i].text);
                                            }
                                            else if (BedroomlistData[i].isSelected==true && BedroomlistData.contains("'" + BedroomlistData[i].text +"'" +",")){
                                              finalBedList.remove(BedroomlistData[i].text);
                                            }
                                            if (BedroomlistData[i].isSelected==false ){
                                              finalBedList.remove(BedroomlistData[i].text);
                                            }
                                          }

                                          print("property list data");
                                          print(finalselectionlist);
                                          print("bedroom list data");
                                          print(finalBedList);
                                          SearchProperty(finalselectionlist,finalBedList);
                                          finalselectionlist= [];
                                          finalBedList = [];
                                        },
                                        child: Text(
                                          "Search",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 20),
                                  child: SizedBox(
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FlatButton(
                                          color: Colors.deepPurple,
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/PostProperty');
                                          },
                                          child: Text(
                                            "Post Property",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.035,
                                        ),
                                        FlatButton(
                                          color: Colors.deepPurple,
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/MyProperty');
                                          },
                                          child: Text(
                                            "My Property",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          //sell code
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 10, right: 10),
                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Locality/Project/Landmark",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: cnst.appPrimaryMaterialColor),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 15.0),
                                //   child: Text(
                                //     "Search in a City,locality, project or Landmark",
                                //     style: TextStyle(
                                //       color: Colors.grey,
                                //     ),
                                //   ),
                                // ),
                                TypeAheadField(
                                    textFieldConfiguration:
                                    TextFieldConfiguration(
                                      decoration: InputDecoration(
                                          labelText:
                                          'Search in a City,locality, project or Landmark'),
                                      controller: this._typeAheadController,
                                      onTap: () {
                                        searchdata = _typeAheadController.text;
                                        print(searchdata);
                                      },
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await getSuggestions(pattern);
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      this._typeAheadController.text =
                                          suggestion;
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 15),
                                  child: Divider(
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.my_location,
                                      size: 16,
                                      color: Colors.deepPurple,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "Search Near Me",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, bottom: 10),
                                  child: Text(
                                    "Property Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                Container(
                                  height: 110,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: propertyradio.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top:8.0,right: 8),
                                          child: GestureDetector(
                                              onTap: () {
                                                if(propertylistData[index].isSelected==true){
                                                  setState(() {
                                                    propertylistData[index].isSelected = false;
                                                    whichistrue = propertylistData[index].text;
                                                    print("not selected");
                                                    print(whichistrue);
                                                  });
                                                }
                                                else {
                                                  setState(() {
                                                    propertylistData[index].isSelected = true;
                                                    whichistrue = propertylistData[index].text;
                                                    print("selected");
                                                    print(whichistrue);
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color: propertylistData[index].isSelected ? Colors.purple : Colors.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(color: Colors.grey[300]),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.home,size: 30, color: cnst.appPrimaryMaterialColor),
                                                      Text(
                                                        "${propertyradio[index]["FieldValue"]}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: !propertylistData[index].isSelected ? cnst.appPrimaryMaterialColor : Colors.white,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    "Budget",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 45,
                                        width: 160,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey[300])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                items: <String>[
                                                  '₹ Min',
                                                  '₹ 0',
                                                  '₹ 5000',
                                                  '₹ 10000',
                                                  '₹ 15000',
                                                  '₹ 20000',
                                                  '₹ 25000',
                                                  '₹ 30000',
                                                  '₹ 35000',
                                                  '₹ 40000',
                                                  '₹ 50000',
                                                  '₹ 60000',
                                                  '₹ 70000',
                                                  '₹ 85000',
                                                  '₹ 1 Lac',
                                                  '₹ 1.5 Lac',
                                                  '₹ 2 Lac',
                                                  '₹ 4 Lac',
                                                  '₹ 7 Lac',
                                                  '₹ 10 Lac',
                                                  '₹ 100 Lac',
                                                  '₹ 1000 Lac',
                                                ].map<DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                isExpanded: true,
                                                value: dropdownMin,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                onChanged: (String val) {
                                                  setState(() {
                                                    dropdownMin = val;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 45,
                                        width: 160,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.grey[300])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                items: <String>[
                                                  '₹ Max',
                                                  '₹ 0',
                                                  '₹ 5000',
                                                  '₹ 10000',
                                                  '₹ 15000',
                                                  '₹ 20000',
                                                  '₹ 25000',
                                                  '₹ 30000',
                                                  '₹ 35000',
                                                  '₹ 40000',
                                                  '₹ 50000',
                                                  '₹ 60000',
                                                  '₹ 70000',
                                                  '₹ 85000',
                                                  '₹ 1 Lac',
                                                  '₹ 1.5 Lac',
                                                  '₹ 2 Lac',
                                                  '₹ 4 Lac',
                                                  '₹ 7 Lac',
                                                  '₹ 10 Lac',
                                                  '₹ 100 Lac',
                                                  '₹ 1000 Lac',
                                                ].map<DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                isExpanded: true,
                                                value: dropdownMax,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                onChanged: (String val) {
                                                  setState(() {
                                                    dropdownMax = val;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, bottom: 10),
                                  child: Text(
                                    "BedRooms",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: bedroom.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top:8.0,right: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              if(BedroomlistData[index].isSelected==true){
                                                setState(() {
                                                  BedroomlistData[index].isSelected = false;
                                                  whichistrue = BedroomlistData[index].text;
                                                  print("not selected");
                                                  print(whichistrue);
                                                });
                                              }
                                              else {
                                                setState(() {
                                                  BedroomlistData[index].isSelected = true;
                                                  whichistrue = BedroomlistData[index].text;
                                                  print("selected");
                                                  print(whichistrue);
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: !BedroomlistData[index].isSelected ? Colors.white : Colors.purple,
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: Colors.grey[300]),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${bedroom[index]["FieldValue"]}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: !BedroomlistData[index].isSelected ? cnst.appPrimaryMaterialColor : Colors.white,),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Center(
                                    child: SizedBox(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      child: FlatButton(
                                        color: Colors.deepPurple,
                                        onPressed: () {
                                          for(int i=0;i<propertyradio.length;i++) {
                                            if(propertylistData[i].isSelected==true ){
                                              finalselectionlist.add(propertylistData[i].text);
                                            }
                                            else if (propertylistData[i].isSelected==true && finalselectionlist.contains("'" + BedroomlistData[i].text +"'" +",")){
                                              finalselectionlist.remove(propertylistData[i].text);
                                            }
                                            if (propertylistData[i].isSelected==false ){
                                              finalselectionlist.remove(propertylistData[i].text);
                                            }
                                          }

                                          for(int i=0;i<bedroom.length;i++) {
                                            if(BedroomlistData[i].isSelected==true ){
                                              finalBedList.add(BedroomlistData[i].text);
                                            }
                                            else if (BedroomlistData[i].isSelected==true && BedroomlistData.contains("'" + BedroomlistData[i].text +"'" +",")){
                                              finalBedList.remove(BedroomlistData[i].text);
                                            }
                                            if (BedroomlistData[i].isSelected==false ){
                                              finalBedList.remove(BedroomlistData[i].text);
                                            }
                                          }

                                          print("property list data");
                                          print(finalselectionlist);
                                          print("bedroom list data");
                                          print(finalBedList);
                                          SearchPropertyRent(finalselectionlist,finalBedList);
                                          finalselectionlist= [];
                                          finalBedList = [];
                                        },
                                        child: Text(
                                          "Search",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 20),
                                  child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FlatButton(
                                          color: Colors.deepPurple,
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/PostProperty');
                                          },
                                          child: Text(
                                            "Post Property",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),

                                        FlatButton(
                                          color: Colors.deepPurple,
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/MyProperty');
                                          },
                                          child: Text(
                                            "My Property",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
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
            ),
          ],
        ),
      ),
    );
  }
}
