class AddNapRequest {
  String? startTime;
  String? endTime;
  String? description;
  String? date;
  String? lang;

  AddNapRequest({
    this.startTime,
    this.endTime,
    this.description,
    this.date,
    this.lang,
  });

  /// ✅ Convert Model → JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime,
      "endTime": endTime,
      "description": description,
      "date": date,
      "lang": lang,
    };
  }
}
