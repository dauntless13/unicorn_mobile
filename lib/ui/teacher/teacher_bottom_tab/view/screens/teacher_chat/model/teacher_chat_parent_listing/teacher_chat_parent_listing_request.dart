class TeacherChatParentListingRequest {
  String? search;
  String? lang;

  TeacherChatParentListingRequest({
    this.search,
    this.lang,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['search'] = search;
    data['lang'] = lang;
    return data;
  }
}