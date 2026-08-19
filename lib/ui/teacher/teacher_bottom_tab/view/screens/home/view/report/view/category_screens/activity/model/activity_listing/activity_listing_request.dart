class ActivityListingRequest {
  String? lang;
  String? date;

  ActivityListingRequest({
    this.lang,
    this.date,
  });

  /// ✅ Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "date": date,
    };
  }
}