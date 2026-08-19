/// success : true
/// message : "Check-in successful"
/// data : ""

class MarkAttendanceResponse {
  MarkAttendanceResponse({
      bool? success, 
      String? message, 
      dynamic data,}){
    _success = success;
    _message = message;
    _data = data;
}

  MarkAttendanceResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'];
  }
  bool? _success;
  String? _message;
  dynamic _data;
MarkAttendanceResponse copyWith({  bool? success,
  String? message,
  dynamic data,
}) => MarkAttendanceResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  dynamic get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['data'] = _data;
    return map;
  }

}
