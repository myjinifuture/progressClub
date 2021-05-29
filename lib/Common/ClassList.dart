class SaveDataClass {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  String Data;
  SaveDataClass({this.Message, this.IsSuccess, this.IsRecord, this.Data});
// factory SaveDataClass.fromJson(Map<String, dynamic> json) {
//   return SaveDataClass(
//       Message: json['MESSAGE'] as String,
//       ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
//       ERROR_STATUS: json['ERROR_STATUS'] as bool,
//       RECORDS: json['RECORDS'] as bool);
// }
}

class GuestData {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  List<GuestClass> Data;

  GuestData({
    this.Message,
    this.IsSuccess,
    this.IsRecord,
    this.Data,
  });

  factory GuestData.fromJson(Map<String, dynamic> json) {
    return GuestData(
      Message: json['MESSAGE'] as String,
      IsSuccess: json['IsSuccess'] as bool,
      IsRecord: json['IsRecord'] as bool,
      Data: json['Data']
          .map<GuestClass>((json) => GuestClass.fromJson(json))
          .toList(),
    );
  }
}
class SaveDataClass1 {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;

  SaveDataClass1(
      {this.MESSAGE, this.ORIGINAL_ERROR, this.ERROR_STATUS, this.RECORDS});

  factory SaveDataClass1.fromJson(Map<String, dynamic> json) {
    return SaveDataClass1(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool);
  }
}

class pcsignupData {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;

  pcsignupData(
      {this.MESSAGE, this.ORIGINAL_ERROR, this.ERROR_STATUS, this.RECORDS});

// factory pcsignupData.fromJson(Map<String, dynamic> json) {
//   return pcsignupData(
//       MESSAGE: json['MESSAGE'] as String,
//       ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
//       ERROR_STATUS: json['ERROR_STATUS'] as bool,
//       RECORDS: json['RECORDS'] as bool);
// }
}

class DashboardCountClass {
  String visitors;
  String share;
  String calls;
  String cardAmount;

  DashboardCountClass({this.visitors, this.share, this.calls, this.cardAmount});

  factory DashboardCountClass.fromJson(Map<String, dynamic> json) {
    return DashboardCountClass(
        visitors: json['visitors'] as String,
        share: json['share'] as String,
        calls: json['calls'] as String,
        cardAmount: json['cardAmount'] as String);
  }
}

class BusinessCategoryClass {
  String businessId;
  String businessName;
}

/*ProfessionDataClass welcomeFromJson(String str) {
  final jsonData = json.decode(str);
  return ProfessionDataClass.fromJson(jsonData);
}

String welcomeToJson(ProfessionDataClass data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}*/

class ProfessionDataClass {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  List<ProfessionClass> Data;

  ProfessionDataClass({
    this.Message,
    this.IsSuccess,
    this.IsRecord,
    this.Data,
  });

  factory ProfessionDataClass.fromJson(Map<String, dynamic> json) {
    return ProfessionDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        IsRecord: json['IsRecord'] as bool,
        Data: json['Data']
            .map<ProfessionClass>((json) => ProfessionClass.fromJson(json))
            .toList());
  }

/*factory ProfessionDataClass.fromJson(Map<String, dynamic> json) =>
      new ProfessionDataClass(
          Message: json["Message"] == null ? null : json["Message"],
          IsSuccess: json["IsSuccess"] == null ? null : json["IsSuccess"],
          IsRecord: json["IsRecord"] == null ? null : json["IsRecord"],
          Data: json["data"] == null
              ? null
              : new List<ProfessionClass>.from(
                  json["data"].map((x) => ProfessionClass.fromJson(x))));*/

/*  Map<String, dynamic> toJson() => {
        "IsSuccess": IsSuccess == null ? null : IsSuccess,
        "Message": Message == null ? null : Message,
        "IsRecord": IsRecord == null ? null : IsRecord,
        "Data": Data == null
            ? null
            : new List<dynamic>.from(Data.map((x) => x.toJson()))
      };*/
}

class ProfessionClass {
  int Id;
  String Profession;

  ProfessionClass({this.Id, this.Profession});

  factory ProfessionClass.fromJson(Map<String, dynamic> json) {
    return ProfessionClass(
        Id: json['Id'] as int, Profession: json['Profession'] as String);
  }

/*Map<String, dynamic> toJson() => {
        "Id": Id == null ? "" : Id,
        "Profession": Profession == null ? null : Profession,
      };*/
}

class GuestClass {
  int Id, MemberId, status;
  String MobileNo, Name, City, State;

  GuestClass({
    this.Id,
    this.MemberId,
    this.MobileNo,
    this.Name,
    this.City,
    this.State,
    this.status,
  });

