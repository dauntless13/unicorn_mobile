class NapListRequest {
  String? lang;
  String? date;

  NapListRequest({
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