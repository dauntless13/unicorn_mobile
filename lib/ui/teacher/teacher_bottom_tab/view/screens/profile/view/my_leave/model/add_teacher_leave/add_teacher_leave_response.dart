/// success : true
/// message : "Leave applied successfully"
/// data : {"id":"f1f05d69-222c-4b84-9bb0-4dade2d74c4e","teacherId":"63d1e5d1-5388-4e47-b05c-56662ac021e6","leaveType":"SICK","startDate":"16-02-2026","endDate":"18-02-2026","totalDays":3,"status":"PENDING","appliedAt":"27-02-2026"}

class AddTeacherLeaveResponse {
  AddTeacherLeaveResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AddTeacherLeaveResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
AddTeacherLeaveResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => AddTeacherLeaveResponse(  success: success ?? _success,
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

/// id : "f1f05d69-222c-4b84-9bb0-4dade2d74c4e"
/// teacherId : "63d1e5d1-5388-4e47-b05c-56662ac021e6"
/// leaveType : "SICK"
/// startDate : "16-02-2026"
/// endDate : "18-02-2026"
/// totalDays : 3
/// status : "PENDING"
/// appliedAt : "27-02-2026"

class Data {
  Data({
      String? id, 
      String? teacherId, 
      String? leaveType, 
      String? startDate, 
      String? endDate, 
      num? totalDays, 
      String? status, 
      String? appliedAt,}){
    _id = id;
    _teacherId = teacherId;
    _leaveType = leaveType;
    _startDate = startDate;
    _endDate = endDate;
    _totalDays = totalDays;
    _status = status;
    _appliedAt = appliedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _teacherId = json['teacherId'];
    _leaveType = json['leaveType'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
    _totalDays = json['totalDays'];
    _status = json['status'];
    _appliedAt = json['appliedAt'];
  }
  String? _id;
  String? _teacherId;
  String? _leaveType;
  String? _startDate;
  String? _endDate;
  num? _totalDays;
  String? _status;
  String? _appliedAt;
Data copyWith({  String? id,
  String? teacherId,
  String? leaveType,
  String? startDate,
  String? endDate,
  num? totalDays,
  String? status,
  String? appliedAt,
}) => Data(  id: id ?? _id,
  teacherId: teacherId ?? _teacherId,
  leaveType: leaveType ?? _leaveType,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  totalDays: totalDays ?? _totalDays,
  status: status ?? _status,
  appliedAt: appliedAt ?? _appliedAt,
);
  String? get id => _id;
  String? get teacherId => _teacherId;
  String? get leaveType => _leaveType;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  num? get totalDays => _totalDays;
  String? get status => _status;
  String? get appliedAt => _appliedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['teacherId'] = _teacherId;
    map['leaveType'] = _leaveType;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['totalDays'] = _totalDays;
    map['status'] = _status;
    map['appliedAt'] = _appliedAt;
    return map;
  }

}