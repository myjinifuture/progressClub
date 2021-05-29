import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/CompletedComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:progressclubsurat_new/Component/PendingAssignmentComponents.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
class PendingTask extends StatefulWidget {
  var meetingId;

  PendingTask(this.meetingId);

  @override
  _PendingTaskState createState() => _PendingTaskState();
}

class _PendingTaskState extends State<PendingTask> {
  ProgressDialog pr;


  @override
  void initState() {
    // TODO: implement initState
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List>(
          future: Services.getPendingAssi(widget.meetingId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PendingAssignmentComponents(
                              snapshot.data[index], widget.meetingId,(action){
                                if(action=="show"){
                                  pr.show();
                                } else {
                                  pr.hide();
                                }
                          });
                        },
                      )
                    : NoDataComponent()
                : LoadinComponent();
          },
        ),
      ),
    );
  }
}
