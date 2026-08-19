class EvaluationFormsListRequest {
  final String? lang;
  final String? status;
  final String? classSlug;
  final String? studentSlug;
  final String? startDate;
  final String? endDate;
  final String? search;
  final int? page;
  final int? limit;

  EvaluationFormsListRequest({
    this.lang,
    this.status,
    this.classSlug,
    this.studentSlug,
    this.startDate,
    this.endDate,
    this.search,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "lang": lang,
      "classSlug": classSlug ?? "",
      "studentSlug": studentSlug ?? "",
      "startDate": startDate ?? "",
      "endDate": endDate ?? "",
      "search": search ?? "",
      "page": page,
      "limit": limit,
    };
    if (status != null && status!.trim().isNotEmpty) {
      map["status"] = status;
    }
    return map;
  }
}
