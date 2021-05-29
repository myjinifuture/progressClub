import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class AddVisitor extends StatefulWidget {
  @override
  _AddVisitorState createState() => _AddVisitorState();
}

class _AddVisitorState extends State<AddVisitor> {
  TextEditingController visitorName = new TextEditingController();
  TextEditingController visitorContactNumber = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Visitor"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              controller: visitorContactNumber,
              scrollPadding: EdgeInsets.all(0),
              maxLength: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(
                    Icons.phone_android,
                  ),
                  counterText: "",
                  hintText: "Visitor Contact No"),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              controller: visitorName,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(
                    Icons.person,
                    //color: cnst.appPrimaryMaterialColor,
                  ),
                  hintText: "Visitor Name"),
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: cnst.appPrimaryMaterialColor,
              minWidth: MediaQuery.of(context).size.width,
              child: Text(
                "Add Visitor",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
