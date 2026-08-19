class SaveRequest {
  bool? save;
  String? lang;

  SaveRequest({
    this.save,
    this.lang,
  });

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "save": save,
      "lang": lang,
    };
  }}