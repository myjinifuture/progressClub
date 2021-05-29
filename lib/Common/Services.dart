import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/MyProperty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

import 'ClassList.dart';

Dio dio = new Dio();
Xml2Json xml2json = new Xml2Json();

class Services {
  //login funtion

  static Future<SaveDataClass1> SaveShare(data) async {
    String url = digitalcard + 'AddShare';
    print("AddShare URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> MyProperty(
      String type, String propertytype, String memberid) async {
    String url = SOAP_API_URL +
        'MyProperty?type=$type&PropertyType=$propertytype&memberid=$memberid';
    //String url = API_URL + 'GetLoginWithFCM?mobile=$mobileNo&fcmToken=$fcmToken';
    print("MyProperty URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("MyProperty URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("MyProperty Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass1> MemberSignUp(data) async {
    String url = cnst.digitalcard + 'MemberSignUp';
    print("digitalcardsignup URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass1 data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        print("digitalcardsignup data: ");
        print(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print("digitalcardsignup Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass1> Scanner(String eventid, String memberid,
      String chapterid, String membername, String mobileno) async {
    String url = cnst.SOAP_API_URL +
        'ScanEventMemberEntry?type=scanevent&eventid=$eventid&memberid=$memberid&chapterid=$chapterid&membername=$membername&mobileno=$mobileno';
    print("ScanEventMemberEntry URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        SaveDataClass1 data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        print("ScanEventMemberEntry data: ");
        print(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print("ScanEventMemberEntry Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass1> PCSignUp(data) async {
    String url = cnst.digitalcard + 'PCSignUp';
    print("PCSignUp URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass1 data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        print("PCSignUp data");
        print(saveDataClass);
        return saveDataClass;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print("PCSignUp Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<MemberClass1>> CardIdNight(String mobileno) async {
    String url = "http://digitalcard.co.in/DigitalcardService.asmx/" +
        'Member_login?type=mobilelogin&mobileno=$mobileno';
    print("CardIdNight URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        List<MemberClass1> list = [];
        print("CardIdNight Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        MemberDataClass1 memberDataClass =
            new MemberDataClass1.fromJson(jsonResponse);

        if (memberDataClass.ERROR_STATUS == false)
          list = memberDataClass.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardIdNight Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<Map> MemberLogin(String mobileNo) async {
    String url =
        'http://pmc.studyfield.com/Service.asmx/SignIn?mobile=$mobileNo';
    //String url = API_URL + 'GetLoginWithFCM?mobile=$mobileNo&fcmToken=$fcmToken';
    print("MemberLogin URL: " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        Map list = {};
        final body = jsonDecode(response.data);
        print("MemberLogin Response: " + response.data.toString());
        if (body["IsSuccess"] == true && body["IsRecord"] == true) {
          print(body["Data"]);
          list = body["Data"];
        } else {
          list = {};
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("MemberLoginById Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<Map> UpdateGuestData(String mobileNo, String name, String id,
      String memberId, String state, String city) async {
    String url =
        "http://pmc.studyfield.com/Service.asmx/EditGuestList?type=updateguest&name=$name&mobile=$mobileNo&state=$state&city=$city&memberId=$memberId&Id=$id";
    print("MemberLogin URL: " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        Map list = {};
        final body = jsonDecode(response.data);
        print("MemberLogin Response: " + response.data.toString());
        if (body["IsSuccess"] == true && body["IsRecord"] == true) {
          print(body["Data"]);
          list = body["Data"];
        } else {
          list = {};
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateGuestData Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetCardIdLogin(String type, String MobileNo) async {
    String url = SOAP_API_URL + 'Login?type=$type&mobile=$MobileNo';
    //String url = API_URL + 'GetLoginWithFCM?mobile=$mobileNo&fcmToken=$fcmToken';
    print("CheckCardId URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("CheckCardId Data: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["RECORDS"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardIdLogin Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> MyProperty1(
      String type, String propertytype, String memberid) async {
    String url = SOAP_API_URL +
        'MyProperty?type=$type&PropertyType=$propertytype&memberid=$memberid';
    //String url = API_URL + 'GetLoginWithFCM?mobile=$mobileNo&fcmToken=$fcmToken';
    print("MyPropertyRent URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("MyPropertyRent URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("MyPropertyRent Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<MemberClass1>> MemberLogin1(String mobileno) async {
    String url =
        cnst.digitalcard + 'Member_login?type=mobilelogin&mobileno=$mobileno';
    print("MemberLogin123 URL: " + url);
    final response = await http.get(url);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        List<MemberClass1> list;
        print("MemberLogin123 Response: " + response.body);
        final jsonResponse = json.decode(response.body);
        MemberDataClass1 memberDataClass =
            new MemberDataClass1.fromJson(jsonResponse);
        if (memberDataClass.ERROR_STATUS == false) {
          list = memberDataClass.Data;
        } else
          list = [];
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Download From Server
  static Future<List> GetDownload() async {
    String url = API_URL + 'GetDownload';
    print("Download URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Download: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Download : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<MemberClass1>> UpdateCardId(
      String type, String cardid, String userid) async {
    String url = SOAP_API_URL +
        'UpdateDigitalCardId?type=$type&cardid=$cardid&userid=$userid';
    print("UpdateCardId URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List<MemberClass1> list;
        print("UpdateCardId: " + response.data.toString());
        // var memberDataClass = response.data;
        // if (memberDataClass["MESSAGE"] == "Successfully !" ) {
        //   print(memberDataClass["Data"]);
        //   list = memberDataClass["Data"];
        // } else {
        //   list = [];
        // }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateCardId : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Event From Server
  static Future<List> GetEvent() async {
    String url = API_URL + 'GetEvent';
    print("Event URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Event Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Event Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get EventGallery From Server
  static Future<List> GetEventGalleryById(int eventId) async {
    String url = API_URL + 'GetEventGalleryById?id=$eventId';
    print("EventGallery URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("EventGallery Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("EventGallery Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Ask List From Server
  static Future<List> GetAsk() async {
    String url = API_URL + 'GetAskData';
    print("Ask List URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Ask List Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Ask List Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getSearchMember(String keyword) async {
    String url = API_URL + 'SearchMember?keyword=$keyword';
    print("getSearchMember URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("getSearchMember Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("getSearchMember Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Directory From Server
  static Future<List> GetDirectory() async {
    String url = API_URL + 'GetChapterList';
    print("Download URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Download URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Download URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Chapter Member List From Server
  static Future<List> GetChapterMemberList(String chapterid) async {
    String url = API_URL + 'GetChapterMemberList?chapterId=$chapterid';
    print("Chapter Member List URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Chapter Member List URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Chapter Member List URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<MemberClass>> GetMemberByChapter(String chapterid) async {
    String url = cnst.API_URL + "GetChapterMemberList?chapterId=$chapterid";
    print("GetChapterMemberList url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<MemberClass> list = [];
        print("GetChapterMemberList Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          MemberDataClass memberdataclass =
              new MemberDataClass.fromJson(jsonResponse);

          list = memberdataclass.Data;

          return list;
        }
      }
    } catch (e) {
      print("GetChapterMemberList error" + e);
      throw Exception(e);
    }
  }

  //get Commities List From Server
  static Future<List> GetCommitiesList(String chapterid) async {
    String url = API_URL + 'GetChapterCommitete?chapterId=$chapterid';
    print("Commities List URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Commities List URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Commities List URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //sign up guest
  static Future<String> guestSignUp(
      String countryname,
      String personname,
      String mobile,
      String email,
      String companyname,
      String state,
      String city,
      String referby) async {
    // print(body.toString());
    String url =
        'http://pmc.studyfield.com/Service.asmx/SignUp?type=guest&companyname=$companyname&personname=$personname&countryname=$countryname&mobile=$mobile&email=$email&statename=$state&cityname=$city&referby=$referby';
    print("SaveMember url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        // SaveDataClass saveData = new SaveDataClass(
        //     Message: 'No Data', IsSuccess: false, IsRecord: false);
        final body = json.decode(response.data);
        // print("SaveMember Response: " + response.data.toString());
        // var memberDataClass = response.data;
        // saveData.Message = memberDataClass["MESSAGE"];
        // saveData.IsSuccess = memberDataClass["IsSuccess"];
        // saveData.IsRecord = memberDataClass["IsRecord"];
        // saveData.Data = memberDataClass["Data"].toString();
        return body["MESSAGE"].toString();
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<String> pcsignup(
      String type,
      String name,
      String mobile,
      String company,
      String email,
      String imagecode,
      String myrefercode,
      String regrefercode) async {
    String url = digitalcard +
        'PCSignUp?type=$type&name=$name&mobile=$mobile&company=$company&email=$email&imagecode=$imagecode&myreferCode=$myrefercode&regreferCode=$regrefercode';
    print("PCSignUp url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        pcsignupData pcsignupData1 = new pcsignupData(
            MESSAGE: 'No Data',
            ORIGINAL_ERROR: "no data",
            ERROR_STATUS: false,
            RECORDS: false);

        print("PCSignUp Response: " + response.data.toString());
        var memberDataClass = response.data;

        // pcsignupData1.MESSAGE = memberDataClass["MESSAGE"];
        // pcsignupData1.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        // pcsignupData1.ERROR_STATUS = memberDataClass["ERROR_STATUS"] ;
        // pcsignupData1.RECORDS = memberDataClass["RECORDS"] ;
        return memberDataClass;
      } else {
        print("PCSignUp Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error PCSignUp ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass1> uploadBrochure(body) async {
    print(body.toString());
    String url = SOAP_API_URL + 'UpdatePhotos';
    print("UpdateBrochure : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.data);
        print("UpdateBrochure response =" + jsonResponse.toString());
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        print("saveDataClass");
        print(saveDataClass);
        return saveDataClass;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //get member Profile From Server
  static Future<List> GetMemberProfile(String memberId) async {
    String url = API_URL + 'GetMemberProfile?MemberId=$memberId';
    print("GetMemberProfile URL: ---------------------------" + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetMemberProfile URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMemberProfile URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> sendOtpCode(String mobileno, String code) async {
    String url = API_URL + 'SendVerificationCode?mobileNo=$mobileno&code=$code';
    print("Update User Details URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SaveMember Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Update User Details Check Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> CodeVerification(String MemberId) async {
    String url = API_URL + 'CodeVerification?id=$MemberId';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("CodeVerification Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CodeVerification Check Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  /*static Future<SaveDataClass> getAssigment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);
    String chapterId = prefs.getString(Session.ChapterId);

    String url = API_URL +
        'GetMeetingData?ChapterId=$chapterId&MemberId=$memberId';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false,IsRecord: false, Data: null);

        print("CodeVerification Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CodeVerification Check Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }*/

  //get Commities List From Server
  static Future<List> getAssigment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);
    String chapterId = prefs.getString(Session.ChapterId);

    String url =
        API_URL + 'GetMeetingData?ChapterId=$chapterId&MemberId=$memberId';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Commities List URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Commities List URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> sendFeedback(body) async {
    print(body.toString());
    String url = API_URL + 'GetFeedBack';
    print("SaveMember url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SaveMember Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> sendEventAttendance(body) async {
    print(body.toString());
    String url = API_URL + 'EventAttendance';
    print("SaveMember url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SaveMember Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //get Commities List From Server
  static Future<List> getCompletedAssi(String meetingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url = API_URL +
        'GetCompletedAssignment?MeetingId=$meetingId&MemberId=$memberId';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Commities List URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Commities List URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Commities List From Server
  static Future<List> getPendingAssi(String meetingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url = API_URL +
        'GetMeetingPendingAssignment?MeetingId=$meetingId&MemberId=$memberId';
    print("GetMeetingPendingAssignment URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetMeetingPendingAssignment URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMeetingPendingAssignment URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> updatePendingTask(body) async {
    print(body.toString());
    String url = API_URL + 'AddUpdateMemberAssignment';
    print("AddUpdateMemberAssignment url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print(
            "AddUpdateMemberAssignment Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("AddUpdateMemberAssignment");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //get Commities List From Server
  static Future<List> SendTokanToServer(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url =
        API_URL + 'UpdateFCMToken?memberId=$memberId&fcmToken=$fcmToken';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Commities List URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Commities List URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> sendMemberDetails(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateProfilePersonalNew';
    print("UpdateProfilePersonal url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("UpdateProfilePersonal Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("UpdateProfilePersonal Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //updated Guest Info
  static Future<SaveDataClass> sendGuestDetails(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateGuest';
    print("UpdateProfilePersonal url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("UpdateProfilePersonal Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("UpdateProfilePersonal Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> sendBusinessMemberDetails(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateProfileBusiness';
    print("sendBusinessMemberDetails url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print(
            "sendBusinessMemberDetails Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("sendBusinessMemberDetails Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> sendMoreInfoMemberDetails(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateProfileOther';
    print("UpdateProfileOther url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("UpdateProfileOther Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("UpdateProfileOther Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<String> sendBusinessWebAndEmail(String website, String email,
      String memberid, String about, String deviceType) async {
    String url = SOAP_API_URL +
        'UpdateMember?type=update&website=$website&email=$email&memberid=$memberid&about=$about&deviceType=$deviceType';
    print("sendBusinessWebAndEmail URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        String dataRes;
        print("sendBusinessWebAndEmail response: " + response.data.toString());
        var memberDataClass = json.decode(response.data);
        print('=======sss========${memberDataClass.runtimeType}');
        print('=======sss========${memberDataClass["IsRecord"].runtimeType}');
        if (memberDataClass["IsSuccess"] == false &&
            memberDataClass["IsRecord"] == false) {
          dataRes = memberDataClass["Data"].toString();
          print('=======ss=======${dataRes}');
        } else {
          dataRes = '';
        }
        return dataRes;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("sendBusinessWebAndEmail error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  /*static Future<SaveDataClass> UploadMemberImage(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateProfilePhoto';
    print("SaveOffer : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        print("SaveOffer Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }*/

  static Future<SaveDataClass> UploadMemberImage(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateProfilePhoto';
    print("UploadMemberImage : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var memberDataClass = json.decode(jsonData);

        print("UploadMemberImage Response: " +
            memberDataClass["ResponseData"].toString());

        saveData.Message =
            memberDataClass["ResponseData"]["Message"].toString();
        saveData.IsSuccess =
            bool.fromEnvironment(memberDataClass["ResponseData"]["IsSuccess"]);
        saveData.IsRecord =
            bool.fromEnvironment(memberDataClass["ResponseData"]["IsRecord"]);
        saveData.Data = memberDataClass["ResponseData"]["Data"].toString();

        return saveData;
      } else {
        print("UploadMemberImageError Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("UploadMemberImageError Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //get Event From Server
  static Future<List> GetDashboard(
      String chapterId, String startdate, String enddate) async {
    String url = API_URL +
        'GetDashboardEvent?chapterId=$chapterId&startdate=$startdate&enddate=$enddate';
    print("GetDashboardEvent URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetDashboardEvent Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetDashboardEvent Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Event From Server
  static Future<List> GetMeetingListByDate(
      String chapterId, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url = API_URL +
        'GetMeetingListWithConformation?chapterId=$chapterId&eventdate=$date&memberId=$memberId';
    //API_URL + 'GetMeetingListByDate?chapterId=$chapterId&eventdate=$date';
    print("GetMeetingListByDate URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetMeetingListByDate Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMeetingListByDate Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Event From Server
  static Future<List> GetEventByDate(String chapterId, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);
    String url = API_URL +
        'GetEventListWithConformation?chapterId=$chapterId&eventdate=$date&memberId=$memberId';
    //API_URL + 'GetEventByDate?chapterId=$chapterId&eventdate=$date';
    print("GetEventByDate URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetEventByDate Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetEventByDate Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> AddEventConformation(body) async {
    print(body.toString());
    String url = API_URL + 'AddEventConformation';
    print("AddEventConformation url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("AddEventConformation Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddEventConformation");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddEventConformation ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> AddMeetingConformation(body) async {
    print(body.toString());
    String url = API_URL + 'AddMeetingConformation';
    print("AddMeetingConformation url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("AddMeetingConformation Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddMeetingConformation");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddMeetingConformation ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //=============by rinki
  static Future<SaveDataClass> AddGuestEventConfirmation(body) async {
    print(body.toString());
    String url = API_URL + 'UpdatePaymentForEvent';
    print("AddGuestEventConfirmation url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print(
            "AddGuestEventConfirmation Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestEventConfirmation");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddGuestEventConfirmation ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> AddGuestEventRegistrationConfirmation(
      String MemberID, String EventID) async {
    // print(body.toString());
    //String url = cnst.SOAP_API_URL + 'RegisterForEvent';
    String url =
        "http://pmc.studyfield.com/Service.asmx/RegisterForEvent?MemberID=$MemberID&EventID=$EventID";
    print("AddGuestEventRegistrationConfirmation url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "0");

        var memberDataClass = jsonDecode(response.data);
        print("AddGuestEventRegistrationConfirmation Response: " +
            memberDataClass.toString());

        saveData.Message = memberDataClass["MESSAGE"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"];

        return saveData;
      } else {
        print("Error AddGuestEventRegistrationConfirmation  ");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddGuestEventRegistrationConfirmation ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> GuestEventPaymentGateWay(String MemberID,
      String EventID, String TransactionId, String Amount) async {
    // print(body.toString());
    //String url = cnst.SOAP_API_URL + 'RegisterForEvent';
    String url =
        "http://pmc.studyfield.com/Service.asmx/UpdatePaymentForEvent?MemberID=$MemberID&EventID=$EventID&TransactionId=$TransactionId&Amount=$Amount";
    print("GuestEventPaymentGateWay url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "0");

        print("GuestEventPaymentGateWay Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);

        saveData.Message = memberDataClass["MESSAGE"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"];

        return saveData;
      } else {
        print("Error GuestEventPaymentGateWay  ");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GuestEventPaymentGateWay ${e.toString()}");
      throw Exception(e.toString());
    }
  }

//===================
  static Future<SaveDataClass> sendTestimonial(body) async {
    print(body.toString());
    String url = API_URL + 'SaveTestimonial';
    print("SaveTestimonial url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SaveTestimonial Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //get member Profile From Server
  static Future<List> GetTestimonial(String memberId) async {
    String url = API_URL + 'GetTestimonialByMemberId?memberId=$memberId';
    print(" member Profile URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print(" member Profile URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("member Profile URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get member Profile From Server
  static Future<SaveDataClass> DeleteTestimonial(String memberId) async {
    String url = API_URL + 'DeleteTestimonial?testimonialId=$memberId';
    print(" DeleteTestimonial URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SaveTestimonial Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("DeleteTestimonial URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get member Profile From Server
  static Future<List> getAttenddance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);
    String chapterId = prefs.getString(Session.ChapterId);

    String url = API_URL +
        'GetMemberAttendanceData?ChapterId=$chapterId&MemberId=$memberId';
    print(" member Profile URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print(" member Profile URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("member Profile URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  /*static Future<List<ProfessionClass>> GetProffesion() async {
    String url = API_URL + 'GetProffesion';
    print("getLastJoin URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<ProfessionClass> list = [];
        print("MemberLogin Response: " + response.data.toString());

        //final jsonResponse = json.decode(response.data);

        ProfessionDataClass memberDataClass =
        new ProfessionDataClass.fromJson(response.data);

        if (memberDataClass.IsSuccess == true && memberDataClass.Data.length>0)
          list = memberDataClass.Data;
        else
          list = null;
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }*/

  static Future<List<ProfessionClass>> GetProffesion() async {
    String url = API_URL + 'GetProffesion';
    print("GetPurposeofJoin URL: " + url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<ProfessionClass> list = [];
        print("GetPurposeofJoin Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        ProfessionDataClass purposeClassData =
            new ProfessionDataClass.fromJson(jsonResponse);

        if (purposeClassData.IsRecord == true)
          list = purposeClassData.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception("Internet Error");
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> sendDailyProgress(body) async {
    print(body.toString());
    String url = API_URL + 'SaveDailyTask';
    print("SaveDailyTask url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SaveDailyTask Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("SaveDailyTask Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("SaveDailyTask  error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //get Daily profress From Server
  static Future<List> GetDailyProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url = API_URL + 'GetDailyTaskByMemberId?memberId=$memberId';
    print("Download URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Download: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Download : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Notification From Server
  static Future<List> GetNotificationFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url = API_URL + 'GetNotificationByMemberId?memberId=$memberId';
    print("Download URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Download: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Download : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<ChapterClass>> GetChapterData() async {
    String url = API_URL + 'GetChapterList';
    print("GetChapterList URL: " + url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<ChapterClass> list = [];
        print("GetChapterList Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        ChapterDataClass purposeClassData =
            new ChapterDataClass.fromJson(jsonResponse);

        if (purposeClassData.IsRecord == true)
          list = purposeClassData.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception("Internet Error");
      }
    } catch (e) {
      print("GetChapterList Erorr : " + e.toString());
      throw Exception(e);
    }
  }

//GetSettings
  static Future<List> GetUserSettings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String chapterid = preferences.getString(Session.ChapterId);
    String url = API_URL + 'GetSettings';
    print("GetSettings URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetSettings Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["IsRecord"] == true) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSettings Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetUserScan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String chapterid = preferences.getString(Session.ChapterId);
    String url = API_URL + 'GetSettings';
    print("GetSettings URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetSettings Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["IsRecord"] == true) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSettings Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetCMSPages() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String chapterid = preferences.getString(Session.ChapterId);
    String url = API_URL + 'GetCMSPage';
    print("GetCMSOages URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetCMSOages Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["IsRecord"] == true) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetCMSOages Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getStatesCities() async {
    String url =
        "https://raw.githubusercontent.com/nshntarora/Indian-Cities-JSON/master/cities.json";
    print("getStatesCities Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        var getStatesCitiesList = json.decode(response.data);
        print("getStatesCities Response" + response.data.toString());

        // final jsonResponse = response.data;
        return getStatesCitiesList;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetState Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> AddGuest(String type, String Name,
      String MobileNo, String MemberId, String City, String State) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String memberId = prefs.getString(Session.MemberId);
    String url = SOAP_API_URL +
        'InsertGeneralGuest?type=$type&Name=$Name&MobileNo=$MobileNo&MemberId=$MemberId&City=$City&State=$State';
    print("InsertGeneralGuest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        String list = "";
        print("InsertGeneralGuest URL: " + response.data.toString());
        // var responseData = response.data;
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = jsonDecode(response.data);
        print("InsertGeneralGuest Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
        // if (responseData["IsSuccess"] == true &&
        //     responseData["IsRecord"] == true) {
        //   list = responseData["Data"];
        // } else {
        //   list = "";
        // }
        // return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("InsertGeneralGuest URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
    // String url = SOAP_API_URL + 'InsertGeneralGuest';
    // print("AddGuest url : " + url);
    // try {
    //   final response = await dio.post(url, data: body);
    //   if (response.statusCode == 200) {
    //     SaveDataClass saveData = new SaveDataClass(
    //         Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);
    //
    //     print("AddGuest Response: " + response.data.toString());
    //     var responseData = response.data;
    //
    //     saveData.Message = responseData["Message"];
    //     saveData.IsSuccess = responseData["IsSuccess"];
    //     saveData.IsRecord = responseData["IsRecord"];
    //     saveData.Data = responseData["Data"].toString();
    //
    //     return saveData;
    //   } else {
    //     print("Error AddGuest");
    //     throw Exception(response.data.toString());
    //   }
    // } catch (e) {
    //   print("Error AddGuest ${e.toString()}");
    //   throw Exception(e.toString());
    // }
  }

  //============by rinki
  static Future<SaveDataClass> AddGuestCountry(
      String type,
      String Country,
      String Name,
      String MobileNo,
      String MemberId,
      String City,
      String State) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String memberId = prefs.getString(Session.MemberId);
    String url = SOAP_API_URL +
        'InsertGeneralGuest?type=$type&Name=$Name&Country=$Country&MobileNo=$MobileNo&MemberId=$MemberId&City=$City&State=$State';
    print("InsertGeneralGuest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        String list = "";
        print("InsertGeneralGuest URL: " + response.data.toString());
        // var responseData = response.data;
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = jsonDecode(response.data);
        print("InsertGeneralGuest Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
        // if (responseData["IsSuccess"] == true &&
        //     responseData["IsRecord"] == true) {
        //   list = responseData["Data"];
        // } else {
        //   list = "";
        // }
        // return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("InsertGeneralGuest URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
    // String url = SOAP_API_URL + 'InsertGeneralGuest';
    // print("AddGuest url : " + url);
    // try {
    //   final response = await dio.post(url, data: body);
    //   if (response.statusCode == 200) {
    //     SaveDataClass saveData = new SaveDataClass(
    //         Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);
    //
    //     print("AddGuest Response: " + response.data.toString());
    //     var responseData = response.data;
    //
    //     saveData.Message = responseData["Message"];
    //     saveData.IsSuccess = responseData["IsSuccess"];
    //     saveData.IsRecord = responseData["IsRecord"];
    //     saveData.Data = responseData["Data"].toString();
    //
    //     return saveData;
    //   } else {
    //     print("Error AddGuest");
    //     throw Exception(response.data.toString());
    //   }
    // } catch (e) {
    //   print("Error AddGuest ${e.toString()}");
    //   throw Exception(e.toString());
    // }
  }

  static Future<SaveDataClass> AddGuestList(body) async {
    print(body.toString());
    String url = API_URL + 'SaveGeneralEventVisitorList';
    print("AddGuestList url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("AddGuestList Response: " + response.data.toString());
        var responseData = response.data;

        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.IsRecord = responseData["IsRecord"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddGuestList ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetEventVisitor(String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.MemberId);
    String url = SOAP_API_URL +
        'GeneralEventVisitorList?EventId=$eventId&MemberId=$memberId';
    print("GetEventVistor URL: " + url);
    try {
      Response response = await dio.get(url);
      // if (response.statusCode == 200) {
      //   GuestData saveData = new GuestData(
      //       Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);
      //
      //   print("GetEventVistor Response: " + response.data.toString());
      //   var responseData = jsonDecode(response.data);
      //   print("responseData");
      //   print(responseData.toString());
      //   saveData.Message = responseData["Message"];
      //   saveData.IsSuccess = responseData["IsSuccess"];
      //   saveData.IsRecord = responseData["IsRecord"];
      //   saveData.Data = responseData["Data"];
      //   print("saveData");
      //   print(saveData);
      //   return saveData.Data;
      //   // String list = "";
      //   // print("GetEventVistor URL: " + response.data.toString());
      //   // var responseData = response.data;
      //   // print("responseData");
      //   // print(responseData[0]);
      //   // if (responseData!=null) {
      //   //   print("anirudh");
      //   //   print(responseData["Data"]);
      //   //   list = responseData;
      //   // } else {
      //   //   list = "";
      //   // }
      //   // return "list";
      // } else {
      //   throw Exception(MESSAGES.INTERNET_ERROR);
      // }
      if (response.statusCode == 200) {
        List list = [];
        print("GetEventVistor URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetEventVistor error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<eventClass>> GetGeneralEvents() async {
    String url = API_URL + 'GeneralEventList';
    print("GetGeneralEvents URL: " + url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<eventClass> list = [];
        print("GetGeneralEvents Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        eventClassData eventData = new eventClassData.fromJson(jsonResponse);

        if (eventData.IsRecord == true)
          list = eventData.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetGeneralEvents URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> AddVisitorToEvent(body) async {
    print(body.toString());
    String url = API_URL + 'SaveGeneralEventVisitorInvite';
    print("AddVisitorToEvent url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("AddVisitorToEvent Response: " + response.data.toString());
        var responseData = response.data;

        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.IsRecord = responseData["IsRecord"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddVisitorToEvent ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> ScanVisitor(String id, String memberId) async {
    String url = API_URL + 'ScanGeneralEventInvite?id=$id&memberId=$memberId';
    print("ScanVisitor url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("ScanVisitor Response: " + response.data.toString());
        var responseData = response.data;

        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.IsRecord = responseData["IsRecord"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error ScanVisitor");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error ScanVisitor ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SyncVisitorData(body) async {
    String url = API_URL + 'ScanGeneralEventInviteList';
    print("SyncVisitorData url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("SyncVisitorData Response: " + response.data.toString());
        var responseData = response.data;

        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.IsRecord = responseData["IsRecord"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SyncVisitorData ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetLastEvent() async {
    String url = API_URL + 'GetLastGeneralEvent';
    print("GetLastGeneralEvent URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetLastGeneralEvent URL: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true &&
            responseData["IsRecord"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      }
    } catch (e) {
      print("GetLastGeneralEvent URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<String> ShrinkURL(String Id) async {
    String url = API_URL + 'ShrinkURL?id=$Id';
    print("Shrink URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        String Url = "";
        print("Shrink URL: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true &&
            responseData["IsRecord"] == true) {
          Url = responseData["Data"];
        } else {
          Url = "";
        }
        return Url;
      }
    } catch (e) {
      print("Shrink URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> AddvisitorByMobilenumber(
      String MobileNo, String MemberId) async {
    String url = API_URL +
        'ScanGeneralEventInviteByMobile?mobileNo=$MobileNo&memberId=$MemberId';
    print("ScanGeneralEventInviteByMobile url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("ScanGeneralEventInviteByMobile Response: " +
            response.data.toString());
        var responseData = response.data;

        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.IsRecord = responseData["IsRecord"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error ScanGeneralEventInviteByMobile ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> DeleteGuest(String id) async {
    String url = API_URL + 'DeleteGeneralEventVisitor?id=$id';
    print("Delete Guest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("Delete Guest Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Delete Guest Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  //get Event From Server
  static Future<List> GetOfficeBookingCalender(
      String startdate, String enddate) async {
    String url = API_URL +
        'GetBookingDetailsByDateRange?FromDate=$startdate&ToDate=$enddate';
    print("GetDashboardEvent URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetBookingDetailsByDateRange Response: " +
            response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetBookingDetailsByDateRange Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //get Event From Server
  static Future<List> GetOfficeBookingByDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url = API_URL + 'GetBookingDetailsByDate?Date=$date';
    //API_URL + 'GetMeetingListByDate?chapterId=$chapterId&eventdate=$date';
    print("GetBookingDetailsByDate URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetBookingDetailsByDate Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetBookingDetailsByDate Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> sendRequestBooking(body) async {
    print(body.toString());
    String url = API_URL + 'NewOfficeBooking';
    print("NewOfficeBooking url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("NewOfficeBooking Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("NewOfficeBooking Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("NewOfficeBooking  error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetMyOfficeBooking() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String MemeberId = pres.getString(Session.MemberId);
    String url = API_URL + 'GetMyOfficeBooking?MemeberId=$MemeberId';
    print("GetMyOfficeBooking URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetMyOfficeBooking URL: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true &&
            responseData["IsRecord"] == true) {
          print(responseData["Data"]);
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMyOfficeBooking URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> DeleteMyBooking(int BookingId) async {
    String url = cnst.API_URL + 'DeleteMyBooking?BookingId=$BookingId';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        var responseData = response.data;

        print("DeleteMyBooking Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteMyBooking Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error DeleteMyBooking Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetMyAsk(String MemberId) async {
    String url = API_URL1 + 'GetMyAsks?id=$MemberId';
    print("GetMyAsks List URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetMyAsks List Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMyAsks List Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> AddMyTask(body) async {
    print(body.toString());
    String url = API_URL1 + 'AddTask';
    print("AddTask url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: null);

        print("AddTask Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.IsRecord = memberDataClass["IsRecord"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("AddTask Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("AddTask  error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> AddFaceToFace(body) async {
    print(body.toString());
    String url = cnst.API_URL1 + 'AddFaceToFace';
    print("AddFaceToFace : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print(
            "AddFaceToFace Response: " + responseData["ResultData"].toString());
        print("Res:  ${responseData}");
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetFaceToFace(String id) async {
    String url = cnst.API_URL1 + 'GetFaceToFace?id=$id';
    print("GetAd URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAd Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAd Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateMyAsk(body) async {
    print(body.toString());
    String url = cnst.API_URL1 + 'EditAsk';
    print("EditAsk : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = response.data;

        print("EditAsk Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  /* static Future<SaveDataClass> DeleteMyAsks(body) async {
    print(body.toString());
    String url = cnst.API_URL1 + 'DeleteAsk';
    print("DeleteAsk : " + url);

    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
        new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        print("DeleteAsk Response: " +
           ["ResultData"].toString());
        saveData.Message = ["Message"].toString();
        saveData.IsSuccess = ["IsSuccess"] == "true";
        saveData.Data = ["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }*/

  static Future<SaveDataClass> DeleteMyAsks(body) async {
    String url = cnst.API_URL1 + 'DeleteAsk';
    print("DeleteAsk Url url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("DeleteAsk Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        print("msg: ${saveData.Message}");
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteAsk Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error DeleteAsk Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> DeleteFaceToFace(body) async {
    String url = cnst.API_URL1 + 'DeleteFaceToFace';
    print("DeleteFaceToFace Url url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("DeleteFaceToFace Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        print("msg: ${saveData.Message}");
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteFaceToFace Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error DeleteFaceToFace Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //by rinki

  //InsertBookIssue
  static Future<SaveDataClass> SaveIssueBook(
      String bookid, String fromDate, String toDate) async {
    var from = fromDate.split(" ");
    var to = toDate.split(" ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.get(cnst.Session.MemberId);
    String url = cnst.SOAP_API_URL +
        'InsertBookIssue?type=bookissue&bookid=$bookid&memberid=$MemberId&issuedt=${from[0]}&returndt=${to[0]}';
    print("SaveIssueBook url : " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = jsonDecode(response.data);
        print("SaveIssueBook Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

//InsertBookReview
  static Future<SaveDataClass> SaveBookReview(
      String bookid, String fromDate, edtReviewController, _rating) async {
    var from = fromDate.split(" ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.get(cnst.Session.MemberId);
    String url = cnst.SOAP_API_URL +
        'InsertBookReview?type=bookreview&bookid=$bookid&memberid=$MemberId&reviewdt=${from[0]}&bookreview=$edtReviewController&bookrating=$_rating';
    print("SaveBookReview url : " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = jsonDecode(response.data);
        print("SaveBookReview Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //InsertProperty
  static Future<SaveDataClass> SaveInsertPopertysale(
      dropdownType,
      dropdownPtype,
      edtAddressController,
      edtLocationController,
      edtCarpetAreaController,
      dropdownCarpetArea,
      edtPriceController,
      dropdownPriority,
      edtGoogleMapController,
      dropdownsalerent,
      edtAdditionalDesController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.get(cnst.Session.MemberId);
    String ChapterId = prefs.get(cnst.Session.ChapterId);
    String url = cnst.SOAP_API_URL +
        'InsertProperty?type=insertproperty&Nature=$dropdownType&PType=$dropdownPtype&Address=$edtAddressController&Area=$edtLocationController&AreaValue=$edtCarpetAreaController&Unit=$dropdownCarpetArea&Price=$edtPriceController&Intensity=$dropdownPriority&GoogleMap=$edtGoogleMapController&PropertyType=$dropdownsalerent&MemberId=$MemberId&ChapterId=$ChapterId&Description=$edtAdditionalDesController';
    print("SaveInsertproperty url : " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = jsonDecode(response.data);
        print("SaveInsertPopertysale Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> UpdatePropertySale(
    dropdownType,
    dropdownPtype,
    edtAddressController,
    edtLocationController,
    edtCarpetAreaController,
    dropdownCarpetArea,
    edtPriceController,
    dropdownPriority,
    edtGoogleMapController,
    dropdownsalerent,
    edtAdditionalDesController,
    propertyId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.get(cnst.Session.MemberId);
    String ChapterId = prefs.get(cnst.Session.ChapterId);
    //String Id = prefs.get(cnst.Session.);
    String url = cnst.SOAP_API_URL +
        'UpdateProperty?type=updateproperty&Nature=$dropdownType&PType=$dropdownPtype&Address=$edtAddressController&Area=$edtLocationController&AreaValue=$edtCarpetAreaController&Unit=$dropdownCarpetArea&Price=$edtPriceController&Intensity=$dropdownPriority&GoogleMap=$edtGoogleMapController&PropertyType=$dropdownsalerent&MemberId=$MemberId&ChapterId=$ChapterId&Description=$edtAdditionalDesController&Id=$propertyId';
    print("UpdateProperty url : " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = jsonDecode(response.data);
        print("UpdateProperty Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SaveInsertPopertyRent(
      dropdownType1,
      dropdownPtype1,
      edtAddressController1,
      edtLocationController1,
      edtCarpetAreaController1,
      dropdownCarpetArea1,
      edtPriceController1,
      dropdownPriority1,
      edtGoogleMapController1,
      dropdownsalerent1,
      edtAdditionalDesController1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.get(cnst.Session.MemberId);
    String ChapterId = prefs.get(cnst.Session.ChapterId);
    String url = cnst.SOAP_API_URL +
        'InsertProperty?type=insertproperty&Nature=$dropdownType1&PType=$dropdownPtype1&Address=$edtAddressController1&Area=$edtLocationController1&AreaValue=$edtCarpetAreaController1&Unit=$dropdownCarpetArea1&Price=$edtPriceController1&Intensity=$dropdownPriority1&GoogleMap=$edtGoogleMapController1&PropertyType=$dropdownsalerent1&MemberId=$MemberId&ChapterId=$ChapterId&Description=$edtAdditionalDesController1';
    print("SaveIssueBook url : " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = jsonDecode(response.data);
        print("SaveInsertPopertyRent Response: " + responseData.toString());
        saveData.Message = responseData["MESSAGE"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString().toLowerCase() == "true"
                ? true
                : false;
        saveData.IsRecord =
            responseData["IsRecord"].toString().toLowerCase() == "true"
                ? true
                : false;

        return saveData;
      } else {
        print("Error Kap1");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Kap ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetPropertyData(String fieldname) async {
    //String url = cnst.SOAP_API_URL + 'ViewPropertyData?type=propertydata';
    String url = cnst.SOAP_API_URL +
        'ViewPropertyData?type=propertydata&field=$fieldname';
    print("PropertyData URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("PropertyData URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          print("****************************************123");
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("PropertyData URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> SearchPropertyData(
      String Area,
      String ptype,
      String budgetfrom,
      String budgetto,
      String nature,
      String propertytype) async {
    //String url = cnst.SOAP_API_URL + 'ViewPropertyData?type=propertydata';
    String url = cnst.SOAP_API_URL +
        'SearchProperty?type=searchproperty&Area=$Area&PType=$ptype&BudgetFrom=$budgetfrom&BudgetTo=$budgetto&Nature=$nature&PropertyType=$propertytype';
    print("Searchpropertydata URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Searchpropertydata URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        print("hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
        print(memberDataClass[0]["IsSuccess"]);
        print("heloooooooooooooooooooooooooooooooooooooooooo");
        if (memberDataClass[0]["IsSuccess"] == true &&
            memberDataClass[0]["IsRecord"] == true) {
          list = memberDataClass[0]["Data"];
        }

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Searchpropertydata URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetBookReview(String bookid) async {
    //String url = cnst.SOAP_API_URL + 'ViewPropertyData?type=propertydata';
    String url =
        cnst.SOAP_API_URL + 'getBookReviews?type=bookreview&bookid=$bookid';
    print("GetBookReviews URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetBookReviews URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          print("****************************************123");
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("PropertyData URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetBookListing() async {
    String url = cnst.SOAP_API_URL + 'ViewBooks?type=books';
    print("BookList URL: " + url);

    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("BookList URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("BookList URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> VerifyOTP() async {
    String url = cnst.SOAP_API_URL + 'OTPVerify';
    print("OTPVerify : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = jsonDecode(response.data);

        print("OTPVerify Response: " + responseData.toString());

        saveData.Message = responseData["Message"];
        saveData.IsSuccess =
            responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"];

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("OTPVerify Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetGuestEventData(String MemberId) async {
    String url = cnst.SOAP_API_URL +
        'GetMeetingData?type=meeting&chapterid=0&memberid=$MemberId';
    print("GuestEvent Data URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GuestEvent Data URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GuestEvent Data URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  // ====by rinki
  static Future<List> GuestEventData1(String Mobile) async {
    String url = cnst.SOAP_API_URL + 'CheckEventRegistration?Mobile=$Mobile';
    print("Event Guest Data URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Event Guest Data URL: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Event Guest Data URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GuestRegistrationForEvent(
      String MemberId, String EventId) async {
    String url = cnst.SOAP_API_URL +
        'RegisterForEvent?MemberId=$MemberId&EventId=$EventId';
    print("Event GuestRegistrationForEvent Data URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Event GuestRegistrationForEvent Data URL: " +
            response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Event GuestRegistrationForEvent Data URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

//=================================
  static Future<List> EventCount(String EventId) async {
    String url =
        cnst.SOAP_API_URL + 'ViewScanEventMembers?type=event&eventid=$EventId';
    var response;
    print(url);
    try {
      response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("Response: " + response.data.toString());
        var responseData = json.decode(response.data);
        if (responseData["RECORDS"] == true &&
            responseData["Data"].length > 0) {
          print(responseData["Data"]);
          list = responseData["Data"];
        }
        return list;
      } else {
        print("error ->" + response.data.toString());
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("error -> ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
