class DeleteCommentRequest {
  String? comment;
  String? lang;

  DeleteCommentRequest({
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