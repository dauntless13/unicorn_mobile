class LikeRequest {
  String? lang;
  bool? isLike;

  LikeRequest({
    this.lang,
    this.isLike,
  });

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "isLike": isLike,
    };
  }
}
