class MealSnackRequest {
  String? lang;
  String? date;

  MealSnackRequest({
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