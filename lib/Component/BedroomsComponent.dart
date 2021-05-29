import 'package:flutter/material.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;


class BedroomsComponent extends StatefulWidget {


  var field;
  Function onTap1;

  BedroomsComponent({this.field,this.onTap1});

  @override
  _BedroomsComponentState createState() => _BedroomsComponentState();
}



class _BedroomsComponentState extends State<BedroomsComponent> {

bool isselected1 = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0,right: 8),
      child: GestureDetector(
        onTap: (){
          setState(() {
            isselected1 = !isselected1;
            if(!isselected1) {
              widget.onTap1(widget.field["FieldValue"]);
            }
          });
        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            color: isselected1 ? Colors.white : Colors.purple,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey[300]),
          ),
          child: Center(
            child: Text(
              "${widget.field["FieldValue"]}",
              style: TextStyle(
                fontSize: 14,
                color: isselected1 ? cnst.appPrimaryMaterialColor : Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
}
