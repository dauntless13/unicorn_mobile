class DeletePostRequest {
  final String? lang;

  DeletePostRequest({this.lang});

  Map<String, dynamic> toJson() => {
        "lang": lang,
      };
}
