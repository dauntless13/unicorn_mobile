class PostListRequest {
  String? lang;

  PostListRequest({this.lang});

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
    };
  }
}