import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[

                  Container(
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Icon(Icons.vpn_key,size: 60,color: cnst.appPrimaryMaterialColor,),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Text('Forget Your Password ? ',textAlign: TextAlign.center,style: TextStyle(color: cnst.appPrimaryMaterialColor,fontSize: 18),)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 75,
                    child: TextFormField(
                      //controller: txtTitle,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          hintText: "Mobile No"),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: cnst.appPrimaryMaterialColor,
                      minWidth: MediaQuery.of(context).size.width - 20,
                      onPressed: () {
                        //if (isLoading == false) this.SaveOffer();
                        Navigator.pushReplacementNamed(context, '/Login');
                      },
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/Login');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already Register ?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text(
                            'SIGN IN',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: cnst.appPrimaryMaterialColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
