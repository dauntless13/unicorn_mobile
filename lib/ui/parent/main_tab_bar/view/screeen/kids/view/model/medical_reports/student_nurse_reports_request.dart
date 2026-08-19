class StudentNurseReportsRequest {
  final String lang;
  final String search;
  final String startDate;
  final String endDate;
  final int page;
  final int limit;

  StudentNurseReportsRequest({
    required this.lang,
    required this.search,
    required this.startDate,
    required this.endDate,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        'lang': lang,
        'search': search,
        'startDate': startDate,
        'endDate': endDate,
        'page': page,
        'limit': limit,
      };
}
