/// success : true
/// message : "Evaluation questions fetched successfully"
/// data : {"total":8,"areas":[{"id":"1","area":"Social & Emotional Development","totalQuestions":6},{"id":"2","area":"Language & Communication","totalQuestions":6},{"id":"3","area":"Cognitive & Problem Solving","totalQuestions":6},{"id":"4","area":"Physical Development (Gross Motor)","totalQuestions":4},{"id":"5","area":"Physical Development (Fine Motor)","totalQuestions":4},{"id":"6","area":"Self-Care & Independence","totalQuestions":5},{"id":"7","area":"Awareness of Environment","totalQuestions":4},{"id":"8","area":"Creativity & Expression","totalQuestions":5}]}

class EvaluationAreaResponse {
  EvaluationAreaResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  EvaluationAreaResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
EvaluationAreaResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => EvaluationAreaResponse(  success: success ?? _success,
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

/// total : 8
/// areas : [{"id":"1","area":"Social & Emotional Development","totalQuestions":6},{"id":"2","area":"Language & Communication","totalQuestions":6},{"id":"3","area":"Cognitive & Problem Solving","totalQuestions":6},{"id":"4","area":"Physical Development (Gross Motor)","totalQuestions":4},{"id":"5","area":"Physical Development (Fine Motor)","totalQuestions":4},{"id":"6","area":"Self-Care & Independence","totalQuestions":5},{"id":"7","area":"Awareness of Environment","totalQuestions":4},{"id":"8","area":"Creativity & Expression","totalQuestions":5}]

class Data {
  Data({
      num? total, 
      List<Areas>? areas,}){
    _total = total;
    _areas = areas;
}

  Data.fromJson(dynamic json) {
    _total = json['total'];
    if (json['areas'] != null) {
      _areas = [];
      json['areas'].forEach((v) {
        _areas?.add(Areas.fromJson(v));
      });
    }
  }
  num? _total;
  List<Areas>? _areas;
Data copyWith({  num? total,
  List<Areas>? areas,
}) => Data(  total: total ?? _total,
  areas: areas ?? _areas,
);
  num? get total => _total;
  List<Areas>? get areas => _areas;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    if (_areas != null) {
      map['areas'] = _areas?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// area : "Social & Emotional Development"
/// totalQuestions : 6

class Areas {
  Areas({
      String? id, 
      String? area, 
      num? totalQuestions,}){
    _id = id;
    _area = area;
    _totalQuestions = totalQuestions;
}

  Areas.fromJson(dynamic json) {
    _id = json['id'];
    _area = json['area'];
    _totalQuestions = json['totalQuestions'];
  }
  String? _id;
  String? _area;
  num? _totalQuestions;
Areas copyWith({  String? id,
  String? area,
  num? totalQuestions,
}) => Areas(  id: id ?? _id,
  area: area ?? _area,
  totalQuestions: totalQuestions ?? _totalQuestions,
);
  String? get id => _id;
  String? get area => _area;
  num? get totalQuestions => _totalQuestions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['area'] = _area;
    map['totalQuestions'] = _totalQuestions;
    return map;
  }

}