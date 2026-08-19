/// success : true
/// message : "story liked successfully"
/// data : {"storyId":"276053a3-b66b-42e5-aa9c-d3f79bd5e93f","isLike":true,"totalLikes":1}

class StoryLikeResponse {
  StoryLikeResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  StoryLikeResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
StoryLikeResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => StoryLikeResponse(  success: success ?? _success,
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

/// storyId : "276053a3-b66b-42e5-aa9c-d3f79bd5e93f"
/// isLike : true
/// totalLikes : 1

class Data {
  Data({
      String? storyId, 
      bool? isLike, 
      num? totalLikes,}){
    _storyId = storyId;
    _isLike = isLike;
    _totalLikes = totalLikes;
}

  Data.fromJson(dynamic json) {
    _storyId = json['storyId'];
    _isLike = json['isLike'];
    _totalLikes = json['totalLikes'];
  }
  String? _storyId;
  bool? _isLike;
  num? _totalLikes;
Data copyWith({  String? storyId,
  bool? isLike,
  num? totalLikes,
}) => Data(  storyId: storyId ?? _storyId,
  isLike: isLike ?? _isLike,
  totalLikes: totalLikes ?? _totalLikes,
);
  String? get storyId => _storyId;
  bool? get isLike => _isLike;
  num? get totalLikes => _totalLikes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['storyId'] = _storyId;
    map['isLike'] = _isLike;
    map['totalLikes'] = _totalLikes;
    return map;
  }

}