class AddActivityRequest {
  String? activity;
  String? startTime;
  String? endTime;
  String? description;
  String? date;
  String? lang;

  AddActivityRequest({
    this.activity,
    this.startTime,
    this.endTime,
    this.description,
    this.date,
    this.lang,
  });

  /// ✅ Convert Model → JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      "activity": activity,
      "startTime": startTime,
      "endTime": endTime,
      "description": description ?? "",
      "date": date,
      "lang": lang,
    };
  }
}
