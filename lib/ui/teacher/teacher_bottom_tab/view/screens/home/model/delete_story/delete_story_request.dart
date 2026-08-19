class DeleteStoryRequest {
  final String? lang;

  DeleteStoryRequest({this.lang});

  Map<String, dynamic> toJson() => {
        "lang": lang,
      };
}
