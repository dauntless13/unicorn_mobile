/// success : true
/// message : "Story viewed successfully"
/// data : {"storyId":"69199639-842e-4642-90c8-bdb5596fa683"}

class StoryViewResponse {
  StoryViewResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  StoryViewResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
StoryViewResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => StoryViewResponse(  success: success ?? _success,
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

/// storyId : "69199639-842e-4642-90c8-bdb5596fa683"

class Data {
  Data({
      String? storyId,}){
    _storyId = storyId;
}

  Data.fromJson(dynamic json) {
    _storyId = json['storyId'];
  }
  String? _storyId;
Data copyWith({  String? storyId,
}) => Data(  storyId: storyId ?? _storyId,
);
  String? get storyId => _storyId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['storyId'] = _storyId;
    return map;
  }

}