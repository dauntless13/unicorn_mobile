/// success : true
/// message : "Mood updated successfully"
/// data : {"name":"Pinal Patel","mood":["HAPPY"]}

class MoodUpdateResponse {
  MoodUpdateResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  MoodUpdateResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
MoodUpdateResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => MoodUpdateResponse(  success: success ?? _success,
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

/// name : "Pinal Patel"
/// mood : ["HAPPY"]

class Data {
  Data({
      String? name, 
      List<String>? mood,}){
    _name = name;
    _mood = mood;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _mood = json['mood'] != null ? json['mood'].cast<String>() : [];
  }
  String? _name;
  List<String>? _mood;
Data copyWith({  String? name,
  List<String>? mood,
}) => Data(  name: name ?? _name,
  mood: mood ?? _mood,
);
  String? get name => _name;
  List<String>? get mood => _mood;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['mood'] = _mood;
    return map;
  }

}