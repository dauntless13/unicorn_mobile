/// success : true
/// message : "Comment added successfully"
/// data : {"replyId":"6a633c0c-15f3-4243-8c97-0a1e7b2e7247","commentId":"63b42874-24ed-4aaa-b3cf-d8a123714160","parentId":"eab69ab5-0161-4635-8aaf-b286724ac712","replyToId":"","firstName":"natasha","lastName":"Pandya","profileLink":"https://api.unicorn-class.com/uploads/1773309738313-966397463.jpg","comment":"wohooo"}

class ReplyCommentResponse {
  ReplyCommentResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  ReplyCommentResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
ReplyCommentResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => ReplyCommentResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// replyId : "6a633c0c-15f3-4243-8c97-0a1e7b2e7247"
/// commentId : "63b42874-24ed-4aaa-b3cf-d8a123714160"
/// parentId : "eab69ab5-0161-4635-8aaf-b286724ac712"
/// replyToId : ""
/// firstName : "natasha"
/// lastName : "Pandya"
/// profileLink : "https://api.unicorn-class.com/uploads/1773309738313-966397463.jpg"
/// comment : "wohooo"

class Data {
  Data({
      String? replyId, 
      String? commentId, 
      String? parentId, 
      String? replyToId, 
      String? firstName, 
      String? lastName, 
      String? profileLink, 
      String? comment,}){
    _replyId = replyId;
    _commentId = commentId;
    _parentId = parentId;
    _replyToId = replyToId;
    _firstName = firstName;
    _lastName = lastName;
    _profileLink = profileLink;
    _comment = comment;
}

  Data.fromJson(dynamic json) {
    _replyId = json['replyId'];
    _commentId = json['commentId'];
    _parentId = json['parentId'];
    _replyToId = json['replyToId'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _profileLink = json['profileLink'];
    _comment = json['comment'];
  }
  String? _replyId;
  String? _commentId;
  String? _parentId;
  String? _replyToId;
  String? _firstName;
  String? _lastName;
  String? _profileLink;
  String? _comment;
Data copyWith({  String? replyId,
  String? commentId,
  String? parentId,
  String? replyToId,
  String? firstName,
  String? lastName,
  String? profileLink,
  String? comment,
}) => Data(  replyId: replyId ?? _replyId,
  commentId: commentId ?? _commentId,
  parentId: parentId ?? _parentId,
  replyToId: replyToId ?? _replyToId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  profileLink: profileLink ?? _profileLink,
  comment: comment ?? _comment,
);
  String? get replyId => _replyId;
  String? get commentId => _commentId;
  String? get parentId => _parentId;
  String? get replyToId => _replyToId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get profileLink => _profileLink;
  String? get comment => _comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['replyId'] = _replyId;
    map['commentId'] = _commentId;
    map['parentId'] = _parentId;
    map['replyToId'] = _replyToId;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['profileLink'] = _profileLink;
    map['comment'] = _comment;
    return map;
  }

}