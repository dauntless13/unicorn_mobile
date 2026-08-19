class TeacherHolidayEventListRequest {
  String? search;
  String? type;
  String? startDate;
  String? endDate;
  String? sort;
  int? page;
  int? limit;
  String? lang;

  TeacherHolidayEventListRequest({
    this.search,
    this.type,
    this.startDate,
    this.endDate,
    this.sort,
    this.page,
    this.limit,
    this.lang,
  });

  /// ✅ Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "search": search,
      "type": type,
      "startDate": startDate,
      "endDate": endDate,
      "sort": sort,
      "page": page,
      "limit": limit,
      "lang": lang,
    };
  }
}