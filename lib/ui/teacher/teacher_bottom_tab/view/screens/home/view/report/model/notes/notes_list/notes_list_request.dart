class NotesListRequest {
  String? lang;
  String? date;

  NotesListRequest({
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