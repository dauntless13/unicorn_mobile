/// success : true
/// message : "activity added successfully"
/// data : {"studentName":"Aarav Patel","studentId":"57e385f0-c052-40a9-b62f-16f5001b9ccb","activity":[{"activityId":"b9208cec-5442-452f-abdd-82c0f926d1eb","studentId":"57e385f0-c052-40a9-b62f-16f5001b9ccb","YOGA":{"date":"2026-02-27","startTime":"02:30 PM","endTime":"03:15 PM","description":" "}}]}

class AddActivityResponse {
  AddActivityResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AddActivityResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
AddActivityResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => AddActivityResponse(  success: success ?? _success,
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
/// activity : [{"activityId":"b9208cec-5442-452f-abdd-82c0f926d1eb","studentId":"57e385f0-c052-40a9-b62f-16f5001b9ccb","YOGA":{"date":"2026-02-27","startTime":"02:30 PM","endTime":"03:15 PM","description":" "}}]

class Data {
  Data({
      String? studentName, 
      String? studentId, 
      List<Activity>? activity,}){
    _studentName = studentName;
    _studentId = studentId;
    _activity = activity;
}

  Data.fromJson(dynamic json) {
    _studentName = json['studentName'];
    _studentId = json['studentId'];
    if (json['activity'] != null) {
      _activity = [];
      json['activity'].forEach((v) {
        _activity?.add(Activity.fromJson(v));
      });
    }
  }
  String? _studentName;
  String? _studentId;
  List<Activity>? _activity;
Data copyWith({  String? studentName,
  String? studentId,
  List<Activity>? activity,
}) => Data(  studentName: studentName ?? _studentName,
  studentId: studentId ?? _studentId,
  activity: activity ?? _activity,
);
  String? get studentName => _studentName;
  String? get studentId => _studentId;
  List<Activity>? get activity => _activity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentName'] = _studentName;
    map['studentId'] = _studentId;
    if (_activity != null) {
      map['activity'] = _activity?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// activityId : "b9208cec-5442-452f-abdd-82c0f926d1eb"
/// studentId : "57e385f0-c052-40a9-b62f-16f5001b9ccb"
/// YOGA : {"date":"2026-02-27","startTime":"02:30 PM","endTime":"03:15 PM","description":" "}

class Activity {
  Activity({
      String? activityId, 
      String? studentId, 
      Yoga? yoga,}){
    _activityId = activityId;
    _studentId = studentId;
    _yoga = yoga;
}

  Activity.fromJson(dynamic json) {
    _activityId = json['activityId'];
    _studentId = json['studentId'];
    _yoga = json['YOGA'] != null ? Yoga.fromJson(json['YOGA']) : null;
  }
  String? _activityId;
  String? _studentId;
  Yoga? _yoga;
Activity copyWith({  String? activityId,
  String? studentId,
  Yoga? yoga,
}) => Activity(  activityId: activityId ?? _activityId,
  studentId: studentId ?? _studentId,
  yoga: yoga ?? _yoga,
);
  String? get activityId => _activityId;
  String? get studentId => _studentId;
  Yoga? get yoga => _yoga;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['activityId'] = _activityId;
    map['studentId'] = _studentId;
    if (_yoga != null) {
      map['YOGA'] = _yoga?.toJson();
    }
    return map;
  }

}

/// date : "2026-02-27"
/// startTime : "02:30 PM"
/// endTime : "03:15 PM"
/// description : " "

class Yoga {
  Yoga({
      String? date, 
      String? startTime, 
      String? endTime, 
      String? description,}){
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _description = description;
}

  Yoga.fromJson(dynamic json) {
    _date = json['date'];
    _startTime = json['startTime'];
    _endTime = json['endTime'];
    _description = json['description'];
  }
  String? _date;
  String? _startTime;
  String? _endTime;
  String? _description;
Yoga copyWith({  String? date,
  String? startTime,
  String? endTime,
  String? description,
}) => Yoga(  date: date ?? _date,
  startTime: startTime ?? _startTime,
  endTime: endTime ?? _endTime,
  description: description ?? _description,
);
  String? get date => _date;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['startTime'] = _startTime;
    map['endTime'] = _endTime;
    map['description'] = _description;
    return map;
  }

}