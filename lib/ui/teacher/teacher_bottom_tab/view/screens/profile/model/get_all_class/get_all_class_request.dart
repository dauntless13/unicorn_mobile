class GetAllClassRequest {
  final int page;
  final int limit;
  final String lang;      // EN or AR
  final String? status;   // active, inactive or empty

  GetAllClassRequest({
    this.page = 1,
    this.limit = 10,
    required this.lang,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "lang": lang,
      "status": status ?? "",
    };
  }}