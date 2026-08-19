class countryRequest {
  final int page;
  final int limit;

  countryRequest({
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
    };
  }
}