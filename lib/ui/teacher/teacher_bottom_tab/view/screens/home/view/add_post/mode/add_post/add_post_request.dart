class AddPostRequest {
  String? lang;
  String? type;
  String? classSlug;
  List<String>? classSlugs;
  String? publishType;
  List<String>? studentSlugs;
  String? mediaType;
  List<String>? mediaUrls;
  String? description;

  AddPostRequest({
    this.lang,
    this.type,
    this.classSlug,
    this.classSlugs,
    this.publishType,
    this.studentSlugs,
    this.mediaType,
    this.mediaUrls,
    this.description,
  });

  /// ✅ Convert Object → JSON (API Request)
  Map<String, dynamic> toJson() {
    final slug = classSlug;
    return {
      "lang": lang,
      "type": type,
      "classSlug": slug,
      "classSlugs": classSlugs ?? (slug == null ? <String>[] : [slug]),
      "publishType": publishType,
      "studentSlugs": studentSlugs,
      "mediaType": mediaType,
      "mediaUrls": mediaUrls,
      "description": description,
    };
  }
}