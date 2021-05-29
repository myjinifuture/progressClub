import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Screens/AddVisitor.dart';
import 'package:progressclubsurat_new/Screens/Dashboard.dart';
import 'package:progressclubsurat_new/Screens/GuestSearch.dart';

class AdminDashboardComponent extends StatefulWidget {
  @override
  _AdminDashboardComponentState createState() =>
      _AdminDashboardComponentState();
}

class _AdminDashboardComponentState extends State<AdminDashboardComponent> {
  final ScrollController scrollbarController = new ScrollController();
  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200].withOpacity(0.5),
      body: GestureDetector(
        onTap: (){
          this._dismissKeyboard(context);
          },
        child: Column(
          children: [
//==============Dashboard Search Component
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, size: 22),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: "Search Guest Name",
                          hintStyle: TextStyle(fontSize: 13)),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> GuestSearch()));

                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: cnst.appPrimaryMaterialColor,
                        ),
                        child: Center(
                            child: Text("Search Guest",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))),
                      ),
                    ),
                  ),
                ],
              ),
            ),


//==============Dashboard 2nd area from top(DashControls)
            Container(
              height: MediaQuery.of(context).size.height * 0.245,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.113,
                            width: MediaQuery.of(context).size.width * 0.477,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                              ),
                              color:
                                  cnst.appPrimaryMaterialColor.withOpacity(0.85),
                            ),
                            child: FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_add,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Add Visitor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/AddVisitor');
                              },
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.113,
                            width: MediaQuery.of(context).size.width * 0.477,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                              ),
                              color:
                                  cnst.appPrimaryMaterialColor.withOpacity(0.85),
                            ),
                            child: FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),

                                  Text(
                                    'Send Notifications',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.113,
                            width: MediaQuery.of(context).size.width * 0.477,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                              ),
                              color:
                                  cnst.appPrimaryMaterialColor.withOpacity(0.85),
                            ),
                            child: FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Send Notifications',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.113,
                            width: MediaQuery.of(context).size.width * 0.477,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                              ),
                              color:
                                  cnst.appPrimaryMaterialColor.withOpacity(0.85),
                            ),
                            child: FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outlined),
                                  Text(
                                    'Demo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.085,
                          ),
                          adminOptionsPressed == true
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.075,
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(100),
                                        bottomLeft: Radius.circular(100),
                                        topLeft: Radius.circular(100),
                                        topRight: Radius.circular(100)),
                                    border:
                                        Border.all(color: Colors.white, width: 4),
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

//==============Dashboard GridView
            Expanded(
              child: CupertinoScrollbar(
                isAlwaysShown: true,
                controller: scrollbarController,
                thickness: 20,
                radius: Radius.circular(200),
                radiusWhileDragging: Radius.circular(200),
                thicknessWhileDragging: 15,
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: scrollbarController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.red,
                        elevation: 2,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
