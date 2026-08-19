/// success : true
/// message : "OTP generated successfully"
/// data : {"otp":"909652","message":"OTP sent to email"}

class ForgotPasswordResponse {
  ForgotPasswordResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  ForgotPasswordResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
ForgotPasswordResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => ForgotPasswordResponse(  success: success ?? _success,
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

/// otp : "909652"
/// message : "OTP sent to email"

class Data {
  Data({
      String? otp, 
      String? message,}){
    _otp = otp;
    _message = message;
}

  Data.fromJson(dynamic json) {
    _otp = json['otp'];
    _message = json['message'];
  }
  String? _otp;
  String? _message;
Data copyWith({  String? otp,
  String? message,
}) => Data(  otp: otp ?? _otp,
  message: message ?? _message,
);
  String? get otp => _otp;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = _otp;
    map['message'] = _message;
    return map;
  }

}