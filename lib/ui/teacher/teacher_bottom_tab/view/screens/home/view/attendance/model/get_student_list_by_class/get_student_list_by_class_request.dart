class GetStudentListByClassRequest {
  String? classId;
  String? lang;
  String? date;
  String? search;

  GetStudentListByClassRequest({
    this.classId,
    this.lang,
    this.date,
    this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      "classId": classId,
      "lang": lang,
      "date": date,
      "search": search,
    };
  }
}