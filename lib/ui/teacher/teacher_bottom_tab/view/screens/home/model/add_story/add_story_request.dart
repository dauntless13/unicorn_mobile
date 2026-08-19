class AddStoryRequest {
  String? lang;
  String? mediaUrl;
  String? mediaType; // IMAGE, VIDEO, PDF
  String? text;
  String? ctaText;

  AddStoryRequest({
    this.lang,
    this.mediaUrl,
    this.mediaType,
    this.text,
    this.ctaText,
  });

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "lang": lang,
      "mediaUrl": mediaUrl,
      "mediaType": mediaType,
      "text": text,
      "ctaText": ctaText,
    };
  }
}