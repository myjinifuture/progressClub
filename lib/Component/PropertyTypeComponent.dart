

import 'package:custom_radio_button/radio_model.dart';
import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Screens/SellRent.dart';

class PropertyTypeComponent extends StatefulWidget {

  var field;
  int length;
  int index;
  List<RadioModel> onTap;
  List<RadioModel> propertylistData = new List<RadioModel>();
  PropertyTypeComponent({this.field,this.length,this.index,this.propertylistData,this.onTap});

  @override
  _PropertyTypeComponentState createState() => _PropertyTypeComponentState();
}

class _PropertyTypeComponentState extends State<PropertyTypeComponent> {
  String whichistrue = "";
@override
  Widget build(BuildContext context){
   return  Padding(
      padding: const EdgeInsets.only(top:8.0,right: 8),
      child: GestureDetector(
          onTap: () {
            if(widget.propertylistData[widget.index].isSelected==true){
              setState(() {
                widget.propertylistData[widget.index].isSelected = false;
                widget.onTap = widget.propertylistData;
                whichistrue = widget.propertylistData[widget.index].text;
                print(whichistrue.length);
              });
            }
            else {
              setState(() {
                widget.propertylistData[widget.index].isSelected = true;
                widget.onTap = widget.propertylistData;
                whichistrue = widget.propertylistData[widget.index].text;
                print(whichistrue);
              });
            }
          },

          child: Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: widget.propertylistData[widget.index].isSelected ? Colors.purple : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.home,size: 30, color: cnst.appPrimaryMaterialColor),
                Text(
                  "${widget.field["FieldValue"]}",
                  style: TextStyle(
                    fontSize: 14,
                    color: !widget.propertylistData[widget.index].isSelected ? cnst.appPrimaryMaterialColor : Colors.white,),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
