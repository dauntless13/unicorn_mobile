import 'dart:convert';

StoryListingResponse storyListingResponseFromJson(String str) =>
    StoryListingResponse.fromJson(json.decode(str));

String storyListingResponseToJson(StoryListingResponse data) =>
    json.encode(data.toJson());

class StoryListingResponse {
  bool? success;
  String? message;
  StoryData? data;

  StoryListingResponse({
    this.success,
    this.message,
    this.data,
  });

  factory StoryListingResponse.fromJson(Map<String, dynamic> json) =>
      StoryListingResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StoryData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class StoryData {
  List<StoryUser>? users;

  StoryData({this.users});

  factory StoryData.fromJson(Map<String, dynamic> json) => StoryData(
    users: json["users"] == null
        ? []
        : List<StoryUser>.from(
        json["users"].map((x) => StoryUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": users == null
        ? []
        : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class StoryUser {
  String? teacherId;
  String? teacherName;
  String? teacherProfileLink;
  List<StoryList>? stories;

  StoryUser({
    this.teacherId,
    this.teacherName,
    this.teacherProfileLink,
    this.stories,
  });

  factory StoryUser.fromJson(Map<String, dynamic> json) => StoryUser(
    teacherId: json["teacherId"],
    teacherName: json["teacherName"],
    teacherProfileLink: json["teacherProfileLink"],
    stories: json["stories"] == null
        ? []
        : List<StoryList>.from(
        json["stories"].map((x) => StoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "teacherId": teacherId,
    "teacherName": teacherName,
    "teacherProfileLink": teacherProfileLink,
    "stories": stories == null
        ? []
        : List<dynamic>.from(stories!.map((x) => x.toJson())),
  };
}

class StoryList {
  String? id;
  String? mediaUrl;
  String? mediaType;
  String? text;
  String? ctaText;
  DateTime? expiresAt;
  bool? storyViewed;
  bool? isLiked; // ✅ ADD THIS

  StoryList({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.text,
    this.ctaText,
    this.expiresAt,
    this.storyViewed,
    this.isLiked, // ✅ ADD
  });

  factory StoryList.fromJson(Map<String, dynamic> json) => StoryList(
    id: json["id"],
    mediaUrl: json["mediaUrl"],
    mediaType: json["mediaType"],
    text: json["text"],
    ctaText: json["ctaText"],
    storyViewed: json["storyViewed"],
    isLiked: json["isLiked"], // ✅ ADD THIS LINE
    expiresAt: json["expiresAt"] == null
        ? null
        : DateTime.parse(json["expiresAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mediaUrl": mediaUrl,
    "mediaType": mediaType,
    "text": text,
    "ctaText": ctaText,
    "storyViewed": storyViewed,
    "isLiked": isLiked, // ✅ ADD THIS
    "expiresAt": expiresAt?.toIso8601String(),
  };
}