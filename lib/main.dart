import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Screens/AboutUs.dart';
import 'package:progressclubsurat_new/Screens/AddFaceToFace.dart';
import 'package:progressclubsurat_new/Screens/AddGuest.dart';
import 'package:progressclubsurat_new/Screens/AddInvitedGuest.dart';
import 'package:progressclubsurat_new/Screens/AddVisitor.dart';
import 'package:progressclubsurat_new/Screens/AskList.dart';
import 'package:progressclubsurat_new/Screens/Assignments.dart';
import 'package:progressclubsurat_new/Screens/Attendance.dart';
import 'package:progressclubsurat_new/Screens/BookScreen.dart';
import 'package:progressclubsurat_new/Screens/CommitieScreen.dart';
import 'package:progressclubsurat_new/Screens/ContactList.dart';
import 'package:progressclubsurat_new/Screens/Dashboard.dart';
import 'package:progressclubsurat_new/Screens/Directory.dart';
import 'package:progressclubsurat_new/Screens/DirectorySearch.dart';
import 'package:progressclubsurat_new/Screens/Download.dart';
import 'package:progressclubsurat_new/Screens/EditGuestData.dart';
import 'package:progressclubsurat_new/Screens/EditProfile.dart';
import 'package:progressclubsurat_new/Screens/EventDetail.dart';
import 'package:progressclubsurat_new/Screens/EventGallaryScroll.dart';
import 'package:progressclubsurat_new/Screens/EventGallery.dart';
import 'package:progressclubsurat_new/Screens/EventList.dart';
import 'package:progressclubsurat_new/Screens/FeedbackScreen.dart';
import 'package:progressclubsurat_new/Screens/ForgotPassword.dart';
import 'package:progressclubsurat_new/Screens/GuestDetails.dart';
import 'package:progressclubsurat_new/Screens/GuestInvitedByMe.dart';
import 'package:progressclubsurat_new/Screens/GuestProfile.dart';
import 'package:progressclubsurat_new/Screens/IdeaBook.dart';
import 'package:progressclubsurat_new/Screens/IdeaBookDisplay.dart';
import 'package:progressclubsurat_new/Screens/IdeaBookFinal.dart';
import 'package:progressclubsurat_new/Screens/InvitedGuestDetails.dart';
import 'package:progressclubsurat_new/Screens/IssueBook.dart';
import 'package:progressclubsurat_new/Screens/Login.dart';
import 'package:progressclubsurat_new/Screens/MemberDetails.dart';
import 'package:progressclubsurat_new/Screens/MemberDirectory.dart';
import 'package:progressclubsurat_new/Screens/MemberProfile.dart';
import 'package:progressclubsurat_new/Screens/MultipleEventList.dart';
import 'package:progressclubsurat_new/Screens/MyAskScreenFromDashboard.dart';
import 'package:progressclubsurat_new/Screens/MyOfficeBooking.dart';
import 'package:progressclubsurat_new/Screens/MyProperty.dart';
import 'package:progressclubsurat_new/Screens/NotificationScreen.dart';
import 'package:progressclubsurat_new/Screens/OtpVerification.dart';
import 'package:progressclubsurat_new/Screens/RentScreen.dart';
import 'package:progressclubsurat_new/Screens/ScanEventGuestList.dart';
import 'package:progressclubsurat_new/Screens/ScanVisitorList.dart';
import 'package:progressclubsurat_new/Screens/SelectIdeaBook.dart';
import 'package:progressclubsurat_new/Screens/SellRent.dart';
import 'package:progressclubsurat_new/Screens/SignUp.dart';
import 'package:progressclubsurat_new/Screens/Splash.dart';
import 'package:progressclubsurat_new/Screens/TaskList.dart';
import 'package:progressclubsurat_new/Screens/Visitorlist.dart';
import 'package:progressclubsurat_new/Screens/WebViewEventForm.dart';
import 'Screens/EventGuest.dart';
import 'Screens/FaceToFace.dart';
import 'Screens/MyAskScreen.dart';
import 'Screens/OfficeBookingCalender.dart';
import 'Screens/PostProperty.dart';
import 'Screens/SaleScreen.dart';
import 'Screens/ShowDailyProgress.dart';
import 'Screens/ViewGuestEventTicketDetail.dart';
import 'Screens/OTP.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  initializeDateFormatting().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<Null> _showItemDialog(Map<String, dynamic> message) async {
    //final Item item = _itemForMessage(message);
    showDialog<Null>(
            builder: (context) => new AlertDialog(
                  content: new Text("Item ${message} has been updated"),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('CLOSE'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        }),
                    new FlatButton(
                        child: const Text('SHOW'),
                        onPressed: () {
                          Navigator.pop(context, true);
                        }),
                  ],
                ),
            context: context)
        .then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        //_navigateToItemDetail(message);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage");
      _showItemDialog(message);
      /*showDialog(
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );*/
      print(message);
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
      print(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });

    //For Ios Notification
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Setting reqistered : $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: cnst.appPrimaryMaterialColor));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Progress Club Surat',
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/Login': (context) => Login(),
        '/SignUp': (context) => SignUp(),
        '/Dashboard': (context) => Dashboard(),
        '/MemberDirectory': (context) => MemberDirectory(),
        '/MemberDetails': (context) => MemberDetails(),
        '/ForgotPassword': (context) => ForgotPassword(),
        '/Directory': (context) => Directory(),
        '/Download': (context) => Download(),
        //'/Assignments': (context) => Assignments(),
        '/NotificationScreen': (context) => NotificationScreen(),
        '/OtpVerification': (context) => OtpVerification(),
        '/FeedbackScreen': (context) => FeedbackScreen(),
        '/EventList': (context) => EventList(),
        '/EventDetail': (context) => EventDetail(),
        '/AskList': (context) => AskList(),
        '/MyOfficeBooking': (context) => MyOfficeBooking(),
        '/TaskList': (context) => TaskList(),
        '/MemberProfile': (context) => MemberProfile(),
        '/EditProfile': (context) => EditProfile(),
        '/EventGallery': (context) => EventGallery(),
        '/MultipleEventList': (context) => MultipleEventList(),
        '/CommitieScreen': (context) => CommitieScreen(),
        '/DirectorySearch': (context) => DirectorySearch(),
        '/GuestProfile': (context) => GuestProfile(),
        '/GuestDetails': (context) => GuestDetails(),
        '/EventGallaryScroll': (context) => EventGallaryScroll(),
        '/ShowDailyProgress': (context) => ShowDailyProgress(),
        '/Attendance': (context) => Attendance(),
        '/AboutUs': (context) => AboutUs(),
        '/EventGuest': (context) => EventGuest(),
        '/AddGuest': (context) => AddGuest(),
        '/EditGuestData': (context) => EditGuestData(),
        '/ContactList': (context) => ContactList(),
        '/Visitorlist': (context) => Visitorlist(),
        '/Web View': (context) => WebViewEventForm(),
        '/OfficeBookingCalender': (context) => OfficeBookingCalender(),
        '/MyOfficeBooking': (context) => MyOfficeBooking(),
        '/GuestInvitedByMe': (context) => GuestInvitedByMe(),
        '/AddInvitedGuest': (context) => AddInvitedGuest(),
        '/InvitedGuestDetails': (context) => InvitedGuestDetails(),
        '/MyAskScreen': (context) => MyAskScreen(),
        '/ScanVisitorList': (context) => ScanVisitorList(),
        '/FaceToFace': (context) => FaceToFace(),
        '/AddFaceToFace': (context) => AddFaceToFace(),
        '/MyAskScreenFromDashboard': (context) => MyAskScreenFromDashboard(),
        '/SellRent': (context) => SellRent(),
        '/PostProperty': (context) => PostProperty(),
        '/SaleScreen': (context) => SaleScreen(),
        '/RentScreen': (context) => RentScreen(),
        '/BookScreen': (context) => BookScreen(),
        '/IssueBook': (context) => IssueBook(),
        '/MyProperty': (context) => MyProperty(),
        '/IdeaBookScreen': (context) => IdeaBook(),
        '/SelectIdeaBook': (context) => SelectIdeaBook(),
        '/IdeaBookComponent': (context) => IdeaBookFinal(),
        '/IdeaBookDisplay': (context) => IdeaBookDisplay(),
        '/ScanEventGuest': (context) => ScanEventGuest(),
        '/ViewGuestEventTicketDetail': (context) =>
            ViewGuestEventTicketDetail(),
        '/AddVisitor': (context) => AddVisitor(),
      },
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: Colors.black,
        buttonColor: Colors.deepPurple,
      ),
    );
  }
}