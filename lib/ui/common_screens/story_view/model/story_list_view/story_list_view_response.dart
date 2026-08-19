/// success : true
/// message : "Story views fetched successfully"
/// data : {"views":[{"firstName":"natasha","lastName":"Pandya","photoUrl":"https://api.unicorn-class.com/uploads/1773309738313-966397463.jpg"}],"count":1}

class StoryListViewResponse {
  StoryListViewResponse({
      bool? success,
      String? message,
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  StoryListViewResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
StoryListViewResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => StoryListViewResponse(  success: success ?? _success,
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

/// views : [{"firstName":"natasha","lastName":"Pandya","photoUrl":"https://api.unicorn-class.com/uploads/1773309738313-966397463.jpg"}]
/// count : 1

class Data {
  Data({
      List<Views>? views,
      num? count,}){
    _views = views;
    _count = count;
}

  Data.fromJson(dynamic json) {
    if (json['views'] != null) {
      _views = [];
      json['views'].forEach((v) {
        _views?.add(Views.fromJson(v));
      });
    }
    _count = json['count'];
  }
  List<Views>? _views;
  num? _count;
Data copyWith({  List<Views>? views,
  num? count,
}) => Data(  views: views ?? _views,
  count: count ?? _count,
);
  List<Views>? get views => _views;
  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_views != null) {
      map['views'] = _views?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    return map;
  }

}

/// firstName : "natasha"
/// lastName : "Pandya"
/// photoUrl : "https://api.unicorn-class.com/uploads/1773309738313-966397463.jpg"
class Views {
  Views({
    String? firstName,
    String? lastName,
    String? photoUrl,
    bool? storyLiked,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _photoUrl = photoUrl;
    _storyLiked = storyLiked;
  }

  Views.fromJson(dynamic json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _photoUrl = json['photoUrl'];
    _storyLiked = json['storyLiked']; // ✅ NEW FIELD
  }

  String? _firstName;
  String? _lastName;
  String? _photoUrl;
  bool? _storyLiked; // ✅ NEW FIELD

  Views copyWith({
    String? firstName,
    String? lastName,
    String? photoUrl,
    bool? storyLiked,
  }) =>
      Views(
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        photoUrl: photoUrl ?? _photoUrl,
        storyLiked: storyLiked ?? _storyLiked,
      );

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get photoUrl => _photoUrl;
  bool? get storyLiked => _storyLiked; // ✅ GETTER

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['photoUrl'] = _photoUrl;
    map['storyLiked'] = _storyLiked; // ✅ INCLUDE IN JSON
    return map;
  }

}