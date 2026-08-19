// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

CreateChatResponse applyForTravelTripResponseFromJson(String str) => CreateChatResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(CreateChatResponse data) => json.encode(data.toJson());

class CreateChatResponse {
  bool? success;
  String? message;
  Data? data;

  CreateChatResponse({
    this.success,
    this.message,
    this.data,
  });

  CreateChatResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      CreateChatResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CreateChatResponse.fromJson(Map<String, dynamic> json) => CreateChatResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? chatId;
  String? id;
  String? parentId;
  String? slug;
  bool? isGroup;
  String? nurseryId;

  Data({
    this.chatId,
    this.id,
    this.parentId,
    this.slug,
    this.isGroup,
    this.nurseryId,
  });

  Data copyWith({
    String? chatId,
    String? id,
    String? parentId,
    String? slug,
    bool? isGroup,
    String? nurseryId,
  }) =>
      Data(
        chatId: chatId ?? this.chatId,
        id: id ?? this.id,
        parentId: parentId ?? this.parentId,
        slug: slug ?? this.slug,
        isGroup: isGroup ?? this.isGroup,
        nurseryId: nurseryId ?? this.nurseryId,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chatId: json["chatId"],
    id: json["id"],
    parentId: json["parentId"],
    slug: json["slug"],
    isGroup: json["isGroup"],
    nurseryId: json["nurseryId"],
  );

  Map<String, dynamic> toJson() => {
    "chatId": chatId,
    "id": id,
    "parentId": parentId,
    "slug": slug,
    "isGroup": isGroup,
    "nurseryId": nurseryId,
  };
}
