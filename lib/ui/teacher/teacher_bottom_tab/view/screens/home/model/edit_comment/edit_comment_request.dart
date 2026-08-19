class EditCommentRequest {
  String? comment;
  String? lang;

  EditCommentRequest({
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