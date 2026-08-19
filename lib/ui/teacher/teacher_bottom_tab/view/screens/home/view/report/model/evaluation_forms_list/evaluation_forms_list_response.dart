/// success : true
/// message : "Evaluations fetched successfully"
/// data : {"total":1,"page":1,"limit":10,"evaluations":[{"id":"7a165402-0c93-4e8a-bc01-4d8379c77f17","studentSlug":"student-neha-mehta-AD0000051","studentName":"Neha  Mehta","studentCode":"AD0000051","rollNumber":"0051","profileLink":"https://api.unicorn-class.com/uploads/1773989112717-974908832.jpg","classSlug":"class-nurseryb-iv-C00025","className":"NurseryB IV","teacherName":"Pooja Patel","evaluationDate":"2026-04-06","status":"SUBMITTED","teacherNote":"Good progress","adminNote":"","submittedAt":"2026-04-06T05:00:18.150Z","approvedAt":"","answerCount":40,"reportPdfLink":"https://api.unicorn-class.com/uploads/evaluation-pdfs/7a165402-0c93-4e8a-bc01-4d8379c77f17-en.pdf"}]}

class EvaluationFormsListResponse {
  EvaluationFormsListResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  EvaluationFormsListResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
EvaluationFormsListResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => EvaluationFormsListResponse(  success: success ?? _success,
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

/// total : 1
/// page : 1
/// limit : 10
/// evaluations : [{"id":"7a165402-0c93-4e8a-bc01-4d8379c77f17","studentSlug":"student-neha-mehta-AD0000051","studentName":"Neha  Mehta","studentCode":"AD0000051","rollNumber":"0051","profileLink":"https://api.unicorn-class.com/uploads/1773989112717-974908832.jpg","classSlug":"class-nurseryb-iv-C00025","className":"NurseryB IV","teacherName":"Pooja Patel","evaluationDate":"2026-04-06","status":"SUBMITTED","teacherNote":"Good progress","adminNote":"","submittedAt":"2026-04-06T05:00:18.150Z","approvedAt":"","answerCount":40,"reportPdfLink":"https://api.unicorn-class.com/uploads/evaluation-pdfs/7a165402-0c93-4e8a-bc01-4d8379c77f17-en.pdf"}]

class Data {
  Data({
      num? total, 
      num? page, 
      num? limit, 
      List<Evaluations>? evaluations,}){
    _total = total;
    _page = page;
    _limit = limit;
    _evaluations = evaluations;
}

  Data.fromJson(dynamic json) {
    _total = json['total'];
    _page = json['page'];
    _limit = json['limit'];
    if (json['evaluations'] != null) {
      _evaluations = [];
      json['evaluations'].forEach((v) {
        _evaluations?.add(Evaluations.fromJson(v));
      });
    }
  }
  num? _total;
  num? _page;
  num? _limit;
  List<Evaluations>? _evaluations;
Data copyWith({  num? total,
  num? page,
  num? limit,
  List<Evaluations>? evaluations,
}) => Data(  total: total ?? _total,
  page: page ?? _page,
  limit: limit ?? _limit,
  evaluations: evaluations ?? _evaluations,
);
  num? get total => _total;
  num? get page => _page;
  num? get limit => _limit;
  List<Evaluations>? get evaluations => _evaluations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['page'] = _page;
    map['limit'] = _limit;
    if (_evaluations != null) {
      map['evaluations'] = _evaluations?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "7a165402-0c93-4e8a-bc01-4d8379c77f17"
/// studentSlug : "student-neha-mehta-AD0000051"
/// studentName : "Neha  Mehta"
/// studentCode : "AD0000051"
/// rollNumber : "0051"
/// profileLink : "https://api.unicorn-class.com/uploads/1773989112717-974908832.jpg"
/// classSlug : "class-nurseryb-iv-C00025"
/// className : "NurseryB IV"
/// teacherName : "Pooja Patel"
/// evaluationDate : "2026-04-06"
/// status : "SUBMITTED"
/// teacherNote : "Good progress"
/// adminNote : ""
/// submittedAt : "2026-04-06T05:00:18.150Z"
/// approvedAt : ""
/// answerCount : 40
/// reportPdfLink : "https://api.unicorn-class.com/uploads/evaluation-pdfs/7a165402-0c93-4e8a-bc01-4d8379c77f17-en.pdf"

class Evaluations {
  Evaluations({
      String? id, 
      String? studentSlug, 
      String? studentName, 
      String? studentCode, 
      String? rollNumber, 
      String? profileLink, 
      String? classSlug, 
      String? className, 
      String? teacherName, 
      String? evaluationDate, 
      String? status, 
      String? teacherNote, 
      String? adminNote, 
      String? submittedAt, 
      String? approvedAt, 
      num? answerCount, 
      String? reportPdfLink,}){
    _id = id;
    _studentSlug = studentSlug;
    _studentName = studentName;
    _studentCode = studentCode;
    _rollNumber = rollNumber;
    _profileLink = profileLink;
    _classSlug = classSlug;
    _className = className;
    _teacherName = teacherName;
    _evaluationDate = evaluationDate;
    _status = status;
    _teacherNote = teacherNote;
    _adminNote = adminNote;
    _submittedAt = submittedAt;
    _approvedAt = approvedAt;
    _answerCount = answerCount;
    _reportPdfLink = reportPdfLink;
}

  Evaluations.fromJson(dynamic json) {
    _id = json['id'];
    _studentSlug = json['studentSlug'];
    _studentName = json['studentName'];
    _studentCode = json['studentCode'];
    _rollNumber = json['rollNumber'];
    _profileLink = json['profileLink'];
    _classSlug = json['classSlug'];
    _className = json['className'];
    _teacherName = json['teacherName'];
    _evaluationDate = json['evaluationDate'];
    _status = json['status'];
    _teacherNote = json['teacherNote'];
    _adminNote = json['adminNote'];
    _submittedAt = json['submittedAt'];
    _approvedAt = json['approvedAt'];
    _answerCount = json['answerCount'];
    _reportPdfLink = json['reportPdfLink'];
  }
  String? _id;
  String? _studentSlug;
  String? _studentName;
  String? _studentCode;
  String? _rollNumber;
  String? _profileLink;
  String? _classSlug;
  String? _className;
  String? _teacherName;
  String? _evaluationDate;
  String? _status;
  String? _teacherNote;
  String? _adminNote;
  String? _submittedAt;
  String? _approvedAt;
  num? _answerCount;
  String? _reportPdfLink;
Evaluations copyWith({  String? id,
  String? studentSlug,
  String? studentName,
  String? studentCode,
  String? rollNumber,
  String? profileLink,
  String? classSlug,
  String? className,
  String? teacherName,
  String? evaluationDate,
  String? status,
  String? teacherNote,
  String? adminNote,
  String? submittedAt,
  String? approvedAt,
  num? answerCount,
  String? reportPdfLink,
}) => Evaluations(  id: id ?? _id,
  studentSlug: studentSlug ?? _studentSlug,
  studentName: studentName ?? _studentName,
  studentCode: studentCode ?? _studentCode,
  rollNumber: rollNumber ?? _rollNumber,
  profileLink: profileLink ?? _profileLink,
  classSlug: classSlug ?? _classSlug,
  className: className ?? _className,
  teacherName: teacherName ?? _teacherName,
  evaluationDate: evaluationDate ?? _evaluationDate,
  status: status ?? _status,
  teacherNote: teacherNote ?? _teacherNote,
  adminNote: adminNote ?? _adminNote,
  submittedAt: submittedAt ?? _submittedAt,
  approvedAt: approvedAt ?? _approvedAt,
  answerCount: answerCount ?? _answerCount,
  reportPdfLink: reportPdfLink ?? _reportPdfLink,
);
  String? get id => _id;
  String? get studentSlug => _studentSlug;
  String? get studentName => _studentName;
  String? get studentCode => _studentCode;
  String? get rollNumber => _rollNumber;
  String? get profileLink => _profileLink;
  String? get classSlug => _classSlug;
  String? get className => _className;
  String? get teacherName => _teacherName;
  String? get evaluationDate => _evaluationDate;
  String? get status => _status;
  String? get teacherNote => _teacherNote;
  String? get adminNote => _adminNote;
  String? get submittedAt => _submittedAt;
  String? get approvedAt => _approvedAt;
  num? get answerCount => _answerCount;
  String? get reportPdfLink => _reportPdfLink;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['studentSlug'] = _studentSlug;
    map['studentName'] = _studentName;
    map['studentCode'] = _studentCode;
    map['rollNumber'] = _rollNumber;
    map['profileLink'] = _profileLink;
    map['classSlug'] = _classSlug;
    map['className'] = _className;
    map['teacherName'] = _teacherName;
    map['evaluationDate'] = _evaluationDate;
    map['status'] = _status;
    map['teacherNote'] = _teacherNote;
    map['adminNote'] = _adminNote;
    map['submittedAt'] = _submittedAt;
    map['approvedAt'] = _approvedAt;
    map['answerCount'] = _answerCount;
    map['reportPdfLink'] = _reportPdfLink;
    return map;
  }

}