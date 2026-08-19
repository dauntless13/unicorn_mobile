class ParentListingRequest {
  final String lang;
  final String slug;
  final String startDate;
  final String endDate;
  final String sortBy;
  final int page;
  final int limit;
  final String search;
  final String status;

  ParentListingRequest({
    required this.lang,
    this.slug = "",
    this.startDate = "",
    this.endDate = "",
    this.sortBy = "asc",
    this.page = 1,
    this.limit = 10,
    this.search = "",
    this.status = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "slug": slug,
      "startDate": startDate,
      "endDate": startDate,
      "sortBy": sortBy,
      "page": page,
      "limit": limit,
      "search": search,
      "status": status,
    };
  }
}
