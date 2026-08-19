class TeacherLeaveListRequest {
  String? lang;
  String? startDate;
  String? endDate;
  String? search;
  String? status;
  String? leaveType;
  String? studentId;

  TeacherLeaveListRequest({
    this.lang,
    this.startDate,
    this.endDate,
    this.search,
    this.status,
    this.leaveType,
    this.studentId,
  });

  /// ✅ Convert Model → JSON (API Body)
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "startDate": startDate,
      "endDate": endDate,
      "search": search,
      "status": status,
      "leaveType": leaveType,
      "studentId": studentId,
    };
  }
}