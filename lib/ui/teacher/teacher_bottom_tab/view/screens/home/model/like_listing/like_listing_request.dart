class LikeListingRequest {
  String? lang;
  int? page;
  int? limit;

  LikeListingRequest({
    this.lang,
    this.page,
    this.limit,
  });

  // Convert JSON to Model
  LikeListingRequest.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    page = json['page'];
    limit = json['limit'];
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lang'] = lang;
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}