  factory GuestClass.fromJson(Map<String, dynamic> json) {
    return GuestClass(
      Id: json['Id'] as int,
      MemberId: json['MemberId'] as int,
      MobileNo: json['MobileNo'],
      Name: json['Name'],
      City: json['City'],
      State: json['State'],
      status: json['status'] as int,
    );
  }

/*Map<String, dynamic> toJson() => {
        "Id": Id == null ? "" : Id,
        "Profession": Profession == null ? null : Profession,
      };*/
}

class ChapterDataClass {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  List<ChapterClass> Data;

  ChapterDataClass({
    this.Message,
    this.IsSuccess,
    this.IsRecord,
    this.Data,
  });

  factory ChapterDataClass.fromJson(Map<String, dynamic> json) {
    return ChapterDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        IsRecord: json['IsRecord'] as bool,
        Data: json['Data']
            .map<ChapterClass>((json) => ChapterClass.fromJson(json))
            .toList());
  }
}

class stateClass {
  String id;
  String name;

  stateClass({this.id, this.name});

  factory stateClass.fromJson(Map<String, dynamic> json) {
    return stateClass(
        id: json['Id'].toString() as String,
        name: json['Title'].toString() as String);
  }
}

class stateClassData {
  String Message;
  bool IsSuccess;
  List<stateClass> Data;

  stateClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory stateClassData.fromJson(Map<String, dynamic> json) {
    return stateClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<stateClass>((json) => stateClass.fromJson(json))
            .toList());
  }
}

class ChapterClass {
  int ChapterId;
  String ChapterName;

  ChapterClass({this.ChapterId, this.ChapterName});

  factory ChapterClass.fromJson(Map<String, dynamic> json) {
    return ChapterClass(
        ChapterId: json['ChapterId'] as int,
        ChapterName: json['ChapterName'] as String);
  }
}

class MemberDataClass {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  List<MemberClass> Data;

  MemberDataClass({
    this.Message,
    this.IsSuccess,
    this.IsRecord,
    this.Data,
  });

  factory MemberDataClass.fromJson(Map<String, dynamic> json) {
    return MemberDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        IsRecord: json['IsRecord'] as bool,
        Data: json['Data']
            .map<MemberClass>((json) => MemberClass.fromJson(json))
            .toList());
  }
}

class MemberDataClass1 {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<MemberClass1> Data;

  MemberDataClass1(
      {this.MESSAGE,
      this.ORIGINAL_ERROR,
      this.ERROR_STATUS,
      this.RECORDS,
      this.Data});

  factory MemberDataClass1.fromJson(Map<String, dynamic> json) {
    return MemberDataClass1(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<MemberClass1>((json) => MemberClass1.fromJson(json))
            .toList());
  }
}

class MemberClass1 {
  String Id;
  String Name;
  String Company;
  String Role;
  String website;
  String About;
  String Image;
  String Mobile;
  String Email;
  String Whatsappno;
  String Facebooklink;
  String CompanyAddress;
  String CompanyPhone;
  String CompanyUrl;
  String CompanyEmail;
  String GMap;
  String Twitter;
  String Google;
  String Linkedin;
  String Youtube;
  String Instagram;
  String CoverImage;
  String MyReferralCode;
  String RegistrationRefCode;
  String JoinDate;
  String ExpDate;
  String MemberType;
  String RegistrationPoints;
  String PersonalPAN;
  String CompanyPAN;
  String GstNo;
  String AboutCompany;
  String ShareMsg;
  bool IsActivePayment;

  MemberClass1({
    this.Id,
    this.Name,
    this.Company,
    this.Role,
    this.website,
    this.About,
    this.Image,
    this.Mobile,
    this.Email,
    this.Whatsappno,
    this.Facebooklink,
    this.CompanyAddress,
    this.CompanyPhone,
    this.CompanyUrl,
    this.CompanyEmail,
    this.GMap,
    this.Twitter,
    this.Google,
    this.Linkedin,
    this.Youtube,
    this.Instagram,
    this.CoverImage,
    this.MyReferralCode,
    this.RegistrationRefCode,
    this.JoinDate,
    this.ExpDate,
    this.MemberType,
    this.RegistrationPoints,
    this.PersonalPAN,
    this.CompanyPAN,
    this.GstNo,
    this.AboutCompany,
    this.ShareMsg,
    this.IsActivePayment,
  });

