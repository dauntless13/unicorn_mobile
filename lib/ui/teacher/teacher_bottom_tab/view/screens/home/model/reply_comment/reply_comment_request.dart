class ReplyCommentRequest {
  String? comment;
  String? lang;

  ReplyCommentRequest({
    this.comment,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['comment'] = comment;
    data['lang'] = lang;
    return data;
  }
}