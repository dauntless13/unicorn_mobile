class EvaluationQuestionRequest {
  final String? lang;

  EvaluationQuestionRequest({this.lang});

  Map<String, dynamic> toJson() => {
        "lang": lang,
      };
}