  factory MemberClass1.fromJson(Map<String, dynamic> json) {
    return MemberClass1(
      Id: json['Id'] as String,
      Name: json['Name'] as String,
      Company: json['Company'] as String,
      Role: json['Role'] as String,
      website: json['website'] as String,
      About: json['About'] as String,
      Image: json['Image'] as String,
      Mobile: json['Mobile'] as String,
      Email: json['Email'] as String,
      Whatsappno: json['Whatsappno'] as String,
      Facebooklink: json['Facebooklink'] as String,
      CompanyAddress: json['CompanyAddress'] as String,
      CompanyPhone: json['CompanyPhone'] as String,
      CompanyUrl: json['CompanyUrl'] as String,
      CompanyEmail: json['CompanyEmail'] as String,
      GMap: json['Map'] as String,
      Twitter: json['Twitter'] as String,
      Google: json['Google'] as String,
      Linkedin: json['Linkedin'] as String,
      Youtube: json['Youtube'] as String,
      Instagram: json['Instagram'] as String,
      CoverImage: json['CoverImage'] as String,
      MyReferralCode: json['MyReferralCode'] as String,
      RegistrationRefCode: json['RegistrationRefCode'] as String,
      JoinDate: json['JoinDate'] as String,
      ExpDate: json['ExpDate'] as String,
      MemberType: json['MemberType'] as String,
      RegistrationPoints: json['RegistrationPoints'] as String,
      PersonalPAN: json['PersonalPAN'] as String,
      CompanyPAN: json['CompanyPAN'] as String,
      GstNo: json['GstNo'] as String,
      AboutCompany: json['AboutCompany'] as String,
      ShareMsg: json['ShareMsg'] as String,
      IsActivePayment: json['IsActivePayment'] as bool,
    );
  }
}

class MemberClass {
  int MemberId;
  String Company;
  String Id;
  String MemberName;

  MemberClass({this.MemberId, this.MemberName, this.Id, this.Company});

  factory MemberClass.fromJson(Map<String, dynamic> json) {
    return MemberClass(
        MemberId: json['Id'] as int,
        MemberName: json['Name'] as String,
        Company: json["CompanyName"] as String);
  }
}

class eventClassData {
  String Message;
  bool IsSuccess;
  bool IsRecord;
  List<eventClass> Data;

  eventClassData({
    this.Message,
    this.IsSuccess,
    this.IsRecord,
    this.Data,
  });

  factory eventClassData.fromJson(Map<String, dynamic> json) {
    return eventClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        IsRecord: json['IsRecord'] as bool,
        Data: json['Data']
            .map<eventClass>((json) => eventClass.fromJson(json))
            .toList());
  }
}

class eventClass {
  String eventId;
  String eventName;
  String InviteMsg;
  bool status;

  eventClass({this.eventId, this.eventName, this.InviteMsg, this.status});

  factory eventClass.fromJson(Map<String, dynamic> json) {
    return eventClass(
        eventId: json['Id'].toString() as String,
        eventName: json['Title'] as String,
        InviteMsg: json['InviteMsg'] as String,
        status: json['Status']);
  }
}

// SQLite Class

class Visitorclass {
  int id;
  String name;
  String mobileNumber;
  String memberId;

  Visitorclass(this.id, this.name, this.mobileNumber, this.memberId);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'memberId': memberId,
    };
    return map;
  }

  Visitorclass.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    mobileNumber = map['mobileNumber'];
    memberId = map['memberId'];
  }
}

class categoryClassData {
  String message;
  bool isSuccess;
  List<categoryClass> data = [];

  categoryClassData({this.message, this.isSuccess, this.data});

  factory categoryClassData.fromJson(Map<String, dynamic> json) {
    return categoryClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<categoryClass>((json) => categoryClass.fromJson(json))
            .toList());
  }
}

class categoryClass {
  String id;
  String ParentId;
  String Title;

  categoryClass({this.id, this.ParentId, this.Title});

  factory categoryClass.fromJson(Map<String, dynamic> json) {
    return categoryClass(
        id: json['Id'].toString() as String,
        ParentId: json['ParentId'].toString() as String,
        Title: json['Title'].toString() as String);
  }
}

class subCategoryClassData {
  String message;
  bool isSuccess;
  List<subCategoryClass> data = [];

  subCategoryClassData({this.message, this.isSuccess, this.data});

  factory subCategoryClassData.fromJson(Map<String, dynamic> json) {
    return subCategoryClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<subCategoryClass>((json) => subCategoryClass.fromJson(json))
            .toList());
  }
}

class subCategoryClass {
  String id;
  String ParentId;
  String Title;

  subCategoryClass({this.id, this.ParentId, this.Title});

  factory subCategoryClass.fromJson(Map<String, dynamic> json) {
    return subCategoryClass(
        id: json['Id'].toString() as String,
        ParentId: json['ParentId'].toString() as String,
        Title: json['Title'].toString() as String);
  }
}
