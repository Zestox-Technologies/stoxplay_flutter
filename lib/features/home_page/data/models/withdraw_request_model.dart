// To parse this JSON data, do
//
//     final withdrawRequestModel = withdrawRequestModelFromJson(jsonString);

import 'dart:convert';

WithdrawRequestModel withdrawRequestModelFromJson(String str) => WithdrawRequestModel.fromJson(json.decode(str));

String withdrawRequestModelToJson(WithdrawRequestModel data) => json.encode(data.toJson());

class WithdrawRequestModel {
  String? id;
  String? requesterId;
  String? targetUserId;
  int? amount;
  String? reason;
  String? status;
  dynamic processedAt;
  dynamic remarks;
  DateTime? createdAt;
  DateTime? updatedAt;
  Requester? requester;
  Requester? targetUser;

  WithdrawRequestModel({
    this.id,
    this.requesterId,
    this.targetUserId,
    this.amount,
    this.reason,
    this.status,
    this.processedAt,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.requester,
    this.targetUser,
  });

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) => WithdrawRequestModel(
    id: json["id"],
    requesterId: json["requesterId"],
    targetUserId: json["targetUserId"],
    amount: json["amount"],
    reason: json["reason"],
    status: json["status"],
    processedAt: json["processedAt"],
    remarks: json["remarks"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    requester: json["requester"] == null ? null : Requester.fromJson(json["requester"]),
    targetUser: json["targetUser"] == null ? null : Requester.fromJson(json["targetUser"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "requesterId": requesterId,
    "targetUserId": targetUserId,
    "amount": amount,
    "reason": reason,
    "status": status,
    "processedAt": processedAt,
    "remarks": remarks,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "requester": requester?.toJson(),
    "targetUser": targetUser?.toJson(),
  };
}

class Requester {
  String? id;
  String? username;

  Requester({
    this.id,
    this.username,
  });

  factory Requester.fromJson(Map<String, dynamic> json) => Requester(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}
