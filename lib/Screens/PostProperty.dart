import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Screens/MultipleImagePicker.dart';
import 'package:progressclubsurat_new/Screens/MyProperty.dart';

class PostProperty extends StatefulWidget {
  List Data= [];
  int index;
   bool selected = true;
  int currentindex;
  PostProperty({this.Data,this.index,this.selected,this.currentindex});
  @override
  _PostPropertyState createState() => _PostPropertyState();
}

class _PostPropertyState extends State<PostProperty>
    with TickerProviderStateMixin {

  TabController _tabController;

  String dropdownType;
  String dropdownCarpetArea;
  String dropdownPriority;
  String dropdownPtype;
  String dropdownsalerent;

  List<String> Naturelist = [];
  List<String> Ptyelist = [];
  List<String> unitcarpetarea = [];
  List<String> prioritylist = [];


  bool isLoading = false;
  TextEditingController edtAddressController = new TextEditingController();
  TextEditingController edtLocationController = new TextEditingController();
  TextEditingController edtCarpetAreaController = new TextEditingController();
  TextEditingController edtPriceController = new TextEditingController();
  TextEditingController edtGoogleMapController = new TextEditingController();
  TextEditingController edtAdditionalDesController = new TextEditingController();
  TextEditingController priorityController = new TextEditingController();
  TextEditingController unitofcarpetController = new TextEditingController();


  //rent


  @override
  void initState() {
    super.initState();
    if(widget.selected==null){
      widget.selected = false;
    }
    if(widget.selected ){
      print("inside if");
      edtAddressController.text = widget.Data[widget.index]["Address"];
      edtLocationController.text = widget.Data[widget.index]["Area"];
      edtCarpetAreaController.text = widget.Data[widget.index]["AreaValue"];
      edtGoogleMapController.text = widget.Data[widget.index]["GoogleMap"];
      edtAdditionalDesController.text = widget.Data[widget.index]["Description"];
      edtPriceController.text = widget.Data[widget.index]["Price"];
      priorityController.text = widget.Data[widget.index]["Intensity"];
      unitofcarpetController.text = widget.Data[widget.index]["Unit"];
      print( edtAddressController.text);
    }
    else{
      print(widget.selected);
    }

    print("outside if");
   Naturelist = <String>[
     'Property Nature',
     'Shop' ,
     'Flat/ Apartment',
     'House',
     'Villa',
     'Builder Floor',
     'Plot',
     'Studio Apartment',
     'Penthouse',
     'Farm House',
   ];
    if(widget.selected) {
      int x = 0;
      int naturelistlength = Naturelist.length;
      for (int i = 0; i < naturelistlength; i++) {
        if (Naturelist[i] == widget.Data[widget.index]["Nature"]) {
          dropdownType = widget.Data[widget.index]["Nature"];
          x = 1;
          break;
        }
      }
      if (x == 0) {
        dropdownType = "Property Nature";
      }
    }
    else{
      print(widget.selected);
      dropdownType = "Property Nature";
    }


    Ptyelist = <String>[
      'Property Type',
      'Residential',
      'Commercial',
    ];

    if(widget.selected) {
      int x = 0;
      int Ptyelistlength = Ptyelist.length;
      for (int i = 0; i < Ptyelistlength; i++) {
        if (Ptyelist[i] == widget.Data[widget.index]["Ptype"]) {
          Ptyelist[i].replaceAll(Ptyelist[i], "");
          dropdownPtype = widget.Data[widget.index]["Ptype"];
          x = 1;
          break;
        }
      }
      if (x == 0) {
        dropdownPtype = "Property Type";
      }
    }
    else{
      print(widget.selected);
      dropdownPtype = "Property Type";
    }

    unitcarpetarea = <String>[
      'Sqft',
      'Sqyrd',
      'Sqm',
      'Acre',
      'Bigha',
      'Hectare',
      'Marla',
      'Kanal',
      'Biswa1',
      'Biswa2',
      'Ground',
      'Aankadam',
      'Rood',
      'Chatak',
      'Kottah',
      'Cent',
      'Perch',
      'Guntha',
      'Are',
    ];

    if(widget.selected) {
      int x = 0;
      int unitcarpetarealength = unitcarpetarea.length;
      for (int i = 0; i < unitcarpetarealength; i++) {
        if (unitcarpetarea[i] == widget.Data[widget.index]["Unit"]) {
          dropdownCarpetArea = widget.Data[widget.index]["Unit"];
          x = 1;
          break;
        }
      }
      if (x == 0) {
        dropdownCarpetArea = 'Sqft';
      }
    }
    else{
      print(widget.selected);
      dropdownCarpetArea = 'Sqft';
    }

    prioritylist =  <String>[
      'Priority',
      'High',
      'Medium',
      'Low',
    ];

    if(widget.selected) {
      int x = 0;
      int prioritylistlength = prioritylist.length;
      for (int i = 0; i < prioritylistlength; i++) {
        if (prioritylist[i] == widget.Data[widget.index]["Ptype"]) {
          prioritylist[i].replaceAll(prioritylist[i], "");
          dropdownPriority = widget.Data[widget.index]["Ptype"];
          x = 1;
          break;
        }
      }
      if (x == 0) {
        dropdownPriority = 'Priority';
      }
    }
    else{
      print(widget.selected);
      dropdownPriority = 'Priority';
    }

    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
  }

  File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.selected==null){
      widget.selected = false;
    }
    widget.currentindex == 1 ? _tabController.index = 1 : _tabController.index = 0;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: Colors.white,
        buttonColor: Colors.deepPurple,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              !widget.selected ?'Post Property' : 'Update Property',
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
          ),
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
                          border: Border.all(color: Colors.grey[400]),
                        ),
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
                                "Sell",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )  , Tab(
                              child: Text(
                                "Rent",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0, left: 10, right: 10),
                              child:  SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                     //image picker here
                                      Center(
                                        child: widget.selected ? RaisedButton(
                                          child: Text("Upload Property Images",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                          ),
                                          ),
                                          onPressed: (){
                                            print(widget.Data[widget.currentindex]["PropertyId"]);
                                            Navigator.push(context,
                                            MaterialPageRoute(builder:
                                            (context) => MultipleImagePicker(propertyid:widget.Data[widget.currentindex]["PropertyId"]),
                                            ),
                                            );
    }
                                ) : null,
                                      ),
                                // Expanded(
                                //   child: buildGridView(),
                                // ),
                                SizedBox(
                                height: 15,
                                ),
                                Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                Text(
                                "Nature",
                                style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: cnst.appPrimaryMaterialColor),
                                ),
                                Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width -
                                140,
                                decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border:
                                Border.all(color: Colors.grey,
                                ),
                                ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                    items: Naturelist.map<DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    isExpanded: true,
                                                    value: dropdownType,
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.grey,
                                                    ),
                                                    onChanged: (String val) {
                                                      setState(() {
                                                        dropdownType = val;
                                                      });
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                             Container(
                                              height: 45,
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      140,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border:
                                                      Border.all(color: Colors.grey)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      items: Ptyelist.map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      isExpanded: true,
                                                      value: dropdownPtype,
                                                      icon: Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      onChanged: (String val) {
                                                        setState(() {
                                                          dropdownPtype = val;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Property \nAddress",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                            Container(
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      140,
                                              child: TextFormField(
                                                controller: edtAddressController,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                        left: 10, top: 18, right: 10),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                             Container(
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      140,
//
                                              child: TextFormField(
                                                controller: edtLocationController,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                        left: 10, top: 18, right: 10),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Carpet Area",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                             Container(
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      280,
                                              child: TextFormField(
                                                controller: edtCarpetAreaController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: "Carpet Area",
                                                  labelStyle: TextStyle(
                                                    color:
                                                        cnst.appPrimaryMaterialColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 45,
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      230,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border:
                                                      Border.all(color: Colors.grey)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      items: unitcarpetarea.map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      isExpanded: true,
                                                      value: dropdownCarpetArea,
                                                      icon: Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      onChanged: (String val) {
                                                        setState(() {
                                                          dropdownCarpetArea = val;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Price",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                             Container(
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      140,
//
                                              child: TextFormField(
                                                controller: edtPriceController,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                        left: 10, top: 18, right: 10),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Priority",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                            Container(
                                              height: 45,
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      140,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border:
                                                      Border.all(color: Colors.grey)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                      items: prioritylist.map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      isExpanded: true,
                                                      value: dropdownPriority,
                                                      icon: Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Colors.grey,
                                                      ),
                                                      onChanged: (String val) {
                                                        setState(() {
                                                          dropdownPriority = val;
                                                        });
                                                      }),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Google Map",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                      cnst.appPrimaryMaterialColor),
                                            ),
                                            Container(
                                              width:
                                                  MediaQuery.of(context).size.width -
                                                      140,
//
                                              child: TextFormField(
                                                controller: edtGoogleMapController ,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                        left: 10, top: 18, right: 10),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(5)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "Additional Information",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: cnst.appPrimaryMaterialColor),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: TextFormField(
                                          controller: edtAdditionalDesController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10, top: 18, right: 10),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5)),
                                                  borderSide:
                                                      BorderSide(color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey, width: 2))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 20),
                                        child: Center(
                                          child: SizedBox(
                                            height: 45,
                                            width: MediaQuery.of(context).size.width -
                                                30,
                                            child: FlatButton(
                                              color: Colors.deepPurple,
                                              onPressed: () {
                                                !widget.selected ? _InsertPropertysale():_UpdatePropertysale(widget.Data[widget.index]["PropertyId"],"Sell");
                                              },
                                              child: Text(
                                                !widget.selected ?"Post" : "Update",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
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
                                  top: 25.0, left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Center(
                                    child: widget.selected ? RaisedButton(
                                        child: Text("Upload Property Images",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: (){
                                          Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (context) => MultipleImagePicker(),
                                            ),
                                          );
                                        }
                                    ) : null,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Nature",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: cnst.appPrimaryMaterialColor),
                                      ),
                                      Container(
                                        height: 45,
                                        width: MediaQuery.of(context).size.width -
                                            140,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border:
                                            Border.all(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                items: Naturelist.map<DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                isExpanded: true,
                                                value: dropdownType,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.grey,
                                                ),
                                                onChanged: (String val) {
                                                  setState(() {
                                                    dropdownType = val;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          height: 45,
                                          width:
                                          MediaQuery.of(context).size.width -
                                              140,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border:
                                              Border.all(color: Colors.grey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  items: Ptyelist.map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  isExpanded: true,
                                                  value: dropdownPtype,
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.grey,
                                                  ),
                                                  onChanged: (String val) {
                                                    setState(() {
                                                      dropdownPtype = val;
                                                    });
                                                  }),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Property \nAddress",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width -
                                              140,
                                          child: formField(
                                            controller: edtAddressController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Location",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width -
                                              140,
//
                                          child: formField(
                                            controller: edtLocationController,
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Carpet Area",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width -
                                              280,
                                          child: formField(
                                            controller: edtCarpetAreaController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width:
                                          MediaQuery.of(context).size.width -
                                              230,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border:
                                              Border.all(color: Colors.grey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  items: unitcarpetarea.map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  isExpanded: true,
                                                  value: dropdownCarpetArea,
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.grey,
                                                  ),
                                                  onChanged: (String val) {
                                                    setState(() {
                                                      dropdownCarpetArea = val;
                                                    });
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Price",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width -
                                              140,
//
                                          child: formField(
                                            controller: edtPriceController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Priority",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          height: 45,
                                          width:
                                          MediaQuery.of(context).size.width -
                                              140,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border:
                                              Border.all(color: Colors.grey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  items: prioritylist.map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  isExpanded: true,
                                                  value: dropdownPriority,
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.grey,
                                                  ),
                                                  onChanged: (String val) {
                                                    setState(() {
                                                      dropdownPriority = val;
                                                    });
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Google Map",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                              cnst.appPrimaryMaterialColor),
                                        ),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width -
                                              140,
//
                                          child: formField(
                                            controller: edtGoogleMapController,
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      "Additional Information",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: cnst.appPrimaryMaterialColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: formField(
                                      controller: edtAdditionalDesController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 20),
                                    child: Center(
                                      child: SizedBox(
                                        height: 45,
                                        width: MediaQuery.of(context).size.width -
                                            30,
                                        child: FlatButton(
                                          color: Colors.deepPurple,
                                          onPressed: () {
                                            !widget.selected ? _InsertPropertyRent("Rent"):_UpdatePropertysale(widget.Data[widget.index]["PropertyId"],"Rent");
                                          },
                                          child: Text(
                                            !widget.selected ?"Post" : "Update",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
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
      ),
    );
  }

  SaveDataClass rent;
  SaveDataClass sale ;
  SaveDataClass update;
  SaveDataClass update1;

  _InsertPropertyRent(String propertytype) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        //,edtReviewController.text
        Future res = Services.SaveInsertPopertysale(
            dropdownType,
            dropdownPtype,
            edtAddressController.text,
            edtLocationController.text,
            edtCarpetAreaController.text,
            dropdownCarpetArea,
            edtPriceController.text.toString(),
            dropdownPriority,
            edtGoogleMapController.text,
            propertytype,
            edtAdditionalDesController.text);
        res.then((data) async {
          if (data.IsSuccess == true) {
            setState(() {
              isLoading = false;
              rent = data;
              print("rent");
              print(rent);
            });
            Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return MyProperty(
                  dropdownpriority : dropdownPriority,
                  editadditional : edtAdditionalDesController.text,
                  googlemap : edtGoogleMapController.text,
                  carpetarea : edtCarpetAreaController.text,
                  unitofcarpet:  dropdownCarpetArea,
                );
              }),
            );
            //Fluttertoast.showToast(msg: "Book Issued Successfully!!!");
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: data.Message);
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

  _InsertPropertysale() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        //,edtReviewController.text
        Future res = Services.SaveInsertPopertysale(
            dropdownType,
            dropdownPtype,
            edtAddressController.text,
            edtLocationController.text,
            edtCarpetAreaController.text,
            dropdownCarpetArea,
            edtPriceController.text,
            dropdownPriority,
            edtGoogleMapController.text,
            dropdownsalerent,

            edtAdditionalDesController.text);
        res.then((data) async {
          if (data.IsSuccess == true) {
            setState(() {
              isLoading = false;
               sale = data;
            });
            Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return MyProperty(
                    dropdownpriority : dropdownPriority,
                    editadditional : edtAdditionalDesController.text,
                    googlemap : edtGoogleMapController.text,
                    carpetarea : edtCarpetAreaController.text,
                   unitofcarpet:  dropdownCarpetArea,
                );
              }),
            );
            //Fluttertoast.showToast(msg: "Book Issued Successfully!!!");
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: data.Message);
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

  _UpdatePropertysale(String propertyId,String dropdownsalerent) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        print("dropdown value");
        print(dropdownType);
        print("location value");
        //print(location.text);
        //,edtReviewController.text
        Future res = Services.UpdatePropertySale(
            dropdownType,
            dropdownPtype,
            edtAddressController.text,
            edtLocationController.text,
            edtCarpetAreaController.text,
            dropdownCarpetArea,
            edtPriceController.text,
            dropdownPriority,
            edtGoogleMapController.text,
            dropdownsalerent,
            edtAdditionalDesController.text,
           widget.Data[widget.index]["PropertyId"],
        );
        res.then((data) async {
          if (data.IsSuccess == true) {
            setState(() {
              isLoading = false;
              update = data;
            });
            Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return MyProperty();
              }),
            );
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: data.Message);
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
}

class formField extends StatelessWidget {
  String hintText;
  TextInputType keyboardType;
  IconData icon;
  int maxLength;
  int maxLines;
  TextEditingController controller;
  bool isPassword;

  formField({
    this.keyboardType,
    this.maxLines,
    this.hintText,
    this.maxLength,
    this.icon,
    this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 13),
          maxLength: maxLength,
          obscureText: isPassword,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: 10, top: 18, right: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(5)),
                  borderSide:
                  BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(5)),
                  borderSide: BorderSide(
                      color: Colors.grey, width: 2),
              ),
          ),
        ),
      ],
    );
  }
}
