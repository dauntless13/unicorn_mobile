class AddHygieneRequest {
  String? hygiene;
  String? otherText;
  String? time;
  String? description;
  String? date;
  String? lang;

  AddHygieneRequest({
    this.hygiene,
    this.otherText,
    this.time,
    this.description,
    this.date,
    this.lang,
  });

  /// ✅ Convert Model → JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      "hygiene": hygiene,
      "otherText": otherText,
      "time": time,
      "description": description ?? "",
      "date": date,
      "lang": lang,
    };
  }
}
