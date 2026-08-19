class MoodUpdateRequest {
  final List<String> mood;
  final String lang;
  final String date;

  MoodUpdateRequest({
    required this.mood,
    this.lang = "EN",
    this.date = "date",
  });

  Map<String, dynamic> toJson() {
    return {
      "mood": mood,
      "lang": lang,
      "date": date,
    };
  }
}