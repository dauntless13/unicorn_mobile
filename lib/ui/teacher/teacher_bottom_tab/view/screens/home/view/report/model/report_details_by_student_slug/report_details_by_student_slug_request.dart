class ReportDetailsByStudentSlugRequest {
  String? lang;
  String? date;

  ReportDetailsByStudentSlugRequest({
    this.lang,
    this.date,
  });

  /// ✅ Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "date": date,
    };
  }
}