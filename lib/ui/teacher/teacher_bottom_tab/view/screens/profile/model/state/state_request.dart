class StateRequest {
  final int page;
  final int limit;
  final String countryId;

  StateRequest({
    required this.page,
    required this.limit,
    required this.countryId,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "countryId": countryId,
    };
  }
}