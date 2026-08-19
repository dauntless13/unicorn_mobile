class AddNotesRequest {
  String? lang;
  String? content;
  String? date;

  AddNotesRequest({
    this.lang,
    this.content,
    this.date,
  });

  /// Convert object → JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "content": content,
      "date": date,
    };
  }}
