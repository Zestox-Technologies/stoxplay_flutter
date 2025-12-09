// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  List<Datum>? data;
  Meta? meta;

  NotificationModel({this.data, this.meta});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datum {
  String? id;
  String? userId;
  String? title;
  String? body;
  Data? data;
  bool? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({this.id, this.userId, this.title, this.body, this.data, this.isRead, this.createdAt, this.updatedAt});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["userId"],
    title: json["title"]!,
    body: json["body"]!,
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    isRead: json["isRead"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "title": title,
    "body": body,
    "data": data?.toJson(),
    "isRead": isRead,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Data {
  String? type;
  String? requestId;

  Data({this.type, this.requestId});

  factory Data.fromJson(Map<String, dynamic> json) => Data(type: json["type"], requestId: json["requestId"]);

  Map<String, dynamic> toJson() => {"type": type, "requestId": requestId};
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) =>
      Meta(page: json["page"], limit: json["limit"], total: json["total"], totalPages: json["totalPages"]);

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "total": total, "totalPages": totalPages};
}
