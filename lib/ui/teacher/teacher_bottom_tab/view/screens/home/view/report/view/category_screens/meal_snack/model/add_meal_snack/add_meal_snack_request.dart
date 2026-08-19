class MealRequest {
  String? meal;
  String? portion;
  String? date;
  String? time;
  String? description;
  String? lang;

  MealRequest({
    this.meal,
    this.portion,
    this.date,
    this.time,
    this.description,
    this.lang,
  });

  /// ✅ Convert Model → JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      "meal": meal,
      "portion": portion,
      "date": date,
      "time": time,
      "description": description,
      "lang": lang,
    };
  }
}
