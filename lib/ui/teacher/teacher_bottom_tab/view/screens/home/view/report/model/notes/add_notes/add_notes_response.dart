/// success : true
/// message : "Note added successfully"
/// data : {"studentName":"Aarav Patel","note":"tomorrow please send the new penil ok"}

class AddNotesResponse {
  AddNotesResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AddNotesResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
AddNotesResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => AddNotesResponse(  success: success ?? _success,
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

/// studentName : "Aarav Patel"
/// note : "tomorrow please send the new penil ok"

class Data {
  Data({
      String? studentName, 
      String? note,}){
    _studentName = studentName;
    _note = note;
}

  Data.fromJson(dynamic json) {
    _studentName = json['studentName'];
    _note = json['note'];
  }
  String? _studentName;
  String? _note;
Data copyWith({  String? studentName,
  String? note,
}) => Data(  studentName: studentName ?? _studentName,
  note: note ?? _note,
);
  String? get studentName => _studentName;
  String? get note => _note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentName'] = _studentName;
    map['note'] = _note;
    return map;
  }

}