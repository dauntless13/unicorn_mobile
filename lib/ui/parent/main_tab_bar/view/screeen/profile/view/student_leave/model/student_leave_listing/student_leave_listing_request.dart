class StudentLeaveListingRequest {
  String? lang;
  String? startDate;
  String? endDate;
  String? search;
  String? status;
  String? studentId;
  String? leaveType;

  StudentLeaveListingRequest({
    this.lang,
    this.startDate,
    this.endDate,
    this.search,
    this.status,
    this.studentId,
    this.leaveType,
  });

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "startDate": startDate,
      "endDate": endDate,
      "search": search,
      "status": status,
      "studentId": studentId,
      "leaveType": leaveType,
    };
  }
}