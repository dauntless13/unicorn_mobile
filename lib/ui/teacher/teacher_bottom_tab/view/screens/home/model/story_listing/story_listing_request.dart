class StoryListingRequest {
  String? lang;

  StoryListingRequest({this.lang});

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
    };
  }
}