class CreateChatRequest {
  String? parentSlug;
  String? lang;

  CreateChatRequest({
    this.parentSlug,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['parentSlug'] = parentSlug;
    data['lang'] = lang;
    return data;
  }
}