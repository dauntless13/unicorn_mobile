/// success : true
/// message : "Password reset successfully"
/// data : ""

class ResetPasswordResponse {
  ResetPasswordResponse({
      bool? success, 
      String? message, 
      String? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  ResetPasswordResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'];
  }
  bool? _success;
  String? _message;
  String? _data;
ResetPasswordResponse copyWith({  bool? success,
  String? message,
  String? data,
}) => ResetPasswordResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['data'] = _data;
    return map;
  }

}