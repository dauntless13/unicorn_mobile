/// success : true
/// message : "Story deleted successfully"
/// data : {"id":"8e084bc1-0157-479c-a470-fbc199a39d7b"}

class DeleteStoryResponse {
  DeleteStoryResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  DeleteStoryResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
DeleteStoryResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => DeleteStoryResponse(  success: success ?? _success,
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

/// id : "8e084bc1-0157-479c-a470-fbc199a39d7b"

class Data {
  Data({
      String? id,}){
    _id = id;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
  }
  String? _id;
Data copyWith({  String? id,
}) => Data(  id: id ?? _id,
);
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }

}