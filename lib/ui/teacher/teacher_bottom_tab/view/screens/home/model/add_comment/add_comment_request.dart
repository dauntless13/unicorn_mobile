class AddCommentRequest {
  String? comment;
  String? lang;

  AddCommentRequest({
    this.comment,
    this.lang,
  });

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
      "lang": lang,
    };
  }}