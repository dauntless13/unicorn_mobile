// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

PostListResponse applyForTravelTripResponseFromJson(String str) => PostListResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(PostListResponse data) => json.encode(data.toJson());

class PostListResponse {
  bool? success;
  String? message;
  Data? data;

  PostListResponse({
    this.success,
    this.message,
    this.data,
  });

  PostListResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      PostListResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PostListResponse.fromJson(Map<String, dynamic> json) => PostListResponse(
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
  Pagination? pagination;
  List<Post>? posts;

  Data({
    this.pagination,
    this.posts,
  });

  Data copyWith({
    Pagination? pagination,
    List<Post>? posts,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        posts: posts ?? this.posts,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
  };
}

class Pagination {
  int? currentPage;
  int? pageSize;
  int? totalRecords;
  int? totalPages;

  Pagination({
    this.currentPage,
    this.pageSize,
    this.totalRecords,
    this.totalPages,
  });

  Pagination copyWith({
    int? currentPage,
    int? pageSize,
    int? totalRecords,
    int? totalPages,
  }) =>
      Pagination(
        currentPage: currentPage ?? this.currentPage,
        pageSize: pageSize ?? this.pageSize,
        totalRecords: totalRecords ?? this.totalRecords,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["currentPage"],
    pageSize: json["pageSize"],
    totalRecords: json["totalRecords"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "pageSize": pageSize,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}

class Post {
  String? id;
  String? slug;
  String? date;
  List<String>? media;
  Teacher? teacher;
  List<Comment>? comment;
  List<Like>? likes;
  int? totalLikeCount;
  String? description;
  bool? isSave;
  bool? isLike;

  Post({
    this.id,
    this.slug,
    this.date,
    this.media,
    this.teacher,
    this.comment,
    this.likes,
    this.totalLikeCount,
    this.description,
    this.isSave,
    this.isLike,
  });

  Post copyWith({
    String? id,
    String? slug,
    String? date,
    List<String>? media,
    Teacher? teacher,
    List<Comment>? comment,
    List<Like>? likes,
    int? totalLikeCount,
    String? description,
    bool? isSave,
    bool? isLike,
  }) =>
      Post(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        date: date ?? this.date,
        media: media ?? this.media,
        teacher: teacher ?? this.teacher,
        comment: comment ?? this.comment,
        likes: likes ?? this.likes,
        totalLikeCount: totalLikeCount ?? this.totalLikeCount,
        description: description ?? this.description,
        isSave: isSave ?? this.isSave,
        isLike: isLike ?? this.isLike,
      );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    slug: json["slug"],
    date: json["date"],
    media: json["media"] == null ? [] : List<String>.from(json["media"]!.map((x) => x)),
    teacher: json["teacher"] == null ? null : Teacher.fromJson(json["teacher"]),
    comment: json["comment"] == null ? [] : List<Comment>.from(json["comment"]!.map((x) => Comment.fromJson(x))),
    likes: json["likes"] == null ? [] : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
    totalLikeCount: json["totalLikeCount"],
    description: json["description"],
    isSave: json["isSave"],
    isLike: json["isLike"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "date": date,
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
    "teacher": teacher?.toJson(),
    "comment": comment == null ? [] : List<dynamic>.from(comment!.map((x) => x.toJson())),
    "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
    "totalLikeCount": totalLikeCount,
    "description": description,
    "isSave": isSave,
    "isLike": isLike,
  };
}

class Comment {
  String? id;
  String? userId;
  String? photoUrl;
  String? firstName;
  String? lastName;
  String? comment;

  // ── NEW FIELD ──
  List<Comment>? replies;   // ← add this

  Comment({
    this.id,
    this.userId,
    this.photoUrl,
    this.firstName,
    this.lastName,
    this.comment,
    this.replies,           // ← add this
  });

  Comment copyWith({
    String? id,
    String? userId,
    String? photoUrl,
    String? firstName,
    String? lastName,
    String? comment,
    List<Comment>? replies,   // ← add this
  }) =>
      Comment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        photoUrl: photoUrl ?? this.photoUrl,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        comment: comment ?? this.comment,
        replies: replies ?? this.replies,   // ← add this
      );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    userId: json["userId"],
    photoUrl: json["photoUrl"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    comment: json["comment"],
    replies: json["replies"] == null
        ? null
        : List<Comment>.from(
        json["replies"]!.map((x) => Comment.fromJson(x))),   // ← recursive parsing
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "photoUrl": photoUrl,
    "firstName": firstName,
    "lastName": lastName,
    "comment": comment,
    "replies": replies == null
        ? null
        : List<dynamic>.from(replies!.map((x) => x.toJson())),   // ← add this
  };
}

class Like {
  String? firstName;
  String? lastName;
  String? profileUrl;

  Like({
    this.firstName,
    this.lastName,
    this.profileUrl,
  });

  Like copyWith({
    String? firstName,
    String? lastName,
    String? profileUrl,
  }) =>
      Like(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileUrl: profileUrl ?? this.profileUrl,
      );

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileUrl: json["profileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "profileUrl": profileUrl,
  };
}

class Teacher {
  String? profileUrl;
  String? firstName;
  String? lastName;
  String? city;
  String? state;
  String? country;

  Teacher({
    this.profileUrl,
    this.firstName,
    this.lastName,
    this.city,
    this.state,
    this.country,
  });

  Teacher copyWith({
    String? profileUrl,
    String? firstName,
    String? lastName,
    String? city,
    String? state,
    String? country,
  }) =>
      Teacher(
        profileUrl: profileUrl ?? this.profileUrl,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
      );

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    profileUrl: json["profileURL"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "profileURL": profileUrl,
    "firstName": firstName,
    "lastName": lastName,
    "city": city,
    "state": state,
    "country": country,
  };
}
