class FeesDetailsRequest {
  final String lang; // "EN" or "AR"

  FeesDetailsRequest({
    this.lang = "EN",
  });

  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
    };
  }
}