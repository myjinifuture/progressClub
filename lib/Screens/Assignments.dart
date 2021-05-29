// import 'package:flutter/material.dart';
// import 'package:progressclubsurat_new/Common/ClassList.dart';
//
// //Common Dart File
// import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
// import 'package:progressclubsurat_new/Common/Constants.dart';
// import 'package:progressclubsurat_new/Common/Services.dart';
//
// import 'package:progressclubsurat_new/Component/AssignmentsComponents.dart';
// import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
// import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
//
// class Assignments extends StatefulWidget {
//   @override
//   _AssignmentsState createState() => _AssignmentsState();
// }
//
// class _AssignmentsState extends State<Assignments> {
//   List list = new List();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: cnst.appPrimaryMaterialColor,
//           ),
//         ),
//         actionsIconTheme: IconThemeData.fallback(),
//         title: Text(
//           'Assignments',
//           style: TextStyle(
//               color: cnst.appPrimaryMaterialColor,
//               fontSize: 18,
//               fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: FutureBuilder<List>(
//           future: Services.getAssigment(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             return snapshot.connectionState == ConnectionState.done
//                 ? snapshot.hasData && snapshot.data.length>0
//                     ? ListView.builder(
//                         padding: EdgeInsets.all(0),
//                         itemCount: snapshot.data.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return AssignmentsComponents(snapshot.data[index]);
//                         },
//                       )
//                     : NoDataComponent()
//                 : LoadinComponent();
//           },
//         ),
//       ),
//     );
//   }
// }
