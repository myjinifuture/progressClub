import 'dart:convert';

IdeaTitleModel ideaTitleModelFromJson(String str) =>
    IdeaTitleModel.fromJson(json.decode(str));

String ideaTitleModelToJson(IdeaTitleModel data) => json.encode(data.toJson());

class IdeaTitleModel {
  IdeaTitleModel({
    this.isSuccess,
    this.count,
    this.message,
    this.data,
  });

  bool isSuccess;
  int count;
  String message;
  List<Datum> data;

  factory IdeaTitleModel.fromJson(Map<String, dynamic> json) => IdeaTitleModel(
        isSuccess: json["IsSuccess"],
        count: json["Count"],
        message: json["Message"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "Count": count,
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.isActive,
    this.id,
    this.title,
    this.v,
  });

  bool isActive;
  String id;
  String title;
  int v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        isActive: json["isActive"],
        id: json["_id"],
        title: json["title"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "_id": id,
        "title": title,
        "__v": v,
      };
}
