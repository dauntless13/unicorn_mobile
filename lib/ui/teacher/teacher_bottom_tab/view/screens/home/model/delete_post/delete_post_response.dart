/// success : true
/// message : "Post deleted successfully"
/// data : {"slug":"post-t1773987161767-45259"}

class DeletePostResponse {
  DeletePostResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  DeletePostResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
DeletePostResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => DeletePostResponse(  success: success ?? _success,
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

/// slug : "post-t1773987161767-45259"

class Data {
  Data({
      String? slug,}){
    _slug = slug;
}

  Data.fromJson(dynamic json) {
    _slug = json['slug'];
  }
  String? _slug;
Data copyWith({  String? slug,
}) => Data(  slug: slug ?? _slug,
);
  String? get slug => _slug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['slug'] = _slug;
    return map;
  }

}