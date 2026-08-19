/// success : true
/// message : "Hygiene added successfully"
/// data : {"studentName":"Aarav Patel","studentId":"57e385f0-c052-40a9-b62f-16f5001b9ccb","hygiene":[{"hygieneId":"f03cf4e4-de87-4e72-9d1c-85e242599aeb","studentId":"57e385f0-c052-40a9-b62f-16f5001b9ccb","BATHROOM":{"date":"2026-02-27","time":"02:30 PM","description":"Student took a bath"}}]}

class AddHygieneResponse {
  AddHygieneResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AddHygieneResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
AddHygieneResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => AddHygieneResponse(  success: success ?? _success,
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
/// studentId : "57e385f0-c052-40a9-b62f-16f5001b9ccb"
/// hygiene : [{"hygieneId":"f03cf4e4-de87-4e72-9d1c-85e242599aeb","studentId":"57e385f0-c052-40a9-b62f-16f5001b9ccb","BATHROOM":{"date":"2026-02-27","time":"02:30 PM","description":"Student took a bath"}}]

class Data {
  Data({
      String? studentName, 
      String? studentId, 
      List<Hygiene>? hygiene,}){
    _studentName = studentName;
    _studentId = studentId;
    _hygiene = hygiene;
}

  Data.fromJson(dynamic json) {
    _studentName = json['studentName'];
    _studentId = json['studentId'];
    if (json['hygiene'] != null) {
      _hygiene = [];
      json['hygiene'].forEach((v) {
        _hygiene?.add(Hygiene.fromJson(v));
      });
    }
  }
  String? _studentName;
  String? _studentId;
  List<Hygiene>? _hygiene;
Data copyWith({  String? studentName,
  String? studentId,
  List<Hygiene>? hygiene,
}) => Data(  studentName: studentName ?? _studentName,
  studentId: studentId ?? _studentId,
  hygiene: hygiene ?? _hygiene,
);
  String? get studentName => _studentName;
  String? get studentId => _studentId;
  List<Hygiene>? get hygiene => _hygiene;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentName'] = _studentName;
    map['studentId'] = _studentId;
    if (_hygiene != null) {
      map['hygiene'] = _hygiene?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// hygieneId : "f03cf4e4-de87-4e72-9d1c-85e242599aeb"
/// studentId : "57e385f0-c052-40a9-b62f-16f5001b9ccb"
/// BATHROOM : {"date":"2026-02-27","time":"02:30 PM","description":"Student took a bath"}

class Hygiene {
  Hygiene({
      String? hygieneId, 
      String? studentId, 
      Bathroom? bathroom,}){
    _hygieneId = hygieneId;
    _studentId = studentId;
    _bathroom = bathroom;
}

  Hygiene.fromJson(dynamic json) {
    _hygieneId = json['hygieneId'];
    _studentId = json['studentId'];
    _bathroom = json['BATHROOM'] != null ? Bathroom.fromJson(json['BATHROOM']) : null;
  }
  String? _hygieneId;
  String? _studentId;
  Bathroom? _bathroom;
Hygiene copyWith({  String? hygieneId,
  String? studentId,
  Bathroom? bathroom,
}) => Hygiene(  hygieneId: hygieneId ?? _hygieneId,
  studentId: studentId ?? _studentId,
  bathroom: bathroom ?? _bathroom,
);
  String? get hygieneId => _hygieneId;
  String? get studentId => _studentId;
  Bathroom? get bathroom => _bathroom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hygieneId'] = _hygieneId;
    map['studentId'] = _studentId;
    if (_bathroom != null) {
      map['BATHROOM'] = _bathroom?.toJson();
    }
    return map;
  }

}

/// date : "2026-02-27"
/// time : "02:30 PM"
/// description : "Student took a bath"

class Bathroom {
  Bathroom({
      String? date, 
      String? time, 
      String? description,}){
    _date = date;
    _time = time;
    _description = description;
}

  Bathroom.fromJson(dynamic json) {
    _date = json['date'];
    _time = json['time'];
    _description = json['description'];
  }
  String? _date;
  String? _time;
  String? _description;
Bathroom copyWith({  String? date,
  String? time,
  String? description,
}) => Bathroom(  date: date ?? _date,
  time: time ?? _time,
  description: description ?? _description,
);
  String? get date => _date;
  String? get time => _time;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['time'] = _time;
    map['description'] = _description;
    return map;
  }

}