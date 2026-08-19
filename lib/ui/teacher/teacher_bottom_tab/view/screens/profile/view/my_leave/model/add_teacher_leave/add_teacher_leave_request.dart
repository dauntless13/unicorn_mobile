class AddTeacherLeaveRequest {
  String? lang;
  String? type;
  String? fromDate;
  String? toDate;
  String? description;

  AddTeacherLeaveRequest({
    this.lang,
    this.type,
    this.fromDate,
    this.toDate,
    this.description,
  });

  /// ✅ Convert Model → JSON (API Request Body)
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "type": type,
      "fromDate": fromDate,
      "toDate": toDate,
      "description": description,
    };
  }
}