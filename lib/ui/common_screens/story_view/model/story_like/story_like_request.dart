class StoryLikeRequest {
  String? lang;
  bool? isLike;

  StoryLikeRequest({
    this.lang,
    this.isLike,
  });

  StoryLikeRequest.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    isLike = json['isLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lang'] = lang;
    data['isLike'] = isLike;
    return data;
  }
}