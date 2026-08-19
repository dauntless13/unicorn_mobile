/// success : true
/// message : "Meal added successfully"
/// data : {"studentName":"Aarav Patel","meals":[{"mealName":"PANEER","date":"2026-02-16","time":"01:30 PM"}]}

class AddMealSnackResponse {
  AddMealSnackResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AddMealSnackResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
AddMealSnackResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => AddMealSnackResponse(  success: success ?? _success,
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
/// meals : [{"mealName":"PANEER","date":"2026-02-16","time":"01:30 PM"}]

class Data {
  Data({
      String? studentName, 
      List<Meals>? meals,}){
    _studentName = studentName;
    _meals = meals;
}

  Data.fromJson(dynamic json) {
    _studentName = json['studentName'];
    if (json['meals'] != null) {
      _meals = [];
      json['meals'].forEach((v) {
        _meals?.add(Meals.fromJson(v));
      });
    }
  }
  String? _studentName;
  List<Meals>? _meals;
Data copyWith({  String? studentName,
  List<Meals>? meals,
}) => Data(  studentName: studentName ?? _studentName,
  meals: meals ?? _meals,
);
  String? get studentName => _studentName;
  List<Meals>? get meals => _meals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentName'] = _studentName;
    if (_meals != null) {
      map['meals'] = _meals?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// mealName : "PANEER"
/// date : "2026-02-16"
/// time : "01:30 PM"

class Meals {
  Meals({
      String? mealName, 
      String? date, 
      String? time,}){
    _mealName = mealName;
    _date = date;
    _time = time;
}

  Meals.fromJson(dynamic json) {
    _mealName = json['mealName'];
    _date = json['date'];
    _time = json['time'];
  }
  String? _mealName;
  String? _date;
  String? _time;
Meals copyWith({  String? mealName,
  String? date,
  String? time,
}) => Meals(  mealName: mealName ?? _mealName,
  date: date ?? _date,
  time: time ?? _time,
);
  String? get mealName => _mealName;
  String? get date => _date;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mealName'] = _mealName;
    map['date'] = _date;
    map['time'] = _time;
    return map;
  }

}