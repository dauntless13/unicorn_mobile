class CityRequest {
  final int page;
  final int limit;
  final String stateId;

  CityRequest({
    required this.page,
    required this.limit,
    required this.stateId,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
      "stateId": stateId,
    };
  }}