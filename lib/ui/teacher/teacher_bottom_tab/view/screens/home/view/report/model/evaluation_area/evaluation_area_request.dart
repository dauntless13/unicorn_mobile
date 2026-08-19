class EvaluationAreaRequest {
  final String? lang;

  EvaluationAreaRequest({this.lang});

  Map<String, dynamic> toJson() => {
        "lang": lang,
      };
}
