class StudentBySlugRequest {
  String? lang;

  StudentBySlugRequest({
    this.lang,
  });

  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
    };
  }
}