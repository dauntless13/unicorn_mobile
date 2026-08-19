/// success : true
/// message : "Evaluation saved successfully"
/// data : {"id":"cbec06ff-3928-433c-99a5-6d9c0351d54b","studentSlug":"student-neha-mehta-AD0000051","studentName":"Neha  Mehta","className":"NurseryB IV","evaluationDate":"2026-04-01","reportingFromDate":"2026-03-01","reportingToDate":"2026-03-31","status":"SUBMITTED","teacherNote":"Doing very well in class routines","answers":[{"questionId":"e715b3e1-b6d3-4970-b731-a0428ff22d0c","questionTitle":"Forms secure relationships with caregivers","area":"Social & Emotional Development","rating":"A","ratingCode":"A"},{"questionId":"19d76c4d-6b2b-49ae-aaff-8dec96496a77","questionTitle":"Interacts positively with peers","area":"Social & Emotional Development","rating":"A","ratingCode":"A"}]}

class SaveEvaluationResponse {
  SaveEvaluationResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  SaveEvaluationResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
SaveEvaluationResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => SaveEvaluationResponse(  success: success ?? _success,
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

/// id : "cbec06ff-3928-433c-99a5-6d9c0351d54b"
/// studentSlug : "student-neha-mehta-AD0000051"
/// studentName : "Neha  Mehta"
/// className : "NurseryB IV"
/// evaluationDate : "2026-04-01"
/// reportingFromDate : "2026-03-01"
/// reportingToDate : "2026-03-31"
/// status : "SUBMITTED"
/// teacherNote : "Doing very well in class routines"
/// answers : [{"questionId":"e715b3e1-b6d3-4970-b731-a0428ff22d0c","questionTitle":"Forms secure relationships with caregivers","area":"Social & Emotional Development","rating":"A","ratingCode":"A"},{"questionId":"19d76c4d-6b2b-49ae-aaff-8dec96496a77","questionTitle":"Interacts positively with peers","area":"Social & Emotional Development","rating":"A","ratingCode":"A"}]

class Data {
  Data({
      String? id, 
      String? studentSlug, 
      String? studentName, 
      String? className, 
      String? evaluationDate, 
      String? reportingFromDate, 
      String? reportingToDate, 
      String? status, 
      String? teacherNote, 
      List<Answers>? answers,}){
    _id = id;
    _studentSlug = studentSlug;
    _studentName = studentName;
    _className = className;
    _evaluationDate = evaluationDate;
    _reportingFromDate = reportingFromDate;
    _reportingToDate = reportingToDate;
    _status = status;
    _teacherNote = teacherNote;
    _answers = answers;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _studentSlug = json['studentSlug'];
    _studentName = json['studentName'];
    _className = json['className'];
    _evaluationDate = json['evaluationDate'];
    _reportingFromDate = json['reportingFromDate'];
    _reportingToDate = json['reportingToDate'];
    _status = json['status'];
    _teacherNote = json['teacherNote'];
    if (json['answers'] != null) {
      _answers = [];
      json['answers'].forEach((v) {
        _answers?.add(Answers.fromJson(v));
      });
    }
  }
  String? _id;
  String? _studentSlug;
  String? _studentName;
  String? _className;
  String? _evaluationDate;
  String? _reportingFromDate;
  String? _reportingToDate;
  String? _status;
  String? _teacherNote;
  List<Answers>? _answers;
Data copyWith({  String? id,
  String? studentSlug,
  String? studentName,
  String? className,
  String? evaluationDate,
  String? reportingFromDate,
  String? reportingToDate,
  String? status,
  String? teacherNote,
  List<Answers>? answers,
}) => Data(  id: id ?? _id,
  studentSlug: studentSlug ?? _studentSlug,
  studentName: studentName ?? _studentName,
  className: className ?? _className,
  evaluationDate: evaluationDate ?? _evaluationDate,
  reportingFromDate: reportingFromDate ?? _reportingFromDate,
  reportingToDate: reportingToDate ?? _reportingToDate,
  status: status ?? _status,
  teacherNote: teacherNote ?? _teacherNote,
  answers: answers ?? _answers,
);
  String? get id => _id;
  String? get studentSlug => _studentSlug;
  String? get studentName => _studentName;
  String? get className => _className;
  String? get evaluationDate => _evaluationDate;
  String? get reportingFromDate => _reportingFromDate;
  String? get reportingToDate => _reportingToDate;
  String? get status => _status;
  String? get teacherNote => _teacherNote;
  List<Answers>? get answers => _answers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['studentSlug'] = _studentSlug;
    map['studentName'] = _studentName;
    map['className'] = _className;
    map['evaluationDate'] = _evaluationDate;
    map['reportingFromDate'] = _reportingFromDate;
    map['reportingToDate'] = _reportingToDate;
    map['status'] = _status;
    map['teacherNote'] = _teacherNote;
    if (_answers != null) {
      map['answers'] = _answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// questionId : "e715b3e1-b6d3-4970-b731-a0428ff22d0c"
/// questionTitle : "Forms secure relationships with caregivers"
/// area : "Social & Emotional Development"
/// rating : "A"
/// ratingCode : "A"

class Answers {
  Answers({
      String? questionId, 
      String? questionTitle, 
      String? area, 
      String? rating, 
      String? ratingCode,}){
    _questionId = questionId;
    _questionTitle = questionTitle;
    _area = area;
    _rating = rating;
    _ratingCode = ratingCode;
}

  Answers.fromJson(dynamic json) {
    _questionId = json['questionId'];
    _questionTitle = json['questionTitle'];
    _area = json['area'];
    _rating = json['rating'];
    _ratingCode = json['ratingCode'];
  }
  String? _questionId;
  String? _questionTitle;
  String? _area;
  String? _rating;
  String? _ratingCode;
Answers copyWith({  String? questionId,
  String? questionTitle,
  String? area,
  String? rating,
  String? ratingCode,
}) => Answers(  questionId: questionId ?? _questionId,
  questionTitle: questionTitle ?? _questionTitle,
  area: area ?? _area,
  rating: rating ?? _rating,
  ratingCode: ratingCode ?? _ratingCode,
);
  String? get questionId => _questionId;
  String? get questionTitle => _questionTitle;
  String? get area => _area;
  String? get rating => _rating;
  String? get ratingCode => _ratingCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['questionId'] = _questionId;
    map['questionTitle'] = _questionTitle;
    map['area'] = _area;
    map['rating'] = _rating;
    map['ratingCode'] = _ratingCode;
    return map;
  }

}