class AddPostRequest {
  String? lang;
  String? type;
  String? classSlug;
  String? publishType;
  List<String>? studentSlugs;
  String? mediaType;
  List<String>? mediaUrls;
  String? description;

  AddPostRequest({
    this.lang,
    this.type,
    this.classSlug,
    this.publishType,
    this.studentSlugs,
    this.mediaType,
    this.mediaUrls,
    this.description,
  });

  /// ✅ Convert Object → JSON (API Request)
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "type": type,
      "classSlug": classSlug,
      "publishType": publishType,
      "studentSlugs": studentSlugs,
      "mediaType": mediaType,
      "mediaUrls": mediaUrls,
      "description": description,
    };
  }
}