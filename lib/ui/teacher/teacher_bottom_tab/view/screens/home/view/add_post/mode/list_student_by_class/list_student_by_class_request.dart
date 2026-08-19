class ListStudentByClassRequest {
  final int page;
  final int limit;
  final String lang;
  final String search;

  ListStudentByClassRequest({
    required this.page,
    required this.limit,
    required this.lang,
    required this.search,
  });

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "lang": lang,
      "search": search,
    };
  }}