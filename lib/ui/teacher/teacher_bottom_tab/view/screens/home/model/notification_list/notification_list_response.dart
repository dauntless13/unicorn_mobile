class NotificationListResponse {
  bool? success;
  String? message;
  NotificationData? data;

  NotificationListResponse({this.success, this.message, this.data});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? NotificationData.fromJson(json['data'])
        : null;
  }
}

class NotificationData {
  Pagination? pagination;
  List<NotificationUserData>? list;

  NotificationData({this.pagination, this.list});

  NotificationData.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    if (json['data'] != null) {
      list = <NotificationUserData>[];
      json['data'].forEach((v) {
        list!.add(NotificationUserData.fromJson(v));
      });
    }
  }
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

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalRecords': totalRecords,
      'totalPages': totalPages,
    };
  }
}

class NotificationUserData {
  String? id;
  String? type;
  String? typeSlug;
  String? title;
  String? message;
  String? name;
  String? email;
  String? date;
  String? time;
  String? studentSlug;
  String? studentId;
  String? postId;
  bool isRead = false;
  Map<String, dynamic>? info;

  NotificationUserData({
    this.id,
    this.type,
    this.typeSlug,
    this.title,
    this.message,
    this.name,
    this.email,
    this.date,
    this.time,
    this.studentSlug,
    this.studentId,
    this.postId,
    this.isRead = false,
    this.info,
  });

  String get navigationId {
    if (studentSlug != null && studentSlug!.isNotEmpty) return studentSlug!;
    if (postId != null && postId!.isNotEmpty) return postId!;
    if (studentId != null && studentId!.isNotEmpty) return studentId!;
    final infoSlug = info?['studentSlug']?.toString() ??
        info?['chatId']?.toString() ??
        info?['postId']?.toString() ??
        '';
    return infoSlug;
  }

  NotificationUserData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    type = json['type']?.toString();
    typeSlug = json['typeSlug']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
    date = json['date']?.toString();
    time = json['time']?.toString();
    studentSlug = json['studentSlug']?.toString();
    studentId = json['studentId']?.toString();
    postId = json['postId']?.toString();
    isRead = json['isRead'] == true;
    if (json['info'] is Map) {
      info = Map<String, dynamic>.from(json['info'] as Map);
      studentSlug ??= info?['studentSlug']?.toString();
      studentId ??= info?['studentId']?.toString();
      postId ??= info?['postId']?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'typeSlug': typeSlug,
      'title': title,
      'message': message,
      'name': name,
      'email': email,
      'date': date,
      'time': time,
      'studentSlug': studentSlug,
      'studentId': studentId,
      'postId': postId,
      'isRead': isRead,
      'info': info,
    };
  }
}
