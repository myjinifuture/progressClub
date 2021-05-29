import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Controller
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobileNo = new TextEditingController();
  TextEditingController edtMobileCountry = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtCmpName = new TextEditingController();
  TextEditingController edtState = new TextEditingController(); //vinchu
  TextEditingController edtCity = new TextEditingController(); //vinchu
  TextEditingController edtRefferBy = new TextEditingController();

  //loading var
  bool isLoading = false;

  String temp = "Select State"; //vinchu
  String temp1 = "Select City"; //vinchu

  List stateandcities = [];
  List<String> states = [], cities = [];

  _getStatesCities() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);
        Services.getStatesCities().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != "") {
            print("statecitiesdata");
            stateandcities = data;
            for (int i = 0; i < stateandcities.length; i++) {
              if (!states.contains(stateandcities[i]["state"])) {
                states.add(stateandcities[i]["state"]);
                states.sort();
              }
            }
            print("states");
            print(states);
          } else {
            //showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  signUpDone(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/Login');
              },
            ),
          ],
        );
      },
    );
  }

  pcsignup() async {
    if (edtName.text != null &&
        edtMobileNo.text != null &&
        edtMobileNo.text.length == 10 &&
        edtEmail.text != null &&
        edtCmpName.text != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          var data = {
            "type": "signup",
            'name': edtName.text.trim(),
            'mobile': edtMobileNo.text.trim(),
            'email': edtEmail.text.trim(),
            'company': edtCmpName.text.trim(),
            //'RefferBy': edtRefferBy.text.trim(),
            "imagecode": "",
            "myreferCode": "",
            "regreferCode": "",
          };

          Services.pcsignup(
                  "signup",
                  edtName.text.trim(),
                  edtMobileNo.text.trim(),
                  edtEmail.text.trim(),
                  edtCmpName.text.trim(),
                  "",
                  "",
                  "")
              .then((data) async {
            setState(() {
              isLoading = false;
            });
            if (data != null) {
              signUpDone("Registration Done Successfully");
              checkLogin();
            } else {
              setState(() {
                isLoading = false;
              });
              showMsg("Data insertion successfull");
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Fill All Data.");
    }
  }

  List CardIddata = [];
  List Updatedata = [];

  UpdateCardId(String cardid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        print("anirudh");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.UpdateCardId("updatemember", cardid, "2944");
        res.then((data) async {
          print(data);
          if (data != null && data.length > 0) {
            setState(() {
              Updatedata = data;
              print("Updatedata");
              print(Updatedata);
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  getCardId() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.GetCardIdLogin(
            "login", prefs.getString(cnst.Session.Mobile));
        res.then((data) async {
          print(data);
          if (data != null && data.length > 0) {
            setState(() {
              CardIddata = data;
              print("card id");
              print(CardIddata[0]["cardid"]);
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  List data;
  String cardidlatest = "";

  Future<List> chklog() async {
    data = await Services.MemberLogin1(CardIddata[0]["mobile"]);
    print("member login data");
    cardidlatest = data[0]["Id"];
    return data;
  }

  checkLogin() async {
    if (CardIddata[0]["mobile"] != "" && CardIddata[0]["mobile"] != null) {
      if (CardIddata[0]["mobile"].length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            //pr.show();
            Services.MemberLogin1(CardIddata[0]["mobile"]).then((data) async {
              if (data[0].Id != "" || data[0].Id != null) {
                UpdateCardId(data[0].Id);
              }
            }, onError: (e) {
              //pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            //pr.hide();
            showMsg("Something went wrong");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please enter Valid Mobile Number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  singnUp() async {
    if (edtName.text != null &&
            edtCity.text != null &&
            edtState.text != null &&
            edtMobileNo.text != null ||
        edtMobileNo.text.length == 10 ||
        edtMobileCountry.text != null &&
            edtEmail.text != null &&
            edtCmpName.text != null ||
        temp1 != 'Select City') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          String city, state, mobile;
          if (dropdownValue == 'India') {
            city = temp;
            state = temp1;
            mobile = edtMobileNo.text;
          } else {
            city = edtCity.text;
            state = edtState.text;
            mobile = edtMobileCountry.text;
          }
          // var data = {
          //   'personname': edtName.text.trim(),
          //   'mobile': edtMobileNo.text.trim(),
          //   'email': edtEmail.text.trim(),
          //   'companyname': edtCmpName.text.trim(),
          //   'statename': temp,
          //   'cityname': temp1,
          //   'referby': edtRefferBy.text.trim(),
          //   'type': "guest",
          // };

          Services.guestSignUp(
                  dropdownValue,
                  edtName.text.trim(),
                  mobile.trim(),
                  edtEmail.text.trim(),
                  edtCmpName.text.trim(),
                  city,
                  state,
                  edtRefferBy.text.trim())
              .then((data) async {
            setState(() {
              isLoading = false;
            });
            if (data == "Successfully !") {
              signUpDone("Registration Done Successfully");
              pcsignup();
            } else {
              setState(() {
                isLoading = false;
              });
              showMsg(data);
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Fill All Data.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStatesCities();
    getCardId();
  }

  String dropdownValue = 'India';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/Login');
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset("images/logo.jpg",
                          width: 180.0, height: 180.0, fit: BoxFit.contain),
                    ),
                    SizedBox(
                      child: InputDecorator(
                        decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          //labelText: "",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            // icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),

                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'Afghanistan',
                              'Albania',
                              'Algeria',
                              'Andorra',
                              'Angola',
                              'Antigua and Barbuda	',
                              'Argentina',
                              'Armenia',
                              'Australia',
                              'Austria',
                              'Azerbaijan',
                              'Bahamas',
                              'Bahrain',
                              'Bangladesh',
                              'Barbados',
                              'Belarus',
                              'Belgium',
                              'Belize',
                              'Benin',
                              'Bhutan',
                              'Bolivia',
                              'Bosnia and Herzegovina	',
                              'Botswana',
                              'Brazil',
                              'Brunei',
                              'Bulgaria',
                              'Burkina Faso	',
                              'Burundi',
                              'Côte d Ivoire',
                              'Cabo Verde	',
                              'Cambodia',
                              'Cameroon',
                              'Canada	',
                              'Central African Republic	',
                              'Chad',
                              'Chile	',
                              'China',
                              'Colombia',
                              'Comoros',
                              'Congo (Congo-Brazzaville)	',
                              'Costa Rica	',
                              'Croatia',
                              'Cuba',
                              'Cyprus',
                              'Czechia (Czech Republic)	',
                              'Democratic Republic of the Congo	',
                              'Denmark',
                              'Djibouti',
                              'Dominica',
                              'Dominican Republic	',
                              'Ecuador',
                              'Egypt	',
                              'El Salvador	',
                              'Equatorial Guinea	',
                              'Eritrea',
                              'Estonia',
                              'Eswatini (fmr. "Swaziland")	',
                              'Ethiopia',
                              'Fiji',
                              'Finland',
                              'France',
                              'Gabon',
                              'Gambia',
                              'Georgia',
                              'Germany	',
                              'Ghana',
                              'Greece',
                              'Grenada',
                              'Guatemala',
                              'Guinea',
                              'Guinea-Bissau	',
                              'Guyana',
                              'Haiti',
                              'Holy See	',
                              'Honduras',
                              'Hungary',
                              'Iceland',
                              'India',
                              'Indonesia',
                              'Iran	',
                              'Iraq	',
                              'Ireland',
                              'Israel',
                              'Italy',
                              'Jamaica',
                              'Japan',
                              'Jordan',
                              'Kazakhstan	',
                              'Kenya',
                              'Kiribati',
                              'Kuwait',
                              'Kyrgyzstan',
                              'Laos',
                              'Latvia',
                              'Lebanon',
                              'Lesotho',
                              'Liberia	',
                              'Libya',
                              'Liechtenstein',
                              'Lithuania',
                              'Luxembourg',
                              'Madagascar',
                              'Malawi	',
                              'Malaysia',
                              'Maldives	',
                              'Mali	',
                              'Malta',
                              'Marshall Islands	',
                              'Mauritania	',
                              'Mauritius',
                              'Mexico',
                              'Micronesia',
                              'Moldova',
                              'Monaco	',
                              'Mongolia	',
                              'Montenegro',
                              'Morocco',
                              'Mozambique',
                              'Myanmar (formerly Burma)	',
                              'Namibia',
                              'Nauru',
                              'Nepal',
                              'Netherlands',
                              'New Zealand	',
                              'Nicaragua	',
                              'Niger',
                              'Nigeria',
                              'North Korea	',
                              'North Macedonia	',
                              'Norway',
                              'Oman',
                              'Pakistan',
                              'Palau',
                              'Palestine State	',
                              'Panama',
                              'Papua New Guinea	',
                              'Paraguay',
                              'Peru',
                              'Philippines',
                              'Poland',
                              'Portugal',
                              'Qatar',
                              'Romania',
                              'Russia',
                              'Rwanda',
                              'Saint Kitts and Nevis	',
                              'Saint Lucia	',
                              'Saint Vincent and the Grenadines	',
                              'Samoa',
                              'San Marino	',
                              'Sao Tome and Principe	',
                              'Saudi Arabia	',
                              'Senegal',
                              'Serbia',
                              'Seychelles',
                              'Sierra Leone	',
                              'Singapore',
                              'Slovakia',
                              'Slovenia',
                              'Solomon Islands	',
                              'Somalia',
                              'South Africa	',
                              'South Korea	',
                              'South Sudan	',
                              'Spain	',
                              'Sri Lanka	',
                              'Sudan',
                              'Suriname',
                              'Sweden',
                              'Switzerland',
                              'Syria',
                              'Tajikistan',
                              'Tanzania',
                              'Thailand',
                              'Timor-Leste	',
                              'Togo',
                              'Tonga',
                              'Trinidad and Tobago	',
                              'Tunisia',
                              'Turkey',
                              'Turkmenistan',
                              'Tuvalu',
                              'Uganda',
                              'Ukraine',
                              'United Arab Emirates	',
                              'United Kingdom	',
                              'United States of America	',
                              'Uruguay',
                              'Uzbekistan',
                              'Vanuatu',
                              'Venezuela',
                              'Vietnam',
                              'Yemen',
                              'Zambia',
                              'Zimbabwe',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        child: TextFormField(
                          controller: edtName,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: cnst.appPrimaryMaterialColor,
                              ),
                              hintText: "Name"),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    dropdownValue == 'India'
                        ? Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtMobileNo,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  hintText: "Mobile No"),
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtMobileCountry,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  hintText: "Mobile No"),
                              //maxLength: 10,
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: edtEmail,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: cnst.appPrimaryMaterialColor,
                            ),
                            hintText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: edtCmpName,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            prefixIcon: Icon(
                              Icons.business,
                              color: cnst.appPrimaryMaterialColor,
                            ),
                            hintText: "Company Name"),
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      //vinchu
                      padding: EdgeInsets.only(top: 10),
                      child: dropdownValue != 'India'
                          ? Container(
                              child: TextFormField(
                                controller: edtState,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    // prefixIcon: Icon(
                                    //   Icons.,
                                    //   color: cnst.appPrimaryMaterialColor,
                                    // ),
                                    hintText: "State"),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: InputDecorator(
                                      decoration: new InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        //labelText: "",
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          //isDense: true,
                                          hint: new Text(temp),

                                          onChanged: (val) {
                                            print(val);
                                            cities = [];
                                            for (int i = 0;
                                                i < stateandcities.length;
                                                i++) {
                                              if (stateandcities[i]["state"] ==
                                                  val.toString()) {
                                                cities.add(
                                                    stateandcities[i]["name"]);
                                                cities.sort();
                                              }
                                            }
                                            print("cities");
                                            print(cities);
                                            setState(() {
                                              temp = val;
                                            });
                                          },

                                          items: states
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: FittedBox(
                                                child: new Text(
                                                  value,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    width: (MediaQuery.of(context).size.width -
                                        124),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Container(
                      //vinchu
                      padding: EdgeInsets.only(top: 10),
                      child: dropdownValue != 'India'
                          ? Container(
                              child: TextFormField(
                                controller: edtCity,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    // prefixIcon: Icon(
                                    //   Icons.account_circle,
                                    //   color: cnst.appPrimaryMaterialColor,
                                    // ),
                                    hintText: "City"),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: InputDecorator(
                                      decoration: new InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        //labelText: "",
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          //isDense: true,
                                          hint: new Text(temp1),
                                          // value: _memberClass,
                                          onChanged: (val) {
                                            setState(() {
                                              temp1 = val;
                                            });
                                          },
                                          //value: temp1,
                                          items: cities
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(
                                                value,
                                                style: new TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    width: (MediaQuery.of(context).size.width -
                                        124),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: edtRefferBy,
                        scrollPadding: EdgeInsets.all(0),
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            prefixIcon: Icon(
                              Icons.supervisor_account,
                              color: cnst.appPrimaryMaterialColor,
                            ),
                            hintText: "Reffer By"),
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 30),
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: cnst.appPrimaryMaterialColor,
                        minWidth: MediaQuery.of(context).size.width - 20,
                        onPressed: () {
                          if (isLoading == false) {
                            singnUp();
                          }
                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
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
                isLoading ? LoadinComponent() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
