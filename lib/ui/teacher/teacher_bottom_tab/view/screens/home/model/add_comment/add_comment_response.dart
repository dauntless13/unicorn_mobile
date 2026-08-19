// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

AddCommentResponse applyForTravelTripResponseFromJson(String str) => AddCommentResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(AddCommentResponse data) => json.encode(data.toJson());

class AddCommentResponse {
  bool? success;
  String? message;
  CommentData? data;

  AddCommentResponse({
    this.success,
    this.message,
    this.data,
  });

  AddCommentResponse copyWith({
    bool? success,
    String? message,
    CommentData? data,
  }) =>
      AddCommentResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) => AddCommentResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : CommentData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class CommentData {
  String? parentId;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? comment;

  CommentData({
    this.parentId,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.comment,
  });

  CommentData copyWith({
    String? parentId,
    String? firstName,
    String? lastName,
    String? profileLink,
    String? comment,
  }) =>
      CommentData(
        parentId: parentId ?? this.parentId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        comment: comment ?? this.comment,
      );

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
    parentId: json["parentId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "parentId": parentId,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
    "comment": comment,
  };
}
