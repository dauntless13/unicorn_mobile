class AddStudentLeaveRequest {
  String? lang;
  String? studentId;
  String? studentSlug;
  String? leaveType;
  String? fromDate;
  String? toDate;
  String? description;

  AddStudentLeaveRequest({
    this.lang,
    this.studentId,
    this.studentSlug,
    this.leaveType,
    this.fromDate,
    this.toDate,
    this.description,
  });

  // Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "studentId": studentId,
      "studentSlug": studentSlug,
      "leaveType": leaveType,
      "fromDate": fromDate,
      "toDate": toDate,
      "description": description,
    };
  }
}