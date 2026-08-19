class MarkAttendanceRequest {
  String? classId;
  String? studentId;
  bool? checkIn;
  bool? checkOut;
  String? status;
  String? lang;
  String? checkInTime;
  String? checkOutTime;

  MarkAttendanceRequest({
    this.classId,
    this.studentId,
    this.checkIn,
    this.checkOut,
    this.status,
    this.lang,
    this.checkInTime,
    this.checkOutTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "classId": classId,
      "studentId": studentId,
      "checkIn": checkIn,
      "checkOut": checkOut,
      "status": status,
      "lang": lang,
      "checkInTime": checkInTime,
      "checkOutTime": checkOutTime,
    };
  }
}